Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:39460 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932728AbbCIQgz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 12:36:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 18/19] usbvision: embed video_device
Date: Mon,  9 Mar 2015 17:34:12 +0100
Message-Id: <1425918853-12371-19-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
References: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Embed the video_device struct to simplify the error handling and in
order to (eventually) get rid of video_device_alloc/release.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/usbvision/usbvision-video.c | 70 ++++++++++-----------------
 drivers/media/usb/usbvision/usbvision.h       |  4 +-
 2 files changed, 28 insertions(+), 46 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index cd2fbf1..2579c87 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -471,7 +471,7 @@ static int vidioc_g_register(struct file *file, void *priv,
 	/* NT100x has a 8-bit register space */
 	err_code = usbvision_read_reg(usbvision, reg->reg&0xff);
 	if (err_code < 0) {
-		dev_err(&usbvision->vdev->dev,
+		dev_err(&usbvision->vdev.dev,
 			"%s: VIDIOC_DBG_G_REGISTER failed: error %d\n",
 				__func__, err_code);
 		return err_code;
@@ -490,7 +490,7 @@ static int vidioc_s_register(struct file *file, void *priv,
 	/* NT100x has a 8-bit register space */
 	err_code = usbvision_write_reg(usbvision, reg->reg & 0xff, reg->val);
 	if (err_code < 0) {
-		dev_err(&usbvision->vdev->dev,
+		dev_err(&usbvision->vdev.dev,
 			"%s: VIDIOC_DBG_S_REGISTER failed: error %d\n",
 				__func__, err_code);
 		return err_code;
@@ -1157,7 +1157,7 @@ static int usbvision_radio_open(struct file *file)
 	if (mutex_lock_interruptible(&usbvision->v4l2_lock))
 		return -ERESTARTSYS;
 	if (usbvision->user) {
-		dev_err(&usbvision->rdev->dev,
+		dev_err(&usbvision->rdev.dev,
 			"%s: Someone tried to open an already opened USBVision Radio!\n",
 				__func__);
 		err_code = -EBUSY;
@@ -1280,7 +1280,7 @@ static struct video_device usbvision_video_template = {
 	.fops		= &usbvision_fops,
 	.ioctl_ops	= &usbvision_ioctl_ops,
 	.name           = "usbvision-video",
-	.release	= video_device_release,
+	.release	= video_device_release_empty,
 	.tvnorms        = USBVISION_NORMS,
 };
 
@@ -1312,58 +1312,46 @@ static const struct v4l2_ioctl_ops usbvision_radio_ioctl_ops = {
 static struct video_device usbvision_radio_template = {
 	.fops		= &usbvision_radio_fops,
 	.name		= "usbvision-radio",
-	.release	= video_device_release,
+	.release	= video_device_release_empty,
 	.ioctl_ops	= &usbvision_radio_ioctl_ops,
 };
 
 
-static struct video_device *usbvision_vdev_init(struct usb_usbvision *usbvision,
-					struct video_device *vdev_template,
-					char *name)
+static void usbvision_vdev_init(struct usb_usbvision *usbvision,
+				struct video_device *vdev,
+				const struct video_device *vdev_template,
+				const char *name)
 {
 	struct usb_device *usb_dev = usbvision->dev;
-	struct video_device *vdev;
 
 	if (usb_dev == NULL) {
 		dev_err(&usbvision->dev->dev,
 			"%s: usbvision->dev is not set\n", __func__);
-		return NULL;
+		return;
 	}
 
-	vdev = video_device_alloc();
-	if (NULL == vdev)
-		return NULL;
 	*vdev = *vdev_template;
 	vdev->lock = &usbvision->v4l2_lock;
 	vdev->v4l2_dev = &usbvision->v4l2_dev;
 	snprintf(vdev->name, sizeof(vdev->name), "%s", name);
 	video_set_drvdata(vdev, usbvision);
-	return vdev;
 }
 
 /* unregister video4linux devices */
 static void usbvision_unregister_video(struct usb_usbvision *usbvision)
 {
 	/* Radio Device: */
-	if (usbvision->rdev) {
+	if (video_is_registered(&usbvision->rdev)) {
 		PDEBUG(DBG_PROBE, "unregister %s [v4l2]",
-		       video_device_node_name(usbvision->rdev));
-		if (video_is_registered(usbvision->rdev))
-			video_unregister_device(usbvision->rdev);
-		else
-			video_device_release(usbvision->rdev);
-		usbvision->rdev = NULL;
+		       video_device_node_name(&usbvision->rdev));
+		video_unregister_device(&usbvision->rdev);
 	}
 
 	/* Video Device: */
-	if (usbvision->vdev) {
+	if (video_is_registered(&usbvision->vdev)) {
 		PDEBUG(DBG_PROBE, "unregister %s [v4l2]",
-		       video_device_node_name(usbvision->vdev));
-		if (video_is_registered(usbvision->vdev))
-			video_unregister_device(usbvision->vdev);
-		else
-			video_device_release(usbvision->vdev);
-		usbvision->vdev = NULL;
+		       video_device_node_name(&usbvision->vdev));
+		video_unregister_device(&usbvision->vdev);
 	}
 }
 
@@ -1371,28 +1359,22 @@ static void usbvision_unregister_video(struct usb_usbvision *usbvision)
 static int usbvision_register_video(struct usb_usbvision *usbvision)
 {
 	/* Video Device: */
-	usbvision->vdev = usbvision_vdev_init(usbvision,
-					      &usbvision_video_template,
-					      "USBVision Video");
-	if (usbvision->vdev == NULL)
-		goto err_exit;
-	if (video_register_device(usbvision->vdev, VFL_TYPE_GRABBER, video_nr) < 0)
+	usbvision_vdev_init(usbvision, &usbvision->vdev,
+			      &usbvision_video_template, "USBVision Video");
+	if (video_register_device(&usbvision->vdev, VFL_TYPE_GRABBER, video_nr) < 0)
 		goto err_exit;
 	printk(KERN_INFO "USBVision[%d]: registered USBVision Video device %s [v4l2]\n",
-	       usbvision->nr, video_device_node_name(usbvision->vdev));
+	       usbvision->nr, video_device_node_name(&usbvision->vdev));
 
 	/* Radio Device: */
 	if (usbvision_device_data[usbvision->dev_model].radio) {
 		/* usbvision has radio */
-		usbvision->rdev = usbvision_vdev_init(usbvision,
-						      &usbvision_radio_template,
-						      "USBVision Radio");
-		if (usbvision->rdev == NULL)
-			goto err_exit;
-		if (video_register_device(usbvision->rdev, VFL_TYPE_RADIO, radio_nr) < 0)
+		usbvision_vdev_init(usbvision, &usbvision->rdev,
+			      &usbvision_radio_template, "USBVision Radio");
+		if (video_register_device(&usbvision->rdev, VFL_TYPE_RADIO, radio_nr) < 0)
 			goto err_exit;
 		printk(KERN_INFO "USBVision[%d]: registered USBVision Radio device %s [v4l2]\n",
-		       usbvision->nr, video_device_node_name(usbvision->rdev));
+		       usbvision->nr, video_device_node_name(&usbvision->rdev));
 	}
 	/* all done */
 	return 0;
@@ -1461,7 +1443,7 @@ static void usbvision_release(struct usb_usbvision *usbvision)
 
 	usbvision->initialized = 0;
 
-	usbvision_remove_sysfs(usbvision->vdev);
+	usbvision_remove_sysfs(&usbvision->vdev);
 	usbvision_unregister_video(usbvision);
 	kfree(usbvision->alt_max_pkt_size);
 
@@ -1611,7 +1593,7 @@ static int usbvision_probe(struct usb_interface *intf,
 	usbvision_configure_video(usbvision);
 	usbvision_register_video(usbvision);
 
-	usbvision_create_sysfs(usbvision->vdev);
+	usbvision_create_sysfs(&usbvision->vdev);
 
 	PDEBUG(DBG_PROBE, "success");
 	return 0;
diff --git a/drivers/media/usb/usbvision/usbvision.h b/drivers/media/usb/usbvision/usbvision.h
index 77aeb1e..140a1f6 100644
--- a/drivers/media/usb/usbvision/usbvision.h
+++ b/drivers/media/usb/usbvision/usbvision.h
@@ -357,8 +357,8 @@ extern struct usb_device_id usbvision_table[];
 
 struct usb_usbvision {
 	struct v4l2_device v4l2_dev;
-	struct video_device *vdev;					/* Video Device */
-	struct video_device *rdev;					/* Radio Device */
+	struct video_device vdev;					/* Video Device */
+	struct video_device rdev;					/* Radio Device */
 
 	/* i2c Declaration Section*/
 	struct i2c_adapter i2c_adap;
-- 
2.1.4

