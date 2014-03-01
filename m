Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46252 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753028AbaCAQPU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Mar 2014 11:15:20 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Subject: [yavta PATCH 7/9] Print timestamp type and source for dequeued buffers
Date: Sat,  1 Mar 2014 18:18:08 +0200
Message-Id: <1393690690-5004-8-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi>
References: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c |   52 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 22 deletions(-)

diff --git a/yavta.c b/yavta.c
index 71c1477..224405d 100644
--- a/yavta.c
+++ b/yavta.c
@@ -445,6 +445,30 @@ static int video_set_framerate(struct device *dev, struct v4l2_fract *time_per_f
 	return 0;
 }
 
+static void get_ts_flags(uint32_t flags, const char **ts_type, const char **ts_source)
+{
+	switch (flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) {
+	case V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN:
+		*ts_type = "unknown";
+		break;
+	case V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC:
+		*ts_type = "monotonic";
+		break;
+	default:
+		*ts_type = "invalid";
+	}
+	switch (flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK) {
+	case V4L2_BUF_FLAG_TSTAMP_SRC_EOF:
+		*ts_source = "EoF";
+		break;
+	case V4L2_BUF_FLAG_TSTAMP_SRC_SOE:
+		*ts_source = "SoE";
+		break;
+	default:
+		*ts_source = "invalid";
+	}
+}
+
 static int video_alloc_buffers(struct device *dev, int nbufs,
 	unsigned int offset, unsigned int padding)
 {
@@ -488,26 +512,7 @@ static int video_alloc_buffers(struct device *dev, int nbufs,
 				strerror(errno), errno);
 			return ret;
 		}
-		switch (buf.flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) {
-		case V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN:
-			ts_type = "unknown";
-			break;
-		case V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC:
-			ts_type = "monotonic";
-			break;
-		default:
-			ts_type = "invalid";
-		}
-		switch (buf.flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK) {
-		case V4L2_BUF_FLAG_TSTAMP_SRC_EOF:
-			ts_source = "EoF";
-			break;
-		case V4L2_BUF_FLAG_TSTAMP_SRC_SOE:
-			ts_source = "SoE";
-			break;
-		default:
-			ts_source = "invalid";
-		}
+		get_ts_flags(buf.flags, &ts_type, &ts_source);
 		printf("length: %u offset: %u timestamp type/source: %s/%s\n",
 		       buf.length, buf.m.offset, ts_type, ts_source);
 
@@ -1131,6 +1136,7 @@ static int video_do_capture(struct device *dev, unsigned int nframes,
 	last.tv_usec = start.tv_nsec / 1000;
 
 	for (i = 0; i < nframes; ++i) {
+		const char *ts_type, *ts_source;
 		/* Dequeue a buffer. */
 		memset(&buf, 0, sizeof buf);
 		buf.type = dev->type;
@@ -1163,10 +1169,12 @@ static int video_do_capture(struct device *dev, unsigned int nframes,
 		fps = fps ? 1000000.0 / fps : 0.0;
 
 		clock_gettime(CLOCK_MONOTONIC, &ts);
-		printf("%u (%u) [%c] %u %u bytes %ld.%06ld %ld.%06ld %.3f fps\n", i, buf.index,
+		get_ts_flags(buf.flags, &ts_type, &ts_source);
+		printf("%u (%u) [%c] %u %u bytes %ld.%06ld %ld.%06ld %.3f fps tstamp type/src %s/%s\n", i, buf.index,
 			(buf.flags & V4L2_BUF_FLAG_ERROR) ? 'E' : '-',
 			buf.sequence, buf.bytesused, buf.timestamp.tv_sec,
-			buf.timestamp.tv_usec, ts.tv_sec, ts.tv_nsec/1000, fps);
+			buf.timestamp.tv_usec, ts.tv_sec, ts.tv_nsec/1000, fps,
+			ts_type, ts_source);
 
 		last = buf.timestamp;
 
-- 
1.7.10.4

