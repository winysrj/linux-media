Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from stipula.dds.nl ([85.17.178.134])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <miki@dds.nl>) id 1L0laR-0002S2-55
	for linux-dvb@linuxtv.org; Fri, 14 Nov 2008 00:26:56 +0100
From: Alain Kalker <miki@dds.nl>
To: Antti Palosaari <crope@iki.fi>
In-Reply-To: <491C4863.1030601@iki.fi>
References: <a40e5bb20a32b537a391.1226449195@miki-debian.ensch1.ov.home.nl>
	<491C4863.1030601@iki.fi>
Content-Type: multipart/mixed; boundary="=-zUf8GXx7T9wBp/mapv8V"
Date: Fri, 14 Nov 2008 00:27:24 +0100
Message-Id: <1226618844.6935.5.camel@miki-debian.ensch1.ov.home.nl>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add support for the Digittrade DVB-T
	USB	Stick	remote
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--=-zUf8GXx7T9wBp/mapv8V
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Op donderdag 13-11-2008 om 17:31 uur [tijdzone +0200], schreef Antti
Palosaari:
> Alain Kalker wrote:
> > From: Alain Kalker <miki@dds.nl>
> > 
> > Add support for the Digittrade DVB-T USB Stick remote.
> > As the Digittrade USB stick identifies itself as a generic AF9015 USB
> > device, the remote cannot be autodetected. To enable it, add the following
> > to /etc/modprobe.d/dvb-usb-af9015 or /etc/modprobe.conf:
> > 
> > options dvb-usb-af9015 remote=4
> 
> Could you lower case hex numbers used in ir-table and re-send patch 
> please? I think lower case is some rule of Linux Kernel.

Sure. I also included af9015 in the description to make it easier to
find in the log.

Kind regards,

Alain

--=-zUf8GXx7T9wBp/mapv8V
Content-Disposition: attachment; filename=9533.patch
Content-Type: text/x-patch; name=9533.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

# HG changeset patch
# User Alain Kalker <miki@dds.nl>
# Date 1226618096 -3600
# Node ID 3cb49e32bda278dc61ed7169262a7c30b2f6ad4d
# Parent  46604f47fca16225c854ad69c3d8a335c94d5448
af9015: Add support for the Digittrade DVB-T USB Stick remote

From: Alain Kalker <miki@dds.nl>

Add support for the Digittrade DVB-T USB Stick remote.
As the Digittrade USB stick identifies itself as a generic AF9015 USB
device, the remote cannot be autodetected. To enable it, add the following
to /etc/modprobe.d/dvb-usb-af9015 or /etc/modprobe.conf:

options dvb-usb-af9015 remote=4

Priority: normal

Signed-off-by: Alain Kalker <miki@dds.nl>

diff -r 46604f47fca1 -r 3cb49e32bda2 linux/drivers/media/dvb/dvb-usb/af9015.c
--- a/linux/drivers/media/dvb/dvb-usb/af9015.c	Fri Nov 07 15:24:18 2008 -0200
+++ b/linux/drivers/media/dvb/dvb-usb/af9015.c	Fri Nov 14 00:14:56 2008 +0100
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
diff -r 46604f47fca1 -r 3cb49e32bda2 linux/drivers/media/dvb/dvb-usb/af9015.h
--- a/linux/drivers/media/dvb/dvb-usb/af9015.h	Fri Nov 07 15:24:18 2008 -0200
+++ b/linux/drivers/media/dvb/dvb-usb/af9015.h	Fri Nov 14 00:14:56 2008 +0100
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
+	0x00, 0xff, 0x06, 0xf9, 0x13, 0x05, 0x00,
+	0x00, 0xff, 0x4d, 0xb2, 0x17, 0x01, 0x00,
+	0x00, 0xff, 0x1f, 0xe0, 0x2c, 0x00, 0x00,
+	0x00, 0xff, 0x0a, 0xf5, 0x15, 0x01, 0x00,
+	0x00, 0xff, 0x0e, 0xf1, 0x16, 0x01, 0x00,
+	0x00, 0xff, 0x09, 0xf6, 0x09, 0x01, 0x00,
+	0x00, 0xff, 0x01, 0xfe, 0x08, 0x01, 0x00,
+	0x00, 0xff, 0x05, 0xfa, 0x10, 0x01, 0x00,
+	0x00, 0xff, 0x02, 0xfd, 0x56, 0x00, 0x00,
+	0x00, 0xff, 0x40, 0xbf, 0x57, 0x00, 0x00,
+	0x00, 0xff, 0x19, 0xe6, 0x52, 0x00, 0x00,
+	0x00, 0xff, 0x17, 0xe8, 0x51, 0x00, 0x00,
+	0x00, 0xff, 0x10, 0xef, 0x0f, 0x01, 0x00,
+	0x00, 0xff, 0x54, 0xab, 0x27, 0x00, 0x00,
+	0x00, 0xff, 0x1b, 0xe4, 0x1e, 0x00, 0x00,
+	0x00, 0xff, 0x11, 0xee, 0x1f, 0x00, 0x00,
+	0x00, 0xff, 0x15, 0xea, 0x20, 0x00, 0x00,
+	0x00, 0xff, 0x12, 0xed, 0x21, 0x00, 0x00,
+	0x00, 0xff, 0x16, 0xe9, 0x22, 0x00, 0x00,
+	0x00, 0xff, 0x4c, 0xb3, 0x23, 0x00, 0x00,
+	0x00, 0xff, 0x48, 0xb7, 0x24, 0x00, 0x00,
+	0x00, 0xff, 0x04, 0xfb, 0x25, 0x00, 0x00,
+	0x00, 0xff, 0x00, 0xff, 0x26, 0x00, 0x00,
+	0x00, 0xff, 0x1e, 0xe1, 0x13, 0x03, 0x00,
+	0x00, 0xff, 0x1a, 0xe5, 0x13, 0x01, 0x00,
+	0x00, 0xff, 0x03, 0xfc, 0x17, 0x05, 0x00,
+	0x00, 0xff, 0x0d, 0xf2, 0x16, 0x05, 0x00,
+	0x00, 0xff, 0x1d, 0xe2, 0x40, 0x00, 0x00,
+};
+
 #endif

--=-zUf8GXx7T9wBp/mapv8V
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=-zUf8GXx7T9wBp/mapv8V--
