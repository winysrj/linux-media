Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:34277 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932374AbbCIQhD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 12:37:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 19/19] cx231xx: embed video_device
Date: Mon,  9 Mar 2015 17:34:13 +0100
Message-Id: <1425918853-12371-20-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
References: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Embed the video_device struct to simplify the error handling and in
order to (eventually) get rid of video_device_alloc/release.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-417.c   | 33 ++++-------
 drivers/media/usb/cx231xx/cx231xx-cards.c |  6 +-
 drivers/media/usb/cx231xx/cx231xx-video.c | 94 ++++++++++---------------------
 drivers/media/usb/cx231xx/cx231xx.h       |  8 +--
 4 files changed, 49 insertions(+), 92 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 3f295b4..983ea83 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1868,13 +1868,9 @@ void cx231xx_417_unregister(struct cx231xx *dev)
 	dprintk(1, "%s()\n", __func__);
 	dprintk(3, "%s()\n", __func__);
 
-	if (dev->v4l_device) {
-		if (-1 != dev->v4l_device->minor)
-			video_unregister_device(dev->v4l_device);
-		else
-			video_device_release(dev->v4l_device);
+	if (video_is_registered(&dev->v4l_device)) {
+		video_unregister_device(&dev->v4l_device);
 		v4l2_ctrl_handler_free(&dev->mpeg_ctrl_handler.hdl);
-		dev->v4l_device = NULL;
 	}
 }
 
@@ -1911,25 +1907,21 @@ static struct cx2341x_handler_ops cx231xx_ops = {
 	.s_video_encoding = cx231xx_s_video_encoding,
 };
 
-static struct video_device *cx231xx_video_dev_alloc(
+static void cx231xx_video_dev_init(
 	struct cx231xx *dev,
 	struct usb_device *usbdev,
-	struct video_device *template,
-	char *type)
+	struct video_device *vfd,
+	const struct video_device *template,
+	const char *type)
 {
-	struct video_device *vfd;
-
 	dprintk(1, "%s()\n", __func__);
-	vfd = video_device_alloc();
-	if (NULL == vfd)
-		return NULL;
 	*vfd = *template;
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s (%s)", dev->name,
 		type, cx231xx_boards[dev->model].name);
 
 	vfd->v4l2_dev = &dev->v4l2_dev;
 	vfd->lock = &dev->lock;
-	vfd->release = video_device_release;
+	vfd->release = video_device_release_empty;
 	vfd->ctrl_handler = &dev->mpeg_ctrl_handler.hdl;
 	video_set_drvdata(vfd, dev);
 	if (dev->tuner_type == TUNER_ABSENT) {
@@ -1938,9 +1930,6 @@ static struct video_device *cx231xx_video_dev_alloc(
 		v4l2_disable_ioctl(vfd, VIDIOC_G_TUNER);
 		v4l2_disable_ioctl(vfd, VIDIOC_S_TUNER);
 	}
-
-	return vfd;
-
 }
 
 int cx231xx_417_register(struct cx231xx *dev)
@@ -1983,9 +1972,9 @@ int cx231xx_417_register(struct cx231xx *dev)
 	cx2341x_handler_set_50hz(&dev->mpeg_ctrl_handler, false);
 
 	/* Allocate and initialize V4L video device */
-	dev->v4l_device = cx231xx_video_dev_alloc(dev,
-		dev->udev, &cx231xx_mpeg_template, "mpeg");
-	err = video_register_device(dev->v4l_device,
+	cx231xx_video_dev_init(dev, dev->udev,
+			&dev->v4l_device, &cx231xx_mpeg_template, "mpeg");
+	err = video_register_device(&dev->v4l_device,
 		VFL_TYPE_GRABBER, -1);
 	if (err < 0) {
 		dprintk(3, "%s: can't register mpeg device\n", dev->name);
@@ -1994,7 +1983,7 @@ int cx231xx_417_register(struct cx231xx *dev)
 	}
 
 	dprintk(3, "%s: registered device video%d [mpeg]\n",
-	       dev->name, dev->v4l_device->num);
+	       dev->name, dev->v4l_device.num);
 
 	return 0;
 }
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 85220b9..fe00da1 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1230,9 +1230,9 @@ static void cx231xx_create_media_graph(struct cx231xx *dev)
 	if (tuner)
 		media_entity_create_link(tuner, 0, decoder, 0,
 					 MEDIA_LNK_FL_ENABLED);
