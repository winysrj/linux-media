Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:46689 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932823AbdIFPex (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Sep 2017 11:34:53 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] media: vp7045: port TwinhanDTV Alpha to rc-core
Date: Wed,  6 Sep 2017 16:34:51 +0100
Message-Id: <20170906153451.26558-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Only the nec protocol is understood, but then it doesn't pass on
the full scancode and it ignores the nec repeats its own remote
sends, so holding buttons does not work.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/keymaps/rc-twinhan1027.c  |  2 +-
 drivers/media/usb/dvb-usb/dvb-usb-remote.c |  1 +
 drivers/media/usb/dvb-usb/dvb-usb.h        |  1 +
 drivers/media/usb/dvb-usb/vp7045.c         | 88 +++++-------------------------
 4 files changed, 18 insertions(+), 74 deletions(-)

diff --git a/drivers/media/rc/keymaps/rc-twinhan1027.c b/drivers/media/rc/keymaps/rc-twinhan1027.c
index 2275b37c61d2..78bb3143a1a8 100644
--- a/drivers/media/rc/keymaps/rc-twinhan1027.c
+++ b/drivers/media/rc/keymaps/rc-twinhan1027.c
@@ -66,7 +66,7 @@ static struct rc_map_list twinhan_vp1027_map = {
 	.map = {
 		.scan     = twinhan_vp1027,
 		.size     = ARRAY_SIZE(twinhan_vp1027),
-		.rc_proto = RC_PROTO_UNKNOWN,	/* Legacy IR type */
+		.rc_proto = RC_PROTO_NEC,
 		.name     = RC_MAP_TWINHAN_VP1027_DVBS,
 	}
 };
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-remote.c b/drivers/media/usb/dvb-usb/dvb-usb-remote.c
index b027d378102a..bf7dcd6b03e0 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-remote.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-remote.c
@@ -283,6 +283,7 @@ static int rc_core_dvb_usb_remote_init(struct dvb_usb_device *d)
 	dev->input_phys = d->rc_phys;
 	dev->dev.parent = &d->udev->dev;
 	dev->priv = d;
