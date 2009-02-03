Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:44655 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbZBCBJK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2009 20:09:10 -0500
Received: by fg-out-1718.google.com with SMTP id 16so763430fgg.17
        for <linux-media@vger.kernel.org>; Mon, 02 Feb 2009 17:09:09 -0800 (PST)
Subject: [patch review 8/8] radio-mr800: increase version and add comments
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org,
	David Ellingsworth <david@identd.dyndns.org>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 04:09:05 +0300
Message-Id: <1233623345.17456.264.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Increase driver version to 0.10, remove old and add new useful comments.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r e7bb8f79fc4e linux/drivers/media/radio/radio-mr800.c
--- a/linux/drivers/media/radio/radio-mr800.c	Mon Feb 02 21:08:27 2009 +0300
+++ b/linux/drivers/media/radio/radio-mr800.c	Tue Feb 03 02:52:09 2009 +0300
@@ -22,7 +22,7 @@
  */
 
 /*
- * Big thanks to authors of dsbr100.c and radio-si470x.c
+ * Big thanks to authors and contributors of dsbr100.c and radio-si470x.c
  *
  * When work was looked pretty good, i discover this:
  * http://av-usbradio.sourceforge.net/index.php
@@ -30,18 +30,23 @@
  * Latest release of theirs project was in 2005.
  * Probably, this driver could be improved trough using their
  * achievements (specifications given).
- * So, we have smth to begin with.
+ * Also, Faidon Liambotis <paravoid@debian.org> wrote nice driver for this radio
+ * in 2007. He allowed to use his driver to improve current mr800 radio driver.
+ * http://kerneltrap.org/mailarchive/linux-usb-devel/2007/10/11/342492
  *
- * History:
  * Version 0.01:	First working version.
  * 			It's required to blacklist AverMedia USB Radio
  * 			in usbhid/hid-quirks.c
+ * Version 0.10:	A lot of cleanups and fixes: unpluging the device,
+ * 			few mutex locks were added, codinstyle issues, etc.
+ * 			Added stereo support. Thanks to
+ * 			Douglas Schilling Landgraf <dougsland@gmail.com> and
+ * 			David Ellingsworth <david@identd.dyndns.org>
+ * 			for discussion, help and support.
  *
  * Many things to do:
  * 	- Correct power managment of device (suspend & resume)
- * 	- Make x86 independance (little-endian and big-endian stuff)
  * 	- Add code for scanning and smooth tuning
- * 	- Checked and add stereo&mono stuff
  * 	- Add code for sensitivity value
  * 	- Correct mistakes
  * 	- In Japan another FREQ_MIN and FREQ_MAX
@@ -63,8 +68,8 @@
 /* driver and module definitions */
 #define DRIVER_AUTHOR "Alexey Klimov <klimov.linux@gmail.com>"
 #define DRIVER_DESC "AverMedia MR 800 USB FM radio driver"
-#define DRIVER_VERSION "0.01"
-#define RADIO_VERSION KERNEL_VERSION(0, 0, 1)
+#define DRIVER_VERSION "0.10"
+#define RADIO_VERSION KERNEL_VERSION(0, 1, 0)
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
@@ -312,14 +317,11 @@
 	return retval;
 }
 
-
-
-/* USB subsystem interface begins here */
-
-/* handle unplugging of the device, release data structures
-if nothing keeps us from doing it.  If something is still
-keeping us busy, the release callback of v4l will take care
-of releasing it. */
+/* Handle unplugging the device.
+ * We call video_unregister_device in any case.
+ * The last function called in this procedure is
+ * usb_amradio_device_release.
+ */
 static void usb_amradio_disconnect(struct usb_interface *intf)
 {
 	struct amradio_device *radio = usb_get_intfdata(intf);


-- 
Best regards, Klimov Alexey

