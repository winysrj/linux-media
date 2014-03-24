Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:46802 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbaCXTc7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 15:32:59 -0400
Received: by mail-ee0-f47.google.com with SMTP id b15so4808168eek.6
        for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 12:32:58 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 06/19] em28xx: move video_device structs from struct em28xx to struct v4l2
Date: Mon, 24 Mar 2014 20:33:12 +0100
Message-Id: <1395689605-2705-7-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 120 ++++++++++++++------------------
 drivers/media/usb/em28xx/em28xx.h       |   7 +-
 2 files changed, 56 insertions(+), 71 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 4fb0053..7252eef 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1447,7 +1447,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 		(EM28XX_VMUX_CABLE == INPUT(n)->type))
 		i->type = V4L2_INPUT_TYPE_TUNER;
 
-	i->std = dev->vdev->tvnorms;
+	i->std = dev->v4l2->vdev->tvnorms;
 	/* webcams do not have the STD API */
 	if (dev->board.is_webcam)
 		i->capabilities = 0;
@@ -1691,9 +1691,10 @@ static int vidioc_s_register(struct file *file, void *priv,
 static int vidioc_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *cap)
 {
-	struct video_device *vdev = video_devdata(file);
-	struct em28xx_fh      *fh  = priv;
-	struct em28xx         *dev = fh->dev;
+	struct video_device   *vdev = video_devdata(file);
+	struct em28xx_fh      *fh   = priv;
+	struct em28xx         *dev  = fh->dev;
+	struct em28xx_v4l2    *v4l2 = dev->v4l2;
 
 	strlcpy(cap->driver, "em28xx", sizeof(cap->driver));
 	strlcpy(cap->card, em28xx_boards[dev->model].name, sizeof(cap->card));
@@ -1715,9 +1716,9 @@ static int vidioc_querycap(struct file *file, void  *priv,
 
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS |
 		V4L2_CAP_READWRITE | V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
-	if (dev->vbi_dev)
+	if (v4l2->vbi_dev)
 		cap->capabilities |= V4L2_CAP_VBI_CAPTURE;
-	if (dev->radio_dev)
+	if (v4l2->radio_dev)
 		cap->capabilities |= V4L2_CAP_RADIO;
 	return 0;
 }
@@ -1955,20 +1956,20 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 
 	em28xx_uninit_usb_xfer(dev, EM28XX_ANALOG_MODE);
 
-	if (dev->radio_dev) {
+	if (v4l2->radio_dev) {
 		em28xx_info("V4L2 device %s deregistered\n",
-			    video_device_node_name(dev->radio_dev));
-		video_unregister_device(dev->radio_dev);
+			    video_device_node_name(v4l2->radio_dev));
+		video_unregister_device(v4l2->radio_dev);
 	}
-	if (dev->vbi_dev) {
+	if (v4l2->vbi_dev) {
 		em28xx_info("V4L2 device %s deregistered\n",
-			    video_device_node_name(dev->vbi_dev));
-		video_unregister_device(dev->vbi_dev);
+			    video_device_node_name(v4l2->vbi_dev));
+		video_unregister_device(v4l2->vbi_dev);
 	}
-	if (dev->vdev) {
+	if (v4l2->vdev) {
 		em28xx_info("V4L2 device %s deregistered\n",
-			    video_device_node_name(dev->vdev));
-		video_unregister_device(dev->vdev);
+			    video_device_node_name(v4l2->vdev));
+		video_unregister_device(v4l2->vdev);
 	}
 
 	v4l2_ctrl_handler_free(&v4l2->ctrl_handler);
@@ -2061,23 +2062,6 @@ exit:
 	return 0;
 }
 
