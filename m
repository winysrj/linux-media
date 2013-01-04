Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f42.google.com ([209.85.212.42]:41732 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab3ADU77 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 15:59:59 -0500
Received: by mail-vb0-f42.google.com with SMTP id fa15so16998644vbb.1
        for <linux-media@vger.kernel.org>; Fri, 04 Jan 2013 12:59:59 -0800 (PST)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 06/15] em28xx: convert to the control framework.
Date: Fri,  4 Jan 2013 15:59:36 -0500
Message-Id: <1357333186-8466-7-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
References: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |   24 +++
 drivers/media/usb/em28xx/em28xx-video.c |  248 +++----------------------------
 drivers/media/usb/em28xx/em28xx.h       |    6 +
 3 files changed, 53 insertions(+), 225 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index f5cac47..4117d38 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2941,6 +2941,8 @@ void em28xx_release_resources(struct em28xx *dev)
 
 	em28xx_i2c_unregister(dev);
 
+	v4l2_ctrl_handler_free(&dev->ctrl_handler);
+
 	v4l2_device_unregister(&dev->v4l2_dev);
 
 	usb_put_dev(dev->udev);
@@ -2957,6 +2959,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 			   struct usb_interface *interface,
 			   int minor)
 {
+	struct v4l2_ctrl_handler *hdl = &dev->ctrl_handler;
 	int retval;
 	static const char *default_chip_name = "em28xx";
 	const char *chip_name = default_chip_name;
@@ -3084,6 +3087,9 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 		return retval;
 	}
 
+	v4l2_ctrl_handler_init(hdl, 4);
+	dev->v4l2_dev.ctrl_handler = hdl;
+
 	/* register i2c bus */
 	retval = em28xx_i2c_register(dev);
 	if (retval < 0) {
@@ -3109,6 +3115,18 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 			__func__, retval);
 		goto fail;
 	}
+	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
+		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
+			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
+		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
+			V4L2_CID_AUDIO_VOLUME, 0, 0x1f, 1, 0x1f);
+	} else {
+		/* install the em28xx notify callback */
+		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_MUTE),
+				em28xx_ctrl_notify, dev);
+		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_VOLUME),
+				em28xx_ctrl_notify, dev);
+	}
 
 	/* wake i2c devices */
 	em28xx_wake_i2c(dev);
@@ -3138,6 +3156,11 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 		msleep(3);
 	}
 
+	v4l2_ctrl_handler_setup(&dev->ctrl_handler);
+	retval = dev->ctrl_handler.error;
+	if (retval)
+		goto fail;
+
 	retval = em28xx_register_analog_devices(dev);
 	if (retval < 0) {
 		goto fail;
@@ -3150,6 +3173,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 
 fail:
 	em28xx_i2c_unregister(dev);
+	v4l2_ctrl_handler_free(&dev->ctrl_handler);
 
 unregister_dev:
 	v4l2_device_unregister(&dev->v4l2_dev);
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 89cbfaf..ebbf775 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -125,30 +125,6 @@ static struct em28xx_fmt format[] = {
 	},
 };
 
-/* supported controls */
-/* Common to all boards */
-static struct v4l2_queryctrl ac97_qctrl[] = {
-	{
-		.id = V4L2_CID_AUDIO_VOLUME,
-		.type = V4L2_CTRL_TYPE_INTEGER,
-		.name = "Volume",
-		.minimum = 0x0,
-		.maximum = 0x1f,
-		.step = 0x1,
-		.default_value = 0x1f,
-		.flags = V4L2_CTRL_FLAG_SLIDER,
-	}, {
-		.id = V4L2_CID_AUDIO_MUTE,
-		.type = V4L2_CTRL_TYPE_BOOLEAN,
-		.name = "Mute",
-		.minimum = 0,
-		.maximum = 1,
-		.step = 1,
-		.default_value = 1,
-		.flags = 0,
-	}
-};
-
 /* ------------------------------------------------------------------
 	DMA and thread functions
    ------------------------------------------------------------------*/
@@ -718,76 +694,48 @@ static int get_ressource(struct em28xx_fh *fh)
 	}
 }
 
-/*
- * ac97_queryctrl()
- * return the ac97 supported controls
- */
-static int ac97_queryctrl(struct v4l2_queryctrl *qc)
+void em28xx_ctrl_notify(struct v4l2_ctrl *ctrl, void *priv)
 {
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(ac97_qctrl); i++) {
-		if (qc->id && qc->id == ac97_qctrl[i].id) {
-			memcpy(qc, &(ac97_qctrl[i]), sizeof(*qc));
-			return 0;
-		}
-	}
-
-	/* Control is not ac97 related */
-	return 1;
-}
+	struct em28xx *dev = priv;
 
