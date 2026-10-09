# 明示されていない場合に使うAWSプロファイルとリージョン。
AWS_PROFILE ?= sandbox
AWS_REGION ?= ap-northeast-1

# すべての開発コマンドをDocker Composeのcdkサービス内で実行する。
COMPOSE = AWS_PROFILE=$(AWS_PROFILE) AWS_REGION=$(AWS_REGION) docker compose
RUN = $(COMPOSE) run --rm cdk

.PHONY: build deps shell sso-configure login whoami synth diff bootstrap deploy lint format test check versions

# CDK開発用Dockerイメージをビルドする。AWS側は変更しない。
build:
	$(COMPOSE) build

# package-lock.jsonどおりにnamed volume内のnpm依存を再インストールする。
deps:
	$(RUN) npm ci

# nodeユーザーで開発コンテナの対話シェルを開く。
shell:
	$(RUN) bash

# IAM Identity Centerのsandboxプロファイルを対話形式で設定し、named volumeへ保存する。
sso-configure:
	$(RUN) aws configure sso --profile $(AWS_PROFILE) --use-device-code --no-browser

# デバイスコードフローでIAM Identity Centerへログインする。
login:
	$(RUN) aws sso login --profile $(AWS_PROFILE) --use-device-code --no-browser

# STSから現在のAWSアカウントとロール情報を取得し、認証先を確認する。
whoami:
	$(RUN) aws sts get-caller-identity --profile $(AWS_PROFILE)

# CDKコードからCloudFormationテンプレートを生成する。AWS側は変更しない。
synth:
	$(RUN) npx cdk synth

# 生成テンプレートとAWS上のデプロイ済みStackとの差分を表示する。AWS側は変更しない。
diff:
	$(RUN) npx cdk diff --method template --profile $(AWS_PROFILE)

# CDK Toolkit用リソースをAWSアカウントに作成または更新する。
bootstrap:
	$(RUN) npx cdk bootstrap --profile $(AWS_PROFILE)

# CDK StackをAWSへデプロイし、AWSリソースを作成または更新する。
deploy:
	$(RUN) npx cdk deploy --profile $(AWS_PROFILE)

# Biomeのlintを実行する。ファイルは変更しない。
lint:
	$(RUN) npm run lint

# BiomeでTypeScriptとJSONファイルを整形する。対象ファイルを変更する。
format:
	$(RUN) npm run format

# Vitestのテストを1回実行する。
test:
	$(RUN) npm test

# 型検査、Biome、テスト、CDK synthを順番に実行する。AWS側は変更しない。
check:
	$(RUN) npm run check

# コンテナ内のAWS CLI、Node.js、CDK CLIのバージョンを表示する。
versions:
	$(RUN) aws --version
	$(RUN) node --version
	$(RUN) npx cdk --version
