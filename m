Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:50995 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752037AbdIBLmv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Sep 2017 07:42:51 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/7] media: dvb: a800: port to rc-core
Date: Sat,  2 Sep 2017 12:42:43 +0100
Message-Id: <81d85c75a1edc4b7ab89587508a2df97752aa759.1504352252.git.sean@mess.org>
In-Reply-To: <cover.1504352252.git.sean@mess.org>
References: <cover.1504352252.git.sean@mess.org>
In-Reply-To: <cover.1504352252.git.sean@mess.org>
References: <cover.1504352252.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This receiver only accepts nec16 messages, I've tried many other protocols
and they're all dropped.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/usb/dvb-usb/a800.c | 65 +++++++++-------------------------------
 1 file changed, 14 insertions(+), 51 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/a800.c b/drivers/media/usb/dvb-usb/a800.c
index 7ba975bea96a..540886b3bb29 100644
--- a/drivers/media/usb/dvb-usb/a800.c
+++ b/drivers/media/usb/dvb-usb/a800.c
@@ -37,48 +37,9 @@ static int a800_identify_state(struct usb_device *udev, struct dvb_usb_device_pr
 	return 0;
 }
 
-static struct rc_map_table rc_map_a800_table[] = {
-	{ 0x0201, KEY_MODE },      /* SOURCE */
-	{ 0x0200, KEY_POWER2 },      /* POWER */
-	{ 0x0205, KEY_1 },           /* 1 */
-	{ 0x0206, KEY_2 },           /* 2 */
-	{ 0x0207, KEY_3 },           /* 3 */
-	{ 0x0209, KEY_4 },           /* 4 */
-	{ 0x020a, KEY_5 },           /* 5 */
-	{ 0x020b, KEY_6 },           /* 6 */
-	{ 0x020d, KEY_7 },           /* 7 */
-	{ 0x020e, KEY_8 },           /* 8 */
-	{ 0x020f, KEY_9 },           /* 9 */
-	{ 0x0212, KEY_LEFT },        /* L / DISPLAY */
-	{ 0x0211, KEY_0 },           /* 0 */
-	{ 0x0213, KEY_RIGHT },       /* R / CH RTN */
-	{ 0x0217, KEY_CAMERA },      /* SNAP SHOT */
-	{ 0x0210, KEY_LAST },        /* 16-CH PREV */
-	{ 0x021e, KEY_VOLUMEDOWN },  /* VOL DOWN */
-	{ 0x020c, KEY_ZOOM },        /* FULL SCREEN */
-	{ 0x021f, KEY_VOLUMEUP },    /* VOL UP */
-	{ 0x0214, KEY_MUTE },        /* MUTE */
-	{ 0x0208, KEY_AUDIO },       /* AUDIO */
-	{ 0x0219, KEY_RECORD },      /* RECORD */
-	{ 0x0218, KEY_PLAY },        /* PLAY */
-	{ 0x021b, KEY_STOP },        /* STOP */
-	{ 0x021a, KEY_PLAYPAUSE },   /* TIMESHIFT / PAUSE */
-	{ 0x021d, KEY_BACK },        /* << / RED */
-	{ 0x021c, KEY_FORWARD },     /* >> / YELLOW */
-	{ 0x0203, KEY_TEXT },        /* TELETEXT */
-	{ 0x0204, KEY_EPG },         /* EPG */
-	{ 0x0215, KEY_MENU },        /* MENU */
-
-	{ 0x0303, KEY_CHANNELUP },   /* CH UP */
-	{ 0x0302, KEY_CHANNELDOWN }, /* CH DOWN */
-	{ 0x0301, KEY_FIRST },       /* |<< / GREEN */
-	{ 0x0300, KEY_LAST },        /* >>| / BLUE */
-
-};
-
-static int a800_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
+static int a800_rc_query(struct dvb_usb_device *d)
 {
-	int ret;
+	int ret = 0;
 	u8 *key = kmalloc(5, GFP_KERNEL);
 	if (!key)
 		return -ENOMEM;
@@ -90,11 +51,12 @@ static int a800_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 		goto out;
 	}
 
-	/* call the universal NEC remote processor, to find out the key's state and event */
-	dvb_usb_nec_rc_key_to_event(d,key,event,state);
-	if (key[0] != 0)
-		deb_rc("key: %*ph\n", 5, key);
-	ret = 0;
+	/* Note that extended nec and nec32 are dropped */
+	if (key[0] == 1)
+		rc_keydown(d->rc_dev, RC_PROTO_NEC,
+			   RC_SCANCODE_NEC(key[1], key[3]), 0);
+	else if (key[0] == 2)
+		rc_repeat(d->rc_dev);
 out:
 	kfree(key);
 	return ret;
@@ -157,11 +119,12 @@ static struct dvb_usb_device_properties a800_properties = {
 	.power_ctrl       = a800_power_ctrl,
 	.identify_state   = a800_identify_state,
 
-	.rc.legacy = {
-		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_map_table     = rc_map_a800_table,
-		.rc_map_size      = ARRAY_SIZE(rc_map_a800_table),
-		.rc_query         = a800_rc_query,
+	.rc.core = {
+		.rc_interval	= DEFAULT_RC_INTERVAL,
+		.rc_codes	= RC_MAP_AVERMEDIA_M135A,
+		.module_name	= KBUILD_MODNAME,
+		.rc_query	= a800_rc_query,
+		.allowed_protos = RC_PROTO_BIT_NEC,
 	},
 
 	.i2c_algo         = &dibusb_i2c_algo,
-- 
2.13.5
