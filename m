Return-path: <mchehab@gaivota>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:35263 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab0KBURx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Nov 2010 16:17:53 -0400
Subject: [PATCH 2/6] ir-core: remove remaining users of the ir-functions
	keyhandlers
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@wilsonet.com, mchehab@infradead.org
Date: Tue, 02 Nov 2010 21:17:49 +0100
Message-ID: <20101102201749.12010.81573.stgit@localhost.localdomain>
In-Reply-To: <20101102201733.12010.30019.stgit@localhost.localdomain>
References: <20101102201733.12010.30019.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This patch removes the remaining usages of the ir_input_nokey() and
ir_input_keydown() functions provided by drivers/media/IR/ir-functions.c
by using the corresponding functionality in ir-core instead.

Signed-off-by: David Härdeman <david@hardeman.nu>
Acked-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/imon.c                     |    9 --
 drivers/media/IR/ir-functions.c             |  101 ++-----------------------
 drivers/media/IR/ir-keytable.c              |  110 ++++++++++++++++++++-------
 drivers/media/video/bt8xx/bttv-input.c      |   32 ++------
 drivers/media/video/bt8xx/bttvp.h           |    1 
 drivers/media/video/cx88/cx88-input.c       |   11 ++-
 drivers/media/video/ir-kbd-i2c.c            |    3 -
 drivers/media/video/saa7134/saa7134-input.c |   49 ++----------
 drivers/staging/tm6000/tm6000-input.c       |   15 +---
 include/media/ir-common.h                   |   31 +-------
 include/media/ir-core.h                     |    3 -
 include/media/ir-kbd-i2c.h                  |    4 -
 12 files changed, 133 insertions(+), 236 deletions(-)

diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
index bc11806..79f4f58 100644
--- a/drivers/media/IR/imon.c
+++ b/drivers/media/IR/imon.c
@@ -1479,17 +1479,12 @@ static void imon_incoming_packet(struct imon_context *ictx,
 	bool norelease = false;
 	int i;
 	u64 scancode;
-	struct input_dev *rdev = NULL;
-	struct ir_input_dev *irdev = NULL;
 	int press_type = 0;
 	int msec;
 	struct timeval t;
 	static struct timeval prev_time = { 0, 0 };
 	u8 ktype;
 
-	rdev = ictx->rdev;
-	irdev = input_get_drvdata(rdev);
-
 	/* filter out junk data on the older 0xffdc imon devices */
 	if ((buf[0] == 0xff) && (buf[1] == 0xff) && (buf[2] == 0xff))
 		return;
@@ -1570,9 +1565,9 @@ static void imon_incoming_packet(struct imon_context *ictx,
 
 	if (ktype != IMON_KEY_PANEL) {
 		if (press_type == 0)
-			ir_keyup(irdev);
+			ir_keyup(ictx->rdev);
 		else {
-			ir_keydown(rdev, ictx->rc_scancode, ictx->rc_toggle);
+			ir_keydown(ictx->rdev, ictx->rc_scancode, ictx->rc_toggle);
 			spin_lock_irqsave(&ictx->kc_lock, flags);
 			ictx->last_keycode = ictx->kc;
 			spin_unlock_irqrestore(&ictx->kc_lock, flags);
diff --git a/drivers/media/IR/ir-functions.c b/drivers/media/IR/ir-functions.c
index f4c4115..fca734c 100644
--- a/drivers/media/IR/ir-functions.c
+++ b/drivers/media/IR/ir-functions.c
@@ -1,7 +1,7 @@
 /*
- *
- * some common structs and functions to handle infrared remotes via
- * input layer ...
+ * some common functions to handle infrared remote protocol decoding for
+ * drivers which have not yet been (or can't be) converted to use the
+ * regular protocol decoders...
  *
  * (c) 2003 Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]
  *
@@ -31,67 +31,6 @@
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
 MODULE_LICENSE("GPL");
 
-static int repeat = 1;
-module_param(repeat, int, 0444);
-MODULE_PARM_DESC(repeat,"auto-repeat for IR keys (default: on)");
-
-/* -------------------------------------------------------------------------- */
-
-static void ir_input_key_event(struct input_dev *dev, struct ir_input_state *ir)
-{
-	if (KEY_RESERVED == ir->keycode) {
-		printk(KERN_INFO "%s: unknown key: key=0x%02x down=%d\n",
-		       dev->name, ir->ir_key, ir->keypressed);
-		return;
-	}
-	IR_dprintk(1,"%s: key event code=%d down=%d\n",
-		dev->name,ir->keycode,ir->keypressed);
-	input_report_key(dev,ir->keycode,ir->keypressed);
-	input_sync(dev);
-}
-
-/* -------------------------------------------------------------------------- */
-
-int ir_input_init(struct input_dev *dev, struct ir_input_state *ir,
-		  const u64 ir_type)
-{
-	ir->ir_type = ir_type;
-
-	if (repeat)
-		set_bit(EV_REP, dev->evbit);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ir_input_init);
-
-
-void ir_input_nokey(struct input_dev *dev, struct ir_input_state *ir)
-{
-	if (ir->keypressed) {
-		ir->keypressed = 0;
-		ir_input_key_event(dev,ir);
-	}
-}
-EXPORT_SYMBOL_GPL(ir_input_nokey);
-
-void ir_input_keydown(struct input_dev *dev, struct ir_input_state *ir,
-		      u32 ir_key)
-{
-	u32 keycode = ir_g_keycode_from_table(dev, ir_key);
-
-	if (ir->keypressed && ir->keycode != keycode) {
-		ir->keypressed = 0;
-		ir_input_key_event(dev,ir);
-	}
-	if (!ir->keypressed) {
-		ir->ir_key  = ir_key;
-		ir->keycode = keycode;
-		ir->keypressed = 1;
-		ir_input_key_event(dev,ir);
-	}
-}
-EXPORT_SYMBOL_GPL(ir_input_keydown);
-
 /* -------------------------------------------------------------------------- */
 /* extract mask bits out of data and pack them into the result */
 u32 ir_extract_bits(u32 data, u32 mask)
@@ -115,7 +54,7 @@ EXPORT_SYMBOL_GPL(ir_extract_bits);
  * saa7134 */
 
 /* decode raw bit pattern to RC5 code */
-u32 ir_rc5_decode(unsigned int code)
+static u32 ir_rc5_decode(unsigned int code)
 {
 	unsigned int org_code = code;
 	unsigned int pair;
@@ -144,13 +83,12 @@ u32 ir_rc5_decode(unsigned int code)
 		RC5_TOGGLE(rc5), RC5_ADDR(rc5), RC5_INSTR(rc5));
 	return rc5;
 }
-EXPORT_SYMBOL_GPL(ir_rc5_decode);
 
 void ir_rc5_timer_end(unsigned long data)
 {
 	struct card_ir *ir = (struct card_ir *)data;
 	struct timeval tv;
-	unsigned long current_jiffies, timeout;
+	unsigned long current_jiffies;
 	u32 gap;
 	u32 rc5 = 0;
 
@@ -191,32 +129,11 @@ void ir_rc5_timer_end(unsigned long data)
 			u32 toggle = RC5_TOGGLE(rc5);
 			u32 instr = RC5_INSTR(rc5);
 
-			/* Good code, decide if repeat/repress */
-			if (toggle != RC5_TOGGLE(ir->last_rc5) ||
-			    instr != RC5_INSTR(ir->last_rc5)) {
-				IR_dprintk(1, "ir-common: instruction %x, toggle %x\n", instr,
-					toggle);
-				ir_input_nokey(ir->dev, &ir->ir);
-				ir_input_keydown(ir->dev, &ir->ir, instr);
-			}
-
-			/* Set/reset key-up timer */
-			timeout = current_jiffies +
-				  msecs_to_jiffies(ir->rc5_key_timeout);
-			mod_timer(&ir->timer_keyup, timeout);
-
-			/* Save code for repeat test */
-			ir->last_rc5 = rc5;
+			/* Good code */
+			ir_keydown(ir->dev, instr, toggle);
+			IR_dprintk(1, "ir-common: instruction %x, toggle %x\n",
+				   instr, toggle);
 		}
 	}
 }
 EXPORT_SYMBOL_GPL(ir_rc5_timer_end);
-
-void ir_rc5_timer_keyup(unsigned long data)
-{
-	struct card_ir *ir = (struct card_ir *)data;
-
-	IR_dprintk(1, "ir-common: key released\n");
-	ir_input_nokey(ir->dev, &ir->ir);
-}
-EXPORT_SYMBOL_GPL(ir_rc5_timer_keyup);
diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index f60107c..8039110 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -431,13 +431,13 @@ u32 ir_g_keycode_from_table(struct input_dev *dev, u32 scancode)
 EXPORT_SYMBOL_GPL(ir_g_keycode_from_table);
 
 /**
- * ir_keyup() - generates input event to cleanup a key press
+ * ir_do_keyup() - internal function to signal the release of a keypress
  * @ir:         the struct ir_input_dev descriptor of the device
  *
- * This routine is used to signal that a key has been released on the
- * remote control. It reports a keyup input event via input_report_key().
+ * This function is used internally to release a keypress, it must be
+ * called with keylock held.
  */
-void ir_keyup(struct ir_input_dev *ir)
+static void ir_do_keyup(struct ir_input_dev *ir)
 {
 	if (!ir->keypressed)
 		return;
@@ -447,6 +447,23 @@ void ir_keyup(struct ir_input_dev *ir)
 	input_sync(ir->input_dev);
 	ir->keypressed = false;
 }
+
+/**
+ * ir_keyup() - generates input event to signal the release of a keypress
+ * @dev:        the struct input_dev descriptor of the device
+ *
+ * This routine is used to signal that a key has been released on the
+ * remote control.
+ */
+void ir_keyup(struct input_dev *dev)
+{
+	unsigned long flags;
+	struct ir_input_dev *ir = input_get_drvdata(dev);
+
+	spin_lock_irqsave(&ir->keylock, flags);
+	ir_do_keyup(ir);
+	spin_unlock_irqrestore(&ir->keylock, flags);
+}
 EXPORT_SYMBOL_GPL(ir_keyup);
 
 /**
@@ -473,7 +490,7 @@ static void ir_timer_keyup(unsigned long cookie)
 	 */
 	spin_lock_irqsave(&ir->keylock, flags);
 	if (time_is_before_eq_jiffies(ir->keyup_jiffies))
-		ir_keyup(ir);
+		ir_do_keyup(ir);
 	spin_unlock_irqrestore(&ir->keylock, flags);
 }
 
