Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720Ab0HACyT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 22:54:19 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o712sJn0012691
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 31 Jul 2010 22:54:19 -0400
Received: from pedra (vpn-10-93.rdu.redhat.com [10.11.10.93])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o712rkwJ027490
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 31 Jul 2010 22:54:15 -0400
Date: Sat, 31 Jul 2010 23:54:07 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 6/7] V4L/DVB: Port dib0700 to rc-core
Message-ID: <20100731235407.0b8df153@pedra>
In-Reply-To: <cover.1280630041.git.mchehab@redhat.com>
References: <cover.1280630041.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the new rc-core handler at dvb-usb-remote for dib0700 driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index 527b1e6..164fa9c 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -491,14 +491,11 @@ struct dib0700_rc_response {
 static void dib0700_rc_urb_completion(struct urb *purb)
 {
 	struct dvb_usb_device *d = purb->context;
-	struct ir_scancode *keymap;
 	struct dib0700_state *st;
 	struct dib0700_rc_response poll_reply;
 	u8 *buf;
-	int found = 0;
-	u32 event;
-	int state;
-	int i;
+	u32 keycode;
+	u8 toggle;
 
 	deb_info("%s()\n", __func__);
 	if (d == NULL)
@@ -510,7 +507,6 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 		return;
 	}
 
-	keymap = d->props.rc.legacy.rc_key_map;
 	st = d->priv;
 	buf = (u8 *)purb->transfer_buffer;
 
@@ -525,21 +521,17 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 		goto resubmit;
 	}
 
-	/* Set initial results in case we exit the function early */
-	event = 0;
-	state = REMOTE_NO_KEY_PRESSED;
-
 	deb_data("IR raw %02X %02X %02X %02X %02X %02X (len %d)\n", buf[0],
 		 buf[1], buf[2], buf[3], buf[4], buf[5], purb->actual_length);
 
 	switch (dvb_usb_dib0700_ir_proto) {
 	case 0:
 		/* NEC Protocol */
-		poll_reply.report_id  = 0;
-		poll_reply.data_state = 1;
+		poll_reply.data_state = 0;
 		poll_reply.system     = buf[2];
 		poll_reply.data       = buf[4];
 		poll_reply.not_data   = buf[5];
+		toggle = 0;
 
 		/* NEC protocol sends repeat code as 0 0 0 FF */
 		if ((poll_reply.system == 0x00) && (poll_reply.data == 0x00)
@@ -547,6 +539,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 			poll_reply.data_state = 2;
 			break;
 		}
+
 		break;
 	default:
 		/* RC5 Protocol */
@@ -555,6 +548,9 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 		poll_reply.system     = (buf[2] << 8) | buf[3];
 		poll_reply.data       = buf[4];
 		poll_reply.not_data   = buf[5];
+
+		toggle = poll_reply.report_id;
+
 		break;
 	}
 
@@ -570,59 +566,8 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 		 poll_reply.report_id, poll_reply.data_state,
 		 poll_reply.system, poll_reply.data, poll_reply.not_data);
 