-/*
- * ac97_get_ctrl()
- * return the current values for ac97 mute and volume
- */
-static int ac97_get_ctrl(struct em28xx *dev, struct v4l2_control *ctrl)
-{
+	/*
+	 * In the case of non-AC97 volume controls, we still need
+	 * to do some setups at em28xx, in order to mute/unmute
+	 * and to adjust audio volume. However, the value ranges
+	 * should be checked by the corresponding V4L subdriver.
+	 */
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
-		ctrl->value = dev->mute;
-		return 0;
+		dev->mute = ctrl->val;
+		em28xx_audio_analog_set(dev);
+		break;
 	case V4L2_CID_AUDIO_VOLUME:
-		ctrl->value = dev->volume;
-		return 0;
-	default:
-		/* Control is not ac97 related */
-		return 1;
+		dev->volume = ctrl->val;
+		em28xx_audio_analog_set(dev);
+		break;
 	}
 }
 
-/*
- * ac97_set_ctrl()
- * set values for ac97 mute and volume
- */
-static int ac97_set_ctrl(struct em28xx *dev, const struct v4l2_control *ctrl)
+static int em28xx_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(ac97_qctrl); i++)
-		if (ctrl->id == ac97_qctrl[i].id)
-			goto handle;
-
-	/* Announce that hasn't handle it */
-	return 1;
-
-handle:
-	if (ctrl->value < ac97_qctrl[i].minimum ||
-	    ctrl->value > ac97_qctrl[i].maximum)
-		return -ERANGE;
+	struct em28xx *dev = container_of(ctrl->handler, struct em28xx, ctrl_handler);
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
-		dev->mute = ctrl->value;
+		dev->mute = ctrl->val;
 		break;
 	case V4L2_CID_AUDIO_VOLUME:
-		dev->volume = ctrl->value;
+		dev->volume = ctrl->val;
 		break;
 	}
 
 	return em28xx_audio_analog_set(dev);
 }
 
