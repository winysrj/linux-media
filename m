Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44109 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753845AbaDJWGt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 18:06:49 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 1/9] Provide -Q option for setting the queue type
Date: Fri, 11 Apr 2014 01:06:37 +0300
Message-Id: <1397167605-29956-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of guessing the queue type, allow setting it explicitly.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/yavta.c b/yavta.c
index 739463d..d7bccfd 100644
--- a/yavta.c
+++ b/yavta.c
@@ -1501,6 +1501,8 @@ static void usage(const char *argv0)
 	printf("-n, --nbufs n			Set the number of video buffers\n");
 	printf("-p, --pause			Pause before starting the video stream\n");
 	printf("-q, --quality n			MJPEG quality (0-100)\n");
+	printf("-Q, --queue-type		Buffer queue type (\"capture\", \"overlay\" or a\n");
+	printf("                                number)\n");
 	printf("-r, --get-control ctrl		Get control 'ctrl'\n");
 	printf("-R, --realtime=[priority]	Enable realtime RR scheduling\n");
 	printf("-s, --size WxH			Set the frame size\n");
@@ -1543,6 +1545,7 @@ static struct option opts[] = {
 	{"offset", 1, 0, OPT_USERPTR_OFFSET},
 	{"pause", 0, 0, 'p'},
 	{"quality", 1, 0, 'q'},
+	{"queue-type", 1, 0, 'Q'},
 	{"get-control", 1, 0, 'r'},
 	{"requeue-last", 0, 0, OPT_REQUEUE_LAST},
 	{"realtime", 2, 0, 'R'},
@@ -1564,7 +1567,7 @@ int main(int argc, char *argv[])
 
 	/* Options parsings */
 	const struct v4l2_format_info *info;
-	int do_file = 0, do_capture = 0, do_pause = 0;
+	int do_file = 0, do_capture = 0, do_pause = 0, queue_type = -1;
 	int do_set_time_per_frame = 0;
 	int do_enum_formats = 0, do_set_format = 0;
 	int do_enum_inputs = 0, do_set_input = 0;
@@ -1600,7 +1603,7 @@ int main(int argc, char *argv[])
 	unsigned int rt_priority = 1;
 
 	opterr = 0;
-	while ((c = getopt_long(argc, argv, "c::Cd:f:F::hi:Iln:pq:r:R::s:t:uw:", opts, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "c::Cd:f:F::hi:Iln:pq:Q:r:R::s:t:uw:", opts, NULL)) != -1) {
 
 		switch (c) {
 		case 'c':
@@ -1652,6 +1655,14 @@ int main(int argc, char *argv[])
 		case 'q':
 			quality = atoi(optarg);
 			break;
+		case 'Q':
+			if (!strcmp(optarg, "capture"))
+				queue_type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+			else if (!strcmp(optarg, "output"))
+				queue_type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+			else
+				queue_type = atoi(optarg);
+			break;
 		case 'r':
 			ctrl_name = strtol(optarg, &endptr, 0);
 			if (*endptr != 0) {
@@ -1761,6 +1772,9 @@ int main(int argc, char *argv[])
 	if (dev.type == (enum v4l2_buf_type)-1)
 		no_query = 1;
 
+	if (queue_type != -1)
+		dev.type = queue_type;
+
 	dev.memtype = memtype;
 
 	if (do_get_control) {
-- 
1.7.10.4

