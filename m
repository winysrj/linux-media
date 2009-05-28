Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:56843 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759177AbZE1Uok (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2009 16:44:40 -0400
Received: by fg-out-1718.google.com with SMTP id d23so1612889fga.17
        for <linux-media@vger.kernel.org>; Thu, 28 May 2009 13:44:42 -0700 (PDT)
Subject: [patch review 2/4] dsbr100: remove usb_dsbr100_open/close calls
From: Alexey Klimov <klimov.linux@gmail.com>
To: Linux Media <linux-media@vger.kernel.org>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain
Date: Fri, 29 May 2009 00:44:42 +0400
Message-Id: <1243543482.6713.42.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch removes usb_dsbr100_open and usb_dsbr100_close calls.
1. No need to start, set frequency, adjust parameters in open call.
2. This patch tackles issue with lock/unlock_kernel() in open call.
3. With this patch feature "Mute on exit?" in gnomeradio works.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r 5abb9dbc58d1 linux/drivers/media/radio/dsbr100.c
--- a/linux/drivers/media/radio/dsbr100.c	Tue May 19 15:05:21 2009 +0400
+++ b/linux/drivers/media/radio/dsbr100.c	Tue May 19 15:18:49 2009 +0400
@@ -127,8 +127,6 @@
 static int usb_dsbr100_probe(struct usb_interface *intf,
 			     const struct usb_device_id *id);
 static void usb_dsbr100_disconnect(struct usb_interface *intf);
-static int usb_dsbr100_open(struct file *file);
-static int usb_dsbr100_close(struct file *file);
 static int usb_dsbr100_suspend(struct usb_interface *intf,
 						pm_message_t message);
 static int usb_dsbr100_resume(struct usb_interface *intf);
@@ -545,50 +543,6 @@
 	return 0;
 }
 
-static int usb_dsbr100_open(struct file *file)
-{
-	struct dsbr100_device *radio = video_drvdata(file);
-	int retval;
-
-	lock_kernel();
-	radio->muted = 1;
-
-	retval = dsbr100_start(radio);
-	if (retval < 0) {
-		dev_warn(&radio->usbdev->dev,
-			 "Radio did not start up properly\n");
-		unlock_kernel();
-		return -EIO;
-	}
-
-	retval = dsbr100_setfreq(radio, radio->curfreq);
-	if (retval < 0)
-		dev_warn(&radio->usbdev->dev,
-			"set frequency failed\n");
-
-	unlock_kernel();
-	return 0;
-}
-
-static int usb_dsbr100_close(struct file *file)
-{
-	struct dsbr100_device *radio = video_drvdata(file);
-	int retval;
-
-	if (!radio)
-		return -ENODEV;
-
-	if (!radio->removed) {
-		retval = dsbr100_stop(radio);
-		if (retval < 0) {
-			dev_warn(&radio->usbdev->dev,
-				"dsbr100_stop failed\n");
-		}
-
-	}
-	return 0;
-}
-
 /* Suspend device - stop device. */
 static int usb_dsbr100_suspend(struct usb_interface *intf, pm_message_t message)
 {
@@ -632,8 +586,6 @@
 /* File system interface */
 static const struct v4l2_file_operations usb_dsbr100_fops = {
 	.owner		= THIS_MODULE,
-	.open		= usb_dsbr100_open,
-	.release	= usb_dsbr100_close,
 	.ioctl		= video_ioctl2,
 };
 


-- 
Best regards, Klimov Alexey

