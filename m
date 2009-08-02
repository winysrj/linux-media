Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:36845 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227AbZHBTp3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Aug 2009 15:45:29 -0400
Received: by ewy10 with SMTP id 10so2616021ewy.37
        for <linux-media@vger.kernel.org>; Sun, 02 Aug 2009 12:45:27 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 2 Aug 2009 20:45:25 +0100
Message-ID: <3d374d00908021245g66fc66b1h66932f4844cb20b1@mail.gmail.com>
Subject: [PATCH] Rework the RTL2831 remote control handler to reuse dibusb.
From: Alistair Buxton <a.j.buxton@gmail.com>
To: linux-media@vger.kernel.org
Cc: jan-conceptronic@hoogenraad.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi. This patch is against the rtl2831-r2 tree.

This patch is really just a proof of concept, that the dibusb handler
code can handle the rtl2831 remote codes. I have both types of device
and noticed that the remotes are interchangable, and it turns out the
code tables are too, but for a quirk in the way the rtl driver looks
up the values (it uses the wrong fields in keybuf.)

Is there any progress on getting the rtl2831 driver ready for
inclusion into the mainline?

# HG changeset patch
# User Alistair Buxton <a.j.buxton@gmail.com>
# Date 1249239142 -3600
# Node ID 83476a81ce48824891f64cebfd293239acafc878
# Parent  1557237aa2ebb25d807e4af251fdf08b182660fb
RTL2831: Rework the RTL2831 remote control code to reuse the dibusb
remote control handler.

1. Add the extra codes of the AzureWave AD-TU800 remote to the dibusb
code table. This remote
uses the same NEC codes as the dibusb remotes, but with extra buttons.
As a bonus, this makes
the AzureWave remote work with dibusb devices too.

2. Make rtd2831u_rc_query() use dvb_usb_nec_rc_key_to_event() instead
of it's own slightly
broken implementation.

3. Fix up the Conceptronic keycode table. This is NEC compatible but
uses different codes to
the dibusb_rc_keys[]. The fields are switched around to make the table
compatible with
dvb_usb_nec_rc_key_to_event().

4. Fudge the keybuf when using RC5 table.

5. Fix all the drivers that use dibusb_rc_keys[] with the new length.

diff -r 1557237aa2eb -r 83476a81ce48
linux/drivers/media/dvb/dvb-usb/dibusb-common.c
--- a/linux/drivers/media/dvb/dvb-usb/dibusb-common.c	Tue May 19
22:29:10 2009 +0200
+++ b/linux/drivers/media/dvb/dvb-usb/dibusb-common.c	Sun Aug 02
19:52:22 2009 +0100
@@ -351,6 +351,31 @@
 	{ 0x00, 0x48, KEY_INFO }, /* Preview */
 	{ 0x00, 0x04, KEY_LIST }, /* RecordList */
 	{ 0x00, 0x0f, KEY_TEXT }, /* Teletext */
+	/* additional keys for the azurewave remote */
+	{ 0x00, 0x4a, KEY_UNKNOWN }, /* Clear */
+	{ 0x00, 0x13, KEY_BACK },
+	{ 0x00, 0x4b, KEY_UP },
+	{ 0x00, 0x51, KEY_DOWN },
+	{ 0x00, 0x4e, KEY_LEFT },
+	{ 0x00, 0x52, KEY_RIGHT },	
+	{ 0x00, 0x4f, KEY_ENTER },
+	{ 0x00, 0x4c, KEY_PAUSE },
+	{ 0x00, 0x41, KEY_PREVIOUSSONG }, /* |< */
+	{ 0x00, 0x42, KEY_NEXTSONG }, /* >| */
+	{ 0x00, 0x54, KEY_CAMERA }, /* capture (has picture of camera on it) */
+	{ 0x00, 0x50, KEY_UNKNOWN }, /* SAP */
+	{ 0x00, 0x47, KEY_UNKNOWN }, /* PIP */
+	{ 0x00, 0x4d, KEY_UNKNOWN }, /* fullscreen */
+	{ 0x00, 0x43, KEY_SUBTITLE },
+	{ 0x00, 0x49, KEY_UNKNOWN }, /* L/R */
+	{ 0x00, 0x07, KEY_POWER2 }, /* hibernate */
+	{ 0x00, 0x08, KEY_VIDEO_NEXT },
+	{ 0x00, 0x45, KEY_ZOOMIN },
+	{ 0x00, 0x46, KEY_ZOOMOUT },
+	{ 0x00, 0x18, KEY_RED },
+	{ 0x00, 0x53, KEY_GREEN },
+	{ 0x00, 0x5e, KEY_YELLOW },
+	{ 0x00, 0x5f, KEY_BLUE },
 	/* Key codes for the KWorld/ADSTech/JetWay remote. */
 	{ 0x86, 0x12, KEY_POWER },
 	{ 0x86, 0x0f, KEY_SELECT }, /* source */
