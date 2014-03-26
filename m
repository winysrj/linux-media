Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:37282 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755631AbaCZAEf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 20:04:35 -0400
Subject: [PATCH 3/3] rc-core: document the protocol type
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: m.chehab@samsung.com
Date: Wed, 26 Mar 2014 01:04:33 +0100
Message-ID: <20140326000433.5663.48614.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140325235935.5663.96526.stgit@zeus.muc.hardeman.nu>
References: <20140325235935.5663.96526.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now the protocol information is not preserved, rc-core gets handed a
scancode but has no idea which protocol it corresponds to.

This patch (which required reading through the source/keymap for all drivers,
not fun) makes the protocol information explicit which is important
documentation and makes it easier to e.g. support multiple protocols with one
decoder (think rc5 and rc-streamzap). The information isn't used yet so there
should be no functional changes.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/i2c/ir-kbd-i2c.c              |    5 +
 drivers/media/pci/bt8xx/bttv-input.c        |   12 ++-
 drivers/media/pci/cx88/cx88-input.c         |   26 ++++++-
 drivers/media/pci/dm1105/dm1105.c           |    3 +
 drivers/media/pci/saa7134/saa7134-input.c   |    6 +-
 drivers/media/pci/ttpci/budget-ci.c         |    8 +-
 drivers/media/rc/img-ir/img-ir-hw.c         |    8 +-
 drivers/media/rc/img-ir/img-ir-hw.h         |    3 +
 drivers/media/rc/img-ir/img-ir-jvc.c        |    4 +
 drivers/media/rc/img-ir/img-ir-nec.c        |    4 +
 drivers/media/rc/img-ir/img-ir-sanyo.c      |    4 +
 drivers/media/rc/img-ir/img-ir-sharp.c      |    4 +
 drivers/media/rc/img-ir/img-ir-sony.c       |   12 ++-
 drivers/media/rc/ir-jvc-decoder.c           |    2 -
 drivers/media/rc/ir-nec-decoder.c           |    2 -
 drivers/media/rc/ir-rc5-decoder.c           |    5 +
 drivers/media/rc/ir-rc5-sz-decoder.c        |    2 -
 drivers/media/rc/ir-rc6-decoder.c           |   37 ++++++++--
 drivers/media/rc/ir-sanyo-decoder.c         |    2 -
 drivers/media/rc/ir-sharp-decoder.c         |    2 -
 drivers/media/rc/ir-sony-decoder.c          |    6 +-
 drivers/media/rc/rc-main.c                  |   32 +++++----
 drivers/media/usb/dvb-usb-v2/af9015.c       |   18 +++--
 drivers/media/usb/dvb-usb-v2/af9035.c       |    9 +-
 drivers/media/usb/dvb-usb-v2/anysee.c       |    3 +
 drivers/media/usb/dvb-usb-v2/az6007.c       |   25 ++++---
 drivers/media/usb/dvb-usb-v2/lmedm04.c      |    9 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c     |   12 ++-
 drivers/media/usb/dvb-usb/dib0700_core.c    |   16 +++-
 drivers/media/usb/dvb-usb/dib0700_devices.c |   24 ++++---
 drivers/media/usb/dvb-usb/dw2102.c          |    7 +-
 drivers/media/usb/dvb-usb/m920x.c           |    2 -
 drivers/media/usb/dvb-usb/pctv452e.c        |    8 +-
 drivers/media/usb/dvb-usb/ttusb2.c          |    6 +-
 drivers/media/usb/em28xx/em28xx-input.c     |   98 ++++++++++++++++-----------
 drivers/media/usb/tm6000/tm6000-input.c     |   51 ++++++++++----
 include/media/rc-core.h                     |    6 +-
 37 files changed, 301 insertions(+), 182 deletions(-)

diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index 143cb2b..f9c4233 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -261,8 +261,9 @@ static int ir_key_poll(struct IR_i2c *ir)
 	}
 
 	if (rc) {
-		dprintk(1, "%s: scancode = 0x%08x\n", __func__, scancode);
-		rc_keydown(ir->rc, scancode, toggle);
+		dprintk(1, "%s: proto = 0x%04x, scancode = 0x%08x\n",
+			__func__, protocol, scancode);
+		rc_keydown(ir->rc, protocol, scancode, toggle);
 	}
 	return 0;
 }
diff --git a/drivers/media/pci/bt8xx/bttv-input.c b/drivers/media/pci/bt8xx/bttv-input.c
index e745f5a..67c8d6b 100644
--- a/drivers/media/pci/bt8xx/bttv-input.c
+++ b/drivers/media/pci/bt8xx/bttv-input.c
@@ -73,12 +73,12 @@ static void ir_handle_key(struct bttv *btv)
 
 	if ((ir->mask_keydown && (gpio & ir->mask_keydown)) ||
 	    (ir->mask_keyup   && !(gpio & ir->mask_keyup))) {
-		rc_keydown_notimeout(ir->dev, data, 0);
+		rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
 	} else {
 		/* HACK: Probably, ir->mask_keydown is missing
 		   for this board */
 		if (btv->c.type == BTTV_BOARD_WINFAST2000)
-			rc_keydown_notimeout(ir->dev, data, 0);
+			rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
 
 		rc_keyup(ir->dev);
 	}
@@ -103,7 +103,7 @@ static void ir_enltv_handle_key(struct bttv *btv)
 			gpio, data,
 			(gpio & ir->mask_keyup) ? " up" : "up/down");
 
-		rc_keydown_notimeout(ir->dev, data, 0);
+		rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
 		if (keyup)
 			rc_keyup(ir->dev);
 	} else {
@@ -117,7 +117,7 @@ static void ir_enltv_handle_key(struct bttv *btv)
 		if (keyup)
 			rc_keyup(ir->dev);
 		else
-			rc_keydown_notimeout(ir->dev, data, 0);
+			rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
 	}
 
 	ir->last_gpio = data | keyup;
@@ -241,8 +241,8 @@ static void bttv_rc5_timer_end(unsigned long data)
 		return;
 	}
 
-	scancode = system << 8 | command;
-	rc_keydown(ir->dev, scancode, toggle);
+	scancode = RC_SCANCODE_RC5(system, command);
+	rc_keydown(ir->dev, RC_TYPE_RC5, scancode, toggle);
 	dprintk("scancode %x, toggle %x\n", scancode, toggle);
 }
 
diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
index 779fc63..9bf48ca 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -130,25 +130,41 @@ static void cx88_ir_handle_key(struct cx88_IR *ir)
 
 		data = (data << 4) | ((gpio_key & 0xf0) >> 4);
 
-		rc_keydown(ir->dev, data, 0);
+		rc_keydown(ir->dev, RC_TYPE_UNKNOWN, data, 0);
+
+	} else if (ir->core->boardnr == CX88_BOARD_PROLINK_PLAYTVPVR ||
+		   ir->core->boardnr == CX88_BOARD_PIXELVIEW_PLAYTV_ULTRA_PRO) {
+		/* bit cleared on keydown, NEC scancode, 0xAAAACC, A = 0x866b */
+		u16 addr;
+		u8 cmd;
+		u32 scancode;
+
+		addr = (data >> 8) & 0xffff;
+		cmd  = (data >> 0) & 0x00ff;
+		scancode = RC_SCANCODE_NECX(addr, cmd);
+
+		if (0 == (gpio & ir->mask_keyup))
+			rc_keydown_notimeout(ir->dev, RC_TYPE_NEC, scancode, 0);
+		else
+			rc_keyup(ir->dev);
 
 	} else if (ir->mask_keydown) {
 		/* bit set on keydown */
 		if (gpio & ir->mask_keydown)
-			rc_keydown_notimeout(ir->dev, data, 0);
+			rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
 		else
 			rc_keyup(ir->dev);
 
 	} else if (ir->mask_keyup) {
 		/* bit cleared on keydown */
 		if (0 == (gpio & ir->mask_keyup))
-			rc_keydown_notimeout(ir->dev, data, 0);
+			rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
 		else
 			rc_keyup(ir->dev);
 
 	} else {
 		/* can't distinguish keydown/up :-/ */
-		rc_keydown_notimeout(ir->dev, data, 0);
+		rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
 		rc_keyup(ir->dev);
 	}
 }
