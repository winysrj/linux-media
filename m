Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:37672 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbZBHTGq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Feb 2009 14:06:46 -0500
Mime-Version: 1.0 (Apple Message framework v753.1)
To: Patrick Boettcher <patrick.boettcher@desy.de>,
	pboettcher@dibcom.fr,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Message-Id: <B7621984-DEB8-4F0C-B5EF-733CD30E7441@alice-dsl.net>
Content-Type: multipart/mixed; boundary=Apple-Mail-16-261364785
Cc: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: [PATCH] Add Elgato EyeTV Diversity to dibcom driver
From: =?ISO-8859-1?Q?Michael_M=FCller?= <mueller_michael@alice-dsl.net>
Date: Sun, 8 Feb 2009 19:51:58 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Apple-Mail-16-261364785
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=ISO-8859-1;
	delsp=yes;
	format=flowed

This patch introduces support for DVB-T for the following dibcom =20
based card:
	Elgato EyeTV Diversity (USB-ID: 0fd9:0011)

Support for the Elgato silver IR remote is added too (set parameter =20
dvb_usb_dib0700_ir_proto=3D0)

Signed-off-by: Michael M=FCller <mueller_michael@alice-dsl.net>


--Apple-Mail-16-261364785
Content-Transfer-Encoding: 7bit
Content-Type: application/octet-stream;
	x-unix-mode=0777;
	name=ElgatoEyeTVDiversity.patch
Content-Disposition: attachment;
	filename=ElgatoEyeTVDiversity.patch

diff -r 71e5a36634ea linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Mon Feb 02 10:33:31 2009 +0100
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Sun Feb 08 19:27:42 2009 +0100
@@ -869,6 +869,43 @@
 	{ 0x1d, 0x37, KEY_RECORD },
 	{ 0x1d, 0x3b, KEY_GOTO },
 	{ 0x1d, 0x3d, KEY_POWER },
+
+	/* Key codes for the Elgato EyeTV Diversity silver remote,
+	   set dvb_usb_dib0700_ir_proto=0 */
+	{ 0x45, 0x01, KEY_POWER },
+	{ 0x45, 0x02, KEY_MUTE },
+	{ 0x45, 0x03, KEY_1 },
+	{ 0x45, 0x04, KEY_2 },
+	{ 0x45, 0x05, KEY_3 },
+	{ 0x45, 0x06, KEY_4 },
+	{ 0x45, 0x07, KEY_5 },
+	{ 0x45, 0x08, KEY_6 },
+	{ 0x45, 0x09, KEY_7 },
+	{ 0x45, 0x0a, KEY_8 },
+	{ 0x45, 0x0b, KEY_9 },
+	{ 0x45, 0x0c, KEY_LAST },
+	{ 0x45, 0x0d, KEY_0 },
+	{ 0x45, 0x0e, KEY_ENTER },
+	{ 0x45, 0x0f, KEY_RED },
+	{ 0x45, 0x10, KEY_CHANNELUP },
+	{ 0x45, 0x11, KEY_GREEN },
+	{ 0x45, 0x12, KEY_VOLUMEDOWN },
+	{ 0x45, 0x13, KEY_OK },
+	{ 0x45, 0x14, KEY_VOLUMEUP },
+	{ 0x45, 0x15, KEY_YELLOW },
+	{ 0x45, 0x16, KEY_CHANNELDOWN },
+	{ 0x45, 0x17, KEY_BLUE },
+	{ 0x45, 0x18, KEY_LEFT }, /* Skip backwards */
+	{ 0x45, 0x19, KEY_PLAYPAUSE },
+	{ 0x45, 0x1a, KEY_RIGHT }, /* Skip forward */
+	{ 0x45, 0x1b, KEY_REWIND },
+	{ 0x45, 0x1c, KEY_L }, /* Live */
+	{ 0x45, 0x1d, KEY_FASTFORWARD },
+	{ 0x45, 0x1e, KEY_STOP }, /* 'Reveal' for Teletext */
+	{ 0x45, 0x1f, KEY_MENU }, /* KEY_TEXT for Teletext */
+	{ 0x45, 0x40, KEY_RECORD }, /* Font 'Size' for Teletext */
+	{ 0x45, 0x41, KEY_SCREEN }, /*  Full screen toggle, 'Hold' for Teletext */
+	{ 0x45, 0x42, KEY_SELECT }, /* Select video input, 'Select' for Teletext */
 };
 
 /* STK7700P: Hauppauge Nova-T Stick, AVerMedia Volar */
@@ -1419,6 +1456,7 @@
 	{ USB_DEVICE(USB_VID_TERRATEC,	USB_PID_TERRATEC_CINERGY_T_EXPRESS) },
 	{ USB_DEVICE(USB_VID_TERRATEC,
 			USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY_2) },
+	{ USB_DEVICE(USB_VID_ELGATO,    USB_PID_ELGATO_EYETV_DIVERSITY) },
 	{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -1684,7 +1722,7 @@
 			}
 		},
 
-		.num_device_descs = 5,
+		.num_device_descs = 6,
 		.devices = {
 			{   "DiBcom STK7070PD reference design",
 				{ &dib0700_usb_id_table[17], NULL },
@@ -1705,7 +1743,11 @@
 			{  "Terratec Cinergy DT USB XS Diversity",
 				{ &dib0700_usb_id_table[43], NULL },
 				{ NULL },
-			}
+			},
+			{   "Elgato EyeTV Diversity",
+				{ &dib0700_usb_id_table[44], NULL },
+				{ NULL },
+			},
 		},
 		.rc_interval      = DEFAULT_RC_INTERVAL,
 		.rc_key_map       = dib0700_rc_keys,
diff -r 71e5a36634ea linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Mon Feb 02 10:33:31 2009 +0100
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Sun Feb 08 19:27:42 2009 +0100
@@ -27,6 +27,7 @@
 #define USB_VID_DIBCOM				0x10b8
 #define USB_VID_DPOSH				0x1498
 #define USB_VID_DVICO				0x0fe9
+#define USB_VID_ELGATO				0x0fd9
 #define USB_VID_EMPIA				0xeb1a
 #define USB_VID_GENPIX				0x09c0
 #define USB_VID_GRANDTEC			0x5032
@@ -237,5 +238,6 @@
 #define USB_PID_XTENSIONS_XD_380			0x0381
 #define USB_PID_TELESTAR_STARSTICK_2			0x8000
 #define USB_PID_MSI_DIGI_VOX_MINI_III                   0x8807
+#define USB_PID_ELGATO_EYETV_DIVERSITY			0x0011
 
 #endif

--Apple-Mail-16-261364785
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed



Hi Patrick,

several months ago I sent you a patch for the Elgato USB stick. At  
this time I was not happy with the problem of the repeated remote  
keys. Since this was fixed by Devin here it is again. The patch is  
against v4l-dvb from 7th Feb. 2009. So compared to the last time I  
only adjusted the index in the USB id table.

As written in the patch text you need to set parameter  
dvb_usb_dib0700_ir_proto=0 (default=1). Is there a way to overwrite  
the default for a specific device as mine? Or does this make no sense  
since the needed protocol is not driven by the USB stick IR receiver  
but the remote control?

BTW: In the meantime I needed to change my email adress.

Devin,

first I want tell you that after your changes the repeated IR keys  
are gone. Thanks.

In December you wrote that you 'should work on getting the dib0700  
driver integrated with ir_keymaps.c so that the it is consistent with  
other drivers.' Did you already started to work on this? Should I  
change my patch to use the ir_keymaps.c way? Which driver is a good  
example how to use it?

Regards

Michael

--Apple-Mail-16-261364785--
