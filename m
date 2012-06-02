Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4246 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759335Ab2FBL6c (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jun 2012 07:58:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 2/6] zr364xx: introduce v4l2_device.
Date: Sat,  2 Jun 2012 13:58:16 +0200
Message-Id: <47339882c1b9352670490f599707aedce55e8663.1338638167.git.hans.verkuil@cisco.com>
In-Reply-To: <1338638300-9769-1-git-send-email-hverkuil@xs4all.nl>
References: <1338638300-9769-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <dd538e942bd8b7a7fb4e02ea9b4b6df72b32f9f1.1338638167.git.hans.verkuil@cisco.com>
References: <dd538e942bd8b7a7fb4e02ea9b4b6df72b32f9f1.1338638167.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Implement struct v4l2_device: use the core lock and use the v4l2_device
release() callback.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/zr364xx.c |  109 +++++++++++++++++++----------------------
 1 file changed, 51 insertions(+), 58 deletions(-)

diff --git a/drivers/media/video/zr364xx.c b/drivers/media/video/zr364xx.c
index daf2099..95fd990 100644
--- a/drivers/media/video/zr364xx.c
+++ b/drivers/media/video/zr364xx.c
@@ -37,6 +37,7 @@
 #include <linux/highmem.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-device.h>
 #include <media/videobuf-vmalloc.h>
 
 