@@ -329,6 +345,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		 * 002-T mini RC, provided with newer PV hardware
 		 */
 		ir_codes = RC_MAP_PIXELVIEW_MK12;
+		rc_type = RC_BIT_NEC;
 		ir->gpio_addr = MO_GP1_IO;
 		ir->mask_keyup = 0x80;
 		ir->polling = 10; /* ms */
@@ -416,7 +433,6 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		break;
 	case CX88_BOARD_TWINHAN_VP1027_DVBS:
 		ir_codes         = RC_MAP_TWINHAN_VP1027_DVBS;
-		rc_type          = RC_BIT_NEC;
 		ir->sampling     = 0xff00; /* address */
 		break;
 	}
diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index e60ac35..e8826c5 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -678,7 +678,8 @@ static void dm1105_emit_key(struct work_struct *work)
 
 	data = (ircom >> 8) & 0x7f;
 
-	rc_keydown(ir->dev, data, 0);
+	/* FIXME: UNKNOWN because we don't generate a full NEC scancode (yet?) */
+	rc_keydown(ir->dev, RC_TYPE_UNKNOWN, data, 0);
 }
 
 /* work handler */
diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index 73670ed..43dd8bd 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -83,14 +83,14 @@ static int build_key(struct saa7134_dev *dev)
 		if (data == ir->mask_keycode)
 			rc_keyup(ir->dev);
 		else
-			rc_keydown_notimeout(ir->dev, data, 0);
+			rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
 		return 0;
 	}
 
 	if (ir->polling) {
 		if ((ir->mask_keydown  &&  (0 != (gpio & ir->mask_keydown))) ||
 		    (ir->mask_keyup    &&  (0 == (gpio & ir->mask_keyup)))) {
-			rc_keydown_notimeout(ir->dev, data, 0);
+			rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
 		} else {
 			rc_keyup(ir->dev);
 		}
@@ -98,7 +98,7 @@ static int build_key(struct saa7134_dev *dev)
 	else {	/* IRQ driven mode - handle key press and release in one go */
 		if ((ir->mask_keydown  &&  (0 != (gpio & ir->mask_keydown))) ||
 		    (ir->mask_keyup    &&  (0 == (gpio & ir->mask_keyup)))) {
-			rc_keydown_notimeout(ir->dev, data, 0);
+			rc_keydown_notimeout(ir->dev, RC_TYPE_UNKNOWN, data, 0);
 			rc_keyup(ir->dev);
 		}
 	}
diff --git a/drivers/media/pci/ttpci/budget-ci.c b/drivers/media/pci/ttpci/budget-ci.c
index 0acf920..41ce7de 100644
--- a/drivers/media/pci/ttpci/budget-ci.c
+++ b/drivers/media/pci/ttpci/budget-ci.c
@@ -161,14 +161,14 @@ static void msp430_ir_interrupt(unsigned long data)
 		return;
 
 	if (budget_ci->ir.full_rc5) {
-		rc_keydown(dev,
-			   budget_ci->ir.rc5_device <<8 | budget_ci->ir.ir_key,
-			   (command & 0x20) ? 1 : 0);
+		rc_keydown(dev, RC_TYPE_RC5,
+			   RC_SCANCODE_RC5(budget_ci->ir.rc5_device, budget_ci->ir.ir_key),
+			   !!(command & 0x20));
 		return;
 	}
 
 	/* FIXME: We should generate complete scancodes for all devices */
-	rc_keydown(dev, budget_ci->ir.ir_key, (command & 0x20) ? 1 : 0);
+	rc_keydown(dev, RC_TYPE_UNKNOWN, budget_ci->ir.ir_key, !!(command & 0x20));
 }
 
 static int msp430_ir_init(struct budget_ci *budget_ci)
diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index 579a52b..aec79f7 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -778,9 +778,11 @@ static void img_ir_handle_data(struct img_ir_priv *priv, u32 len, u64 raw)
 	struct img_ir_priv_hw *hw = &priv->hw;
 	const struct img_ir_decoder *dec = hw->decoder;
 	int ret = IMG_IR_SCANCODE;
-	int scancode;
+	u32 scancode;
+	enum rc_type protocol = RC_TYPE_UNKNOWN;
+
 	if (dec->scancode)
-		ret = dec->scancode(len, raw, &scancode, hw->enabled_protocols);
+		ret = dec->scancode(len, raw, &protocol, &scancode, hw->enabled_protocols);
 	else if (len >= 32)
 		scancode = (u32)raw;
 	else if (len < 32)
