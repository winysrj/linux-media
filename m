Return-path: <linux-media-owner@vger.kernel.org>
Received: from m50-133.163.com ([123.125.50.133]:60162 "EHLO m50-133.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbbLVPi3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2015 10:38:29 -0500
From: Geliang Tang <geliangtang@163.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Arnd Bergmann <arnd@arndb.de>
Cc: Geliang Tang <geliangtang@163.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [media] bttv-driver, usbvision-video: use to_video_device()
Date: Tue, 22 Dec 2015 23:38:04 +0800
Message-Id: <58a3ade4630fc2291762bf8abc9095f59a26a3e0.1450798632.git.geliangtang@163.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use to_video_device() instead of open-coding it.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c         |  2 +-
 drivers/media/usb/usbvision/usbvision-video.c | 27 +++++++++------------------
 2 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 9400e99..a04329a 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -186,7 +186,7 @@ MODULE_VERSION(BTTV_VERSION);
 static ssize_t show_card(struct device *cd,
 			 struct device_attribute *attr, char *buf)
 {
-	struct video_device *vfd = container_of(cd, struct video_device, dev);
+	struct video_device *vfd = to_video_device(cd);
 	struct bttv *btv = video_get_drvdata(vfd);
 	return sprintf(buf, "%d\n", btv ? btv->c.type : UNSET);
 }
diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index de9ff3b..7f5d6f1 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -162,8 +162,7 @@ MODULE_ALIAS(DRIVER_ALIAS);
 
 static inline struct usb_usbvision *cd_to_usbvision(struct device *cd)
 {
-	struct video_device *vdev =
-		container_of(cd, struct video_device, dev);
+	struct video_device *vdev = to_video_device(cd);
 	return video_get_drvdata(vdev);
 }
 
@@ -177,8 +176,7 @@ static DEVICE_ATTR(version, S_IRUGO, show_version, NULL);
 static ssize_t show_model(struct device *cd,
 			  struct device_attribute *attr, char *buf)
 {
-	struct video_device *vdev =
-		container_of(cd, struct video_device, dev);
+	struct video_device *vdev = to_video_device(cd);
 	struct usb_usbvision *usbvision = video_get_drvdata(vdev);
 	return sprintf(buf, "%s\n",
 		       usbvision_device_data[usbvision->dev_model].model_string);
@@ -188,8 +186,7 @@ static DEVICE_ATTR(model, S_IRUGO, show_model, NULL);
 static ssize_t show_hue(struct device *cd,
 			struct device_attribute *attr, char *buf)
 {
-	struct video_device *vdev =
-		container_of(cd, struct video_device, dev);
+	struct video_device *vdev = to_video_device(cd);
 	struct usb_usbvision *usbvision = video_get_drvdata(vdev);
 	struct v4l2_control ctrl;
 	ctrl.id = V4L2_CID_HUE;
@@ -203,8 +200,7 @@ static DEVICE_ATTR(hue, S_IRUGO, show_hue, NULL);
 static ssize_t show_contrast(struct device *cd,
 			     struct device_attribute *attr, char *buf)
 {
-	struct video_device *vdev =
-		container_of(cd, struct video_device, dev);
+	struct video_device *vdev = to_video_device(cd);
 	struct usb_usbvision *usbvision = video_get_drvdata(vdev);
 	struct v4l2_control ctrl;
 	ctrl.id = V4L2_CID_CONTRAST;
@@ -218,8 +214,7 @@ static DEVICE_ATTR(contrast, S_IRUGO, show_contrast, NULL);
 static ssize_t show_brightness(struct device *cd,
 			       struct device_attribute *attr, char *buf)
 {
-	struct video_device *vdev =
-		container_of(cd, struct video_device, dev);
+	struct video_device *vdev = to_video_device(cd);
 	struct usb_usbvision *usbvision = video_get_drvdata(vdev);
 	struct v4l2_control ctrl;
 	ctrl.id = V4L2_CID_BRIGHTNESS;
@@ -233,8 +228,7 @@ static DEVICE_ATTR(brightness, S_IRUGO, show_brightness, NULL);
 static ssize_t show_saturation(struct device *cd,
 			       struct device_attribute *attr, char *buf)
 {
-	struct video_device *vdev =
-		container_of(cd, struct video_device, dev);
+	struct video_device *vdev = to_video_device(cd);
 	struct usb_usbvision *usbvision = video_get_drvdata(vdev);
 	struct v4l2_control ctrl;
 	ctrl.id = V4L2_CID_SATURATION;
@@ -248,8 +242,7 @@ static DEVICE_ATTR(saturation, S_IRUGO, show_saturation, NULL);
 static ssize_t show_streaming(struct device *cd,
 			      struct device_attribute *attr, char *buf)
 {
-	struct video_device *vdev =
-		container_of(cd, struct video_device, dev);
+	struct video_device *vdev = to_video_device(cd);
 	struct usb_usbvision *usbvision = video_get_drvdata(vdev);
 	return sprintf(buf, "%s\n",
 		       YES_NO(usbvision->streaming == stream_on ? 1 : 0));
@@ -259,8 +252,7 @@ static DEVICE_ATTR(streaming, S_IRUGO, show_streaming, NULL);
 static ssize_t show_compression(struct device *cd,
 				struct device_attribute *attr, char *buf)
 {
-	struct video_device *vdev =
-		container_of(cd, struct video_device, dev);
+	struct video_device *vdev = to_video_device(cd);
 	struct usb_usbvision *usbvision = video_get_drvdata(vdev);
 	return sprintf(buf, "%s\n",
 		       YES_NO(usbvision->isoc_mode == ISOC_MODE_COMPRESS));
@@ -270,8 +262,7 @@ static DEVICE_ATTR(compression, S_IRUGO, show_compression, NULL);
 static ssize_t show_device_bridge(struct device *cd,
 				  struct device_attribute *attr, char *buf)
 {
-	struct video_device *vdev =
-		container_of(cd, struct video_device, dev);
+	struct video_device *vdev = to_video_device(cd);
 	struct usb_usbvision *usbvision = video_get_drvdata(vdev);
 	return sprintf(buf, "%d\n", usbvision->bridge_type);
 }
-- 
2.5.0


