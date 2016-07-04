Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:57337 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753119AbcGDIfZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 04:35:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 05/14] usbvision: use v4l2_ctrl_g_ctrl instead of the g_ctrl op.
Date: Mon,  4 Jul 2016 10:35:01 +0200
Message-Id: <1467621310-8203-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467621310-8203-1-git-send-email-hverkuil@xs4all.nl>
References: <1467621310-8203-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This op is deprecated and should not be used anymore.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/usbvision/usbvision-video.c | 40 +++++++++++----------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index ad2f3d2..c8b4eb2 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -188,12 +188,10 @@ static ssize_t show_hue(struct device *cd,
 {
 	struct video_device *vdev = to_video_device(cd);
 	struct usb_usbvision *usbvision = video_get_drvdata(vdev);
-	struct v4l2_control ctrl;
-	ctrl.id = V4L2_CID_HUE;
-	ctrl.value = 0;
-	if (usbvision->user)
-		call_all(usbvision, core, g_ctrl, &ctrl);
-	return sprintf(buf, "%d\n", ctrl.value);
+	s32 val = v4l2_ctrl_g_ctrl(v4l2_ctrl_find(&usbvision->hdl,
+						  V4L2_CID_HUE));
+
+	return sprintf(buf, "%d\n", val);
 }
 static DEVICE_ATTR(hue, S_IRUGO, show_hue, NULL);
 
@@ -202,12 +200,10 @@ static ssize_t show_contrast(struct device *cd,
 {
 	struct video_device *vdev = to_video_device(cd);
 	struct usb_usbvision *usbvision = video_get_drvdata(vdev);
-	struct v4l2_control ctrl;
-	ctrl.id = V4L2_CID_CONTRAST;
-	ctrl.value = 0;
-	if (usbvision->user)
-		call_all(usbvision, core, g_ctrl, &ctrl);
-	return sprintf(buf, "%d\n", ctrl.value);
+	s32 val = v4l2_ctrl_g_ctrl(v4l2_ctrl_find(&usbvision->hdl,
+						  V4L2_CID_CONTRAST));
+
+	return sprintf(buf, "%d\n", val);
 }
 static DEVICE_ATTR(contrast, S_IRUGO, show_contrast, NULL);
 
@@ -216,12 +212,10 @@ static ssize_t show_brightness(struct device *cd,
 {
 	struct video_device *vdev = to_video_device(cd);
 	struct usb_usbvision *usbvision = video_get_drvdata(vdev);
-	struct v4l2_control ctrl;
-	ctrl.id = V4L2_CID_BRIGHTNESS;
-	ctrl.value = 0;
-	if (usbvision->user)
-		call_all(usbvision, core, g_ctrl, &ctrl);
-	return sprintf(buf, "%d\n", ctrl.value);
+	s32 val = v4l2_ctrl_g_ctrl(v4l2_ctrl_find(&usbvision->hdl,
+						  V4L2_CID_BRIGHTNESS));
+
+	return sprintf(buf, "%d\n", val);
 }
 static DEVICE_ATTR(brightness, S_IRUGO, show_brightness, NULL);
 
@@ -230,12 +224,10 @@ static ssize_t show_saturation(struct device *cd,
 {
 	struct video_device *vdev = to_video_device(cd);
 	struct usb_usbvision *usbvision = video_get_drvdata(vdev);
-	struct v4l2_control ctrl;
-	ctrl.id = V4L2_CID_SATURATION;
-	ctrl.value = 0;
-	if (usbvision->user)
-		call_all(usbvision, core, g_ctrl, &ctrl);
-	return sprintf(buf, "%d\n", ctrl.value);
+	s32 val = v4l2_ctrl_g_ctrl(v4l2_ctrl_find(&usbvision->hdl,
+						  V4L2_CID_SATURATION));
+
+	return sprintf(buf, "%d\n", val);
 }
 static DEVICE_ATTR(saturation, S_IRUGO, show_saturation, NULL);
 
-- 
2.8.1