diff -r 1557237aa2eb -r 83476a81ce48 linux/drivers/media/dvb/dvb-usb/dibusb-mb.c
--- a/linux/drivers/media/dvb/dvb-usb/dibusb-mb.c	Tue May 19 22:29:10 2009 +0200
+++ b/linux/drivers/media/dvb/dvb-usb/dibusb-mb.c	Sun Aug 02 19:52:22 2009 +0100
@@ -213,7 +213,7 @@

 	.rc_interval      = DEFAULT_RC_INTERVAL,
 	.rc_key_map       = dibusb_rc_keys,
-	.rc_key_map_size  = 111, /* wow, that is ugly ... I want to load it
to the driver dynamically */
+	.rc_key_map_size  = 135, /* wow, that is ugly ... I want to load it
to the driver dynamically */
 	.rc_query         = dibusb_rc_query,

 	.i2c_algo         = &dibusb_i2c_algo,
@@ -297,7 +297,7 @@

 	.rc_interval      = DEFAULT_RC_INTERVAL,
 	.rc_key_map       = dibusb_rc_keys,
-	.rc_key_map_size  = 111, /* wow, that is ugly ... I want to load it
to the driver dynamically */
+	.rc_key_map_size  = 135, /* wow, that is ugly ... I want to load it
to the driver dynamically */
 	.rc_query         = dibusb_rc_query,

 	.i2c_algo         = &dibusb_i2c_algo,
@@ -361,7 +361,7 @@

 	.rc_interval      = DEFAULT_RC_INTERVAL,
 	.rc_key_map       = dibusb_rc_keys,
-	.rc_key_map_size  = 111, /* wow, that is ugly ... I want to load it
to the driver dynamically */
+	.rc_key_map_size  = 135, /* wow, that is ugly ... I want to load it
to the driver dynamically */
 	.rc_query         = dibusb_rc_query,

 	.i2c_algo         = &dibusb_i2c_algo,
@@ -418,7 +418,7 @@

 	.rc_interval      = DEFAULT_RC_INTERVAL,
 	.rc_key_map       = dibusb_rc_keys,
-	.rc_key_map_size  = 111, /* wow, that is ugly ... I want to load it
to the driver dynamically */
+	.rc_key_map_size  = 135, /* wow, that is ugly ... I want to load it
to the driver dynamically */
 	.rc_query         = dibusb_rc_query,

 	.i2c_algo         = &dibusb_i2c_algo,
diff -r 1557237aa2eb -r 83476a81ce48 linux/drivers/media/dvb/dvb-usb/dibusb-mc.c
--- a/linux/drivers/media/dvb/dvb-usb/dibusb-mc.c	Tue May 19 22:29:10 2009 +0200
+++ b/linux/drivers/media/dvb/dvb-usb/dibusb-mc.c	Sun Aug 02 19:52:22 2009 +0100
@@ -81,7 +81,7 @@

 	.rc_interval      = DEFAULT_RC_INTERVAL,
 	.rc_key_map       = dibusb_rc_keys,
-	.rc_key_map_size  = 111, /* FIXME */
+	.rc_key_map_size  = 135, /* FIXME */
 	.rc_query         = dibusb_rc_query,

 	.i2c_algo         = &dibusb_i2c_algo,
