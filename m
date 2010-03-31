Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay02.digicable.hu ([92.249.128.188]:39713 "EHLO
	relay02.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab0CaF5B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Mar 2010 01:57:01 -0400
Message-ID: <4BB2E42B.4090302@freemail.hu>
Date: Wed, 31 Mar 2010 07:56:59 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Krivchikov Sergei <sergei.krivchikov@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: genius islim 310 webcam test
References: <68c794d61003301249u138e643am20bb264375c3dfe1@mail.gmail.com>
In-Reply-To: <68c794d61003301249u138e643am20bb264375c3dfe1@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sergei,

Krivchikov Sergei wrote:
> Hi!
> I have a Genius iSlim 310 webcam and linux ubuntu 9.10 kernel 2.6.31. My
> developer level under linux - beginner (very beginner) :) but i'm ready
> to test this webcam undr linux. But I need the instructions:) How was
> your success in the launch of this webcam under Linux?
> 
> Sincerely, Sergei Krivchikov.

Currently the Genius iSlim 310 webcam is not supported by the mainline Linux
kernel, but I think that the support can be added very easily. See the
description at http://linuxtv.org/wiki/index.php/PixArt_PAC7301/PAC7302 why.

First thing what I'll need that you connect your Genius iSlim 310 to the Linux
box, open an xterm and send the output of "lsusb" command. Then we can find
out the USB ID of the device.

Also, please send the output of dmesg. The easiest way to do this is to redirect
the standard output to a file like this: "dmesg >dmesg.txt" and then send the
created file as an attachment.

The next thing is that you need to learn how to compile the Linux kernel
from source code. There is a description for Ubuntu at
https://help.ubuntu.com/community/Kernel/Compile . After you are able to
compile and install your new kernel, you can try to apply the patch in this
email, recompile the kernel, install the kernel and the modules,
unload the gspca_pac7302 kernel module ("rmmod gspca_pac7302"), and then
plug the webcam in order it can load the new kernel module. When you were
successful with these steps you'll see new messages in the output of "dmesg"
command. Please send this output also.

Finally, what you will also need is that the libv4l-0 package of Ubuntu
( http://packages.ubuntu.com/intrepid/libv4l-0 ) is installed on your computer.
This package you may have already installed.

These are the main points. Let's see how far you can proceed. Let me know
if you need further assistance.

Regards,

	Márton Németh

---
From: Márton Németh <nm127@freemail.hu>

On the schematics in PixArt PAC7301/PAC7302 datasheet
(http://www.pixart.com.tw/upload/PAC7301_7302%20%20Spec%20V1_20091228174030.pdf)
pages 19, 20, 21 and 22 there is a note titled "PID IO_TRAP" which describes
the possible product ID range 0x2620..0x262f. In this range there are some
known webcams, however, there are some PIDs with unknown or future devices.
Because PixArt PAC7301/PAC7302 is a System on a Chip (SoC) device is is
probable that this driver will work correctly independent of the used PID.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r dfa82cf98a85 linux/drivers/media/video/gspca/pac7302.c
--- a/linux/drivers/media/video/gspca/pac7302.c	Sat Jan 30 20:03:02 2010 +0100
+++ b/linux/drivers/media/video/gspca/pac7302.c	Sun Jan 31 11:08:21 2010 +0100
@@ -96,6 +96,7 @@
 	u8 flags;
 #define FL_HFLIP 0x01		/* mirrored by default */
 #define FL_VFLIP 0x02		/* vertical flipped by default */
+#define FL_EXPERIMENTAL 0x80	/* USB IDs based on heuristic without any known product */

 	u8 sof_read;
 	u8 autogain_ignore_frames;
@@ -1220,17 +1221,33 @@
 };

 /* -- module initialisation -- */
+/* Note on FL_EXPERIMENTAL:
+ * On the schematics in PixArt PAC7301/PAC7302 datasheet
+ * (http://www.pixart.com.tw/upload/PAC7301_7302%20%20Spec%20V1_20091228174030.pdf)
+ * pages 19, 20, 21 and 22 there is a note titled "PID IO_TRAP" which describes
+ * the possible product ID range 0x2620..0x262f. In this range there are some
+ * known webcams, however, there are some PIDs with unknown or future devices.
+ * Because PixArt PAC7301/PAC7302 is a System on a Chip (SoC) device is is
+ * probable that this driver will work correctly independent of the used PID.
+ */
 static const struct usb_device_id device_table[] __devinitconst = {
 	{USB_DEVICE(0x06f8, 0x3009)},
 	{USB_DEVICE(0x093a, 0x2620)},
 	{USB_DEVICE(0x093a, 0x2621)},
 	{USB_DEVICE(0x093a, 0x2622), .driver_info = FL_VFLIP},
+	{USB_DEVICE(0x093a, 0x2623), .driver_info = FL_EXPERIMENTAL },
 	{USB_DEVICE(0x093a, 0x2624), .driver_info = FL_VFLIP},
+	{USB_DEVICE(0x093a, 0x2625), .driver_info = FL_EXPERIMENTAL },
 	{USB_DEVICE(0x093a, 0x2626)},
+	{USB_DEVICE(0x093a, 0x2627), .driver_info = FL_EXPERIMENTAL },
 	{USB_DEVICE(0x093a, 0x2628)},
 	{USB_DEVICE(0x093a, 0x2629), .driver_info = FL_VFLIP},
 	{USB_DEVICE(0x093a, 0x262a)},
+	{USB_DEVICE(0x093a, 0x262b), .driver_info = FL_EXPERIMENTAL },
 	{USB_DEVICE(0x093a, 0x262c)},
+	{USB_DEVICE(0x093a, 0x262d), .driver_info = FL_EXPERIMENTAL },
+	{USB_DEVICE(0x093a, 0x262e), .driver_info = FL_EXPERIMENTAL },
+	{USB_DEVICE(0x093a, 0x262f), .driver_info = FL_EXPERIMENTAL },
 	{}
 };
 MODULE_DEVICE_TABLE(usb, device_table);
@@ -1239,6 +1256,17 @@
 static int __devinit sd_probe(struct usb_interface *intf,
 			const struct usb_device_id *id)
 {
+	if ((u8)id->driver_info & FL_EXPERIMENTAL) {
+		PDEBUG(D_ERR | D_PROBE, "WARNING: USB device ID %04x:%04x is "
+			"not known, but based on some heuristics this driver "
+			"tries to handle it.",
+			id->idVendor, id->idProduct);
+		PDEBUG(D_ERR | D_PROBE, "WARNING: Plase send an email to "
+			"linux-media@vger.kernel.org with 'lsusb -v' output, "
+			"the vendor and name of the product and whether the "
+			"device is working or not.");
+	}
+
 	return gspca_dev_probe(intf, id, &sd_desc, sizeof(struct sd),
 				THIS_MODULE);
 }

