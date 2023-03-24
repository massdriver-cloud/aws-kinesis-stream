resource "massdriver_artifact" "stream" {
  field                = "stream"
  provider_resource_id = module.kinesis_stream.stream_arn
  name                 = "Kinesis Steram: ${local.name}"
  artifact = jsonencode(
    {
      data = {
        # This should match the aws-rds-arn.json schema file
        infrastructure = {
          arn = module.kinesis_stream.stream_arn
        }
        security = {
          iam = {
            read = {
              policy_arn = module.kinesis_stream.read_policy_arn
            }
            write = {
              policy_arn = module.kinesis_stream.write_policy_arn
            }
            manage = {
              policy_arn = module.kinesis_stream.manage_policy_arn
            }
          }
        }
      }
      specs = {
        aws = {
          region = var.stream.region
        }
      }
    }
  )
}
