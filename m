Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50697 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751605AbaDLNYR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Apr 2014 09:24:17 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH v3 08/11] Print timestamp type and source for dequeued buffers
Date: Sat, 12 Apr 2014 16:24:00 +0300
Message-Id: <1397309043-8322-9-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1397309043-8322-1-git-send-email-sakari.ailus@iki.fi>
References: <1397309043-8322-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c |   52 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 22 deletions(-)

diff --git a/yavta.c b/yavta.c
index a0f8570..5516675 100644
--- a/yavta.c
+++ b/yavta.c
@@ -717,6 +717,30 @@ static void video_buffer_fill_userptr(struct device *dev, struct buffer *buffer,
 		v4l2buf->m.planes[i].m.userptr = (unsigned long)buffer->mem[i];
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
@@ -764,26 +788,7 @@ static int video_alloc_buffers(struct device *dev, int nbufs,
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
 
@@ -1451,6 +1456,7 @@ static int video_do_capture(struct device *dev, unsigned int nframes,
 	last.tv_usec = start.tv_nsec / 1000;
 
 	for (i = 0; i < nframes; ++i) {
+		const char *ts_type, *ts_source;
 		/* Dequeue a buffer. */
 		memset(&buf, 0, sizeof buf);
 		memset(planes, 0, sizeof planes);
@@ -1483,10 +1489,12 @@ static int video_do_capture(struct device *dev, unsigned int nframes,
 		fps = fps ? 1000000.0 / fps : 0.0;
 
 		clock_gettime(CLOCK_MONOTONIC, &ts);
-		printf("%u (%u) [%c] %u %u bytes %ld.%06ld %ld.%06ld %.3f fps\n", i, buf.index,
+		get_ts_flags(buf.flags, &ts_type, &ts_source);
+		printf("%u (%u) [%c] %u %u bytes %ld.%06ld %ld.%06ld %.3f fps ts %s/%s\n", i, buf.index,
 			(buf.flags & V4L2_BUF_FLAG_ERROR) ? 'E' : '-',
 			buf.sequence, buf.bytesused, buf.timestamp.tv_sec,
-			buf.timestamp.tv_usec, ts.tv_sec, ts.tv_nsec/1000, fps);
+			buf.timestamp.tv_usec, ts.tv_sec, ts.tv_nsec/1000, fps,
+			ts_type, ts_source);
 
 		last = buf.timestamp;
 
-- 
1.7.10.4

