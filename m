Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:37278 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754569AbaCZAEY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 20:04:24 -0400
Subject: [PATCH 1/3] bt8xx: fixup RC5 decoding
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: m.chehab@samsung.com
Date: Wed, 26 Mar 2014 01:04:22 +0100
Message-ID: <20140326000422.5663.21569.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140325235935.5663.96526.stgit@zeus.muc.hardeman.nu>
References: <20140325235935.5663.96526.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The bt8xx driver does RC5 decoding for Nebula digi hardware, but includes
some pointless limitations (both start bits must be one, the
device/address/system must be 0x00). Remove those limitations and update
the keymap to use the full RC5 scancode (fortunately the 0x00 address
means that this is perfectly backwards compatible).

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/pci/bt8xx/bttv-input.c |   62 ++++++++++---------
 drivers/media/pci/bt8xx/bttvp.h      |    2 -
 drivers/media/rc/keymaps/rc-nebula.c |  112 +++++++++++++++++-----------------
 3 files changed, 88 insertions(+), 88 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-input.c b/drivers/media/pci/bt8xx/bttv-input.c
index 5930bce..ffc0ee1 100644
--- a/drivers/media/pci/bt8xx/bttv-input.c
+++ b/drivers/media/pci/bt8xx/bttv-input.c
@@ -154,10 +154,10 @@ static void bttv_input_timer(unsigned long data)
  * testing.
  */
 
-#define RC5_START(x)	(((x) >> 12) & 3)
-#define RC5_TOGGLE(x)	(((x) >> 11) & 1)
-#define RC5_ADDR(x)	(((x) >> 6) & 31)
-#define RC5_INSTR(x)	((x) & 63)
+#define RC5_START(x)	(((x) >> 12) & 0x03)
+#define RC5_TOGGLE(x)	(((x) >> 11) & 0x01)
+#define RC5_ADDR(x)	(((x) >> 6)  & 0x1f)
+#define RC5_INSTR(x)	(((x) >> 0)  & 0x3f)
 
 /* decode raw bit pattern to RC5 code */
 static u32 bttv_rc5_decode(unsigned int code)
@@ -195,8 +195,8 @@ static void bttv_rc5_timer_end(unsigned long data)
 {
 	struct bttv_ir *ir = (struct bttv_ir *)data;
 	struct timeval tv;
-	u32 gap;
-	u32 rc5 = 0;
+	u32 gap, rc5, scancode;
+	u8 toggle, command, system;
 
 	/* get time */
 	do_gettimeofday(&tv);
@@ -221,26 +221,29 @@ static void bttv_rc5_timer_end(unsigned long data)
 	if (ir->last_bit < 20) {
 		/* ignore spurious codes (caused by light/other remotes) */
 		dprintk("short code: %x\n", ir->code);
-	} else {
-		ir->code = (ir->code << ir->shift_by) | 1;
-		rc5 = bttv_rc5_decode(ir->code);
-
-		/* two start bits? */
-		if (RC5_START(rc5) != ir->start) {
-			pr_info(DEVNAME ":"
-			       " rc5 start bits invalid: %u\n", RC5_START(rc5));
-
-			/* right address? */
-		} else if (RC5_ADDR(rc5) == ir->addr) {
-			u32 toggle = RC5_TOGGLE(rc5);
-			u32 instr = RC5_INSTR(rc5);
-
-			/* Good code */
-			rc_keydown(ir->dev, instr, toggle);
-			dprintk("instruction %x, toggle %x\n",
-				instr, toggle);
-		}
+		return;
 	}
+
+	ir->code = (ir->code << ir->shift_by) | 1;
+	rc5 = bttv_rc5_decode(ir->code);
+
+	toggle = RC5_TOGGLE(rc5);
+	system = RC5_ADDR(rc5);
+	command = RC5_INSTR(rc5);
+
+	switch (RC5_START(rc5)) {
+	case 0x3:
+		break;
+	case 0x2:
+		command += 0x40;
+		break;
+	default:
+		return;
+	}
+
+	scancode = system << 8 | command;
+	rc_keydown(ir->dev, scancode, toggle);
+	dprintk("scancode %x, toggle %x\n", scancode, toggle);
 }
 
 static int bttv_rc5_irq(struct bttv *btv)
