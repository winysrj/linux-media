Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:44514 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754578AbbCIQgD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 12:36:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 12/19] em28xx: embed video_device
Date: Mon,  9 Mar 2015 17:34:06 +0100
Message-Id: <1425918853-12371-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
References: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Embed the video_device struct to simplify the error handling and in
order to (eventually) get rid of video_device_alloc/release.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 119 ++++++++++++++------------------
 drivers/media/usb/em28xx/em28xx.h       |   6 +-
 2 files changed, 54 insertions(+), 71 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 9ecf656..14eba9c 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1472,7 +1472,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 	    (EM28XX_VMUX_CABLE == INPUT(n)->type))
 		i->type = V4L2_INPUT_TYPE_TUNER;
 
-	i->std = dev->v4l2->vdev->tvnorms;
+	i->std = dev->v4l2->vdev.tvnorms;
 	/* webcams do not have the STD API */
 	if (dev->board.is_webcam)
 		i->capabilities = 0;
@@ -1730,9 +1730,9 @@ static int vidioc_querycap(struct file *file, void  *priv,
 
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS |
 		V4L2_CAP_READWRITE | V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
-	if (v4l2->vbi_dev)
+	if (video_is_registered(&v4l2->vbi_dev))
 		cap->capabilities |= V4L2_CAP_VBI_CAPTURE;
-	if (v4l2->radio_dev)
+	if (video_is_registered(&v4l2->radio_dev))
 		cap->capabilities |= V4L2_CAP_RADIO;
 	return 0;
 }
@@ -1966,20 +1966,20 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 
 	em28xx_uninit_usb_xfer(dev, EM28XX_ANALOG_MODE);
 
-	if (v4l2->radio_dev) {
+	if (video_is_registered(&v4l2->radio_dev)) {
 		em28xx_info("V4L2 device %s deregistered\n",
-			    video_device_node_name(v4l2->radio_dev));
-		video_unregister_device(v4l2->radio_dev);
+			    video_device_node_name(&v4l2->radio_dev));
+		video_unregister_device(&v4l2->radio_dev);
 	}
-	if (v4l2->vbi_dev) {
+	if (video_is_registered(&v4l2->vbi_dev)) {
 		em28xx_info("V4L2 device %s deregistered\n",
-			    video_device_node_name(v4l2->vbi_dev));
-		video_unregister_device(v4l2->vbi_dev);
+			    video_device_node_name(&v4l2->vbi_dev));
+		video_unregister_device(&v4l2->vbi_dev);
 	}
-	if (v4l2->vdev) {
+	if (video_is_registered(&v4l2->vdev)) {
 		em28xx_info("V4L2 device %s deregistered\n",
-			    video_device_node_name(v4l2->vdev));
-		video_unregister_device(v4l2->vdev);
+			    video_device_node_name(&v4l2->vdev));
+		video_unregister_device(&v4l2->vdev);
 	}
 
 	v4l2_ctrl_handler_free(&v4l2->ctrl_handler);
@@ -2127,7 +2127,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 static const struct video_device em28xx_video_template = {
 	.fops		= &em28xx_v4l_fops,
 	.ioctl_ops	= &video_ioctl_ops,
-	.release	= video_device_release,
+	.release	= video_device_release_empty,
 	.tvnorms	= V4L2_STD_ALL,
 };
 
@@ -2156,7 +2156,7 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 static struct video_device em28xx_radio_template = {
 	.fops		= &radio_fops,
 	.ioctl_ops	= &radio_ioctl_ops,
-	.release	= video_device_release,
+	.release	= video_device_release_empty,
 };
 
 /* I2C possible address to saa7115, tvp5150, msp3400, tvaudio */
@@ -2179,17 +2179,11 @@ static unsigned short msp3400_addrs[] = {
 
 /******************************** usb interface ******************************/
 
-static struct video_device
-*em28xx_vdev_init(struct em28xx *dev,
-		  const struct video_device *template,
-		  const char *type_name)
+static void em28xx_vdev_init(struct em28xx *dev,
+			     struct video_device *vfd,
+			     const struct video_device *template,
+			     const char *type_name)
 {
-	struct video_device *vfd;
-
-	vfd = video_device_alloc();
-	if (NULL == vfd)
-		return NULL;
-
 	*vfd		= *template;
 	vfd->v4l2_dev	= &dev->v4l2->v4l2_dev;
 	vfd->lock	= &dev->lock;
@@ -2200,7 +2194,6 @@ static struct video_device
 		 dev->name, type_name);
 
 	video_set_drvdata(vfd, dev);
-	return vfd;
 }
 
 static void em28xx_tuner_setup(struct em28xx *dev, unsigned short tuner_addr)
