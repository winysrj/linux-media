Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail21.extendcp.co.uk ([79.170.40.21])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mailing-lists@enginuities.com>) id 1LiBlU-0003lC-Rw
	for linux-dvb@linuxtv.org; Fri, 13 Mar 2009 19:05:50 +0100
Received: from 220-244-17-151.static.tpgi.com.au ([220.244.17.151]
	helo=cobra.localnet) by mail21.extendcp.com with esmtpa (Exim 4.63)
	id 1LiBlQ-00052V-Mv
	for linux-dvb@linuxtv.org; Fri, 13 Mar 2009 18:05:45 +0000
From: Stuart <mailing-lists@enginuities.com>
To: linux-dvb@linuxtv.org
Date: Sat, 14 Mar 2009 05:06:00 +1100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903140506.00723.mailing-lists@enginuities.com>
Subject: [linux-dvb] Patch for DigitalNow TinyTwin remote.
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

First of all, thanks to those involved in getting the TinyTwin working!

I haven't found any support for the remote control yet so I would like to offer what I've managed to do so far (in case I've done something wrong as this is the first time I've tried to submit a patch).

The remote I'm referring to is pictured here (albeit with a few buttons labeled differently):

http://www.digitalnow.com.au/images/ProRemote.jpg

I extracted an ir table from the .bin file located in:

