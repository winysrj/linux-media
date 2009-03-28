Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate04.web.de ([217.72.192.242]:43123 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205AbZC1QPk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Mar 2009 12:15:40 -0400
Received: from web.de
	by fmmailgate04.web.de (Postfix) with SMTP id 9CE9E6090ABB
	for <linux-media@vger.kernel.org>; Sat, 28 Mar 2009 17:15:37 +0100 (CET)
Date: Sat, 28 Mar 2009 17:15:35 +0100
Message-Id: <1622164526@web.de>
MIME-Version: 1.0
From: =?iso-8859-15?Q?Bernd_Strau=DF?= <no_bs@web.de>
To: linux-media@vger.kernel.org
Subject: [Patch] IR support for TeVii S460 DVB-S card
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

changeset:   11251:58f9585b7d94
tag:         tip
user:        root
date:        Sat Mar 28 15:19:20 2009 +0100
files:       linux/drivers/media/common/ir-keymaps.c linux/drivers/media/video/cx88/cx88-input.c linux/include/media/ir-common.h
description:

IR support for TeVii S460

From: Bernd Strauss <no_bs@web.de>

The remote control that comes with this card doesn't work out of the box.
This patch fixes that. Works with LIRC and /dev/input/eventX.

Priority: normal

Signed-off-by: Bernd Strauss <no_bs@web.de>


diff -r 2adf4a837334 linux/drivers/media/common/ir-keymaps.c
--- a/linux/drivers/media/common/ir-keymaps.c	Sat Mar 28 06:55:35 2009 -0300
+++ b/linux/drivers/media/common/ir-keymaps.c	Sat Mar 28 15:15:04 2009 +0100
@@ -2800,3 +2800,59 @@
 	[0x1b] = KEY_B,		/*recall*/
 };
 EXPORT_SYMBOL_GPL(ir_codes_dm1105_nec);
+
+/* TeVii S460 DVB-S/S2
+   Bernd Strauss <no_bs@web.de>
+*/
+IR_KEYTAB_TYPE ir_codes_tevii_s460[IR_KEYTAB_SIZE] = {
+	[0x0a] = KEY_POWER,
+	[0x0c] = KEY_MUTE,
+	[0x11] = KEY_1,
+	[0x12] = KEY_2,
+	[0x13] = KEY_3,
+	[0x14] = KEY_4,
+	[0x15] = KEY_5,
+	[0x16] = KEY_6,
+	[0x17] = KEY_7,
+	[0x18] = KEY_8,
+	[0x19] = KEY_9,
+	[0x1a] = KEY_LAST,		/* 'recall' / 'event info' */
+	[0x10] = KEY_0,
+	[0x1b] = KEY_FAVORITES,
+
+	[0x09] = KEY_VOLUMEUP,
+	[0x0f] = KEY_VOLUMEDOWN,
+	[0x05] = KEY_TUNER,		/* 'live mode' */
+	[0x07] = KEY_PVR,		/* 'play mode' */
+	[0x08] = KEY_CHANNELUP,
+	[0x06] = KEY_CHANNELDOWN,
+	[0x00] = KEY_UP,
+	[0x03] = KEY_LEFT,
+	[0x1f] = KEY_OK,        
+	[0x02] = KEY_RIGHT,
+	[0x01] = KEY_DOWN,
+	[0x1c] = KEY_MENU,
+	[0x1d] = KEY_BACK,
+
+	[0x40] = KEY_PLAYPAUSE,
+	[0x1e] = KEY_REWIND,		/* '<<' */
+	[0x4d] = KEY_FASTFORWARD,	/* '>>' */
+	[0x44] = KEY_EPG,
+	[0x04] = KEY_RECORD,
+	[0x0b] = KEY_TIME,              /* 'timer' */
+	[0x0e] = KEY_OPEN,
+	[0x4c] = KEY_INFO,
+	[0x41] = KEY_AB,                /* 'A/B' */
+	[0x43] = KEY_AUDIO,
+	[0x45] = KEY_SUBTITLE,
+	[0x4a] = KEY_LIST,
+	[0x46] = KEY_F1,		/* 'F1' / 'satellite' */
+	[0x47] = KEY_F2,		/* 'F2' / 'provider' */
+	[0x5e] = KEY_F3,		/* 'F3' / 'transp' */
+	[0x5c] = KEY_F4,		/* 'F4' / 'favorites' */
+	[0x52] = KEY_F5,		/* 'F5' / 'all' */
+	[0x5a] = KEY_F6,
+	[0x56] = KEY_SWITCHVIDEOMODE,	/* 'mon' */
+	[0x58] = KEY_ZOOM,		/* 'FS' */
+};
+EXPORT_SYMBOL_GPL(ir_codes_tevii_s460);
diff -r 2adf4a837334 linux/drivers/media/video/cx88/cx88-input.c
--- a/linux/drivers/media/video/cx88/cx88-input.c	Sat Mar 28 06:55:35 2009 -0300
+++ b/linux/drivers/media/video/cx88/cx88-input.c	Sat Mar 28 15:15:04 2009 +0100
@@ -330,6 +330,11 @@
 		ir->mask_keycode = 0x7e;
 		ir->polling = 100; /* ms */
 		break;
+	case CX88_BOARD_TEVII_S460:
+		ir_codes = ir_codes_tevii_s460;
+		ir_type = IR_TYPE_PD;
+		ir->sampling = 0xff00; /* address */
+		break;
 	}
 
 	if (NULL == ir_codes) {
@@ -436,6 +441,7 @@
 	switch (core->boardnr) {
 	case CX88_BOARD_TERRATEC_CINERGY_1400_DVB_T1:
 	case CX88_BOARD_DNTV_LIVE_DVB_T_PRO:
+	case CX88_BOARD_TEVII_S460:
 		ircode = ir_decode_pulsedistance(ir->samples, ir->scount, 1, 4);
 
 		if (ircode == 0xffffffff) { /* decoding error */
diff -r 2adf4a837334 linux/include/media/ir-common.h
--- a/linux/include/media/ir-common.h	Sat Mar 28 06:55:35 2009 -0300
+++ b/linux/include/media/ir-common.h	Sat Mar 28 15:15:04 2009 +0100
@@ -162,6 +162,7 @@
 extern IR_KEYTAB_TYPE ir_codes_kworld_plus_tv_analog[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_kaiomy[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_dm1105_nec[IR_KEYTAB_SIZE];
+extern IR_KEYTAB_TYPE ir_codes_tevii_s460[IR_KEYTAB_SIZE];
 #endif
 
 /*

__________________________________________________________________________
Verschicken Sie SMS direkt vom Postfach aus - in alle deutschen und viele 
ausländische Netze zum gleichen Preis! 
https://produkte.web.de/webde_sms/sms



