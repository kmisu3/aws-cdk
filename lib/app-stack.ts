import * as cdk from 'aws-cdk-lib';
import type { Construct } from 'constructs';

/** Add the project's AWS resources to this stack. */
export class AppStack extends cdk.Stack {
  public constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);
  }
}