http://www.digitalnow.com.au/DNTV/TinyTwinRemote4MCE.zip
(listed at the bottom of http://www.digitalnow.com.au/downloads.html)

After changing linux/drivers/media/dvb/dvb-usb/af9015.[ch] I got a response from the remote, however, it would auto-repeat indefinitely. I believe this is caused by no "key up" event with the usbhid driver. To stop usbhid from attaching to the device I've modified a 
couple of files in the kernel. This appears to leave dvb-usb-af9015 in charge of creating events for the remote by polling (is this the correct method to go about it?).

Some keys don't work (I don't know if it's possible to get them working with a revised ir table), they're labeled on the remote as:

Tab, Capture, PIP, L/R, Recall, Zoom-, Red

The included patches apply to the following versions:

af9015: a57ea2073e77
kernel: 2.6.29_rc7

I'm not sure if this is the correct approach, however, it seems to be working for me so any feedback would be appreciated!

Stuart

af9015_tinytwin_remote_patch.diff:
--- orig/linux/drivers/media/dvb/dvb-usb/af9015.c	2009-01-24 09:23:23.000000000 +1100
+++ modified/linux/drivers/media/dvb/dvb-usb/af9015.c	2009-03-13 21:08:05.000000000 +1100
@@ -782,6 +785,16 @@ static int af9015_read_config(struct usb
 					  af9015_ir_table_twinhan;
 					af9015_config.ir_table_size =
 					  ARRAY_SIZE(af9015_ir_table_twinhan);
+				} else if (udev->descriptor.idProduct ==
+				cpu_to_le16(USB_PID_TINYTWIN)) {
+					af9015_properties[i].rc_key_map =
+					  af9015_rc_keys_tinytwin;
+					af9015_properties[i].rc_key_map_size =
+					  ARRAY_SIZE(af9015_rc_keys_tinytwin);
+					af9015_config.ir_table =
+					  af9015_ir_table_tinytwin;
+					af9015_config.ir_table_size =
+					  ARRAY_SIZE(af9015_ir_table_tinytwin);
 				}
 				break;
 			case USB_VID_KWORLD_2:
--- orig/linux/drivers/media/dvb/dvb-usb/af9015.h	2009-01-24 09:23:23.000000000 +1100
+++ modified/linux/drivers/media/dvb/dvb-usb/af9015.h	2009-03-13 21:08:05.000000000 +1100
@@ -127,6 +127,105 @@ enum af9015_remote {
 	AF9015_REMOTE_AVERMEDIA_KS,
 };
 
+/* Tiny Twin */
+static struct dvb_usb_rc_key af9015_rc_keys_tinytwin[] = {
+	{0x00, 0x1e, KEY_1},			/* 1 */
+	{0x00, 0x1f, KEY_2},			/* 2 */
+	{0x00, 0x20, KEY_3},			/* 3 */
+	{0x00, 0x21, KEY_4},			/* 4 */
+	{0x00, 0x22, KEY_5},			/* 5 */
+	{0x00, 0x23, KEY_6},			/* 6 */
+	{0x00, 0x24, KEY_7},			/* 7 */
+	{0x00, 0x25, KEY_8},			/* 8 */
+	{0x00, 0x26, KEY_9},			/* 9 */
+	{0x00, 0x27, KEY_0},			/* 0 */
+	{0x00, 0x28, KEY_ENTER},		/* Enter/ok */
+	{0x00, 0x29, KEY_CANCEL},		/* Cancel */
+	{0x00, 0x2a, KEY_BACK},			/* Back */
+	{0x00, 0x41, KEY_MUTE},			/* Mute */
+	{0x00, 0x42, KEY_VOLUMEDOWN},		/* VOL- */
+	{0x00, 0x43, KEY_VOLUMEUP},		/* VOL+ */
+	{0x00, 0x4b, KEY_CHANNELUP},		/* CH+ */
+	{0x00, 0x4c, KEY_CLEAR},		/* Clear */
+	{0x00, 0x4e, KEY_CHANNELDOWN},		/* CH- */
+	{0x00, 0x4f, KEY_RIGHT},		/* Right */
+	{0x00, 0x50, KEY_LEFT},			/* Left */
+	{0x00, 0x51, KEY_DOWN},			/* Down */
+	{0x00, 0x52, KEY_UP},			/* Up */
+	{0x01, 0x04, KEY_INFO},			/* Preview */
+	{0x01, 0x05, KEY_PREVIOUS},		/* Replay */
+	{0x01, 0x07, KEY_EPG},			/* Info/EPG */
+	{0x01, 0x08, KEY_BLUE},			/* Blue */
+	{0x01, 0x09, KEY_NEXT},			/* Skip */
+	{0x01, 0x0a, KEY_FAVORITES},		/* Favourites */
+	{0x01, 0x0c, KEY_YELLOW},		/* Yellow */
+	{0x01, 0x10, KEY_GREEN},		/* Green */
+	{0x01, 0x12, KEY_LIST},			/* Record List */
+	{0x01, 0x13, KEY_PAUSE},		/* Pause */
+	{0x01, 0x15, KEY_RECORD},		/* REC */
+	{0x01, 0x17, KEY_TEXT},			/* Teletext */
+	{0x03, 0x04, KEY_LANGUAGE},		/* SAP */
+	{0x03, 0x05, KEY_REWIND},		/* FR */
+	{0x03, 0x06, KEY_SUBTITLE},		/* Subtitle/CC */
+	{0x03, 0x09, KEY_FASTFORWARD},		/* FF */
+	{0x03, 0x13, KEY_PLAY},			/* Play */
+	{0x03, 0x16, KEY_STOP},			/* Stop */
+	{0x03, 0x17, KEY_SWITCHVIDEOMODE},	/* A/V */
+	{0x03, 0x1d, KEY_ZOOMIN},		/* Zoom+ */
+	{0x04, 0x28, KEY_ZOOM},			/* Full Screen */
+	{0x04, 0x3d, KEY_SLEEP},		/* Hibernate */
+	{0x0c, 0x28, KEY_POWER},		/* Power */
+};
+
+static u8 af9015_ir_table_tinytwin[] = {
+	0x00, 0xff, 0x16, 0xe9, 0x28, 0x0c, 0x00, /* Power */
+	0x00, 0xff, 0x17, 0xe8, 0x0a, 0x01, 0x00, /* Favourites */
+	0x00, 0xff, 0x1c, 0xe3, 0x07, 0x01, 0x00, /* Info/EPG */
+	0x00, 0xff, 0x04, 0xfb, 0x12, 0x01, 0x00, /* Record List */
+	0x00, 0xff, 0x03, 0xfc, 0x1e, 0x00, 0x00, /* 1 */
+	0x00, 0xff, 0x01, 0xfe, 0x1f, 0x00, 0x00, /* 2 */
+	0x00, 0xff, 0x06, 0xf9, 0x20, 0x00, 0x00, /* 3 */
+	0x00, 0xff, 0x09, 0xf6, 0x21, 0x00, 0x00, /* 4 */
+	0x00, 0xff, 0x1d, 0xe2, 0x22, 0x00, 0x00, /* 5 */
+	0x00, 0xff, 0x1f, 0xe0, 0x23, 0x00, 0x00, /* 6 */
+	0x00, 0xff, 0x0d, 0xf2, 0x24, 0x00, 0x00, /* 7 */
+	0x00, 0xff, 0x19, 0xe6, 0x25, 0x00, 0x00, /* 8 */
+	0x00, 0xff, 0x1b, 0xe4, 0x26, 0x00, 0x00, /* 9 */
+	0x00, 0xff, 0x0c, 0xf3, 0x29, 0x00, 0x00, /* Cancel */
+	0x00, 0xff, 0x15, 0xea, 0x27, 0x00, 0x00, /* 0 */
+	0x00, 0xff, 0x4a, 0xb5, 0x4c, 0x00, 0x00, /* Clear */
+	0x00, 0xff, 0x13, 0xec, 0x2a, 0x00, 0x00, /* Back */
+	0x00, 0xff, 0x4b, 0xb4, 0x52, 0x00, 0x00, /* Up */
+	0x00, 0xff, 0x4e, 0xb1, 0x50, 0x00, 0x00, /* Left */
+	0x00, 0xff, 0x4f, 0xb0, 0x28, 0x00, 0x00, /* Enter/ok */
+	0x00, 0xff, 0x52, 0xad, 0x4f, 0x00, 0x00, /* Right */
+	0x00, 0xff, 0x51, 0xae, 0x51, 0x00, 0x00, /* Down */
+	0x00, 0xff, 0x1e, 0xe1, 0x43, 0x00, 0x00, /* VOL+ */
+	0x00, 0xff, 0x0a, 0xf5, 0x42, 0x00, 0x00, /* VOL- */
+	0x00, 0xff, 0x02, 0xfd, 0x4e, 0x00, 0x00, /* CH- */
+	0x00, 0xff, 0x05, 0xfa, 0x4b, 0x00, 0x00, /* CH+ */
+	0x00, 0xff, 0x11, 0xee, 0x15, 0x01, 0x00, /* REC */
+	0x00, 0xff, 0x14, 0xeb, 0x13, 0x03, 0x00, /* Play */
+	0x00, 0xff, 0x4c, 0xb3, 0x13, 0x01, 0x00, /* Pause */
+	0x00, 0xff, 0x1a, 0xe5, 0x16, 0x03, 0x00, /* Stop */
+	0x00, 0xff, 0x40, 0xbf, 0x05, 0x03, 0x00, /* FR */
+	0x00, 0xff, 0x12, 0xed, 0x09, 0x03, 0x00, /* FF */
+	0x00, 0xff, 0x41, 0xbe, 0x05, 0x01, 0x00, /* Replay */
+	0x00, 0xff, 0x42, 0xbd, 0x09, 0x01, 0x00, /* Skip */
+	0x00, 0xff, 0x50, 0xaf, 0x04, 0x03, 0x00, /* SAP */
+	0x00, 0xff, 0x4d, 0xb2, 0x28, 0x04, 0x00, /* Full Screen */
+	0x00, 0xff, 0x10, 0xef, 0x41, 0x00, 0x00, /* Mute */
+	0x00, 0xff, 0x43, 0xbc, 0x06, 0x03, 0x00, /* Subtitle/CC */
+	0x00, 0xff, 0x45, 0xba, 0x1d, 0x03, 0x00, /* Zoom+ */
+	0x00, 0xff, 0x0f, 0xf0, 0x17, 0x01, 0x00, /* Teletext */
+	0x00, 0xff, 0x08, 0xf7, 0x17, 0x03, 0x00, /* A/V */
+	0x00, 0xff, 0x53, 0xac, 0x10, 0x01, 0x00, /* Green */
+	0x00, 0xff, 0x5f, 0xa0, 0x08, 0x01, 0x00, /* Blue */
+	0x00, 0xff, 0x5e, 0xa1, 0x0c, 0x01, 0x00, /* Yellow */
+	0x00, 0xff, 0x48, 0xb7, 0x04, 0x01, 0x00, /* Preview */
+	0x00, 0xff, 0x07, 0xf8, 0x3d, 0x04, 0x00, /* Hibernate */
+};
+
 /* Leadtek WinFast DTV Dongle Gold */
 static struct dvb_usb_rc_key af9015_rc_keys_leadtek[] = {
 	{ 0x00, 0x1e, KEY_1 },

kernel-2.6.29_rc7_tinytwin_remote_patch.diff:
--- orig/drivers/hid/hid-ids.h	2009-03-13 22:50:05.000000000 +1100
+++ modified/drivers/hid/hid-ids.h	2009-03-13 22:52:10.000000000 +1100
@@ -420,4 +420,7 @@
 #define USB_VENDOR_ID_KYE		0x0458
 #define USB_DEVICE_ID_KYE_GPEN_560	0x5003
 
+#define USB_VENDOR_ID_DIGITALNOW	0x13d3
+#define USB_DEVICE_ID_DIGITALNOW_TINYTWIN	0x3226
+
 #endif
--- orig/drivers/hid/hid-core.c	2009-03-13 22:50:05.000000000 +1100
+++ modified/drivers/hid/hid-core.c	2009-03-13 22:52:47.000000000 +1100
@@ -1629,6 +1629,7 @@ static const struct hid_device_id hid_ig
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WISEGROUP, USB_DEVICE_ID_1_PHIDGETSERVO_20) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WISEGROUP, USB_DEVICE_ID_8_8_4_IF_KIT) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_YEALINK, USB_DEVICE_ID_YEALINK_P1K_P4K_B2K) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_DIGITALNOW, USB_DEVICE_ID_DIGITALNOW_TINYTWIN) },
 	{ }
 };
 



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
