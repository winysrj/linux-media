Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:51895 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752767AbdDRP6Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Apr 2017 11:58:25 -0400
Subject: [PATCH] rc-core: use the full 32 bits for NEC scancodes
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Tue, 18 Apr 2017 17:50:27 +0200
Message-ID: <149253062750.8732.14617348605110322157.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using the full 32 bits for all kinds of NEC scancodes simplifies rc-core
and the nec decoder without any loss of functionality. At the same time
it ensures that scancodes for NEC16/NEC24/NEC32 do not overlap and
removes lots of duplication (as you can see from the patch, the same NEC
disambiguation logic is contained in several different drivers).

Using NEC32 also removes ambiguity. For example, consider these two NEC
messages:
NEC16 message to address 0x05, command 0x03
NEC24 message to address 0x0005, command 0x03

They'll both have scancode 0x00000503, and there's no way to tell which
message was received.

In order to maintain backwards compatibility, some heuristics are added
in rc-main.c to convert scancodes to NEC32 as necessary when userspace
adds entries to the keytable using the regular input ioctls. These
heuristics are essentially the same as the ones that are currently in
drivers/media/rc/img-ir/img-ir-nec.c (which are rendered unecessary
with this patch).

The reason this has to be done now is that the newer sysfs wakefilter API
will expose the difference between the NEC protocols to userspace for no
good reason and once exposed, it will be much more difficult to change the
logic.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/igorplugusb.c       |    4 +
 drivers/media/rc/img-ir/img-ir-nec.c |   92 +++++++---------------------------
 drivers/media/rc/ir-nec-decoder.c    |   63 ++++-------------------
 drivers/media/rc/rc-main.c           |   74 ++++++++++++++++++++-------
 drivers/media/rc/winbond-cir.c       |   32 +-----------
 5 files changed, 89 insertions(+), 176 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
index 01f2e472a2a0..61c46763ac97 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -146,7 +146,7 @@ static void cx88_ir_handle_key(struct cx88_IR *ir)
 		scancode = RC_SCANCODE_NECX(addr, cmd);
 
 		if (0 == (gpio & ir->mask_keyup))
