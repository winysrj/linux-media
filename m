Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:50149 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753093Ab0HYNJC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Aug 2010 09:09:02 -0400
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] af9015: add USB ID for Terratec Cinergy T Stick RC MKII
Date: Wed, 25 Aug 2010 15:08:48 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008251508.51379.s.L-H@gmx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Adding the USB ID for my TerraTec Electronic GmbH Cinergy T RC MKII
[0ccd:0097] and hooking it up into af9015, on top of your new NXP TDA18218
patches, makes it work for me.

Just the shipped IR remote control doesn't seem to create keycode events
yet (tested with different remote=%d parameters), are there any hints to 
add support for that?

[    2.250022] usb 1-10: new high speed USB device using ehci_hcd and address 5
[    2.369287] usb 1-10: New USB device found, idVendor=0ccd, idProduct=0097
[    2.369290] usb 1-10: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.369293] usb 1-10: Product: USB2.0 DVB-T TV Stick
[    2.369294] usb 1-10: Manufacturer: NEWMI
[    2.369296] usb 1-10: SerialNumber: 010101010600001
[    2.534023] usbcore: registered new interface driver hiddev
[    2.537235] input: NEWMI USB2.0 DVB-T TV Stick as /devices/pci0000:00/0000:00:02.1/usb1/1-10/1-10:1.1/input/input0
[    2.537323] generic-usb 0003:0CCD:0097.0001: input,hidraw0: USB HID v1.01 Keyboard [NEWMI USB2.0 DVB-T TV Stick] on usb-0000:00:02.1-10/input1
[    2.537349] usbcore: registered new interface driver usbhid
[    2.537351] usbhid: USB HID core driver
[    3.263177] generic-usb 0003:04D9:1603.0002: input,hidraw1: USB HID v1.10 Keyboard [  USB Keyboard] on usb-0000:00:02.0-8.1/input0
[    3.286946] generic-usb 0003:04D9:1603.0003: input,hidraw2: USB HID v1.10 Device [  USB Keyboard] on usb-0000:00:02.0-8.1/input1
[    3.467136] generic-usb 0003:046D:C050.0004: input,hidraw3: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:02.0-8.2/input0
[    3.660890] generic-usb 0003:10D5:000D.0005: input,hidraw4: USB HID v1.10 Keyboard [No brand SP02-A1] on usb-0000:00:02.0-8.3/input0
[    5.567632] dvb-usb: found a 'TerraTec Cinergy T Stick RC' in cold state, will try to load a firmware
[    5.693497] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
[    5.773109] dvb-usb: found a 'TerraTec Cinergy T Stick RC' in warm state.
[    5.773168] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[    5.774290] DVB: registering new adapter (TerraTec Cinergy T Stick RC)
[    6.007696] af9013: firmware version:5.1.0
[    6.010843] DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
[    6.032697] tda18218: NXP TDA18218HN successfully identified.
[    6.034442] dvb-usb: TerraTec Cinergy T Stick RC successfully initialized and connected.
[    6.040612] usbcore: registered new interface driver dvb_usb_af9015

Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
---

This depends on the git pull request "NXP TDA18218 silicon tuner driver"
from Antti Palosaari <crope@iki.fi> and does not apply to -stable:
 * NXP TDA18218 silicon tuner driver
 * af9013: add support for tda18218 silicon tuner
 * af9015: add support for tda18218 silicon tuner

 drivers/media/dvb/dvb-usb/af9015.c      |    8 +++++++-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -1307,6 +1307,7 @@ static struct usb_device_id af9015_usb_t
 	{USB_DEVICE(USB_VID_LEADTEK,   USB_PID_WINFAST_DTV2000DS)},
 /* 30 */{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_UB383_T)},
 	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_395U_4)},
+	{USB_DEVICE(USB_VID_TERRATEC,  USB_PID_TERRATEC_CINERGY_T_STICK_RC)},
 	{0},
 };
 MODULE_DEVICE_TABLE(usb, af9015_usb_table);
@@ -1580,7 +1581,7 @@ static struct dvb_usb_device_properties
 
 		.i2c_algo = &af9015_i2c_algo,
 
-		.num_device_descs = 8, /* max 9 */
+		.num_device_descs = 9, /* max 9 */
 		.devices = {
 			{
 				.name = "AverMedia AVerTV Volar GPS 805 (A805)",
@@ -1625,6 +1626,11 @@ static struct dvb_usb_device_properties
 				.cold_ids = {&af9015_usb_table[30], NULL},
 				.warm_ids = {NULL},
 			},
+			{
+				.name = "TerraTec Cinergy T Stick RC",
+				.cold_ids = {&af9015_usb_table[32], NULL},
+				.warm_ids = {NULL},
+			},
 		}
 	},
 };
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -133,6 +133,7 @@
 #define USB_PID_KWORLD_VSTREAM_WARM			0x17df
 #define USB_PID_TERRATEC_CINERGY_T_USB_XE		0x0055
 #define USB_PID_TERRATEC_CINERGY_T_USB_XE_REV2		0x0069
+#define USB_PID_TERRATEC_CINERGY_T_STICK_RC		0x0097
 #define USB_PID_TWINHAN_VP7041_COLD			0x3201
 #define USB_PID_TWINHAN_VP7041_WARM			0x3202
 #define USB_PID_TWINHAN_VP7020_COLD			0x3203
