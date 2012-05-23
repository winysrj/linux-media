Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44252 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab2EWJtv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:49:51 -0400
Subject: [PATCH 04/43] rc-core: use the full 32 bits for NEC scancodes
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:42:21 +0200
Message-ID: <20120523094221.14474.67372.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using the full 32 bits for all kinds of NEC scancodes simplifies rc-core
and the nec decoder without any loss of functionality.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/dvb/dvb-usb/af9015.c   |   22 ++++++----------------
 drivers/media/dvb/dvb-usb/af9035.c   |   20 +++-----------------
 drivers/media/dvb/dvb-usb/az6007.c   |   16 ++++------------
 drivers/media/dvb/dvb-usb/it913x.c   |   15 ++++++---------
 drivers/media/dvb/dvb-usb/rtl28xxu.c |   21 ++++-----------------
 drivers/media/rc/ir-nec-decoder.c    |   28 ++++------------------------
 include/media/rc-map.h               |   11 +++++++++--
 7 files changed, 36 insertions(+), 97 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index bd47e68..4733044 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -1046,7 +1046,8 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 	if ((priv->rc_repeat != buf[6] || buf[0]) &&
 					!memcmp(&buf[12], priv->rc_last, 4)) {
 		deb_rc("%s: key repeated\n", __func__);
-		rc_keydown(d->rc_dev, RC_TYPE_NEC, priv->rc_keycode, 0);
+		rc_keydown(d->rc_dev, RC_TYPE_NEC,
+			   RC_SCANCODE_NEC32(priv->rc_keycode), 0);
 		priv->rc_repeat = buf[6];
 		return ret;
 	}
@@ -1063,21 +1064,10 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 
 		/* Remember this key */
 		memcpy(priv->rc_last, &buf[12], 4);
-		if (buf[14] == (u8) ~buf[15]) {
-			if (buf[12] == (u8) ~buf[13]) {
-				/* NEC */
-				priv->rc_keycode = buf[12] << 8 | buf[14];
-			} else {
-				/* NEC extended*/
-				priv->rc_keycode = buf[12] << 16 |
-					buf[13] << 8 | buf[14];
-			}
-		} else {
-			/* 32 bit NEC */
-			priv->rc_keycode = buf[12] << 24 | buf[13] << 16 |
-					buf[14] << 8 | buf[15];
-		}
-		rc_keydown(d->rc_dev, RC_TYPE_NEC, priv->rc_keycode, 0);
+		priv->rc_keycode = buf[12] << 24 | buf[13] << 16 |
+				   buf[14] << 8  | buf[15];
+		rc_keydown(d->rc_dev, RC_TYPE_NEC,
+			   RC_SCANCODE_NEC32(priv->rc_keycode), 0);
 	} else {
 		deb_rc("%s: no key press\n", __func__);
 		/* Invalidate last keypress */
diff --git a/drivers/media/dvb/dvb-usb/af9035.c b/drivers/media/dvb/dvb-usb/af9035.c
index c000feb..42094e1 100644
--- a/drivers/media/dvb/dvb-usb/af9035.c
+++ b/drivers/media/dvb/dvb-usb/af9035.c
@@ -311,24 +311,10 @@ static int af9035_rc_query(struct dvb_usb_device *d)
 
 	ret = af9035_ctrl_msg(d->udev, &req);
 	if (ret < 0)
-		goto err;
-
-	if ((b[2] + b[3]) == 0xff) {
-		if ((b[0] + b[1]) == 0xff) {
-			/* NEC */
-			key = b[0] << 8 | b[2];
-		} else {
-			/* ext. NEC */
-			key = b[0] << 16 | b[1] << 8 | b[2];
-		}
-	} else {
-		key = b[0] << 24 | b[1] << 16 | b[2] << 8 | b[3];
-	}
-
-	rc_keydown(d->rc_dev, RC_TYPE_NEC, key, 0);
+		return 0;
 
-err:
-	/* ignore errors */
+	key = b[0] << 24 | b[1] << 16 | b[2] << 8 | b[3];
+	rc_keydown(d->rc_dev, RC_TYPE_NEC, RC_SCANCODE_NEC32(key), 0);
 	return 0;
 }
 
diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index 1e26863..1e5888f 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -204,18 +204,10 @@ static int az6007_rc_query(struct dvb_usb_device *d)
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
 
diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index 2c3c400..59d3f07 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -381,7 +381,6 @@ static int it913x_rc_query(struct dvb_usb_device *d)
 {
 	u8 ibuf[4];
 	int ret;
-	u16 device, command;
 	u64 scancode;
 
 	if (!d->rc_dev)
@@ -393,14 +392,12 @@ static int it913x_rc_query(struct dvb_usb_device *d)
 	ret = it913x_io(d->udev, READ_LONG, PRO_LINK, CMD_IR_GET,
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
 
diff --git a/drivers/media/dvb/dvb-usb/rtl28xxu.c b/drivers/media/dvb/dvb-usb/rtl28xxu.c
index b2749d8..9dbde0a 100644
--- a/drivers/media/dvb/dvb-usb/rtl28xxu.c
+++ b/drivers/media/dvb/dvb-usb/rtl28xxu.c
@@ -673,23 +673,10 @@ static int rtl2831u_rc_query(struct dvb_usb_device *d)
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
 
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 535e6e2..1033f30 100644
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
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 48af876..7de8215 100644
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