@@ -2491,38 +2484,33 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		goto unregister_dev;
 
 	/* allocate and fill video video_device struct */
-	v4l2->vdev = em28xx_vdev_init(dev, &em28xx_video_template, "video");
-	if (!v4l2->vdev) {
-		em28xx_errdev("cannot allocate video_device.\n");
-		ret = -ENODEV;
-		goto unregister_dev;
-	}
+	em28xx_vdev_init(dev, &v4l2->vdev, &em28xx_video_template, "video");
 	mutex_init(&v4l2->vb_queue_lock);
 	mutex_init(&v4l2->vb_vbi_queue_lock);
-	v4l2->vdev->queue = &v4l2->vb_vidq;
-	v4l2->vdev->queue->lock = &v4l2->vb_queue_lock;
+	v4l2->vdev.queue = &v4l2->vb_vidq;
+	v4l2->vdev.queue->lock = &v4l2->vb_queue_lock;
 
 	/* disable inapplicable ioctls */
 	if (dev->board.is_webcam) {
-		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_QUERYSTD);
-		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_G_STD);
-		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_S_STD);
+		v4l2_disable_ioctl(&v4l2->vdev, VIDIOC_QUERYSTD);
+		v4l2_disable_ioctl(&v4l2->vdev, VIDIOC_G_STD);
+		v4l2_disable_ioctl(&v4l2->vdev, VIDIOC_S_STD);
 	} else {
-		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_S_PARM);
+		v4l2_disable_ioctl(&v4l2->vdev, VIDIOC_S_PARM);
 	}
 	if (dev->tuner_type == TUNER_ABSENT) {
-		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_G_TUNER);
-		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_S_TUNER);
-		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_G_FREQUENCY);
-		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_S_FREQUENCY);
+		v4l2_disable_ioctl(&v4l2->vdev, VIDIOC_G_TUNER);
+		v4l2_disable_ioctl(&v4l2->vdev, VIDIOC_S_TUNER);
+		v4l2_disable_ioctl(&v4l2->vdev, VIDIOC_G_FREQUENCY);
+		v4l2_disable_ioctl(&v4l2->vdev, VIDIOC_S_FREQUENCY);
 	}
 	if (dev->int_audio_type == EM28XX_INT_AUDIO_NONE) {
-		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_G_AUDIO);
-		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_S_AUDIO);
+		v4l2_disable_ioctl(&v4l2->vdev, VIDIOC_G_AUDIO);
+		v4l2_disable_ioctl(&v4l2->vdev, VIDIOC_S_AUDIO);
 	}
 
 	/* register v4l2 video video_device */
