Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50698 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754143AbaDLNYR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Apr 2014 09:24:17 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH v3 09/11] Shorten dequeued buffer info print
Date: Sat, 12 Apr 2014 16:24:01 +0300
Message-Id: <1397309043-8322-10-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1397309043-8322-1-git-send-email-sakari.ailus@iki.fi>
References: <1397309043-8322-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/yavta.c b/yavta.c
index 5516675..e81e058 100644
--- a/yavta.c
+++ b/yavta.c
@@ -721,13 +721,13 @@ static void get_ts_flags(uint32_t flags, const char **ts_type, const char **ts_s
 {
 	switch (flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) {
 	case V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN:
-		*ts_type = "unknown";
+		*ts_type = "unk";
 		break;
 	case V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC:
-		*ts_type = "monotonic";
+		*ts_type = "mono";
 		break;
 	default:
-		*ts_type = "invalid";
+		*ts_type = "inv";
 	}
 	switch (flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK) {
 	case V4L2_BUF_FLAG_TSTAMP_SRC_EOF:
@@ -737,7 +737,7 @@ static void get_ts_flags(uint32_t flags, const char **ts_type, const char **ts_s
 		*ts_source = "SoE";
 		break;
 	default:
-		*ts_source = "invalid";
+		*ts_source = "inv";
 	}
 }
 
@@ -1490,7 +1490,7 @@ static int video_do_capture(struct device *dev, unsigned int nframes,
 
 		clock_gettime(CLOCK_MONOTONIC, &ts);
 		get_ts_flags(buf.flags, &ts_type, &ts_source);
-		printf("%u (%u) [%c] %u %u bytes %ld.%06ld %ld.%06ld %.3f fps ts %s/%s\n", i, buf.index,
+		printf("%u (%u) [%c] %u %u B %ld.%06ld %ld.%06ld %.3f fps ts %s/%s\n", i, buf.index,
 			(buf.flags & V4L2_BUF_FLAG_ERROR) ? 'E' : '-',
 			buf.sequence, buf.bytesused, buf.timestamp.tv_sec,
 			buf.timestamp.tv_usec, ts.tv_sec, ts.tv_nsec/1000, fps,
-- 
1.7.10.4

