Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720Ab0HACx4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 22:53:56 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o712ruEV002922
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 31 Jul 2010 22:53:56 -0400
Received: from pedra (vpn-10-93.rdu.redhat.com [10.11.10.93])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o712rkwF027490
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 31 Jul 2010 22:53:51 -0400
Date: Sat, 31 Jul 2010 23:54:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/7] V4L/DVB: dvb-usb: get rid of struct dvb_usb_rc_key
Message-ID: <20100731235403.1210e666@pedra>
In-Reply-To: <cover.1280630041.git.mchehab@redhat.com>
References: <cover.1280630041.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dvb-usb has its own IR handle code. Now that we have a Remote
Controller subsystem, we should start using it. So, remove this
struct, in favor of the similar struct defined at the RC subsystem.

This is a big, but trivial patch. It is a 3 line delect, plus
lots of rename on several dvb-usb files.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/dvb-usb/a800.c b/drivers/media/dvb/dvb-usb/a800.c
index b6cbb1d..5580383 100644
--- a/drivers/media/dvb/dvb-usb/a800.c
+++ b/drivers/media/dvb/dvb-usb/a800.c
@@ -37,7 +37,7 @@ static int a800_identify_state(struct usb_device *udev, struct dvb_usb_device_pr
 	return 0;
 }
 
