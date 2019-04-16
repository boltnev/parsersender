CREATE TABLE IF NOT EXISTS frontend
(
      event_date Date,
      dt DateTime,
      remote_addr String,
      ts Float64,
      method String,
      http String,
      url String,
      status String,
      body_bytes_sent UInt32,
      referer String,
      user_agent String,
      host String,
      rt String,
      rtt Float32,
      upstrem_st String,
      upstream_addr String,
      geo_country String,
      geo_region String
)
ENGINE = MergeTree(event_date, (ts, remote_addr), 8192)
