Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.seznam.cz ([77.75.72.43]:39241 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbZBAH1r (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Feb 2009 02:27:47 -0500
To: linux-media@vger.kernel.org
Subject: [PATCH][RESEND] Added support for AVerMedia Cardbus Hybrid remote control
From: Oldrich Jedlicka <oldium.pro@seznam.cz>
Date: Sun, 1 Feb 2009 07:58:24 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_QgUhJtorBxpLRRI"
Message-Id: <200902010758.24135.oldium.pro@seznam.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_QgUhJtorBxpLRRI
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all,

I've found a way to get the remote control for AVerMedia Cardbus Hybrid (and 
possibly other Cardbus cards like Cardbus Plus) work, so here is the patch 
for it. Currently only the Hybrid (E506R) uses it.

Patch was created against v4l-dvb Mercurial tree (22.1.2009), tested with 
vanilla 2.6.28.1. Works for me.

The first mail (22.1.2009 on Linux-DVB ML) didn't get any attention, so here 
is a "resend" version, now on unified Linux-media ML.

Enjoy (and please apply :-)). Comments are more than welcome.

Regards,
Oldrich.

--Boundary-00=_QgUhJtorBxpLRRI
Content-Type: text/x-diff;
  charset="us-ascii";
  name="avermedia-cardbus-remote.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="avermedia-cardbus-remote.patch"

# HG changeset patch
# User Old=C5=99ich Jedli=C4=8Dka <oldium.pro@seznam.cz>
# Date 1232648889 -3600
# Node ID 2b8e5fc5b41f12950de265a4459dbdeee03f1776
# Parent  66e0b01971de89076fcc9a7ef624b35d5451cbe4
Added support for AVerMedia Cardbus Hybrid remote control

=46rom: Old=C5=99ich Jedli=C4=8Dka <oldium.pro@seznam.cz>

Added support for I2C device at address 0x40 and subaddress 0x0d/0x0b
that provides remote control key reading support for AVerMedia Cardbus
Hybrid card, possibly for other AVerMedia Cardbus cards.

The I2C address 0x40 doesn't like the SAA7134's 0xfd quirk, so it was
disabled.

Priority: normal

Signed-off-by: Old=C5=99ich Jedli=C4=8Dka <oldium.pro@seznam.cz>

diff -r 66e0b01971de -r 2b8e5fc5b41f linux/drivers/media/common/ir-keymaps.c
=2D-- a/linux/drivers/media/common/ir-keymaps.c	Thu Jan 22 19:27:07 2009 +0=
100
+++ b/linux/drivers/media/common/ir-keymaps.c	Thu Jan 22 19:28:09 2009 +0100
@@ -154,6 +154,65 @@
 };
 EXPORT_SYMBOL_GPL(ir_codes_avermedia_m135a);
