Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:40368 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab2HYVrR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Aug 2012 17:47:17 -0400
Subject: [PATCH 5/8] rc-core: use the full 32 bits for NEC scancodes
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jwilson@redhat.com, mchehab@redhat.com, sean@mess.org
Date: Sat, 25 Aug 2012 23:47:14 +0200
Message-ID: <20120825214713.22603.89806.stgit@localhost.localdomain>
In-Reply-To: <20120825214520.22603.37194.stgit@localhost.localdomain>
References: <20120825214520.22603.37194.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using the full 32 bits for all kinds of NEC scancodes simplifies rc-core
and the nec decoder without any loss of functionality.

In order to maintain backwards compatibility, some heuristics are added
in rc-main.c to convert scancodes to NEC32 as necessary. No conversion
is made for the newer "rc_keymap_entry" based ioctls.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-nec-decoder.c       |   28 +++---------------------
 drivers/media/rc/rc-main.c              |   36 ++++++++++++++++++++++++++++++-
 drivers/media/usb/dvb-usb-v2/af9015.c   |   22 +++++--------------
 drivers/media/usb/dvb-usb-v2/az6007.c   |   16 +++-----------
 drivers/media/usb/dvb-usb-v2/it913x.c   |   15 +++++--------
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c |   21 +++---------------
 include/media/rc-map.h                  |   11 ++++++++-
 7 files changed, 68 insertions(+), 81 deletions(-)

diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 61fa889..0b98f8f 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -50,7 +50,6 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	struct nec_dec *data = &dev->raw->nec;
 	u32 scancode;
 	u8 address, not_address, command, not_command;
-	bool send_32bits = false;
 
 	if (!(dev->enabled_protocols & RC_BIT_NEC))
 		return 0;
@@ -163,33 +162,14 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		command	    = bitrev8((data->bits >>  8) & 0xff);
 		not_command = bitrev8((data->bits >>  0) & 0xff);
 
-		if ((command ^ not_command) != 0xff) {
-			IR_dprintk(1, "NEC checksum error: received 0x%08x\n",
-				   data->bits);
-			send_32bits = true;
-		}
-
-		if (send_32bits) {
-			/* NEC transport, but modified protocol, used by at
-			 * least Apple and TiVo remotes */
-			scancode = data->bits;
-			IR_dprintk(1, "NEC (modified) scancode 0x%08x\n", scancode);
-		} else if ((address ^ not_address) != 0xff) {
-			/* Extended NEC */
-			scancode = address     << 16 |
-				   not_address <<  8 |
-				   command;
-			IR_dprintk(1, "NEC (Ext) scancode 0x%06x\n", scancode);
-		} else {
-			/* Normal NEC */
-			scancode = address << 8 | command;
-			IR_dprintk(1, "NEC scancode 0x%04x\n", scancode);
-		}
+		scancode = address << 24 | not_address << 16 |
+			   command << 8  | not_command;
+		IR_dprintk(1, "NEC scancode 0x%08x\n", scancode);
 
 		if (data->is_nec_x)
 			data->necx_repeat = true;
 
