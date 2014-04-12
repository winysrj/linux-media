Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50694 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754308AbaDLNYR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Apr 2014 09:24:17 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH v3 05/11] Provide -B option for setting the buffer type
Date: Sat, 12 Apr 2014 16:23:57 +0300
Message-Id: <1397309043-8322-6-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1397309043-8322-1-git-send-email-sakari.ailus@iki.fi>
References: <1397309043-8322-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of guessing the buffer type, allow setting it explicitly.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c |   44 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 7 deletions(-)

diff --git a/yavta.c b/yavta.c
index 01f61d2..78ebf21 100644
--- a/yavta.c
+++ b/yavta.c
@@ -99,15 +99,34 @@ static bool video_is_output(struct device *dev)
 
 static struct {
  	enum v4l2_buf_type type;
+ 	bool supported;
 	const char *name;
+	const char *string;
 } buf_types[] = {
-	{ V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE, "Video capture mplanes", },
-	{ V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE, "Video output", },
-	{ V4L2_BUF_TYPE_VIDEO_CAPTURE, "Video capture" },
-	{ V4L2_BUF_TYPE_VIDEO_OUTPUT, "Video output mplanes" },
-	{ V4L2_BUF_TYPE_VIDEO_OVERLAY, "Video overlay" },
+	{ V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE, 1, "Video capture mplanes", "capture-mplane", },
+	{ V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE, 1, "Video output", "output-mplane", },
+	{ V4L2_BUF_TYPE_VIDEO_CAPTURE, 1, "Video capture", "capture", },
+	{ V4L2_BUF_TYPE_VIDEO_OUTPUT, 1, "Video output mplanes", "output", },
+	{ V4L2_BUF_TYPE_VIDEO_OVERLAY, 0, "Video overlay", "overlay" },
 };
 
+static int v4l2_buf_type_from_string(const char *str)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(buf_types); i++) {
+		if (!buf_types[i].supported)
+			continue;
+
+		if (strcmp(buf_types[i].string, str))
+			continue;
+
+		return buf_types[i].type;
+	}
+
+	return -1;
+}
+
 static const char *v4l2_buf_type_name(enum v4l2_buf_type type)
 {
 	unsigned int i;
@@ -1500,6 +1519,8 @@ static void usage(const char *argv0)
 {
 	printf("Usage: %s [options] device\n", argv0);
 	printf("Supported options:\n");
+	printf("-B, --buffer-type		Buffer type (\"capture\", \"output\",\n");
+	printf("                                \"capture-mplane\" or \"output-mplane\")\n");
 	printf("-c, --capture[=nframes]		Capture frames\n");
 	printf("-C, --check-overrun		Verify dequeued frames for buffer overrun\n");
 	printf("-d, --delay			Delay (in ms) before requeuing buffers\n");
@@ -1541,6 +1562,7 @@ static void usage(const char *argv0)
 #define OPT_STRIDE		263
 
 static struct option opts[] = {
+	{"buffer-type", 1, 0, 'B'},
 	{"capture", 2, 0, 'c'},
 	{"check-overrun", 0, 0, 'C'},
 	{"delay", 1, 0, 'd'},
@@ -1618,9 +1640,17 @@ int main(int argc, char *argv[])
 	video_init(&dev);
 
 	opterr = 0;
-	while ((c = getopt_long(argc, argv, "c::Cd:f:F::hi:Iln:pq:r:R::s:t:uw:", opts, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "B:c::Cd:f:F::hi:Iln:pq:r:R::s:t:uw:", opts, NULL)) != -1) {
 
 		switch (c) {
+		case 'B':
+			ret = v4l2_buf_type_from_string(optarg);
+			if (ret == -1) {
+				printf("Bad buffer type \"%s\"\n", optarg);
+				return 1;
+			}
+			video_set_buf_type(&dev, ret);
+			break;
 		case 'c':
 			do_capture = 1;
 			if (optarg)
@@ -1783,7 +1813,7 @@ int main(int argc, char *argv[])
 	if (ret < 0)
 		return 1;
 
-	if (!video_is_buf_type_valid(&dev))
+	if (!video_has_valid_buf_type(&dev))
 		video_set_buf_type(&dev, ret);
 
 	dev.memtype = memtype;
-- 
1.7.10.4

