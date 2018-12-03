Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:39664 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbeLCMEX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2018 07:04:23 -0500
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH] Add support to reset device controls
Date: Mon,  3 Dec 2018 12:03:31 +0000
Message-Id: <20181203120331.4097-1-kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Provide a new option '--reset-controls' which will enumerate the
available controls on a device or sub-device, and re-initialise them to
defaults.

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>

---

This 'extends' the video_list_controls() function with an extra bool
flag for 'reset' to prevent duplicating the iteration functionality.

The patch could also pass the same flag into 'video_print_control()'
rather than implementing 'video_reset_control()' which necessitates
calling query_control() a second time.

I have chosen to add the extra call, as I feel it makes the code
cleaner, and pollutes the existing implementation less. The cost of the
extra query, while a little redundant should be minimal and produces a
simple function to reset the control independently.
---
 yavta.c | 41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/yavta.c b/yavta.c
index c7986bd9e031..30022c45ed5b 100644
--- a/yavta.c
+++ b/yavta.c
@@ -1186,7 +1186,28 @@ static int video_print_control(struct device *dev, unsigned int id, bool full)
 	return query.id;
 }
 
-static void video_list_controls(struct device *dev)
+static int video_reset_control(struct device *dev, unsigned int id)
+{
+	struct v4l2_queryctrl query;
+	int ret;
+
+	ret = query_control(dev, id, &query);
+	if (ret < 0)
+		return ret;
+
+	if (query.flags & V4L2_CTRL_FLAG_DISABLED)
+		return query.id;
+
+	if (query.type == V4L2_CTRL_TYPE_CTRL_CLASS)
+		return query.id;
+
+	printf("Reset control 0x%08x to %d:\n", query.id, query.default_value);
+	set_control(dev, query.id, query.default_value);
+
+	return query.id;
+}
+
+static void video_list_controls(struct device *dev, bool reset)
 {
 	unsigned int nctrls = 0;
 	unsigned int id;
@@ -1207,6 +1228,12 @@ static void video_list_controls(struct device *dev)
 		if (ret < 0)
 			break;
 
+		if (reset) {
+			ret = video_reset_control(dev, id);
+			if (ret < 0)
+				break;
+		}
+
 		id = ret;
 		nctrls++;
 	}
@@ -1837,6 +1864,7 @@ static void usage(const char *argv0)
 	printf("    --offset			User pointer buffer offset from page start\n");
 	printf("    --premultiplied		Color components are premultiplied by alpha value\n");
 	printf("    --queue-late		Queue buffers after streamon, not before\n");
+	printf("    --reset-controls		Enumerate available controls and reset to defaults\n");
 	printf("    --requeue-last		Requeue the last buffers before streamoff\n");
 	printf("    --timestamp-source		Set timestamp source on output buffers [eof, soe]\n");
 	printf("    --skip n			Skip the first n frames\n");
@@ -1860,6 +1888,7 @@ static void usage(const char *argv0)
 #define OPT_PREMULTIPLIED	269
 #define OPT_QUEUE_LATE		270
 #define OPT_DATA_PREFIX		271
+#define OPT_RESET_CONTROLS	272
 
 static struct option opts[] = {
 	{"buffer-size", 1, 0, OPT_BUFFER_SIZE},
@@ -1888,6 +1917,7 @@ static struct option opts[] = {
 	{"queue-late", 0, 0, OPT_QUEUE_LATE},
 	{"get-control", 1, 0, 'r'},
 	{"requeue-last", 0, 0, OPT_REQUEUE_LAST},
+	{"reset-controls", 0, 0, OPT_RESET_CONTROLS},
 	{"realtime", 2, 0, 'R'},
 	{"size", 1, 0, 's'},
 	{"set-control", 1, 0, 'w'},
@@ -1915,6 +1945,7 @@ int main(int argc, char *argv[])
 	int do_enum_formats = 0, do_set_format = 0;
 	int do_enum_inputs = 0, do_set_input = 0;
 	int do_list_controls = 0, do_get_control = 0, do_set_control = 0;
+	int do_reset_controls = 0;
 	int do_sleep_forever = 0, do_requeue_last = 0;
 	int do_rt = 0, do_log_status = 0;
 	int no_query = 0, do_queue_late = 0;
@@ -2107,6 +2138,9 @@ int main(int argc, char *argv[])
 		case OPT_QUEUE_LATE:
 			do_queue_late = 1;
 			break;
+		case OPT_RESET_CONTROLS:
+			do_reset_controls = 1;
+			break;
 		case OPT_REQUEUE_LAST:
 			do_requeue_last = 1;
 			break;
@@ -2185,7 +2219,10 @@ int main(int argc, char *argv[])
 		set_control(&dev, ctrl_name, ctrl_value);
 
 	if (do_list_controls)
-		video_list_controls(&dev);
+		video_list_controls(&dev, false);
+
+	if (do_reset_controls)
+		video_list_controls(&dev, true);
 
 	if (do_enum_formats) {
 		printf("- Available formats:\n");
-- 
2.17.1
