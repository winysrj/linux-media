Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2073 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601Ab3FLPCK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jun 2013 11:02:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 05/12] sn9c102_core: add v4l2_device and replace parent with v4l2_dev
Date: Wed, 12 Jun 2013 17:00:55 +0200
Message-Id: <1371049262-5799-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1371049262-5799-1-git-send-email-hverkuil@xs4all.nl>
References: <1371049262-5799-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This driver did not yet support struct v4l2_device, so add it. This
make it possible to replace the deprecated parent field with the
v4l2_dev field, allowing the eventual removal of the parent field.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/sn9c102/sn9c102.h      |    3 +++
 drivers/media/usb/sn9c102/sn9c102_core.c |   13 ++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/sn9c102/sn9c102.h b/drivers/media/usb/sn9c102/sn9c102.h
index 2bc153e..8a917f06 100644
--- a/drivers/media/usb/sn9c102/sn9c102.h
+++ b/drivers/media/usb/sn9c102/sn9c102.h
@@ -25,6 +25,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-device.h>
 #include <linux/device.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
@@ -100,6 +101,8 @@ static DECLARE_RWSEM(sn9c102_dev_lock);
 struct sn9c102_device {
 	struct video_device* v4ldev;
 
+	struct v4l2_device v4l2_dev;
+
 	enum sn9c102_bridge bridge;
 	struct sn9c102_sensor sensor;
 
diff --git a/drivers/media/usb/sn9c102/sn9c102_core.c b/drivers/media/usb/sn9c102/sn9c102_core.c
index c957e9a..2cb44de 100644
--- a/drivers/media/usb/sn9c102/sn9c102_core.c
+++ b/drivers/media/usb/sn9c102/sn9c102_core.c
@@ -1737,6 +1737,7 @@ static void sn9c102_release_resources(struct kref *kref)
 	    video_device_node_name(cam->v4ldev));
 	video_set_drvdata(cam->v4ldev, NULL);
 	video_unregister_device(cam->v4ldev);
+	v4l2_device_unregister(&cam->v4l2_dev);
 	usb_put_dev(cam->usbdev);
 	kfree(cam->control_buffer);
 	kfree(cam);
@@ -3254,6 +3255,13 @@ sn9c102_usb_probe(struct usb_interface* intf, const struct usb_device_id* id)
 
 	cam->usbdev = udev;
 
+	/* register v4l2_device early so it can be used for printks */
+	if (v4l2_device_register(&intf->dev, &cam->v4l2_dev)) {
+		dev_err(&intf->dev, "v4l2_device_register failed\n");
+		err = -ENOMEM;
+		goto fail;
+	}
+
 	if (!(cam->control_buffer = kzalloc(8, GFP_KERNEL))) {
 		DBG(1, "kzalloc() failed");
 		err = -ENOMEM;
@@ -3325,7 +3333,7 @@ sn9c102_usb_probe(struct usb_interface* intf, const struct usb_device_id* id)
 	strcpy(cam->v4ldev->name, "SN9C1xx PC Camera");
 	cam->v4ldev->fops = &sn9c102_fops;
 	cam->v4ldev->release = video_device_release;
-	cam->v4ldev->parent = &udev->dev;
+	cam->v4ldev->v4l2_dev = &cam->v4l2_dev;
 
 	init_completion(&cam->probe);
 
@@ -3377,6 +3385,7 @@ fail:
 		kfree(cam->control_buffer);
 		if (cam->v4ldev)
 			video_device_release(cam->v4ldev);
+		v4l2_device_unregister(&cam->v4l2_dev);
 		kfree(cam);
 	}
 	return err;
@@ -3407,6 +3416,8 @@ static void sn9c102_usb_disconnect(struct usb_interface* intf)
 
 	wake_up_interruptible_all(&cam->wait_open);
 
+	v4l2_device_disconnect(&cam->v4l2_dev);
+
 	kref_put(&cam->kref, sn9c102_release_resources);
 
 	up_write(&sn9c102_dev_lock);
-- 
1.7.10.4