-		rc_keydown(dev, RC_TYPE_NEC, scancode, 0);
+		rc_keydown(dev, RC_TYPE_NEC, RC_SCANCODE_NEC32(scancode), 0);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index b111500..d29818c 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -324,6 +324,30 @@ static unsigned int ir_establish_scancode(struct rc_dev *dev,
 }
 
 /**
+ * to_nec32() - helper function to try to convert misc NEC scancodes to NEC32
+ * @orig:	original scancode
+ * @return:	NEC32 scancode
+ *
+ * This helper routine is used to provide backwards compatibility.
+ */
+static u64 to_nec32(u64 orig)
+{
+	u8 b3 = (u8)(orig >> 16);
+	u8 b2 = (u8)(orig >>  8);
+	u8 b1 = (u8)(orig >>  0);
+
+	if (orig <= 0xffff)
+		/* Plain old NEC */
+		return b2 << 24 | ((u8)~b2) << 16 |  b1 << 8 | ((u8)~b1);
+	else if (orig <= 0xffffff)
+		/* NEC extended */
+		return b3 << 24 | b2 << 16 |  b1 << 8 | ((u8)~b1);
+	else
+		/* NEC32 */
+		return orig;
+}
+
+/**
  * ir_setkeycode() - set a keycode in the scancode->keycode table
  * @idev:	the struct input_dev device descriptor
  * @scancode:	the desired scancode
@@ -371,6 +395,9 @@ static int ir_setkeycode(struct input_dev *idev,
 		else
 			entry.protocol = RC_TYPE_OTHER;
 
+		if (entry.protocol == RC_TYPE_NEC)
+			entry.scancode = to_nec32(entry.scancode);
+
 		index = ir_establish_scancode(rdev, rc_map, &entry, true);
 		if (index >= rc_map->len) {
 			retval = -ENOMEM;
@@ -430,8 +457,12 @@ static int ir_setkeytable(struct rc_dev *dev,
 		   rc_map->size, rc_map->alloc);
 
 	for (i = 0; i < from->size; i++) {
+		if (from->rc_type == RC_TYPE_NEC)
+			entry.scancode = to_nec32(from->scan[i].scancode);
+		else
+			entry.scancode = from->scan[i].scancode;
+
 		entry.protocol = from->rc_type;
-		entry.scancode = from->scan[i].scancode;
 		index = ir_establish_scancode(dev, rc_map, &entry, false);
 		if (index >= rc_map->len) {
 			rc = -ENOMEM;
@@ -527,6 +558,9 @@ static int ir_getkeycode(struct input_dev *idev,
 		else
 			protocol = RC_TYPE_OTHER;
 
+		if (protocol == RC_TYPE_NEC)
+			scancode = to_nec32(scancode);
+
 		index = ir_lookup_by_scancode(rc_map, protocol, scancode);
 
 	} else if (ke->len == sizeof(struct rc_scancode)) {
diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index 6a32274..330ae5e 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -1192,7 +1192,8 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 	if ((state->rc_repeat != buf[6] || buf[0]) &&
 			!memcmp(&buf[12], state->rc_last, 4)) {
 		deb_rc("%s: key repeated\n", __func__);
-		rc_keydown(d->rc_dev, RC_TYPE_NEC, state->rc_keycode, 0);
+		rc_keydown(d->rc_dev, RC_TYPE_NEC,
+			   RC_SCANCODE_NEC32(state->rc_keycode), 0);
 		state->rc_repeat = buf[6];
 		return ret;
 	}
@@ -1208,21 +1209,10 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 
 		/* Remember this key */
 		memcpy(state->rc_last, &buf[12], 4);