-/*
- * em28xx_videodevice_release()
- * called when the last user of the video device exits and frees the memeory
- */
-static void em28xx_videodevice_release(struct video_device *vdev)
-{
-	struct em28xx *dev = video_get_drvdata(vdev);
-
-	video_device_release(vdev);
-	if (vdev == dev->vdev)
-		dev->vdev = NULL;
-	else if (vdev == dev->vbi_dev)
-		dev->vbi_dev = NULL;
-	else if (vdev == dev->radio_dev)
-		dev->radio_dev = NULL;
-}
-
 static const struct v4l2_file_operations em28xx_v4l_fops = {
 	.owner         = THIS_MODULE,
 	.open          = em28xx_v4l2_open,
@@ -2134,7 +2118,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 static const struct video_device em28xx_video_template = {
 	.fops		= &em28xx_v4l_fops,
 	.ioctl_ops	= &video_ioctl_ops,
-	.release	= em28xx_videodevice_release,
+	.release	= video_device_release,
 	.tvnorms	= V4L2_STD_ALL,
 };
 
@@ -2163,7 +2147,7 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 static struct video_device em28xx_radio_template = {
 	.fops		= &radio_fops,
 	.ioctl_ops	= &radio_ioctl_ops,
-	.release	= em28xx_videodevice_release,
+	.release	= video_device_release,
 };
 
 /* I2C possible address to saa7115, tvp5150, msp3400, tvaudio */
@@ -2493,36 +2477,36 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		goto unregister_dev;
 
 	/* allocate and fill video video_device struct */
-	dev->vdev = em28xx_vdev_init(dev, &em28xx_video_template, "video");
-	if (!dev->vdev) {
+	v4l2->vdev = em28xx_vdev_init(dev, &em28xx_video_template, "video");
+	if (!v4l2->vdev) {
 		em28xx_errdev("cannot allocate video_device.\n");
 		ret = -ENODEV;
 		goto unregister_dev;
 	}
-	dev->vdev->queue = &dev->vb_vidq;
-	dev->vdev->queue->lock = &dev->vb_queue_lock;
+	v4l2->vdev->queue = &dev->vb_vidq;
+	v4l2->vdev->queue->lock = &dev->vb_queue_lock;
 
 	/* disable inapplicable ioctls */
 	if (dev->board.is_webcam) {
-		v4l2_disable_ioctl(dev->vdev, VIDIOC_QUERYSTD);
-		v4l2_disable_ioctl(dev->vdev, VIDIOC_G_STD);
-		v4l2_disable_ioctl(dev->vdev, VIDIOC_S_STD);
+		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_QUERYSTD);
+		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_G_STD);
+		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_S_STD);
 	} else {
-		v4l2_disable_ioctl(dev->vdev, VIDIOC_S_PARM);
+		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_S_PARM);
 	}
 	if (dev->tuner_type == TUNER_ABSENT) {
-		v4l2_disable_ioctl(dev->vdev, VIDIOC_G_TUNER);
-		v4l2_disable_ioctl(dev->vdev, VIDIOC_S_TUNER);
-		v4l2_disable_ioctl(dev->vdev, VIDIOC_G_FREQUENCY);
-		v4l2_disable_ioctl(dev->vdev, VIDIOC_S_FREQUENCY);
+		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_G_TUNER);
+		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_S_TUNER);
+		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_G_FREQUENCY);
+		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_S_FREQUENCY);
 	}
 	if (!dev->audio_mode.has_audio) {
-		v4l2_disable_ioctl(dev->vdev, VIDIOC_G_AUDIO);
-		v4l2_disable_ioctl(dev->vdev, VIDIOC_S_AUDIO);
+		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_G_AUDIO);
+		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_S_AUDIO);
 	}
 
 	/* register v4l2 video video_device */
