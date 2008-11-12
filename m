Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from stipula.dds.nl ([85.17.178.134])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <miki@dds.nl>) id 1L03SQ-0002Zh-Cd
	for linux-dvb@linuxtv.org; Wed, 12 Nov 2008 01:19:47 +0100
Received: from localhost (localhost [127.0.0.1])
	by stipula.dds.nl (Postfix) with ESMTP id F0494795FEE
	for <linux-dvb@linuxtv.org>; Wed, 12 Nov 2008 01:19:37 +0100 (CET)
Received: from miki-debian.ensch1.ov.home.nl (cc921761-b.ensch1.ov.home.nl
	[82.74.124.196]) (using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	by stipula.dds.nl (Postfix) with ESMTP id B3A3B795FDB
	for <linux-dvb@linuxtv.org>; Wed, 12 Nov 2008 01:19:37 +0100 (CET)
Received: from miki by miki-debian.ensch1.ov.home.nl with local (Exim 4.69)
	(envelope-from <miki@dds.nl>) id 1L03Sp-00060j-Dr
	for linux-dvb@linuxtv.org; Wed, 12 Nov 2008 01:20:07 +0100
MIME-Version: 1.0
Message-Id: <a40e5bb20a32b537a391.1226449195@miki-debian.ensch1.ov.home.nl>
Date: Wed, 12 Nov 2008 01:19:55 +0100
From: Alain Kalker <miki@dds.nl>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] [PATCH] Add support for the Digittrade DVB-T USB Stick
	remote
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

From: Alain Kalker <miki@dds.nl>

Add support for the Digittrade DVB-T USB Stick remote.
As the Digittrade USB stick identifies itself as a generic AF9015 USB
device, the remote cannot be autodetected. To enable it, add the following
to /etc/modprobe.d/dvb-usb-af9015 or /etc/modprobe.conf:

options dvb-usb-af9015 remote=4

Priority: normal

Signed-off-by: Alain Kalker <miki@dds.nl>

diff -r 46604f47fca1 -r a40e5bb20a32 linux/drivers/media/dvb/dvb-usb/af9015.c
--- a/linux/drivers/media/dvb/dvb-usb/af9015.c	Fri Nov 07 15:24:18 2008 -0200
+++ b/linux/drivers/media/dvb/dvb-usb/af9015.c	Wed Nov 12 00:54:49 2008 +0100
@@ -738,6 +738,16 @@
 				  af9015_ir_table_mygictv;
 				af9015_config.ir_table_size =
 				  ARRAY_SIZE(af9015_ir_table_mygictv);
+				break;
+			case AF9015_REMOTE_DIGITTRADE_DVB_T:
+				af9015_properties[i].rc_key_map =
+				  af9015_rc_keys_digittrade;
+				af9015_properties[i].rc_key_map_size =
+				  ARRAY_SIZE(af9015_rc_keys_digittrade);
+				af9015_config.ir_table =
+				  af9015_ir_table_digittrade;
+				af9015_config.ir_table_size =
+				  ARRAY_SIZE(af9015_ir_table_digittrade);
 				break;
 			}
 		} else {
diff -r 46604f47fca1 -r a40e5bb20a32 linux/drivers/media/dvb/dvb-usb/af9015.h
--- a/linux/drivers/media/dvb/dvb-usb/af9015.h	Fri Nov 07 15:24:18 2008 -0200
+++ b/linux/drivers/media/dvb/dvb-usb/af9015.h	Wed Nov 12 00:54:49 2008 +0100
@@ -123,6 +123,7 @@
 	AF9015_REMOTE_A_LINK_DTU_M,
 	AF9015_REMOTE_MSI_DIGIVOX_MINI_II_V3,
 	AF9015_REMOTE_MYGICTV_U718,
+	AF9015_REMOTE_DIGITTRADE_DVB_T,
 };
 
 /* Leadtek WinFast DTV Dongle Gold */
@@ -596,4 +597,67 @@
 	0x03, 0xfc, 0x03, 0xfc, 0x0e, 0x05, 0x00,
 };
 