@@ -173,6 +174,7 @@ static const struct zr364xx_fmt formats[] = {
 struct zr364xx_camera {
 	struct usb_device *udev;	/* save off the usb device pointer */
 	struct usb_interface *interface;/* the interface for this device */
+	struct v4l2_device v4l2_dev;
 	struct video_device vdev;	/* v4l video device */
 	int nb;
 	struct zr364xx_bufferi		buffer;
@@ -181,7 +183,6 @@ struct zr364xx_camera {
 	int height;
 	int method;
 	struct mutex lock;
-	struct mutex open_lock;
 	int users;
 
 	spinlock_t		slock;
@@ -230,11 +231,6 @@ static int send_control_msg(struct usb_device *udev, u8 request, u16 value,
 				 transfer_buffer, size, CTRL_TIMEOUT);
 
 	kfree(transfer_buffer);
-
-	if (status < 0)
-		dev_err(&udev->dev,
-			"Failed sending control message, error %d.\n", status);
-
 	return status;
 }
 
@@ -468,6 +464,7 @@ static ssize_t zr364xx_read(struct file *file, char __user *buf, size_t count,
 			    loff_t * ppos)
 {
 	struct zr364xx_camera *cam = video_drvdata(file);
+	int err = 0;
 
 	_DBG("%s\n", __func__);
 
@@ -477,17 +474,20 @@ static ssize_t zr364xx_read(struct file *file, char __user *buf, size_t count,
 	if (!count)
 		return -EINVAL;
 
+	if (mutex_lock_interruptible(&cam->lock))
+		return -ERESTARTSYS;
+
 	if (cam->type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
 	    zr364xx_vidioc_streamon(file, cam, cam->type) == 0) {
 		DBG("%s: reading %d bytes at pos %d.\n", __func__, (int) count,
 		    (int) *ppos);
 
 		/* NoMan Sux ! */
-		return videobuf_read_one(&cam->vb_vidq, buf, count, ppos,
+		err = videobuf_read_one(&cam->vb_vidq, buf, count, ppos,
 					file->f_flags & O_NONBLOCK);
 	}
-
-	return 0;
+	mutex_unlock(&cam->lock);
+	return err;
 }
 
 /* video buffer vmalloc implementation based partly on VIVI driver which is
@@ -705,16 +705,13 @@ static int zr364xx_read_video_callback(struct zr364xx_camera *cam,
 static int res_get(struct zr364xx_camera *cam)
 {
 	/* is it free? */
-	mutex_lock(&cam->lock);
 	if (cam->resources) {
 		/* no, someone else uses it */
-		mutex_unlock(&cam->lock);
 		return 0;
 	}
 	/* it's free, grab it */
 	cam->resources = 1;
 	_DBG("res: get\n");
-	mutex_unlock(&cam->lock);
 	return 1;
 }
 
@@ -725,9 +722,7 @@ static inline int res_check(struct zr364xx_camera *cam)
 
 static void res_free(struct zr364xx_camera *cam)
 {
-	mutex_lock(&cam->lock);
 	cam->resources = 0;
-	mutex_unlock(&cam->lock);
 	_DBG("res: put\n");
 }
 
@@ -811,11 +806,9 @@ static int zr364xx_vidioc_s_ctrl(struct file *file, void *priv,
 	case V4L2_CID_BRIGHTNESS:
 		cam->mode.brightness = c->value;
 		/* hardware brightness */
-		mutex_lock(&cam->lock);
 		send_control_msg(cam->udev, 1, 0x2001, 0, NULL, 0);
 		temp = (0x60 << 8) + 127 - cam->mode.brightness;
 		send_control_msg(cam->udev, 1, temp, 0, NULL, 0);
-		mutex_unlock(&cam->lock);
 		break;
 	default:
 		return -EINVAL;
@@ -1270,7 +1263,8 @@ static int zr364xx_open(struct file *file)
 
 	DBG("%s\n", __func__);
 
-	mutex_lock(&cam->open_lock);
+	if (mutex_lock_interruptible(&cam->lock))
+		return -ERESTARTSYS;
 
 	if (cam->users) {
 		err = -EBUSY;
@@ -1299,7 +1293,7 @@ static int zr364xx_open(struct file *file)
 				    NULL, &cam->slock,
 				    cam->type,
 				    V4L2_FIELD_NONE,
-				    sizeof(struct zr364xx_buffer), cam, NULL);
+				    sizeof(struct zr364xx_buffer), cam, &cam->lock);
 
 	/* Added some delay here, since opening/closing the camera quickly,
 	 * like Ekiga does during its startup, can crash the webcam
@@ -1308,27 +1302,20 @@ static int zr364xx_open(struct file *file)
 	err = 0;
 
 out:
-	mutex_unlock(&cam->open_lock);
+	mutex_unlock(&cam->lock);
 	DBG("%s: %d\n", __func__, err);
 	return err;
 }
 
-static void zr364xx_destroy(struct zr364xx_camera *cam)
+static void zr364xx_release(struct v4l2_device *v4l2_dev)
 {
+	struct zr364xx_camera *cam =
+		container_of(v4l2_dev, struct zr364xx_camera, v4l2_dev);
 	unsigned long i;
 
-	if (!cam) {
-		printk(KERN_ERR KBUILD_MODNAME ", %s: no device\n", __func__);
-		return;
-	}
-	mutex_lock(&cam->open_lock);
-	video_unregister_device(&cam->vdev);
-
-	/* stops the read pipe if it is running */
-	if (cam->b_acquire)
-		zr364xx_stop_acquire(cam);
+	v4l2_device_unregister(&cam->v4l2_dev);
 
-	zr364xx_stop_readpipe(cam);
+	videobuf_mmap_free(&cam->vb_vidq);
 
 	/* release sys buffers */
 	for (i = 0; i < FRAMES; i++) {
@@ -1341,25 +1328,20 @@ static void zr364xx_destroy(struct zr364xx_camera *cam)
 
 	/* release transfer buffer */
 	kfree(cam->pipe->transfer_buffer);
-	cam->pipe->transfer_buffer = NULL;
-	mutex_unlock(&cam->open_lock);
 	kfree(cam);
 }
 
 /* release the camera */
-static int zr364xx_release(struct file *file)
+static int zr364xx_close(struct file *file)
 {
 	struct zr364xx_camera *cam;
 	struct usb_device *udev;
-	int i, err;
+	int i;
 
 	DBG("%s\n", __func__);
 	cam = video_drvdata(file);
 
-	if (!cam)
-		return -ENODEV;
-
-	mutex_lock(&cam->open_lock);
+	mutex_lock(&cam->lock);
 	udev = cam->udev;
 
 	/* turn off stream */
@@ -1374,26 +1356,17 @@ static int zr364xx_release(struct file *file)
 	file->private_data = NULL;
 
 	for (i = 0; i < 2; i++) {
-		err =
-		    send_control_msg(udev, 1, init[cam->method][i].value,
+		send_control_msg(udev, 1, init[cam->method][i].value,
 				     0, init[cam->method][i].bytes,
 				     init[cam->method][i].size);
-		if (err < 0) {
-			dev_err(&udev->dev, "error during release sequence\n");
-			goto out;
-		}
 	}
 
 	/* Added some delay here, since opening/closing the camera quickly,
 	 * like Ekiga does during its startup, can crash the webcam
 	 */
 	mdelay(100);
-	err = 0;
-
-out:
-	mutex_unlock(&cam->open_lock);
-
-	return err;
+	mutex_unlock(&cam->lock);
+	return 0;
 }
 
 
@@ -1432,10 +1405,10 @@ static unsigned int zr364xx_poll(struct file *file,
 static const struct v4l2_file_operations zr364xx_fops = {
 	.owner = THIS_MODULE,
 	.open = zr364xx_open,
-	.release = zr364xx_release,
+	.release = zr364xx_close,
 	.read = zr364xx_read,
 	.mmap = zr364xx_mmap,
-	.ioctl = video_ioctl2,
+	.unlocked_ioctl = video_ioctl2,
 	.poll = zr364xx_poll,
 };
 
@@ -1552,10 +1525,20 @@ static int zr364xx_probe(struct usb_interface *intf,
 		dev_err(&udev->dev, "cam: out of memory !\n");
 		return -ENOMEM;
 	}
+
+	cam->v4l2_dev.release = zr364xx_release;
+	err = v4l2_device_register(&intf->dev, &cam->v4l2_dev);
+	if (err < 0) {
+		dev_err(&udev->dev, "couldn't register v4l2_device\n");
+		kfree(cam);
+		return err;
+	}
 	/* save the init method used by this camera */
 	cam->method = id->driver_info;
+	mutex_init(&cam->lock);
 	cam->vdev = zr364xx_template;
-	cam->vdev.parent = &intf->dev;
+	cam->vdev.lock = &cam->lock;
+	cam->vdev.v4l2_dev = &cam->v4l2_dev;
 	video_set_drvdata(&cam->vdev, cam);
 	if (debug)
 		cam->vdev.debug = V4L2_DEBUG_IOCTL | V4L2_DEBUG_IOCTL_ARG;
@@ -1607,8 +1590,6 @@ static int zr364xx_probe(struct usb_interface *intf,
 	cam->users = 0;
 	cam->nb = 0;
 	cam->mode.brightness = 64;
-	mutex_init(&cam->lock);
-	mutex_init(&cam->open_lock);
 
 	DBG("dev: %p, udev %p interface %p\n", cam, cam->udev, intf);
 
@@ -1625,6 +1606,7 @@ static int zr364xx_probe(struct usb_interface *intf,
 
 	if (!cam->read_endpoint) {
 		dev_err(&intf->dev, "Could not find bulk-in endpoint\n");
+		v4l2_device_unregister(&cam->v4l2_dev);
 		kfree(cam);
 		return -ENOMEM;
 	}
@@ -1647,6 +1629,7 @@ static int zr364xx_probe(struct usb_interface *intf,
 	err = video_register_device(&cam->vdev, VFL_TYPE_GRABBER, -1);
 	if (err) {
 		dev_err(&udev->dev, "video_register_device failed\n");
+		v4l2_device_unregister(&cam->v4l2_dev);
 		kfree(cam);
 		return err;
 	}
@@ -1660,10 +1643,20 @@ static int zr364xx_probe(struct usb_interface *intf,
 static void zr364xx_disconnect(struct usb_interface *intf)
 {
 	struct zr364xx_camera *cam = usb_get_intfdata(intf);
-	videobuf_mmap_free(&cam->vb_vidq);
+
+	mutex_lock(&cam->lock);
 	usb_set_intfdata(intf, NULL);
 	dev_info(&intf->dev, DRIVER_DESC " webcam unplugged\n");
-	zr364xx_destroy(cam);
+	video_unregister_device(&cam->vdev);
+	v4l2_device_disconnect(&cam->v4l2_dev);
+
+	/* stops the read pipe if it is running */
+	if (cam->b_acquire)
+		zr364xx_stop_acquire(cam);
+
+	zr364xx_stop_readpipe(cam);
+	mutex_unlock(&cam->lock);
+	v4l2_device_put(&cam->v4l2_dev);
 }
 
 
-- 
1.7.10

