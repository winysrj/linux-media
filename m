Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:58776 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab0AaKUB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jan 2010 05:20:01 -0500
Message-ID: <4B655949.50102@freemail.hu>
Date: Sun, 31 Jan 2010 11:19:53 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	Thomas Kaiser <thomas@kaiser-linux.li>,
	Hans de Goede <hdegoede@redhat.com>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH, RFC] gspca pac7302: add USB PID range based on heuristics
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

as I was reading the PixArt PAC7301/PAC7302 datasheet
( http://www.pixart.com.tw/upload/PAC7301_7302%20%20Spec%20V1_20091228174030.pdf )
I recognised a little description on the schematics. This is about how to
set up the USB Product ID from range 0x2620..0x262f via hardware wires.

I had the idea that the list of supported devices could be extended with the full
range because the System on a Chip internals will not change just because it is
configured to a different USB Product ID.

I don't know much about the maintenance implications that's why I'm very
much listening to the comments of this idea.

So, what do you think?

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