-	/* Find the key in the map */
-	for (i = 0; i < d->props.rc.legacy.rc_key_map_size; i++) {
-		if (rc5_custom(&keymap[i]) == (poll_reply.system & 0xff) &&
-		    rc5_data(&keymap[i]) == poll_reply.data) {
-			event = keymap[i].keycode;
-			found = 1;
-			break;
-		}
-	}
-
-	if (found == 0) {
-		err("Unknown remote controller key: %04x %02x %02x",
-		    poll_reply.system, poll_reply.data, poll_reply.not_data);
-		d->last_event = 0;
-		goto resubmit;
-	}
-
-	if (poll_reply.data_state == 1) {
-		/* New key hit */
-		st->rc_counter = 0;
-		event = keymap[i].keycode;
-		state = REMOTE_KEY_PRESSED;
-		d->last_event = keymap[i].keycode;
-	} else if (poll_reply.data_state == 2) {
-		/* Key repeated */
-		st->rc_counter++;
-
-		/* prevents unwanted double hits */
-		if (st->rc_counter > RC_REPEAT_DELAY_V1_20) {
-			event = d->last_event;
-			state = REMOTE_KEY_PRESSED;
-			st->rc_counter = RC_REPEAT_DELAY_V1_20;
-		}
-	} else {
-		err("Unknown data state [%d]", poll_reply.data_state);
-	}
-
-	switch (state) {
-	case REMOTE_NO_KEY_PRESSED:
-		break;
-	case REMOTE_KEY_PRESSED:
-		deb_info("key pressed\n");
-		d->last_event = event;
-	case REMOTE_KEY_REPEAT:
-		deb_info("key repeated\n");
-		input_event(d->rc_input_dev, EV_KEY, event, 1);
-		input_sync(d->rc_input_dev);
-		input_event(d->rc_input_dev, EV_KEY, d->last_event, 0);
-		input_sync(d->rc_input_dev);
-		break;
-	default:
-		break;
-	}
+	keycode = poll_reply.system << 8 | poll_reply.data;
+	ir_keydown(d->rc_input_dev, keycode, toggle);
 
 resubmit:
 	/* Clean the buffer before we requeue */
@@ -640,9 +585,6 @@ int dib0700_rc_setup(struct dvb_usb_device *d)
 	int ret;
 	int i;
 
