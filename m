Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40266 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681AbaDCXb1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:31:27 -0400
Subject: [PATCH 02/49] rc-core: improve ir-kbd-i2c get_key functions
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:31:25 +0200
Message-ID: <20140403233125.27099.13731.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The arguments used for ir-kbd-i2c's get_key() functions are not
really suited for rc-core and the ir_raw/ir_key distinction is
just confusing.

Convert all of them to return a protocol/scancode/toggle triple instead.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/i2c/ir-kbd-i2c.c            |   90 +++++++++++++++--------------
 drivers/media/pci/bt8xx/bttv-input.c      |    8 ++-
 drivers/media/pci/cx88/cx88-input.c       |    8 ++-
 drivers/media/pci/ivtv/ivtv-i2c.c         |    9 ++-
 drivers/media/pci/saa7134/saa7134-input.c |   76 +++++++++++++++---------
 drivers/media/usb/cx231xx/cx231xx-input.c |   20 ++----
 include/media/ir-kbd-i2c.h                |    6 +-
 include/media/rc-map.h                    |   10 +++
 8 files changed, 127 insertions(+), 100 deletions(-)

diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index c8fe135..143cb2b 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -62,8 +62,8 @@ module_param(debug, int, 0644);    /* debug level (0,1,2) */
 
 /* ----------------------------------------------------------------------- */
 
