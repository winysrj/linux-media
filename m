Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41335 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbaLOQ2d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 11:28:33 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH v2 1/3] yavta: Implement data_offset support for multi plane buffers
Date: Mon, 15 Dec 2014 18:26:47 +0200
Message-Id: <1418660809-30548-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1418660809-30548-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1418660809-30548-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support data_offset for multi plane buffers. Also add an option to write the
data in the buffer before data offset (--buffer-prefix).

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 yavta.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/yavta.c b/yavta.c
index 77e5a41..003d6ba 100644
--- a/yavta.c
+++ b/yavta.c
@@ -80,6 +80,8 @@ struct device
 
 	void *pattern[VIDEO_MAX_PLANES];
 	unsigned int patternsize[VIDEO_MAX_PLANES];
+
+	bool write_buffer_prefix;
 };
 
 static bool video_is_mplane(struct device *dev)
@@ -1546,13 +1548,22 @@ static void video_save_image(struct device *dev, struct v4l2_buffer *buf,
 
 	for (i = 0; i < dev->num_planes; i++) {
 		unsigned int length;
+		unsigned int data_offset = 0;
 
-		if (video_is_mplane(dev))
+		if (video_is_mplane(dev)) {
 			length = buf->m.planes[i].bytesused;
-		else
+			data_offset = buf->m.planes[i].data_offset;
+		} else {
 			length = buf->bytesused;
+		}
+
+		if (!dev->write_buffer_prefix)
+			length -= data_offset;
+		else
+			data_offset = 0;
 
-		ret = write(fd, dev->buffers[buf->index].mem[i], length);
+		ret = write(fd, dev->buffers[buf->index].mem[i] + data_offset,
+			    length);
 		if (ret < 0) {
 			printf("write error: %s (%d)\n", strerror(errno), errno);
 			break;
@@ -1717,6 +1728,7 @@ static void usage(const char *argv0)
 	printf("-t, --time-per-frame num/denom	Set the time per frame (eg. 1/25 = 25 fps)\n");
 	printf("-u, --userptr			Use the user pointers streaming method\n");
 	printf("-w, --set-control 'ctrl value'	Set control 'ctrl' to 'value'\n");
+	printf("    --buffer-prefix		Write portions of buffer before data_offset\n");
 	printf("    --buffer-size		Buffer size in bytes\n");
 	printf("    --enum-formats		Enumerate formats\n");
 	printf("    --enum-inputs		Enumerate inputs\n");
@@ -1749,10 +1761,12 @@ static void usage(const char *argv0)
 #define OPT_BUFFER_SIZE		268
 #define OPT_PREMULTIPLIED	269
 #define OPT_QUEUE_LATE		270
+#define OPT_BUFFER_PREFIX	271
 
 static struct option opts[] = {
 	{"buffer-size", 1, 0, OPT_BUFFER_SIZE},
 	{"buffer-type", 1, 0, 'B'},
+	{"buffer-prefix", 1, 0, OPT_BUFFER_PREFIX},
 	{"capture", 2, 0, 'c'},
 	{"check-overrun", 0, 0, 'C'},
 	{"delay", 1, 0, 'd'},
@@ -2016,6 +2030,8 @@ int main(int argc, char *argv[])
 		case OPT_USERPTR_OFFSET:
 			userptr_offset = atoi(optarg);
 			break;
+		case OPT_BUFFER_PREFIX:
+			dev.write_buffer_prefix = true;
 		default:
 			printf("Invalid option -%c\n", c);
 			printf("Run %s -h for help.\n", argv[0]);
-- 
2.1.0.231.g7484e3b

