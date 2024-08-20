## AWS Kinesis Stream

Amazon Kinesis Stream is a service for real-time processing of streaming data at massive scale. It can continuously capture gigabytes of data per second from hundreds of thousands of sources such as website clickstreams, database event streams, financial transactions, social media feeds, and IT logs.

### Design Decisions

- **Stream Mode**: Supports both “ON_DEMAND” and manually specified shard count modes. Users can select based on their anticipated throughput and scaling needs.
- **Shard Level Metrics**: Allows enabling detailed monitoring for shard-level metrics, offering more granular insights into the stream's performance.
- **Retention Hours**: Configurable retention period for data in the stream. Depending on how long you plan to keep your data, retention can be adjusted from 24 hours up to 7 days.

### Runbook

#### Stream Not Capturing Data

This section helps troubleshoot when the Kinesis Stream is not capturing data as expected.

1. **Check Stream Status**

   Ensure the stream is in an ACTIVE state.
   ```sh
   aws kinesis describe-stream --stream-name YOUR_STREAM_NAME --query "StreamDescription.StreamStatus"
   ```
   Expect to see: `ACTIVE`

2. **Verify Shard Count and Capacity**

   Ensure you have sufficient shards to capture the data.
   ```sh
   aws kinesis describe-stream --stream-name YOUR_STREAM_NAME --query "StreamDescription.Shards[*].ShardId"
   ```
   Verify the number of shards listed matches the expected configuration. Adjust shard count if necessary.

3. **Review CloudWatch Metrics**

   Check CloudWatch for signs of throttling or high iterator age.
   ```sh
   aws cloudwatch get-metric-statistics --namespace AWS/Kinesis --metric-name GetRecords.IteratorAgeMilliseconds --dimensions Name=StreamName,Value=YOUR_STREAM_NAME --start-time 2023-10-10T00:00:00Z --end-time 2023-10-10T01:00:00Z --period 300 --statistics Average
   ```
   Look for any anomalies in the iterator age which might indicate issues with processing records.

#### Permission Issues

This section assists when users face permission-related problems with the Kinesis Stream.

1. **Check IAM Policies**

   Ensure the IAM roles/policies attached to your Kinesis Stream have the correct permissions.
   ```sh
   aws iam get-policy --policy-arn YOUR_POLICY_ARN
   ```
   Verify that the policy includes actions like `kinesis:PutRecord`, `kinesis:GetRecords`, `kinesis:DescribeStream`, etc.

2. **Review Attached Roles**

   Check the roles assigned to your AWS services to make sure they include necessary permissions.
   ```sh
   aws iam list-attached-role-policies --role-name YOUR_ROLE_NAME
   ```
   Ensure that the policies attached match the required permissions for Kinesis operations.

#### High Latency Issues

This segment deals with high latency problems in streams.

1. **Monitor and Adjust Shards**

   Review shard-level metrics for latency and adjust shard count if necessary.
   ```sh
   aws kinesis describe-stream --stream-name YOUR_STREAM_NAME --query "StreamDescription.Shards[*].ShardId"
   ```
   Increase the shard count if high latency is detected in processing.

2. **Inspect CloudWatch Logs**

   Check for any anomalies or errors posted in CloudWatch logs.
   ```sh
   aws logs filter-log-events --log-group-name /aws/kinesis/YOUR_STREAM_NAME
   ```
   Look for event patterns that might indicate issues in data processing or delivery.

   For more detailed insights into operational adjustments and monitoring, make sure to leverage AWS’s CloudWatch service in conjunction with Kinesis.



