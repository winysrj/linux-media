Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.seznam.cz ([77.75.72.43]:18229 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbZBLGnS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Feb 2009 01:43:18 -0500
From: =?utf-8?q?Old=C5=99ich_Jedli=C4=8Dka?= <oldium.pro@seznam.cz>
Subject: [PATCH] Added support for AVerMedia Cardbus Hybrid remote control
Date: Thu, 12 Feb 2009 07:43:11 +0100
MIME-Version: 1.0
Content-Disposition: inline
To: linux-media@vger.kernel.org
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200902120743.11615.oldium.pro@seznam.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added support for I2C device at address 0x40 and subaddress 0x0d/0x0b
that provides remote control key reading support for AVerMedia Cardbus
Hybrid card, possibly for other AVerMedia Cardbus cards.

The I2C address 0x40 doesn't like the SAA7134's 0xfd quirk, so it was
disabled.

Signed-off-by: Oldřich Jedlička <oldium.pro@seznam.cz>
---
diff -r 66e0b01971de -r 2b8e5fc5b41f linux/drivers/media/common/ir-keymaps.c
--- a/linux/drivers/media/common/ir-keymaps.c	Thu Jan 22 19:27:07 2009 +0100
+++ b/linux/drivers/media/common/ir-keymaps.c	Thu Jan 22 19:28:09 2009 +0100
@@ -154,6 +154,65 @@
 };
 EXPORT_SYMBOL_GPL(ir_codes_avermedia_m135a);
 
+/* Oldrich Jedlicka <oldium.pro@seznam.cz> */
+IR_KEYTAB_TYPE ir_codes_avermedia_cardbus[IR_KEYTAB_SIZE] = {
+	[ 0x00 ] = KEY_POWER,
+	[ 0x01 ] = KEY_TUNER,		/* TV/FM */
+	[ 0x03 ] = KEY_TEXT,		/* Teletext */
+	[ 0x04 ] = KEY_EPG,
+	[ 0x05 ] = KEY_1,
+	[ 0x06 ] = KEY_2,
+	[ 0x07 ] = KEY_3,
+	[ 0x08 ] = KEY_AUDIO,
+	[ 0x09 ] = KEY_4,
+	[ 0x0a ] = KEY_5,
+	[ 0x0b ] = KEY_6,
+	[ 0x0c ] = KEY_ZOOM,		/* Full screen */
+	[ 0x0d ] = KEY_7,
+	[ 0x0e ] = KEY_8,
+	[ 0x0f ] = KEY_9,
+	[ 0x10 ] = KEY_PAGEUP,		/* 16-CH PREV */
+	[ 0x11 ] = KEY_0,
+	[ 0x12 ] = KEY_INFO,
+	[ 0x13 ] = KEY_AGAIN,		/* CH RTN - channel return */
+	[ 0x14 ] = KEY_MUTE,
+	[ 0x15 ] = KEY_EDIT,		/* Autoscan */
+	[ 0x17 ] = KEY_SAVE,		/* Screenshot */
+	[ 0x18 ] = KEY_PLAYPAUSE,
+	[ 0x19 ] = KEY_RECORD,
+	[ 0x1a ] = KEY_PLAY,
+	[ 0x1b ] = KEY_STOP,
+	[ 0x1c ] = KEY_FASTFORWARD,
+	[ 0x1d ] = KEY_REWIND,
+	[ 0x1e ] = KEY_VOLUMEDOWN,
+	[ 0x1f ] = KEY_VOLUMEUP,
+	[ 0x22 ] = KEY_SLEEP,		/* Sleep */
+	[ 0x23 ] = KEY_ZOOM,		/* Aspect */
+	[ 0x26 ] = KEY_SCREEN,		/* Pos */
+	[ 0x27 ] = KEY_ANGLE,		/* Size */
+	[ 0x28 ] = KEY_SELECT,		/* Select */
+	[ 0x29 ] = KEY_BLUE,		/* Blue/Picture */
+	[ 0x2a ] = KEY_BACKSPACE,	/* Back */
+	[ 0x2b ] = KEY_MEDIA,		/* PIP (Picture-in-picture) */
+	[ 0x2c ] = KEY_DOWN,
+	[ 0x2e ] = KEY_DOT,
+	[ 0x2f ] = KEY_TV,		/* Live TV */
+	[ 0x32 ] = KEY_LEFT,
+	[ 0x33 ] = KEY_CLEAR,		/* Clear */
+	[ 0x35 ] = KEY_RED,		/* Red/TV */
+	[ 0x36 ] = KEY_UP,
+	[ 0x37 ] = KEY_HOME,		/* Home */
+	[ 0x39 ] = KEY_GREEN,		/* Green/Video */
+	[ 0x3d ] = KEY_YELLOW,		/* Yellow/Music */
+	[ 0x3e ] = KEY_OK,		/* Ok */
+	[ 0x3f ] = KEY_RIGHT,
+	[ 0x40 ] = KEY_NEXT,		/* Next */
+	[ 0x41 ] = KEY_PREVIOUS,	/* Previous */
+	[ 0x42 ] = KEY_CHANNELDOWN,	/* Channel down */
+	[ 0x43 ] = KEY_CHANNELUP	/* Channel up */
+};
+EXPORT_SYMBOL_GPL(ir_codes_avermedia_cardbus);
+
 /* Attila Kondoros <attila.kondoros@chello.hu> */
 IR_KEYTAB_TYPE ir_codes_apac_viewcomp[IR_KEYTAB_SIZE] = {
 
diff -r 66e0b01971de -r 2b8e5fc5b41f linux/drivers/media/video/ir-kbd-i2c.c
--- a/linux/drivers/media/video/ir-kbd-i2c.c	Thu Jan 22 19:27:07 2009 +0100
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
 
+static int get_key_avermedia_cardbus(struct IR_i2c *ir,
+				     u32 *ir_key, u32 *ir_raw)
+{
+	unsigned char subaddr, key, keygroup;
+	struct i2c_msg msg[] = {{.addr=ir->c.addr, .flags=0, .buf=&subaddr,
+								.len = 1},
+				{.addr=ir->c.addr, .flags=I2C_M_RD, .buf=&key,
+								.len = 1}};
+	subaddr = 0x0d;
+	if (2 != i2c_transfer(ir->c.adapter, msg, 2)) {
+		dprintk(1, "read error\n");
+		return -EIO;
+	}
+
+	if (key == 0xff)
+		return 0;
+
+	subaddr = 0x0b;
+	msg[1].buf = &keygroup;
+	if (2 != i2c_transfer(ir->c.adapter, msg, 2)) {
+		dprintk(1, "read error\n");
+		return -EIO;
+	}
+
+	if (keygroup == 0xff)
+		return 0;
+
+	dprintk(1, "read key 0x%02x/0x%02x\n", key, keygroup);
+	if (keygroup < 2 || keygroup > 3) {
+		/* Only a warning */
+		dprintk(1, "warning: invalid key group 0x%02x for key 0x%02x\n",
+								keygroup, key);
+	}
+	key |= (keygroup & 1) << 6;
+
+	*ir_key = key;
+	*ir_raw = key;
+	return 1;
+}
+
 /* ----------------------------------------------------------------------- */
 
 static void ir_key_poll(struct IR_i2c *ir)
@@ -369,6 +411,12 @@
 			ir_type     = IR_TYPE_OTHER;
 		}
 		break;
