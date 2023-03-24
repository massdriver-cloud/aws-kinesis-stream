locals {
  shard_level_metrics = var.observability.enable_shard_level_metrics ? var.observability.shard_level_metrics : []
  name                = var.md_metadata.name_prefix
  shard_count         = var.capacity.stream_mode == "ON_DEMAND" ? null : var.capacity.shard_count
}

module "kinesis_stream" {
  source              = "github.com/massdriver-cloud/terraform-modules//aws/kinesis-stream?ref=4402f35"
  name                = local.name
  stream_mode         = var.capacity.stream_mode
  shard_count         = local.shard_count
  shard_level_metrics = local.shard_level_metrics
  retention_hours     = var.stream.retention_hours
}