@@ -506,44 +523,37 @@ out:
 EXPORT_SYMBOL_GPL(ir_repeat);
 
 /**
- * ir_keydown() - generates input event for a key press
+ * ir_do_keydown() - internal function to process a keypress
  * @dev:        the struct input_dev descriptor of the device
- * @scancode:   the scancode that we're seeking
- * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
- *              support toggle values, this should be set to zero)
+ * @scancode:   the scancode of the keypress
+ * @keycode:    the keycode of the keypress
+ * @toggle:     the toggle value of the keypress
  *
- * This routine is used by the input routines when a key is pressed at the
- * IR. It gets the keycode for a scancode and reports an input event via
- * input_report_key().
+ * This function is used internally to register a keypress, it must be
+ * called with keylock held.
  */
-void ir_keydown(struct input_dev *dev, int scancode, u8 toggle)
+static void ir_do_keydown(struct input_dev *dev, int scancode,
+			  u32 keycode, u8 toggle)
 {
-	unsigned long flags;
 	struct ir_input_dev *ir = input_get_drvdata(dev);
 
-	u32 keycode = ir_g_keycode_from_table(dev, scancode);
-
-	spin_lock_irqsave(&ir->keylock, flags);
-
 	input_event(dev, EV_MSC, MSC_SCAN, scancode);
 
 	/* Repeat event? */
 	if (ir->keypressed &&
 	    ir->last_scancode == scancode &&
 	    ir->last_toggle == toggle)
-		goto set_timer;
+		return;
 
 	/* Release old keypress */
-	ir_keyup(ir);
+	ir_do_keyup(ir);
 
 	ir->last_scancode = scancode;
 	ir->last_toggle = toggle;
 	ir->last_keycode = keycode;
 
-
 	if (keycode == KEY_RESERVED)
-		goto out;
-
+		return;
 
 	/* Register a keypress */
 	ir->keypressed = true;
@@ -551,15 +561,61 @@ void ir_keydown(struct input_dev *dev, int scancode, u8 toggle)
 		   dev->name, keycode, scancode);
 	input_report_key(dev, ir->last_keycode, 1);
 	input_sync(dev);
+}
 
