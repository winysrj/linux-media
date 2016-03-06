Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34328 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbcCFNvO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2016 08:51:14 -0500
Received: by mail-wm0-f68.google.com with SMTP id p65so6429003wmp.1
        for <linux-media@vger.kernel.org>; Sun, 06 Mar 2016 05:51:14 -0800 (PST)
Date: Sun, 6 Mar 2016 15:51:00 +0200
From: Ulrik de Muelenaere <ulrikdem@gmail.com>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>, Antonio Ospite <ao2@ao2.it>
Subject: [PATCH 1/2] [media] gspca: allow multiple probes per USB interface
Message-ID: <9a06763b2ef47c215c473a6b9a0c8d079b163991.1457262292.git.ulrikdem@gmail.com>
References: <cover.1457262292.git.ulrikdem@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1457262292.git.ulrikdem@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow gspca_dev_probe() to be called multiple times per USB interface,
resulting in multiple video device nodes.

A pointer to the created gspca_dev is stored as the interface's private
data. Store other devices linked to the same interface as a linked list,
allowing all devices to be disconnected, suspended or resumed when given
the interface.

This is useful for subdrivers such as gspca_kinect, where a single USB
interface produces both video and depth streams.

Signed-off-by: Ulrik de Muelenaere <ulrikdem@gmail.com>
---
 drivers/media/usb/gspca/gspca.c | 129 +++++++++++++++++++++++-----------------
 drivers/media/usb/gspca/gspca.h |   1 +
 2 files changed, 76 insertions(+), 54 deletions(-)

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index af5cd82..d002b8b 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -2004,8 +2004,9 @@ static const struct video_device gspca_template = {
 /*
  * probe and create a new gspca device
  *
- * This function must be called by the sub-driver when it is
- * called for probing a new device.
+ * This function must be called by the sub-driver when it is called for probing
+ * a new device. It may be called multiple times per USB interface, resulting in
+ * multiple video device nodes.
  */
 int gspca_dev_probe2(struct usb_interface *intf,
 		const struct usb_device_id *id,
@@ -2037,6 +2038,7 @@ int gspca_dev_probe2(struct usb_interface *intf,
 	gspca_dev->dev = dev;
 	gspca_dev->iface = intf->cur_altsetting->desc.bInterfaceNumber;
 	gspca_dev->xfer_ep = -1;
+	gspca_dev->next_dev = usb_get_intfdata(intf);
 
 	/* check if any audio device */
 	if (dev->actconfig->desc.bNumInterfaces != 1) {
@@ -2169,41 +2171,50 @@ EXPORT_SYMBOL(gspca_dev_probe);
  */
 void gspca_disconnect(struct usb_interface *intf)
 {
-	struct gspca_dev *gspca_dev = usb_get_intfdata(intf);
+	struct gspca_dev *gspca_dev = usb_get_intfdata(intf), *next_dev;
 #if IS_ENABLED(CONFIG_INPUT)
 	struct input_dev *input_dev;
 #endif
 
-	PDEBUG(D_PROBE, "%s disconnect",
-		video_device_node_name(&gspca_dev->vdev));
+	while (gspca_dev) {
+		PDEBUG(D_PROBE, "%s disconnect",
+			video_device_node_name(&gspca_dev->vdev));
 
-	mutex_lock(&gspca_dev->usb_lock);
+		mutex_lock(&gspca_dev->usb_lock);
 
-	gspca_dev->present = 0;
-	destroy_urbs(gspca_dev);
+		gspca_dev->present = 0;
+		destroy_urbs(gspca_dev);
 
 #if IS_ENABLED(CONFIG_INPUT)
-	gspca_input_destroy_urb(gspca_dev);
-	input_dev = gspca_dev->input_dev;
-	if (input_dev) {
-		gspca_dev->input_dev = NULL;
-		input_unregister_device(input_dev);
-	}
+		gspca_input_destroy_urb(gspca_dev);
+		input_dev = gspca_dev->input_dev;
+		if (input_dev) {
+			gspca_dev->input_dev = NULL;
+			input_unregister_device(input_dev);
+		}
 #endif
-	/* Free subdriver's streaming resources / stop sd workqueue(s) */
-	if (gspca_dev->sd_desc->stop0 && gspca_dev->streaming)
-		gspca_dev->sd_desc->stop0(gspca_dev);
-	gspca_dev->streaming = 0;
-	gspca_dev->dev = NULL;
-	wake_up_interruptible(&gspca_dev->wq);
+		/* Free subdriver's streaming resources / stop sd
+		 * workqueue(s)
+		 */
+		if (gspca_dev->sd_desc->stop0 && gspca_dev->streaming)
+			gspca_dev->sd_desc->stop0(gspca_dev);
+		gspca_dev->streaming = 0;
+		gspca_dev->dev = NULL;
+		wake_up_interruptible(&gspca_dev->wq);
 
-	v4l2_device_disconnect(&gspca_dev->v4l2_dev);
-	video_unregister_device(&gspca_dev->vdev);
+		v4l2_device_disconnect(&gspca_dev->v4l2_dev);
+		video_unregister_device(&gspca_dev->vdev);
 
-	mutex_unlock(&gspca_dev->usb_lock);
+		mutex_unlock(&gspca_dev->usb_lock);
 
-	/* (this will call gspca_release() immediately or on last close) */
-	v4l2_device_put(&gspca_dev->v4l2_dev);
+		next_dev = gspca_dev->next_dev;
+		/* (this will call gspca_release() immediately or on last
+		 * close)
+		 */
+		v4l2_device_put(&gspca_dev->v4l2_dev);
+
+		gspca_dev = next_dev;
+	}
 }
 EXPORT_SYMBOL(gspca_disconnect);
 
@@ -2212,21 +2223,27 @@ int gspca_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct gspca_dev *gspca_dev = usb_get_intfdata(intf);
 
-	gspca_input_destroy_urb(gspca_dev);
+	while (gspca_dev) {
+		gspca_input_destroy_urb(gspca_dev);
 
-	if (!gspca_dev->streaming)
-		return 0;
+		if (!gspca_dev->streaming) {
+			gspca_dev = gspca_dev->next_dev;
+			continue;
+		}
 
-	mutex_lock(&gspca_dev->usb_lock);
-	gspca_dev->frozen = 1;		/* avoid urb error messages */
-	gspca_dev->usb_err = 0;
-	if (gspca_dev->sd_desc->stopN)
-		gspca_dev->sd_desc->stopN(gspca_dev);
-	destroy_urbs(gspca_dev);
-	gspca_set_alt0(gspca_dev);
-	if (gspca_dev->sd_desc->stop0)
-		gspca_dev->sd_desc->stop0(gspca_dev);
-	mutex_unlock(&gspca_dev->usb_lock);
+		mutex_lock(&gspca_dev->usb_lock);
+		gspca_dev->frozen = 1;		/* avoid urb error messages */
+		gspca_dev->usb_err = 0;
+		if (gspca_dev->sd_desc->stopN)
+			gspca_dev->sd_desc->stopN(gspca_dev);
+		destroy_urbs(gspca_dev);
+		gspca_set_alt0(gspca_dev);
+		if (gspca_dev->sd_desc->stop0)
+			gspca_dev->sd_desc->stop0(gspca_dev);
+		mutex_unlock(&gspca_dev->usb_lock);
+
+		gspca_dev = gspca_dev->next_dev;
+	}
 
 	return 0;
 }
@@ -2237,22 +2254,26 @@ int gspca_resume(struct usb_interface *intf)
 	struct gspca_dev *gspca_dev = usb_get_intfdata(intf);
 	int streaming, ret = 0;
 
-	mutex_lock(&gspca_dev->usb_lock);
-	gspca_dev->frozen = 0;
-	gspca_dev->usb_err = 0;
-	gspca_dev->sd_desc->init(gspca_dev);
-	/*
-	 * Most subdrivers send all ctrl values on sd_start and thus
-	 * only write to the device registers on s_ctrl when streaming ->
-	 * Clear streaming to avoid setting all ctrls twice.
-	 */
-	streaming = gspca_dev->streaming;
-	gspca_dev->streaming = 0;
-	if (streaming)
-		ret = gspca_init_transfer(gspca_dev);
-	else
-		gspca_input_create_urb(gspca_dev);
-	mutex_unlock(&gspca_dev->usb_lock);
+	while (gspca_dev) {
+		mutex_lock(&gspca_dev->usb_lock);
+		gspca_dev->frozen = 0;
+		gspca_dev->usb_err = 0;
+		gspca_dev->sd_desc->init(gspca_dev);
+		/*
+		 * Most subdrivers send all ctrl values on sd_start and thus
+		 * only write to the device registers on s_ctrl when streaming -
+		 * Clear streaming to avoid setting all ctrls twice.
+		 */
+		streaming = gspca_dev->streaming;
+		gspca_dev->streaming = 0;
+		if (streaming)
+			ret |= gspca_init_transfer(gspca_dev);
+		else
+			gspca_input_create_urb(gspca_dev);
+		mutex_unlock(&gspca_dev->usb_lock);
+
+		gspca_dev = gspca_dev->next_dev;
+	}
 
 	return ret;
 }
diff --git a/drivers/media/usb/gspca/gspca.h b/drivers/media/usb/gspca/gspca.h
index d39adf9..dcafc89 100644
--- a/drivers/media/usb/gspca/gspca.h
+++ b/drivers/media/usb/gspca/gspca.h
@@ -207,6 +207,7 @@ struct gspca_dev {
 	__u8 alt;			/* USB alternate setting */
 	int xfer_ep;			/* USB transfer endpoint address */
 	u8 audio;			/* presence of audio device */
+	struct gspca_dev *next_dev;	/* next device sharing USB interface */
 
 	/* (*) These variables are proteced by both usb_lock and queue_lock,
 	   that is any code setting them is holding *both*, which means that
-- 
2.7.0

