Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168]:51647 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759180AbZE1Uov (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2009 16:44:51 -0400
Received: by fxm12 with SMTP id 12so3977963fxm.37
        for <linux-media@vger.kernel.org>; Thu, 28 May 2009 13:44:52 -0700 (PDT)
Subject: [patch review 4/4] dsbr100: change radio->muted to radio->status,
 update suspend/resume
From: Alexey Klimov <klimov.linux@gmail.com>
To: Linux Media <linux-media@vger.kernel.org>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain
Date: Fri, 29 May 2009 00:44:48 +0400
Message-Id: <1243543488.6713.44.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch renames radio->muted to radio->status, add defines for that
variable, and fixes suspend/resume procedure. Radio->status set to
STOPPED in usb_dsbr100_probe because of removing open call.
Also, patch increases driver version.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r 8046021e508e linux/drivers/media/radio/dsbr100.c
--- a/linux/drivers/media/radio/dsbr100.c	Tue May 19 15:59:49 2009 +0400
+++ b/linux/drivers/media/radio/dsbr100.c	Tue May 19 17:55:35 2009 +0400
@@ -33,6 +33,10 @@
 
  History:
 
+ Version 0.46:
+	Removed usb_dsbr100_open/close calls and radio->users counter. Also,
+	radio->muted changed to radio->status and suspend/resume calls updated.
+
  Version 0.45:
 	Converted to v4l2_device.
 
@@ -101,8 +105,8 @@
  */
 #include <linux/version.h>	/* for KERNEL_VERSION MACRO	*/
 
-#define DRIVER_VERSION "v0.45"
-#define RADIO_VERSION KERNEL_VERSION(0, 4, 5)
+#define DRIVER_VERSION "v0.46"
+#define RADIO_VERSION KERNEL_VERSION(0, 4, 6)
 
 #define DRIVER_AUTHOR "Markus Demleitner <msdemlei@tucana.harvard.edu>"
 #define DRIVER_DESC "D-Link DSB-R100 USB FM radio driver"
@@ -122,6 +126,10 @@
 #define FREQ_MAX 108.0
 #define FREQ_MUL 16000
 
+/* defines for radio->status */
+#define STARTED	0
+#define STOPPED	1
+
 #define videodev_to_radio(d) container_of(d, struct dsbr100_device, videodev)
 
 static int usb_dsbr100_probe(struct usb_interface *intf,
@@ -145,7 +153,7 @@
 	int curfreq;
 	int stereo;
 	int removed;
-	int muted;
+	int status;
 };
 
 static struct usb_device_id usb_dsbr100_device_table [] = {
@@ -201,7 +209,7 @@
 		goto usb_control_msg_failed;
 	}
 
-	radio->muted = 0;
+	radio->status = STARTED;
 	mutex_unlock(&radio->lock);
 	return (radio->transfer_buffer)[0];
 
@@ -244,7 +252,7 @@
 		goto usb_control_msg_failed;
 	}
 
-	radio->muted = 1;
+	radio->status = STOPPED;
 	mutex_unlock(&radio->lock);
 	return (radio->transfer_buffer)[0];
 
@@ -473,7 +481,7 @@
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
-		ctrl->value = radio->muted;
+		ctrl->value = radio->status;
 		return 0;
 	}
 	return -EINVAL;
@@ -549,9 +557,21 @@
 	struct dsbr100_device *radio = usb_get_intfdata(intf);
 	int retval;
 
-	retval = dsbr100_stop(radio);
-	if (retval < 0)
-		dev_warn(&intf->dev, "dsbr100_stop failed\n");
+	if (radio->status == STARTED) {
+		retval = dsbr100_stop(radio);
+		if (retval < 0)
+			dev_warn(&intf->dev, "dsbr100_stop failed\n");
+
+		/* After dsbr100_stop() status set to STOPPED.
+		 * If we want driver to start radio on resume
+		 * we set status equal to STARTED.
+		 * On resume we will check status and run radio if needed.
+		 */
+
+		mutex_lock(&radio->lock);
+		radio->status = STARTED;
+		mutex_unlock(&radio->lock);
+	}
 
 	dev_info(&intf->dev, "going into suspend..\n");
 
@@ -564,9 +584,11 @@
 	struct dsbr100_device *radio = usb_get_intfdata(intf);
 	int retval;
 
-	retval = dsbr100_start(radio);
-	if (retval < 0)
-		dev_warn(&intf->dev, "dsbr100_start failed\n");
+	if (radio->status == STARTED) {
+		retval = dsbr100_start(radio);
+		if (retval < 0)
+			dev_warn(&intf->dev, "dsbr100_start failed\n");
+	}
 
 	dev_info(&intf->dev, "coming out of suspend..\n");
 
@@ -645,6 +667,7 @@
 	radio->removed = 0;
 	radio->usbdev = interface_to_usbdev(intf);
 	radio->curfreq = FREQ_MIN * FREQ_MUL;
+	radio->status = STOPPED;
 
 	video_set_drvdata(&radio->videodev, radio);
 



-- 
Best regards, Klimov Alexey

