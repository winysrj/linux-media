Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44112 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753878AbaDJWGu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 18:06:50 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 4/9] Separate querying capabilities and determining buffer queue type
Date: Fri, 11 Apr 2014 01:06:40 +0300
Message-Id: <1397167605-29956-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1397167605-29956-1-git-send-email-sakari.ailus@iki.fi>
References: <1397167605-29956-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c |   78 ++++++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 42 insertions(+), 36 deletions(-)

diff --git a/yavta.c b/yavta.c
index 5a35bab..12a6719 100644
--- a/yavta.c
+++ b/yavta.c
@@ -220,12 +220,8 @@ static const char *v4l2_format_name(unsigned int fourcc)
 	return name;
 }
 
-static int video_open(struct device *dev, const char *devname, int no_query)
+static int video_open(struct device *dev, const char *devname)
 {
-	struct v4l2_capability cap;
-	unsigned int capabilities;
-	int ret;
-
 	dev->fd = -1;
 	dev->memtype = V4L2_MEMORY_MMAP;
 	dev->buffers = NULL;
@@ -240,39 +236,46 @@ static int video_open(struct device *dev, const char *devname, int no_query)
 
 	printf("Device %s opened.\n", devname);
 
-	if (no_query) {
-		/* Assume capture device. */
-		dev->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		return 0;
-	}
+	return 0;
+}
+
+static int video_querycap(struct device *dev, unsigned int *capabilities)
+{
+	struct v4l2_capability cap;
+	int ret;
 
 	memset(&cap, 0, sizeof cap);
 	ret = ioctl(dev->fd, VIDIOC_QUERYCAP, &cap);
 	if (ret < 0)
 		return 0;
 
-	capabilities = cap.capabilities & V4L2_CAP_DEVICE_CAPS
+	*capabilities = cap.capabilities & V4L2_CAP_DEVICE_CAPS
 		     ? cap.device_caps : cap.capabilities;
 
-	if (capabilities & V4L2_CAP_VIDEO_CAPTURE_MPLANE)
+	printf("Device `%s' on `%s' is a video %s (%s mplanes) device.\n",
+		cap.card, cap.bus_info,
+		video_is_capture(dev) ? "capture" : "output",
+		video_is_mplane(dev) ? "with" : "without");
+	return 0;
+}
+
+static int video_set_queue_type(struct device *dev, unsigned int capabilities)
+{
+	if (dev->type != -1) {
+	} else if (capabilities & V4L2_CAP_VIDEO_CAPTURE_MPLANE) {
 		dev->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
-	else if (capabilities & V4L2_CAP_VIDEO_OUTPUT_MPLANE)
+	} else if (capabilities & V4L2_CAP_VIDEO_OUTPUT_MPLANE) {
 		dev->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
-	else if (capabilities & V4L2_CAP_VIDEO_CAPTURE)
+	} else if (capabilities & V4L2_CAP_VIDEO_CAPTURE) {
 		dev->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	else if (capabilities & V4L2_CAP_VIDEO_OUTPUT)
+	} else if (capabilities & V4L2_CAP_VIDEO_OUTPUT) {
 		dev->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
-	else {
-		printf("Error opening device %s: neither video capture "
-			"nor video output supported.\n", devname);
-		close(dev->fd);
+	} else {
+		printf("Device supports neither capture nor output.\n");
 		return -EINVAL;
 	}
+	printf("Using buffer queue type %d\n", dev->type);
 
-	printf("Device `%s' on `%s' is a video %s (%s mplanes) device.\n",
-		cap.card, cap.bus_info,
-		video_is_capture(dev) ? "capture" : "output",
-		video_is_mplane(dev) ? "with" : "without");
 	return 0;
 }
 
@@ -1561,12 +1564,14 @@ static struct option opts[] = {
 int main(int argc, char *argv[])
 {
 	struct sched_param sched;
-	struct device dev = { 0 };
+	struct device dev = { .type = -1 };
 	int ret;
 
 	/* Options parsings */
 	const struct v4l2_format_info *info;
-	int do_file = 0, do_capture = 0, do_pause = 0, queue_type = -1;
+	/* Use video capture by default if query isn't done. */
+	unsigned int capabilities = V4L2_CAP_VIDEO_CAPTURE;
+	int do_file = 0, do_capture = 0, do_pause = 0;
 	int do_set_time_per_frame = 0;
 	int do_enum_formats = 0, do_set_format = 0;
 	int do_enum_inputs = 0, do_set_input = 0;
@@ -1656,11 +1661,11 @@ int main(int argc, char *argv[])
 			break;
 		case 'Q':
 			if (!strcmp(optarg, "capture"))
-				queue_type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+				dev.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 			else if (!strcmp(optarg, "output"))
-				queue_type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+				dev.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
 			else
-				queue_type = atoi(optarg);
+				dev.type = atoi(optarg);
 			break;
 		case 'r':
 			ctrl_name = strtol(optarg, &endptr, 0);
@@ -1761,18 +1766,19 @@ int main(int argc, char *argv[])
 	if (!do_file)
 		filename = NULL;
 
-	/* Open the video device. If the device type isn't recognized, set the
-	 * --no-query option to avoid querying V4L2 subdevs.
-	 */
-	ret = video_open(&dev, argv[optind], no_query);
+	ret = video_open(&dev, argv[optind]);
 	if (ret < 0)
 		return 1;
 
-	if (dev.type == (enum v4l2_buf_type)-1)
-		no_query = 1;
+	if (!no_query) {
+		ret = video_querycap(&dev, &capabilities);
+		if (ret < 0)
+			return 1;
+	}
 
-	if (queue_type != -1)
-		dev.type = queue_type;
+	ret = video_set_queue_type(&dev, capabilities);
+	if (ret < 0)
+		return 1;
 
 	dev.memtype = memtype;
 
-- 
1.7.10.4