-set_timer:
-	ir->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
-	mod_timer(&ir->timer_keyup, ir->keyup_jiffies);
-out:
+/**
+ * ir_keydown() - generates input event for a key press
+ * @dev:        the struct input_dev descriptor of the device
+ * @scancode:   the scancode that we're seeking
+ * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
+ *              support toggle values, this should be set to zero)
+ *
+ * This routine is used by the input routines when a key is pressed at the
+ * IR. It gets the keycode for a scancode and reports an input event via
+ * input_report_key().
+ */
+void ir_keydown(struct input_dev *dev, int scancode, u8 toggle)
+{
+	unsigned long flags;
+	struct ir_input_dev *ir = input_get_drvdata(dev);
+	u32 keycode = ir_g_keycode_from_table(dev, scancode);
+
+	spin_lock_irqsave(&ir->keylock, flags);
+	ir_do_keydown(dev, scancode, keycode, toggle);
+
+	if (ir->keypressed) {
+		ir->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
+		mod_timer(&ir->timer_keyup, ir->keyup_jiffies);
+	}
 	spin_unlock_irqrestore(&ir->keylock, flags);
 }
 EXPORT_SYMBOL_GPL(ir_keydown);
 
+/**
+ * ir_keydown_notimeout() - generates input event for a key press without
+ *                          an automatic keyup event at a later time
+ * @dev:        the struct input_dev descriptor of the device
+ * @scancode:   the scancode that we're seeking
+ * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
+ *              support toggle values, this should be set to zero)
+ *
+ * This routine is used by the input routines when a key is pressed at the
+ * IR. It gets the keycode for a scancode and reports an input event via
+ * input_report_key(). The driver must manually call ir_keyup() at a later
+ * stage.
+ */
+void ir_keydown_notimeout(struct input_dev *dev, int scancode, u8 toggle)
+{
+	unsigned long flags;
+	struct ir_input_dev *ir = input_get_drvdata(dev);
+	u32 keycode = ir_g_keycode_from_table(dev, scancode);
+
+	spin_lock_irqsave(&ir->keylock, flags);
+	ir_do_keydown(dev, scancode, keycode, toggle);
+	spin_unlock_irqrestore(&ir->keylock, flags);
+}
+EXPORT_SYMBOL_GPL(ir_keydown_notimeout);
+
 static int ir_open(struct input_dev *input_dev)
 {
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
diff --git a/drivers/media/video/bt8xx/bttv-input.c b/drivers/media/video/bt8xx/bttv-input.c
index 6bf05a7..eb71c3a 100644
--- a/drivers/media/video/bt8xx/bttv-input.c
+++ b/drivers/media/video/bt8xx/bttv-input.c
@@ -38,8 +38,6 @@ module_param(repeat_period, int, 0644);
 
 static int ir_rc5_remote_gap = 885;
 module_param(ir_rc5_remote_gap, int, 0644);
-static int ir_rc5_key_timeout = 200;
-module_param(ir_rc5_key_timeout, int, 0644);
 
 #undef dprintk
 #define dprintk(arg...) do {	\
@@ -74,18 +72,17 @@ static void ir_handle_key(struct bttv *btv)
 		(gpio & ir->mask_keydown) ? " down" : "",
 		(gpio & ir->mask_keyup)   ? " up"   : "");
 
-	if ((ir->mask_keydown  &&  (0 != (gpio & ir->mask_keydown))) ||
-	    (ir->mask_keyup    &&  (0 == (gpio & ir->mask_keyup)))) {
-		ir_input_keydown(ir->dev, &ir->ir, data);
+	if ((ir->mask_keydown && (gpio & ir->mask_keydown)) ||
+	    (ir->mask_keyup   && !(gpio & ir->mask_keyup))) {
+		ir_keydown_notimeout(ir->dev, data, 0);
 	} else {
 		/* HACK: Probably, ir->mask_keydown is missing
 		   for this board */
 		if (btv->c.type == BTTV_BOARD_WINFAST2000)
-			ir_input_keydown(ir->dev, &ir->ir, data);
+			ir_keydown_notimeout(ir->dev, data, 0);
 
-		ir_input_nokey(ir->dev,&ir->ir);
+		ir_keyup(ir->dev);
 	}
-
 }
 
 static void ir_enltv_handle_key(struct bttv *btv)
@@ -107,9 +104,9 @@ static void ir_enltv_handle_key(struct bttv *btv)
 			gpio, data,
 			(gpio & ir->mask_keyup) ? " up" : "up/down");
 
-		ir_input_keydown(ir->dev, &ir->ir, data);
+		ir_keydown_notimeout(ir->dev, data, 0);
 		if (keyup)
-			ir_input_nokey(ir->dev, &ir->ir);
+			ir_keyup(ir->dev);
 	} else {
 		if ((ir->last_gpio & 1 << 31) == keyup)
 			return;
@@ -119,9 +116,9 @@ static void ir_enltv_handle_key(struct bttv *btv)
 			(gpio & ir->mask_keyup) ? " up" : "down");
 
 		if (keyup)
