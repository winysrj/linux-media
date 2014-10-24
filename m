Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:33868 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755833AbaJXOYU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Oct 2014 10:24:20 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH 1/1] yavta: Add --queue-late option for delay queueing buffers over streaming start
Date: Fri, 24 Oct 2014 17:23:58 +0300
Message-Id: <1414160638-27974-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Queue buffers to the device after VIDIOC_STREAMON, not before. This does not
affect queueing behaviour otherwise.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 yavta.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/yavta.c b/yavta.c
index 20bbe29..7f9e814 100644
--- a/yavta.c
+++ b/yavta.c
@@ -1429,7 +1429,6 @@ static int video_prepare_capture(struct device *dev, int nbufs, unsigned int off
 				 const char *filename, enum buffer_fill_mode fill)
 {
 	unsigned int padding;
-	unsigned int i;
 	int ret;
 
 	/* Allocate and map buffers. */
@@ -1443,6 +1442,14 @@ static int video_prepare_capture(struct device *dev, int nbufs, unsigned int off
 			return ret;
 	}
 
+	return 0;
+}
+
+static int video_queue_all_buffers(struct device *dev, enum buffer_fill_mode fill)
+{
+	unsigned int i;
+	int ret;
+
 	/* Queue the buffers. */
 	for (i = 0; i < dev->nbufs; ++i) {
 		ret = video_queue_buffer(dev, i, fill);
@@ -1554,7 +1561,7 @@ static void video_save_image(struct device *dev, struct v4l2_buffer *buf,
 
 static int video_do_capture(struct device *dev, unsigned int nframes,
 	unsigned int skip, unsigned int delay, const char *pattern,
-	int do_requeue_last, enum buffer_fill_mode fill)
+	int do_requeue_last, int do_queue_late, enum buffer_fill_mode fill)
 {
 	struct v4l2_plane planes[VIDEO_MAX_PLANES];
 	struct v4l2_buffer buf;
@@ -1572,6 +1579,9 @@ static int video_do_capture(struct device *dev, unsigned int nframes,
 	if (ret < 0)
 		goto done;
 
+	if (do_queue_late)
+		video_queue_all_buffers(dev, fill);
+
 	size = 0;
 	clock_gettime(CLOCK_MONOTONIC, &start);
 	last.tv_sec = start.tv_sec;
@@ -1712,6 +1722,7 @@ static void usage(const char *argv0)
 	printf("    --no-query			Don't query capabilities on open\n");
 	printf("    --offset			User pointer buffer offset from page start\n");
 	printf("    --premultiplied		Color components are premultiplied by alpha value\n");
+	printf("    --queue-late		Queue buffers after streamon, not before\n");
 	printf("    --requeue-last		Requeue the last buffers before streamoff\n");
 	printf("    --timestamp-source		Set timestamp source on output buffers [eof, soe]\n");
 	printf("    --skip n			Skip the first n frames\n");
@@ -1733,6 +1744,7 @@ static void usage(const char *argv0)
 #define OPT_LOG_STATUS		267
 #define OPT_BUFFER_SIZE		268
 #define OPT_PREMULTIPLIED	269
+#define OPT_QUEUE_LATE		270
 
 static struct option opts[] = {
 	{"buffer-size", 1, 0, OPT_BUFFER_SIZE},
@@ -1757,6 +1769,7 @@ static struct option opts[] = {
 	{"pause", 0, 0, 'p'},
 	{"premultiplied", 0, 0, OPT_PREMULTIPLIED},
 	{"quality", 1, 0, 'q'},
+	{"queue-late", 0, 0, OPT_QUEUE_LATE},
 	{"get-control", 1, 0, 'r'},
 	{"requeue-last", 0, 0, OPT_REQUEUE_LAST},
 	{"realtime", 2, 0, 'R'},
@@ -1788,7 +1801,7 @@ int main(int argc, char *argv[])
 	int do_list_controls = 0, do_get_control = 0, do_set_control = 0;
 	int do_sleep_forever = 0, do_requeue_last = 0;
 	int do_rt = 0, do_log_status = 0;
-	int no_query = 0;
+	int no_query = 0, do_queue_late = 0;
 	char *endptr;
 	int c;
 
@@ -1971,6 +1984,9 @@ int main(int argc, char *argv[])
 		case OPT_PREMULTIPLIED:
 			fmt_flags |= V4L2_PIX_FMT_FLAG_PREMUL_ALPHA;
 			break;
+		case OPT_QUEUE_LATE:
+			do_queue_late = 1;
+			break;
 		case OPT_REQUEUE_LAST:
 			do_requeue_last = 1;
 			break;
@@ -2107,6 +2123,11 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
+	if (!do_queue_late && video_queue_all_buffers(&dev, fill_mode)) {
+		video_close(&dev);
+		return 1;
+	}
+
 	if (do_pause) {
 		printf("Press enter to start capture\n");
 		getchar();
@@ -2122,7 +2143,7 @@ int main(int argc, char *argv[])
 	}
 
 	if (video_do_capture(&dev, nframes, skip, delay, filename,
-			     do_requeue_last, fill_mode) < 0) {
+			     do_requeue_last, do_queue_late, fill_mode) < 0) {
 		video_close(&dev);
 		return 1;
 	}
-- 
2.1.0.231.g7484e3b