+const struct v4l2_ctrl_ops em28xx_ctrl_ops = {
+	.s_ctrl = em28xx_s_ctrl,
+};
+
 static int check_dev(struct em28xx *dev)
 {
 	if (dev->state & DEV_DISCONNECTED) {
@@ -1182,131 +1130,6 @@ static int vidioc_s_audio(struct file *file, void *priv, const struct v4l2_audio
 	return 0;
 }
 
-static int vidioc_queryctrl(struct file *file, void *priv,
-				struct v4l2_queryctrl *qc)
-{
-	struct em28xx_fh      *fh  = priv;
-	struct em28xx         *dev = fh->dev;
-	int                   id  = qc->id;
-	int                   rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
-
-	memset(qc, 0, sizeof(*qc));
-
-	qc->id = id;
-
-	/* enumerate AC97 controls */
-	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
-		rc = ac97_queryctrl(qc);
-		if (!rc)
-			return 0;
-	}
-
-	/* enumerate V4L2 device controls */
-	v4l2_device_call_all(&dev->v4l2_dev, 0, core, queryctrl, qc);
-
-	if (qc->type)
-		return 0;
-	else
-		return -EINVAL;
-}
-
-/*
- * FIXME: This is an indirect way to check if a control exists at a
- * subdev. Instead of that hack, maybe the better would be to change all
- * subdevs to return -ENOIOCTLCMD, if an ioctl is not supported.
- */
-static int check_subdev_ctrl(struct em28xx *dev, int id)
-{
-	struct v4l2_queryctrl qc;
-
-	memset(&qc, 0, sizeof(qc));
-	qc.id = id;
-
-	/* enumerate V4L2 device controls */
-	v4l2_device_call_all(&dev->v4l2_dev, 0, core, queryctrl, &qc);
-
-	if (qc.type)
-		return 0;
-	else
-		return -EINVAL;
-}
-
-static int vidioc_g_ctrl(struct file *file, void *priv,
-				struct v4l2_control *ctrl)
-{
-	struct em28xx_fh      *fh  = priv;
-	struct em28xx         *dev = fh->dev;
-	int                   rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
-	rc = 0;
-
-	/* Set an AC97 control */
-	if (dev->audio_mode.ac97 != EM28XX_NO_AC97)
-		rc = ac97_get_ctrl(dev, ctrl);
-	else
-		rc = 1;
-
-	/* It were not an AC97 control. Sends it to the v4l2 dev interface */
-	if (rc == 1) {
-		if (check_subdev_ctrl(dev, ctrl->id))
-			return -EINVAL;
-
-		v4l2_device_call_all(&dev->v4l2_dev, 0, core, g_ctrl, ctrl);
-		rc = 0;
-	}
-
-	return rc;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-				struct v4l2_control *ctrl)
-{
-	struct em28xx_fh      *fh  = priv;
-	struct em28xx         *dev = fh->dev;
-	int                   rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
-
-	/* Set an AC97 control */
-	if (dev->audio_mode.ac97 != EM28XX_NO_AC97)
-		rc = ac97_set_ctrl(dev, ctrl);
-	else
-		rc = 1;
-
-	/* It isn't an AC97 control. Sends it to the v4l2 dev interface */
-	if (rc == 1) {
-		rc = check_subdev_ctrl(dev, ctrl->id);
-		if (!rc)
-			v4l2_device_call_all(&dev->v4l2_dev, 0,
-					     core, s_ctrl, ctrl);
-		/*
-		 * In the case of non-AC97 volume controls, we still need
-		 * to do some setups at em28xx, in order to mute/unmute
-		 * and to adjust audio volume. However, the value ranges
-		 * should be checked by the corresponding V4L subdriver.
-		 */
-		switch (ctrl->id) {
-		case V4L2_CID_AUDIO_MUTE:
-			dev->mute = ctrl->value;
-			rc = em28xx_audio_analog_set(dev);
-			break;
-		case V4L2_CID_AUDIO_VOLUME:
-			dev->volume = ctrl->value;
-			rc = em28xx_audio_analog_set(dev);
-		}
-	}
-	return (rc < 0) ? rc : 0;
-}
-
 static int vidioc_g_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *t)
 {
@@ -1874,25 +1697,6 @@ static int radio_s_tuner(struct file *file, void *priv,
 	return 0;
 }
 
-static int radio_queryctrl(struct file *file, void *priv,
-			   struct v4l2_queryctrl *qc)
-{
-	int i;
-
-	if (qc->id <  V4L2_CID_BASE ||
-		qc->id >= V4L2_CID_LASTP1)
-		return -EINVAL;
-
-	for (i = 0; i < ARRAY_SIZE(ac97_qctrl); i++) {
-		if (qc->id && qc->id == ac97_qctrl[i].id) {
-			memcpy(qc, &(ac97_qctrl[i]), sizeof(*qc));
-			return 0;
-		}
-	}
-
-	return -EINVAL;
-}
-
 /*
  * em28xx_v4l2_open()
  * inits the device and starts isoc transfer
@@ -2218,9 +2022,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_enum_input          = vidioc_enum_input,
 	.vidioc_g_input             = vidioc_g_input,
 	.vidioc_s_input             = vidioc_s_input,
-	.vidioc_queryctrl           = vidioc_queryctrl,
-	.vidioc_g_ctrl              = vidioc_g_ctrl,
-	.vidioc_s_ctrl              = vidioc_s_ctrl,
 	.vidioc_streamon            = vidioc_streamon,
 	.vidioc_streamoff           = vidioc_streamoff,
 	.vidioc_g_tuner             = vidioc_g_tuner,
@@ -2254,9 +2055,6 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_querycap      = vidioc_querycap,
 	.vidioc_g_tuner       = radio_g_tuner,
 	.vidioc_s_tuner       = radio_s_tuner,
-	.vidioc_queryctrl     = radio_queryctrl,
-	.vidioc_g_ctrl        = vidioc_g_ctrl,
-	.vidioc_s_ctrl        = vidioc_s_ctrl,
 	.vidioc_g_frequency   = vidioc_g_frequency,
 	.vidioc_s_frequency   = vidioc_s_frequency,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -2300,7 +2098,7 @@ static struct video_device *em28xx_vdev_init(struct em28xx *dev,
 
 int em28xx_register_analog_devices(struct em28xx *dev)
 {
-      u8 val;
+	u8 val;
 	int ret;
 	unsigned int maxw;
 
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 062841e..707319e 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -33,6 +33,7 @@
 
 #include <media/videobuf-vmalloc.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
 #include <media/ir-kbd-i2c.h>
 #include <media/rc-core.h>
 #if defined(CONFIG_VIDEO_EM28XX_DVB) || defined(CONFIG_VIDEO_EM28XX_DVB_MODULE)
@@ -497,6 +498,9 @@ struct em28xx {
 	int audio_ifnum;
 
 	struct v4l2_device v4l2_dev;
+	struct v4l2_ctrl_handler ctrl_handler;
+	/* provides ac97 mute and volume overrides */
+	struct v4l2_ctrl_handler ac97_ctrl_handler;
 	struct em28xx_board board;
 
 	/* Webcam specific fields */
@@ -705,6 +709,8 @@ void em28xx_close_extension(struct em28xx *dev);
 /* Provided by em28xx-video.c */
 int em28xx_register_analog_devices(struct em28xx *dev);
 void em28xx_release_analog_resources(struct em28xx *dev);
+void em28xx_ctrl_notify(struct v4l2_ctrl *ctrl, void *priv);
+extern const struct v4l2_ctrl_ops em28xx_ctrl_ops;
 
 /* Provided by em28xx-cards.c */
 extern int em2800_variant_detect(struct usb_device *udev, int model);
-- 
1.7.9.5

