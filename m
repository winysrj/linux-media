Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:42738 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755394AbbGTNAz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:00:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 02/12] usbvision: remove power_on_at_open and timed power off
Date: Mon, 20 Jul 2015 14:59:28 +0200
Message-Id: <1437397178-5013-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437397178-5013-1-git-send-email-hverkuil@xs4all.nl>
References: <1437397178-5013-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This causes lots of problems and is *very* slow as well.

One of the main problems is that this prohibits the use of the control
framework since subdevs will be unloaded on power off which is not allowed
as long as they are used by a usb device.

Apparently the reason for doing this is to turn off a noisy tuner. My hardware
has no problem with that, and I wonder whether the hardware with that noisy
tuner wasn't just functioning improperly as I have never heard of noisy tuners.

Contact me if you have one of those devices and I can take a look whether the
tuner can't be powered off if necessary by letting the tuner subdevice go
into standby mode. Unloading the tuner module is just evil and is not the
right approach.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/usbvision/usbvision-core.c  | 49 ------------------
 drivers/media/usb/usbvision/usbvision-video.c | 71 ++++-----------------------
 drivers/media/usb/usbvision/usbvision.h       |  5 --
 3 files changed, 9 insertions(+), 116 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-core.c b/drivers/media/usb/usbvision/usbvision-core.c
index 7c04ef6..ec50984 100644
--- a/drivers/media/usb/usbvision/usbvision-core.c
+++ b/drivers/media/usb/usbvision/usbvision-core.c
@@ -2161,55 +2161,6 @@ int usbvision_power_on(struct usb_usbvision *usbvision)
 
 
 /*
- * usbvision timer stuff
- */
-
-/* to call usbvision_power_off from task queue */
-static void call_usbvision_power_off(struct work_struct *work)
-{
-	struct usb_usbvision *usbvision = container_of(work, struct usb_usbvision, power_off_work);
-
-	PDEBUG(DBG_FUNC, "");
-	if (mutex_lock_interruptible(&usbvision->v4l2_lock))
-		return;
-
-	if (usbvision->user == 0) {
-		usbvision_i2c_unregister(usbvision);
-
-		usbvision_power_off(usbvision);
-		usbvision->initialized = 0;
-	}
-	mutex_unlock(&usbvision->v4l2_lock);
-}
-
-static void usbvision_power_off_timer(unsigned long data)
-{
-	struct usb_usbvision *usbvision = (void *)data;
-
-	PDEBUG(DBG_FUNC, "");
-	del_timer(&usbvision->power_off_timer);
-	INIT_WORK(&usbvision->power_off_work, call_usbvision_power_off);
-	(void) schedule_work(&usbvision->power_off_work);
-}
-
-void usbvision_init_power_off_timer(struct usb_usbvision *usbvision)
-{
-	setup_timer(&usbvision->power_off_timer, usbvision_power_off_timer,
-		    (unsigned long)usbvision);
-}
-
-void usbvision_set_power_off_timer(struct usb_usbvision *usbvision)
-{
-	mod_timer(&usbvision->power_off_timer, jiffies + USBVISION_POWEROFF_TIME);
-}
-
-void usbvision_reset_power_off_timer(struct usb_usbvision *usbvision)
-{
-	if (timer_pending(&usbvision->power_off_timer))
-		del_timer(&usbvision->power_off_timer);
-}
-
-/*
  * usbvision_begin_streaming()
  * Sure you have to put bit 7 to 0, if not incoming frames are droped, but no
  * idea about the rest
diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index 1c6d31f..1355b5d 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -122,8 +122,6 @@ static void usbvision_release(struct usb_usbvision *usbvision);
 static int isoc_mode = ISOC_MODE_COMPRESS;
 /* Set the default Debug Mode of the device driver */
 static int video_debug;
-/* Set the default device to power on at startup */
-static int power_on_at_open = 1;
 /* Sequential Number of Video Device */
 static int video_nr = -1;
 /* Sequential Number of Radio Device */
