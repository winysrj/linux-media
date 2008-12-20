Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBK39V8G026911
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 22:09:31 -0500
Received: from mail-ew0-f21.google.com (mail-ew0-f21.google.com
	[209.85.219.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBK39HKT011487
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 22:09:17 -0500
Received: by ewy14 with SMTP id 14so1312355ewy.3
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 19:09:17 -0800 (PST)
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain
Date: Sat, 20 Dec 2008 06:09:32 +0300
Message-Id: <1229742572.10297.116.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: [review patch 4/5] dsbr100: fix and add rigth comments
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Fixing and adding right comments. Few empty lines are removed.

---
diff -r 91319c812b7b linux/drivers/media/radio/dsbr100.c
--- a/linux/drivers/media/radio/dsbr100.c	Sat Dec 20 05:29:58 2008 +0300
+++ b/linux/drivers/media/radio/dsbr100.c	Sat Dec 20 05:35:13 2008 +0300
@@ -1,5 +1,5 @@
-/* A driver for the D-Link DSB-R100 USB radio.  The R100 plugs
- into both the USB and an analog audio input, so this thing
+/* A driver for the D-Link DSB-R100 USB radio and Gemtek USB Radio 21.
+ The device plugs into both the USB and an analog audio input, so this thing
  only deals with initialisation and frequency setting, the
  audio data has to be handled by a sound driver.
 
@@ -173,7 +173,6 @@
 	int muted;
 };
 
-
 static struct usb_device_id usb_dsbr100_device_table [] = {
 	{ USB_DEVICE(DSB100_VENDOR, DSB100_PRODUCT) },
 	{ }						/* Terminating entry */
@@ -226,7 +225,6 @@
 	mutex_unlock(&radio->lock);
 	return (radio->transfer_buffer)[0];
 }
-
 
 /* switch off radio */
 static int dsbr100_stop(struct dsbr100_device *radio)
@@ -320,13 +318,14 @@
 	mutex_unlock(&radio->lock);
 }
 
-
 /* USB subsystem interface begins here */
 
-/* handle unplugging of the device, release data structures
-if nothing keeps us from doing it.  If something is still
-keeping us busy, the release callback of v4l will take care
-of releasing it. */
+/*
+ * Handle unplugging of the device.
+ * We call video_unregister_device in any case.
+ * The last function called in this procedure is
+ * usb_dsbr100_video_device_release
+ */
 static void usb_dsbr100_disconnect(struct usb_interface *intf)
 {
 	struct dsbr100_device *radio = usb_get_intfdata(intf);
@@ -597,6 +596,7 @@
 	return 0;
 }
 
+/* free data structures */
 static void usb_dsbr100_video_device_release(struct video_device *videodev)
 {
 	struct dsbr100_device *radio = videodev_to_radio(videodev);
@@ -640,8 +640,7 @@
 	.release	= usb_dsbr100_video_device_release,
 };
 
-/* check if the device is present and register with v4l and
-usb if it is */
+/* check if the device is present and register with v4l and usb if it is */
 static int usb_dsbr100_probe(struct usb_interface *intf,
 				const struct usb_device_id *id)
 {



-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
