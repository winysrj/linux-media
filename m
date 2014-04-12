Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50687 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754066AbaDLNYQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Apr 2014 09:24:16 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH v3 03/11] Separate querying capabilities and determining buffer queue type
Date: Sat, 12 Apr 2014 16:23:55 +0300
Message-Id: <1397309043-8322-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1397309043-8322-1-git-send-email-sakari.ailus@iki.fi>
References: <1397309043-8322-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c |   74 ++++++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 42 insertions(+), 32 deletions(-)

diff --git a/yavta.c b/yavta.c
index d8f0c59..02a7403 100644
--- a/yavta.c
+++ b/yavta.c
@@ -239,12 +239,8 @@ static void video_init(struct device *dev)
 	dev->type = (enum v4l2_buf_type)-1;
 }
 
-static int video_open(struct device *dev, const char *devname, int no_query)
+static int video_open(struct device *dev, const char *devname)
 {
-	struct v4l2_capability cap;
-	unsigned int capabilities;
-	int ret;
-
 	dev->fd = open(devname, O_RDWR);
 	if (dev->fd < 0) {
 		printf("Error opening device %s: %s (%d).\n", devname,
@@ -254,35 +250,22 @@ static int video_open(struct device *dev, const char *devname, int no_query)
 
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
-		dev->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
-	else if (capabilities & V4L2_CAP_VIDEO_OUTPUT_MPLANE)
-		dev->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
-	else if (capabilities & V4L2_CAP_VIDEO_CAPTURE)
-		dev->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	else if (capabilities & V4L2_CAP_VIDEO_OUTPUT)
-		dev->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
-	else {
-		printf("Error opening device %s: neither video capture "
-			"nor video output supported.\n", devname);
-		close(dev->fd);
-		return -EINVAL;
-	}
-
 	printf("Device `%s' on `%s' is a video %s (%s mplanes) device.\n",
 		cap.card, cap.bus_info,
 		video_is_capture(dev) ? "capture" : "output",
@@ -290,6 +273,24 @@ static int video_open(struct device *dev, const char *devname, int no_query)
 	return 0;
 }
 
+static int cap_get_buf_type(unsigned int capabilities)
+{
+	if (capabilities & V4L2_CAP_VIDEO_CAPTURE_MPLANE) {
+		return V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	} else if (capabilities & V4L2_CAP_VIDEO_OUTPUT_MPLANE) {
+		return V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	} else if (capabilities & V4L2_CAP_VIDEO_CAPTURE) {
+		return  V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	} else if (capabilities & V4L2_CAP_VIDEO_OUTPUT) {
+		return V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	} else {
+		printf("Device supports neither capture nor output.\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static void video_close(struct device *dev)
 {
 	unsigned int i;
@@ -1577,6 +1578,8 @@ int main(int argc, char *argv[])
 
 	/* Options parsings */
 	const struct v4l2_format_info *info;
+	/* Use video capture by default if query isn't done. */
+	unsigned int capabilities = V4L2_CAP_VIDEO_CAPTURE;
 	int do_file = 0, do_capture = 0, do_pause = 0;
 	int do_set_time_per_frame = 0;
 	int do_enum_formats = 0, do_set_format = 0;
@@ -1766,15 +1769,22 @@ int main(int argc, char *argv[])
 	if (!do_file)
 		filename = NULL;
 
-	/* Open the video device. If the device type isn't recognized, set the
-	 * --no-query option to avoid querying V4L2 subdevs.
-	 */
-	ret = video_open(&dev, argv[optind], no_query);
+	ret = video_open(&dev, argv[optind]);
+	if (ret < 0)
+		return 1;
+
+	if (!no_query) {
+		ret = video_querycap(&dev, &capabilities);
+		if (ret < 0)
+			return 1;
+	}
+
+	ret = cap_get_buf_type(capabilities);
 	if (ret < 0)
 		return 1;
 
-	if (dev.type == (enum v4l2_buf_type)-1)
-		no_query = 1;
+	if (!video_is_buf_type_valid(&dev))
+		video_set_buf_type(&dev, ret);
 
 	dev.memtype = memtype;
 
-- 
1.7.10.4