@@ -134,13 +132,11 @@ static int radio_nr = -1;
 /* Showing parameters under SYSFS */
 module_param(isoc_mode, int, 0444);
 module_param(video_debug, int, 0444);
-module_param(power_on_at_open, int, 0444);
 module_param(video_nr, int, 0444);
 module_param(radio_nr, int, 0444);
 
 MODULE_PARM_DESC(isoc_mode, " Set the default format for ISOC endpoint.  Default: 0x60 (Compression On)");
 MODULE_PARM_DESC(video_debug, " Set the default Debug Mode of the device driver.  Default: 0 (Off)");
-MODULE_PARM_DESC(power_on_at_open, " Set the default device to power on when device is opened.  Default: 1 (On)");
 MODULE_PARM_DESC(video_nr, "Set video device number (/dev/videoX).  Default: -1 (autodetect)");
 MODULE_PARM_DESC(radio_nr, "Set radio device number (/dev/radioX).  Default: -1 (autodetect)");
 
@@ -351,11 +347,10 @@ static int usbvision_v4l2_open(struct file *file)
 
 	if (mutex_lock_interruptible(&usbvision->v4l2_lock))
 		return -ERESTARTSYS;
-	usbvision_reset_power_off_timer(usbvision);
 
-	if (usbvision->user)
+	if (usbvision->user) {
 		err_code = -EBUSY;
-	else {
+	} else {
 		/* Allocate memory for the scratch ring buffer */
 		err_code = usbvision_scratch_alloc(usbvision);
 		if (isoc_mode == ISOC_MODE_COMPRESS) {
@@ -372,11 +367,6 @@ static int usbvision_v4l2_open(struct file *file)
 
 	/* If so far no errors then we shall start the camera */
 	if (!err_code) {
-		if (usbvision->power == 0) {
-			usbvision_power_on(usbvision);
-			usbvision_i2c_register(usbvision);
-		}
-
 		/* Send init sequence only once, it's large! */
 		if (!usbvision->initialized) {
 			int setup_ok = 0;
@@ -392,18 +382,13 @@ static int usbvision_v4l2_open(struct file *file)
 			err_code = usbvision_init_isoc(usbvision);
 			/* device must be initialized before isoc transfer */
 			usbvision_muxsel(usbvision, 0);
+
+			/* prepare queues */
+			usbvision_empty_framequeues(usbvision);
 			usbvision->user++;
-		} else {
-			if (power_on_at_open) {
-				usbvision_i2c_unregister(usbvision);
-				usbvision_power_off(usbvision);
-				usbvision->initialized = 0;
-			}
 		}
 	}
 
-	/* prepare queues */
-	usbvision_empty_framequeues(usbvision);
 	mutex_unlock(&usbvision->v4l2_lock);
 
 	PDEBUG(DBG_IO, "success");
@@ -436,13 +421,6 @@ static int usbvision_v4l2_close(struct file *file)
 
 	usbvision->user--;
 
-	if (power_on_at_open) {
-		/* power off in a little while
-		   to avoid off/on every close/open short sequences */
-		usbvision_set_power_off_timer(usbvision);
-		usbvision->initialized = 0;
-	}
-
 	if (usbvision->remove_pending) {
 		printk(KERN_INFO "%s: Final disconnect\n", __func__);
 		usbvision_release(usbvision);
@@ -1173,14 +1151,6 @@ static int usbvision_radio_open(struct file *file)
 				__func__);
 		err_code = -EBUSY;
 	} else {
-		if (power_on_at_open) {
-			usbvision_reset_power_off_timer(usbvision);
-			if (usbvision->power == 0) {
-				usbvision_power_on(usbvision);
-				usbvision_i2c_register(usbvision);
-			}
-		}
-
 		/* Alternate interface 1 is is the biggest frame size */
 		err_code = usbvision_set_alternate(usbvision);
 		if (err_code < 0) {
@@ -1195,14 +1165,6 @@ static int usbvision_radio_open(struct file *file)
 		usbvision_set_audio(usbvision, USBVISION_AUDIO_RADIO);
 		usbvision->user++;
 	}
-
-	if (err_code) {
-		if (power_on_at_open) {
-			usbvision_i2c_unregister(usbvision);
-			usbvision_power_off(usbvision);
-			usbvision->initialized = 0;
-		}
-	}
 out:
 	mutex_unlock(&usbvision->v4l2_lock);
 	return err_code;
@@ -1226,11 +1188,6 @@ static int usbvision_radio_close(struct file *file)
 	usbvision->radio = 0;
 	usbvision->user--;
 
-	if (power_on_at_open) {
-		usbvision_set_power_off_timer(usbvision);
-		usbvision->initialized = 0;
-	}
-
 	if (usbvision->remove_pending) {
 		printk(KERN_INFO "%s: Final disconnect\n", __func__);
 		usbvision_release(usbvision);
@@ -1428,8 +1385,6 @@ static struct usb_usbvision *usbvision_alloc(struct usb_device *dev,
 		goto err_unreg;
 	init_waitqueue_head(&usbvision->ctrl_urb_wq);
 
-	usbvision_init_power_off_timer(usbvision);
-
 	return usbvision;
 
 err_unreg:
@@ -1450,8 +1405,6 @@ static void usbvision_release(struct usb_usbvision *usbvision)
 {
 	PDEBUG(DBG_PROBE, "");
 
-	usbvision_reset_power_off_timer(usbvision);
-
 	usbvision->initialized = 0;
 
 	usbvision_remove_sysfs(&usbvision->vdev);
@@ -1495,11 +1448,9 @@ static void usbvision_configure_video(struct usb_usbvision *usbvision)
 	/* first switch off audio */
 	if (usbvision_device_data[model].audio_channels > 0)
 		usbvision_audio_off(usbvision);
-	if (!power_on_at_open) {
-		/* and then power up the noisy tuner */
-		usbvision_power_on(usbvision);
-		usbvision_i2c_register(usbvision);
-	}
+	/* and then power up the tuner */
+	usbvision_power_on(usbvision);
+	usbvision_i2c_register(usbvision);
 }
 
 /*
@@ -1646,11 +1597,7 @@ static void usbvision_disconnect(struct usb_interface *intf)
 	usbvision_stop_isoc(usbvision);
 
 	v4l2_device_disconnect(&usbvision->v4l2_dev);
-
-	if (usbvision->power) {
-		usbvision_i2c_unregister(usbvision);
-		usbvision_power_off(usbvision);
-	}
+	usbvision_i2c_unregister(usbvision);
 	usbvision->remove_pending = 1;	/* Now all ISO data will be ignored */
 
 	usb_put_dev(usbvision->dev);
diff --git a/drivers/media/usb/usbvision/usbvision.h b/drivers/media/usb/usbvision/usbvision.h
index 140a1f6..d39ab10 100644
--- a/drivers/media/usb/usbvision/usbvision.h
+++ b/drivers/media/usb/usbvision/usbvision.h
@@ -391,8 +391,6 @@ struct usb_usbvision {
 	unsigned char iface_alt;					/* Alt settings */
 	unsigned char vin_reg2_preset;
 	struct mutex v4l2_lock;
-	struct timer_list power_off_timer;
-	struct work_struct power_off_work;
 	int power;							/* is the device powered on? */
 	int user;							/* user count for exclusive use */
 	int initialized;						/* Had we already sent init sequence? */
@@ -510,9 +508,6 @@ int usbvision_muxsel(struct usb_usbvision *usbvision, int channel);
 int usbvision_set_input(struct usb_usbvision *usbvision);
 int usbvision_set_output(struct usb_usbvision *usbvision, int width, int height);
 
-void usbvision_init_power_off_timer(struct usb_usbvision *usbvision);
-void usbvision_set_power_off_timer(struct usb_usbvision *usbvision);
-void usbvision_reset_power_off_timer(struct usb_usbvision *usbvision);
 int usbvision_power_off(struct usb_usbvision *usbvision);
 int usbvision_power_on(struct usb_usbvision *usbvision);
 
-- 
2.1.4