-	if (d->props.rc.legacy.rc_key_map == NULL)
-		return 0;
-
 	/* Set the IR mode */
 	i = dib0700_ctrl_wr(d, rc_setup, sizeof(rc_setup));
 	if (i < 0) {
@@ -700,6 +642,12 @@ static int dib0700_probe(struct usb_interface *intf,
 			st->fw_version = fw_version;
 			st->nb_packet_buffer_size = (u32)nb_packet_buffer_size;
 
+			/* Disable polling mode on newer firmwares */
+			if (st->fw_version >= 0x10200)
+				dev->props.rc.core.bulk_mode = true;
+			else
+				dev->props.rc.core.bulk_mode = false;
+
 			dib0700_rc_setup(dev);
 
 			return 0;
diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index 2ae74ba..6e587cd 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -473,15 +473,20 @@ static u8 rc_request[] = { REQUEST_POLL_RC, 0 };
 /* Number of keypresses to ignore before start repeating */
 #define RC_REPEAT_DELAY 6
 
-static int dib0700_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
+/*
+ * This function is used only when firmware is < 1.20 version. Newer
+ * firmwares use bulk mode, with functions implemented at dib0700_core,
+ * at dib0700_rc_urb_completion()
+ */
+static int dib0700_rc_query_old_firmware(struct dvb_usb_device *d)
 {
 	u8 key[4];
+	u32 keycode;
+	u8 toggle;
 	int i;
-	struct ir_scancode *keymap = d->props.rc.legacy.rc_key_map;
 	struct dib0700_state *st = d->priv;
 
-	*event = 0;
-	*state = REMOTE_NO_KEY_PRESSED;
+printk("%s\n", __func__);
 
 	if (st->fw_version >= 0x10200) {
 		/* For 1.20 firmware , We need to keep the RC polling
@@ -491,348 +496,45 @@ static int dib0700_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 		return 0;
 	}
 
-	i=dib0700_ctrl_rd(d,rc_request,2,key,4);
-	if (i<=0) {
+	i = dib0700_ctrl_rd(d, rc_request, 2, key, 4);
+	if (i <= 0) {
 		err("RC Query Failed");
 		return -1;
 	}
 
 	/* losing half of KEY_0 events from Philipps rc5 remotes.. */
-	if (key[0]==0 && key[1]==0 && key[2]==0 && key[3]==0) return 0;
+	if (key[0] == 0 && key[1] == 0 && key[2] == 0 && key[3] == 0)
+		return 0;
 
 	/* info("%d: %2X %2X %2X %2X",dvb_usb_dib0700_ir_proto,(int)key[3-2],(int)key[3-3],(int)key[3-1],(int)key[3]);  */
 
 	dib0700_rc_setup(d); /* reset ir sensor data to prevent false events */
 
+	d->last_event = 0;
 	switch (dvb_usb_dib0700_ir_proto) {
-	case 0: {
+	case 0:
 		/* NEC protocol sends repeat code as 0 0 0 FF */
 		if ((key[3-2] == 0x00) && (key[3-3] == 0x00) &&
-		    (key[3] == 0xFF)) {
-			st->rc_counter++;
-			if (st->rc_counter > RC_REPEAT_DELAY) {
-				*event = d->last_event;
-				*state = REMOTE_KEY_PRESSED;
-				st->rc_counter = RC_REPEAT_DELAY;
-			}
-			return 0;
-		}
-		for (i=0;i<d->props.rc.legacy.rc_key_map_size; i++) {
-			if (rc5_custom(&keymap[i]) == key[3-2] &&
-			    rc5_data(&keymap[i]) == key[3-3]) {
-				st->rc_counter = 0;
-				*event = keymap[i].keycode;
-				*state = REMOTE_KEY_PRESSED;
-				d->last_event = keymap[i].keycode;
-				return 0;
-			}
+		    (key[3] == 0xff))
+			keycode = d->last_event;
+		else {
+			keycode = key[3-2] << 8 | key[3-3];
+			d->last_event = keycode;
 		}
+
+		ir_keydown(d->rc_input_dev, keycode, 0);
 		break;
-	}
-	default: {
+	default:
 		/* RC-5 protocol changes toggle bit on new keypress */
-		for (i = 0; i < d->props.rc.legacy.rc_key_map_size; i++) {
-			if (rc5_custom(&keymap[i]) == key[3-2] &&
-			    rc5_data(&keymap[i]) == key[3-3]) {
-				if (d->last_event == keymap[i].keycode &&
-					key[3-1] == st->rc_toggle) {
-					st->rc_counter++;
-					/* prevents unwanted double hits */
-					if (st->rc_counter > RC_REPEAT_DELAY) {
-						*event = d->last_event;
-						*state = REMOTE_KEY_PRESSED;
-						st->rc_counter = RC_REPEAT_DELAY;
-					}
+		keycode = key[3-2] << 8 | key[3-3];
+		toggle = key[3-1];
+		ir_keydown(d->rc_input_dev, keycode, toggle);
 
-					return 0;
-				}
-				st->rc_counter = 0;
-				*event = keymap[i].keycode;
-				*state = REMOTE_KEY_PRESSED;
-				st->rc_toggle = key[3-1];
-				d->last_event = keymap[i].keycode;
-				return 0;
-			}
-		}
 		break;
 	}
-	}
-	err("Unknown remote controller key: %2X %2X %2X %2X", (int) key[3-2], (int) key[3-3], (int) key[3-1], (int) key[3]);
-	d->last_event = 0;
 	return 0;
 }
 
-static struct ir_scancode ir_codes_dib0700_table[] = {
-	/* Key codes for the tiny Pinnacle remote*/
-	{ 0x0700, KEY_MUTE },
-	{ 0x0701, KEY_MENU }, /* Pinnacle logo */
-	{ 0x0739, KEY_POWER },
-	{ 0x0703, KEY_VOLUMEUP },
-	{ 0x0709, KEY_VOLUMEDOWN },
-	{ 0x0706, KEY_CHANNELUP },
-	{ 0x070c, KEY_CHANNELDOWN },
-	{ 0x070f, KEY_1 },
-	{ 0x0715, KEY_2 },
-	{ 0x0710, KEY_3 },
-	{ 0x0718, KEY_4 },
-	{ 0x071b, KEY_5 },
-	{ 0x071e, KEY_6 },
-	{ 0x0711, KEY_7 },
-	{ 0x0721, KEY_8 },
-	{ 0x0712, KEY_9 },
-	{ 0x0727, KEY_0 },
-	{ 0x0724, KEY_SCREEN }, /* 'Square' key */
-	{ 0x072a, KEY_TEXT },   /* 'T' key */
-	{ 0x072d, KEY_REWIND },
-	{ 0x0730, KEY_PLAY },
-	{ 0x0733, KEY_FASTFORWARD },
-	{ 0x0736, KEY_RECORD },
-	{ 0x073c, KEY_STOP },
-	{ 0x073f, KEY_CANCEL }, /* '?' key */
-	/* Key codes for the Terratec Cinergy DT XS Diversity, similar to cinergyT2.c */
-	{ 0xeb01, KEY_POWER },
-	{ 0xeb02, KEY_1 },
-	{ 0xeb03, KEY_2 },
-	{ 0xeb04, KEY_3 },
-	{ 0xeb05, KEY_4 },
-	{ 0xeb06, KEY_5 },
-	{ 0xeb07, KEY_6 },
-	{ 0xeb08, KEY_7 },
-	{ 0xeb09, KEY_8 },
-	{ 0xeb0a, KEY_9 },
-	{ 0xeb0b, KEY_VIDEO },
-	{ 0xeb0c, KEY_0 },
-	{ 0xeb0d, KEY_REFRESH },
-	{ 0xeb0f, KEY_EPG },
-	{ 0xeb10, KEY_UP },
-	{ 0xeb11, KEY_LEFT },
-	{ 0xeb12, KEY_OK },
-	{ 0xeb13, KEY_RIGHT },
-	{ 0xeb14, KEY_DOWN },
-	{ 0xeb16, KEY_INFO },
-	{ 0xeb17, KEY_RED },
-	{ 0xeb18, KEY_GREEN },
-	{ 0xeb19, KEY_YELLOW },
-	{ 0xeb1a, KEY_BLUE },
-	{ 0xeb1b, KEY_CHANNELUP },
-	{ 0xeb1c, KEY_VOLUMEUP },
-	{ 0xeb1d, KEY_MUTE },
-	{ 0xeb1e, KEY_VOLUMEDOWN },
-	{ 0xeb1f, KEY_CHANNELDOWN },
-	{ 0xeb40, KEY_PAUSE },
-	{ 0xeb41, KEY_HOME },
-	{ 0xeb42, KEY_MENU }, /* DVD Menu */
-	{ 0xeb43, KEY_SUBTITLE },
-	{ 0xeb44, KEY_TEXT }, /* Teletext */
-	{ 0xeb45, KEY_DELETE },
-	{ 0xeb46, KEY_TV },
-	{ 0xeb47, KEY_DVD },
-	{ 0xeb48, KEY_STOP },
-	{ 0xeb49, KEY_VIDEO },
-	{ 0xeb4a, KEY_AUDIO }, /* Music */
-	{ 0xeb4b, KEY_SCREEN }, /* Pic */
-	{ 0xeb4c, KEY_PLAY },
-	{ 0xeb4d, KEY_BACK },
-	{ 0xeb4e, KEY_REWIND },
-	{ 0xeb4f, KEY_FASTFORWARD },
-	{ 0xeb54, KEY_PREVIOUS },
-	{ 0xeb58, KEY_RECORD },
-	{ 0xeb5c, KEY_NEXT },
-
-	/* Key codes for the Haupauge WinTV Nova-TD, copied from nova-t-usb2.c (Nova-T USB2) */
-	{ 0x1e00, KEY_0 },
-	{ 0x1e01, KEY_1 },
-	{ 0x1e02, KEY_2 },
-	{ 0x1e03, KEY_3 },
-	{ 0x1e04, KEY_4 },
-	{ 0x1e05, KEY_5 },
-	{ 0x1e06, KEY_6 },
-	{ 0x1e07, KEY_7 },
-	{ 0x1e08, KEY_8 },
-	{ 0x1e09, KEY_9 },
-	{ 0x1e0a, KEY_KPASTERISK },
-	{ 0x1e0b, KEY_RED },
-	{ 0x1e0c, KEY_RADIO },
-	{ 0x1e0d, KEY_MENU },
-	{ 0x1e0e, KEY_GRAVE }, /* # */
-	{ 0x1e0f, KEY_MUTE },
-	{ 0x1e10, KEY_VOLUMEUP },
-	{ 0x1e11, KEY_VOLUMEDOWN },
-	{ 0x1e12, KEY_CHANNEL },
-	{ 0x1e14, KEY_UP },
-	{ 0x1e15, KEY_DOWN },
-	{ 0x1e16, KEY_LEFT },
-	{ 0x1e17, KEY_RIGHT },
-	{ 0x1e18, KEY_VIDEO },
-	{ 0x1e19, KEY_AUDIO },
-	{ 0x1e1a, KEY_MEDIA },
-	{ 0x1e1b, KEY_EPG },
-	{ 0x1e1c, KEY_TV },
-	{ 0x1e1e, KEY_NEXT },
-	{ 0x1e1f, KEY_BACK },
-	{ 0x1e20, KEY_CHANNELUP },
-	{ 0x1e21, KEY_CHANNELDOWN },
-	{ 0x1e24, KEY_LAST }, /* Skip backwards */
-	{ 0x1e25, KEY_OK },
-	{ 0x1e29, KEY_BLUE},
-	{ 0x1e2e, KEY_GREEN },
-	{ 0x1e30, KEY_PAUSE },
-	{ 0x1e32, KEY_REWIND },
-	{ 0x1e34, KEY_FASTFORWARD },
-	{ 0x1e35, KEY_PLAY },
-	{ 0x1e36, KEY_STOP },
-	{ 0x1e37, KEY_RECORD },
-	{ 0x1e38, KEY_YELLOW },
-	{ 0x1e3b, KEY_GOTO },
-	{ 0x1e3d, KEY_POWER },
-
-	/* Key codes for the Leadtek Winfast DTV Dongle */
-	{ 0x0042, KEY_POWER },
-	{ 0x077c, KEY_TUNER },
-	{ 0x0f4e, KEY_PRINT }, /* PREVIEW */
-	{ 0x0840, KEY_SCREEN }, /* full screen toggle*/
-	{ 0x0f71, KEY_DOT }, /* frequency */
-	{ 0x0743, KEY_0 },
-	{ 0x0c41, KEY_1 },
-	{ 0x0443, KEY_2 },
-	{ 0x0b7f, KEY_3 },
-	{ 0x0e41, KEY_4 },
-	{ 0x0643, KEY_5 },
-	{ 0x097f, KEY_6 },
-	{ 0x0d7e, KEY_7 },
-	{ 0x057c, KEY_8 },
-	{ 0x0a40, KEY_9 },
-	{ 0x0e4e, KEY_CLEAR },
-	{ 0x047c, KEY_CHANNEL }, /* show channel number */
-	{ 0x0f41, KEY_LAST }, /* recall */
-	{ 0x0342, KEY_MUTE },
-	{ 0x064c, KEY_RESERVED }, /* PIP button*/
-	{ 0x0172, KEY_SHUFFLE }, /* SNAPSHOT */
-	{ 0x0c4e, KEY_PLAYPAUSE }, /* TIMESHIFT */
-	{ 0x0b70, KEY_RECORD },
-	{ 0x037d, KEY_VOLUMEUP },
-	{ 0x017d, KEY_VOLUMEDOWN },
-	{ 0x0242, KEY_CHANNELUP },
-	{ 0x007d, KEY_CHANNELDOWN },
-
-	/* Key codes for Nova-TD "credit card" remote control. */
-	{ 0x1d00, KEY_0 },
-	{ 0x1d01, KEY_1 },
-	{ 0x1d02, KEY_2 },
-	{ 0x1d03, KEY_3 },
-	{ 0x1d04, KEY_4 },
-	{ 0x1d05, KEY_5 },
-	{ 0x1d06, KEY_6 },
-	{ 0x1d07, KEY_7 },
-	{ 0x1d08, KEY_8 },
-	{ 0x1d09, KEY_9 },
-	{ 0x1d0a, KEY_TEXT },
-	{ 0x1d0d, KEY_MENU },
-	{ 0x1d0f, KEY_MUTE },
-	{ 0x1d10, KEY_VOLUMEUP },
-	{ 0x1d11, KEY_VOLUMEDOWN },
-	{ 0x1d12, KEY_CHANNEL },
-	{ 0x1d14, KEY_UP },
-	{ 0x1d15, KEY_DOWN },
-	{ 0x1d16, KEY_LEFT },
-	{ 0x1d17, KEY_RIGHT },
-	{ 0x1d1c, KEY_TV },
-	{ 0x1d1e, KEY_NEXT },
-	{ 0x1d1f, KEY_BACK },
-	{ 0x1d20, KEY_CHANNELUP },
-	{ 0x1d21, KEY_CHANNELDOWN },
-	{ 0x1d24, KEY_LAST },
-	{ 0x1d25, KEY_OK },
-	{ 0x1d30, KEY_PAUSE },
-	{ 0x1d32, KEY_REWIND },
-	{ 0x1d34, KEY_FASTFORWARD },
-	{ 0x1d35, KEY_PLAY },
-	{ 0x1d36, KEY_STOP },
-	{ 0x1d37, KEY_RECORD },
-	{ 0x1d3b, KEY_GOTO },
-	{ 0x1d3d, KEY_POWER },
-
-	/* Key codes for the Pixelview SBTVD remote (proto NEC) */
-	{ 0x8613, KEY_MUTE },
-	{ 0x8612, KEY_POWER },
-	{ 0x8601, KEY_1 },
-	{ 0x8602, KEY_2 },
-	{ 0x8603, KEY_3 },
-	{ 0x8604, KEY_4 },
-	{ 0x8605, KEY_5 },
-	{ 0x8606, KEY_6 },
-	{ 0x8607, KEY_7 },
-	{ 0x8608, KEY_8 },
-	{ 0x8609, KEY_9 },
-	{ 0x8600, KEY_0 },
-	{ 0x860d, KEY_CHANNELUP },
-	{ 0x8619, KEY_CHANNELDOWN },
-	{ 0x8610, KEY_VOLUMEUP },
-	{ 0x860c, KEY_VOLUMEDOWN },
-
-	{ 0x860a, KEY_CAMERA },
-	{ 0x860b, KEY_ZOOM },
-	{ 0x861b, KEY_BACKSPACE },
-	{ 0x8615, KEY_ENTER },
-
-	{ 0x861d, KEY_UP },
-	{ 0x861e, KEY_DOWN },
-	{ 0x860e, KEY_LEFT },
-	{ 0x860f, KEY_RIGHT },
-
-	{ 0x8618, KEY_RECORD },
-	{ 0x861a, KEY_STOP },
-
-	/* Key codes for the EvolutePC TVWay+ remote (proto NEC) */
-	{ 0x7a00, KEY_MENU },
-	{ 0x7a01, KEY_RECORD },
-	{ 0x7a02, KEY_PLAY },
-	{ 0x7a03, KEY_STOP },
-	{ 0x7a10, KEY_CHANNELUP },
-	{ 0x7a11, KEY_CHANNELDOWN },
-	{ 0x7a12, KEY_VOLUMEUP },
-	{ 0x7a13, KEY_VOLUMEDOWN },
-	{ 0x7a40, KEY_POWER },
-	{ 0x7a41, KEY_MUTE },
-
-	/* Key codes for the Elgato EyeTV Diversity silver remote,
-	   set dvb_usb_dib0700_ir_proto=0 */
-	{ 0x4501, KEY_POWER },
-	{ 0x4502, KEY_MUTE },
-	{ 0x4503, KEY_1 },
-	{ 0x4504, KEY_2 },
-	{ 0x4505, KEY_3 },
-	{ 0x4506, KEY_4 },
-	{ 0x4507, KEY_5 },
-	{ 0x4508, KEY_6 },
-	{ 0x4509, KEY_7 },
-	{ 0x450a, KEY_8 },
-	{ 0x450b, KEY_9 },
-	{ 0x450c, KEY_LAST },
-	{ 0x450d, KEY_0 },
-	{ 0x450e, KEY_ENTER },
-	{ 0x450f, KEY_RED },
-	{ 0x4510, KEY_CHANNELUP },
-	{ 0x4511, KEY_GREEN },
-	{ 0x4512, KEY_VOLUMEDOWN },
-	{ 0x4513, KEY_OK },
-	{ 0x4514, KEY_VOLUMEUP },
-	{ 0x4515, KEY_YELLOW },
-	{ 0x4516, KEY_CHANNELDOWN },
-	{ 0x4517, KEY_BLUE },
-	{ 0x4518, KEY_LEFT }, /* Skip backwards */
-	{ 0x4519, KEY_PLAYPAUSE },
-	{ 0x451a, KEY_RIGHT }, /* Skip forward */
-	{ 0x451b, KEY_REWIND },
-	{ 0x451c, KEY_L }, /* Live */
-	{ 0x451d, KEY_FASTFORWARD },
-	{ 0x451e, KEY_STOP }, /* 'Reveal' for Teletext */
-	{ 0x451f, KEY_MENU }, /* KEY_TEXT for Teletext */
-	{ 0x4540, KEY_RECORD }, /* Font 'Size' for Teletext */
-	{ 0x4541, KEY_SCREEN }, /*  Full screen toggle, 'Hold' for Teletext */
-	{ 0x4542, KEY_SELECT }, /* Select video input, 'Select' for Teletext */
-};
-
 /* STK7700P: Hauppauge Nova-T Stick, AVerMedia Volar */
 static struct dibx000_agc_config stk7700p_7000m_mt2060_agc_config = {
 	BAND_UHF | BAND_VHF,
@@ -2168,11 +1870,10 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			}
 		},
 
-		.rc.legacy = {
+		.rc.core = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
-			.rc_key_map       = ir_codes_dib0700_table,
-			.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
-			.rc_query         = dib0700_rc_query
+			.rc_codes         = RC_MAP_DIB0700_BIG_TABLE,
+			.rc_query         = dib0700_rc_query_old_firmware
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -2199,11 +1900,10 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			},
 		},
 
-		.rc.legacy = {
+		.rc.core = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
-			.rc_key_map       = ir_codes_dib0700_table,
-			.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
-			.rc_query         = dib0700_rc_query
+			.rc_codes         = RC_MAP_DIB0700_BIG_TABLE,
+			.rc_query         = dib0700_rc_query_old_firmware
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -2255,11 +1955,10 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 		},
 
-		.rc.legacy = {
+		.rc.core = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
-			.rc_key_map       = ir_codes_dib0700_table,
-			.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
-			.rc_query         = dib0700_rc_query
+			.rc_codes         = RC_MAP_DIB0700_BIG_TABLE,
+			.rc_query         = dib0700_rc_query_old_firmware
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -2293,11 +1992,11 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			}
 		},
 