-	ret = video_register_device(dev->vdev, VFL_TYPE_GRABBER,
+	ret = video_register_device(v4l2->vdev, VFL_TYPE_GRABBER,
 				       video_nr[dev->devno]);
 	if (ret) {
 		em28xx_errdev("unable to register video device (error=%i).\n",
@@ -2532,27 +2516,27 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 
 	/* Allocate and fill vbi video_device struct */
 	if (em28xx_vbi_supported(dev) == 1) {
-		dev->vbi_dev = em28xx_vdev_init(dev, &em28xx_video_template,
+		v4l2->vbi_dev = em28xx_vdev_init(dev, &em28xx_video_template,
 						"vbi");
 
-		dev->vbi_dev->queue = &dev->vb_vbiq;
-		dev->vbi_dev->queue->lock = &dev->vb_vbi_queue_lock;
+		v4l2->vbi_dev->queue = &dev->vb_vbiq;
+		v4l2->vbi_dev->queue->lock = &dev->vb_vbi_queue_lock;
 
 		/* disable inapplicable ioctls */
-		v4l2_disable_ioctl(dev->vdev, VIDIOC_S_PARM);
+		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_S_PARM);
 		if (dev->tuner_type == TUNER_ABSENT) {
-			v4l2_disable_ioctl(dev->vbi_dev, VIDIOC_G_TUNER);
-			v4l2_disable_ioctl(dev->vbi_dev, VIDIOC_S_TUNER);
-			v4l2_disable_ioctl(dev->vbi_dev, VIDIOC_G_FREQUENCY);
-			v4l2_disable_ioctl(dev->vbi_dev, VIDIOC_S_FREQUENCY);
+			v4l2_disable_ioctl(v4l2->vbi_dev, VIDIOC_G_TUNER);
+			v4l2_disable_ioctl(v4l2->vbi_dev, VIDIOC_S_TUNER);
+			v4l2_disable_ioctl(v4l2->vbi_dev, VIDIOC_G_FREQUENCY);
+			v4l2_disable_ioctl(v4l2->vbi_dev, VIDIOC_S_FREQUENCY);
 		}
 		if (!dev->audio_mode.has_audio) {
-			v4l2_disable_ioctl(dev->vbi_dev, VIDIOC_G_AUDIO);
-			v4l2_disable_ioctl(dev->vbi_dev, VIDIOC_S_AUDIO);
+			v4l2_disable_ioctl(v4l2->vbi_dev, VIDIOC_G_AUDIO);
+			v4l2_disable_ioctl(v4l2->vbi_dev, VIDIOC_S_AUDIO);
 		}
 
 		/* register v4l2 vbi video_device */
-		ret = video_register_device(dev->vbi_dev, VFL_TYPE_VBI,
+		ret = video_register_device(v4l2->vbi_dev, VFL_TYPE_VBI,
 					    vbi_nr[dev->devno]);
 		if (ret < 0) {
 			em28xx_errdev("unable to register vbi device\n");
@@ -2561,29 +2545,29 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	}
 
 	if (em28xx_boards[dev->model].radio.type == EM28XX_RADIO) {
-		dev->radio_dev = em28xx_vdev_init(dev, &em28xx_radio_template,
-						  "radio");
-		if (!dev->radio_dev) {
+		v4l2->radio_dev = em28xx_vdev_init(dev, &em28xx_radio_template,
+						   "radio");
+		if (!v4l2->radio_dev) {
 			em28xx_errdev("cannot allocate video_device.\n");
 			ret = -ENODEV;
 			goto unregister_dev;
 		}
-		ret = video_register_device(dev->radio_dev, VFL_TYPE_RADIO,
+		ret = video_register_device(v4l2->radio_dev, VFL_TYPE_RADIO,
 					    radio_nr[dev->devno]);
 		if (ret < 0) {
 			em28xx_errdev("can't register radio device\n");
 			goto unregister_dev;
 		}
 		em28xx_info("Registered radio device as %s\n",
-			    video_device_node_name(dev->radio_dev));
+			    video_device_node_name(v4l2->radio_dev));
 	}
 
 	em28xx_info("V4L2 video device registered as %s\n",
-		    video_device_node_name(dev->vdev));
+		    video_device_node_name(v4l2->vdev));
 
-	if (dev->vbi_dev)
+	if (v4l2->vbi_dev)
 		em28xx_info("V4L2 VBI device registered as %s\n",
-			    video_device_node_name(dev->vbi_dev));
+			    video_device_node_name(v4l2->vbi_dev));
 
 	/* Save some power by putting tuner to sleep */
 	v4l2_device_call_all(&v4l2->v4l2_dev, 0, core, s_power, 0);
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index a4d26bf..88d0589 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -504,6 +504,10 @@ struct em28xx_v4l2 {
 	struct v4l2_device v4l2_dev;
 	struct v4l2_ctrl_handler ctrl_handler;
 	struct v4l2_clk *clk;
+
+	struct video_device *vdev;
+	struct video_device *vbi_dev;
+	struct video_device *radio_dev;
 };
 
 struct em28xx_audio {
@@ -614,7 +618,6 @@ struct em28xx {
 	/* video for linux */
 	int users;		/* user count for exclusive use */
 	int streaming_users;    /* Number of actively streaming users */
-	struct video_device *vdev;	/* video for linux device struct */
 	v4l2_std_id norm;	/* selected tv norm */
 	int ctl_freq;		/* selected frequency */
 	unsigned int ctl_input;	/* selected input */
@@ -645,8 +648,6 @@ struct em28xx {
 	/* locks */
 	struct mutex lock;
 	struct mutex ctrl_urb_lock;	/* protects urb_buf */
-	struct video_device *vbi_dev;
-	struct video_device *radio_dev;
 
 	/* Videobuf2 */
 	struct vb2_queue vb_vidq;
-- 
1.8.4.5