@@ -789,7 +791,7 @@ static void img_ir_handle_data(struct img_ir_priv *priv, u32 len, u64 raw)
 		len, (unsigned long long)raw);
 	if (ret == IMG_IR_SCANCODE) {
 		dev_dbg(priv->dev, "decoded scan code %#x\n", scancode);
-		rc_keydown(hw->rdev, scancode, 0);
+		rc_keydown(hw->rdev, protocol, scancode, 0);
 		img_ir_end_repeat(priv);
 	} else if (ret == IMG_IR_REPEATCODE) {
 		if (hw->mode == IMG_IR_M_REPEATING) {
diff --git a/drivers/media/rc/img-ir/img-ir-hw.h b/drivers/media/rc/img-ir/img-ir-hw.h
index 6c9a94a..e5dc98b 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.h
+++ b/drivers/media/rc/img-ir/img-ir-hw.h
@@ -157,7 +157,8 @@ struct img_ir_decoder {
 	struct img_ir_control		control;
 
 	/* scancode logic */
-	int (*scancode)(int len, u64 raw, int *scancode, u64 protocols);
+	int (*scancode)(int len, u64 raw, enum rc_type *protocol,
+			u32 *scancode, u64 enabled_protocols);
 	int (*filter)(const struct rc_scancode_filter *in,
 		      struct img_ir_filter *out, u64 protocols);
 };
diff --git a/drivers/media/rc/img-ir/img-ir-jvc.c b/drivers/media/rc/img-ir/img-ir-jvc.c
index 10209d2..be68a16 100644
--- a/drivers/media/rc/img-ir/img-ir-jvc.c
+++ b/drivers/media/rc/img-ir/img-ir-jvc.c
@@ -7,7 +7,8 @@
 #include "img-ir-hw.h"
 
 /* Convert JVC data to a scancode */
-static int img_ir_jvc_scancode(int len, u64 raw, int *scancode, u64 protocols)
+static int img_ir_jvc_scancode(int len, u64 raw, enum rc_type *protocol,
+			       u32 *scancode, u64 enabled_protocols)
 {
 	unsigned int cust, data;
 
@@ -17,6 +18,7 @@ static int img_ir_jvc_scancode(int len, u64 raw, int *scancode, u64 protocols)
 	cust = (raw >> 0) & 0xff;
 	data = (raw >> 8) & 0xff;
 
+	*protocol = RC_TYPE_JVC;
 	*scancode = cust << 8 | data;
 	return IMG_IR_SCANCODE;
 }
diff --git a/drivers/media/rc/img-ir/img-ir-nec.c b/drivers/media/rc/img-ir/img-ir-nec.c
index e7a731b..c0111d6 100644
--- a/drivers/media/rc/img-ir/img-ir-nec.c
+++ b/drivers/media/rc/img-ir/img-ir-nec.c
@@ -7,7 +7,8 @@
 #include "img-ir-hw.h"
 
 /* Convert NEC data to a scancode */
-static int img_ir_nec_scancode(int len, u64 raw, int *scancode, u64 protocols)
+static int img_ir_nec_scancode(int len, u64 raw, enum rc_type *protocol,
+			       u32 *scancode, u64 enabled_protocols)
 {
 	unsigned int addr, addr_inv, data, data_inv;
 	/* a repeat code has no data */
@@ -39,6 +40,7 @@ static int img_ir_nec_scancode(int len, u64 raw, int *scancode, u64 protocols)
 		*scancode = addr << 8 |
 			    data;
 	}
+	*protocol = RC_TYPE_NEC;
 	return IMG_IR_SCANCODE;
 }
 
diff --git a/drivers/media/rc/img-ir/img-ir-sanyo.c b/drivers/media/rc/img-ir/img-ir-sanyo.c
index c2c763e..a0a0129 100644
--- a/drivers/media/rc/img-ir/img-ir-sanyo.c
+++ b/drivers/media/rc/img-ir/img-ir-sanyo.c
@@ -18,7 +18,8 @@
 #include "img-ir-hw.h"
 
 /* Convert Sanyo data to a scancode */
-static int img_ir_sanyo_scancode(int len, u64 raw, int *scancode, u64 protocols)
+static int img_ir_sanyo_scancode(int len, u64 raw, enum rc_type *protocol,
+				 u32 *scancode, u64 enabled_protocols)
 {
 	unsigned int addr, addr_inv, data, data_inv;
 	/* a repeat code has no data */
@@ -38,6 +39,7 @@ static int img_ir_sanyo_scancode(int len, u64 raw, int *scancode, u64 protocols)
 		return -EINVAL;
 
 	/* Normal Sanyo */
+	*protocol = RC_TYPE_SANYO;
 	*scancode = addr << 8 | data;
 	return IMG_IR_SCANCODE;
 }
diff --git a/drivers/media/rc/img-ir/img-ir-sharp.c b/drivers/media/rc/img-ir/img-ir-sharp.c
index 3397cc5..8624fd2 100644
--- a/drivers/media/rc/img-ir/img-ir-sharp.c
+++ b/drivers/media/rc/img-ir/img-ir-sharp.c
@@ -7,7 +7,8 @@
 #include "img-ir-hw.h"
 
 /* Convert Sharp data to a scancode */
-static int img_ir_sharp_scancode(int len, u64 raw, int *scancode, u64 protocols)
+static int img_ir_sharp_scancode(int len, u64 raw, enum rc_type *protocol,
+				 u32 *scancode, u64 enabled_protocols)
 {
 	unsigned int addr, cmd, exp, chk;
 
@@ -26,6 +27,7 @@ static int img_ir_sharp_scancode(int len, u64 raw, int *scancode, u64 protocols)
 		/* probably the second half of the message */
 		return -EINVAL;
 
+	*protocol = RC_TYPE_SHARP;
 	*scancode = addr << 8 | cmd;
 	return IMG_IR_SCANCODE;
 }
diff --git a/drivers/media/rc/img-ir/img-ir-sony.c b/drivers/media/rc/img-ir/img-ir-sony.c
index 993409a..eb11ce8 100644
--- a/drivers/media/rc/img-ir/img-ir-sony.c
+++ b/drivers/media/rc/img-ir/img-ir-sony.c
@@ -7,35 +7,39 @@
 #include "img-ir-hw.h"
 
 /* Convert Sony data to a scancode */
-static int img_ir_sony_scancode(int len, u64 raw, int *scancode, u64 protocols)
+static int img_ir_sony_scancode(int len, u64 raw, enum rc_type *protocol,
+				u32 *scancode, u64 enabled_protocols)
 {
 	unsigned int dev, subdev, func;
 
 	switch (len) {
 	case 12:
-		if (!(protocols & RC_BIT_SONY12))
+		if (!(enabled_protocols & RC_BIT_SONY12))
 			return -EINVAL;
 		func   = raw & 0x7f;	/* first 7 bits */
 		raw    >>= 7;
 		dev    = raw & 0x1f;	/* next 5 bits */
 		subdev = 0;
+		*protocol = RC_TYPE_SONY12;
 		break;
 	case 15:
-		if (!(protocols & RC_BIT_SONY15))
+		if (!(enabled_protocols & RC_BIT_SONY15))
 			return -EINVAL;
 		func   = raw & 0x7f;	/* first 7 bits */
 		raw    >>= 7;
 		dev    = raw & 0xff;	/* next 8 bits */
 		subdev = 0;
+		*protocol = RC_TYPE_SONY15;
 		break;
 	case 20:
-		if (!(protocols & RC_BIT_SONY20))
+		if (!(enabled_protocols & RC_BIT_SONY20))
 			return -EINVAL;
 		func   = raw & 0x7f;	/* first 7 bits */
 		raw    >>= 7;
 		dev    = raw & 0x1f;	/* next 5 bits */
 		raw    >>= 5;
 		subdev = raw & 0xff;	/* next 8 bits */
+		*protocol = RC_TYPE_SONY20;
 		break;
 	default:
 		return -EINVAL;
diff --git a/drivers/media/rc/ir-jvc-decoder.c b/drivers/media/rc/ir-jvc-decoder.c
index 4ea62a1..7b79eca 100644
--- a/drivers/media/rc/ir-jvc-decoder.c
+++ b/drivers/media/rc/ir-jvc-decoder.c
@@ -140,7 +140,7 @@ again:
 			scancode = (bitrev8((data->bits >> 8) & 0xff) << 8) |
 				   (bitrev8((data->bits >> 0) & 0xff) << 0);
 			IR_dprintk(1, "JVC scancode 0x%04x\n", scancode);
-			rc_keydown(dev, scancode, data->toggle);
+			rc_keydown(dev, RC_TYPE_JVC, scancode, data->toggle);
 			data->first = false;
 			data->old_bits = data->bits;
 		} else if (data->bits == data->old_bits) {
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 9de1791..735a509 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -192,7 +192,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		if (data->is_nec_x)
 			data->necx_repeat = true;
 
-		rc_keydown(dev, scancode, 0);
+		rc_keydown(dev, RC_TYPE_NEC, scancode, 0);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index 4295d9b..3d38cbc 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -51,6 +51,7 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	struct rc5_dec *data = &dev->raw->rc5;
 	u8 toggle;
 	u32 scancode;
+	enum rc_type protocol;
 
 	if (!rc_protocols_enabled(dev, RC_BIT_RC5 | RC_BIT_RC5X))
 		return 0;
@@ -138,6 +139,7 @@ again:
 			toggle   = (data->bits & 0x20000) ? 1 : 0;
 			command += (data->bits & 0x01000) ? 0 : 0x40;
 			scancode = system << 16 | command << 8 | xdata;
+			protocol = RC_TYPE_RC5X;
 
 			IR_dprintk(1, "RC5X scancode 0x%06x (toggle: %u)\n",
 				   scancode, toggle);
@@ -154,12 +156,13 @@ again:
 			toggle   = (data->bits & 0x00800) ? 1 : 0;
 			command += (data->bits & 0x01000) ? 0 : 0x40;
 			scancode = system << 8 | command;
+			protocol = RC_TYPE_RC5;
 
 			IR_dprintk(1, "RC5 scancode 0x%04x (toggle: %u)\n",
 				   scancode, toggle);
 		}
 
-		rc_keydown(dev, scancode, toggle);
+		rc_keydown(dev, protocol, scancode, toggle);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
diff --git a/drivers/media/rc/ir-rc5-sz-decoder.c b/drivers/media/rc/ir-rc5-sz-decoder.c
index dc18b74..85c7711 100644
--- a/drivers/media/rc/ir-rc5-sz-decoder.c
+++ b/drivers/media/rc/ir-rc5-sz-decoder.c
@@ -115,7 +115,7 @@ again:
 		IR_dprintk(1, "RC5-sz scancode 0x%04x (toggle: %u)\n",
 			   scancode, toggle);
 
-		rc_keydown(dev, scancode, toggle);
+		rc_keydown(dev, RC_TYPE_RC5_SZ, scancode, toggle);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index cfbd64e..1dc97a7 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -88,6 +88,7 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	struct rc6_dec *data = &dev->raw->rc6;
 	u32 scancode;
 	u8 toggle;
+	enum rc_type protocol;
 
 	if (!rc_protocols_enabled(dev, RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 |
 				  RC_BIT_RC6_6A_24 | RC_BIT_RC6_6A_32 |
@@ -233,9 +234,11 @@ again:
 		case RC6_MODE_0:
 			scancode = data->body;
 			toggle = data->toggle;
+			protocol = RC_TYPE_RC6_0;
 			IR_dprintk(1, "RC6(0) scancode 0x%04x (toggle: %u)\n",
 				   scancode, toggle);
 			break;
+
 		case RC6_MODE_6A:
 			if (data->count > CHAR_BIT * sizeof data->body) {
 				IR_dprintk(1, "RC6 too many (%u) data bits\n",
@@ -244,23 +247,39 @@ again:
 			}
 
 			scancode = data->body;
-			if (data->count == RC6_6A_32_NBITS &&
-					(scancode & RC6_6A_LCC_MASK) == RC6_6A_MCE_CC) {
-				/* MCE RC */
-				toggle = (scancode & RC6_6A_MCE_TOGGLE_MASK) ? 1 : 0;
-				scancode &= ~RC6_6A_MCE_TOGGLE_MASK;
-			} else {
+			switch (data->count) {
+			case 20:
+				protocol = RC_TYPE_RC6_6A_20;
+				toggle = 0;
+				break;
+			case 24:
+				protocol = RC_BIT_RC6_6A_24;
 				toggle = 0;
+				break;
+			case 32:
+				if ((scancode & RC6_6A_LCC_MASK) == RC6_6A_MCE_CC) {
+					protocol = RC_TYPE_RC6_MCE;
+					scancode &= ~RC6_6A_MCE_TOGGLE_MASK;
+					toggle = !!(scancode & RC6_6A_MCE_TOGGLE_MASK);
+				} else {
+					protocol = RC_BIT_RC6_6A_32;
+					toggle = 0;
+				}
+				break;
+			default:
+				IR_dprintk(1, "RC6(6A) unsupported length\n");
+				goto out;
 			}
-			IR_dprintk(1, "RC6(6A) scancode 0x%08x (toggle: %u)\n",
-				   scancode, toggle);
+
+			IR_dprintk(1, "RC6(6A) proto 0x%04x, scancode 0x%08x (toggle: %u)\n",
+				   protocol, scancode, toggle);
 			break;
 		default:
 			IR_dprintk(1, "RC6 unknown mode\n");
 			goto out;
 		}
 
-		rc_keydown(dev, scancode, toggle);
+		rc_keydown(dev, protocol, scancode, toggle);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
index eb715f0..5f77022 100644
--- a/drivers/media/rc/ir-sanyo-decoder.c
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -167,7 +167,7 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
 
 		scancode = address << 8 | command;
 		IR_dprintk(1, "SANYO scancode: 0x%06x\n", scancode);
-		rc_keydown(dev, scancode, 0);
+		rc_keydown(dev, RC_TYPE_SANYO, scancode, 0);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
diff --git a/drivers/media/rc/ir-sharp-decoder.c b/drivers/media/rc/ir-sharp-decoder.c
index 66d2039..c8f2519 100644
--- a/drivers/media/rc/ir-sharp-decoder.c
+++ b/drivers/media/rc/ir-sharp-decoder.c
@@ -162,7 +162,7 @@ static int ir_sharp_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		scancode = address << 8 | command;
 		IR_dprintk(1, "Sharp scancode 0x%04x\n", scancode);
 
-		rc_keydown(dev, scancode, 0);
+		rc_keydown(dev, RC_TYPE_SHARP, scancode, 0);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
diff --git a/drivers/media/rc/ir-sony-decoder.c b/drivers/media/rc/ir-sony-decoder.c
index 599c19a..f485f9fe 100644
--- a/drivers/media/rc/ir-sony-decoder.c
+++ b/drivers/media/rc/ir-sony-decoder.c
@@ -42,6 +42,7 @@ enum sony_state {
 static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
 	struct sony_dec *data = &dev->raw->sony;
+	enum rc_type protocol;
 	u32 scancode;
 	u8 device, subdevice, function;
 
@@ -131,6 +132,7 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			device    = bitrev8((data->bits <<  3) & 0xF8);
 			subdevice = 0;
 			function  = bitrev8((data->bits >>  4) & 0xFE);
+			protocol = RC_TYPE_SONY12;
 			break;
 		case 15:
 			if (!rc_protocols_enabled(dev, RC_BIT_SONY15)) {
@@ -140,6 +142,7 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			device    = bitrev8((data->bits >>  0) & 0xFF);
 			subdevice = 0;
 			function  = bitrev8((data->bits >>  7) & 0xFE);
+			protocol = RC_TYPE_SONY15;
 			break;
 		case 20:
 			if (!rc_protocols_enabled(dev, RC_BIT_SONY20)) {
@@ -149,6 +152,7 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			device    = bitrev8((data->bits >>  5) & 0xF8);
 			subdevice = bitrev8((data->bits >>  0) & 0xFF);
 			function  = bitrev8((data->bits >> 12) & 0xFE);
+			protocol = RC_TYPE_SONY20;
 			break;
 		default:
 			IR_dprintk(1, "Sony invalid bitcount %u\n", data->count);
@@ -157,7 +161,7 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 
 		scancode = device << 16 | subdevice << 8 | function;
 		IR_dprintk(1, "Sony(%u) scancode 0x%05x\n", data->count, scancode);
-		rc_keydown(dev, scancode, 0);
+		rc_keydown(dev, protocol, scancode, 0);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 99697aa..c0bfd50 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -623,6 +623,7 @@ EXPORT_SYMBOL_GPL(rc_repeat);
 /**
  * ir_do_keydown() - internal function to process a keypress
  * @dev:	the struct rc_dev descriptor of the device
+ * @protocol:	the protocol of the keypress
  * @scancode:   the scancode of the keypress
  * @keycode:    the keycode of the keypress
  * @toggle:     the toggle value of the keypress
@@ -630,13 +631,14 @@ EXPORT_SYMBOL_GPL(rc_repeat);
  * This function is used internally to register a keypress, it must be
  * called with keylock held.
  */
-static void ir_do_keydown(struct rc_dev *dev, int scancode,
-			  u32 keycode, u8 toggle)
+static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
+			  u32 scancode, u32 keycode, u8 toggle)
 {
 	struct rc_scancode_filter *filter;
-	bool new_event = !dev->keypressed ||
-			 dev->last_scancode != scancode ||
-			 dev->last_toggle != toggle;
+	bool new_event = (!dev->keypressed		 ||
+			  dev->last_protocol != protocol ||
+			  dev->last_scancode != scancode ||
+			  dev->last_toggle   != toggle);
 
 	if (new_event && dev->keypressed)
 		ir_do_keyup(dev, false);
@@ -651,13 +653,14 @@ static void ir_do_keydown(struct rc_dev *dev, int scancode,
 	if (new_event && keycode != KEY_RESERVED) {
 		/* Register a keypress */
 		dev->keypressed = true;
+		dev->last_protocol = protocol;
 		dev->last_scancode = scancode;
 		dev->last_toggle = toggle;
 		dev->last_keycode = keycode;
 
 		IR_dprintk(1, "%s: key down event, "
-			   "key 0x%04x, scancode 0x%04x\n",
-			   dev->input_name, keycode, scancode);
+			   "key 0x%04x, protocol 0x%04x, scancode 0x%08x\n",
+			   dev->input_name, keycode, protocol, scancode);
 		input_report_key(dev->input_dev, keycode, 1);
 
 		led_trigger_event(led_feedback, LED_FULL);
@@ -669,20 +672,21 @@ static void ir_do_keydown(struct rc_dev *dev, int scancode,
 /**
  * rc_keydown() - generates input event for a key press
  * @dev:	the struct rc_dev descriptor of the device
- * @scancode:   the scancode that we're seeking
+ * @protocol:	the protocol for the keypress
+ * @scancode:	the scancode for the keypress
  * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
  *              support toggle values, this should be set to zero)
  *
  * This routine is used to signal that a key has been pressed on the
  * remote control.
  */
-void rc_keydown(struct rc_dev *dev, int scancode, u8 toggle)
+void rc_keydown(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 toggle)
 {
 	unsigned long flags;
 	u32 keycode = rc_g_keycode_from_table(dev, scancode);
 
 	spin_lock_irqsave(&dev->keylock, flags);
-	ir_do_keydown(dev, scancode, keycode, toggle);
+	ir_do_keydown(dev, protocol, scancode, keycode, toggle);
 
 	if (dev->keypressed) {
 		dev->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
@@ -696,20 +700,22 @@ EXPORT_SYMBOL_GPL(rc_keydown);
  * rc_keydown_notimeout() - generates input event for a key press without
  *                          an automatic keyup event at a later time
  * @dev:	the struct rc_dev descriptor of the device
- * @scancode:   the scancode that we're seeking
+ * @protocol:	the protocol for the keypress
+ * @scancode:	the scancode for the keypress
  * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
  *              support toggle values, this should be set to zero)
  *
  * This routine is used to signal that a key has been pressed on the
  * remote control. The driver must manually call rc_keyup() at a later stage.
  */
-void rc_keydown_notimeout(struct rc_dev *dev, int scancode, u8 toggle)
+void rc_keydown_notimeout(struct rc_dev *dev, enum rc_type protocol,
+			  u32 scancode, u8 toggle)
 {
 	unsigned long flags;
 	u32 keycode = rc_g_keycode_from_table(dev, scancode);
 
 	spin_lock_irqsave(&dev->keylock, flags);
-	ir_do_keydown(dev, scancode, keycode, toggle);
+	ir_do_keydown(dev, protocol, scancode, keycode, toggle);
 	spin_unlock_irqrestore(&dev->keylock, flags);
 }
 EXPORT_SYMBOL_GPL(rc_keydown_notimeout);
diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index da47d23..5ca738a 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -1213,7 +1213,7 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 	if ((state->rc_repeat != buf[6] || buf[0]) &&
 			!memcmp(&buf[12], state->rc_last, 4)) {
 		dev_dbg(&d->udev->dev, "%s: key repeated\n", __func__);
-		rc_keydown(d->rc_dev, state->rc_keycode, 0);
+		rc_repeat(d->rc_dev);
 		state->rc_repeat = buf[6];
 		return ret;
 	}
@@ -1233,18 +1233,22 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 		if (buf[14] == (u8) ~buf[15]) {
 			if (buf[12] == (u8) ~buf[13]) {
 				/* NEC */
-				state->rc_keycode = buf[12] << 8 | buf[14];
+				state->rc_keycode = RC_SCANCODE_NEC(buf[12],
+								    buf[14]);
 			} else {
 				/* NEC extended*/
-				state->rc_keycode = buf[12] << 16 |
-					buf[13] << 8 | buf[14];
+				state->rc_keycode = RC_SCANCODE_NECX(buf[12] << 8 |
+								     buf[13],
+								     buf[14]);
 			}
 		} else {
 			/* 32 bit NEC */
-			state->rc_keycode = buf[12] << 24 | buf[13] << 16 |
-					buf[14] << 8 | buf[15];
+			state->rc_keycode = RC_SCANCODE_NEC32(buf[12] << 24 |
+							      buf[13] << 16 |
+							      buf[14] << 8  |
+							      buf[15]);
 		}
-		rc_keydown(d->rc_dev, state->rc_keycode, 0);
+		rc_keydown(d->rc_dev, RC_TYPE_NEC, state->rc_keycode, 0);
 	} else {
 		dev_dbg(&d->udev->dev, "%s: no key press\n", __func__);
 		/* Invalidate last keypress */
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 021e4d3..3bfba13 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1287,19 +1287,20 @@ static int af9035_rc_query(struct dvb_usb_device *d)
 	if ((buf[2] + buf[3]) == 0xff) {
 		if ((buf[0] + buf[1]) == 0xff) {
 			/* NEC standard 16bit */
-			key = buf[0] << 8 | buf[2];
+			key = RC_SCANCODE_NEC(buf[0], buf[2]);
 		} else {
 			/* NEC extended 24bit */
-			key = buf[0] << 16 | buf[1] << 8 | buf[2];
+			key = RC_SCANCODE_NECX(buf[0] << 8 | buf[1], buf[2]);
 		}
 	} else {
 		/* NEC full code 32bit */
-		key = buf[0] << 24 | buf[1] << 16 | buf[2] << 8 | buf[3];
+		key = RC_SCANCODE_NEC32(buf[0] << 24 | buf[1] << 16 |
+					buf[2] << 8  | buf[3]);
 	}
 
 	dev_dbg(&d->udev->dev, "%s: %*ph\n", __func__, 4, buf);
 
-	rc_keydown(d->rc_dev, key, 0);
+	rc_keydown(d->rc_dev, RC_TYPE_NEC, key, 0);
 
 	return 0;
 
diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
index eeab79b..e4a2382 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.c
+++ b/drivers/media/usb/dvb-usb-v2/anysee.c
@@ -1038,7 +1038,8 @@ static int anysee_rc_query(struct dvb_usb_device *d)
 	if (ircode[0]) {
 		dev_dbg(&d->udev->dev, "%s: key pressed %02x\n", __func__,
 				ircode[1]);
-		rc_keydown(d->rc_dev, 0x08 << 8 | ircode[1], 0);
+		rc_keydown(d->rc_dev, RC_TYPE_NEC,
+			   RC_SCANCODE_NEC(0x08, ircode[1]), 0);
 	}
 
 	return 0;
diff --git a/drivers/media/usb/dvb-usb-v2/az6007.c b/drivers/media/usb/dvb-usb-v2/az6007.c
index c3c4b98..935dbaa 100644
--- a/drivers/media/usb/dvb-usb-v2/az6007.c
+++ b/drivers/media/usb/dvb-usb-v2/az6007.c
@@ -207,24 +207,27 @@ static int az6007_streaming_ctrl(struct dvb_frontend *fe, int onoff)
 static int az6007_rc_query(struct dvb_usb_device *d)
 {
 	struct az6007_device_state *st = d_to_priv(d);
-	unsigned code = 0;
+	unsigned code;
 
 	az6007_read(d, AZ6007_READ_IR, 0, 0, st->data, 10);
 
 	if (st->data[1] == 0x44)
 		return 0;
 
-	if ((st->data[1] ^ st->data[2]) == 0xff)
-		code = st->data[1];
-	else
-		code = st->data[1] << 8 | st->data[2];
-
-	if ((st->data[3] ^ st->data[4]) == 0xff)
-		code = code << 8 | st->data[3];
-	else
-		code = code << 16 | st->data[3] << 8 | st->data[4];
+	if ((st->data[3] ^ st->data[4]) == 0xff) {
+		if ((st->data[1] ^ st->data[2]) == 0xff)
+			code = RC_SCANCODE_NEC(st->data[1], st->data[3]);
+		else
+			code = RC_SCANCODE_NECX(st->data[1] << 8 | st->data[2],
+						st->data[3]);
+	} else {
+		code = RC_SCANCODE_NEC32(st->data[1] << 24 |
+					 st->data[2] << 16 |
+					 st->data[3] << 8  |
+					 st->data[4]);
+	}
 
-	rc_keydown(d->rc_dev, code, st->data[5]);
+	rc_keydown(d->rc_dev, RC_TYPE_NEC, code, st->data[5]);
 
 	return 0;
 }
diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index f674dc0..31f31fc 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -287,14 +287,13 @@ static void lme2510_int_response(struct urb *lme_urb)
 		case 0xaa:
 			debug_data_snipet(1, "INT Remote data snipet", ibuf);
 			if ((ibuf[4] + ibuf[5]) == 0xff) {
-				key = ibuf[5];
-				key += (ibuf[3] > 0)
-					? (ibuf[3] ^ 0xff) << 8 : 0;
-				key += (ibuf[2] ^ 0xff) << 16;
+				key = RC_SCANCODE_NECX((ibuf[2] ^ 0xff) << 8 |
+						       (ibuf[3] > 0) ? (ibuf[3] ^ 0xff) : 0,
+						       ibuf[5]);
 				deb_info(1, "INT Key =%08x", key);
 				if (adap_to_d(adap)->rc_dev != NULL)
 					rc_keydown(adap_to_d(adap)->rc_dev,
-						key, 0);
+						   RC_TYPE_NEC, key, 0);
 			}
 			break;
 		case 0xbb:
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index c83c16c..574f4ee 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1249,19 +1249,19 @@ static int rtl2831u_rc_query(struct dvb_usb_device *d)
 		if (buf[2] == (u8) ~buf[3]) {
 			if (buf[0] == (u8) ~buf[1]) {
 				/* NEC standard (16 bit) */
-				rc_code = buf[0] << 8 | buf[2];
+				rc_code = RC_SCANCODE_NEC(buf[0], buf[2]);
 			} else {
 				/* NEC extended (24 bit) */
-				rc_code = buf[0] << 16 |
-						buf[1] << 8 | buf[2];
+				rc_code = RC_SCANCODE_NECX(buf[0] << 8 | buf[1],
+							   buf[2]);
 			}
 		} else {
 			/* NEC full (32 bit) */
-			rc_code = buf[0] << 24 | buf[1] << 16 |
-					buf[2] << 8 | buf[3];
+			rc_code = RC_SCANCODE_NEC32(buf[0] << 24 | buf[1] << 16 |
+						    buf[2] << 8  | buf[3]);
 		}
 
-		rc_keydown(d->rc_dev, rc_code, 0);
+		rc_keydown(d->rc_dev, RC_TYPE_NEC, rc_code, 0);
 
 		ret = rtl28xx_wr_reg(d, SYS_IRRC_SR, 1);
 		if (ret)
diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index bf2a908..6afe7ea 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -674,7 +674,8 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 {
 	struct dvb_usb_device *d = purb->context;
 	struct dib0700_rc_response *poll_reply;
-	u32 uninitialized_var(keycode);
+	enum rc_type protocol;
+	u32 uninitialized_var(scancode);
 	u8 toggle;
 
 	deb_info("%s()\n", __func__);
@@ -707,6 +708,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 
 	switch (d->props.rc.core.protocol) {
 	case RC_BIT_NEC:
+		protocol = RC_TYPE_NEC;
 		toggle = 0;
 
 		/* NEC protocol sends repeat code as 0 0 0 FF */
@@ -719,19 +721,21 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 		if ((poll_reply->system ^ poll_reply->not_system) != 0xff) {
 			deb_data("NEC extended protocol\n");
 			/* NEC extended code - 24 bits */
-			keycode = be16_to_cpu(poll_reply->system16) << 8 | poll_reply->data;
+			scancode = RC_SCANCODE_NECX(be16_to_cpu(poll_reply->system16),
+						    poll_reply->data);
 		} else {
 			deb_data("NEC normal protocol\n");
 			/* normal NEC code - 16 bits */
-			keycode = poll_reply->system << 8 | poll_reply->data;
+			scancode = RC_SCANCODE_NEC(poll_reply->system,
+						   poll_reply->data);
 		}
 
 		break;
 	default:
 		deb_data("RC5 protocol\n");
-		/* RC5 Protocol */
+		protocol = RC_TYPE_RC5;
 		toggle = poll_reply->report_id;
-		keycode = poll_reply->system << 8 | poll_reply->data;
+		scancode = RC_SCANCODE_RC5(poll_reply->system, poll_reply->data);
 
 		break;
 	}
@@ -744,7 +748,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 		goto resubmit;
 	}
 
-	rc_keydown(d->rc_dev, keycode, toggle);
+	rc_keydown(d->rc_dev, protocol, scancode, toggle);
 
 resubmit:
 	/* Clean the buffer before we requeue */
diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index 829323e..6a70223 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -489,7 +489,8 @@ static u8 rc_request[] = { REQUEST_POLL_RC, 0 };
 static int dib0700_rc_query_old_firmware(struct dvb_usb_device *d)
 {
 	u8 key[4];
-	u32 keycode;
+	enum rc_type protocol;
+	u32 scancode;
 	u8 toggle;
 	int i;
 	struct dib0700_state *st = d->priv;
@@ -516,28 +517,29 @@ static int dib0700_rc_query_old_firmware(struct dvb_usb_device *d)
 
 	dib0700_rc_setup(d); /* reset ir sensor data to prevent false events */
 
-	d->last_event = 0;
 	switch (d->props.rc.core.protocol) {
 	case RC_BIT_NEC:
 		/* NEC protocol sends repeat code as 0 0 0 FF */
 		if ((key[3-2] == 0x00) && (key[3-3] == 0x00) &&
-		    (key[3] == 0xff))
-			keycode = d->last_event;
-		else {
-			keycode = key[3-2] << 8 | key[3-3];
-			d->last_event = keycode;
+		    (key[3] == 0xff)) {
+			rc_repeat(d->rc_dev);
+			return 0;
 		}
 
-		rc_keydown(d->rc_dev, keycode, 0);
+		protocol = RC_TYPE_NEC;
+		scancode = RC_SCANCODE_NEC(key[3-2], key[3-3]);
+		toggle = 0;
 		break;
+
 	default:
 		/* RC-5 protocol changes toggle bit on new keypress */
-		keycode = key[3-2] << 8 | key[3-3];
+		protocol = RC_TYPE_RC5;
+		scancode = RC_SCANCODE_RC5(key[3-2], key[3-3]);
 		toggle = key[3-1];
-		rc_keydown(d->rc_dev, keycode, toggle);
-
 		break;
 	}
+
+	rc_keydown(d->rc_dev, protocol, scancode, toggle);
 	return 0;
 }
 
diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index ae0f56a..8f22d79 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -1482,7 +1482,7 @@ static int dw2102_rc_query(struct dvb_usb_device *d)
 		if (msg.buf[0] != 0xff) {
 			deb_rc("%s: rc code: %x, %x\n",
 					__func__, key[0], key[1]);
-			rc_keydown(d->rc_dev, key[0], 1);
+			rc_keydown(d->rc_dev, RC_TYPE_UNKNOWN, key[0], 0);
 		}
 	}
 
@@ -1503,7 +1503,7 @@ static int prof_rc_query(struct dvb_usb_device *d)
 		if (msg.buf[0] != 0xff) {
 			deb_rc("%s: rc code: %x, %x\n",
 					__func__, key[0], key[1]);
-			rc_keydown(d->rc_dev, key[0]^0xff, 1);
+			rc_keydown(d->rc_dev, RC_TYPE_UNKNOWN, key[0]^0xff, 0);
 		}
 	}
 
@@ -1524,7 +1524,8 @@ static int su3000_rc_query(struct dvb_usb_device *d)
 		if (msg.buf[0] != 0xff) {
 			deb_rc("%s: rc code: %x, %x\n",
 					__func__, key[0], key[1]);
-			rc_keydown(d->rc_dev, key[1] << 8 | key[0], 1);
+			rc_keydown(d->rc_dev, RC_TYPE_RC5,
+				   RC_SCANCODE_RC5(key[1], key[0]), 0);
 		}
 	}
 
diff --git a/drivers/media/usb/dvb-usb/m920x.c b/drivers/media/usb/dvb-usb/m920x.c
index 0306cb7..abf8ab2 100644
--- a/drivers/media/usb/dvb-usb/m920x.c
+++ b/drivers/media/usb/dvb-usb/m920x.c
@@ -245,7 +245,7 @@ static int m920x_rc_core_query(struct dvb_usb_device *d)
 	else if (state == REMOTE_KEY_REPEAT)
 		rc_repeat(d->rc_dev);
 	else
-		rc_keydown(d->rc_dev, rc_state[1], 0);
+		rc_keydown(d->rc_dev, RC_TYPE_UNKNOWN, rc_state[1], 0);
 
 out:
 	kfree(rc_state);
diff --git a/drivers/media/usb/dvb-usb/pctv452e.c b/drivers/media/usb/dvb-usb/pctv452e.c
index 449a996..bdfe896 100644
--- a/drivers/media/usb/dvb-usb/pctv452e.c
+++ b/drivers/media/usb/dvb-usb/pctv452e.c
@@ -565,12 +565,12 @@ static int pctv452e_rc_query(struct dvb_usb_device *d)
 
 	if ((rx[3] == 9) &&  (rx[12] & 0x01)) {
 		/* got a "press" event */
-		state->last_rc_key = (rx[7] << 8) | rx[6];
+		state->last_rc_key = RC_SCANCODE_RC5(rx[7], rx[6]);
 		if (debug > 2)
 			info("%s: cmd=0x%02x sys=0x%02x\n",
 				__func__, rx[6], rx[7]);
 
-		rc_keydown(d->rc_dev, state->last_rc_key, 0);
+		rc_keydown(d->rc_dev, RC_TYPE_RC5, state->last_rc_key, 0);
 	} else if (state->last_rc_key) {
 		rc_keyup(d->rc_dev);
 		state->last_rc_key = 0;
@@ -927,7 +927,7 @@ static struct dvb_usb_device_properties pctv452e_properties = {
 
 	.rc.core = {
 		.rc_codes	= RC_MAP_DIB0700_RC5_TABLE,
-		.allowed_protos	= RC_BIT_UNKNOWN,
+		.allowed_protos	= RC_BIT_RC5,
 		.rc_query	= pctv452e_rc_query,
 		.rc_interval	= 100,
 	},
@@ -980,7 +980,7 @@ static struct dvb_usb_device_properties tt_connect_s2_3600_properties = {
 
 	.rc.core = {
 		.rc_codes	= RC_MAP_TT_1500,
-		.allowed_protos	= RC_BIT_UNKNOWN,
+		.allowed_protos	= RC_BIT_RC5,
 		.rc_query	= pctv452e_rc_query,
 		.rc_interval	= 100,
 	},
diff --git a/drivers/media/usb/dvb-usb/ttusb2.c b/drivers/media/usb/dvb-usb/ttusb2.c
index 2ce3d19..f107173 100644
--- a/drivers/media/usb/dvb-usb/ttusb2.c
+++ b/drivers/media/usb/dvb-usb/ttusb2.c
@@ -438,9 +438,9 @@ static int tt3650_rc_query(struct dvb_usb_device *d)
 
 	if (rx[8] & 0x01) {
 		/* got a "press" event */
-		st->last_rc_key = (rx[3] << 8) | rx[2];
+		st->last_rc_key = RC_SCANCODE_RC5(rx[3], rx[2]);
 		deb_info("%s: cmd=0x%02x sys=0x%02x\n", __func__, rx[2], rx[3]);
-		rc_keydown(d->rc_dev, st->last_rc_key, rx[1]);
+		rc_keydown(d->rc_dev, RC_TYPE_RC5, st->last_rc_key, rx[1]);
 	} else if (st->last_rc_key) {
 		rc_keyup(d->rc_dev);
 		st->last_rc_key = 0;
@@ -747,7 +747,7 @@ static struct dvb_usb_device_properties ttusb2_properties_ct3650 = {
 		.rc_interval      = 150, /* Less than IR_KEYPRESS_TIMEOUT */
 		.rc_codes         = RC_MAP_TT_1500,
 		.rc_query         = tt3650_rc_query,
-		.allowed_protos   = RC_BIT_UNKNOWN,
+		.allowed_protos   = RC_BIT_RC5,
 	},
 
 	.num_adapters = 1,
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 56ef49d..014888f 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -27,6 +27,7 @@
 #include <linux/interrupt.h>
 #include <linux/usb.h>
 #include <linux/slab.h>
+#include <linux/bitrev.h>
 
 #include "em28xx.h"
 
@@ -53,6 +54,7 @@ struct em28xx_ir_poll_result {
 	unsigned int toggle_bit:1;
 	unsigned int read_count:7;
 
+	enum rc_type protocol;
 	u32 scancode;
 };
 
@@ -72,7 +74,7 @@ struct em28xx_IR {
 	/* i2c slave address of external device (if used) */
 	u16 i2c_dev_addr;
 
-	int  (*get_key_i2c)(struct i2c_client *, u32 *);
+	int  (*get_key_i2c)(struct i2c_client *ir, enum rc_type *protocol, u32 *scancode);
 	int  (*get_key)(struct em28xx_IR *, struct em28xx_ir_poll_result *);
 };
 
@@ -80,7 +82,8 @@ struct em28xx_IR {
  I2C IR based get keycodes - should be used with ir-kbd-i2c
  **********************************************************/
 
-static int em28xx_get_key_terratec(struct i2c_client *i2c_dev, u32 *ir_key)
+static int em28xx_get_key_terratec(struct i2c_client *i2c_dev,
+				   enum rc_type *protocol, u32 *scancode)
 {
 	unsigned char b;
 
@@ -98,14 +101,15 @@ static int em28xx_get_key_terratec(struct i2c_client *i2c_dev, u32 *ir_key)
 		/* keep old data */
 		return 1;
 
-	*ir_key = b;
+	*protocol = RC_TYPE_UNKNOWN;
+	*scancode = b;
 	return 1;
 }
 
-static int em28xx_get_key_em_haup(struct i2c_client *i2c_dev, u32 *ir_key)
+static int em28xx_get_key_em_haup(struct i2c_client *i2c_dev,
+				  enum rc_type *protocol, u32 *scancode)
 {
 	unsigned char buf[2];
-	u16 code;
 	int size;
 
 	/* poll IR chip */
@@ -127,26 +131,13 @@ static int em28xx_get_key_em_haup(struct i2c_client *i2c_dev, u32 *ir_key)
 	 * So, the code translation is not complete. Yet, it is enough to
 	 * work with the provided RC5 IR.
 	 */
-	code =
-		 ((buf[0] & 0x01) ? 0x0020 : 0) | /* 		0010 0000 */
-		 ((buf[0] & 0x02) ? 0x0010 : 0) | /* 		0001 0000 */
-		 ((buf[0] & 0x04) ? 0x0008 : 0) | /* 		0000 1000 */
-		 ((buf[0] & 0x08) ? 0x0004 : 0) | /* 		0000 0100 */
-		 ((buf[0] & 0x10) ? 0x0002 : 0) | /* 		0000 0010 */
-		 ((buf[0] & 0x20) ? 0x0001 : 0) | /* 		0000 0001 */
-		 ((buf[1] & 0x08) ? 0x1000 : 0) | /* 0001 0000		  */
-		 ((buf[1] & 0x10) ? 0x0800 : 0) | /* 0000 1000		  */
-		 ((buf[1] & 0x20) ? 0x0400 : 0) | /* 0000 0100		  */
-		 ((buf[1] & 0x40) ? 0x0200 : 0) | /* 0000 0010		  */
-		 ((buf[1] & 0x80) ? 0x0100 : 0);  /* 0000 0001		  */
-
-	/* return key */
-	*ir_key = code;
+	*protocol = RC_TYPE_RC5;
+	*scancode = (bitrev8(buf[1]) & 0x1f) << 8 | bitrev8(buf[0]) >> 2;
 	return 1;
 }
 
 static int em28xx_get_key_pinnacle_usb_grey(struct i2c_client *i2c_dev,
-					    u32 *ir_key)
+					    enum rc_type *protocol, u32 *scancode)
 {
 	unsigned char buf[3];
 
@@ -158,13 +149,13 @@ static int em28xx_get_key_pinnacle_usb_grey(struct i2c_client *i2c_dev,
 	if (buf[0] != 0x00)
 		return 0;
 
-	*ir_key = buf[2]&0x3f;
-
+	*protocol = RC_TYPE_UNKNOWN;
+	*scancode = buf[2] & 0x3f;
 	return 1;
 }
 
 static int em28xx_get_key_winfast_usbii_deluxe(struct i2c_client *i2c_dev,
-					       u32 *ir_key)
+					       enum rc_type *protocol, u32 *scancode)
 {
 	unsigned char subaddr, keydetect, key;
 
@@ -184,7 +175,8 @@ static int em28xx_get_key_winfast_usbii_deluxe(struct i2c_client *i2c_dev,
 	if (key == 0x00)
 		return 0;
 
-	*ir_key = key;
+	*protocol = RC_TYPE_UNKNOWN;
+	*scancode = key;
 	return 1;
 }
 
@@ -215,7 +207,22 @@ static int default_polling_getkey(struct em28xx_IR *ir,
 	poll_result->read_count = (msg[0] & 0x7f);
 
 	/* Remote Control Address/Data (Regs 0x46/0x47) */
-	poll_result->scancode = msg[1] << 8 | msg[2];
+	switch (ir->rc_type) {
+	case RC_BIT_RC5:
+		poll_result->protocol = RC_TYPE_RC5;
+		poll_result->scancode = RC_SCANCODE_RC5(msg[1], msg[2]);
+		break;
+
+	case RC_BIT_NEC:
+		poll_result->protocol = RC_TYPE_NEC;
+		poll_result->scancode = RC_SCANCODE_NEC(msg[1], msg[2]);
+		break;
+
+	default:
+		poll_result->protocol = RC_TYPE_UNKNOWN;
+		poll_result->scancode = msg[1] << 8 | msg[2];
+		break;
+	}
 
 	return 0;
 }
@@ -247,25 +254,32 @@ static int em2874_polling_getkey(struct em28xx_IR *ir,
 	 */
 	switch (ir->rc_type) {
 	case RC_BIT_RC5:
-		poll_result->scancode = msg[1] << 8 | msg[2];
+		poll_result->protocol = RC_TYPE_RC5;
+		poll_result->scancode = RC_SCANCODE_RC5(msg[1], msg[2]);
 		break;
+
 	case RC_BIT_NEC:
+		poll_result->protocol = RC_TYPE_RC5;
+		poll_result->scancode = msg[1] << 8 | msg[2];
 		if ((msg[3] ^ msg[4]) != 0xff)		/* 32 bits NEC */
-			poll_result->scancode = (msg[1] << 24) |
-						(msg[2] << 16) |
-						(msg[3] << 8)  |
-						 msg[4];
+			poll_result->scancode = RC_SCANCODE_NEC32((msg[1] << 24) |
+								  (msg[2] << 16) |
+								  (msg[3] << 8)  |
+								  (msg[4]));
 		else if ((msg[1] ^ msg[2]) != 0xff)	/* 24 bits NEC */
-			poll_result->scancode = (msg[1] << 16) |
-						(msg[2] << 8)  |
-						 msg[3];
+			poll_result->scancode = RC_SCANCODE_NECX(msg[1] << 8 |
+								 msg[2], msg[3]); 
 		else					/* Normal NEC */
-			poll_result->scancode = msg[1] << 8 | msg[3];
+			poll_result->scancode = RC_SCANCODE_NEC(msg[1], msg[3]);
 		break;
+
 	case RC_BIT_RC6_0:
-		poll_result->scancode = msg[1] << 8 | msg[2];
+		poll_result->protocol = RC_TYPE_RC6_0;
+		poll_result->scancode = RC_SCANCODE_RC6_0(msg[1], msg[2]);
 		break;
+
 	default:
+		poll_result->protocol = RC_TYPE_UNKNOWN;
 		poll_result->scancode = (msg[1] << 24) | (msg[2] << 16) |
 					(msg[3] << 8)  | msg[4];
 		break;
@@ -281,22 +295,24 @@ static int em2874_polling_getkey(struct em28xx_IR *ir,
 static int em28xx_i2c_ir_handle_key(struct em28xx_IR *ir)
 {
 	struct em28xx *dev = ir->dev;
-	static u32 ir_key;
+	static u32 scancode;
+	enum rc_type protocol;
 	int rc;
 	struct i2c_client client;
 
 	client.adapter = &ir->dev->i2c_adap[dev->def_i2c_bus];
 	client.addr = ir->i2c_dev_addr;
 
-	rc = ir->get_key_i2c(&client, &ir_key);
+	rc = ir->get_key_i2c(&client, &protocol, &scancode);
 	if (rc < 0) {
 		dprintk("ir->get_key_i2c() failed: %d\n", rc);
 		return rc;
 	}
 
 	if (rc) {
-		dprintk("%s: keycode = 0x%04x\n", __func__, ir_key);
-		rc_keydown(ir->rc, ir_key, 0);
+		dprintk("%s: proto = 0x%04x, scancode = 0x%04x\n",
+			__func__, protocol, scancode);
+		rc_keydown(ir->rc, protocol, scancode, 0);
 	}
 	return 0;
 }
@@ -319,10 +335,12 @@ static void em28xx_ir_handle_key(struct em28xx_IR *ir)
 			poll_result.scancode);
 		if (ir->full_code)
 			rc_keydown(ir->rc,
+				   poll_result.protocol,
 				   poll_result.scancode,
 				   poll_result.toggle_bit);
 		else
 			rc_keydown(ir->rc,
+				   RC_TYPE_UNKNOWN,
 				   poll_result.scancode & 0xff,
 				   poll_result.toggle_bit);
 
diff --git a/drivers/media/usb/tm6000/tm6000-input.c b/drivers/media/usb/tm6000/tm6000-input.c
index d1af543..676c0232 100644
--- a/drivers/media/usb/tm6000/tm6000-input.c
+++ b/drivers/media/usb/tm6000/tm6000-input.c
@@ -162,11 +162,42 @@ static int tm6000_ir_config(struct tm6000_IR *ir)
 	return 0;
 }
 
+static void tm6000_ir_keydown(struct tm6000_IR *ir,
+			      const char *buf, unsigned int len)
+{
+	u8 device, command;
+	u32 scancode;
+	enum rc_type protocol;
+
+	if (len < 1)
+		return;
+
+	command = buf[0];
+	device = (len > 1 ? buf[1] : 0x0);
+	switch (ir->rc_type) {
+	case RC_BIT_RC5:
+		protocol = RC_TYPE_RC5;
+		scancode = RC_SCANCODE_RC5(device, command);
+		break;
+	case RC_BIT_NEC:
+		protocol = RC_TYPE_NEC;
+		scancode = RC_SCANCODE_NEC(device, command);
+		break;
+	default:
+		protocol = RC_TYPE_OTHER;
+		scancode = RC_SCANCODE_OTHER(device << 8 | command);
+		break;
+	}
+
+	dprintk(1, "%s, protocol: 0x%04x, scancode: 0x%08x\n",
+		__func__, protocol, scancode);
+	rc_keydown(ir->rc, protocol, scancode, 0);
+}
+
 static void tm6000_ir_urb_received(struct urb *urb)
 {
 	struct tm6000_core *dev = urb->context;
 	struct tm6000_IR *ir = dev->ir;
-	struct tm6000_ir_poll_result poll_result;
 	char *buf;
 
 	dprintk(2, "%s\n",__func__);
@@ -184,12 +215,7 @@ static void tm6000_ir_urb_received(struct urb *urb)
 			       DUMP_PREFIX_OFFSET,16, 1,
 			       buf, urb->actual_length, false);
 
-	poll_result.rc_data = buf[0];
-	if (urb->actual_length > 1)
-		poll_result.rc_data |= buf[1] << 8;
-
-	dprintk(1, "%s, scancode: 0x%04x\n",__func__, poll_result.rc_data);
-	rc_keydown(ir->rc, poll_result.rc_data, 0);
+	tm6000_ir_keydown(ir, urb->transfer_buffer, urb->actual_length);
 
 	usb_submit_urb(urb, GFP_ATOMIC);
 	/*
@@ -204,7 +230,6 @@ static void tm6000_ir_handle_key(struct work_struct *work)
 {
 	struct tm6000_IR *ir = container_of(work, struct tm6000_IR, work.work);
 	struct tm6000_core *dev = ir->dev;
-	struct tm6000_ir_poll_result poll_result;
 	int rc;
 	u8 buf[2];
 
@@ -219,13 +244,8 @@ static void tm6000_ir_handle_key(struct work_struct *work)
 	if (rc < 0)
 		return;
 
-	if (rc > 1)
-		poll_result.rc_data = buf[0] | buf[1] << 8;
-	else
-		poll_result.rc_data = buf[0];
-
 	/* Check if something was read */
-	if ((poll_result.rc_data & 0xff) == 0xff) {
+	if ((buf[0] & 0xff) == 0xff) {
 		if (!ir->pwled) {
 			tm6000_flash_led(dev, 1);
 			ir->pwled = 1;
@@ -233,8 +253,7 @@ static void tm6000_ir_handle_key(struct work_struct *work)
 		return;
 	}
 
-	dprintk(1, "%s, scancode: 0x%04x\n",__func__, poll_result.rc_data);
-	rc_keydown(ir->rc, poll_result.rc_data, 0);
+	tm6000_ir_keydown(ir, buf, rc);
 	tm6000_flash_led(dev, 0);
 	ir->pwled = 0;
 
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 0b9f890..dbbe63e 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -88,6 +88,7 @@ enum rc_filter_type {
  * @keyup_jiffies: time (in jiffies) when the current keypress should be released
  * @timer_keyup: timer for releasing a keypress
  * @last_keycode: keycode of last keypress
+ * @last_protocol: protocol of last keypress
  * @last_scancode: scancode of last keypress
  * @last_toggle: toggle value of last command
  * @timeout: optional time after which device stops sending data
@@ -138,6 +139,7 @@ struct rc_dev {
 	unsigned long			keyup_jiffies;
 	struct timer_list		timer_keyup;
 	u32				last_keycode;
+	enum rc_type			last_protocol;
 	u32				last_scancode;
 	u8				last_toggle;
 	u32				timeout;
@@ -217,8 +219,8 @@ int rc_open(struct rc_dev *rdev);
 void rc_close(struct rc_dev *rdev);
 
 void rc_repeat(struct rc_dev *dev);
-void rc_keydown(struct rc_dev *dev, int scancode, u8 toggle);
-void rc_keydown_notimeout(struct rc_dev *dev, int scancode, u8 toggle);
+void rc_keydown(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 toggle);
+void rc_keydown_notimeout(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 toggle);
 void rc_keyup(struct rc_dev *dev);
 u32 rc_g_keycode_from_table(struct rc_dev *dev, u32 scancode);
 

