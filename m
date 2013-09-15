Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:34475 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab3IOURP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Sep 2013 16:17:15 -0400
Received: by mail-ea0-f173.google.com with SMTP id g10so1635859eak.18
        for <linux-media@vger.kernel.org>; Sun, 15 Sep 2013 13:17:14 -0700 (PDT)
From: David Jedelsky <david.jedelsky@gmail.com>
To: linux-media@vger.kernel.org
Cc: David Jedelsky <david.jedelsky@gmail.com>
Subject: [PATCH] [media] az6027: Added remote control support
Date: Sun, 15 Sep 2013 22:16:55 +0200
Message-Id: <1379276215-3030-1-git-send-email-david.jedelsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added remote control support and possibility to add more RC key tables.
Added module parameter for key table selection or disabling the RC.
Single RC key table is provided (for below mentioned TS35).

This patch was tested on TechniSat SkyStar 2 HD CI USB ID 14f7:0002
with bundled remote control TS35.

Signed-off-by: David Jedelsky <david.jedelsky@gmail.com>
---
 drivers/media/usb/dvb-usb/az6027.c |  108 +++++++++++++++++++++++++++++++++---
 1 file changed, 99 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/az6027.c b/drivers/media/usb/dvb-usb/az6027.c
index ea2d5ee..5c76f7d 100644
--- a/drivers/media/usb/dvb-usb/az6027.c
+++ b/drivers/media/usb/dvb-usb/az6027.c
@@ -23,8 +23,18 @@ int dvb_usb_az6027_debug;
 module_param_named(debug, dvb_usb_az6027_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=info,xfer=2,rc=4 (or-able))." DVB_USB_DEBUG_STATUS);
 
+/* keymaps */
+static int ir_keymap;
+module_param_named(keymap, ir_keymap, int, 0644);
+MODULE_PARM_DESC(keymap, "set keymap: 0=TS35(Skystar2)  other=none");
+
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
+struct rc_map_dvb_usb_table_table {
+	struct rc_map_table *rc_keys;
+	int rc_keys_size;
+};
+
 struct az6027_device_state {
 	struct dvb_ca_en50221 ca;
 	struct mutex ca_mutex;
@@ -385,16 +395,96 @@ static int az6027_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 	return ret;
 }
 
-/* keys for the enclosed remote control */
-static struct rc_map_table rc_map_az6027_table[] = {
-	{ 0x01, KEY_1 },
-	{ 0x02, KEY_2 },
+/* Keys for the remote control TS35 - bundled with TechniSat SkyStar2 HD CI */
+static struct rc_map_table rc_map_skystar2_ts35[] = {
+	{ 0xf520, KEY_CHANNELUP },
+	{ 0xf510, KEY_VOLUMEUP },
+	{ 0xf521, KEY_CHANNELDOWN },
+	{ 0xf511, KEY_VOLUMEDOWN },
+	{ 0xf517, KEY_OK },
+	{ 0xf50d, KEY_MUTE },
+	{ 0xf538, KEY_VIDEO }, /* EXT */
+	{ 0xf523, KEY_AB },
+	{ 0xf50c, KEY_POWER },
+	{ 0xf501, KEY_1 },
+	{ 0xf502, KEY_2 },
+	{ 0xf503, KEY_3 },
+	{ 0xf513, KEY_TV },
+	{ 0xf504, KEY_4 },
+	{ 0xf505, KEY_5 },
+	{ 0xf506, KEY_6 },
+	{ 0xf50a, KEY_LIST }, /* -/-- */
+	{ 0xf507, KEY_7 },
+	{ 0xf508, KEY_8 },
+	{ 0xf509, KEY_9 },
+	{ 0xf500, KEY_0 },
+	{ 0xf50f, KEY_INFO },
+	{ 0xf512, KEY_MENU },
+	{ 0xf52f, KEY_EPG }, /* (*) SFI */
+	{ 0xf522, KEY_BACK },
+	{ 0xf52b, KEY_RED },
+	{ 0xf52c, KEY_GREEN },
+	{ 0xf52d, KEY_YELLOW },
+	{ 0xf52e, KEY_BLUE },
+	{ 0xf536, KEY_PLAY }, /* confirm sign */
+	{ 0xf53c, KEY_TEXT },
+	{ 0xf529, KEY_STOP },
+};
+
+static struct rc_map_dvb_usb_table_table keys_tables[] = {
+	{ rc_map_skystar2_ts35, ARRAY_SIZE(rc_map_skystar2_ts35) },
 };
 
-/* remote control stuff (does not work with my box) */
 static int az6027_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
-	return 0;
+	struct rc_map_table *keymap = d->props.rc.legacy.rc_map_table;
+	int keymap_size = d->props.rc.legacy.rc_map_size;
+	int ret;
+	int i;
+	u8 b[10];
+	u8 req = 0xB4;
+	u16 value = 5;
+	u16 index = 0;
+	int blen = 10;
+
+	*state = REMOTE_NO_KEY_PRESSED;
+	ret = az6027_usb_in_op(d, req, value, index, b, blen);
+	if (ret != 0) {
+		ret = -EIO;
+		goto out;
+	}
+	ret = 0;
+
+	deb_rc("in: req. %02x, val: %04x, buffer: ", req, value);
+	debug_dump(b, blen, deb_rc);
+
+	/* override keymap */
+	if ((ir_keymap > 0) && (ir_keymap <= ARRAY_SIZE(keys_tables))) {
+		keymap = keys_tables[ir_keymap - 1].rc_keys;
+		keymap_size = keys_tables[ir_keymap - 1].rc_keys_size;
+	} else if (ir_keymap > ARRAY_SIZE(keys_tables))
+		goto out; /* RC disabled */
+
+	if (b[3] + b[4] == 0xff) {
+		/* key pressed */
+		for (i = 0; i < keymap_size; i++) {
+			if (rc5_data(&keymap[i]) == b[3]) {
+				*state = REMOTE_KEY_PRESSED;
+				*event = keymap[i].keycode;
+				break;
+			}
+		}
+
+		if ((*state) == REMOTE_KEY_PRESSED)
+			deb_rc("%s: found rc key: %x, %x, event: %x\n",
+					__func__, b[2], b[3], (*event));
+		else
+			deb_rc("%s: unknown rc key: %x, %x\n",
+					__func__, b[2], b[3]);
+	}
+
+out:
+	return ret;
 }
 
 /*
@@ -1128,9 +1218,9 @@ static struct dvb_usb_device_properties az6027_properties = {
 	.read_mac_address = az6027_read_mac_addr,
  */
 	.rc.legacy = {
-		.rc_map_table     = rc_map_az6027_table,
-		.rc_map_size      = ARRAY_SIZE(rc_map_az6027_table),
-		.rc_interval      = 400,
+		.rc_map_table     = rc_map_skystar2_ts35,
+		.rc_map_size      = ARRAY_SIZE(rc_map_skystar2_ts35),
+		.rc_interval      = 150,
 		.rc_query         = az6027_rc_query,
 	},
 
-- 
1.7.10.4