@@ -310,8 +313,6 @@ static void bttv_ir_start(struct bttv *btv, struct bttv_ir *ir)
 		/* set timer_end for code completion */
 		setup_timer(&ir->timer, bttv_rc5_timer_end, (unsigned long)ir);
 		ir->shift_by = 1;
-		ir->start = 3;
-		ir->addr = 0x0;
 		ir->rc5_remote_gap = ir_rc5_remote_gap;
 	}
 }
@@ -490,8 +491,8 @@ int bttv_input_init(struct bttv *btv)
 		ir->polling      = 50; // ms
 		break;
 	case BTTV_BOARD_NEBULA_DIGITV:
-		ir_codes = RC_MAP_NEBULA;
-		ir->rc5_gpio = true;
+		ir_codes         = RC_MAP_NEBULA;
+		ir->rc5_gpio     = true;
 		break;
 	case BTTV_BOARD_MACHTV_MAGICTV:
 		ir_codes         = RC_MAP_APAC_VIEWCOMP;
@@ -514,7 +515,8 @@ int bttv_input_init(struct bttv *btv)
 						   ir->mask_keycode);
 		break;
 	}
-	if (NULL == ir_codes) {
+
+	if (!ir_codes) {
 		dprintk("Ooops: IR config error [card=%d]\n", btv->c.type);
 		err = -ENODEV;
 		goto err_out_free;
diff --git a/drivers/media/pci/bt8xx/bttvp.h b/drivers/media/pci/bt8xx/bttvp.h
index 6eefb59..9fe19488 100644
--- a/drivers/media/pci/bt8xx/bttvp.h
+++ b/drivers/media/pci/bt8xx/bttvp.h
@@ -133,8 +133,6 @@ struct bttv_ir {
 	u32                     polling;
 	u32                     last_gpio;
 	int                     shift_by;
-	int                     start; // What should RC5_START() be
-	int                     addr; // What RC5_ADDR() should be.
 	int                     rc5_remote_gap;
 
 	/* RC5 gpio */
diff --git a/drivers/media/rc/keymaps/rc-nebula.c b/drivers/media/rc/keymaps/rc-nebula.c
index 8ec881a..4c50f33 100644
--- a/drivers/media/rc/keymaps/rc-nebula.c
+++ b/drivers/media/rc/keymaps/rc-nebula.c
@@ -14,68 +14,68 @@
 #include <linux/module.h>
 
 static struct rc_map_table nebula[] = {
-	{ 0x00, KEY_0 },
-	{ 0x01, KEY_1 },
-	{ 0x02, KEY_2 },
-	{ 0x03, KEY_3 },
-	{ 0x04, KEY_4 },
-	{ 0x05, KEY_5 },
-	{ 0x06, KEY_6 },
-	{ 0x07, KEY_7 },
-	{ 0x08, KEY_8 },
-	{ 0x09, KEY_9 },
-	{ 0x0a, KEY_TV },
-	{ 0x0b, KEY_AUX },
-	{ 0x0c, KEY_DVD },
-	{ 0x0d, KEY_POWER },
-	{ 0x0e, KEY_CAMERA },	/* labelled 'Picture' */
-	{ 0x0f, KEY_AUDIO },
-	{ 0x10, KEY_INFO },
-	{ 0x11, KEY_F13 },	/* 16:9 */
-	{ 0x12, KEY_F14 },	/* 14:9 */
-	{ 0x13, KEY_EPG },
-	{ 0x14, KEY_EXIT },
-	{ 0x15, KEY_MENU },
-	{ 0x16, KEY_UP },
-	{ 0x17, KEY_DOWN },
-	{ 0x18, KEY_LEFT },
-	{ 0x19, KEY_RIGHT },
-	{ 0x1a, KEY_ENTER },
-	{ 0x1b, KEY_CHANNELUP },
-	{ 0x1c, KEY_CHANNELDOWN },
-	{ 0x1d, KEY_VOLUMEUP },
-	{ 0x1e, KEY_VOLUMEDOWN },
-	{ 0x1f, KEY_RED },
-	{ 0x20, KEY_GREEN },
-	{ 0x21, KEY_YELLOW },
-	{ 0x22, KEY_BLUE },
-	{ 0x23, KEY_SUBTITLE },
-	{ 0x24, KEY_F15 },	/* AD */
-	{ 0x25, KEY_TEXT },
-	{ 0x26, KEY_MUTE },
-	{ 0x27, KEY_REWIND },
-	{ 0x28, KEY_STOP },
-	{ 0x29, KEY_PLAY },
-	{ 0x2a, KEY_FASTFORWARD },
-	{ 0x2b, KEY_F16 },	/* chapter */
-	{ 0x2c, KEY_PAUSE },
-	{ 0x2d, KEY_PLAY },
-	{ 0x2e, KEY_RECORD },
-	{ 0x2f, KEY_F17 },	/* picture in picture */
-	{ 0x30, KEY_KPPLUS },	/* zoom in */
-	{ 0x31, KEY_KPMINUS },	/* zoom out */
-	{ 0x32, KEY_F18 },	/* capture */
-	{ 0x33, KEY_F19 },	/* web */
-	{ 0x34, KEY_EMAIL },
-	{ 0x35, KEY_PHONE },
-	{ 0x36, KEY_PC },
+	{ 0x0000, KEY_0 },
+	{ 0x0001, KEY_1 },
+	{ 0x0002, KEY_2 },
+	{ 0x0003, KEY_3 },
+	{ 0x0004, KEY_4 },
+	{ 0x0005, KEY_5 },
+	{ 0x0006, KEY_6 },
+	{ 0x0007, KEY_7 },
+	{ 0x0008, KEY_8 },
+	{ 0x0009, KEY_9 },
+	{ 0x000a, KEY_TV },
+	{ 0x000b, KEY_AUX },
+	{ 0x000c, KEY_DVD },
+	{ 0x000d, KEY_POWER },
+	{ 0x000e, KEY_CAMERA },	/* labelled 'Picture' */
+	{ 0x000f, KEY_AUDIO },
+	{ 0x0010, KEY_INFO },
+	{ 0x0011, KEY_F13 },	/* 16:9 */
+	{ 0x0012, KEY_F14 },	/* 14:9 */
+	{ 0x0013, KEY_EPG },
+	{ 0x0014, KEY_EXIT },
+	{ 0x0015, KEY_MENU },
+	{ 0x0016, KEY_UP },
+	{ 0x0017, KEY_DOWN },
+	{ 0x0018, KEY_LEFT },
+	{ 0x0019, KEY_RIGHT },
+	{ 0x001a, KEY_ENTER },
+	{ 0x001b, KEY_CHANNELUP },
+	{ 0x001c, KEY_CHANNELDOWN },
+	{ 0x001d, KEY_VOLUMEUP },
+	{ 0x001e, KEY_VOLUMEDOWN },
+	{ 0x001f, KEY_RED },
+	{ 0x0020, KEY_GREEN },
+	{ 0x0021, KEY_YELLOW },
+	{ 0x0022, KEY_BLUE },
+	{ 0x0023, KEY_SUBTITLE },
+	{ 0x0024, KEY_F15 },	/* AD */
+	{ 0x0025, KEY_TEXT },
+	{ 0x0026, KEY_MUTE },
+	{ 0x0027, KEY_REWIND },
+	{ 0x0028, KEY_STOP },
+	{ 0x0029, KEY_PLAY },
+	{ 0x002a, KEY_FASTFORWARD },
+	{ 0x002b, KEY_F16 },	/* chapter */
+	{ 0x002c, KEY_PAUSE },
+	{ 0x002d, KEY_PLAY },
+	{ 0x002e, KEY_RECORD },
+	{ 0x002f, KEY_F17 },	/* picture in picture */
+	{ 0x0030, KEY_KPPLUS },	/* zoom in */
+	{ 0x0031, KEY_KPMINUS },	/* zoom out */
+	{ 0x0032, KEY_F18 },	/* capture */
+	{ 0x0033, KEY_F19 },	/* web */
+	{ 0x0034, KEY_EMAIL },
+	{ 0x0035, KEY_PHONE },
+	{ 0x0036, KEY_PC },
 };
 
 static struct rc_map_list nebula_map = {
 	.map = {
 		.scan    = nebula,
 		.size    = ARRAY_SIZE(nebula),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_RC5,
 		.name    = RC_MAP_NEBULA,
 	}
 };