-		.rc.legacy = {
+		.rc.core = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
-			.rc_key_map       = ir_codes_dib0700_table,
-			.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
-			.rc_query         = dib0700_rc_query
+			.rc_codes         = RC_MAP_DIB0700_BIG_TABLE,
+			.module_name	  = "dib0700",
+			.rc_query         = dib0700_rc_query_old_firmware
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -2365,11 +2064,11 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			},
 		},
 
-		.rc.legacy = {
+		.rc.core = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
-			.rc_key_map       = ir_codes_dib0700_table,
-			.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
-			.rc_query         = dib0700_rc_query
+			.rc_codes         = RC_MAP_DIB0700_BIG_TABLE,
+			.module_name	  = "dib0700",
+			.rc_query         = dib0700_rc_query_old_firmware
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -2405,11 +2104,11 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			},
 		},
 
-		.rc.legacy = {
+		.rc.core = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
-			.rc_key_map       = ir_codes_dib0700_table,
-			.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
-			.rc_query         = dib0700_rc_query
+			.rc_codes         = RC_MAP_DIB0700_BIG_TABLE,
+			.module_name	  = "dib0700",
+			.rc_query         = dib0700_rc_query_old_firmware
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -2473,11 +2172,11 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			},
 		},
 
-		.rc.legacy = {
+		.rc.core = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
-			.rc_key_map       = ir_codes_dib0700_table,
-			.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
-			.rc_query         = dib0700_rc_query
+			.rc_codes         = RC_MAP_DIB0700_BIG_TABLE,
+			.module_name	  = "dib0700",
+			.rc_query         = dib0700_rc_query_old_firmware
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
@@ -2538,11 +2237,11 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			},
 		},
 