diff -r 1557237aa2eb -r 83476a81ce48 linux/drivers/media/dvb/rtl2831/rtd2830u.c
--- a/linux/drivers/media/dvb/rtl2831/rtd2830u.c	Tue May 19 22:29:10 2009 +0200
+++ b/linux/drivers/media/dvb/rtl2831/rtd2830u.c	Sun Aug 02 19:52:22 2009 +0100
@@ -24,6 +24,7 @@

 #include "rtd2831u.h"
 #include "tuner_demod_io.h"
+#include "dibusb.h"

 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);

@@ -58,45 +59,6 @@
 #define USB_EPA_CTL			0x0148
 /*(prev.line) epa contrl register */

-#ifdef RTL2831U_NEC_PROTOCOL
-static struct dvb_usb_rc_key rtd2831u_nec_keys[] = {
-	{0x03, 0xfc, KEY_1},
-	{0x01, 0xfe, KEY_2},
-	{0x06, 0xf9, KEY_3},
-	{0x09, 0xf6, KEY_4},
-	{0x1d, 0xe2, KEY_5},
-	{0x1f, 0xe0, KEY_6},
-	{0x0D, 0xf2, KEY_7},
-	{0x19, 0xe6, KEY_8},
-	{0x1b, 0xe4, KEY_9},
-	{0x15, 0xea, KEY_0},
-
-	{0x17, 0xe8, KEY_S},	/*show scan page */
-	{0x14, 0xeb, KEY_G},	/*start scan */
-	{0x1a, 0xe5, KEY_X},	/*stop scan */
-
-	{0x08, 0xf7, KEY_A},	/*de-interlace  ---> advance scanpage */
-
-	{0x0a, 0xf5, KEY_LEFT},	/*key_left */
-	{0x1e, 0xe1, KEY_RIGHT},	/*key_right */
-	{0x11, 0xee, KEY_BACKSPACE},	/*backspace */
-
-	{0x0a, 0xf5, KEY_VOLUMEDOWN},	/*vol- */
-	{0x1e, 0xe1, KEY_VOLUMEUP},	/*vol+ */
-	{0x10, 0xef, KEY_MUTE},	/*mute */
-
-	{0x05, 0xfa, KEY_CHANNELUP},	/*channel+ */
-	{0x02, 0xfd, KEY_CHANNELDOWN},	/*channel- */
-	{0x4f, 0xb0, KEY_LAST},	/*last channel */
-
-	{0x05, 0xfa, KEY_UP},	/*country + */
-	{0x02, 0xfd, KEY_DOWN},	/*country- */
-
-	{0x16, 0xe9, KEY_POWER},	/*End(poweroff) */
-	{0x4c, 0xb3, KEY_R},	/*Reboot  */
-};
-#endif
-
 #ifdef RTL2831U_RC5_PROTOCOL
 /* philip rc5 keys */
 static struct dvb_usb_rc_key rtd2831u_rc5_keys[] = {
@@ -137,28 +99,28 @@
 */

 static struct dvb_usb_rc_key rtd2831u_conceptronic_keys[] = {
-	{0x04, 0xfb, KEY_1},
-	{0x05, 0xfa, KEY_2},
-	{0x06, 0xf9, KEY_3},
-	{0x07, 0xf8, KEY_4},
-	{0x08, 0xf7, KEY_5},
-	{0x09, 0xf6, KEY_6},
-	{0x0a, 0xf5, KEY_7},
-	{0x1b, 0xe4, KEY_8},
-	{0x1f, 0xe0, KEY_9},
-	{0x0d, 0xf2, KEY_0},
+	{0x80, 0x04, KEY_1},
+	{0x80, 0x05, KEY_2},
+	{0x80, 0x06, KEY_3},
+	{0x80, 0x07, KEY_4},
+	{0x80, 0x08, KEY_5},
+	{0x80, 0x09, KEY_6},
+	{0x80, 0x0a, KEY_7},
+	{0x80, 0x1b, KEY_8},
+	{0x80, 0x1f, KEY_9},
+	{0x80, 0x0d, KEY_0},

-	{0x02, 0xfd, KEY_VOLUMEDOWN},	/*vol- */
-	{0x1a, 0xe5, KEY_VOLUMEUP},	/*vol+ */
-	{0x01, 0xfe, KEY_MUTE},	/*mute */
+	{0x80, 0x02, KEY_VOLUMEDOWN},	/*vol- */
+	{0x80, 0x1a, KEY_VOLUMEUP},	/*vol+ */
+	{0x80, 0x01, KEY_MUTE},	/*mute */

-	{0x1e, 0xe1, KEY_CHANNELUP},	/*channel+ */
-	{0x03, 0xfc, KEY_CHANNELDOWN},	/*channel- */
+	{0x80, 0x1e, KEY_CHANNELUP},	/*channel+ */
+	{0x80, 0x03, KEY_CHANNELDOWN},	/*channel- */

-	{0x12, 0xed, KEY_POWER},	/*End(poweroff) */
-	{0x0e, 0xf1, KEY_LAST},	/*last channel */
+	{0x80, 0x12, KEY_POWER},	/*End(poweroff) */
+	{0x80, 0x0e, KEY_LAST},	/*last channel */

-	{0x0c, 0xf3, KEY_ZOOM},	/* zoom was not assigned, now Z */
+	{0x80, 0x0c, KEY_ZOOM},	/* zoom was not assigned, now Z */
 };

 #endif
@@ -196,8 +158,8 @@
 	case RTL2831U_NEC_TYPE:
 		deb_info("Selected IR type 0x%02x\n", ir_protocol);
 		memcpy(reg_val, NEC_REG_VAL, sizeof(u8) * ARRAY_SIZE(reg_val));
-		d->props.rc_key_map = rtd2831u_nec_keys;
-		d->props.rc_key_map_size = ARRAY_SIZE(rtd2831u_nec_keys);
+		d->props.rc_key_map = dibusb_rc_keys;
+		d->props.rc_key_map_size = 135;
 		break;
 	case RTL2831U_RC5_TYPE:
 		deb_info("Selected IR type 0x%02x\n", ir_protocol);
@@ -237,47 +199,9 @@
 	return 1;
 }