=20
+/* Oldrich Jedlicka <oldium.pro@seznam.cz> */
+IR_KEYTAB_TYPE ir_codes_avermedia_cardbus[IR_KEYTAB_SIZE] =3D {
+	[ 0x00 ] =3D KEY_POWER,
+	[ 0x01 ] =3D KEY_TUNER,		/* TV/FM */
+	[ 0x03 ] =3D KEY_TEXT,		/* Teletext */
+	[ 0x04 ] =3D KEY_EPG,
+	[ 0x05 ] =3D KEY_1,
+	[ 0x06 ] =3D KEY_2,
+	[ 0x07 ] =3D KEY_3,
+	[ 0x08 ] =3D KEY_AUDIO,
+	[ 0x09 ] =3D KEY_4,
+	[ 0x0a ] =3D KEY_5,
+	[ 0x0b ] =3D KEY_6,
+	[ 0x0c ] =3D KEY_ZOOM,		/* Full screen */
+	[ 0x0d ] =3D KEY_7,
+	[ 0x0e ] =3D KEY_8,
+	[ 0x0f ] =3D KEY_9,
+	[ 0x10 ] =3D KEY_PAGEUP,		/* 16-CH PREV */
+	[ 0x11 ] =3D KEY_0,
+	[ 0x12 ] =3D KEY_INFO,
+	[ 0x13 ] =3D KEY_AGAIN,		/* CH RTN - channel return */
+	[ 0x14 ] =3D KEY_MUTE,
+	[ 0x15 ] =3D KEY_EDIT,		/* Autoscan */
+	[ 0x17 ] =3D KEY_SAVE,		/* Screenshot */
+	[ 0x18 ] =3D KEY_PLAYPAUSE,
+	[ 0x19 ] =3D KEY_RECORD,
+	[ 0x1a ] =3D KEY_PLAY,
+	[ 0x1b ] =3D KEY_STOP,
+	[ 0x1c ] =3D KEY_FASTFORWARD,
+	[ 0x1d ] =3D KEY_REWIND,
+	[ 0x1e ] =3D KEY_VOLUMEDOWN,
+	[ 0x1f ] =3D KEY_VOLUMEUP,
+	[ 0x22 ] =3D KEY_SLEEP,		/* Sleep */
+	[ 0x23 ] =3D KEY_ZOOM,		/* Aspect */
+	[ 0x26 ] =3D KEY_SCREEN,		/* Pos */
+	[ 0x27 ] =3D KEY_ANGLE,		/* Size */
+	[ 0x28 ] =3D KEY_SELECT,		/* Select */
+	[ 0x29 ] =3D KEY_BLUE,		/* Blue/Picture */
+	[ 0x2a ] =3D KEY_BACKSPACE,	/* Back */
+	[ 0x2b ] =3D KEY_MEDIA,		/* PIP (Picture-in-picture) */
+	[ 0x2c ] =3D KEY_DOWN,
+	[ 0x2e ] =3D KEY_DOT,
+	[ 0x2f ] =3D KEY_TV,		/* Live TV */
+	[ 0x32 ] =3D KEY_LEFT,
+	[ 0x33 ] =3D KEY_CLEAR,		/* Clear */
+	[ 0x35 ] =3D KEY_RED,		/* Red/TV */
+	[ 0x36 ] =3D KEY_UP,
+	[ 0x37 ] =3D KEY_HOME,		/* Home */
+	[ 0x39 ] =3D KEY_GREEN,		/* Green/Video */
+	[ 0x3d ] =3D KEY_YELLOW,		/* Yellow/Music */
+	[ 0x3e ] =3D KEY_OK,		/* Ok */
+	[ 0x3f ] =3D KEY_RIGHT,
+	[ 0x40 ] =3D KEY_NEXT,		/* Next */
+	[ 0x41 ] =3D KEY_PREVIOUS,	/* Previous */
+	[ 0x42 ] =3D KEY_CHANNELDOWN,	/* Channel down */
+	[ 0x43 ] =3D KEY_CHANNELUP	/* Channel up */
+};
+EXPORT_SYMBOL_GPL(ir_codes_avermedia_cardbus);
+
 /* Attila Kondoros <attila.kondoros@chello.hu> */
 IR_KEYTAB_TYPE ir_codes_apac_viewcomp[IR_KEYTAB_SIZE] =3D {
=20
diff -r 66e0b01971de -r 2b8e5fc5b41f linux/drivers/media/video/ir-kbd-i2c.c
=2D-- a/linux/drivers/media/video/ir-kbd-i2c.c	Thu Jan 22 19:27:07 2009 +01=
00
+++ b/linux/drivers/media/video/ir-kbd-i2c.c	Thu Jan 22 19:28:09 2009 +0100
@@ -16,6 +16,8 @@
  *      Henry Wong <henry@stuffedcow.net>
  *      Mark Schultz <n9xmj@yahoo.com>
  *      Brian Rogers <brian_rogers@comcast.net>
+ * modified for AVerMedia Cardbus by
+ *      Oldrich Jedlicka <oldium.pro@seznam.cz>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -217,6 +219,46 @@
 	return 1;
 }
=20
+static int get_key_avermedia_cardbus(struct IR_i2c *ir,
+				     u32 *ir_key, u32 *ir_raw)
+{
+	unsigned char subaddr, key, keygroup;
+	struct i2c_msg msg[] =3D {{.addr=3Dir->c.addr, .flags=3D0, .buf=3D&subadd=
r,
+								.len =3D 1},
+				{.addr=3Dir->c.addr, .flags=3DI2C_M_RD, .buf=3D&key,
+								.len =3D 1}};
+	subaddr =3D 0x0d;
+	if (2 !=3D i2c_transfer(ir->c.adapter, msg, 2)) {
+		dprintk(1, "read error\n");
+		return -EIO;
+	}
+
+	if (key =3D=3D 0xff)
+		return 0;
+
+	subaddr =3D 0x0b;
+	msg[1].buf =3D &keygroup;
+	if (2 !=3D i2c_transfer(ir->c.adapter, msg, 2)) {
+		dprintk(1, "read error\n");
+		return -EIO;
+	}
+
+	if (keygroup =3D=3D 0xff)
+		return 0;
+
+	dprintk(1, "read key 0x%02x/0x%02x\n", key, keygroup);
+	if (keygroup < 2 || keygroup > 3) {
+		/* Only a warning */
+		dprintk(1, "warning: invalid key group 0x%02x for key 0x%02x\n",
+								keygroup, key);
+	}
+	key |=3D (keygroup & 1) << 6;
+
+	*ir_key =3D key;
+	*ir_raw =3D key;
+	return 1;
+}
+
 /* -----------------------------------------------------------------------=
 */
