# AWS CDK TypeScript Template

Docker内で開発ツールとAWS認証を完結させる、AWS CDK v2 / TypeScriptプロジェクトの雛形です。
AWS IAM Identity Center（AWS SSO）、Dev Container、Biome、Vitestを利用できます。

## この雛形からプロジェクトを作る

このリポジトリを別名のディレクトリへcloneして使います。

```console
git clone https://github.com/kmisu3/aws-cdk.git <project-name>
cd <project-name>
```

コピー後、最低限次を変更します。

1. `package.json` と `package-lock.json` の `name`
2. `bin/app.ts` の `AppStack` とCloudFormationスタック名
3. `lib/app-stack.ts` のファイル名、クラス名、リソース定義
4. `test/app-stack.test.ts` のテスト対象
5. `.devcontainer/devcontainer.json` の表示名

初回の依存インストールでlockfileを更新する場合は、コンテナ内で `npm install --package-lock-only` を実行します。

## 前提

ホストに必要なものは次のとおりです。

- Docker / Docker Compose
- Git
- エディタとWebブラウザ
- Makefileを使う場合は `make`

ホスト側のNode.js、npm、AWS CLI、CDK CLIは使用しません。AWSの長期アクセスキーやIAM Userも使用しません。

## 初回セットアップ

Dockerイメージをビルドし、依存をインストールします。

```console
make build
make deps
```

AWS SSOプロファイルを設定し、デバイスコードフローでログインします。既定のプロファイルは `sandbox`、リージョンは `ap-northeast-1` です。

```console
make sso-configure
make login
make whoami
```

別の値を使う場合は、コマンド実行時に指定します。

```console
make whoami AWS_PROFILE=<profile-name> AWS_REGION=<region>
```

SSO設定と短期キャッシュはDocker named volumeに保存され、ホストの `~/.aws` はマウントしません。

## 開発

```console
make shell       # コンテナの対話シェルを開く
make synth       # CloudFormationテンプレートを生成
make diff        # デプロイ済み環境との差分を確認
make lint        # lint
make format      # フォーマット
make test        # テスト
make check       # 型検査、Biome、テスト、synth
make versions    # 各ツールのバージョンを表示
```

VS Codeではこのディレクトリを開き、`Dev Containers: Reopen in Container` を実行します。作成後に `npm ci --prefer-offline` が実行されます。

## AWS環境を変更する操作

次のコマンドはAWSアカウントへ変更を加えます。必ず `make whoami` で認証先を確認してから、明示的に実行してください。

```console
make bootstrap
make deploy
```

この雛形はbootstrapやdeployを自動実行しません。

## ファイル構成

```text
bin/app.ts             CDKアプリのエントリーポイント
lib/app-stack.ts       スタック定義
test/app-stack.test.ts スタックのテスト
compose.yaml           Docker Compose設定
Dockerfile             Node.jsとAWS CLIを含む開発環境
Makefile               日常操作のショートカット
```
