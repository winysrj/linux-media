Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2345 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab3CKVBL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 17:01:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Steven Toth <stoth@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 11/15] au0828: fix disconnect sequence.
Date: Mon, 11 Mar 2013 22:00:42 +0100
Message-Id: <6d4b25c7bfc65cfff4937133bed3e60828c20174.1363035203.git.hans.verkuil@cisco.com>
In-Reply-To: <1363035646-25244-1-git-send-email-hverkuil@xs4all.nl>
References: <1363035646-25244-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0e2409cf677013b9cad1ba4aee17fe434dae7146.1363035203.git.hans.verkuil@cisco.com>
References: <0e2409cf677013b9cad1ba4aee17fe434dae7146.1363035203.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The driver crashed when the device was disconnected while an application
still had a device node open. Fixed by using the release() callback of struct
v4l2_device.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/au0828/au0828-core.c  |   48 ++++++++++++++++++++-----------
 drivers/media/usb/au0828/au0828-video.c |    9 +-----
 2 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index ffd3bcb..bd9d19a 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -125,36 +125,48 @@ static int recv_control_msg(struct au0828_dev *dev, u16 request, u32 value,
 	return status;
 }
 
-static void au0828_usb_disconnect(struct usb_interface *interface)
+static void au0828_usb_release(struct au0828_dev *dev)
 {
-	struct au0828_dev *dev = usb_get_intfdata(interface);
-
-	dprintk(1, "%s()\n", __func__);
-
-	/* Digital TV */
-	au0828_dvb_unregister(dev);
-
-#ifdef CONFIG_VIDEO_AU0828_V4L2
-	if (AUVI_INPUT(0).type != AU0828_VMUX_UNDEFINED)
-		au0828_analog_unregister(dev);
-#endif
-
 	/* I2C */
 	au0828_i2c_unregister(dev);
 
+	kfree(dev);
+}
+
 #ifdef CONFIG_VIDEO_AU0828_V4L2
+static void au0828_usb_v4l2_release(struct v4l2_device *v4l2_dev)
+{
+	struct au0828_dev *dev =
+		container_of(v4l2_dev, struct au0828_dev, v4l2_dev);
+
 	v4l2_ctrl_handler_free(&dev->v4l2_ctrl_hdl);
 	v4l2_device_unregister(&dev->v4l2_dev);
+	au0828_usb_release(dev);
+}
 #endif
 
-	usb_set_intfdata(interface, NULL);
+static void au0828_usb_disconnect(struct usb_interface *interface)
+{
+	struct au0828_dev *dev = usb_get_intfdata(interface);
+
+	dprintk(1, "%s()\n", __func__);
+
+	/* Digital TV */
+	au0828_dvb_unregister(dev);
 
+	usb_set_intfdata(interface, NULL);
 	mutex_lock(&dev->mutex);
 	dev->usbdev = NULL;
 	mutex_unlock(&dev->mutex);
-
-	kfree(dev);
-
+#ifdef CONFIG_VIDEO_AU0828_V4L2
+	if (AUVI_INPUT(0).type != AU0828_VMUX_UNDEFINED) {
+		au0828_analog_unregister(dev);
+		v4l2_device_disconnect(&dev->v4l2_dev);
+		v4l2_device_put(&dev->v4l2_dev);
+		return;
+	}
+#endif
+	au0828_usb_release(dev);
 }
 
 static int au0828_usb_probe(struct usb_interface *interface,
@@ -203,6 +215,8 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	dev->boardnr = id->driver_info;
 
 #ifdef CONFIG_VIDEO_AU0828_V4L2
+	dev->v4l2_dev.release = au0828_usb_v4l2_release;
+
 	/* Create the v4l2_device */
 	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
 	if (retval) {
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 62308fe..a41e5ae 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1063,14 +1063,7 @@ static int au0828_v4l2_close(struct file *filp)
 		res_free(fh, AU0828_RESOURCE_VBI);
 	}
 
-	if (dev->users == 1) {
-		if (dev->dev_state & DEV_DISCONNECTED) {
-			au0828_analog_unregister(dev);
-			kfree(fh);
-			kfree(dev);
-			return 0;
-		}
-
+	if (dev->users == 1 && video_is_registered(video_devdata(filp))) {
 		au0828_analog_stream_disable(dev);
 
 		au0828_uninit_isoc(dev);
-- 
1.7.10.4

