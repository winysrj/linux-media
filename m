Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:13636 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbZKIWJ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 17:09:29 -0500
Received: by fg-out-1718.google.com with SMTP id d23so936990fga.1
        for <linux-media@vger.kernel.org>; Mon, 09 Nov 2009 14:09:34 -0800 (PST)
Date: Tue, 10 Nov 2009 01:09:49 +0300
From: Alexey Klimov <klimov.linux@gmail.com>
To: linux-media@vger.kernel.org
Cc: oliver@neukum.org, dougsland@gmail.com
Subject: [patch] radio-mr800 - autosuspend for radio-mr800 driver
Message-Id: <20091110010949.494ee080.klimov.linux@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


From: Oliver Neukum <oliver@neukum.org>

Patch adds autosuspend support for mr800 radio driver.

Priority: normal

Signed-off-by: Oliver Neukum <oliver@neukum.org>
Acked-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r 19c0469c02c3 linux/drivers/media/radio/radio-mr800.c
--- a/linux/drivers/media/radio/radio-mr800.c	Sat Nov 07 15:51:01 2009 -0200
+++ b/linux/drivers/media/radio/radio-mr800.c	Tue Nov 10 00:38:19 2009 +0300
@@ -133,6 +133,7 @@
 struct amradio_device {
 	/* reference to USB and video device */
 	struct usb_device *usbdev;
+	struct usb_interface *intf;
 	struct video_device videodev;
 	struct v4l2_device v4l2_dev;
 
@@ -166,7 +167,7 @@
 	.reset_resume		= usb_amradio_resume,
 #endif
 	.id_table		= usb_amradio_device_table,
-	.supports_autosuspend	= 0,
+	.supports_autosuspend	= 1,
 };
 
 /* switch on/off the radio. Send 8 bytes to device */
@@ -509,9 +510,15 @@
 	}
 
 	file->private_data = radio;
+	retval = usb_autopm_get_interface(radio->intf);
+	if (retval)
+		goto unlock;
 
-	if (unlikely(!radio->initialized))
+	if (unlikely(!radio->initialized)) {
 		retval = usb_amradio_init(radio);
+		if (retval)
+			usb_autopm_put_interface(radio->intf);
+	}
 
 unlock:
 	mutex_unlock(&radio->lock);
@@ -528,6 +535,8 @@
 
 	if (!radio->usbdev)
 		retval = -EIO;
+	else
+		usb_autopm_put_interface(radio->intf);
 
 	mutex_unlock(&radio->lock);
 	return retval;
@@ -669,6 +678,7 @@
 	radio->videodev.release = usb_amradio_video_device_release;
 
 	radio->usbdev = interface_to_usbdev(intf);
+	radio->intf = intf;
 	radio->curfreq = 95.16 * FREQ_MUL;
 
 	mutex_init(&radio->lock);



-- 
Alexey Klimov