-	media_entity_create_link(decoder, 1, &dev->vdev->entity, 0,
+	media_entity_create_link(decoder, 1, &dev->vdev.entity, 0,
 				 MEDIA_LNK_FL_ENABLED);
-	media_entity_create_link(decoder, 2, &dev->vbi_dev->entity, 0,
+	media_entity_create_link(decoder, 2, &dev->vbi_dev.entity, 0,
 				 MEDIA_LNK_FL_ENABLED);
 #endif
 }
@@ -1748,7 +1748,7 @@ static void cx231xx_usb_disconnect(struct usb_interface *interface)
 	if (dev->users) {
 		dev_warn(dev->dev,
 			 "device %s is open! Deregistration and memory deallocation are deferred on close.\n",
-			 video_device_node_name(dev->vdev));
+			 video_device_node_name(&dev->vdev));
 
 		/* Even having users, it is safe to remove the RC i2c driver */
 		cx231xx_ir_exit(dev);
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index acc1b68..c261e16 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1129,7 +1129,7 @@ int cx231xx_enum_input(struct file *file, void *priv,
 	    (CX231XX_VMUX_CABLE == INPUT(n)->type))
 		i->type = V4L2_INPUT_TYPE_TUNER;
 
-	i->std = dev->vdev->tvnorms;
+	i->std = dev->vdev.tvnorms;
 
 	/* If they are asking about the active input, read signal status */
 	if (n == dev->video_input) {
@@ -1524,7 +1524,7 @@ int cx231xx_querycap(struct file *file, void *priv,
 	cap->capabilities = cap->device_caps | V4L2_CAP_READWRITE |
 		V4L2_CAP_VBI_CAPTURE | V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_STREAMING | V4L2_CAP_DEVICE_CAPS;
-	if (dev->radio_dev)
+	if (video_is_registered(&dev->radio_dev))
 		cap->capabilities |= V4L2_CAP_RADIO;
 
 	return 0;
@@ -1802,34 +1802,21 @@ void cx231xx_release_analog_resources(struct cx231xx *dev)
 
 	/*FIXME: I2C IR should be disconnected */
 
-	if (dev->radio_dev) {
-		if (video_is_registered(dev->radio_dev))
-			video_unregister_device(dev->radio_dev);
-		else
-			video_device_release(dev->radio_dev);
-		dev->radio_dev = NULL;
-	}
-	if (dev->vbi_dev) {
+	if (video_is_registered(&dev->radio_dev))
+		video_unregister_device(&dev->radio_dev);
+	if (video_is_registered(&dev->vbi_dev)) {
 		dev_info(dev->dev, "V4L2 device %s deregistered\n",
-			video_device_node_name(dev->vbi_dev));
-		if (video_is_registered(dev->vbi_dev))
-			video_unregister_device(dev->vbi_dev);
-		else
-			video_device_release(dev->vbi_dev);
-		dev->vbi_dev = NULL;
+			video_device_node_name(&dev->vbi_dev));
+		video_unregister_device(&dev->vbi_dev);
 	}
-	if (dev->vdev) {
+	if (video_is_registered(&dev->vdev)) {
 		dev_info(dev->dev, "V4L2 device %s deregistered\n",
-			video_device_node_name(dev->vdev));
+			video_device_node_name(&dev->vdev));
 
 		if (dev->board.has_417)
 			cx231xx_417_unregister(dev);
 
-		if (video_is_registered(dev->vdev))
-			video_unregister_device(dev->vdev);
-		else
-			video_device_release(dev->vdev);
-		dev->vdev = NULL;
+		video_unregister_device(&dev->vdev);
 	}
 	v4l2_ctrl_handler_free(&dev->ctrl_handler);
 	v4l2_ctrl_handler_free(&dev->radio_ctrl_handler);
@@ -2086,7 +2073,7 @@ static struct video_device cx231xx_vbi_template;
 
 static const struct video_device cx231xx_video_template = {
 	.fops         = &cx231xx_v4l_fops,
-	.release      = video_device_release,
+	.release      = video_device_release_empty,
 	.ioctl_ops    = &video_ioctl_ops,
 	.tvnorms      = V4L2_STD_ALL,
 };
@@ -2122,19 +2109,14 @@ static struct video_device cx231xx_radio_template = {
 
 /******************************** usb interface ******************************/
 
-static struct video_device *cx231xx_vdev_init(struct cx231xx *dev,
-		const struct video_device
-		*template, const char *type_name)
+static void cx231xx_vdev_init(struct cx231xx *dev,
+		struct video_device *vfd,
+		const struct video_device *template,
+		const char *type_name)
 {
-	struct video_device *vfd;
-
-	vfd = video_device_alloc();
-	if (NULL == vfd)
-		return NULL;
-
 	*vfd = *template;
 	vfd->v4l2_dev = &dev->v4l2_dev;
-	vfd->release = video_device_release;
+	vfd->release = video_device_release_empty;
 	vfd->lock = &dev->lock;
 
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s", dev->name, type_name);
@@ -2146,7 +2128,6 @@ static struct video_device *cx231xx_vdev_init(struct cx231xx *dev,
 		v4l2_disable_ioctl(vfd, VIDIOC_G_TUNER);
 		v4l2_disable_ioctl(vfd, VIDIOC_S_TUNER);
 	}
-	return vfd;
 }
 
 int cx231xx_register_analog_devices(struct cx231xx *dev)
@@ -2189,20 +2170,16 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 	/* write code here...  */
 
 	/* allocate and fill video video_device struct */
-	dev->vdev = cx231xx_vdev_init(dev, &cx231xx_video_template, "video");
-	if (!dev->vdev) {
-		dev_err(dev->dev, "cannot allocate video_device.\n");
-		return -ENODEV;
-	}
+	cx231xx_vdev_init(dev, &dev->vdev, &cx231xx_video_template, "video");
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	dev->video_pad.flags = MEDIA_PAD_FL_SINK;
-	ret = media_entity_init(&dev->vdev->entity, 1, &dev->video_pad, 0);
+	ret = media_entity_init(&dev->vdev.entity, 1, &dev->video_pad, 0);
 	if (ret < 0)
 		dev_err(dev->dev, "failed to initialize video media entity!\n");
 #endif
-	dev->vdev->ctrl_handler = &dev->ctrl_handler;
+	dev->vdev.ctrl_handler = &dev->ctrl_handler;
 	/* register v4l2 video video_device */
-	ret = video_register_device(dev->vdev, VFL_TYPE_GRABBER,
+	ret = video_register_device(&dev->vdev, VFL_TYPE_GRABBER,
 				    video_nr[dev->devno]);
 	if (ret) {
 		dev_err(dev->dev,
@@ -2212,28 +2189,24 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 	}
 
 	dev_info(dev->dev, "Registered video device %s [v4l2]\n",
-		video_device_node_name(dev->vdev));
+		video_device_node_name(&dev->vdev));
 
 	/* Initialize VBI template */
 	cx231xx_vbi_template = cx231xx_video_template;
 	strcpy(cx231xx_vbi_template.name, "cx231xx-vbi");
 
 	/* Allocate and fill vbi video_device struct */
-	dev->vbi_dev = cx231xx_vdev_init(dev, &cx231xx_vbi_template, "vbi");
+	cx231xx_vdev_init(dev, &dev->vbi_dev, &cx231xx_vbi_template, "vbi");
 
-	if (!dev->vbi_dev) {
-		dev_err(dev->dev, "cannot allocate video_device.\n");
-		return -ENODEV;
-	}
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	dev->vbi_pad.flags = MEDIA_PAD_FL_SINK;
-	ret = media_entity_init(&dev->vbi_dev->entity, 1, &dev->vbi_pad, 0);
+	ret = media_entity_init(&dev->vbi_dev.entity, 1, &dev->vbi_pad, 0);
 	if (ret < 0)
 		dev_err(dev->dev, "failed to initialize vbi media entity!\n");
 #endif
-	dev->vbi_dev->ctrl_handler = &dev->ctrl_handler;
+	dev->vbi_dev.ctrl_handler = &dev->ctrl_handler;
 	/* register v4l2 vbi video_device */
-	ret = video_register_device(dev->vbi_dev, VFL_TYPE_VBI,
+	ret = video_register_device(&dev->vbi_dev, VFL_TYPE_VBI,
 				    vbi_nr[dev->devno]);
 	if (ret < 0) {
 		dev_err(dev->dev, "unable to register vbi device\n");
@@ -2241,18 +2214,13 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 	}
 
 	dev_info(dev->dev, "Registered VBI device %s\n",
-		video_device_node_name(dev->vbi_dev));
+		video_device_node_name(&dev->vbi_dev));
 
 	if (cx231xx_boards[dev->model].radio.type == CX231XX_RADIO) {
-		dev->radio_dev = cx231xx_vdev_init(dev, &cx231xx_radio_template,
-						   "radio");
-		if (!dev->radio_dev) {
-			dev_err(dev->dev,
-				"cannot allocate video_device.\n");
-			return -ENODEV;
-		}
-		dev->radio_dev->ctrl_handler = &dev->radio_ctrl_handler;
-		ret = video_register_device(dev->radio_dev, VFL_TYPE_RADIO,
+		cx231xx_vdev_init(dev, &dev->radio_dev,
+				&cx231xx_radio_template, "radio");
+		dev->radio_dev.ctrl_handler = &dev->radio_ctrl_handler;
+		ret = video_register_device(&dev->radio_dev, VFL_TYPE_RADIO,
 					    radio_nr[dev->devno]);
 		if (ret < 0) {
 			dev_err(dev->dev,
@@ -2260,7 +2228,7 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 			return ret;
 		}
 		dev_info(dev->dev, "Registered radio device as %s\n",
-			video_device_node_name(dev->radio_dev));
+			video_device_node_name(&dev->radio_dev));
 	}
 
 	return 0;
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 573b3c0..9251111 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -634,7 +634,7 @@ struct cx231xx {
 
 	/* video for linux */
 	int users;		/* user count for exclusive use */
-	struct video_device *vdev;	/* video for linux device struct */
+	struct video_device vdev;	/* video for linux device struct */
 	v4l2_std_id norm;	/* selected tv norm */
 	int ctl_freq;		/* selected frequency */
 	unsigned int ctl_ainput;	/* selected audio input */
@@ -656,8 +656,8 @@ struct cx231xx {
 	struct mutex ctrl_urb_lock;	/* protects urb_buf */
 	struct list_head inqueue, outqueue;
 	wait_queue_head_t open, wait_frame, wait_stream;
-	struct video_device *vbi_dev;
-	struct video_device *radio_dev;
+	struct video_device vbi_dev;
+	struct video_device radio_dev;
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	struct media_device *media_dev;
@@ -724,7 +724,7 @@ struct cx231xx {
 	u8 USE_ISO;
 	struct cx231xx_tvnorm      encodernorm;
 	struct cx231xx_tsport      ts1, ts2;
-	struct video_device        *v4l_device;
+	struct video_device        v4l_device;
 	atomic_t                   v4l_reader_count;
 	u32                        freq;
 	unsigned int               input;
-- 
2.1.4