-			ir_input_nokey(ir->dev, &ir->ir);
+			ir_keyup(ir->dev);
 		else
-			ir_input_keydown(ir->dev, &ir->ir, data);
+			ir_keydown_notimeout(ir->dev, data, 0);
 	}
 
 	ir->last_gpio = data | keyup;
@@ -215,14 +212,9 @@ static void bttv_ir_start(struct bttv *btv, struct card_ir *ir)
 		init_timer(&ir->timer_end);
 		ir->timer_end.function = ir_rc5_timer_end;
 		ir->timer_end.data = (unsigned long)ir;
-
-		init_timer(&ir->timer_keyup);
-		ir->timer_keyup.function = ir_rc5_timer_keyup;
-		ir->timer_keyup.data = (unsigned long)ir;
 		ir->shift_by = 1;
 		ir->start = 3;
 		ir->addr = 0x0;
-		ir->rc5_key_timeout = ir_rc5_key_timeout;
 		ir->rc5_remote_gap = ir_rc5_remote_gap;
 	}
 }
@@ -290,7 +282,6 @@ void __devinit init_bttv_i2c_ir(struct bttv *btv)
 		btv->init_data.name = "PV951";
 		btv->init_data.get_key = get_key_pv951;
 		btv->init_data.ir_codes = RC_MAP_PV951;
-		btv->init_data.type = IR_TYPE_OTHER;
 		info.addr = 0x4b;
 		break;
 	default:
@@ -327,7 +318,6 @@ int bttv_input_init(struct bttv *btv)
 	struct card_ir *ir;
 	char *ir_codes = NULL;
 	struct input_dev *input_dev;
-	u64 ir_type = IR_TYPE_OTHER;
 	int err = -ENOMEM;
 
 	if (!btv->has_remote)
@@ -448,10 +438,6 @@ int bttv_input_init(struct bttv *btv)
 	snprintf(ir->phys, sizeof(ir->phys), "pci-%s/ir0",
 		 pci_name(btv->c.pci));
 
-	err = ir_input_init(input_dev, &ir->ir, ir_type);
-	if (err < 0)
-		goto err_out_free;
-
 	input_dev->name = ir->name;
 	input_dev->phys = ir->phys;
 	input_dev->id.bustype = BUS_PCI;
diff --git a/drivers/media/video/bt8xx/bttvp.h b/drivers/media/video/bt8xx/bttvp.h
index d1e26a4..157285b 100644
--- a/drivers/media/video/bt8xx/bttvp.h
+++ b/drivers/media/video/bt8xx/bttvp.h
@@ -305,7 +305,6 @@ struct bttv_pll_info {
 /* for gpio-connected remote control */
 struct bttv_input {
 	struct input_dev      *dev;
-	struct ir_input_state ir;
 	char                  name[32];
 	char                  phys[32];
 	u32                   mask_keycode;
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index 436ace8..564e3cb 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -131,16 +131,21 @@ static void cx88_ir_handle_key(struct cx88_IR *ir)
 	} else if (ir->mask_keydown) {
 		/* bit set on keydown */
 		if (gpio & ir->mask_keydown)
-			ir_keydown(ir->input, data, 0);
+			ir_keydown_notimeout(ir->input, data, 0);
+		else
+			ir_keyup(ir->input);
 
 	} else if (ir->mask_keyup) {
 		/* bit cleared on keydown */
 		if (0 == (gpio & ir->mask_keyup))
-			ir_keydown(ir->input, data, 0);
+			ir_keydown_notimeout(ir->input, data, 0);
+		else
+			ir_keyup(ir->input);
 
 	} else {
 		/* can't distinguish keydown/up :-/ */
-		ir_keydown(ir->input, data, 0);
+		ir_keydown_notimeout(ir->input, data, 0);
+		ir_keyup(ir->input);
 	}
 }
 
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index 5a000c6..aee8943 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -270,7 +270,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	char *ir_codes = NULL;
 	const char *name = NULL;
-	u64 ir_type = 0;
+	u64 ir_type = IR_TYPE_UNKNOWN;
 	struct IR_i2c *ir;
 	struct input_dev *input_dev;
 	struct i2c_adapter *adap = client->adapter;
@@ -384,7 +384,6 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		 dev_name(&client->dev));
 
 	/* init + register input device */