+/* Digittrade DVB-T USB Stick */
+static struct dvb_usb_rc_key af9015_rc_keys_digittrade[] = {
+	{ 0x01, 0x0f, KEY_LAST },	/* RETURN */
+	{ 0x05, 0x17, KEY_TEXT },	/* TELETEXT */
+	{ 0x01, 0x08, KEY_EPG },	/* EPG */
+	{ 0x05, 0x13, KEY_POWER },	/* POWER */
+	{ 0x01, 0x09, KEY_ZOOM },	/* FULLSCREEN */
+	{ 0x00, 0x40, KEY_AUDIO },	/* DUAL SOUND */
+	{ 0x00, 0x2c, KEY_PRINT },	/* SNAPSHOT */
+	{ 0x05, 0x16, KEY_SUBTITLE },	/* SUBTITLE */
+	{ 0x00, 0x52, KEY_CHANNELUP },	/* CH Up */
+	{ 0x00, 0x51, KEY_CHANNELDOWN },/* Ch Dn */
+	{ 0x00, 0x57, KEY_VOLUMEUP },	/* Vol Up */
+	{ 0x00, 0x56, KEY_VOLUMEDOWN },	/* Vol Dn */
+	{ 0x01, 0x10, KEY_MUTE },	/* MUTE */
+	{ 0x00, 0x27, KEY_0 },
+	{ 0x00, 0x1e, KEY_1 },
+	{ 0x00, 0x1f, KEY_2 },
+	{ 0x00, 0x20, KEY_3 },
+	{ 0x00, 0x21, KEY_4 },
+	{ 0x00, 0x22, KEY_5 },
+	{ 0x00, 0x23, KEY_6 },
+	{ 0x00, 0x24, KEY_7 },
+	{ 0x00, 0x25, KEY_8 },
+	{ 0x00, 0x26, KEY_9 },
+	{ 0x01, 0x17, KEY_PLAYPAUSE },	/* TIMESHIFT */
+	{ 0x01, 0x15, KEY_RECORD },	/* RECORD */
+	{ 0x03, 0x13, KEY_PLAY },	/* PLAY */
+	{ 0x01, 0x16, KEY_STOP },	/* STOP */
+	{ 0x01, 0x13, KEY_PAUSE },	/* PAUSE */
+};
+
+static u8 af9015_ir_table_digittrade[] = {
+	0x00, 0xFF, 0x06, 0xF9, 0x13, 0x05, 0x00,
+	0x00, 0xFF, 0x4D, 0xB2, 0x17, 0x01, 0x00,
+	0x00, 0xFF, 0x1F, 0xE0, 0x2C, 0x00, 0x00,
+	0x00, 0xFF, 0x0A, 0xF5, 0x15, 0x01, 0x00,
+	0x00, 0xFF, 0x0E, 0xF1, 0x16, 0x01, 0x00,
+	0x00, 0xFF, 0x09, 0xF6, 0x09, 0x01, 0x00,
+	0x00, 0xFF, 0x01, 0xFE, 0x08, 0x01, 0x00,
+	0x00, 0xFF, 0x05, 0xFA, 0x10, 0x01, 0x00,
+	0x00, 0xFF, 0x02, 0xFD, 0x56, 0x00, 0x00,
+	0x00, 0xFF, 0x40, 0xBF, 0x57, 0x00, 0x00,
+	0x00, 0xFF, 0x19, 0xE6, 0x52, 0x00, 0x00,
+	0x00, 0xFF, 0x17, 0xE8, 0x51, 0x00, 0x00,
+	0x00, 0xFF, 0x10, 0xEF, 0x0F, 0x01, 0x00,
+	0x00, 0xFF, 0x54, 0xAB, 0x27, 0x00, 0x00,
+	0x00, 0xFF, 0x1B, 0xE4, 0x1E, 0x00, 0x00,
+	0x00, 0xFF, 0x11, 0xEE, 0x1F, 0x00, 0x00,
+	0x00, 0xFF, 0x15, 0xEA, 0x20, 0x00, 0x00,
+	0x00, 0xFF, 0x12, 0xED, 0x21, 0x00, 0x00,
+	0x00, 0xFF, 0x16, 0xE9, 0x22, 0x00, 0x00,
+	0x00, 0xFF, 0x4C, 0xB3, 0x23, 0x00, 0x00,
+	0x00, 0xFF, 0x48, 0xB7, 0x24, 0x00, 0x00,
+	0x00, 0xFF, 0x04, 0xFB, 0x25, 0x00, 0x00,
+	0x00, 0xFF, 0x00, 0xFF, 0x26, 0x00, 0x00,
+	0x00, 0xFF, 0x1E, 0xE1, 0x13, 0x03, 0x00,
+	0x00, 0xFF, 0x1A, 0xE5, 0x13, 0x01, 0x00,
+	0x00, 0xFF, 0x03, 0xFC, 0x17, 0x05, 0x00,
+	0x00, 0xFF, 0x0D, 0xF2, 0x16, 0x05, 0x00,
+	0x00, 0xFF, 0x1D, 0xE2, 0x40, 0x00, 0x00,
+};
+
 #endif

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
