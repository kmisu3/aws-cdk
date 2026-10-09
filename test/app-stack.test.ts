import * as cdk from 'aws-cdk-lib';
import { Template } from 'aws-cdk-lib/assertions';
import { describe, expect, it } from 'vitest';
import { AppStack } from '../lib/app-stack';

describe('AppStack', () => {
  it('can synthesize an empty stack', () => {
    const app = new cdk.App();
    cdk.Validations.of(app).acknowledge({
      id: 'CloudFormation-Validate::F0001',
      reason: 'This test intentionally verifies the initial empty stack.',
    });
    const stack = new AppStack(app, 'TestStack');
    const template = Template.fromStack(stack).toJSON();

    expect(template.Resources ?? {}).toEqual({});
  });
});