-static int rtd2831u_rc_key_to_event(struct dvb_usb_device *d,
-				    u8 keybuf[4], u32 * event, int *state)
-{
-	int i;
-	struct dvb_usb_rc_key *keymap = d->props.rc_key_map;
-	*event = 0;
-	*state = REMOTE_NO_KEY_PRESSED;
-
-	switch (ir_protocol) {
-	case RTL2831U_RC5_TYPE:
-		keybuf[0] = (keybuf[0] & 0x00);
-		keybuf[1] = (keybuf[1] & 0x00);
-		keybuf[2] = (keybuf[2] & 0x00);
-		keybuf[3] = (keybuf[3] & 0xff);
-		break;
-	}
-
-/* deb_info("raw key code 0x%02x, 0x%02x, 0x%02x,
0x%02x\n",keybuf[0], keybuf[1], keybuf[2], keybuf[3]); */
-	/* See if we can match the raw key code. */
-	for (i = 0; i < d->props.rc_key_map_size; i++)
-		if (keymap[i].custom == keybuf[2]
-		    && keymap[i].data == keybuf[3]) {
-			*event = keymap[i].event;
-			*state = REMOTE_KEY_PRESSED;
-			return 0;
-		}
-
-	if (*state != REMOTE_KEY_PRESSED) {
-		deb_info
-		    ("Unmatched raw key code 0x%02x, 0x%02x, 0x%02x, 0x%02x: please
try other setting for parameter ir_protocol\n",
-		     keybuf[0], keybuf[1], keybuf[2], keybuf[3]);
-	}
-
-	return 0;
-
-}
-
 static int rtd2831u_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
 {
-	u8 key[4];
-	u8 b = 0xcc;
+	u8 key[5] = {0xcc, 0, 0, 0, 0};
 	struct rtl2831u_rc_state *p_rc_state = d->priv;

 	*event = 0;
@@ -290,21 +214,36 @@
 			goto error;
 	}

-	if (RTD2831_READ_BYTES(d, RTD2831U_SYS, IRRC_SR, &b, 1))
+	if (RTD2831_READ_BYTES(d, RTD2831U_SYS, IRRC_SR, &key[0], 1))
 		goto error;