-		.rc.legacy = {
+		.rc.core = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
-			.rc_key_map       = ir_codes_dib0700_table,
-			.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
-			.rc_query         = dib0700_rc_query
+			.rc_codes         = RC_MAP_DIB0700_BIG_TABLE,
+			.module_name	  = "dib0700",
+			.rc_query         = dib0700_rc_query_old_firmware
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 		.num_adapters = 1,
@@ -2569,11 +2268,12 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 				{ NULL },
 			},
 		},
-		.rc.legacy = {
+
+		.rc.core = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
-			.rc_key_map       = ir_codes_dib0700_table,
-			.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
-			.rc_query         = dib0700_rc_query
+			.rc_codes         = RC_MAP_DIB0700_BIG_TABLE,
+			.module_name	  = "dib0700",
+			.rc_query         = dib0700_rc_query_old_firmware
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 		.num_adapters = 1,
@@ -2632,11 +2332,12 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 				{ NULL },
 			},
 		},
-		.rc.legacy = {
+
+		.rc.core = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
-			.rc_key_map       = ir_codes_dib0700_table,
-			.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
-			.rc_query         = dib0700_rc_query
+			.rc_codes         = RC_MAP_DIB0700_BIG_TABLE,
+			.module_name	  = "dib0700",
+			.rc_query         = dib0700_rc_query_old_firmware
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 		.num_adapters = 1,
@@ -2672,11 +2373,11 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			},
 		},
 
