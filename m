Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:61808 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab3BOSiE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 13:38:04 -0500
Received: by mail-ee0-f44.google.com with SMTP id l10so1950762eei.17
        for <linux-media@vger.kernel.org>; Fri, 15 Feb 2013 10:38:03 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 4/4] em28xx: add image quality bridge controls
Date: Fri, 15 Feb 2013 19:38:32 +0100
Message-Id: <1360953512-4133-5-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1360953512-4133-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1360953512-4133-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the image quality bridge controls contrast, brightness, saturation,
blue balance, red balance and sharpness.
These controls are enabled only if no subdevice provides them.

Tested with the following devices:
"Terratec Cinergy 200 USB"
"Hauppauge HVR-900"
"SilverCrest 1.3MPix webcam"
"Hauppauge WinTV USB2"
"Speedlink VAD Laplace webcam"


Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |    7 +---
 drivers/media/usb/em28xx/em28xx-video.c |   58 +++++++++++++++++++++++++++++--
 2 Dateien geändert, 57 Zeilen hinzugefügt(+), 8 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 0a5aa62..96de831 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3089,7 +3089,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 		return retval;
 	}
 
-	v4l2_ctrl_handler_init(hdl, 4);
+	v4l2_ctrl_handler_init(hdl, 8);
 	dev->v4l2_dev.ctrl_handler = hdl;
 
 	/* register i2c bus */
@@ -3158,11 +3158,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 		msleep(3);
 	}
 
-	v4l2_ctrl_handler_setup(&dev->ctrl_handler);
-	retval = dev->ctrl_handler.error;
-	if (retval)
-		goto fail;
-
 	retval = em28xx_register_analog_devices(dev);
 	if (retval < 0) {
 		goto fail;
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 86fd907..48b937d 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -782,17 +782,38 @@ void em28xx_ctrl_notify(struct v4l2_ctrl *ctrl, void *priv)
 static int em28xx_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct em28xx *dev = container_of(ctrl->handler, struct em28xx, ctrl_handler);
+	int ret = -EINVAL;
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
 		dev->mute = ctrl->val;
+		ret = em28xx_audio_analog_set(dev);
 		break;
 	case V4L2_CID_AUDIO_VOLUME:
 		dev->volume = ctrl->val;
+		ret = em28xx_audio_analog_set(dev);
+		break;
+	case V4L2_CID_CONTRAST:
+		ret = em28xx_write_reg(dev, EM28XX_R20_YGAIN, ctrl->val);
+		break;
+	case V4L2_CID_BRIGHTNESS:
+		ret = em28xx_write_reg(dev, EM28XX_R21_YOFFSET, ctrl->val);
+		break;
+	case V4L2_CID_SATURATION:
+		ret = em28xx_write_reg(dev, EM28XX_R22_UVGAIN, ctrl->val);
+		break;
+	case V4L2_CID_BLUE_BALANCE:
+		ret = em28xx_write_reg(dev, EM28XX_R23_UOFFSET, ctrl->val);
+		break;
+	case V4L2_CID_RED_BALANCE:
+		ret = em28xx_write_reg(dev, EM28XX_R24_VOFFSET, ctrl->val);
+		break;
+	case V4L2_CID_SHARPNESS:
+		ret = em28xx_write_reg(dev, EM28XX_R25_SHARPNESS, ctrl->val);
 		break;
 	}
 
-	return em28xx_audio_analog_set(dev);
+	return (ret < 0) ? ret : 0;
 }
 
 const struct v4l2_ctrl_ops em28xx_ctrl_ops = {
@@ -1784,9 +1805,42 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 			 (EM28XX_XCLK_AUDIO_UNMUTE | val));
 
 	em28xx_set_outfmt(dev);
-	em28xx_colorlevels_set_default(dev);
 	em28xx_compression_disable(dev);
 
+	/* Add image controls */
+	/* NOTE: at this point, the subdevices are already registered, so bridge
+	 * controls are only added/enabled when no subdevice provides them */
+	if (NULL == v4l2_ctrl_find(&dev->ctrl_handler, V4L2_CID_CONTRAST))
+		v4l2_ctrl_new_std(&dev->ctrl_handler, &em28xx_ctrl_ops,
+				  V4L2_CID_CONTRAST,
+				  0, 0x1f, 1, CONTRAST_DEFAULT);
+	if (NULL == v4l2_ctrl_find(&dev->ctrl_handler, V4L2_CID_BRIGHTNESS))
+		v4l2_ctrl_new_std(&dev->ctrl_handler, &em28xx_ctrl_ops,
+				  V4L2_CID_BRIGHTNESS,
+				  -0x80, 0x7f, 1, BRIGHTNESS_DEFAULT);
+	if (NULL == v4l2_ctrl_find(&dev->ctrl_handler, V4L2_CID_SATURATION))
+		v4l2_ctrl_new_std(&dev->ctrl_handler, &em28xx_ctrl_ops,
+				  V4L2_CID_SATURATION,
+				  0, 0x1f, 1, SATURATION_DEFAULT);
+	if (NULL == v4l2_ctrl_find(&dev->ctrl_handler, V4L2_CID_BLUE_BALANCE))
+		v4l2_ctrl_new_std(&dev->ctrl_handler, &em28xx_ctrl_ops,
+				  V4L2_CID_BLUE_BALANCE,
+				  -0x30, 0x30, 1, BLUE_BALANCE_DEFAULT);
+	if (NULL == v4l2_ctrl_find(&dev->ctrl_handler, V4L2_CID_RED_BALANCE))
+		v4l2_ctrl_new_std(&dev->ctrl_handler, &em28xx_ctrl_ops,
+				  V4L2_CID_RED_BALANCE,
+				  -0x30, 0x30, 1, RED_BALANCE_DEFAULT);
+	if (NULL == v4l2_ctrl_find(&dev->ctrl_handler, V4L2_CID_SHARPNESS))
+		v4l2_ctrl_new_std(&dev->ctrl_handler, &em28xx_ctrl_ops,
+				  V4L2_CID_SHARPNESS,
+				  0, 0x0f, 1, SHARPNESS_DEFAULT);
+
+	/* Reset image controls */
+	em28xx_colorlevels_set_default(dev);
+	v4l2_ctrl_handler_setup(&dev->ctrl_handler);
+	if (dev->ctrl_handler.error)
+		return dev->ctrl_handler.error;
+
 	/* allocate and fill video video_device struct */
 	dev->vdev = em28xx_vdev_init(dev, &em28xx_video_template, "video");
 	if (!dev->vdev) {
-- 
1.7.10.4