-		if (buf[14] == (u8) ~buf[15]) {
-			if (buf[12] == (u8) ~buf[13]) {
-				/* NEC */
-				state->rc_keycode = buf[12] << 8 | buf[14];
-			} else {
-				/* NEC extended*/
-				state->rc_keycode = buf[12] << 16 |
-					buf[13] << 8 | buf[14];
-			}
-		} else {
-			/* 32 bit NEC */
-			state->rc_keycode = buf[12] << 24 | buf[13] << 16 |
-					buf[14] << 8 | buf[15];
-		}
-		rc_keydown(d->rc_dev, RC_TYPE_NEC, state->rc_keycode, 0);
+		state->rc_keycode = buf[12] << 24 | buf[13] << 16 |
+				    buf[14] << 8  | buf[15];
+		rc_keydown(d->rc_dev, RC_TYPE_NEC,
+			   RC_SCANCODE_NEC32(state->rc_keycode), 0);
 	} else {
 		deb_rc("%s: no key press\n", __func__);
 		/* Invalidate last keypress */
diff --git a/drivers/media/usb/dvb-usb-v2/az6007.c b/drivers/media/usb/dvb-usb-v2/az6007.c
index d3e6922..488fe68 100644
--- a/drivers/media/usb/dvb-usb-v2/az6007.c
+++ b/drivers/media/usb/dvb-usb-v2/az6007.c
@@ -200,18 +200,10 @@ static int az6007_rc_query(struct dvb_usb_device *d)
 	if (st->data[1] == 0x44)
 		return 0;
 
-	if ((st->data[3] ^ st->data[4]) == 0xff) {
-		if ((st->data[1] ^ st->data[2]) == 0xff)
-			code = RC_SCANCODE_NEC(st->data[1], st->data[3]);
-		else
-			code = RC_SCANCODE_NECX(st->data[1] << 8 | st->data[2],
-						st->data[3]);
-	} else {
-		code = RC_SCANCODE_NEC32(st->data[1] << 24 |
-					 st->data[2] << 16 |
-					 st->data[3] << 8  |
-					 st->data[4]);
-	}
+	code = RC_SCANCODE_NEC32(st->data[1] << 24 |
+				 st->data[2] << 16 |
+				 st->data[3] << 8  |
+				 st->data[4]);
 
 	rc_keydown(d->rc_dev, RC_TYPE_NEC, code, st->data[5]);
 
diff --git a/drivers/media/usb/dvb-usb-v2/it913x.c b/drivers/media/usb/dvb-usb-v2/it913x.c
index f23c5b7..951d151 100644
--- a/drivers/media/usb/dvb-usb-v2/it913x.c
+++ b/drivers/media/usb/dvb-usb-v2/it913x.c
@@ -313,7 +313,6 @@ static int it913x_rc_query(struct dvb_usb_device *d)
 {
 	u8 ibuf[4];
 	int ret;
-	u16 device, command;
 	u64 scancode;
 
 	if (!d->rc_dev)
@@ -325,14 +324,12 @@ static int it913x_rc_query(struct dvb_usb_device *d)
 	ret = it913x_io(d, READ_LONG, PRO_LINK, CMD_IR_GET,
 		0, 0, &ibuf[0], sizeof(ibuf));
 
-	if ((ibuf[2] + ibuf[3]) == 0xff) {
-		command = ibuf[2];
-		device = (ibuf[0] << 8) | ibuf[1];
-		scancode = RC_SCANCODE_NECX(device, command);
-		deb_info(1, "NEC Extended Key = 0x%08llx",
-			 (unsigned long long)scancode);
-		rc_keydown(d->rc_dev, RC_TYPE_NEC, scancode, 0);
-	}
+	scancode = RC_SCANCODE_NEC32(ibuf[0] << 24 |
+				     ibuf[1] << 16 |
+				     ibuf[2] <<  8 |
+				     ibuf[3] <<  0);
+	deb_info(1, "NEC32 Key = 0x%08llx", (unsigned long long)scancode);
+	rc_keydown(d->rc_dev, RC_TYPE_NEC, scancode, 0);
 
 	mutex_unlock(&d->i2c_mutex);
 
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 887d0f5..7f80f61 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1062,23 +1062,10 @@ static int rtl2831u_rc_query(struct dvb_usb_device *d)
 		goto err;
 
 	if (buf[4] & 0x01) {
-		if (buf[2] == (u8) ~buf[3]) {
-			if (buf[0] == (u8) ~buf[1]) {
-				/* NEC standard (16 bit) */
-				rc_code = RC_SCANCODE_NEC(buf[0], buf[2]);
-			} else {
-				/* NEC extended (24 bit) */
-				rc_code = RC_SCANCODE_NECX(buf[0] << 8 |
-							   buf[1],
-							   buf[2]);
-			}
-		} else {
-			/* NEC full (32 bit) */
-			rc_code = RC_SCANCODE_NEC32(buf[0] << 24 |
-						    buf[1] << 16 |
-						    buf[2] << 8  |
-						    buf[3]);
-		}
+		rc_code = RC_SCANCODE_NEC32(buf[0] << 24 |
+					    buf[1] << 16 |
+					    buf[2] << 8  |
+					    buf[3]);
 
 		rc_keydown(d->rc_dev, RC_TYPE_NEC, rc_code, 0);
 
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 88a1c4e..b497608 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -62,8 +62,15 @@ enum rc_type {
 
 #define RC_SCANCODE_UNKNOWN(x) (x)
 #define RC_SCANCODE_OTHER(x) (x)
-#define RC_SCANCODE_NEC(addr, cmd) (((addr) << 8) | (cmd))
-#define RC_SCANCODE_NECX(addr, cmd) (((addr) << 8) | (cmd))
+#define RC_SCANCODE_NEC(addr, cmd)  \
+	((( (addr) & 0xff) << 24) | \
+	 ((~(addr) & 0xff) << 16) | \
+	 (( (cmd)  & 0xff) << 8 ) | \
+	 ((~(cmd)  & 0xff) << 0 ))
+#define RC_SCANCODE_NECX(addr, cmd)   \
+	((( (addr) & 0xffff) << 16) | \
+	 (( (cmd)  & 0x00ff) << 8)  | \
+	 ((~(cmd)  & 0x00ff) << 0))
 #define RC_SCANCODE_NEC32(data) ((data) & 0xffffffff)
 #define RC_SCANCODE_RC5(sys, cmd) (((sys) << 8) | (cmd))
 #define RC_SCANCODE_RC5_SZ(sys, cmd) (((sys) << 8) | (cmd))

