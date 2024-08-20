## AWS Kinesis Stream

Amazon Kinesis Stream is a service designed to handle real-time data streaming at massive scale. Kinesis allows you to build applications that continuously process or analyze streaming data for specialized needs.

### Design Decisions

The module has been designed with the following considerations:

1. **Flexibility**: It supports both `ON_DEMAND` and `PROVISIONED` stream modes and allows for dynamic configuration based on user specifications.
2. **Observability**: Shard level metrics are configurable and can be enabled for detailed monitoring.
3. **Security**: IAM policies are automatically created for read, write, and manage permissions.
4. **Scalability**: Shard count is dynamically managed to support scalable streaming data.
5. **User-Friendly**: Simplifies the configuration for non-developers, abstracting away the complexity of underlying Terraform scripts and AWS configurations.

### Runbook

#### Stream Not Active

If the Kinesis stream is not active, it will not process any data. You can check the status of your Kinesis stream using the AWS CLI.

```sh
aws kinesis describe-stream --stream-name <your_stream_name> --query 'StreamDescription.StreamStatus'
```

You should expect the output `ACTIVE`. If the stream status is not `ACTIVE`, you may need to investigate further or wait until it transitions to `ACTIVE`.

#### High Latency in Data Processing

High latency in data processing could be due to inadequate shard count or high incoming data rate.

To check the metrics for a stream:

```sh
aws cloudwatch get-metric-statistics --namespace AWS/Kinesis --metric-name IncomingBytes --dimensions Name=StreamName,Value=<your_stream_name> --start-time $(date -u -d '15 minutes ago' +%FT%TZ) --end-time $(date -u +%FT%TZ) --period 60 --statistics Sum
```

This command fetches the incoming bytes for the last 15 minutes. Compare it with the provisioned capacity to decide if you need more shards.

#### Data Loss or Missing Records

To debug data loss or missing records, check the retention hours and consumer application logs.

1. **Check Retention Period:**

    ```sh
    aws kinesis describe-stream --stream-name <your_stream_name> --query 'StreamDescription.RetentionPeriodHours'
    ```

    Ensure the retention period is sufficient for your data processing needs.

2. **Check Consumer Lag:**

    Most Kinesis consumers log their current sequence number. Ensure your logs indicate timely processing of incoming sequences.

#### IAM Policy Issues

If your application is facing IAM policy issues, verify the attached policies.

```sh
aws iam list-attached-role-policies --role-name <your_role_name>
```

Look for policies related to Kinesis stream access and ensure there are policies for `read`, `write`, and `manage` operations.

#### Stream Scaling Issues

If the stream needs scaling, you can update the shard count. Also, check the `StreamModeDetails` to ensure it aligns with your desired configuration.

```sh
aws kinesis update-shard-count --stream-name <your_stream_name> --target-shard-count <desired_shard_count>
```

Confirm the scaling:
```sh
aws kinesis describe-stream --stream-name <your_stream_name> --query 'StreamDescription.Shards'
```

This command lists the stream shards, allowing you to verify the new shard count.