-	if (b & 0x01) {
-		if (RTD2831_READ_BYTES(d, RTD2831U_SYS, IRRC_RP, key, 4))
+	if (key[0] & 0x01) {
+		if (RTD2831_READ_BYTES(d, RTD2831U_SYS, IRRC_RP, &key[1], 4))
 			goto error;
-		b = 0x01;
-		if (RTD2831_WRITE_BYTES(d, RTD2831U_SYS, IRRC_SR, &b, 1))
+		key[0] = 0x01;
+		if (RTD2831_WRITE_BYTES(d, RTD2831U_SYS, IRRC_SR, &key[0], 1))
 			goto error;

 		if (++p_rc_state->repeat_key_count <
 		    p_rc_state->rc_key_repeat_count)
 			return 0;	/*set two events to 1(repeat.....) */

-		rtd2831u_rc_key_to_event(d, key, event, state);
+		/* in the old code, keybuf was 4 bytes. in the dibusb, keybuf is 5 bytes.
+		   byte 0 is the cmd. bytes 1-4 are bytes 0-3 from the old.
+		   so we must switch around some bytes to make the rc5 table valid.
+		   This probably isn't necessary (can just fix the table instead)
+		   but I can't tell without the actual un-switched remote codes. */
+
+		switch (ir_protocol) {
+		case RTL2831U_RC5_TYPE:
+			key[1] = 0x00; // custom - 0 in rc5 table
+			key[2] = 0xff; // checksum/compliment of keybuf[1]
+			key[3] = (key[4] & 0xff); // data (need to move it)
+			key[4] = ~key[3];	// checksum/compliment
+			break;
+		}
+
+		dvb_usb_nec_rc_key_to_event(d, key, event, state);
 		p_rc_state->repeat_key_count = 0;
 /*(prev.line) reset counter to 0		 */
 	}
@@ -412,17 +351,16 @@

 	.rc_interval = 300,
 #ifdef RTL2831U_NEC_PROTOCOL
-	.rc_key_map = rtd2831u_nec_keys,
-	.rc_key_map_size = ARRAY_SIZE(rtd2831u_nec_keys),
-#else
-#ifdef RTL2831U_RC5_PROTOCOL
+	.rc_key_map = dibusb_rc_keys,
+	.rc_key_map_size = 135,
+#elif defined RTL2831U_RC5_PROTOCOL
 	.rc_key_map = rtd2831u_rc5_keys,
 	.rc_key_map_size = ARRAY_SIZE(rtd2831u_rc5_keys),
 #elif defined RTL2831U_CONCEPTRONIC_PROTOCOL
 	.rc_key_map = rtd2831u_conceptronic_keys,
 	.rc_key_map_size = ARRAY_SIZE(rtd2831u_conceptronic_keys),
 #endif
-#endif
+
 	.rc_query = rtd2831u_rc_query,

 	.num_device_descs = 8,
@@ -487,17 +425,15 @@

 	.rc_interval = 300,
 #ifdef RTL2831U_NEC_PROTOCOL
-	.rc_key_map = rtd2831u_nec_keys,
-	.rc_key_map_size = ARRAY_SIZE(rtd2831u_nec_keys),
-#else
-#ifdef RTL2831U_RC5_PROTOCOL
+	.rc_key_map = dibusb_rc_keys,
+	.rc_key_map_size = 135,
+#elif defined RTL2831U_RC5_PROTOCOL
 	.rc_key_map = rtd2831u_rc5_keys,
 	.rc_key_map_size = ARRAY_SIZE(rtd2831u_rc5_keys),
 #elif defined RTL2831U_CONCEPTRONIC_PROTOCOL
 	.rc_key_map = rtd2831u_conceptronic_keys,
 	.rc_key_map_size = ARRAY_SIZE(rtd2831u_conceptronic_keys),
 #endif
-#endif
 	.rc_query = rtd2831u_rc_query,

 	.num_device_descs = 5,





-- 
Alistair Buxton
a.j.buxton@gmail.com