+	case 0x40:
+		name        = "AVerMedia Cardbus remote";
+		ir->get_key = get_key_avermedia_cardbus;
+		ir_type     = IR_TYPE_OTHER;
+		ir_codes    = ir_codes_avermedia_cardbus;
+		break;
 	default:
 		/* shouldn't happen */
 		printk(DEVNAME ": Huh? unknown i2c address (0x%02x)?\n", addr);
@@ -537,6 +585,22 @@
 			ir_attach(adap, msg.addr, 0, 0);
 	}
 
+	/* Special case for AVerMedia Cardbus remote */
+	if (adap->id == I2C_HW_SAA7134) {
+		unsigned char subaddr, data;
+		struct i2c_msg msg[] = {{.addr=0x40, .flags=0, .buf=&subaddr,
+								.len = 1},
+					{.addr=0x40, .flags=I2C_M_RD,
+							.buf=&data, .len = 1}};
+		subaddr = 0x0d;
+		rc = i2c_transfer(adap, msg, 2);
+		dprintk(1, "probe 0x%02x/0x%02x @ %s: %s\n",
+			msg[0].addr, subaddr, adap->name,
+			(2 == rc) ? "yes" : "no");
+		if (2 == rc)
+			ir_attach(adap, msg[0].addr, 0, 0);
+	}
+
 	return 0;
 }
 
diff -r 66e0b01971de -r 2b8e5fc5b41f 
linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Jan 22 19:27:07 
2009 +0100
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Jan 22 19:28:09 
2009 +0100
@@ -6120,6 +6120,11 @@
 		msleep(10);
 		break;
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
+		saa7134_set_gpio(dev, 23, 0);
+		msleep(10);
+		saa7134_set_gpio(dev, 23, 1);
+		dev->has_remote = SAA7134_REMOTE_I2C;
+		break;
 	case SAA7134_BOARD_AVERMEDIA_M103:
 		saa7134_set_gpio(dev, 23, 0);
 		msleep(10);
diff -r 66e0b01971de -r 2b8e5fc5b41f 
linux/drivers/media/video/saa7134/saa7134-i2c.c
--- a/linux/drivers/media/video/saa7134/saa7134-i2c.c	Thu Jan 22 19:27:07 2009 
+0100
+++ b/linux/drivers/media/video/saa7134/saa7134-i2c.c	Thu Jan 22 19:28:09 2009 
+0100
@@ -260,7 +260,7 @@
 			addr  = msgs[i].addr << 1;
 			if (msgs[i].flags & I2C_M_RD)
 				addr |= 1;
-			if (i > 0 && msgs[i].flags & I2C_M_RD) {
+			if (i > 0 && msgs[i].flags & I2C_M_RD && msgs[i].addr != 0x40) {
 				/* workaround for a saa7134 i2c bug
 				 * needed to talk to the mt352 demux
 				 * thanks to pinnacle for the hint */
diff -r 66e0b01971de -r 2b8e5fc5b41f linux/include/media/ir-common.h
--- a/linux/include/media/ir-common.h	Thu Jan 22 19:27:07 2009 +0100
+++ b/linux/include/media/ir-common.h	Thu Jan 22 19:28:09 2009 +0100
@@ -111,6 +111,7 @@
 extern IR_KEYTAB_TYPE ir_codes_avermedia[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_avermedia_dvbt[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_avermedia_m135a[IR_KEYTAB_SIZE];
+extern IR_KEYTAB_TYPE ir_codes_avermedia_cardbus[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_apac_viewcomp[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_pixelview[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_pixelview_new[IR_KEYTAB_SIZE];
