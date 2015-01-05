Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:2944 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbbAEXuZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Jan 2015 18:50:25 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH 1/2] Rename buffer prefix as data prefix
Date: Tue,  6 Jan 2015 01:50:14 +0200
Message-Id: <1420501815-3684-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1420501815-3684-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1420501815-3684-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Data prefix is a much better name for this (think of data_offset, for
instance).

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 yavta.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/yavta.c b/yavta.c
index 0055c7d..3bec0be 100644
--- a/yavta.c
+++ b/yavta.c
@@ -81,7 +81,7 @@ struct device
 	void *pattern[VIDEO_MAX_PLANES];
 	unsigned int patternsize[VIDEO_MAX_PLANES];
 
-	bool write_buffer_prefix;
+	bool write_data_prefix;
 };
 
 static bool video_is_mplane(struct device *dev)
@@ -1556,7 +1556,7 @@ static void video_save_image(struct device *dev, struct v4l2_buffer *buf,
 		if (video_is_mplane(dev)) {
 			length = buf->m.planes[i].bytesused;
 
-			if (!dev->write_buffer_prefix) {
+			if (!dev->write_data_prefix) {
 				data += buf->m.planes[i].data_offset;
 				length -= buf->m.planes[i].data_offset;
 			}
@@ -1763,14 +1763,14 @@ static void usage(const char *argv0)
 #define OPT_BUFFER_SIZE		268
 #define OPT_PREMULTIPLIED	269
 #define OPT_QUEUE_LATE		270
-#define OPT_BUFFER_PREFIX	271
+#define OPT_DATA_PREFIX		271
 
 static struct option opts[] = {
 	{"buffer-size", 1, 0, OPT_BUFFER_SIZE},
 	{"buffer-type", 1, 0, 'B'},
-	{"buffer-prefix", 1, 0, OPT_BUFFER_PREFIX},
 	{"capture", 2, 0, 'c'},
 	{"check-overrun", 0, 0, 'C'},
+	{"data-prefix", 1, 0, OPT_DATA_PREFIX},
 	{"delay", 1, 0, 'd'},
 	{"enum-formats", 0, 0, OPT_ENUM_FORMATS},
 	{"enum-inputs", 0, 0, OPT_ENUM_INPUTS},
@@ -2032,8 +2032,8 @@ int main(int argc, char *argv[])
 		case OPT_USERPTR_OFFSET:
 			userptr_offset = atoi(optarg);
 			break;
-		case OPT_BUFFER_PREFIX:
-			dev.write_buffer_prefix = true;
+		case OPT_DATA_PREFIX:
+			dev.write_data_prefix = true;
 		default:
 			printf("Invalid option -%c\n", c);
 			printf("Run %s -h for help.\n", argv[0]);
-- 
2.1.0.231.g7484e3b