-	ret = video_register_device(v4l2->vdev, VFL_TYPE_GRABBER,
+	ret = video_register_device(&v4l2->vdev, VFL_TYPE_GRABBER,
 				    video_nr[dev->devno]);
 	if (ret) {
 		em28xx_errdev("unable to register video device (error=%i).\n",
@@ -2532,27 +2520,27 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 
 	/* Allocate and fill vbi video_device struct */
 	if (em28xx_vbi_supported(dev) == 1) {
-		v4l2->vbi_dev = em28xx_vdev_init(dev, &em28xx_video_template,
-						"vbi");
+		em28xx_vdev_init(dev, &v4l2->vbi_dev, &em28xx_video_template,
+				"vbi");
 
-		v4l2->vbi_dev->queue = &v4l2->vb_vbiq;
-		v4l2->vbi_dev->queue->lock = &v4l2->vb_vbi_queue_lock;
+		v4l2->vbi_dev.queue = &v4l2->vb_vbiq;
+		v4l2->vbi_dev.queue->lock = &v4l2->vb_vbi_queue_lock;
 
 		/* disable inapplicable ioctls */
-		v4l2_disable_ioctl(v4l2->vbi_dev, VIDIOC_S_PARM);
+		v4l2_disable_ioctl(&v4l2->vbi_dev, VIDIOC_S_PARM);
 		if (dev->tuner_type == TUNER_ABSENT) {
-			v4l2_disable_ioctl(v4l2->vbi_dev, VIDIOC_G_TUNER);
-			v4l2_disable_ioctl(v4l2->vbi_dev, VIDIOC_S_TUNER);
-			v4l2_disable_ioctl(v4l2->vbi_dev, VIDIOC_G_FREQUENCY);
-			v4l2_disable_ioctl(v4l2->vbi_dev, VIDIOC_S_FREQUENCY);
+			v4l2_disable_ioctl(&v4l2->vbi_dev, VIDIOC_G_TUNER);
+			v4l2_disable_ioctl(&v4l2->vbi_dev, VIDIOC_S_TUNER);
+			v4l2_disable_ioctl(&v4l2->vbi_dev, VIDIOC_G_FREQUENCY);
+			v4l2_disable_ioctl(&v4l2->vbi_dev, VIDIOC_S_FREQUENCY);
 		}
 		if (dev->int_audio_type == EM28XX_INT_AUDIO_NONE) {
-			v4l2_disable_ioctl(v4l2->vbi_dev, VIDIOC_G_AUDIO);
-			v4l2_disable_ioctl(v4l2->vbi_dev, VIDIOC_S_AUDIO);
+			v4l2_disable_ioctl(&v4l2->vbi_dev, VIDIOC_G_AUDIO);
+			v4l2_disable_ioctl(&v4l2->vbi_dev, VIDIOC_S_AUDIO);
 		}
 
 		/* register v4l2 vbi video_device */
-		ret = video_register_device(v4l2->vbi_dev, VFL_TYPE_VBI,
+		ret = video_register_device(&v4l2->vbi_dev, VFL_TYPE_VBI,
 					    vbi_nr[dev->devno]);
 		if (ret < 0) {
 			em28xx_errdev("unable to register vbi device\n");
@@ -2561,29 +2549,24 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	}
 
 	if (em28xx_boards[dev->model].radio.type == EM28XX_RADIO) {
-		v4l2->radio_dev = em28xx_vdev_init(dev, &em28xx_radio_template,
-						   "radio");
-		if (!v4l2->radio_dev) {
-			em28xx_errdev("cannot allocate video_device.\n");
-			ret = -ENODEV;
-			goto unregister_dev;
-		}
-		ret = video_register_device(v4l2->radio_dev, VFL_TYPE_RADIO,
+		em28xx_vdev_init(dev, &v4l2->radio_dev, &em28xx_radio_template,
+				   "radio");
+		ret = video_register_device(&v4l2->radio_dev, VFL_TYPE_RADIO,
 					    radio_nr[dev->devno]);
 		if (ret < 0) {
 			em28xx_errdev("can't register radio device\n");
 			goto unregister_dev;
 		}
 		em28xx_info("Registered radio device as %s\n",
-			    video_device_node_name(v4l2->radio_dev));
+			    video_device_node_name(&v4l2->radio_dev));
 	}
 
 	em28xx_info("V4L2 video device registered as %s\n",
-		    video_device_node_name(v4l2->vdev));
+		    video_device_node_name(&v4l2->vdev));
 
-	if (v4l2->vbi_dev)
+	if (video_is_registered(&v4l2->vbi_dev))
 		em28xx_info("V4L2 VBI device registered as %s\n",
-			    video_device_node_name(v4l2->vbi_dev));
+			    video_device_node_name(&v4l2->vbi_dev));
 
 	/* Save some power by putting tuner to sleep */
 	v4l2_device_call_all(&v4l2->v4l2_dev, 0, core, s_power, 0);
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 637c959..e6559c6 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -513,9 +513,9 @@ struct em28xx_v4l2 {
 	struct v4l2_ctrl_handler ctrl_handler;
 	struct v4l2_clk *clk;
 
-	struct video_device *vdev;
-	struct video_device *vbi_dev;
-	struct video_device *radio_dev;
+	struct video_device vdev;
+	struct video_device vbi_dev;
+	struct video_device radio_dev;
 
 	/* Videobuf2 */
 	struct vb2_queue vb_vidq;
-- 
2.1.4