+	dev->scancode_mask = d->props.rc.core.scancode_mask;
 
 	err = rc_register_device(dev);
 	if (err < 0) {
diff --git a/drivers/media/usb/dvb-usb/dvb-usb.h b/drivers/media/usb/dvb-usb/dvb-usb.h
index 72468fdffa18..1da9e47553f5 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb.h
+++ b/drivers/media/usb/dvb-usb/dvb-usb.h
@@ -207,6 +207,7 @@ struct dvb_rc {
 	int (*rc_query) (struct dvb_usb_device *d);
 	int rc_interval;
 	bool bulk_mode;				/* uses bulk mode */
+	u32 scancode_mask;
 };
 
 /**
diff --git a/drivers/media/usb/dvb-usb/vp7045.c b/drivers/media/usb/dvb-usb/vp7045.c
index 13340af0d39c..2527b88beb87 100644
--- a/drivers/media/usb/dvb-usb/vp7045.c
+++ b/drivers/media/usb/dvb-usb/vp7045.c
@@ -97,82 +97,22 @@ static int vp7045_power_ctrl(struct dvb_usb_device *d, int onoff)
 	return vp7045_usb_op(d,SET_TUNER_POWER,&v,1,NULL,0,150);
 }
 
-/* remote control stuff */
-
-/* The keymapping struct. Somehow this should be loaded to the driver, but
- * currently it is hardcoded. */
-static struct rc_map_table rc_map_vp7045_table[] = {
-	{ 0x0016, KEY_POWER },
-	{ 0x0010, KEY_MUTE },
-	{ 0x0003, KEY_1 },
-	{ 0x0001, KEY_2 },
-	{ 0x0006, KEY_3 },
-	{ 0x0009, KEY_4 },
-	{ 0x001d, KEY_5 },
-	{ 0x001f, KEY_6 },
-	{ 0x000d, KEY_7 },
-	{ 0x0019, KEY_8 },
-	{ 0x001b, KEY_9 },
-	{ 0x0015, KEY_0 },
-	{ 0x0005, KEY_CHANNELUP },
-	{ 0x0002, KEY_CHANNELDOWN },
-	{ 0x001e, KEY_VOLUMEUP },
-	{ 0x000a, KEY_VOLUMEDOWN },
-	{ 0x0011, KEY_RECORD },
-	{ 0x0017, KEY_FAVORITES }, /* Heart symbol - Channel list. */
-	{ 0x0014, KEY_PLAY },
-	{ 0x001a, KEY_STOP },
-	{ 0x0040, KEY_REWIND },
-	{ 0x0012, KEY_FASTFORWARD },
-	{ 0x000e, KEY_PREVIOUS }, /* Recall - Previous channel. */
-	{ 0x004c, KEY_PAUSE },
-	{ 0x004d, KEY_SCREEN }, /* Full screen mode. */
-	{ 0x0054, KEY_AUDIO }, /* MTS - Switch to secondary audio. */
-	{ 0x000c, KEY_CANCEL }, /* Cancel */
-	{ 0x001c, KEY_EPG }, /* EPG */
-	{ 0x0000, KEY_TAB }, /* Tab */
-	{ 0x0048, KEY_INFO }, /* Preview */
-	{ 0x0004, KEY_LIST }, /* RecordList */
-	{ 0x000f, KEY_TEXT }, /* Teletext */
-	{ 0x0041, KEY_PREVIOUSSONG },
-	{ 0x0042, KEY_NEXTSONG },
-	{ 0x004b, KEY_UP },
-	{ 0x0051, KEY_DOWN },
-	{ 0x004e, KEY_LEFT },
-	{ 0x0052, KEY_RIGHT },
-	{ 0x004f, KEY_ENTER },
-	{ 0x0013, KEY_CANCEL },
-	{ 0x004a, KEY_CLEAR },
-	{ 0x0054, KEY_PRINT }, /* Capture */
-	{ 0x0043, KEY_SUBTITLE }, /* Subtitle/CC */
-	{ 0x0008, KEY_VIDEO }, /* A/V */
-	{ 0x0007, KEY_SLEEP }, /* Hibernate */
-	{ 0x0045, KEY_ZOOM }, /* Zoom+ */
-	{ 0x0018, KEY_RED},
-	{ 0x0053, KEY_GREEN},
-	{ 0x005e, KEY_YELLOW},
-	{ 0x005f, KEY_BLUE}
-};
-
-static int vp7045_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
+static int vp7045_rc_query(struct dvb_usb_device *d)
 {
 	u8 key;
-	int i;
 	vp7045_usb_op(d,RC_VAL_READ,NULL,0,&key,1,20);
 
 	deb_rc("remote query key: %x %d\n",key,key);
 
-	if (key == 0x44) {
-		*state = REMOTE_NO_KEY_PRESSED;
-		return 0;
+	if (key != 0x44) {
+		/*
+		 * The 8 bit address isn't available, but since the remote uses
+		 * address 0 we'll use that. nec repeats are ignored too, even
+		 * though the remote sends them.
+		 */
+		rc_keydown(d->rc_dev, RC_PROTO_NEC, RC_SCANCODE_NEC(0, key), 0);
 	}
 
-	for (i = 0; i < ARRAY_SIZE(rc_map_vp7045_table); i++)
-		if (rc5_data(&rc_map_vp7045_table[i]) == key) {
-			*state = REMOTE_KEY_PRESSED;
-			*event = rc_map_vp7045_table[i].keycode;
-			break;
-		}
 	return 0;
 }
 
@@ -265,11 +205,13 @@ static struct dvb_usb_device_properties vp7045_properties = {
 	.power_ctrl       = vp7045_power_ctrl,
 	.read_mac_address = vp7045_read_mac_addr,
 
-	.rc.legacy = {
-		.rc_interval      = 400,
-		.rc_map_table       = rc_map_vp7045_table,
-		.rc_map_size  = ARRAY_SIZE(rc_map_vp7045_table),
-		.rc_query         = vp7045_rc_query,
+	.rc.core = {
+		.rc_interval	= 400,
+		.rc_codes	= RC_MAP_TWINHAN_VP1027_DVBS,
+		.module_name    = KBUILD_MODNAME,
+		.rc_query	= vp7045_rc_query,
+		.allowed_protos = RC_PROTO_BIT_NEC,
+		.scancode_mask	= 0xff,
 	},
 
 	.num_device_descs = 2,
-- 
2.13.5
