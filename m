Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:49281 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756074AbcIUJyW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Sep 2016 05:54:22 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] [media] rc: split nec protocol into its three variants
Date: Wed, 21 Sep 2016 10:54:19 +0100
Message-Id: <1474451659-28947-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently we do not know what variant (bit length) of the nec protocol
is used, other than from guessing from the length of the scancode. Now
nec will be handled the same way as the sony protocol or the rc6 protocol;
one variant per bit length.

In the future we might want to expose the rc protocol type to userspace
and we don't want to be introducing this world of pain into userspace
too.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/pci/cx23885/cx23885-input.c |  2 +-
 drivers/media/pci/cx88/cx88-input.c       |  5 +++--
 drivers/media/pci/saa7134/saa7134-input.c |  4 ++--
 drivers/media/rc/igorplugusb.c            |  3 ++-
 drivers/media/rc/img-ir/img-ir-nec.c      |  6 ++++--
 drivers/media/rc/ir-nec-decoder.c         |  8 ++++++--
 drivers/media/rc/rc-main.c                |  4 +++-
 drivers/media/usb/au0828/au0828-input.c   |  3 ++-
 drivers/media/usb/dvb-usb-v2/af9015.c     |  8 ++++++--
 drivers/media/usb/dvb-usb-v2/af9035.c     |  9 +++++++--
 drivers/media/usb/dvb-usb-v2/az6007.c     | 13 +++++++++----
 drivers/media/usb/dvb-usb-v2/lmedm04.c    |  5 +++--
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c   |  9 +++++++--
 drivers/media/usb/dvb-usb/dib0700_core.c  |  4 +++-
 drivers/media/usb/dvb-usb/dtt200u.c       |  5 ++++-
 include/media/rc-map.h                    | 31 +++++++++++++++++++------------
 16 files changed, 81 insertions(+), 38 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
index 64328d0..410c314 100644
--- a/drivers/media/pci/cx23885/cx23885-input.c
+++ b/drivers/media/pci/cx23885/cx23885-input.c
@@ -293,7 +293,7 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
 		/* Integrated CX23885 IR controller */
 		driver_type = RC_DRIVER_IR_RAW;
-		allowed_protos = RC_BIT_NEC;
+		allowed_protos = RC_BIT_ALL;
 		/* The grey Terratec remote with orange buttons */
 		rc_map = RC_MAP_NEC_TERRATEC_CINERGY_XS;
 		break;
diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
index 3f1342c..6eac81b 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -144,7 +144,8 @@ static void cx88_ir_handle_key(struct cx88_IR *ir)
 		scancode = RC_SCANCODE_NECX(addr, cmd);
 
 		if (0 == (gpio & ir->mask_keyup))
-			rc_keydown_notimeout(ir->dev, RC_TYPE_NEC, scancode, 0);
+			rc_keydown_notimeout(ir->dev, RC_TYPE_NECX, scancode,
+									0);
 		else
 			rc_keyup(ir->dev);
 
@@ -345,7 +346,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		 * 002-T mini RC, provided with newer PV hardware
 		 */
 		ir_codes = RC_MAP_PIXELVIEW_MK12;
-		rc_type = RC_BIT_NEC;
+		rc_type = RC_BIT_NECX;
 		ir->gpio_addr = MO_GP1_IO;
 		ir->mask_keyup = 0x80;
 		ir->polling = 10; /* ms */
diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index c8042c3..eff52bb 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -345,7 +345,7 @@ static int get_key_beholdm6xx(struct IR_i2c *ir, enum rc_type *protocol,
 	if (data[9] != (unsigned char)(~data[8]))
 		return 0;
 
-	*protocol = RC_TYPE_NEC;
+	*protocol = RC_TYPE_NECX;
 	*scancode = RC_SCANCODE_NECX(data[11] << 8 | data[10], data[9]);
 	*toggle = 0;
 	return 1;
@@ -1035,7 +1035,7 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 		dev->init_data.name = "BeholdTV";
 		dev->init_data.get_key = get_key_beholdm6xx;
 		dev->init_data.ir_codes = RC_MAP_BEHOLD;
-		dev->init_data.type = RC_BIT_NEC;
+		dev->init_data.type = RC_BIT_NECX;
 		info.addr = 0x2d;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_501:
diff --git a/drivers/media/rc/igorplugusb.c b/drivers/media/rc/igorplugusb.c
index e0c531f..5cf983b 100644
--- a/drivers/media/rc/igorplugusb.c
+++ b/drivers/media/rc/igorplugusb.c
@@ -203,7 +203,8 @@ static int igorplugusb_probe(struct usb_interface *intf,
 	 * This device can only store 36 pulses + spaces, which is not enough
 	 * for the NEC protocol and many others.
 	 */
-	rc->allowed_protocols = RC_BIT_ALL & ~(RC_BIT_NEC | RC_BIT_RC6_6A_20 |
+	rc->allowed_protocols = RC_BIT_ALL & ~(RC_BIT_NEC | RC_BIT_NECX |
+			RC_BIT_NEC32 | RC_BIT_RC6_6A_20 |
 			RC_BIT_RC6_6A_24 | RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE |
 			RC_BIT_SONY20 | RC_BIT_MCE_KBD | RC_BIT_SANYO);
 
diff --git a/drivers/media/rc/img-ir/img-ir-nec.c b/drivers/media/rc/img-ir/img-ir-nec.c
index 27a7ea8..0931493 100644
--- a/drivers/media/rc/img-ir/img-ir-nec.c
+++ b/drivers/media/rc/img-ir/img-ir-nec.c
@@ -34,19 +34,21 @@ static int img_ir_nec_scancode(int len, u64 raw, u64 enabled_protocols,
 				bitrev8(addr_inv) << 16 |
 				bitrev8(data)     <<  8 |
 				bitrev8(data_inv);
+		request->protocol = RC_TYPE_NEC32;
 	} else if ((addr_inv ^ addr) != 0xff) {
 		/* Extended NEC */
 		/* scan encoding: AAaaDD */
 		request->scancode = addr     << 16 |
 				addr_inv <<  8 |
 				data;
+		request->protocol = RC_TYPE_NECX;
 	} else {
 		/* Normal NEC */
 		/* scan encoding: AADD */
 		request->scancode = addr << 8 |
 				data;
+		request->protocol = RC_TYPE_NEC;
 	}
-	request->protocol = RC_TYPE_NEC;
 	return IMG_IR_SCANCODE;
 }
 
@@ -109,7 +111,7 @@ static int img_ir_nec_filter(const struct rc_scancode_filter *in,
  *        http://wiki.altium.com/display/ADOH/NEC+Infrared+Transmission+Protocol
  */
 struct img_ir_decoder img_ir_nec = {
-	.type = RC_BIT_NEC,
+	.type = RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32,
 	.control = {
 		.decoden = 1,
 		.code_type = IMG_IR_CODETYPE_PULSEDIST,
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index bea0d1e..2a9d155 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -49,6 +49,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
 	struct nec_dec *data = &dev->raw->nec;
 	u32 scancode;
+	enum rc_type rc_type;
 	u8 address, not_address, command, not_command;
 	bool send_32bits = false;
 
@@ -171,22 +172,25 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			 * least Apple and TiVo remotes */
 			scancode = data->bits;
 			IR_dprintk(1, "NEC (modified) scancode 0x%08x\n", scancode);
+			rc_type = RC_TYPE_NEC32;
 		} else if ((address ^ not_address) != 0xff) {
 			/* Extended NEC */
 			scancode = address     << 16 |
 				   not_address <<  8 |
 				   command;
 			IR_dprintk(1, "NEC (Ext) scancode 0x%06x\n", scancode);
+			rc_type = RC_TYPE_NECX;
 		} else {
 			/* Normal NEC */
 			scancode = address << 8 | command;
 			IR_dprintk(1, "NEC scancode 0x%04x\n", scancode);
+			rc_type = RC_TYPE_NEC;
 		}
 
 		if (data->is_nec_x)
 			data->necx_repeat = true;
 
-		rc_keydown(dev, RC_TYPE_NEC, scancode, 0);
+		rc_keydown(dev, rc_type, scancode, 0);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
@@ -198,7 +202,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 }
 
 static struct ir_raw_handler nec_handler = {
-	.protocols	= RC_BIT_NEC,
+	.protocols	= RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32,
 	.decode		= ir_nec_decode,
 };
 
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 8e7f292..154020d 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -795,7 +795,9 @@ static const struct {
 	{ RC_BIT_UNKNOWN,	"unknown",	NULL			},
 	{ RC_BIT_RC5 |
 	  RC_BIT_RC5X,		"rc-5",		"ir-rc5-decoder"	},
-	{ RC_BIT_NEC,		"nec",		"ir-nec-decoder"	},
+	{ RC_BIT_NEC |
+	  RC_BIT_NECX |
+	  RC_BIT_NEC32,		"nec",		"ir-nec-decoder"	},
 	{ RC_BIT_RC6_0 |
 	  RC_BIT_RC6_6A_20 |
 	  RC_BIT_RC6_6A_24 |
diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/media/usb/au0828/au0828-input.c
index 3d6687f..1e66e78 100644
--- a/drivers/media/usb/au0828/au0828-input.c
+++ b/drivers/media/usb/au0828/au0828-input.c
@@ -344,7 +344,8 @@ int au0828_rc_register(struct au0828_dev *dev)
 	rc->dev.parent = &dev->usbdev->dev;
 	rc->driver_name = "au0828-input";
 	rc->driver_type = RC_DRIVER_IR_RAW;
-	rc->allowed_protocols = RC_BIT_NEC | RC_BIT_RC5;
+	rc->allowed_protocols = RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32 |
+								RC_BIT_RC5;
 
 	/* all done */
 	err = rc_register_device(rc);
diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index 09e0f58..941ceff 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -1222,6 +1222,7 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 
 	/* Only process key if canary killed */
 	if (buf[16] != 0xff && buf[0] != 0x01) {
+		enum rc_type proto;
 		dev_dbg(&d->udev->dev, "%s: key pressed %*ph\n",
 				__func__, 4, buf + 12);
 
@@ -1237,11 +1238,13 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 				/* NEC */
 				state->rc_keycode = RC_SCANCODE_NEC(buf[12],
 								    buf[14]);
+				proto = RC_TYPE_NEC;
 			} else {
 				/* NEC extended*/
 				state->rc_keycode = RC_SCANCODE_NECX(buf[12] << 8 |
 								     buf[13],
 								     buf[14]);
+				proto = RC_TYPE_NECX;
 			}
 		} else {
 			/* 32 bit NEC */
@@ -1249,8 +1252,9 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 							      buf[13] << 16 |
 							      buf[14] << 8  |
 							      buf[15]);
+			proto = RC_TYPE_NEC32;
 		}
-		rc_keydown(d->rc_dev, RC_TYPE_NEC, state->rc_keycode, 0);
+		rc_keydown(d->rc_dev, proto, state->rc_keycode, 0);
 	} else {
 		dev_dbg(&d->udev->dev, "%s: no key press\n", __func__);
 		/* Invalidate last keypress */
@@ -1317,7 +1321,7 @@ static int af9015_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 	if (!rc->map_name)
 		rc->map_name = RC_MAP_EMPTY;
 
-	rc->allowed_protos = RC_BIT_NEC;
+	rc->allowed_protos = RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32;
 	rc->query = af9015_rc_query;
 	rc->interval = 500;
 
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index ca018cd..8961dd7 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1828,6 +1828,7 @@ static int af9035_rc_query(struct dvb_usb_device *d)
 {
 	struct usb_interface *intf = d->intf;
 	int ret;
+	enum rc_type proto;
 	u32 key;
 	u8 buf[4];
 	struct usb_req req = { CMD_IR_GET, 0, 0, NULL, 4, buf };
@@ -1842,19 +1843,22 @@ static int af9035_rc_query(struct dvb_usb_device *d)
 		if ((buf[0] + buf[1]) == 0xff) {
 			/* NEC standard 16bit */
 			key = RC_SCANCODE_NEC(buf[0], buf[2]);
+			proto = RC_TYPE_NEC;
 		} else {
 			/* NEC extended 24bit */
 			key = RC_SCANCODE_NECX(buf[0] << 8 | buf[1], buf[2]);
+			proto = RC_TYPE_NECX;
 		}
 	} else {
 		/* NEC full code 32bit */
 		key = RC_SCANCODE_NEC32(buf[0] << 24 | buf[1] << 16 |
 					buf[2] << 8  | buf[3]);
+		proto = RC_TYPE_NEC32;
 	}
 
 	dev_dbg(&intf->dev, "%*ph\n", 4, buf);
 
-	rc_keydown(d->rc_dev, RC_TYPE_NEC, key, 0);
+	rc_keydown(d->rc_dev, proto, key, 0);
 
 	return 0;
 
@@ -1889,7 +1893,8 @@ static int af9035_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 		switch (tmp) {
 		case 0: /* NEC */
 		default:
-			rc->allowed_protos = RC_BIT_NEC;
+			rc->allowed_protos = RC_BIT_NEC | RC_BIT_NECX |
+								RC_BIT_NEC32;
 			break;
 		case 1: /* RC6 */
 			rc->allowed_protos = RC_BIT_RC6_MCE;
diff --git a/drivers/media/usb/dvb-usb-v2/az6007.c b/drivers/media/usb/dvb-usb-v2/az6007.c
index 935dbaa..50c07fe 100644
--- a/drivers/media/usb/dvb-usb-v2/az6007.c
+++ b/drivers/media/usb/dvb-usb-v2/az6007.c
@@ -208,6 +208,7 @@ static int az6007_rc_query(struct dvb_usb_device *d)
 {
 	struct az6007_device_state *st = d_to_priv(d);
 	unsigned code;
+	enum rc_type proto;
 
 	az6007_read(d, AZ6007_READ_IR, 0, 0, st->data, 10);
 
@@ -215,19 +216,23 @@ static int az6007_rc_query(struct dvb_usb_device *d)
 		return 0;
 
 	if ((st->data[3] ^ st->data[4]) == 0xff) {
-		if ((st->data[1] ^ st->data[2]) == 0xff)
+		if ((st->data[1] ^ st->data[2]) == 0xff) {
 			code = RC_SCANCODE_NEC(st->data[1], st->data[3]);
-		else
+			proto = RC_TYPE_NEC;
+		} else {
 			code = RC_SCANCODE_NECX(st->data[1] << 8 | st->data[2],
 						st->data[3]);
+			proto = RC_TYPE_NECX;
+		}
 	} else {
 		code = RC_SCANCODE_NEC32(st->data[1] << 24 |
 					 st->data[2] << 16 |
 					 st->data[3] << 8  |
 					 st->data[4]);
+		proto = RC_TYPE_NEC32;
 	}
 
-	rc_keydown(d->rc_dev, RC_TYPE_NEC, code, st->data[5]);
+	rc_keydown(d->rc_dev, proto, code, st->data[5]);
 
 	return 0;
 }
@@ -236,7 +241,7 @@ static int az6007_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 {
 	pr_debug("Getting az6007 Remote Control properties\n");
 
-	rc->allowed_protos = RC_BIT_NEC;
+	rc->allowed_protos = RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32;
 	rc->query          = az6007_rc_query;
 	rc->interval       = 400;
 
diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index 3721ee6..0e8fb89 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -357,7 +357,8 @@ static void lme2510_int_response(struct urb *lme_urb)
 						ibuf[5]);
 
 			deb_info(1, "INT Key = 0x%08x", key);
-			rc_keydown(adap_to_d(adap)->rc_dev, RC_TYPE_NEC, key, 0);
+			rc_keydown(adap_to_d(adap)->rc_dev, RC_TYPE_NEC32, key,
+									0);
 			break;
 		case 0xbb:
 			switch (st->tuner_config) {
@@ -1242,7 +1243,7 @@ static int lme2510_get_stream_config(struct dvb_frontend *fe, u8 *ts_type,
 static int lme2510_get_rc_config(struct dvb_usb_device *d,
 	struct dvb_usb_rc *rc)
 {
-	rc->allowed_protos = RC_BIT_NEC;
+	rc->allowed_protos = RC_BIT_NEC32;
 	return 0;
 }
 
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 6643762..c583c63 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1631,22 +1631,27 @@ static int rtl2831u_rc_query(struct dvb_usb_device *d)
 		goto err;
 
 	if (buf[4] & 0x01) {
+		enum rc_type proto;
+
 		if (buf[2] == (u8) ~buf[3]) {
 			if (buf[0] == (u8) ~buf[1]) {
 				/* NEC standard (16 bit) */
 				rc_code = RC_SCANCODE_NEC(buf[0], buf[2]);
+				proto = RC_TYPE_NEC;
 			} else {
 				/* NEC extended (24 bit) */
 				rc_code = RC_SCANCODE_NECX(buf[0] << 8 | buf[1],
 							   buf[2]);
+				proto = RC_TYPE_NECX;
 			}
 		} else {
 			/* NEC full (32 bit) */
 			rc_code = RC_SCANCODE_NEC32(buf[0] << 24 | buf[1] << 16 |
 						    buf[2] << 8  | buf[3]);
+			proto = RC_TYPE_NEC32;
 		}
 
-		rc_keydown(d->rc_dev, RC_TYPE_NEC, rc_code, 0);
+		rc_keydown(d->rc_dev, proto, rc_code, 0);
 
 		ret = rtl28xxu_wr_reg(d, SYS_IRRC_SR, 1);
 		if (ret)
@@ -1668,7 +1673,7 @@ static int rtl2831u_get_rc_config(struct dvb_usb_device *d,
 		struct dvb_usb_rc *rc)
 {
 	rc->map_name = RC_MAP_EMPTY;
-	rc->allowed_protos = RC_BIT_NEC;
+	rc->allowed_protos = RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32;
 	rc->query = rtl2831u_rc_query;
 	rc->interval = 400;
 
diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index 2679797..f319665 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -710,7 +710,6 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 
 	switch (d->props.rc.core.protocol) {
 	case RC_BIT_NEC:
-		protocol = RC_TYPE_NEC;
 		toggle = 0;
 
 		/* NEC protocol sends repeat code as 0 0 0 FF */
@@ -728,16 +727,19 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 						     poll_reply->nec.not_system << 16 |
 						     poll_reply->nec.data       << 8  |
 						     poll_reply->nec.not_data);
+			protocol = RC_TYPE_NEC32;
 		} else if ((poll_reply->nec.system ^ poll_reply->nec.not_system) != 0xff) {
 			deb_data("NEC extended protocol\n");
 			keycode = RC_SCANCODE_NECX(poll_reply->nec.system << 8 |
 						    poll_reply->nec.not_system,
 						    poll_reply->nec.data);
 
+			protocol = RC_TYPE_NECX;
 		} else {
 			deb_data("NEC normal protocol\n");
 			keycode = RC_SCANCODE_NEC(poll_reply->nec.system,
 						   poll_reply->nec.data);
+			protocol = RC_TYPE_NEC;
 		}
 
 		break;
diff --git a/drivers/media/usb/dvb-usb/dtt200u.c b/drivers/media/usb/dvb-usb/dtt200u.c
index be633ec..d2a01b5 100644
--- a/drivers/media/usb/dvb-usb/dtt200u.c
+++ b/drivers/media/usb/dvb-usb/dtt200u.c
@@ -62,18 +62,21 @@ static int dtt200u_rc_query(struct dvb_usb_device *d)
 
 	dvb_usb_generic_rw(d,&cmd,1,key,5,0);
 	if (key[0] == 1) {
+		enum rc_type proto = RC_TYPE_NEC;
+
 		scancode = key[1];
 		if ((u8) ~key[1] != key[2]) {
 			/* Extended NEC */
 			scancode = scancode << 8;
 			scancode |= key[2];
+			proto = RC_TYPE_NECX;
 		}
 		scancode = scancode << 8;
 		scancode |= key[3];
 
 		/* Check command checksum is ok */
 		if ((u8) ~key[3] == key[4])
-			rc_keydown(d->rc_dev, RC_TYPE_NEC, scancode, 0);
+			rc_keydown(d->rc_dev, proto, scancode, 0);
 		else
 			rc_keyup(d->rc_dev);
 	} else if (key[0] == 2) {
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 3c8edb3..e1cc14c 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -24,6 +24,8 @@
  * @RC_TYPE_SONY15: Sony 15 bit protocol
  * @RC_TYPE_SONY20: Sony 20 bit protocol
  * @RC_TYPE_NEC: NEC protocol
+ * @RC_TYPE_NECX: Extended NEC protocol
+ * @RC_TYPE_NEC32: NEC 32 bit protocol
  * @RC_TYPE_SANYO: Sanyo protocol
  * @RC_TYPE_MCE_KBD: RC6-ish MCE keyboard/mouse
  * @RC_TYPE_RC6_0: Philips RC6-0-16 protocol
@@ -46,16 +48,18 @@ enum rc_type {
 	RC_TYPE_SONY15		= 7,
 	RC_TYPE_SONY20		= 8,
 	RC_TYPE_NEC		= 9,
-	RC_TYPE_SANYO		= 10,
-	RC_TYPE_MCE_KBD		= 11,
-	RC_TYPE_RC6_0		= 12,
-	RC_TYPE_RC6_6A_20	= 13,
-	RC_TYPE_RC6_6A_24	= 14,
-	RC_TYPE_RC6_6A_32	= 15,
-	RC_TYPE_RC6_MCE		= 16,
-	RC_TYPE_SHARP		= 17,
-	RC_TYPE_XMP		= 18,
-	RC_TYPE_CEC		= 19,
+	RC_TYPE_NECX		= 10,
+	RC_TYPE_NEC32		= 11,
+	RC_TYPE_SANYO		= 12,
+	RC_TYPE_MCE_KBD		= 13,
+	RC_TYPE_RC6_0		= 14,
+	RC_TYPE_RC6_6A_20	= 15,
+	RC_TYPE_RC6_6A_24	= 16,
+	RC_TYPE_RC6_6A_32	= 17,
+	RC_TYPE_RC6_MCE		= 18,
+	RC_TYPE_SHARP		= 19,
+	RC_TYPE_XMP		= 20,
+	RC_TYPE_CEC		= 21,
 };
 
 #define RC_BIT_NONE		0ULL
@@ -69,6 +73,8 @@ enum rc_type {
 #define RC_BIT_SONY15		(1ULL << RC_TYPE_SONY15)
 #define RC_BIT_SONY20		(1ULL << RC_TYPE_SONY20)
 #define RC_BIT_NEC		(1ULL << RC_TYPE_NEC)
+#define RC_BIT_NECX		(1ULL << RC_TYPE_NECX)
+#define RC_BIT_NEC32		(1ULL << RC_TYPE_NEC32)
 #define RC_BIT_SANYO		(1ULL << RC_TYPE_SANYO)
 #define RC_BIT_MCE_KBD		(1ULL << RC_TYPE_MCE_KBD)
 #define RC_BIT_RC6_0		(1ULL << RC_TYPE_RC6_0)
@@ -84,8 +90,9 @@ enum rc_type {
 			 RC_BIT_RC5 | RC_BIT_RC5X | RC_BIT_RC5_SZ | \
 			 RC_BIT_JVC | \
 			 RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20 | \
-			 RC_BIT_NEC | RC_BIT_SANYO | RC_BIT_MCE_KBD | \
-			 RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
+			 RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32 | \
+			 RC_BIT_SANYO | RC_BIT_MCE_KBD | RC_BIT_RC6_0 | \
+			 RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
 			 RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE | RC_BIT_SHARP | \
 			 RC_BIT_XMP | RC_BIT_CEC)
 
-- 
2.7.4