-static int get_key_haup_common(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw,
-			       int size, int offset)
+static int get_key_haup_common(struct IR_i2c *ir, enum rc_type *protocol,
+			       u32 *scancode, u8 *ptoggle, int size, int offset)
 {
 	unsigned char buf[6];
 	int start, range, toggle, dev, code, ircode;
@@ -86,19 +86,10 @@ static int get_key_haup_common(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw,
 	if (!start)
 		/* no key pressed */
 		return 0;
-	/*
-	 * Hauppauge remotes (black/silver) always use
-	 * specific device ids. If we do not filter the
-	 * device ids then messages destined for devices
-	 * such as TVs (id=0) will get through causing
-	 * mis-fired events.
-	 *
-	 * We also filter out invalid key presses which
-	 * produce annoying debug log entries.
-	 */
-	ircode= (start << 12) | (toggle << 11) | (dev << 6) | code;
-	if ((ircode & 0x1fff)==0x1fff)
-		/* invalid key press */
+
+	/* filter out invalid key presses */
+	ircode = (start << 12) | (toggle << 11) | (dev << 6) | code;
+	if ((ircode & 0x1fff) == 0x1fff)
 		return 0;
 
 	if (!range)
@@ -107,18 +98,20 @@ static int get_key_haup_common(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw,
 	dprintk(1,"ir hauppauge (rc5): s%d r%d t%d dev=%d code=%d\n",
 		start, range, toggle, dev, code);
 
-	/* return key */
-	*ir_key = (dev << 8) | code;
-	*ir_raw = ircode;
+	*protocol = RC_TYPE_RC5;
+	*scancode = RC_SCANCODE_RC5(dev, code);
+	*ptoggle = toggle;
 	return 1;
 }
 
-static int get_key_haup(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+static int get_key_haup(struct IR_i2c *ir, enum rc_type *protocol,
+			u32 *scancode, u8 *toggle)
 {
-	return get_key_haup_common (ir, ir_key, ir_raw, 3, 0);
+	return get_key_haup_common (ir, protocol, scancode, toggle, 3, 0);
 }
 
-static int get_key_haup_xvr(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+static int get_key_haup_xvr(struct IR_i2c *ir, enum rc_type *protocol,
+			    u32 *scancode, u8 *toggle)
 {
 	int ret;
 	unsigned char buf[1] = { 0 };
@@ -133,10 +126,11 @@ static int get_key_haup_xvr(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 	if (ret != 1)
 		return (ret < 0) ? ret : -EINVAL;
 
-	return get_key_haup_common (ir, ir_key, ir_raw, 6, 3);
+	return get_key_haup_common(ir, protocol, scancode, toggle, 6, 3);
 }
 
-static int get_key_pixelview(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+static int get_key_pixelview(struct IR_i2c *ir, enum rc_type *protocol,
+			     u32 *scancode, u8 *toggle)
 {
 	unsigned char b;
 
@@ -145,12 +139,15 @@ static int get_key_pixelview(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 		dprintk(1,"read error\n");
 		return -EIO;
 	}
-	*ir_key = b;
-	*ir_raw = b;
+
+	*protocol = RC_TYPE_OTHER;
+	*scancode = b;
+	*toggle = 0;
 	return 1;
 }
 
-static int get_key_fusionhdtv(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+static int get_key_fusionhdtv(struct IR_i2c *ir, enum rc_type *protocol,
+			      u32 *scancode, u8 *toggle)
 {
 	unsigned char buf[4];
 
@@ -168,13 +165,14 @@ static int get_key_fusionhdtv(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 	if(buf[0] != 0x1 ||  buf[1] != 0xfe)
 		return 0;
 
-	*ir_key = buf[2];
-	*ir_raw = (buf[2] << 8) | buf[3];
-
+	*protocol = RC_TYPE_UNKNOWN;
+	*scancode = buf[2];
+	*toggle = 0;
 	return 1;
 }
 
-static int get_key_knc1(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+static int get_key_knc1(struct IR_i2c *ir, enum rc_type *protocol,
+			u32 *scancode, u8 *toggle)
 {
 	unsigned char b;
 
@@ -197,13 +195,14 @@ static int get_key_knc1(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 		/* keep old data */
 		return 1;
 
-	*ir_key = b;
-	*ir_raw = b;
+	*protocol = RC_TYPE_UNKNOWN;
+	*scancode = b;
+	*toggle = 0;
 	return 1;
 }
 
-static int get_key_avermedia_cardbus(struct IR_i2c *ir,
-				     u32 *ir_key, u32 *ir_raw)
+static int get_key_avermedia_cardbus(struct IR_i2c *ir, enum rc_type *protocol,
+				     u32 *scancode, u8 *toggle)
 {
 	unsigned char subaddr, key, keygroup;
 	struct i2c_msg msg[] = { { .addr = ir->c->addr, .flags = 0,
@@ -237,12 +236,11 @@ static int get_key_avermedia_cardbus(struct IR_i2c *ir,
 	}
 	key |= (keygroup & 1) << 6;
 
-	*ir_key = key;
-	*ir_raw = key;
-	if (!strcmp(ir->ir_codes, RC_MAP_AVERMEDIA_M733A_RM_K6)) {
-		*ir_key |= keygroup << 8;
-		*ir_raw |= keygroup << 8;
-	}
+	*protocol = RC_TYPE_UNKNOWN;
+	*scancode = key;
+	if (ir->c->addr == 0x41) /* AVerMedia EM78P153 */
+		*scancode |= keygroup << 8;
+	*toggle = 0;
 	return 1;
 }
 
@@ -250,19 +248,21 @@ static int get_key_avermedia_cardbus(struct IR_i2c *ir,
 
 static int ir_key_poll(struct IR_i2c *ir)
 {
-	static u32 ir_key, ir_raw;
+	enum rc_type protocol;
+	u32 scancode;
+	u8 toggle;
 	int rc;
 
 	dprintk(3, "%s\n", __func__);
-	rc = ir->get_key(ir, &ir_key, &ir_raw);
+	rc = ir->get_key(ir, &protocol, &scancode, &toggle);
 	if (rc < 0) {
 		dprintk(2,"error\n");
 		return rc;
 	}
 
 	if (rc) {
-		dprintk(1, "%s: keycode = 0x%04x\n", __func__, ir_key);
-		rc_keydown(ir->rc, ir_key, 0);
+		dprintk(1, "%s: scancode = 0x%08x\n", __func__, scancode);
+		rc_keydown(ir->rc, scancode, toggle);
 	}
 	return 0;
 }
@@ -327,7 +327,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	case 0x6b:
 		name        = "FusionHDTV";
 		ir->get_key = get_key_fusionhdtv;
-		rc_type     = RC_BIT_RC5;
+		rc_type     = RC_BIT_UNKNOWN;
 		ir_codes    = RC_MAP_FUSIONHDTV_MCE;
 		break;
 	case 0x40:
diff --git a/drivers/media/pci/bt8xx/bttv-input.c b/drivers/media/pci/bt8xx/bttv-input.c
index ffc0ee1..e745f5a 100644
--- a/drivers/media/pci/bt8xx/bttv-input.c
+++ b/drivers/media/pci/bt8xx/bttv-input.c
@@ -336,7 +336,8 @@ static void bttv_ir_stop(struct bttv *btv)
  * Get_key functions used by I2C remotes
  */
 
-static int get_key_pv951(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+static int get_key_pv951(struct IR_i2c *ir, enum rc_type *protocol,
+			 u32 *scancode, u8 *toggle)
 {
 	unsigned char b;
 
@@ -363,8 +364,9 @@ static int get_key_pv951(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 	 * 	   the device is bound to the vendor-provided RC.
 	 */
 
-	*ir_key = b;
-	*ir_raw = b;
+	*protocol = RC_TYPE_UNKNOWN;
+	*scancode = b;
+	*toggle = 0;
 	return 1;
 }
 
diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
index f991696..779fc63 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -539,7 +539,8 @@ void cx88_ir_irq(struct cx88_core *core)
 	ir_raw_event_handle(ir->dev);
 }
 
-static int get_key_pvr2000(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+static int get_key_pvr2000(struct IR_i2c *ir, enum rc_type *protocol,
+			   u32 *scancode, u8 *toggle)
 {
 	int flags, code;
 
@@ -563,8 +564,9 @@ static int get_key_pvr2000(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 	dprintk("IR Key/Flags: (0x%02x/0x%02x)\n",
 		   code & 0xff, flags & 0xff);
 
-	*ir_key = code & 0xff;
-	*ir_raw = code;
+	*protocol = RC_TYPE_UNKNOWN;
+	*scancode = code & 0xff;
+	*toggle = 0;
 	return 1;
 }
 
diff --git a/drivers/media/pci/ivtv/ivtv-i2c.c b/drivers/media/pci/ivtv/ivtv-i2c.c
index ceed2d8..1a41ba5 100644
--- a/drivers/media/pci/ivtv/ivtv-i2c.c
+++ b/drivers/media/pci/ivtv/ivtv-i2c.c
@@ -148,7 +148,8 @@ static const char * const hw_devicenames[] = {
 	"ir_video",		/* IVTV_HW_I2C_IR_RX_ADAPTEC */
 };
 
-static int get_key_adaptec(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+static int get_key_adaptec(struct IR_i2c *ir, enum rc_type *protocol,
+			   u32 *scancode, u8 *toggle)
 {
 	unsigned char keybuf[4];
 
@@ -167,9 +168,9 @@ static int get_key_adaptec(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 	keybuf[2] &= 0x7f;
 	keybuf[3] |= 0x80;
 
-	*ir_key = keybuf[3] | keybuf[2] << 8 | keybuf[1] << 16 |keybuf[0] << 24;
-	*ir_raw = *ir_key;
-
+	*protocol = RC_TYPE_UNKNOWN;
+	*scancode = keybuf[3] | keybuf[2] << 8 | keybuf[1] << 16 |keybuf[0] << 24;
+	*toggle = 0;
 	return 1;
 }
 
diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index 6f43126..73670ed 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -108,7 +108,8 @@ static int build_key(struct saa7134_dev *dev)
 
 /* --------------------- Chip specific I2C key builders ----------------- */
 
-static int get_key_flydvb_trio(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+static int get_key_flydvb_trio(struct IR_i2c *ir, enum rc_type *protocol,
+			       u32 *scancode, u8 *toggle)
 {
 	int gpio;
 	int attempt = 0;
@@ -158,13 +159,14 @@ static int get_key_flydvb_trio(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 		return -EIO;
 	}
 
-	*ir_key = b;
-	*ir_raw = b;
+	*protocol = RC_TYPE_UNKNOWN;
+	*scancode = b;
+	*toggle = 0;
 	return 1;
 }
 
-static int get_key_msi_tvanywhere_plus(struct IR_i2c *ir, u32 *ir_key,
-				       u32 *ir_raw)
+static int get_key_msi_tvanywhere_plus(struct IR_i2c *ir, enum rc_type *protocol,
+				       u32 *scancode, u8 *toggle)
 {
 	unsigned char b;
 	int gpio;
@@ -205,14 +207,15 @@ static int get_key_msi_tvanywhere_plus(struct IR_i2c *ir, u32 *ir_key,
 	/* Button pressed */
 
 	dprintk("get_key_msi_tvanywhere_plus: Key = 0x%02X\n", b);
-	*ir_key = b;
-	*ir_raw = b;
+	*protocol = RC_TYPE_UNKNOWN;
+	*scancode = b;
+	*toggle = 0;
 	return 1;
 }
 
 /* copied and modified from get_key_msi_tvanywhere_plus() */
-static int get_key_kworld_pc150u(struct IR_i2c *ir, u32 *ir_key,
-					u32 *ir_raw)
+static int get_key_kworld_pc150u(struct IR_i2c *ir, enum rc_type *protocol,
+				 u32 *scancode, u8 *toggle)
 {
 	unsigned char b;
 	unsigned int gpio;
@@ -253,12 +256,14 @@ static int get_key_kworld_pc150u(struct IR_i2c *ir, u32 *ir_key,
 	/* Button pressed */
 
 	dprintk("get_key_kworld_pc150u: Key = 0x%02X\n", b);
-	*ir_key = b;
-	*ir_raw = b;
+	*protocol = RC_TYPE_UNKNOWN;
+	*scancode = b;
+	*toggle = 0;
 	return 1;
 }
 
-static int get_key_purpletv(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+static int get_key_purpletv(struct IR_i2c *ir, enum rc_type *protocol,
+			    u32 *scancode, u8 *toggle)
 {
 	unsigned char b;
 
@@ -276,12 +281,14 @@ static int get_key_purpletv(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 	if (b & 0x80)
 		return 1;
 
-	*ir_key = b;
-	*ir_raw = b;
+	*protocol = RC_TYPE_UNKNOWN;
+	*scancode = b;
+	*toggle = 0;
 	return 1;
 }
 
-static int get_key_hvr1110(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+static int get_key_hvr1110(struct IR_i2c *ir, enum rc_type *protocol,
+			   u32 *scancode, u8 *toggle)
 {
 	unsigned char buf[5];
 
@@ -299,14 +306,20 @@ static int get_key_hvr1110(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 	 * by preserving it into two separate readings
 	 * buf[4] bits 0 and 1, and buf[1] and buf[2] are always
 	 * zero.
+	 *
+	 * Note that the keymap which the hvr1110 uses is RC5.
+	 *
+	 * FIXME: start bits could maybe be used...?
 	 */
-	*ir_key = 0x1fff & ((buf[3] << 8) | (buf[4] >> 2));
-	*ir_raw = *ir_key;
+	*protocol = RC_TYPE_RC5;
+	*scancode = RC_SCANCODE_RC5(buf[3] & 0x1f, buf[4] >> 2);
+	*toggle = !!(buf[3] & 0x40);
 	return 1;
 }
 
 
-static int get_key_beholdm6xx(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+static int get_key_beholdm6xx(struct IR_i2c *ir, enum rc_type *protocol,
+			      u32 *scancode, u8 *toggle)
 {
 	unsigned char data[12];
 	u32 gpio;
@@ -332,17 +345,18 @@ static int get_key_beholdm6xx(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 	if (data[9] != (unsigned char)(~data[8]))
 		return 0;
 
-	*ir_raw = ((data[10] << 16) | (data[11] << 8) | (data[9] << 0));
-	*ir_key = *ir_raw;
-
+	*protocol = RC_TYPE_NEC;
+	*scancode = RC_SCANCODE_NECX(((data[10] << 8) | data[11]), data[9]);
+	*toggle = 0;
 	return 1;
 }
 
 /* Common (grey or coloured) pinnacle PCTV remote handling
  *
  */
-static int get_key_pinnacle(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw,
-			    int parity_offset, int marker, int code_modulo)
+static int get_key_pinnacle(struct IR_i2c *ir, enum rc_type *protocol,
+			    u32 *scancode, u8 *toggle, int parity_offset,
+			    int marker, int code_modulo)
 {
 	unsigned char b[4];
 	unsigned int start = 0,parity = 0,code = 0;
@@ -377,11 +391,11 @@ static int get_key_pinnacle(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw,
 
 	code %= code_modulo;
 
-	*ir_raw = code;
-	*ir_key = code;
+	*protocol = RC_TYPE_UNKNOWN;
+	*scancode = code;
+	*toggle = 0;
 
 	i2cdprintk("Pinnacle PCTV key %02x\n", code);
-
 	return 1;
 }
 
@@ -394,10 +408,11 @@ static int get_key_pinnacle(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw,
  *
  * Sylvain Pasche <sylvain.pasche@gmail.com>
  */
-static int get_key_pinnacle_grey(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+static int get_key_pinnacle_grey(struct IR_i2c *ir, enum rc_type *protocol,
+				 u32 *scancode, u8 *toggle)
 {
 
-	return get_key_pinnacle(ir, ir_key, ir_raw, 1, 0xfe, 0xff);
+	return get_key_pinnacle(ir, protocol, scancode, toggle, 1, 0xfe, 0xff);
 }
 
 
@@ -405,7 +420,8 @@ static int get_key_pinnacle_grey(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
  *
  * Ricardo Cerqueira <v4l@cerqueira.org>
  */
-static int get_key_pinnacle_color(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+static int get_key_pinnacle_color(struct IR_i2c *ir, enum rc_type *protocol,
+				  u32 *scancode, u8 *toggle)
 {
 	/* code_modulo parameter (0x88) is used to reduce code value to fit inside IR_KEYTAB_SIZE
 	 *
@@ -413,7 +429,7 @@ static int get_key_pinnacle_color(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 	 * codes < 128
 	 */
 
-	return get_key_pinnacle(ir, ir_key, ir_raw, 2, 0x80, 0x88);
+	return get_key_pinnacle(ir, protocol, scancode, toggle, 2, 0x80, 0x88);
 }
 
 void saa7134_input_irq(struct saa7134_dev *dev)
diff --git a/drivers/media/usb/cx231xx/cx231xx-input.c b/drivers/media/usb/cx231xx/cx231xx-input.c
index 46d52fa..adcdd92 100644
--- a/drivers/media/usb/cx231xx/cx231xx-input.c
+++ b/drivers/media/usb/cx231xx/cx231xx-input.c
@@ -21,11 +21,12 @@
 #include "cx231xx.h"
 #include <linux/usb.h>
 #include <linux/slab.h>
+#include <linux/bitrev.h>
 
 #define MODULE_NAME "cx231xx-input"
 
-static int get_key_isdbt(struct IR_i2c *ir, u32 *ir_key,
-			 u32 *ir_raw)
+static int get_key_isdbt(struct IR_i2c *ir, enum rc_type *protocol,
+			 u32 *pscancode, u8 *toggle)
 {
 	int	rc;
 	u8	cmd, scancode;
@@ -46,21 +47,14 @@ static int get_key_isdbt(struct IR_i2c *ir, u32 *ir_key,
 	if (cmd == 0xff)
 		return 0;
 
-	scancode =
-		 ((cmd & 0x01) ? 0x80 : 0) |
-		 ((cmd & 0x02) ? 0x40 : 0) |
-		 ((cmd & 0x04) ? 0x20 : 0) |
-		 ((cmd & 0x08) ? 0x10 : 0) |
-		 ((cmd & 0x10) ? 0x08 : 0) |
-		 ((cmd & 0x20) ? 0x04 : 0) |
-		 ((cmd & 0x40) ? 0x02 : 0) |
-		 ((cmd & 0x80) ? 0x01 : 0);
+	scancode = bitrev8(cmd);
 
 	dev_dbg(&ir->rc->input_dev->dev, "cmd %02x, scan = %02x\n",
 		cmd, scancode);
 
-	*ir_key = scancode;
-	*ir_raw = scancode;
+	*protocol = RC_TYPE_OTHER;
+	*pscancode = scancode;
+	*toggle = 0;
 	return 1;
 }
 
diff --git a/include/media/ir-kbd-i2c.h b/include/media/ir-kbd-i2c.h
index e221bc7..d856435 100644
--- a/include/media/ir-kbd-i2c.h
+++ b/include/media/ir-kbd-i2c.h
@@ -20,7 +20,8 @@ struct IR_i2c {
 	struct delayed_work    work;
 	char                   name[32];
 	char                   phys[32];
-	int                    (*get_key)(struct IR_i2c*, u32*, u32*);
+	int                    (*get_key)(struct IR_i2c *ir, enum rc_type *protocol,
+					  u32 *scancode, u8 *toggle);
 };
 
 enum ir_kbd_get_key_fn {
@@ -44,7 +45,8 @@ struct IR_i2c_init_data {
 	 * Specify either a function pointer or a value indicating one of
 	 * ir_kbd_i2c's internal get_key functions
 	 */
-	int                    (*get_key)(struct IR_i2c*, u32*, u32*);
+	int                    (*get_key)(struct IR_i2c *ir, enum rc_type *protocol,
+					  u32 *scancode, u8 *toggle);
 	enum ir_kbd_get_key_fn internal_get_key_func;
 
 	struct rc_dev		*rc_dev;
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index e5aa240..894c7e4 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -62,6 +62,16 @@ enum rc_type {
 			 RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
 			 RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE | RC_BIT_SHARP)
 
+#define RC_SCANCODE_UNKNOWN(x)			(x)
+#define RC_SCANCODE_OTHER(x)			(x)
+#define RC_SCANCODE_NEC(addr, cmd)		(((addr) << 8) | (cmd))
+#define RC_SCANCODE_NECX(addr, cmd)		(((addr) << 8) | (cmd))
+#define RC_SCANCODE_NEC32(data)			((data) & 0xffffffff)
+#define RC_SCANCODE_RC5(sys, cmd)		(((sys) << 8) | (cmd))
+#define RC_SCANCODE_RC5_SZ(sys, cmd)		(((sys) << 8) | (cmd))
+#define RC_SCANCODE_RC6_0(sys, cmd)		(((sys) << 8) | (cmd))
+#define RC_SCANCODE_RC6_6A(vendor, sys, cmd)	(((vendor) << 16) | ((sys) << 8) | (cmd))
+
 struct rc_map_table {
 	u32	scancode;
 	u32	keycode;

