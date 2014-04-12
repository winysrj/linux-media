Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50695 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754403AbaDLNYQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Apr 2014 09:24:16 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH v3 07/11] Timestamp source for output buffers
Date: Sat, 12 Apr 2014 16:23:59 +0300
Message-Id: <1397309043-8322-8-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1397309043-8322-1-git-send-email-sakari.ailus@iki.fi>
References: <1397309043-8322-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/yavta.c b/yavta.c
index 98f5e05..a0f8570 100644
--- a/yavta.c
+++ b/yavta.c
@@ -72,6 +72,7 @@ struct device
 
 	unsigned int width;
 	unsigned int height;
+	uint32_t buffer_output_flags;
 
 	unsigned char num_planes;
 	struct v4l2_plane_pix_format plane_fmt[VIDEO_MAX_PLANES];
@@ -867,6 +868,9 @@ static int video_queue_buffer(struct device *dev, int index, enum buffer_fill_mo
 	buf.type = dev->type;
 	buf.memory = dev->memtype;
 
+	if (dev->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		buf.flags = dev->buffer_output_flags;
+
 	if (video_is_mplane(dev)) {
 		buf.m.planes = planes;
 		buf.length = dev->num_planes;
@@ -1574,6 +1578,7 @@ static void usage(const char *argv0)
 	printf("    --no-query			Don't query capabilities on open\n");
 	printf("    --offset			User pointer buffer offset from page start\n");
 	printf("    --requeue-last		Requeue the last buffers before streamoff\n");
+	printf("    --timestamp-source		Set timestamp source on output buffers [eof, soe]\n");
 	printf("    --skip n			Skip the first n frames\n");
 	printf("    --sleep-forever		Sleep forever after configuring the device\n");
 	printf("    --stride value		Line stride in bytes\n");
@@ -1588,6 +1593,7 @@ static void usage(const char *argv0)
 #define OPT_REQUEUE_LAST	262
 #define OPT_STRIDE		263
 #define OPT_FD			264
+#define OPT_TSTAMP_SRC		265
 
 static struct option opts[] = {
 	{"buffer-type", 1, 0, 'B'},
@@ -1617,6 +1623,7 @@ static struct option opts[] = {
 	{"sleep-forever", 0, 0, OPT_SLEEP_FOREVER},
 	{"stride", 1, 0, OPT_STRIDE},
 	{"time-per-frame", 1, 0, 't'},
+	{"timestamp-source", 1, 0, OPT_TSTAMP_SRC},
 	{"userptr", 0, 0, 'u'},
 	{0, 0, 0, 0}
 };
@@ -1814,6 +1821,16 @@ int main(int argc, char *argv[])
 		case OPT_STRIDE:
 			stride = atoi(optarg);
 			break;
+		case OPT_TSTAMP_SRC:
+			if (!strcmp(optarg, "eof")) {
+				dev.buffer_output_flags |= V4L2_BUF_FLAG_TSTAMP_SRC_EOF;
+			} else if (!strcmp(optarg, "soe")) {
+				dev.buffer_output_flags |= V4L2_BUF_FLAG_TSTAMP_SRC_SOE;
+			} else {
+				printf("Invalid timestamp source %s\n", optarg);
+				return 1;
+			}
+			break;
 		case OPT_USERPTR_OFFSET:
 			userptr_offset = atoi(optarg);
 			break;
-- 
1.7.10.4