-			rc_keydown_notimeout(ir->dev, RC_TYPE_NECX, scancode,
+			rc_keydown_notimeout(ir->dev, RC_TYPE_NEC, scancode,
 					     0);
 		else
 			rc_keyup(ir->dev);
@@ -348,7 +348,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		 * 002-T mini RC, provided with newer PV hardware
 		 */
 		ir_codes = RC_MAP_PIXELVIEW_MK12;
-		rc_type = RC_BIT_NECX;
+		rc_type = RC_BIT_NEC;
 		ir->gpio_addr = MO_GP1_IO;
 		ir->mask_keyup = 0x80;
 		ir->polling = 10; /* ms */
diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index 78849c19f68a..47d8e055ddd3 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -338,7 +338,7 @@ static int get_key_beholdm6xx(struct IR_i2c *ir, enum rc_type *protocol,
 	if (data[9] != (unsigned char)(~data[8]))
 		return 0;
 
-	*protocol = RC_TYPE_NECX;
+	*protocol = RC_TYPE_NEC;
 	*scancode = RC_SCANCODE_NECX(data[11] << 8 | data[10], data[9]);
 	*toggle = 0;
 	return 1;
@@ -1028,7 +1028,7 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 		dev->init_data.name = "BeholdTV";
 		dev->init_data.get_key = get_key_beholdm6xx;
 		dev->init_data.ir_codes = RC_MAP_BEHOLD;
-		dev->init_data.type = RC_BIT_NECX;
+		dev->init_data.type = RC_BIT_NEC;
 		info.addr = 0x2d;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_501:
diff --git a/drivers/media/rc/igorplugusb.c b/drivers/media/rc/igorplugusb.c
index cb6d4f1247da..9e3119c94368 100644
--- a/drivers/media/rc/igorplugusb.c
+++ b/drivers/media/rc/igorplugusb.c
@@ -203,8 +203,8 @@ static int igorplugusb_probe(struct usb_interface *intf,
 	 * for the NEC protocol and many others.
 	 */
 	rc->allowed_protocols = RC_BIT_ALL_IR_DECODER & ~(RC_BIT_NEC |
-			RC_BIT_NECX | RC_BIT_NEC32 | RC_BIT_RC6_6A_20 |
-			RC_BIT_RC6_6A_24 | RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE |
+			RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 |
+			RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE |
 			RC_BIT_SONY20 | RC_BIT_SANYO);
 
 	rc->priv = ir;
diff --git a/drivers/media/rc/img-ir/img-ir-nec.c b/drivers/media/rc/img-ir/img-ir-nec.c
index 044fd42b22a0..56159bb44f9c 100644
--- a/drivers/media/rc/img-ir/img-ir-nec.c
+++ b/drivers/media/rc/img-ir/img-ir-nec.c
@@ -28,28 +28,15 @@ static int img_ir_nec_scancode(int len, u64 raw, u64 enabled_protocols,
 	addr_inv = (raw >>  8) & 0xff;
 	data     = (raw >> 16) & 0xff;
 	data_inv = (raw >> 24) & 0xff;
-	if ((data_inv ^ data) != 0xff) {
-		/* 32-bit NEC (used by Apple and TiVo remotes) */
-		/* scan encoding: as transmitted, MSBit = first received bit */
-		request->scancode = bitrev8(addr)     << 24 |
-				bitrev8(addr_inv) << 16 |
-				bitrev8(data)     <<  8 |
-				bitrev8(data_inv);
-		request->protocol = RC_TYPE_NEC32;
-	} else if ((addr_inv ^ addr) != 0xff) {
-		/* Extended NEC */
-		/* scan encoding: AAaaDD */
-		request->scancode = addr     << 16 |
-				addr_inv <<  8 |
-				data;
-		request->protocol = RC_TYPE_NECX;
-	} else {
-		/* Normal NEC */
-		/* scan encoding: AADD */
-		request->scancode = addr << 8 |
-				data;
-		request->protocol = RC_TYPE_NEC;
-	}
+
+	/* 32-bit NEC */
+	/* scan encoding: as transmitted, MSBit = first received bit */
+	request->scancode = 
+			bitrev8(addr)     << 24 |
+			bitrev8(addr_inv) << 16 |
+			bitrev8(data)     <<  8 |
+			bitrev8(data_inv);
+	request->protocol = RC_TYPE_NEC;
 	return IMG_IR_SCANCODE;
 }
 
@@ -60,55 +47,16 @@ static int img_ir_nec_filter(const struct rc_scancode_filter *in,
 	unsigned int addr, addr_inv, data, data_inv;
 	unsigned int addr_m, addr_inv_m, data_m, data_inv_m;
 
-	data       = in->data & 0xff;
-	data_m     = in->mask & 0xff;
-
-	protocols &= RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32;
-
-	/*
-	 * If only one bit is set, we were requested to do an exact
-	 * protocol. This should be the case for wakeup filters; for
-	 * normal filters, guess the protocol from the scancode.
-	 */
-	if (!is_power_of_2(protocols)) {
-		if ((in->data | in->mask) & 0xff000000)
-			protocols = RC_BIT_NEC32;
-		else if ((in->data | in->mask) & 0x00ff0000)
-			protocols = RC_BIT_NECX;
-		else
-			protocols = RC_BIT_NEC;
-	}
-
-	if (protocols == RC_BIT_NEC32) {
-		/* 32-bit NEC (used by Apple and TiVo remotes) */
-		/* scan encoding: as transmitted, MSBit = first received bit */
-		addr       = bitrev8(in->data >> 24);
-		addr_m     = bitrev8(in->mask >> 24);
-		addr_inv   = bitrev8(in->data >> 16);
-		addr_inv_m = bitrev8(in->mask >> 16);
-		data       = bitrev8(in->data >>  8);
-		data_m     = bitrev8(in->mask >>  8);
-		data_inv   = bitrev8(in->data >>  0);
-		data_inv_m = bitrev8(in->mask >>  0);
-	} else if (protocols == RC_BIT_NECX) {
-		/* Extended NEC */
-		/* scan encoding AAaaDD */
-		addr       = (in->data >> 16) & 0xff;
-		addr_m     = (in->mask >> 16) & 0xff;
-		addr_inv   = (in->data >>  8) & 0xff;
-		addr_inv_m = (in->mask >>  8) & 0xff;
-		data_inv   = data ^ 0xff;
-		data_inv_m = data_m;
-	} else {
-		/* Normal NEC */
-		/* scan encoding: AADD */
-		addr       = (in->data >>  8) & 0xff;
-		addr_m     = (in->mask >>  8) & 0xff;
-		addr_inv   = addr ^ 0xff;
-		addr_inv_m = addr_m;
-		data_inv   = data ^ 0xff;
-		data_inv_m = data_m;
-	}
+	/* 32-bit NEC */
+	/* scan encoding: as transmitted, MSBit = first received bit */
+	addr       = bitrev8(in->data >> 24);
+	addr_m     = bitrev8(in->mask >> 24);
+	addr_inv   = bitrev8(in->data >> 16);
+	addr_inv_m = bitrev8(in->mask >> 16);
+	data       = bitrev8(in->data >>  8);
+	data_m     = bitrev8(in->mask >>  8);
+	data_inv   = bitrev8(in->data >>  0);
+	data_inv_m = bitrev8(in->mask >>  0);
 
 	/* raw encoding: ddDDaaAA */
 	out->data = data_inv << 24 |
@@ -128,7 +76,7 @@ static int img_ir_nec_filter(const struct rc_scancode_filter *in,
  *        http://wiki.altium.com/display/ADOH/NEC+Infrared+Transmission+Protocol
  */
 struct img_ir_decoder img_ir_nec = {
-	.type = RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32,
+	.type = RC_BIT_NEC,
 	.control = {
 		.decoden = 1,
 		.code_type = IMG_IR_CODETYPE_PULSEDIST,
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 3ce850314dca..1f137dfa3eb3 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -49,9 +49,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
 	struct nec_dec *data = &dev->raw->nec;
 	u32 scancode;
-	enum rc_type rc_type;
 	u8 address, not_address, command, not_command;
-	bool send_32bits = false;
 
 	if (!is_timing_event(ev)) {
 		if (ev.reset)
@@ -161,39 +159,14 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
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
-			scancode = not_address << 24 |
-				address     << 16 |
-				not_command <<  8 |
-				command;
-			IR_dprintk(1, "NEC (modified) scancode 0x%08x\n", scancode);
-			rc_type = RC_TYPE_NEC32;
-		} else if ((address ^ not_address) != 0xff) {
-			/* Extended NEC */
-			scancode = address     << 16 |
-				   not_address <<  8 |
-				   command;
-			IR_dprintk(1, "NEC (Ext) scancode 0x%06x\n", scancode);
-			rc_type = RC_TYPE_NECX;
-		} else {
-			/* Normal NEC */
-			scancode = address << 8 | command;
-			IR_dprintk(1, "NEC scancode 0x%04x\n", scancode);
-			rc_type = RC_TYPE_NEC;
-		}
+		scancode = RC_SCANCODE_NEC32(address << 24 | not_address << 16 |
+					     command << 8  | not_command);
+		IR_dprintk(1, "NEC scancode 0x%08x\n", scancode);
 
 		if (data->is_nec_x)
 			data->necx_repeat = true;
 
-		rc_keydown(dev, rc_type, scancode, 0);
+		rc_keydown(dev, RC_TYPE_NEC, scancode, 0);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
@@ -214,27 +187,11 @@ static u32 ir_nec_scancode_to_raw(enum rc_type protocol, u32 scancode)
 {
 	unsigned int addr, addr_inv, data, data_inv;
 
-	data = scancode & 0xff;
-
-	if (protocol == RC_TYPE_NEC32) {
-		/* 32-bit NEC (used by Apple and TiVo remotes) */
-		/* scan encoding: aaAAddDD */
-		addr_inv   = (scancode >> 24) & 0xff;
-		addr       = (scancode >> 16) & 0xff;
-		data_inv   = (scancode >>  8) & 0xff;
-	} else if (protocol == RC_TYPE_NECX) {
-		/* Extended NEC */
-		/* scan encoding AAaaDD */
-		addr       = (scancode >> 16) & 0xff;
-		addr_inv   = (scancode >>  8) & 0xff;
-		data_inv   = data ^ 0xff;
-	} else {
-		/* Normal NEC */
-		/* scan encoding: AADD */
-		addr       = (scancode >>  8) & 0xff;
-		addr_inv   = addr ^ 0xff;
-		data_inv   = data ^ 0xff;
-	}
+	/* 32-bit NEC, scan encoding: aaAAddDD */
+	addr_inv   = (scancode >> 24) & 0xff;
+	addr       = (scancode >> 16) & 0xff;
+	data_inv   = (scancode >>  8) & 0xff;
+	data       = (scancode >>  0) & 0xff;
 
 	/* raw encoding: ddDDaaAA */
 	return data_inv << 24 |
@@ -285,7 +242,7 @@ static int ir_nec_encode(enum rc_type protocol, u32 scancode,
 }
 
 static struct ir_raw_handler nec_handler = {
-	.protocols	= RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32,
+	.protocols	= RC_BIT_NEC,
 	.decode		= ir_nec_decode,
 	.encode		= ir_nec_encode,
 };
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 6ec73357fa47..196843c5a886 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -327,6 +327,49 @@ static unsigned int ir_establish_scancode(struct rc_dev *dev,
 }
 
 /**
+ * guess_protocol() - heuristics to guess the protocol for a scancode
+ * @rdev:	the struct rc_dev device descriptor
+ * @return:	the guessed RC_TYPE_* protocol
+ *
+ * Internal routine to guess the current IR protocol for legacy ioctls.
+ */
+static inline enum rc_type guess_protocol(struct rc_dev *rdev)
+{
+	struct rc_map *rc_map = &rdev->rc_map;
+
+	if (hweight64(rdev->enabled_protocols) == 1)
+		return rc_bitmap_to_type(rdev->enabled_protocols);
+	else if (hweight64(rdev->allowed_protocols) == 1)
+		return rc_bitmap_to_type(rdev->allowed_protocols);
+	else
+		return rc_map->rc_type;
+}
+
+/**
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
@@ -359,6 +402,9 @@ static int ir_setkeycode(struct input_dev *idev,
 		if (retval)
 			goto out;
 
+		if (guess_protocol(rdev) == RC_TYPE_NEC)
+			scancode = to_nec32(scancode);
+
 		index = ir_establish_scancode(rdev, rc_map, scancode, true);
 		if (index >= rc_map->len) {
 			retval = -ENOMEM;
@@ -399,7 +445,10 @@ static int ir_setkeytable(struct rc_dev *dev,
 
 	for (i = 0; i < from->size; i++) {
 		index = ir_establish_scancode(dev, rc_map,
-					      from->scan[i].scancode, false);
+					      from->rc_type == RC_TYPE_NEC ?
+					      to_nec32(from->scan[i].scancode) :
+					      from->scan[i].scancode,
+					      false);
 		if (index >= rc_map->len) {
 			rc = -ENOMEM;
 			break;
@@ -473,6 +522,8 @@ static int ir_getkeycode(struct input_dev *idev,
 		if (retval)
 			goto out;
 
+		if (guess_protocol(rdev) == RC_TYPE_NEC)
+			scancode = to_nec32(scancode);
 		index = ir_lookup_by_scancode(rc_map, scancode);
 	}
 
@@ -669,7 +720,6 @@ static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
 
 		led_trigger_event(led_feedback, LED_FULL);
 	}
-
 	input_sync(dev->input_dev);
 }
 
@@ -742,9 +792,7 @@ static int rc_validate_filter(struct rc_dev *dev,
 		[RC_TYPE_SONY15] = 0xff007f,
 		[RC_TYPE_SONY20] = 0x1fff7f,
 		[RC_TYPE_JVC] = 0xffff,
-		[RC_TYPE_NEC] = 0xffff,
-		[RC_TYPE_NECX] = 0xffffff,
-		[RC_TYPE_NEC32] = 0xffffffff,
+		[RC_TYPE_NEC] = 0xffffffff,
 		[RC_TYPE_SANYO] = 0x1fffff,
 		[RC_TYPE_MCIR2_KBD] = 0xffff,
 		[RC_TYPE_MCIR2_MSE] = 0x1fffff,
@@ -759,14 +807,6 @@ static int rc_validate_filter(struct rc_dev *dev,
 	enum rc_type protocol = dev->wakeup_protocol;
 
 	switch (protocol) {
-	case RC_TYPE_NECX:
-		if ((((s >> 16) ^ ~(s >> 8)) & 0xff) == 0)
-			return -EINVAL;
-		break;
-	case RC_TYPE_NEC32:
-		if ((((s >> 24) ^ ~(s >> 16)) & 0xff) == 0)
-			return -EINVAL;
-		break;
 	case RC_TYPE_RC6_MCE:
 		if ((s & 0xffff0000) != 0x800f0000)
 			return -EINVAL;
@@ -865,9 +905,7 @@ static const struct {
 	{ RC_BIT_UNKNOWN,	"unknown",	NULL			},
 	{ RC_BIT_RC5 |
 	  RC_BIT_RC5X_20,	"rc-5",		"ir-rc5-decoder"	},
-	{ RC_BIT_NEC |
-	  RC_BIT_NECX |
-	  RC_BIT_NEC32,		"nec",		"ir-nec-decoder"	},
+	{ RC_BIT_NEC,		"nec",		"ir-nec-decoder"	},
 	{ RC_BIT_RC6_0 |
 	  RC_BIT_RC6_6A_20 |
 	  RC_BIT_RC6_6A_24 |
@@ -1330,7 +1368,7 @@ static ssize_t store_filter(struct device *device,
 /*
  * This is the list of all variants of all protocols, which is used by
  * the wakeup_protocols sysfs entry. In the protocols sysfs entry some
- * some protocols are grouped together (e.g. nec = nec + necx + nec32).
+ * some protocols are grouped together.
  *
  * For wakeup we need to know the exact protocol variant so the hardware
  * can be programmed exactly what to expect.
@@ -1346,8 +1384,6 @@ static const char * const proto_variant_names[] = {
 	[RC_TYPE_SONY15] = "sony-15",
 	[RC_TYPE_SONY20] = "sony-20",
 	[RC_TYPE_NEC] = "nec",
-	[RC_TYPE_NECX] = "nec-x",
-	[RC_TYPE_NEC32] = "nec-32",
 	[RC_TYPE_SANYO] = "sanyo",
 	[RC_TYPE_MCIR2_KBD] = "mcir2-kbd",
 	[RC_TYPE_MCIR2_MSE] = "mcir2-mse",
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 5a4d4a611197..914eab8df819 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -715,34 +715,6 @@ wbcir_shutdown(struct pnp_dev *device)
 		break;
 
 	case RC_TYPE_NEC:
-		mask[1] = bitrev8(mask_sc);
-		mask[0] = mask[1];
-		mask[3] = bitrev8(mask_sc >> 8);
-		mask[2] = mask[3];
-
-		match[1] = bitrev8(wake_sc);
-		match[0] = ~match[1];
-		match[3] = bitrev8(wake_sc >> 8);
-		match[2] = ~match[3];
-
-		proto = IR_PROTOCOL_NEC;
-		break;
-
-	case RC_TYPE_NECX:
-		mask[1] = bitrev8(mask_sc);
-		mask[0] = mask[1];
-		mask[2] = bitrev8(mask_sc >> 8);
-		mask[3] = bitrev8(mask_sc >> 16);
-
-		match[1] = bitrev8(wake_sc);
-		match[0] = ~match[1];
-		match[2] = bitrev8(wake_sc >> 8);
-		match[3] = bitrev8(wake_sc >> 16);
-
-		proto = IR_PROTOCOL_NEC;
-		break;
-
-	case RC_TYPE_NEC32:
 		mask[0] = bitrev8(mask_sc);
 		mask[1] = bitrev8(mask_sc >> 8);
 		mask[2] = bitrev8(mask_sc >> 16);
@@ -1087,8 +1059,8 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	data->dev->max_timeout = 10 * IR_DEFAULT_TIMEOUT;
 	data->dev->rx_resolution = US_TO_NS(2);
 	data->dev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
-	data->dev->allowed_wakeup_protocols = RC_BIT_NEC | RC_BIT_NECX |
-			RC_BIT_NEC32 | RC_BIT_RC5 | RC_BIT_RC6_0 |
+	data->dev->allowed_wakeup_protocols =
+			RC_BIT_NEC | RC_BIT_RC5 | RC_BIT_RC6_0 |
 			RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 |
 			RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE;
 	data->dev->wakeup_protocol = RC_TYPE_RC6_MCE;
diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/media/usb/au0828/au0828-input.c
index 9ec919c68482..545741feff2f 100644
--- a/drivers/media/usb/au0828/au0828-input.c
+++ b/drivers/media/usb/au0828/au0828-input.c
@@ -343,8 +343,7 @@ int au0828_rc_register(struct au0828_dev *dev)
 	rc->input_id.product = le16_to_cpu(dev->usbdev->descriptor.idProduct);
 	rc->dev.parent = &dev->usbdev->dev;
 	rc->driver_name = "au0828-input";
-	rc->allowed_protocols = RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32 |
-								RC_BIT_RC5;
+	rc->allowed_protocols = RC_BIT_NEC | RC_BIT_RC5;
 
 	/* all done */
 	err = rc_register_device(rc);
diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index caa1e6101f58..ef1800206ca6 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -1218,7 +1218,6 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 
 	/* Only process key if canary killed */
 	if (buf[16] != 0xff && buf[0] != 0x01) {
-		enum rc_type proto;
 		dev_dbg(&d->udev->dev, "%s: key pressed %*ph\n",
 				__func__, 4, buf + 12);
 
@@ -1229,28 +1228,11 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 
 		/* Remember this key */
 		memcpy(state->rc_last, &buf[12], 4);
-		if (buf[14] == (u8) ~buf[15]) {
-			if (buf[12] == (u8) ~buf[13]) {
-				/* NEC */
-				state->rc_keycode = RC_SCANCODE_NEC(buf[12],
-								    buf[14]);
-				proto = RC_TYPE_NEC;
-			} else {
-				/* NEC extended*/
-				state->rc_keycode = RC_SCANCODE_NECX(buf[12] << 8 |
-								     buf[13],
-								     buf[14]);
-				proto = RC_TYPE_NECX;
-			}
-		} else {
-			/* 32 bit NEC */
-			state->rc_keycode = RC_SCANCODE_NEC32(buf[12] << 24 |
-							      buf[13] << 16 |
-							      buf[14] << 8  |
-							      buf[15]);
-			proto = RC_TYPE_NEC32;
-		}
-		rc_keydown(d->rc_dev, proto, state->rc_keycode, 0);
+		state->rc_keycode = RC_SCANCODE_NEC32(buf[12] << 24 |
+						      buf[13] << 16 |
+						      buf[14] << 8  |
+						      buf[15]);
+		rc_keydown(d->rc_dev, RC_TYPE_NEC, state->rc_keycode, 0);
 	} else {
 		dev_dbg(&d->udev->dev, "%s: no key press\n", __func__);
 		/* Invalidate last keypress */
@@ -1317,7 +1299,7 @@ static int af9015_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 	if (!rc->map_name)
 		rc->map_name = RC_MAP_EMPTY;
 
-	rc->allowed_protos = RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32;
+	rc->allowed_protos = RC_BIT_NEC;
 	rc->query = af9015_rc_query;
 	rc->interval = 500;
 
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 4df9486e19b9..ccb2b4c673db 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1828,8 +1828,6 @@ static int af9035_rc_query(struct dvb_usb_device *d)
 {
 	struct usb_interface *intf = d->intf;
 	int ret;
-	enum rc_type proto;
-	u32 key;
 	u8 buf[4];
 	struct usb_req req = { CMD_IR_GET, 0, 0, NULL, 4, buf };
 
@@ -1839,26 +1837,12 @@ static int af9035_rc_query(struct dvb_usb_device *d)
 	else if (ret < 0)
 		goto err;
 
-	if ((buf[2] + buf[3]) == 0xff) {
-		if ((buf[0] + buf[1]) == 0xff) {
-			/* NEC standard 16bit */
-			key = RC_SCANCODE_NEC(buf[0], buf[2]);
-			proto = RC_TYPE_NEC;
-		} else {
-			/* NEC extended 24bit */
-			key = RC_SCANCODE_NECX(buf[0] << 8 | buf[1], buf[2]);
-			proto = RC_TYPE_NECX;
-		}
-	} else {
-		/* NEC full code 32bit */
-		key = RC_SCANCODE_NEC32(buf[0] << 24 | buf[1] << 16 |
-					buf[2] << 8  | buf[3]);
-		proto = RC_TYPE_NEC32;
-	}
-
 	dev_dbg(&intf->dev, "%*ph\n", 4, buf);
 
-	rc_keydown(d->rc_dev, proto, key, 0);
+	rc_keydown(d->rc_dev, RC_TYPE_NEC,
+		   RC_SCANCODE_NEC32(buf[0] << 24 | buf[1] << 16 |
+				     buf[2] << 8  | buf[3]),
+		   0);
 
 	return 0;
 
@@ -1881,8 +1865,7 @@ static int af9035_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 		switch (state->ir_type) {
 		case 0: /* NEC */
 		default:
-			rc->allowed_protos = RC_BIT_NEC | RC_BIT_NECX |
-								RC_BIT_NEC32;
+			rc->allowed_protos = RC_BIT_NEC;
 			break;
 		case 1: /* RC6 */
 			rc->allowed_protos = RC_BIT_RC6_MCE;
diff --git a/drivers/media/usb/dvb-usb-v2/az6007.c b/drivers/media/usb/dvb-usb-v2/az6007.c
index 50c07fe7dacb..7e3827843042 100644
--- a/drivers/media/usb/dvb-usb-v2/az6007.c
+++ b/drivers/media/usb/dvb-usb-v2/az6007.c
@@ -208,31 +208,18 @@ static int az6007_rc_query(struct dvb_usb_device *d)
 {
 	struct az6007_device_state *st = d_to_priv(d);
 	unsigned code;
-	enum rc_type proto;
 
 	az6007_read(d, AZ6007_READ_IR, 0, 0, st->data, 10);
 
 	if (st->data[1] == 0x44)
 		return 0;
 
-	if ((st->data[3] ^ st->data[4]) == 0xff) {
-		if ((st->data[1] ^ st->data[2]) == 0xff) {
-			code = RC_SCANCODE_NEC(st->data[1], st->data[3]);
-			proto = RC_TYPE_NEC;
-		} else {
-			code = RC_SCANCODE_NECX(st->data[1] << 8 | st->data[2],
-						st->data[3]);
-			proto = RC_TYPE_NECX;
-		}
-	} else {
-		code = RC_SCANCODE_NEC32(st->data[1] << 24 |
-					 st->data[2] << 16 |
-					 st->data[3] << 8  |
-					 st->data[4]);
-		proto = RC_TYPE_NEC32;
-	}
+	code = RC_SCANCODE_NEC32(st->data[1] << 24 |
+				 st->data[2] << 16 |
+				 st->data[3] << 8  |
+				 st->data[4]);
 
-	rc_keydown(d->rc_dev, proto, code, st->data[5]);
+	rc_keydown(d->rc_dev, RC_TYPE_NEC, code, st->data[5]);
 
 	return 0;
 }
@@ -241,7 +228,7 @@ static int az6007_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 {
 	pr_debug("Getting az6007 Remote Control properties\n");
 
-	rc->allowed_protos = RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32;
+	rc->allowed_protos = RC_BIT_NEC;
 	rc->query          = az6007_rc_query;
 	rc->interval       = 400;
 
diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index 924adfdb660d..860e9cf2ee4e 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -349,8 +349,7 @@ static void lme2510_int_response(struct urb *lme_urb)
 						ibuf[5]);
 
 			deb_info(1, "INT Key = 0x%08x", key);
-			rc_keydown(adap_to_d(adap)->rc_dev, RC_TYPE_NEC32, key,
-									0);
+			rc_keydown(adap_to_d(adap)->rc_dev, RC_TYPE_NEC, key, 0);
 			break;
 		case 0xbb:
 			switch (st->tuner_config) {
@@ -1233,7 +1232,7 @@ static int lme2510_get_stream_config(struct dvb_frontend *fe, u8 *ts_type,
 static int lme2510_get_rc_config(struct dvb_usb_device *d,
 	struct dvb_usb_rc *rc)
 {
-	rc->allowed_protos = RC_BIT_NEC32;
+	rc->allowed_protos = RC_BIT_NEC;
 	return 0;
 }
 
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index e16ca07acf1d..06219abaef7b 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1597,7 +1597,7 @@ static int rtl2831u_rc_query(struct dvb_usb_device *d)
 	int ret, i;
 	struct rtl28xxu_dev *dev = d->priv;
 	u8 buf[5];
-	u32 rc_code;
+	u64 rc_code;
 	struct rtl28xxu_reg_val rc_nec_tab[] = {
 		{ 0x3033, 0x80 },
 		{ 0x3020, 0x43 },
@@ -1631,27 +1631,12 @@ static int rtl2831u_rc_query(struct dvb_usb_device *d)
 		goto err;
 
 	if (buf[4] & 0x01) {
-		enum rc_type proto;
+		rc_code = RC_SCANCODE_NEC32(buf[0] << 24 |
+					    buf[1] << 16 |
+					    buf[2] << 8  |
+					    buf[3]);
 
-		if (buf[2] == (u8) ~buf[3]) {
-			if (buf[0] == (u8) ~buf[1]) {
-				/* NEC standard (16 bit) */
-				rc_code = RC_SCANCODE_NEC(buf[0], buf[2]);
-				proto = RC_TYPE_NEC;
-			} else {
-				/* NEC extended (24 bit) */
-				rc_code = RC_SCANCODE_NECX(buf[0] << 8 | buf[1],
-							   buf[2]);
-				proto = RC_TYPE_NECX;
-			}
-		} else {
-			/* NEC full (32 bit) */
-			rc_code = RC_SCANCODE_NEC32(buf[0] << 24 | buf[1] << 16 |
-						    buf[2] << 8  | buf[3]);
-			proto = RC_TYPE_NEC32;
-		}
-
-		rc_keydown(d->rc_dev, proto, rc_code, 0);
+		rc_keydown(d->rc_dev, RC_TYPE_NEC, rc_code, 0);
 
 		ret = rtl28xxu_wr_reg(d, SYS_IRRC_SR, 1);
 		if (ret)
@@ -1673,7 +1658,7 @@ static int rtl2831u_get_rc_config(struct dvb_usb_device *d,
 		struct dvb_usb_rc *rc)
 {
 	rc->map_name = RC_MAP_EMPTY;
-	rc->allowed_protos = RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32;
+	rc->allowed_protos = RC_BIT_NEC;
 	rc->query = rtl2831u_rc_query;
 	rc->interval = 400;
 
diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index 08acdd32e412..3267bc7ea9c5 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -734,6 +734,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 
 	switch (d->props.rc.core.protocol) {
 	case RC_BIT_NEC:
+		protocol = RC_TYPE_NEC;
 		toggle = 0;
 
 		/* NEC protocol sends repeat code as 0 0 0 FF */
@@ -746,26 +747,10 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 			goto resubmit;
 		}
 
-		if ((poll_reply->nec.data ^ poll_reply->nec.not_data) != 0xff) {
-			deb_data("NEC32 protocol\n");
-			keycode = RC_SCANCODE_NEC32(poll_reply->nec.system     << 24 |
-						     poll_reply->nec.not_system << 16 |
-						     poll_reply->nec.data       << 8  |
-						     poll_reply->nec.not_data);
-			protocol = RC_TYPE_NEC32;
-		} else if ((poll_reply->nec.system ^ poll_reply->nec.not_system) != 0xff) {
-			deb_data("NEC extended protocol\n");
-			keycode = RC_SCANCODE_NECX(poll_reply->nec.system << 8 |
-						    poll_reply->nec.not_system,
-						    poll_reply->nec.data);
-
-			protocol = RC_TYPE_NECX;
-		} else {
-			deb_data("NEC normal protocol\n");
-			keycode = RC_SCANCODE_NEC(poll_reply->nec.system,
-						   poll_reply->nec.data);
-			protocol = RC_TYPE_NEC;
-		}
+		keycode = RC_SCANCODE_NEC32(poll_reply->nec.system     << 24 |
+					    poll_reply->nec.not_system << 16 |
+					    poll_reply->nec.data       << 8  |
+					    poll_reply->nec.not_data);
 
 		break;
 	default:
diff --git a/drivers/media/usb/dvb-usb/dtt200u.c b/drivers/media/usb/dvb-usb/dtt200u.c
index fcbff7fb0c4e..ffe987f72590 100644
--- a/drivers/media/usb/dvb-usb/dtt200u.c
+++ b/drivers/media/usb/dvb-usb/dtt200u.c
@@ -89,7 +89,6 @@ static int dtt200u_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid,
 static int dtt200u_rc_query(struct dvb_usb_device *d)
 {
 	struct dtt200u_state *st = d->priv;
-	u32 scancode;
 	int ret;
 
 	mutex_lock(&d->data_mutex);
@@ -100,23 +99,13 @@ static int dtt200u_rc_query(struct dvb_usb_device *d)
 		goto ret;
 
 	if (st->data[0] == 1) {
-		enum rc_type proto = RC_TYPE_NEC;
-
-		scancode = st->data[1];
-		if ((u8) ~st->data[1] != st->data[2]) {
-			/* Extended NEC */
-			scancode = scancode << 8;
-			scancode |= st->data[2];
-			proto = RC_TYPE_NECX;
-		}
-		scancode = scancode << 8;
-		scancode |= st->data[3];
-
-		/* Check command checksum is ok */
-		if ((u8) ~st->data[3] == st->data[4])
-			rc_keydown(d->rc_dev, proto, scancode, 0);
-		else
-			rc_keyup(d->rc_dev);
+		u32 scancode;
+
+		scancode = RC_SCANCODE_NEC32((st->data[1] << 24) |
+					     (st->data[2] << 16) |
+					     (st->data[3] <<  8) |
+					     (st->data[4] <<  0));
+		rc_keydown(d->rc_dev, RC_TYPE_NEC, scancode, 0);
 	} else if (st->data[0] == 2) {
 		rc_repeat(d->rc_dev);
 	} else {
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index eba75736e654..93c3fca7849a 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -259,21 +259,11 @@ static int em2874_polling_getkey(struct em28xx_IR *ir,
 		break;
 
 	case RC_BIT_NEC:
-		poll_result->scancode = msg[1] << 8 | msg[2];
-		if ((msg[3] ^ msg[4]) != 0xff) {	/* 32 bits NEC */
-			poll_result->protocol = RC_TYPE_NEC32;
-			poll_result->scancode = RC_SCANCODE_NEC32((msg[1] << 24) |
-								  (msg[2] << 16) |
-								  (msg[3] << 8)  |
-								  (msg[4]));
-		} else if ((msg[1] ^ msg[2]) != 0xff) {	/* 24 bits NEC */
-			poll_result->protocol = RC_TYPE_NECX;
-			poll_result->scancode = RC_SCANCODE_NECX(msg[1] << 8 |
-								 msg[2], msg[3]);
-		} else {				/* Normal NEC */
-			poll_result->protocol = RC_TYPE_NEC;
-			poll_result->scancode = RC_SCANCODE_NEC(msg[1], msg[3]);
-		}
+		poll_result->protocol = RC_TYPE_NEC;
+		poll_result->scancode = RC_SCANCODE_NEC32((msg[1] << 24) |
+							  (msg[2] << 16) |
+							  (msg[3] << 8)  |
+							  (msg[4]));
 		break;
 
 	case RC_BIT_RC6_0:
@@ -780,7 +770,7 @@ static int em28xx_ir_init(struct em28xx *dev)
 		case CHIP_ID_EM28178:
 			ir->get_key = em2874_polling_getkey;
 			rc->allowed_protocols = RC_BIT_RC5 | RC_BIT_NEC |
-				RC_BIT_NECX | RC_BIT_NEC32 | RC_BIT_RC6_0;
+				RC_BIT_RC6_0;
 			break;
 		default:
 			err = -ENODEV;
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 1a815a572fa1..e5d0559dc523 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -24,8 +24,6 @@
  * @RC_TYPE_SONY15: Sony 15 bit protocol
  * @RC_TYPE_SONY20: Sony 20 bit protocol
  * @RC_TYPE_NEC: NEC protocol
- * @RC_TYPE_NECX: Extended NEC protocol
- * @RC_TYPE_NEC32: NEC 32 bit protocol
  * @RC_TYPE_SANYO: Sanyo protocol
  * @RC_TYPE_MCIR2_KBD: RC6-ish MCE keyboard
  * @RC_TYPE_MCIR2_MSE: RC6-ish MCE mouse
@@ -49,21 +47,20 @@ enum rc_type {
 	RC_TYPE_SONY15		= 7,
 	RC_TYPE_SONY20		= 8,
 	RC_TYPE_NEC		= 9,
-	RC_TYPE_NECX		= 10,
-	RC_TYPE_NEC32		= 11,
-	RC_TYPE_SANYO		= 12,
-	RC_TYPE_MCIR2_KBD	= 13,
-	RC_TYPE_MCIR2_MSE	= 14,
-	RC_TYPE_RC6_0		= 15,
-	RC_TYPE_RC6_6A_20	= 16,
-	RC_TYPE_RC6_6A_24	= 17,
-	RC_TYPE_RC6_6A_32	= 18,
-	RC_TYPE_RC6_MCE		= 19,
-	RC_TYPE_SHARP		= 20,
-	RC_TYPE_XMP		= 21,
-	RC_TYPE_CEC		= 22,
+	RC_TYPE_SANYO		= 10,
+	RC_TYPE_MCIR2_KBD	= 11,
+	RC_TYPE_MCIR2_MSE	= 12,
+	RC_TYPE_RC6_0		= 13,
+	RC_TYPE_RC6_6A_20	= 14,
+	RC_TYPE_RC6_6A_24	= 15,
+	RC_TYPE_RC6_6A_32	= 16,
+	RC_TYPE_RC6_MCE		= 17,
+	RC_TYPE_SHARP		= 18,
+	RC_TYPE_XMP		= 19,
+	RC_TYPE_CEC		= 20,
 };
 
+#define rc_bitmap_to_type(x) (fls64(x) - 1)
 #define RC_BIT_NONE		0ULL
 #define RC_BIT_UNKNOWN		BIT_ULL(RC_TYPE_UNKNOWN)
 #define RC_BIT_OTHER		BIT_ULL(RC_TYPE_OTHER)
@@ -75,8 +72,6 @@ enum rc_type {
 #define RC_BIT_SONY15		BIT_ULL(RC_TYPE_SONY15)
 #define RC_BIT_SONY20		BIT_ULL(RC_TYPE_SONY20)
 #define RC_BIT_NEC		BIT_ULL(RC_TYPE_NEC)
-#define RC_BIT_NECX		BIT_ULL(RC_TYPE_NECX)
-#define RC_BIT_NEC32		BIT_ULL(RC_TYPE_NEC32)
 #define RC_BIT_SANYO		BIT_ULL(RC_TYPE_SANYO)
 #define RC_BIT_MCIR2_KBD	BIT_ULL(RC_TYPE_MCIR2_KBD)
 #define RC_BIT_MCIR2_MSE	BIT_ULL(RC_TYPE_MCIR2_MSE)
@@ -93,7 +88,7 @@ enum rc_type {
 			 RC_BIT_RC5 | RC_BIT_RC5X_20 | RC_BIT_RC5_SZ | \
 			 RC_BIT_JVC | \
 			 RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20 | \
-			 RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32 | \
+			 RC_BIT_NEC | \
 			 RC_BIT_SANYO | \
 			 RC_BIT_MCIR2_KBD | RC_BIT_MCIR2_MSE | \
 			 RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
@@ -104,7 +99,7 @@ enum rc_type {
 			(RC_BIT_RC5 | RC_BIT_RC5X_20 | RC_BIT_RC5_SZ | \
 			 RC_BIT_JVC | \
 			 RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20 | \
-			 RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32 | \
+			 RC_BIT_NEC | \
 			 RC_BIT_SANYO | RC_BIT_MCIR2_KBD | RC_BIT_MCIR2_MSE | \
 			 RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
 			 RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE | RC_BIT_SHARP | \
@@ -114,7 +109,7 @@ enum rc_type {
 			(RC_BIT_RC5 | RC_BIT_RC5X_20 | RC_BIT_RC5_SZ | \
 			 RC_BIT_JVC | \
 			 RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20 | \
-			 RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32 | \
+			 RC_BIT_NEC | \
 			 RC_BIT_SANYO | RC_BIT_MCIR2_KBD | RC_BIT_MCIR2_MSE | \
 			 RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
 			 RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE | \
@@ -122,13 +117,20 @@ enum rc_type {
 
 #define RC_SCANCODE_UNKNOWN(x)			(x)
 #define RC_SCANCODE_OTHER(x)			(x)
-#define RC_SCANCODE_NEC(addr, cmd)		(((addr) << 8) | (cmd))
-#define RC_SCANCODE_NECX(addr, cmd)		(((addr) << 8) | (cmd))
-#define RC_SCANCODE_NEC32(data)			((data) & 0xffffffff)
 #define RC_SCANCODE_RC5(sys, cmd)		(((sys) << 8) | (cmd))
 #define RC_SCANCODE_RC5_SZ(sys, cmd)		(((sys) << 8) | (cmd))
 #define RC_SCANCODE_RC6_0(sys, cmd)		(((sys) << 8) | (cmd))
 #define RC_SCANCODE_RC6_6A(vendor, sys, cmd)	(((vendor) << 16) | ((sys) << 8) | (cmd))
+#define RC_SCANCODE_NEC(addr, cmd)  \
+	((((addr)  & 0xff) << 24) | \
+	 ((~(addr) & 0xff) << 16) | \
+	 (((cmd)   & 0xff) << 8 ) | \
+	 ((~(cmd)  & 0xff) << 0 ))
+#define RC_SCANCODE_NECX(addr, cmd)   \
+	((((addr) & 0xffff) << 16) | \
+	 (((cmd)  & 0x00ff) << 8)  | \
+	 ((~(cmd) & 0x00ff) << 0))
+#define RC_SCANCODE_NEC32(data) ((data) & 0xffffffff)
 
 /**
  * struct rc_map_table - represents a scancode/keycode pair