-	ir->ir_type = ir_type;
 	input_dev->id.bustype = BUS_I2C;
 	input_dev->name       = ir->name;
 	input_dev->phys       = ir->phys;
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 46d31df..7a59c26 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -44,8 +44,6 @@ MODULE_PARM_DESC(pinnacle_remote, "Specify Pinnacle PCTV remote: 0=coloured, 1=g
 
 static int ir_rc5_remote_gap = 885;
 module_param(ir_rc5_remote_gap, int, 0644);
-static int ir_rc5_key_timeout = 115;
-module_param(ir_rc5_key_timeout, int, 0644);
 
 static int repeat_delay = 500;
 module_param(repeat_delay, int, 0644);
@@ -70,7 +68,6 @@ static int saa7134_rc5_irq(struct saa7134_dev *dev);
 static int saa7134_nec_irq(struct saa7134_dev *dev);
 static int saa7134_raw_decode_irq(struct saa7134_dev *dev);
 static void nec_task(unsigned long data);
-static void saa7134_nec_timer(unsigned long data);
 
 /* -------------------- GPIO generic keycode builder -------------------- */
 
@@ -104,25 +101,25 @@ static int build_key(struct saa7134_dev *dev)
 	switch (dev->board) {
 	case SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG:
 		if (data == ir->mask_keycode)
-			ir_input_nokey(ir->dev, &ir->ir);
+			ir_keyup(ir->dev);
 		else
-			ir_input_keydown(ir->dev, &ir->ir, data);
+			ir_keydown_notimeout(ir->dev, data, 0);
 		return 0;
 	}
 
 	if (ir->polling) {
 		if ((ir->mask_keydown  &&  (0 != (gpio & ir->mask_keydown))) ||
 		    (ir->mask_keyup    &&  (0 == (gpio & ir->mask_keyup)))) {
-			ir_input_keydown(ir->dev, &ir->ir, data);
+			ir_keydown_notimeout(ir->dev, data, 0);
 		} else {
-			ir_input_nokey(ir->dev, &ir->ir);
+			ir_keyup(ir->dev);
 		}
 	}
 	else {	/* IRQ driven mode - handle key press and release in one go */
 		if ((ir->mask_keydown  &&  (0 != (gpio & ir->mask_keydown))) ||
 		    (ir->mask_keyup    &&  (0 == (gpio & ir->mask_keyup)))) {
-			ir_input_keydown(ir->dev, &ir->ir, data);
-			ir_input_nokey(ir->dev, &ir->ir);
+			ir_keydown_notimeout(ir->dev, data, 0);
+			ir_keyup(ir->dev);
 		}
 	}
 
@@ -465,17 +462,11 @@ static int __saa7134_ir_start(void *priv)
 		init_timer(&ir->timer_end);
 		ir->timer_end.function = ir_rc5_timer_end;
 		ir->timer_end.data = (unsigned long)ir;
-		init_timer(&ir->timer_keyup);
-		ir->timer_keyup.function = ir_rc5_timer_keyup;
-		ir->timer_keyup.data = (unsigned long)ir;
 		ir->shift_by = 2;
 		ir->start = 0x2;
 		ir->addr = 0x17;
-		ir->rc5_key_timeout = ir_rc5_key_timeout;
 		ir->rc5_remote_gap = ir_rc5_remote_gap;
 	} else if (ir->nec_gpio) {
-		setup_timer(&ir->timer_keyup, saa7134_nec_timer,
-			    (unsigned long)dev);
 		tasklet_init(&ir->tlet, nec_task, (unsigned long)dev);
 	} else if (ir->raw_decode) {
 		/* set timer_end for code completion */
@@ -596,7 +587,6 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	int nec_gpio	 = 0;
 	int raw_decode   = 0;
 	int allow_protocol_change = 0;
-	u64 ir_type = IR_TYPE_OTHER;
 	int err;
 
 	if (dev->has_remote != SAA7134_REMOTE_GPIO)
@@ -871,10 +861,6 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		ir->props.change_protocol = saa7134_ir_change_protocol;
 	}
 
-	err = ir_input_init(input_dev, &ir->ir, ir_type);
-	if (err < 0)
-		goto err_out_free;
-
 	input_dev->name = ir->name;
 	input_dev->phys = ir->phys;
 	input_dev->id.bustype = BUS_PCI;
@@ -1092,20 +1078,6 @@ static int saa7134_rc5_irq(struct saa7134_dev *dev)
 	return 1;
 }
 