-static struct dvb_usb_rc_key ir_codes_a800_table[] = {
+static struct ir_scancode ir_codes_a800_table[] = {
 	{ 0x0201, KEY_PROG1 },       /* SOURCE */
 	{ 0x0200, KEY_POWER },       /* POWER */
 	{ 0x0205, KEY_1 },           /* 1 */
diff --git a/drivers/media/dvb/dvb-usb/af9005-remote.c b/drivers/media/dvb/dvb-usb/af9005-remote.c
index b41fa87..696207f 100644
--- a/drivers/media/dvb/dvb-usb/af9005-remote.c
+++ b/drivers/media/dvb/dvb-usb/af9005-remote.c
@@ -33,7 +33,7 @@ MODULE_PARM_DESC(debug,
 
 #define deb_decode(args...)   dprintk(dvb_usb_af9005_remote_debug,0x01,args)
 
-struct dvb_usb_rc_key ir_codes_af9005_table[] = {
+struct ir_scancode ir_codes_af9005_table[] = {
 
 	{0x01b7, KEY_POWER},
 	{0x01a7, KEY_VOLUMEUP},
@@ -133,7 +133,7 @@ int af9005_rc_decode(struct dvb_usb_device *d, u8 * data, int len, u32 * event,
 			for (i = 0; i < ir_codes_af9005_table_size; i++) {
 				if (rc5_custom(&ir_codes_af9005_table[i]) == cust
 				    && rc5_data(&ir_codes_af9005_table[i]) == dat) {
-					*event = ir_codes_af9005_table[i].event;
+					*event = ir_codes_af9005_table[i].keycode;
 					*state = REMOTE_KEY_PRESSED;
 					deb_decode
 					    ("key pressed, event %x\n", *event);
diff --git a/drivers/media/dvb/dvb-usb/af9005.h b/drivers/media/dvb/dvb-usb/af9005.h
index 088e708..3c1fbd1 100644
--- a/drivers/media/dvb/dvb-usb/af9005.h
+++ b/drivers/media/dvb/dvb-usb/af9005.h
@@ -3490,7 +3490,7 @@ extern u8 regmask[8];
 /* remote control decoder */
 extern int af9005_rc_decode(struct dvb_usb_device *d, u8 * data, int len,
 			    u32 * event, int *state);
-extern struct dvb_usb_rc_key ir_codes_af9005_table[];
+extern struct ir_scancode ir_codes_af9005_table[];
 extern int ir_codes_af9005_table_size;
 
 #endif
diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index 2fb24c3..c63134c 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -735,7 +735,7 @@ error:
 
 struct af9015_setup {
 	unsigned int id;
-	struct dvb_usb_rc_key *rc_key_map;
+	struct ir_scancode *rc_key_map;
 	unsigned int rc_key_map_size;
 	u8 *ir_table;
 	unsigned int ir_table_size;
@@ -1063,7 +1063,7 @@ static int af9015_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
 	u8 buf[8];
 	struct req_t req = {GET_IR_CODE, 0, 0, 0, 0, sizeof(buf), buf};
-	struct dvb_usb_rc_key *keymap = d->props.rc_key_map;
+	struct ir_scancode *keymap = d->props.rc_key_map;
 	int i, ret;
 
 	memset(buf, 0, sizeof(buf));
@@ -1078,7 +1078,7 @@ static int af9015_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	for (i = 0; i < d->props.rc_key_map_size; i++) {
 		if (!buf[1] && rc5_custom(&keymap[i]) == buf[0] &&
 		    rc5_data(&keymap[i]) == buf[2]) {
-			*event = keymap[i].event;
+			*event = keymap[i].keycode;
 			*state = REMOTE_KEY_PRESSED;
 			break;
 		}
diff --git a/drivers/media/dvb/dvb-usb/af9015.h b/drivers/media/dvb/dvb-usb/af9015.h
index 63b2a49..c8e9349 100644
--- a/drivers/media/dvb/dvb-usb/af9015.h
+++ b/drivers/media/dvb/dvb-usb/af9015.h
@@ -123,7 +123,7 @@ enum af9015_remote {
 
 /* LeadTek - Y04G0051 */
 /* Leadtek WinFast DTV Dongle Gold */
-static struct dvb_usb_rc_key ir_codes_af9015_table_leadtek[] = {
+static struct ir_scancode ir_codes_af9015_table_leadtek[] = {
 	{ 0x001e, KEY_1 },
 	{ 0x001f, KEY_2 },
 	{ 0x0020, KEY_3 },
@@ -227,7 +227,7 @@ static u8 af9015_ir_table_leadtek[] = {
 };
 
 /* TwinHan AzureWave AD-TU700(704J) */
-static struct dvb_usb_rc_key ir_codes_af9015_table_twinhan[] = {
+static struct ir_scancode ir_codes_af9015_table_twinhan[] = {
 	{ 0x053f, KEY_POWER },
 	{ 0x0019, KEY_FAVORITES },    /* Favorite List */
 	{ 0x0004, KEY_TEXT },         /* Teletext */
@@ -338,7 +338,7 @@ static u8 af9015_ir_table_twinhan[] = {
 };
 
 /* A-Link DTU(m) */
-static struct dvb_usb_rc_key ir_codes_af9015_table_a_link[] = {
+static struct ir_scancode ir_codes_af9015_table_a_link[] = {
 	{ 0x001e, KEY_1 },
 	{ 0x001f, KEY_2 },
 	{ 0x0020, KEY_3 },
@@ -381,7 +381,7 @@ static u8 af9015_ir_table_a_link[] = {
 };
 
 /* MSI DIGIVOX mini II V3.0 */
-static struct dvb_usb_rc_key ir_codes_af9015_table_msi[] = {
+static struct ir_scancode ir_codes_af9015_table_msi[] = {
 	{ 0x001e, KEY_1 },
 	{ 0x001f, KEY_2 },
 	{ 0x0020, KEY_3 },
@@ -424,7 +424,7 @@ static u8 af9015_ir_table_msi[] = {
 };
 
 /* MYGICTV U718 */
-static struct dvb_usb_rc_key ir_codes_af9015_table_mygictv[] = {
+static struct ir_scancode ir_codes_af9015_table_mygictv[] = {
 	{ 0x003d, KEY_SWITCHVIDEOMODE },
 					  /* TV / AV */
 	{ 0x0545, KEY_POWER },
@@ -550,7 +550,7 @@ static u8 af9015_ir_table_kworld[] = {
 };
 
 /* AverMedia Volar X */
-static struct dvb_usb_rc_key ir_codes_af9015_table_avermedia[] = {
+static struct ir_scancode ir_codes_af9015_table_avermedia[] = {
 	{ 0x053d, KEY_PROG1 },       /* SOURCE */
 	{ 0x0512, KEY_POWER },       /* POWER */
 	{ 0x051e, KEY_1 },           /* 1 */
@@ -656,7 +656,7 @@ static u8 af9015_ir_table_avermedia_ks[] = {
 };
 
 /* Digittrade DVB-T USB Stick */
-static struct dvb_usb_rc_key ir_codes_af9015_table_digittrade[] = {
+static struct ir_scancode ir_codes_af9015_table_digittrade[] = {
 	{ 0x010f, KEY_LAST },	/* RETURN */
 	{ 0x0517, KEY_TEXT },	/* TELETEXT */
 	{ 0x0108, KEY_EPG },	/* EPG */
@@ -719,7 +719,7 @@ static u8 af9015_ir_table_digittrade[] = {
 };
 
 /* TREKSTOR DVB-T USB Stick */
-static struct dvb_usb_rc_key ir_codes_af9015_table_trekstor[] = {
+static struct ir_scancode ir_codes_af9015_table_trekstor[] = {
 	{ 0x0704, KEY_AGAIN },		/* Home */
 	{ 0x0705, KEY_MUTE },		/* Mute */
 	{ 0x0706, KEY_UP },			/* Up */
@@ -782,7 +782,7 @@ static u8 af9015_ir_table_trekstor[] = {
 };
 
 /* MSI DIGIVOX mini III */
-static struct dvb_usb_rc_key ir_codes_af9015_table_msi_digivox_iii[] = {
+static struct ir_scancode ir_codes_af9015_table_msi_digivox_iii[] = {
 	{ 0x0713, KEY_POWER },       /* [red power button] */
 	{ 0x073b, KEY_VIDEO },       /* Source */
 	{ 0x073e, KEY_ZOOM },        /* Zoom */
diff --git a/drivers/media/dvb/dvb-usb/anysee.c b/drivers/media/dvb/dvb-usb/anysee.c
index aa5c7d5..3e39e8f 100644
--- a/drivers/media/dvb/dvb-usb/anysee.c
+++ b/drivers/media/dvb/dvb-usb/anysee.c
@@ -377,7 +377,7 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
 static int anysee_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
 	u8 buf[] = {CMD_GET_IR_CODE};
-	struct dvb_usb_rc_key *keymap = d->props.rc_key_map;
+	struct ir_scancode *keymap = d->props.rc_key_map;
 	u8 ircode[2];
 	int i, ret;
 
@@ -391,7 +391,7 @@ static int anysee_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	for (i = 0; i < d->props.rc_key_map_size; i++) {
 		if (rc5_custom(&keymap[i]) == ircode[0] &&
 		    rc5_data(&keymap[i]) == ircode[1]) {
-			*event = keymap[i].event;
+			*event = keymap[i].keycode;
 			*state = REMOTE_KEY_PRESSED;
 			return 0;
 		}
@@ -399,7 +399,7 @@ static int anysee_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	return 0;
 }
 
-static struct dvb_usb_rc_key ir_codes_anysee_table[] = {
+static struct ir_scancode ir_codes_anysee_table[] = {
 	{ 0x0100, KEY_0 },
 	{ 0x0101, KEY_1 },
 	{ 0x0102, KEY_2 },
diff --git a/drivers/media/dvb/dvb-usb/az6027.c b/drivers/media/dvb/dvb-usb/az6027.c
index 6681ac1..03d9bfe 100644
--- a/drivers/media/dvb/dvb-usb/az6027.c
+++ b/drivers/media/dvb/dvb-usb/az6027.c
@@ -386,7 +386,7 @@ static int az6027_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 }
 
 /* keys for the enclosed remote control */
-static struct dvb_usb_rc_key ir_codes_az6027_table[] = {
+static struct ir_scancode ir_codes_az6027_table[] = {
 	{ 0x01, KEY_1 },
 	{ 0x02, KEY_2 },
 };
diff --git a/drivers/media/dvb/dvb-usb/cinergyT2-core.c b/drivers/media/dvb/dvb-usb/cinergyT2-core.c
index 5a9c14b..806d781 100644
--- a/drivers/media/dvb/dvb-usb/cinergyT2-core.c
+++ b/drivers/media/dvb/dvb-usb/cinergyT2-core.c
@@ -84,7 +84,7 @@ static int cinergyt2_frontend_attach(struct dvb_usb_adapter *adap)
 	return 0;
 }
 
-static struct dvb_usb_rc_key ir_codes_cinergyt2_table[] = {
+static struct ir_scancode ir_codes_cinergyt2_table[] = {
 	{ 0x0401, KEY_POWER },
 	{ 0x0402, KEY_1 },
 	{ 0x0403, KEY_2 },
diff --git a/drivers/media/dvb/dvb-usb/cxusb.c b/drivers/media/dvb/dvb-usb/cxusb.c
index 11e9e85..22fc0a9 100644
--- a/drivers/media/dvb/dvb-usb/cxusb.c
+++ b/drivers/media/dvb/dvb-usb/cxusb.c
@@ -385,7 +385,7 @@ static int cxusb_d680_dmb_streaming_ctrl(
 
 static int cxusb_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
-	struct dvb_usb_rc_key *keymap = d->props.rc_key_map;
+	struct ir_scancode *keymap = d->props.rc_key_map;
 	u8 ircode[4];
 	int i;
 
@@ -397,7 +397,7 @@ static int cxusb_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	for (i = 0; i < d->props.rc_key_map_size; i++) {
 		if (rc5_custom(&keymap[i]) == ircode[2] &&
 		    rc5_data(&keymap[i]) == ircode[3]) {
-			*event = keymap[i].event;
+			*event = keymap[i].keycode;
 			*state = REMOTE_KEY_PRESSED;
 
 			return 0;
@@ -410,7 +410,7 @@ static int cxusb_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 static int cxusb_bluebird2_rc_query(struct dvb_usb_device *d, u32 *event,
 				    int *state)
 {
-	struct dvb_usb_rc_key *keymap = d->props.rc_key_map;
+	struct ir_scancode *keymap = d->props.rc_key_map;
 	u8 ircode[4];
 	int i;
 	struct i2c_msg msg = { .addr = 0x6b, .flags = I2C_M_RD,
@@ -425,7 +425,7 @@ static int cxusb_bluebird2_rc_query(struct dvb_usb_device *d, u32 *event,
 	for (i = 0; i < d->props.rc_key_map_size; i++) {
 		if (rc5_custom(&keymap[i]) == ircode[1] &&
 		    rc5_data(&keymap[i]) == ircode[2]) {
-			*event = keymap[i].event;
+			*event = keymap[i].keycode;
 			*state = REMOTE_KEY_PRESSED;
 
 			return 0;
@@ -438,7 +438,7 @@ static int cxusb_bluebird2_rc_query(struct dvb_usb_device *d, u32 *event,
 static int cxusb_d680_dmb_rc_query(struct dvb_usb_device *d, u32 *event,
 		int *state)
 {
-	struct dvb_usb_rc_key *keymap = d->props.rc_key_map;
+	struct ir_scancode *keymap = d->props.rc_key_map;
 	u8 ircode[2];
 	int i;
 
@@ -451,7 +451,7 @@ static int cxusb_d680_dmb_rc_query(struct dvb_usb_device *d, u32 *event,
 	for (i = 0; i < d->props.rc_key_map_size; i++) {
 		if (rc5_custom(&keymap[i]) == ircode[0] &&
 		    rc5_data(&keymap[i]) == ircode[1]) {
-			*event = keymap[i].event;
+			*event = keymap[i].keycode;
 			*state = REMOTE_KEY_PRESSED;
 
 			return 0;
@@ -461,7 +461,7 @@ static int cxusb_d680_dmb_rc_query(struct dvb_usb_device *d, u32 *event,
 	return 0;
 }
 
-static struct dvb_usb_rc_key ir_codes_dvico_mce_table[] = {
+static struct ir_scancode ir_codes_dvico_mce_table[] = {
 	{ 0xfe02, KEY_TV },
 	{ 0xfe0e, KEY_MP3 },
 	{ 0xfe1a, KEY_DVD },
@@ -509,7 +509,7 @@ static struct dvb_usb_rc_key ir_codes_dvico_mce_table[] = {
 	{ 0xfe4e, KEY_POWER },
 };
 
-static struct dvb_usb_rc_key ir_codes_dvico_portable_table[] = {
+static struct ir_scancode ir_codes_dvico_portable_table[] = {
 	{ 0xfc02, KEY_SETUP },       /* Profile */
 	{ 0xfc43, KEY_POWER2 },
 	{ 0xfc06, KEY_EPG },
@@ -548,7 +548,7 @@ static struct dvb_usb_rc_key ir_codes_dvico_portable_table[] = {
 	{ 0xfc00, KEY_UNKNOWN },    /* HD */
 };
 
-static struct dvb_usb_rc_key ir_codes_d680_dmb_table[] = {
+static struct ir_scancode ir_codes_d680_dmb_table[] = {
 	{ 0x0038, KEY_UNKNOWN },	/* TV/AV */
 	{ 0x080c, KEY_ZOOM },
 	{ 0x0800, KEY_0 },
diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index 7deade7..f761897 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -491,7 +491,7 @@ struct dib0700_rc_response {
 static void dib0700_rc_urb_completion(struct urb *purb)
 {
 	struct dvb_usb_device *d = purb->context;
-	struct dvb_usb_rc_key *keymap;
+	struct ir_scancode *keymap;
 	struct dib0700_state *st;
 	struct dib0700_rc_response poll_reply;
 	u8 *buf;
@@ -574,7 +574,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 	for (i = 0; i < d->props.rc_key_map_size; i++) {
 		if (rc5_custom(&keymap[i]) == (poll_reply.system & 0xff) &&
 		    rc5_data(&keymap[i]) == poll_reply.data) {
-			event = keymap[i].event;
+			event = keymap[i].keycode;
 			found = 1;
 			break;
 		}
@@ -590,9 +590,9 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 	if (poll_reply.data_state == 1) {
 		/* New key hit */
 		st->rc_counter = 0;
-		event = keymap[i].event;
+		event = keymap[i].keycode;
 		state = REMOTE_KEY_PRESSED;
-		d->last_event = keymap[i].event;
+		d->last_event = keymap[i].keycode;
 	} else if (poll_reply.data_state == 2) {
 		/* Key repeated */
 		st->rc_counter++;
diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index 800800a..0c9adbb 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -477,7 +477,7 @@ static int dib0700_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
 	u8 key[4];
 	int i;
-	struct dvb_usb_rc_key *keymap = d->props.rc_key_map;
+	struct ir_scancode *keymap = d->props.rc_key_map;
 	struct dib0700_state *st = d->priv;
 
 	*event = 0;
@@ -521,9 +521,9 @@ static int dib0700_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 			if (rc5_custom(&keymap[i]) == key[3-2] &&
 			    rc5_data(&keymap[i]) == key[3-3]) {
 				st->rc_counter = 0;
-				*event = keymap[i].event;
+				*event = keymap[i].keycode;
 				*state = REMOTE_KEY_PRESSED;
-				d->last_event = keymap[i].event;
+				d->last_event = keymap[i].keycode;
 				return 0;
 			}
 		}
@@ -534,7 +534,7 @@ static int dib0700_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 		for (i = 0; i < d->props.rc_key_map_size; i++) {
 			if (rc5_custom(&keymap[i]) == key[3-2] &&
 			    rc5_data(&keymap[i]) == key[3-3]) {
-				if (d->last_event == keymap[i].event &&
+				if (d->last_event == keymap[i].keycode &&
 					key[3-1] == st->rc_toggle) {
 					st->rc_counter++;
 					/* prevents unwanted double hits */
@@ -547,10 +547,10 @@ static int dib0700_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 					return 0;
 				}
 				st->rc_counter = 0;
-				*event = keymap[i].event;
+				*event = keymap[i].keycode;
 				*state = REMOTE_KEY_PRESSED;
 				st->rc_toggle = key[3-1];
-				d->last_event = keymap[i].event;
+				d->last_event = keymap[i].keycode;
 				return 0;
 			}
 		}
@@ -562,7 +562,7 @@ static int dib0700_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	return 0;
 }
 
-static struct dvb_usb_rc_key ir_codes_dib0700_table[] = {
+static struct ir_scancode ir_codes_dib0700_table[] = {
 	/* Key codes for the tiny Pinnacle remote*/
 	{ 0x0700, KEY_MUTE },
 	{ 0x0701, KEY_MENU }, /* Pinnacle logo */
diff --git a/drivers/media/dvb/dvb-usb/dibusb-common.c b/drivers/media/dvb/dvb-usb/dibusb-common.c
index bc08bc0..ba991aa 100644
--- a/drivers/media/dvb/dvb-usb/dibusb-common.c
+++ b/drivers/media/dvb/dvb-usb/dibusb-common.c
@@ -327,7 +327,7 @@ EXPORT_SYMBOL(dibusb_dib3000mc_tuner_attach);
 /*
  * common remote control stuff
  */
-struct dvb_usb_rc_key ir_codes_dibusb_table[] = {
+struct ir_scancode ir_codes_dibusb_table[] = {
 	/* Key codes for the little Artec T1/Twinhan/HAMA/ remote. */
 	{ 0x0016, KEY_POWER },
 	{ 0x0010, KEY_MUTE },
diff --git a/drivers/media/dvb/dvb-usb/dibusb.h b/drivers/media/dvb/dvb-usb/dibusb.h
index 3d50ac5..61a6bf3 100644
--- a/drivers/media/dvb/dvb-usb/dibusb.h
+++ b/drivers/media/dvb/dvb-usb/dibusb.h
@@ -124,7 +124,7 @@ extern int dibusb2_0_power_ctrl(struct dvb_usb_device *, int);
 #define DEFAULT_RC_INTERVAL 150
 //#define DEFAULT_RC_INTERVAL 100000
 
-extern struct dvb_usb_rc_key ir_codes_dibusb_table[];
+extern struct ir_scancode ir_codes_dibusb_table[];
 extern int dibusb_rc_query(struct dvb_usb_device *, u32 *, int *);
 extern int dibusb_read_eeprom_byte(struct dvb_usb_device *, u8, u8 *);
 
diff --git a/drivers/media/dvb/dvb-usb/digitv.c b/drivers/media/dvb/dvb-usb/digitv.c
index e826077..73f14a2 100644
--- a/drivers/media/dvb/dvb-usb/digitv.c
+++ b/drivers/media/dvb/dvb-usb/digitv.c
@@ -161,7 +161,7 @@ static int digitv_tuner_attach(struct dvb_usb_adapter *adap)
 	return 0;
 }
 
-static struct dvb_usb_rc_key ir_codes_digitv_table[] = {
+static struct ir_scancode ir_codes_digitv_table[] = {
 	{ 0x5f55, KEY_0 },
 	{ 0x6f55, KEY_1 },
 	{ 0x9f55, KEY_2 },
@@ -240,7 +240,7 @@ static int digitv_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 		  for (i = 0; i < d->props.rc_key_map_size; i++) {
 			if (rc5_custom(&d->props.rc_key_map[i]) == key[1] &&
 			    rc5_data(&d->props.rc_key_map[i]) == key[2]) {
-				*event = d->props.rc_key_map[i].event;
+				*event = d->props.rc_key_map[i].keycode;
 				*state = REMOTE_KEY_PRESSED;
 				return 0;
 			}
diff --git a/drivers/media/dvb/dvb-usb/dtt200u.c b/drivers/media/dvb/dvb-usb/dtt200u.c
index f57e590..c0de0c0 100644
--- a/drivers/media/dvb/dvb-usb/dtt200u.c
+++ b/drivers/media/dvb/dvb-usb/dtt200u.c
@@ -57,7 +57,7 @@ static int dtt200u_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid,
 
 /* remote control */
 /* key list for the tiny remote control (Yakumo, don't know about the others) */
-static struct dvb_usb_rc_key ir_codes_dtt200u_table[] = {
+static struct ir_scancode ir_codes_dtt200u_table[] = {
 	{ 0x8001, KEY_MUTE },
 	{ 0x8002, KEY_CHANNELDOWN },
 	{ 0x8003, KEY_VOLUMEDOWN },
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
index 852fe89..e210f2f 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
@@ -13,13 +13,13 @@ static int dvb_usb_getkeycode(struct input_dev *dev,
 {
 	struct dvb_usb_device *d = input_get_drvdata(dev);
 
-	struct dvb_usb_rc_key *keymap = d->props.rc_key_map;
+	struct ir_scancode *keymap = d->props.rc_key_map;
 	int i;
 
 	/* See if we can match the raw key code. */
 	for (i = 0; i < d->props.rc_key_map_size; i++)
-		if (keymap[i].scan == scancode) {
-			*keycode = keymap[i].event;
+		if (keymap[i].scancode == scancode) {
+			*keycode = keymap[i].keycode;
 			return 0;
 		}
 
@@ -29,8 +29,8 @@ static int dvb_usb_getkeycode(struct input_dev *dev,
 	 * to work
 	 */
 	for (i = 0; i < d->props.rc_key_map_size; i++)
-		if (keymap[i].event == KEY_RESERVED ||
-		    keymap[i].event == KEY_UNKNOWN) {
+		if (keymap[i].keycode == KEY_RESERVED ||
+		    keymap[i].keycode == KEY_UNKNOWN) {
 			*keycode = KEY_RESERVED;
 			return 0;
 		}
@@ -43,22 +43,22 @@ static int dvb_usb_setkeycode(struct input_dev *dev,
 {
 	struct dvb_usb_device *d = input_get_drvdata(dev);
 
-	struct dvb_usb_rc_key *keymap = d->props.rc_key_map;
+	struct ir_scancode *keymap = d->props.rc_key_map;
 	int i;
 
 	/* Search if it is replacing an existing keycode */
 	for (i = 0; i < d->props.rc_key_map_size; i++)
-		if (keymap[i].scan == scancode) {
-			keymap[i].event = keycode;
+		if (keymap[i].scancode == scancode) {
+			keymap[i].keycode = keycode;
 			return 0;
 		}
 
 	/* Search if is there a clean entry. If so, use it */
 	for (i = 0; i < d->props.rc_key_map_size; i++)
-		if (keymap[i].event == KEY_RESERVED ||
-		    keymap[i].event == KEY_UNKNOWN) {
-			keymap[i].scan = scancode;
-			keymap[i].event = keycode;
+		if (keymap[i].keycode == KEY_RESERVED ||
+		    keymap[i].keycode == KEY_UNKNOWN) {
+			keymap[i].scancode = scancode;
+			keymap[i].keycode = keycode;
 			return 0;
 		}
 
@@ -184,8 +184,8 @@ int dvb_usb_remote_init(struct dvb_usb_device *d)
 	deb_rc("key map size: %d\n", d->props.rc_key_map_size);
 	for (i = 0; i < d->props.rc_key_map_size; i++) {
 		deb_rc("setting bit for event %d item %d\n",
-			d->props.rc_key_map[i].event, i);
-		set_bit(d->props.rc_key_map[i].event, input_dev->keybit);
+			d->props.rc_key_map[i].keycode, i);
+		set_bit(d->props.rc_key_map[i].keycode, input_dev->keybit);
 	}
 
 	/* Start the remote-control polling. */
@@ -234,7 +234,7 @@ int dvb_usb_nec_rc_key_to_event(struct dvb_usb_device *d,
 		u8 keybuf[5], u32 *event, int *state)
 {
 	int i;
-	struct dvb_usb_rc_key *keymap = d->props.rc_key_map;
+	struct ir_scancode *keymap = d->props.rc_key_map;
 	*event = 0;
 	*state = REMOTE_NO_KEY_PRESSED;
 	switch (keybuf[0]) {
@@ -250,7 +250,7 @@ int dvb_usb_nec_rc_key_to_event(struct dvb_usb_device *d,
 			for (i = 0; i < d->props.rc_key_map_size; i++)
 				if (rc5_custom(&keymap[i]) == keybuf[1] &&
 					rc5_data(&keymap[i]) == keybuf[3]) {
-					*event = keymap[i].event;
+					*event = keymap[i].keycode;
 					*state = REMOTE_KEY_PRESSED;
 					return 0;
 				}
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb.h b/drivers/media/dvb/dvb-usb/dvb-usb.h
index 4a9f676..832bbfd 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb.h
@@ -14,6 +14,7 @@
 #include <linux/usb.h>
 #include <linux/firmware.h>
 #include <linux/mutex.h>
+#include <media/rc-map.h>
 
 #include "dvb_frontend.h"
 #include "dvb_demux.h"
@@ -74,30 +75,19 @@ struct dvb_usb_device_description {
 	struct usb_device_id *warm_ids[DVB_USB_ID_MAX_NUM];
 };
 
-/**
- * struct dvb_usb_rc_key - a remote control key and its input-event
- * @custom: the vendor/custom part of the key
- * @data: the actual key part
- * @event: the input event assigned to key identified by custom and data
- */
-struct dvb_usb_rc_key {
-	u16 scan;
-	u32 event;
-};
-
-static inline u8 rc5_custom(struct dvb_usb_rc_key *key)
+static inline u8 rc5_custom(struct ir_scancode *key)
 {
-	return (key->scan >> 8) & 0xff;
+	return (key->scancode >> 8) & 0xff;
 }
 
-static inline u8 rc5_data(struct dvb_usb_rc_key *key)
+static inline u8 rc5_data(struct ir_scancode *key)
 {
-	return key->scan & 0xff;
+	return key->scancode & 0xff;
 }
 
-static inline u8 rc5_scan(struct dvb_usb_rc_key *key)
+static inline u8 rc5_scan(struct ir_scancode *key)
 {
-	return key->scan & 0xffff;
+	return key->scancode & 0xffff;
 }
 
 struct dvb_usb_device;
@@ -185,7 +175,7 @@ struct dvb_usb_adapter_properties {
  * @identify_state: called to determine the state (cold or warm), when it
  *  is not distinguishable by the USB IDs.
  *
- * @rc_key_map: a hard-wired array of struct dvb_usb_rc_key (NULL to disable
+ * @rc_key_map: a hard-wired array of struct ir_scancode (NULL to disable
  *  remote control handling).
  * @rc_key_map_size: number of items in @rc_key_map.
  * @rc_query: called to query an event event.
@@ -237,7 +227,7 @@ struct dvb_usb_device_properties {
 #define REMOTE_NO_KEY_PRESSED      0x00
 #define REMOTE_KEY_PRESSED         0x01
 #define REMOTE_KEY_REPEAT          0x02
-	struct dvb_usb_rc_key  *rc_key_map;
+	struct ir_scancode  *rc_key_map;
 	int rc_key_map_size;
 	int (*rc_query) (struct dvb_usb_device *, u32 *, int *);
 	int rc_interval;
diff --git a/drivers/media/dvb/dvb-usb/dw2102.c b/drivers/media/dvb/dvb-usb/dw2102.c
index e8fb853..2528e06 100644
--- a/drivers/media/dvb/dvb-usb/dw2102.c
+++ b/drivers/media/dvb/dvb-usb/dw2102.c
@@ -74,7 +74,7 @@
 		"on firmware-problems."
 
 struct ir_codes_dvb_usb_table_table {
-	struct dvb_usb_rc_key *rc_keys;
+	struct ir_scancode *rc_keys;
 	int rc_keys_size;
 };
 
@@ -948,7 +948,7 @@ static int dw3101_tuner_attach(struct dvb_usb_adapter *adap)
 	return 0;
 }
 
-static struct dvb_usb_rc_key ir_codes_dw210x_table[] = {
+static struct ir_scancode ir_codes_dw210x_table[] = {
 	{ 0xf80a, KEY_Q },		/*power*/
 	{ 0xf80c, KEY_M },		/*mute*/
 	{ 0xf811, KEY_1 },
@@ -982,7 +982,7 @@ static struct dvb_usb_rc_key ir_codes_dw210x_table[] = {
 	{ 0xf81b, KEY_B },		/*recall*/
 };
 
-static struct dvb_usb_rc_key ir_codes_tevii_table[] = {
+static struct ir_scancode ir_codes_tevii_table[] = {
 	{ 0xf80a, KEY_POWER },
 	{ 0xf80c, KEY_MUTE },
 	{ 0xf811, KEY_1 },
@@ -1032,7 +1032,7 @@ static struct dvb_usb_rc_key ir_codes_tevii_table[] = {
 	{ 0xf858, KEY_SWITCHVIDEOMODE },
 };
 
-static struct dvb_usb_rc_key ir_codes_tbs_table[] = {
+static struct ir_scancode ir_codes_tbs_table[] = {
 	{ 0xf884, KEY_POWER },
 	{ 0xf894, KEY_MUTE },
 	{ 0xf887, KEY_1 },
@@ -1075,7 +1075,7 @@ static struct ir_codes_dvb_usb_table_table keys_tables[] = {
 
 static int dw2102_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
-	struct dvb_usb_rc_key *keymap = d->props.rc_key_map;
+	struct ir_scancode *keymap = d->props.rc_key_map;
 	int keymap_size = d->props.rc_key_map_size;
 	u8 key[2];
 	struct i2c_msg msg = {
@@ -1096,7 +1096,7 @@ static int dw2102_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 		for (i = 0; i < keymap_size ; i++) {
 			if (rc5_data(&keymap[i]) == msg.buf[0]) {
 				*state = REMOTE_KEY_PRESSED;
-				*event = keymap[i].event;
+				*event = keymap[i].keycode;
 				break;
 			}
 
diff --git a/drivers/media/dvb/dvb-usb/m920x.c b/drivers/media/dvb/dvb-usb/m920x.c
index c211fef..1e1cb6b 100644
--- a/drivers/media/dvb/dvb-usb/m920x.c
+++ b/drivers/media/dvb/dvb-usb/m920x.c
@@ -144,7 +144,7 @@ static int m920x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 
 	for (i = 0; i < d->props.rc_key_map_size; i++)
 		if (rc5_data(&d->props.rc_key_map[i]) == rc_state[1]) {
-			*event = d->props.rc_key_map[i].event;
+			*event = d->props.rc_key_map[i].keycode;
 
 			switch(rc_state[0]) {
 			case 0x80:
@@ -589,7 +589,7 @@ static struct m920x_inits pinnacle310e_init[] = {
 };
 
 /* ir keymaps */
-static struct dvb_usb_rc_key ir_codes_megasky_table [] = {
+static struct ir_scancode ir_codes_megasky_table[] = {
 	{ 0x0012, KEY_POWER },
 	{ 0x001e, KEY_CYCLEWINDOWS }, /* min/max */
 	{ 0x0002, KEY_CHANNELUP },
@@ -608,7 +608,7 @@ static struct dvb_usb_rc_key ir_codes_megasky_table [] = {
 	{ 0x000e, KEY_COFFEE }, /* "MTS" */
 };
 
-static struct dvb_usb_rc_key ir_codes_tvwalkertwin_table [] = {
+static struct ir_scancode ir_codes_tvwalkertwin_table[] = {
 	{ 0x0001, KEY_ZOOM }, /* Full Screen */
 	{ 0x0002, KEY_CAMERA }, /* snapshot */
 	{ 0x0003, KEY_MUTE },
@@ -628,7 +628,7 @@ static struct dvb_usb_rc_key ir_codes_tvwalkertwin_table [] = {
 	{ 0x001e, KEY_VOLUMEUP },
 };
 
-static struct dvb_usb_rc_key ir_codes_pinnacle310e_table[] = {
+static struct ir_scancode ir_codes_pinnacle310e_table[] = {
 	{ 0x16, KEY_POWER },
 	{ 0x17, KEY_FAVORITES },
 	{ 0x0f, KEY_TEXT },
diff --git a/drivers/media/dvb/dvb-usb/nova-t-usb2.c b/drivers/media/dvb/dvb-usb/nova-t-usb2.c
index d195a58..b48e217 100644
--- a/drivers/media/dvb/dvb-usb/nova-t-usb2.c
+++ b/drivers/media/dvb/dvb-usb/nova-t-usb2.c
@@ -21,7 +21,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 #define deb_ee(args...) dprintk(debug,0x02,args)
 
 /* Hauppauge NOVA-T USB2 keys */
-static struct dvb_usb_rc_key ir_codes_haupp_table [] = {
+static struct ir_scancode ir_codes_haupp_table[] = {
 	{ 0x1e00, KEY_0 },
 	{ 0x1e01, KEY_1 },
 	{ 0x1e02, KEY_2 },
@@ -98,7 +98,7 @@ static int nova_t_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 					deb_rc("c: %x, d: %x\n", rc5_data(&ir_codes_haupp_table[i]),
 								 rc5_custom(&ir_codes_haupp_table[i]));
 
-					*event = ir_codes_haupp_table[i].event;
+					*event = ir_codes_haupp_table[i].keycode;
 					*state = REMOTE_KEY_PRESSED;
 					if (st->old_toggle == toggle) {
 						if (st->last_repeat_count++ < 2)
diff --git a/drivers/media/dvb/dvb-usb/opera1.c b/drivers/media/dvb/dvb-usb/opera1.c
index dfb81ff..6a2f9e2 100644
--- a/drivers/media/dvb/dvb-usb/opera1.c
+++ b/drivers/media/dvb/dvb-usb/opera1.c
@@ -331,7 +331,7 @@ static int opera1_pid_filter_control(struct dvb_usb_adapter *adap, int onoff)
 	return 0;
 }
 
-static struct dvb_usb_rc_key ir_codes_opera1_table[] = {
+static struct ir_scancode ir_codes_opera1_table[] = {
 	{0x5fa0, KEY_1},
 	{0x51af, KEY_2},
 	{0x5da2, KEY_3},
@@ -407,9 +407,9 @@ static int opera1_rc_query(struct dvb_usb_device *dev, u32 * event, int *state)
 		for (i = 0; i < ARRAY_SIZE(ir_codes_opera1_table); i++) {
 			if (rc5_scan(&ir_codes_opera1_table[i]) == (send_key & 0xffff)) {
 				*state = REMOTE_KEY_PRESSED;
-				*event = ir_codes_opera1_table[i].event;
+				*event = ir_codes_opera1_table[i].keycode;
 				opst->last_key_pressed =
-					ir_codes_opera1_table[i].event;
+					ir_codes_opera1_table[i].keycode;
 				break;
 			}
 			opst->last_key_pressed = 0;
diff --git a/drivers/media/dvb/dvb-usb/vp702x.c b/drivers/media/dvb/dvb-usb/vp702x.c
index 4d33245..7ea57a4 100644
--- a/drivers/media/dvb/dvb-usb/vp702x.c
+++ b/drivers/media/dvb/dvb-usb/vp702x.c
@@ -174,7 +174,7 @@ static int vp702x_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 }
 
 /* keys for the enclosed remote control */
-static struct dvb_usb_rc_key ir_codes_vp702x_table[] = {
+static struct ir_scancode ir_codes_vp702x_table[] = {
 	{ 0x0001, KEY_1 },
 	{ 0x0002, KEY_2 },
 };
@@ -200,7 +200,7 @@ static int vp702x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	for (i = 0; i < ARRAY_SIZE(ir_codes_vp702x_table); i++)
 		if (rc5_custom(&ir_codes_vp702x_table[i]) == key[1]) {
 			*state = REMOTE_KEY_PRESSED;
-			*event = ir_codes_vp702x_table[i].event;
+			*event = ir_codes_vp702x_table[i].keycode;
 			break;
 		}
 	return 0;
diff --git a/drivers/media/dvb/dvb-usb/vp7045.c b/drivers/media/dvb/dvb-usb/vp7045.c
index 036893f..30663a8 100644
--- a/drivers/media/dvb/dvb-usb/vp7045.c
+++ b/drivers/media/dvb/dvb-usb/vp7045.c
@@ -99,7 +99,7 @@ static int vp7045_power_ctrl(struct dvb_usb_device *d, int onoff)
 
 /* The keymapping struct. Somehow this should be loaded to the driver, but
  * currently it is hardcoded. */
-static struct dvb_usb_rc_key ir_codes_vp7045_table[] = {
+static struct ir_scancode ir_codes_vp7045_table[] = {
 	{ 0x0016, KEY_POWER },
 	{ 0x0010, KEY_MUTE },
 	{ 0x0003, KEY_1 },
@@ -168,7 +168,7 @@ static int vp7045_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	for (i = 0; i < ARRAY_SIZE(ir_codes_vp7045_table); i++)
 		if (rc5_data(&ir_codes_vp7045_table[i]) == key) {
 			*state = REMOTE_KEY_PRESSED;
-			*event = ir_codes_vp7045_table[i].event;
+			*event = ir_codes_vp7045_table[i].keycode;
 			break;
 		}
 	return 0;
-- 
1.7.1


