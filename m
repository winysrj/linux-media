Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:24304 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932580AbZE0RvI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 13:51:08 -0400
MIME-Version: 1.0
Date: Wed, 27 May 2009 21:51:08 +0400
Message-ID: <208cbae30905271051jfe3294bye415b5b4cd0ce14b@mail.gmail.com>
Subject: Probably strange bug with usb radio-mr800
From: Alexey Klimov <klimov.linux@gmail.com>
To: Linux Media <linux-media@vger.kernel.org>,
	linux-usb@vger.kernel.org
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	Alexey Klimov <klimov.linux@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Doing some improvements in media/radio/radio-mr800.c i see very
strange situation.
I made simple patch that removed usb_amradio_open function. There is
no need in this function (no need to start/set frequency radio in open
procedure, and also removed lock/unlock_kernel() calls).
Here is this patch:

diff -r a344b328a34b linux/drivers/media/radio/radio-mr800.c
--- a/linux/drivers/media/radio/radio-mr800.c	Wed May 27 21:21:36 2009 +0400
+++ b/linux/drivers/media/radio/radio-mr800.c	Wed May 27 21:25:41 2009 +0400
@@ -119,7 +119,6 @@
 static int usb_amradio_probe(struct usb_interface *intf,
 			     const struct usb_device_id *id);
 static void usb_amradio_disconnect(struct usb_interface *intf);
-static int usb_amradio_open(struct file *file);
 static int usb_amradio_close(struct file *file);
 static int usb_amradio_suspend(struct usb_interface *intf,
 				pm_message_t message);
@@ -533,40 +532,6 @@
 	return 0;
 }

-/* open device - amradio_start() and amradio_setfreq() */
-static int usb_amradio_open(struct file *file)
-{
-	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
-	int retval;
-
-	lock_kernel();
-
-	radio->users = 1;
-	radio->muted = 1;
-
-	retval = amradio_set_mute(radio, AMRADIO_START);
-	if (retval < 0) {
-		amradio_dev_warn(&radio->videodev->dev,
-			"radio did not start up properly\n");
-		radio->users = 0;
-		unlock_kernel();
-		return -EIO;
-	}
-
-	retval = amradio_set_stereo(radio, WANT_STEREO);
-	if (retval < 0)
-		amradio_dev_warn(&radio->videodev->dev,
-			"set stereo failed\n");
-
-	retval = amradio_setfreq(radio, radio->curfreq);
-	if (retval < 0)
-		amradio_dev_warn(&radio->videodev->dev,
-			"set frequency failed\n");
-
-	unlock_kernel();
-	return 0;
-}
-
 /*close device */
 static int usb_amradio_close(struct file *file)
 {
@@ -623,7 +588,6 @@
 /* File system interface */
 static const struct v4l2_file_operations usb_amradio_fops = {
 	.owner		= THIS_MODULE,
-	.open		= usb_amradio_open,
 	.release	= usb_amradio_close,
 	.ioctl		= video_ioctl2,
 };

Then i test it. I have two machines: pentium-m and athlon 64 X2 dual
core. Kernel is 2.6.30-rc7 on both machines.
After patch such tools like fmtools, gnomeradio, kradio works fine
with radio. But mplayer didn't.

On 64bit machine mplayer didn't start radio. I ask usbmon to help me
and here is messages from usbmon:

cat /sys/kernel/debug/usbmon/2u
ffff880022e380c0 1662784522 S Io:2:003:2 -115:64 8 = 0055aa00 ab010000
(this message stops radio)
ffff880022e380c0 1662799160 C Io:2:003:2 0:64 8 >
ffff880022e380c0 1662799273 S Io:2:003:2 -115:64 8 = 0055aa00 ae000000
(this ask radio to have stereo signal)
ffff880022e380c0 1662831161 C Io:2:003:2 0:64 8 >
ffff880022e380c0 1662831439 S Io:2:003:2 -115:64 8 = 0055aa03 a4000008
(this and next message set frequency)
ffff880022e380c0 1662863161 C Io:2:003:2 0:64 8 >
ffff880022e380c0 1662863233 S Io:2:003:2 -115:64 8 = 1dd00100 00000000
ffff880022e380c0 1662895155 C Io:2:003:2 0:64 8 >
ffff880022e380c0 1662895190 S Io:2:003:2 -115:64 8 = 0055aa00 ab000000
(this message starts radio)
ffff880022e380c0 1662927156 C Io:2:003:2 0:64 8 >

Well, there is no sound from usb device after that.

On 32bit machine mplayer starts radio fine and works ok. Usbmon shows
me the same messages:

tux ~ # cat /sys/kernel/debug/usbmon/0u
f6530900 2647820070 S Io:2:002:2 -115:64 8 = 0055aa00 ab010000
f6530900 2647859740 C Io:2:002:2 0:64 8 >
f6530900 2647859825 S Io:2:002:2 -115:64 8 = 0055aa00 ae000000
f6530900 2647923747 C Io:2:002:2 0:64 8 >
f6530900 2647923942 S Io:2:002:2 -115:64 8 = 0055aa03 a4000008
f6530900 2647987749 C Io:2:002:2 0:64 8 >
f6530900 2647987766 S Io:2:002:2 -115:64 8 = 1dcf0100 00000000
f6530900 2648051747 C Io:2:002:2 0:64 8 >
f6530900 2648051775 S Io:2:002:2 -115:64 8 = 0055aa00 ab000000
f6530900 2648115753 C Io:2:002:2 0:64 8 >

So, the same messages to device works fine with radio on 32bit machine
and nothing on 64bit machine.
Good thing is if i add one more start message radio works on 64bit machine also.

Is this usb subsystem bug?
Should i make some workaround to deal with this and add comments about mplayer?

-- 
Best regards, Klimov Alexey