=20
 static void ir_key_poll(struct IR_i2c *ir)
@@ -369,6 +411,12 @@
 			ir_type     =3D IR_TYPE_OTHER;
 		}
 		break;
+	case 0x40:
+		name        =3D "AVerMedia Cardbus remote";
+		ir->get_key =3D get_key_avermedia_cardbus;
+		ir_type     =3D IR_TYPE_OTHER;
+		ir_codes    =3D ir_codes_avermedia_cardbus;
+		break;
 	default:
 		/* shouldn't happen */
 		printk(DEVNAME ": Huh? unknown i2c address (0x%02x)?\n", addr);
@@ -537,6 +585,22 @@
 			ir_attach(adap, msg.addr, 0, 0);
 	}
=20
+	/* Special case for AVerMedia Cardbus remote */
+	if (adap->id =3D=3D I2C_HW_SAA7134) {
+		unsigned char subaddr, data;
+		struct i2c_msg msg[] =3D {{.addr=3D0x40, .flags=3D0, .buf=3D&subaddr,
+								.len =3D 1},
+					{.addr=3D0x40, .flags=3DI2C_M_RD,
+							.buf=3D&data, .len =3D 1}};
+		subaddr =3D 0x0d;
+		rc =3D i2c_transfer(adap, msg, 2);
+		dprintk(1, "probe 0x%02x/0x%02x @ %s: %s\n",
+			msg[0].addr, subaddr, adap->name,
+			(2 =3D=3D rc) ? "yes" : "no");
+		if (2 =3D=3D rc)
+			ir_attach(adap, msg[0].addr, 0, 0);
+	}
+
 	return 0;
 }
=20
diff -r 66e0b01971de -r 2b8e5fc5b41f linux/drivers/media/video/saa7134/saa7=
134-cards.c
=2D-- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Jan 22 19:27:=
07 2009 +0100
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Jan 22 19:28:09=
 2009 +0100
@@ -6120,6 +6120,11 @@
 		msleep(10);
 		break;
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
+		saa7134_set_gpio(dev, 23, 0);
+		msleep(10);
+		saa7134_set_gpio(dev, 23, 1);
+		dev->has_remote =3D SAA7134_REMOTE_I2C;
+		break;
 	case SAA7134_BOARD_AVERMEDIA_M103:
 		saa7134_set_gpio(dev, 23, 0);
 		msleep(10);
diff -r 66e0b01971de -r 2b8e5fc5b41f linux/drivers/media/video/saa7134/saa7=
134-i2c.c
=2D-- a/linux/drivers/media/video/saa7134/saa7134-i2c.c	Thu Jan 22 19:27:07=
 2009 +0100
+++ b/linux/drivers/media/video/saa7134/saa7134-i2c.c	Thu Jan 22 19:28:09 2=
009 +0100
@@ -260,7 +260,7 @@
 			addr  =3D msgs[i].addr << 1;
 			if (msgs[i].flags & I2C_M_RD)
 				addr |=3D 1;
=2D			if (i > 0 && msgs[i].flags & I2C_M_RD) {
+			if (i > 0 && msgs[i].flags & I2C_M_RD && msgs[i].addr !=3D 0x40) {
 				/* workaround for a saa7134 i2c bug
 				 * needed to talk to the mt352 demux
 				 * thanks to pinnacle for the hint */
diff -r 66e0b01971de -r 2b8e5fc5b41f linux/include/media/ir-common.h
=2D-- a/linux/include/media/ir-common.h	Thu Jan 22 19:27:07 2009 +0100
+++ b/linux/include/media/ir-common.h	Thu Jan 22 19:28:09 2009 +0100
@@ -111,6 +111,7 @@
 extern IR_KEYTAB_TYPE ir_codes_avermedia[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_avermedia_dvbt[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_avermedia_m135a[IR_KEYTAB_SIZE];
+extern IR_KEYTAB_TYPE ir_codes_avermedia_cardbus[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_apac_viewcomp[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_pixelview[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_pixelview_new[IR_KEYTAB_SIZE];

--Boundary-00=_QgUhJtorBxpLRRI--