-/* On NEC protocol, One has 2.25 ms, and zero has 1.125 ms
-   The first pulse (start) has 9 + 4.5 ms
- */
-
-static void saa7134_nec_timer(unsigned long data)
-{
-	struct saa7134_dev *dev = (struct saa7134_dev *) data;
-	struct card_ir *ir = dev->remote;
-
-	dprintk("Cancel key repeat\n");
-
-	ir_input_nokey(ir->dev, &ir->ir);
-}
-
 static void nec_task(unsigned long data)
 {
 	struct saa7134_dev *dev = (struct saa7134_dev *) data;
@@ -1194,12 +1166,11 @@ static void nec_task(unsigned long data)
 		dprintk("scancode = 0x%02x (code = 0x%02x, notcode= 0x%02x)\n",
 			 ir->code, ircode, not_code);
 
-		ir_input_keydown(ir->dev, &ir->ir, ir->code);
-	} else
+		ir_keydown(ir->dev, ir->code, 0);
+	} else {
 		dprintk("Repeat last key\n");
-
-	/* Keep repeating the last key */
-	mod_timer(&ir->timer_keyup, jiffies + msecs_to_jiffies(150));
+		ir_repeat(ir->dev);
+	}
 
 	saa_setl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO18_P);
 }
diff --git a/drivers/staging/tm6000/tm6000-input.c b/drivers/staging/tm6000/tm6000-input.c
index 6022caa..3e74884 100644
--- a/drivers/staging/tm6000/tm6000-input.c
+++ b/drivers/staging/tm6000/tm6000-input.c
@@ -25,7 +25,6 @@
 #include <linux/usb.h>
 
 #include <media/ir-core.h>
-#include <media/ir-common.h>
 
 #include "tm6000.h"
 #include "tm6000-regs.h"