-		.rc.legacy = {
+		.rc.core = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
-			.rc_key_map       = ir_codes_dib0700_table,
-			.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
-			.rc_query         = dib0700_rc_query
+			.rc_codes         = RC_MAP_DIB0700_BIG_TABLE,
+			.module_name	  = "dib0700",
+			.rc_query         = dib0700_rc_query_old_firmware
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 		.num_adapters = 2,
@@ -2717,11 +2418,11 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			},
 		},
 
-		.rc.legacy = {
+		.rc.core = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
-			.rc_key_map       = ir_codes_dib0700_table,
-			.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
-			.rc_query         = dib0700_rc_query
+			.rc_codes         = RC_MAP_DIB0700_BIG_TABLE,
+			.module_name	  = "dib0700",
+			.rc_query         = dib0700_rc_query_old_firmware
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 		.num_adapters = 1,
@@ -2750,11 +2451,11 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			},
 		},
 
-		.rc.legacy = {
+		.rc.core = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
-			.rc_key_map       = ir_codes_dib0700_table,
-			.rc_key_map_size  = ARRAY_SIZE(ir_codes_dib0700_table),
-			.rc_query         = dib0700_rc_query
+			.rc_codes         = RC_MAP_DIB0700_BIG_TABLE,
+			.module_name	  = "dib0700",
+			.rc_query         = dib0700_rc_query_old_firmware
 		},
 	},
 };
-- 
1.7.1