@@ -52,7 +51,6 @@ struct tm6000_ir_poll_result {
 struct tm6000_IR {
 	struct tm6000_core	*dev;
 	struct ir_input_dev	*input;
-	struct ir_input_state	ir;
 	char			name[32];
 	char			phys[32];
 
@@ -67,6 +65,7 @@ struct tm6000_IR {
 	int (*get_key) (struct tm6000_IR *, struct tm6000_ir_poll_result *);
 
 	/* IR device properties */
+	u64			ir_type;
 	struct ir_dev_props	props;
 };
 
@@ -145,7 +144,7 @@ static int default_polling_getkey(struct tm6000_IR *ir,
 		return 0;
 
 	if (&dev->int_in) {
-		if (ir->ir.ir_type == IR_TYPE_RC5)
+		if (ir->ir_type == IR_TYPE_RC5)
 			poll_result->rc_data = ir->urb_data[0];
 		else
 			poll_result->rc_data = ir->urb_data[0] | ir->urb_data[1] << 8;
@@ -155,7 +154,7 @@ static int default_polling_getkey(struct tm6000_IR *ir,
 		tm6000_set_reg(dev, REQ_04_EN_DISABLE_MCU_INT, 2, 1);
 		msleep(10);
 
-		if (ir->ir.ir_type == IR_TYPE_RC5) {
+		if (ir->ir_type == IR_TYPE_RC5) {
 			rc = tm6000_read_write_usb(dev, USB_DIR_IN |
 				USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				REQ_02_GET_IR_CODE, 0, 0, buf, 1);
@@ -201,10 +200,7 @@ static void tm6000_ir_handle_key(struct tm6000_IR *ir)
 	dprintk("ir->get_key result data=%04x\n", poll_result.rc_data);
 
 	if (ir->key) {
-		ir_input_keydown(ir->input->input_dev, &ir->ir,
-				(u32)poll_result.rc_data);
-
-		ir_input_nokey(ir->input->input_dev, &ir->ir);
+		ir_keydown(ir->input->input_dev, poll_result.rc_data, 0);
 		ir->key = 0;
 	}
 	return;
@@ -291,9 +287,6 @@ int tm6000_ir_init(struct tm6000_core *dev)
 	strlcat(ir->phys, "/input0", sizeof(ir->phys));
 
 	tm6000_ir_change_protocol(ir, IR_TYPE_UNKNOWN);
-	err = ir_input_init(ir_input_dev->input_dev, &ir->ir, IR_TYPE_OTHER);
-	if (err < 0)
-		goto err_out_free;
 
 	ir_input_dev->input_dev->name = ir->name;
 	ir_input_dev->input_dev->phys = ir->phys;
diff --git a/include/media/ir-common.h b/include/media/ir-common.h
index 4152420..4a32e89 100644
--- a/include/media/ir-common.h
+++ b/include/media/ir-common.h
@@ -1,7 +1,7 @@
 /*
- *
- * some common structs and functions to handle infrared remotes via
- * input layer ...
+ * some common functions to handle infrared remote protocol decoding for
+ * drivers which have not yet been (or can't be) converted to use the
+ * regular protocol decoders...
  *
  * (c) 2003 Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]
  *
@@ -33,30 +33,17 @@
 #define RC5_ADDR(x)	(((x)>>6)&31)
 #define RC5_INSTR(x)	((x)&63)
 
-struct ir_input_state {
-	/* configuration */
-	u64      ir_type;
-
-	/* key info */
-	u32                ir_key;      /* ir scancode */
-	u32                keycode;     /* linux key code */
-	int                keypressed;  /* current state */
-};
-
 /* this was saa7134_ir and bttv_ir, moved here for
  * rc5 decoding. */
 struct card_ir {
 	struct input_dev        *dev;
-	struct ir_input_state   ir;
 	char                    name[32];
 	char                    phys[32];
 	int			users;
-
 	u32			running:1;
 	struct ir_dev_props	props;
 
 	/* Usual gpio signalling */
-
 	u32                     mask_keycode;
 	u32                     mask_keydown;
 	u32                     mask_keyup;
@@ -65,7 +52,6 @@ struct card_ir {
 	int			shift_by;
 	int			start; // What should RC5_START() be
 	int			addr; // What RC5_ADDR() should be.
-	int			rc5_key_timeout;
 	int			rc5_remote_gap;
 	struct work_struct      work;
 	struct timer_list       timer;
@@ -73,8 +59,6 @@ struct card_ir {
 	/* RC5 gpio */
 	u32 rc5_gpio;
 	struct timer_list timer_end;	/* timer_end for code completion */
-	struct timer_list timer_keyup;	/* timer_end for key release */
-	u32 last_rc5;			/* last good rc5 code */
 	u32 last_bit;			/* last raw bit seen */
 	u32 code;			/* raw code under construction */
 	struct timeval base_time;	/* time of last seen code */
@@ -89,16 +73,7 @@ struct card_ir {
 };
 
 /* Routines from ir-functions.c */
-
-int ir_input_init(struct input_dev *dev, struct ir_input_state *ir,
-		   const u64 ir_type);
-void ir_input_nokey(struct input_dev *dev, struct ir_input_state *ir);
-void ir_input_keydown(struct input_dev *dev, struct ir_input_state *ir,
-		      u32 ir_key);
 u32  ir_extract_bits(u32 data, u32 mask);
-u32  ir_rc5_decode(unsigned int code);
-
 void ir_rc5_timer_end(unsigned long data);
-void ir_rc5_timer_keyup(unsigned long data);
 
 #endif
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index 6dc37fa..bff75f2 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -159,7 +159,8 @@ void ir_input_unregister(struct input_dev *input_dev);
 
 void ir_repeat(struct input_dev *dev);
 void ir_keydown(struct input_dev *dev, int scancode, u8 toggle);
-void ir_keyup(struct ir_input_dev *ir);
+void ir_keydown_notimeout(struct input_dev *dev, int scancode, u8 toggle);
+void ir_keyup(struct input_dev *dev);
 u32 ir_g_keycode_from_table(struct input_dev *input_dev, u32 scancode);
 
 /* From ir-raw-event.c */
diff --git a/include/media/ir-kbd-i2c.h b/include/media/ir-kbd-i2c.h
index 557c676..8c37b5e 100644
--- a/include/media/ir-kbd-i2c.h
+++ b/include/media/ir-kbd-i2c.h
@@ -12,8 +12,7 @@ struct IR_i2c {
 
 	struct i2c_client      *c;
 	struct input_dev       *input;
-	struct ir_input_state  ir;
-	u64                    ir_type;
+
 	/* Used to avoid fast repeating */
 	unsigned char          old;
 
@@ -41,6 +40,7 @@ struct IR_i2c_init_data {
 	const char		*name;
 	u64			type; /* IR_TYPE_RC5, etc */
 	u32			polling_interval; /* 0 means DEFAULT_POLLING_INTERVAL */
+
 	/*
 	 * Specify either a function pointer or a value indicating one of
 	 * ir_kbd_i2c's internal get_key functions

