Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:50472 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933420Ab0HXXCM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Aug 2010 19:02:12 -0400
Subject: [PATCH 2/3] remove remaining users of the ir-functions keyhandlers
To: mchehab@infradead.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@redhat.com, linux-media@vger.kernel.org
Date: Wed, 25 Aug 2010 01:02:07 +0200
Message-ID: <20100824230207.13006.79909.stgit@localhost.localdomain>
In-Reply-To: <20100824225427.13006.57226.stgit@localhost.localdomain>
References: <20100824225427.13006.57226.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

This patch removes the remaining usages of the ir_input_nokey() and
ir_input_keydown() functions provided by drivers/media/IR/ir-functions.c
by using the corresponding functionality in rc-core directly instead.
---
 drivers/media/IR/ir-functions.c             |   96 ++---------------------
 drivers/media/IR/rc-core.c                  |  114 +++++++++++++++++++++------
 drivers/media/video/bt8xx/bttv-input.c      |   26 ++----
 drivers/media/video/bt8xx/bttvp.h           |    1 
 drivers/media/video/cx18/cx18-i2c.c         |    1 
 drivers/media/video/cx23885/cx23885-input.c |   59 +-------------
 drivers/media/video/cx88/cx88-input.c       |   24 ++----
 drivers/media/video/ir-kbd-i2c.c            |   14 ---
 drivers/media/video/ivtv/ivtv-i2c.c         |    3 -
 drivers/media/video/saa7134/saa7134-input.c |   50 ++----------
 include/media/ir-common.h                   |   29 +------
 include/media/ir-core.h                     |    2 
 include/media/ir-kbd-i2c.h                  |    3 -
 13 files changed, 131 insertions(+), 291 deletions(-)

diff --git a/drivers/media/IR/ir-functions.c b/drivers/media/IR/ir-functions.c
index db591e4..77faf7a 100644
--- a/drivers/media/IR/ir-functions.c
+++ b/drivers/media/IR/ir-functions.c
@@ -1,7 +1,8 @@
 /*
  *
- * some common structs and functions to handle infrared remotes via
- * input layer ...
+ * some common functions to handle infrared remote protocol decoding for
+ * drivers which have not yet been (or can't be) converted to use the
+ * regular protocol decoders...
  *
  * (c) 2003 Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]
  *
@@ -31,67 +32,6 @@
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
@@ -284,7 +224,7 @@ void ir_rc5_timer_end(unsigned long data)
 {
 	struct card_ir *ir = (struct card_ir *)data;
 	struct timeval tv;
-	unsigned long current_jiffies, timeout;
+	unsigned long current_jiffies;
 	u32 gap;
 	u32 rc5 = 0;
 
@@ -325,32 +265,12 @@ void ir_rc5_timer_end(unsigned long data)
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
+			IR_dprintk(1, "ir-common: instruction %x, toggle %x\n", instr,
+				   toggle);
 		}
 	}
 }
 EXPORT_SYMBOL_GPL(ir_rc5_timer_end);
 
-void ir_rc5_timer_keyup(unsigned long data)
-{
-	struct card_ir *ir = (struct card_ir *)data;
-
-	IR_dprintk(1, "ir-common: key released\n");
-	ir_input_nokey(ir->dev, &ir->ir);
-}
-EXPORT_SYMBOL_GPL(ir_rc5_timer_keyup);
diff --git a/drivers/media/IR/rc-core.c b/drivers/media/IR/rc-core.c
index 0d67933..8699e15 100644
--- a/drivers/media/IR/rc-core.c
+++ b/drivers/media/IR/rc-core.c
@@ -600,13 +600,13 @@ u32 ir_g_keycode_from_table(struct input_dev *dev, u32 scancode)
 EXPORT_SYMBOL_GPL(ir_g_keycode_from_table);
 
 /**
- * ir_keyup() - generates input event to cleanup a key press
- * @ir:         the struct ir_input_dev descriptor of the device
+ * ir_do_keyup() - internal function to signal the release of a keypress
+ * @ir:		the struct ir_input_dev descriptor of the device
  *
- * This routine is used to signal that a key has been released on the
- * remote control. It reports a keyup input event via input_report_key().
+ * This function is used internally to release a keypress, it must be
+ * called with keylock held.
  */
-static void ir_keyup(struct ir_input_dev *ir)
+static void ir_do_keyup(struct ir_input_dev *ir)
 {
 	if (!ir->keypressed)
 		return;
@@ -618,6 +618,24 @@ static void ir_keyup(struct ir_input_dev *ir)
 }
 
 /**
+ * ir_keyup() - generates input event to signal the release of a keypress
+ * @dev:	the struct input_dev descriptor of the device
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
+EXPORT_SYMBOL_GPL(ir_keyup);
+
+/**
  * ir_timer_keyup() - generates a keyup event after a timeout
  * @cookie:     a pointer to struct ir_input_dev passed to setup_timer()
  *
@@ -641,7 +659,7 @@ static void ir_timer_keyup(unsigned long cookie)
 	 */
 	spin_lock_irqsave(&ir->keylock, flags);
 	if (time_is_after_eq_jiffies(ir->keyup_jiffies))
-		ir_keyup(ir);
+		ir_do_keyup(ir);
 	spin_unlock_irqrestore(&ir->keylock, flags);
 }
 
@@ -672,40 +690,35 @@ out:
 EXPORT_SYMBOL_GPL(ir_repeat);
 
 /**
- * ir_keydown() - generates input event for a key press
- * @dev:        the struct input_dev descriptor of the device
- * @scancode:   the scancode that we're seeking
- * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
- *              support toggle values, this should be set to zero)
+ * ir_do_keydown() - internal function to process a keypress
+ * @dev:       the struct input_dev descriptor of the device
+ * @scancode:  the scancode of the keypress
+ * @keycode:   the keycode of the keypress
+ * @toggle:    the toggle value of the keypress
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
 
 	if (keycode == KEY_RESERVED)
-		goto out;
+		return;
 
 	/* Register a keypress */
 	ir->keypressed = true;
@@ -713,15 +726,62 @@ void ir_keydown(struct input_dev *dev, int scancode, u8 toggle)
 		   dev->name, keycode, scancode);
 	input_report_key(dev, ir->last_keycode, 1);
 	input_sync(dev);
+}
+
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
 
-set_timer:
-	ir->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
-	mod_timer(&ir->timer_keyup, ir->keyup_jiffies);
-out:
 	spin_unlock_irqrestore(&ir->keylock, flags);
 }
 EXPORT_SYMBOL_GPL(ir_keydown);
 
+/**
+ * ir_keydown_notimeout() - generates input event for a key press without
+ *                          an automatic keyup event at a later time
+ * @dev:	the struct input_dev descriptor of the device
+ * @scancode:	the scancode that we're seeking
+ * @toggle:	the toggle value (protocol dependent, if the protocol doesn't
+ *		support toggle values, this should be set to zero)
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
index f68717a..1d93a73 100644
--- a/drivers/media/video/bt8xx/bttv-input.c
+++ b/drivers/media/video/bt8xx/bttv-input.c
@@ -38,8 +38,6 @@ module_param(repeat_period, int, 0644);
 
 static int ir_rc5_remote_gap = 885;
 module_param(ir_rc5_remote_gap, int, 0644);
-static int ir_rc5_key_timeout = 200;
-module_param(ir_rc5_key_timeout, int, 0644);
 
 #undef dprintk
 #define dprintk(arg...) do {	\
@@ -76,14 +74,14 @@ static void ir_handle_key(struct bttv *btv)
 
 	if ((ir->mask_keydown  &&  (0 != (gpio & ir->mask_keydown))) ||
 	    (ir->mask_keyup    &&  (0 == (gpio & ir->mask_keyup)))) {
-		ir_input_keydown(ir->dev, &ir->ir, data);
+		ir_keydown_notimeout(ir->dev, data, 0);
 	} else {
 		/* HACK: Probably, ir->mask_keydown is missing
 		   for this board */
 		if (btv->c.type == BTTV_BOARD_WINFAST2000)
-			ir_input_keydown(ir->dev, &ir->ir, data);
+			ir_keydown(ir->dev, data, 0);
 
-		ir_input_nokey(ir->dev,&ir->ir);
+		ir_keyup(ir->dev);
 	}
 
 }
@@ -107,9 +105,9 @@ static void ir_enltv_handle_key(struct bttv *btv)
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
@@ -119,9 +117,9 @@ static void ir_enltv_handle_key(struct bttv *btv)
 			(gpio & ir->mask_keyup) ? " up" : "down");
 
 		if (keyup)
-			ir_input_nokey(ir->dev, &ir->ir);
+			ir_keyup(ir->dev);
 		else
-			ir_input_keydown(ir->dev, &ir->ir, data);
+			ir_keydown_notimeout(ir->dev, data, 0);
 	}
 
 	ir->last_gpio = data | keyup;
@@ -215,14 +213,9 @@ static void bttv_ir_start(struct bttv *btv, struct card_ir *ir)
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
@@ -250,7 +243,6 @@ int bttv_input_init(struct bttv *btv)
 	struct card_ir *ir;
 	char *ir_codes = NULL;
 	struct input_dev *input_dev;
-	u64 ir_type = IR_TYPE_OTHER;
 	int err = -ENOMEM;
 
 	if (!btv->has_remote)
@@ -371,10 +363,6 @@ int bttv_input_init(struct bttv *btv)
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
index 6cccc2a..9e9613f 100644
--- a/drivers/media/video/bt8xx/bttvp.h
+++ b/drivers/media/video/bt8xx/bttvp.h
@@ -301,7 +301,6 @@ struct bttv_pll_info {
 /* for gpio-connected remote control */
 struct bttv_input {
 	struct input_dev      *dev;
-	struct ir_input_state ir;
 	char                  name[32];
 	char                  phys[32];
 	u32                   mask_keycode;
diff --git a/drivers/media/video/cx18/cx18-i2c.c b/drivers/media/video/cx18/cx18-i2c.c
index cfa1f28..9f4f644 100644
--- a/drivers/media/video/cx18/cx18-i2c.c
+++ b/drivers/media/video/cx18/cx18-i2c.c
@@ -111,7 +111,6 @@ static int cx18_i2c_new_ir(struct cx18 *cx, struct i2c_adapter *adap, u32 hw,
 	case CX18_HW_Z8F0811_IR_RX_HAUP:
 		init_data->ir_codes = RC_MAP_HAUPPAUGE_NEW;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
-		init_data->type = IR_TYPE_RC5;
 		init_data->name = cx->card_name;
 		info.platform_data = init_data;
 		break;
diff --git a/drivers/media/video/cx23885/cx23885-input.c b/drivers/media/video/cx23885/cx23885-input.c
index 8d306d8..444251b 100644
--- a/drivers/media/video/cx23885/cx23885-input.c
+++ b/drivers/media/video/cx23885/cx23885-input.c
@@ -63,7 +63,7 @@ static inline unsigned int rc5_command(u32 rc5_baseband)
 static void cx23885_input_process_raw_rc5(struct cx23885_dev *dev)
 {
 	struct card_ir *ir_input = dev->ir_input;
-	unsigned int code, command;
+	unsigned int code;
 	u32 rc5;
 
 	/* Ignore codes that are too short to be valid RC-5 */
@@ -89,21 +89,7 @@ static void cx23885_input_process_raw_rc5(struct cx23885_dev *dev)
 	if (ir_input->addr != RC5_ADDR(rc5))
 		return;
 
-	/* Don't generate a keypress for RC-5 auto-repeated keypresses */
-	command = rc5_command(rc5);
-	if (RC5_TOGGLE(rc5) != RC5_TOGGLE(ir_input->last_rc5) ||
-	    command != rc5_command(ir_input->last_rc5) ||
-	    /* Catch T == 0, CMD == 0 (e.g. '0') as first keypress after init */
-	    RC5_START(ir_input->last_rc5) == 0) {
-		/* This keypress is differnet: not an auto repeat */
-		ir_input_nokey(ir_input->dev, &ir_input->ir);
-		ir_input_keydown(ir_input->dev, &ir_input->ir, command);
-	}
-	ir_input->last_rc5 = rc5;
-
-	/* Schedule when we should do the key up event: ir_input_nokey() */
-	mod_timer(&ir_input->timer_keyup,
-		  jiffies + msecs_to_jiffies(ir_input->rc5_key_timeout));
+	ir_keydown(ir_input->dev, rc5_command(rc5), RC5_TOGGLE(rc5));
 }
 
 static void cx23885_input_next_pulse_width_rc5(struct cx23885_dev *dev,
@@ -166,9 +152,6 @@ static void cx23885_input_next_pulse_width_rc5(struct cx23885_dev *dev,
 static void cx23885_input_process_pulse_widths_rc5(struct cx23885_dev *dev,
 						   bool add_eom)
 {
-	struct card_ir *ir_input = dev->ir_input;
-	struct ir_input_state *ir_input_state = &ir_input->ir;
-
 	u32 ns_pulse[RC5_HALF_BITS+1];
 	ssize_t num = 0;
 	int count, i;
@@ -185,10 +168,6 @@ static void cx23885_input_process_pulse_widths_rc5(struct cx23885_dev *dev,
 			count++;
 		}
 
-		/* Just drain the Rx FIFO, if we're called, but not RC-5 */
-		if (ir_input_state->ir_type != IR_TYPE_RC5)
-			continue;
-
 		for (i = 0; i < count; i++)
 			cx23885_input_next_pulse_width_rc5(dev, ns_pulse[i]);
 	} while (num != 0);
@@ -243,8 +222,6 @@ void cx23885_input_rx_work_handler(struct cx23885_dev *dev, u32 events)
 
 static void cx23885_input_ir_start(struct cx23885_dev *dev)
 {
-	struct card_ir *ir_input = dev->ir_input;
-	struct ir_input_state *ir_input_state = &ir_input->ir;
 	struct v4l2_subdev_ir_parameters params;
 
 	if (dev->sd_ir == NULL)
@@ -252,23 +229,6 @@ static void cx23885_input_ir_start(struct cx23885_dev *dev)
 
 	atomic_set(&dev->ir_input_stopping, 0);
 
-	/* keyup timer set up, if needed */
-	switch (dev->board) {
-	case CX23885_BOARD_HAUPPAUGE_HVR1850:
-	case CX23885_BOARD_HAUPPAUGE_HVR1290:
-		setup_timer(&ir_input->timer_keyup,
-			    ir_rc5_timer_keyup,	/* Not actually RC-5 specific */
-			    (unsigned long) ir_input);
-		if (ir_input_state->ir_type == IR_TYPE_RC5) {
-			/*
-			 * RC-5 repeats a held key every
-			 * 64 bits * (2 * 32/36000) sec/bit = 113.778 ms
-			 */
-			ir_input->rc5_key_timeout = 115;
-		}
-		break;
-	}
-
 	v4l2_subdev_call(dev->sd_ir, ir, rx_g_parameters, &params);
 	switch (dev->board) {
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
@@ -303,7 +263,6 @@ static void cx23885_input_ir_start(struct cx23885_dev *dev)
 
 static void cx23885_input_ir_stop(struct cx23885_dev *dev)
 {
-	struct card_ir *ir_input = dev->ir_input;
 	struct v4l2_subdev_ir_parameters params;
 
 	if (dev->sd_ir == NULL)
@@ -327,13 +286,6 @@ static void cx23885_input_ir_stop(struct cx23885_dev *dev)
 	}
 
 	flush_scheduled_work();
-
-	switch (dev->board) {
-	case CX23885_BOARD_HAUPPAUGE_HVR1850:
-	case CX23885_BOARD_HAUPPAUGE_HVR1290:
-		del_timer_sync(&ir_input->timer_keyup);
-		break;
-	}
 }
 
 int cx23885_input_init(struct cx23885_dev *dev)
@@ -341,7 +293,7 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	struct card_ir *ir;
 	struct input_dev *input_dev;
 	char *ir_codes = NULL;
-	int ir_type, ir_addr, ir_start;
+	int ir_addr, ir_start;
 	int ret;
 
 	/*
@@ -356,7 +308,6 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
 		/* Parameters for the grey Hauppauge remote for the HVR-1850 */
 		ir_codes = RC_MAP_HAUPPAUGE_NEW;
-		ir_type = IR_TYPE_RC5;
 		ir_addr = 0x1e; /* RC-5 system bits emitted by the remote */
 		ir_start = RC5_START_BITS_NORMAL; /* A basic RC-5 remote */
 		break;
@@ -380,10 +331,6 @@ int cx23885_input_init(struct cx23885_dev *dev)
 		 cx23885_boards[dev->board].name);
 	snprintf(ir->phys, sizeof(ir->phys), "pci-%s/ir0", pci_name(dev->pci));
 
-	ret = ir_input_init(input_dev, &ir->ir, ir_type);
-	if (ret < 0)
-		goto err_out_free;
-
 	input_dev->name = ir->name;
 	input_dev->phys = ir->phys;
 	input_dev->id.bustype = BUS_PCI;
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index eccc5e4..45cf079 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -41,7 +41,6 @@ struct cx88_IR {
 	struct cx88_core *core;
 	struct input_dev *input;
 	struct ir_dev_props props;
-	u64 ir_type;
 
 	int users;
 
@@ -125,21 +124,27 @@ static void cx88_ir_handle_key(struct cx88_IR *ir)
 
 		data = (data << 4) | ((gpio_key & 0xf0) >> 4);
 
-		ir_keydown(ir->input, data, 0);
+		ir_keydown_notimeout(ir->input, data, 0);
+		ir_keyup(ir->input);
 
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
 
@@ -238,7 +243,6 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	struct cx88_IR *ir;
 	struct input_dev *input_dev;
 	char *ir_codes = NULL;
-	u64 ir_type = IR_TYPE_OTHER;
 	int err = -ENOMEM;
 	u32 hardware_mask = 0;	/* For devices with a hardware mask, when
 				 * used with a full-code IR table
@@ -264,7 +268,6 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		break;
 	case CX88_BOARD_TERRATEC_CINERGY_1400_DVB_T1:
 		ir_codes = RC_MAP_CINERGY_1400;
-		ir_type = IR_TYPE_NEC;
 		ir->sampling = 0xeb04; /* address */
 		break;
 	case CX88_BOARD_HAUPPAUGE:
@@ -279,7 +282,6 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	case CX88_BOARD_PCHDTV_HD5500:
 	case CX88_BOARD_HAUPPAUGE_IRONLY:
 		ir_codes = RC_MAP_HAUPPAUGE_NEW;
-		ir_type = IR_TYPE_RC5;
 		ir->sampling = 1;
 		break;
 	case CX88_BOARD_WINFAST_DTV2000H:
@@ -367,18 +369,15 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	case CX88_BOARD_PROF_7301:
 	case CX88_BOARD_PROF_6200:
 		ir_codes = RC_MAP_TBS_NEC;
-		ir_type = IR_TYPE_NEC;
 		ir->sampling = 0xff00; /* address */
 		break;
 	case CX88_BOARD_TEVII_S460:
 	case CX88_BOARD_TEVII_S420:
 		ir_codes = RC_MAP_TEVII_NEC;
-		ir_type = IR_TYPE_NEC;
 		ir->sampling = 0xff00; /* address */
 		break;
 	case CX88_BOARD_DNTV_LIVE_DVB_T_PRO:
 		ir_codes         = RC_MAP_DNTV_LIVE_DVBT_PRO;
-		ir_type          = IR_TYPE_NEC;
 		ir->sampling     = 0xff00; /* address */
 		break;
 	case CX88_BOARD_NORWOOD_MICRO:
@@ -396,7 +395,6 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		break;
 	case CX88_BOARD_PINNACLE_PCTV_HD_800i:
 		ir_codes         = RC_MAP_PINNACLE_PCTV_HD;
-		ir_type          = IR_TYPE_RC5;
 		ir->sampling     = 1;
 		break;
 	case CX88_BOARD_POWERCOLOR_REAL_ANGEL:
@@ -431,8 +429,6 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	snprintf(ir->name, sizeof(ir->name), "cx88 IR (%s)", core->board.name);
 	snprintf(ir->phys, sizeof(ir->phys), "pci-%s/ir0", pci_name(pci));
 
-	ir->ir_type = ir_type;
-
 	input_dev->name = ir->name;
 	input_dev->phys = ir->phys;
 	input_dev->id.bustype = BUS_PCI;
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index 27ae8bb..edd414d 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -296,7 +296,6 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	char *ir_codes = NULL;
 	const char *name = NULL;
-	u64 ir_type = 0;
 	struct IR_i2c *ir;
 	struct input_dev *input_dev;
 	struct i2c_adapter *adap = client->adapter;
@@ -318,13 +317,11 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	case 0x64:
 		name        = "Pixelview";
 		ir->get_key = get_key_pixelview;
-		ir_type     = IR_TYPE_OTHER;
 		ir_codes    = RC_MAP_EMPTY;
 		break;
 	case 0x4b:
 		name        = "PV951";
 		ir->get_key = get_key_pv951;
-		ir_type     = IR_TYPE_OTHER;
 		ir_codes    = RC_MAP_PV951;
 		break;
 	case 0x18:
@@ -332,7 +329,6 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	case 0x1a:
 		name        = "Hauppauge";
 		ir->get_key = get_key_haup;
-		ir_type     = IR_TYPE_RC5;
 		if (hauppauge == 1) {
 			ir_codes    = RC_MAP_HAUPPAUGE_NEW;
 		} else {
@@ -342,13 +338,11 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	case 0x30:
 		name        = "KNC One";
 		ir->get_key = get_key_knc1;
-		ir_type     = IR_TYPE_OTHER;
 		ir_codes    = RC_MAP_EMPTY;
 		break;
 	case 0x6b:
 		name        = "FusionHDTV";
 		ir->get_key = get_key_fusionhdtv;
-		ir_type     = IR_TYPE_RC5;
 		ir_codes    = RC_MAP_FUSIONHDTV_MCE;
 		break;
 	case 0x0b:
@@ -359,7 +353,6 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 			/* Handled by cx88-input */
 			name = adap->id == I2C_HW_B_CX2341X ? "CX2341x remote"
 							    : "CX2388x remote";
-			ir_type     = IR_TYPE_RC5;
 			ir->get_key = get_key_haup_xvr;
 			if (hauppauge == 1) {
 				ir_codes    = RC_MAP_HAUPPAUGE_NEW;
@@ -369,13 +362,11 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		} else {
 			/* Handled by saa7134-input */
 			name        = "SAA713x remote";
-			ir_type     = IR_TYPE_OTHER;
 		}
 		break;
 	case 0x40:
 		name        = "AVerMedia Cardbus remote";
 		ir->get_key = get_key_avermedia_cardbus;
-		ir_type     = IR_TYPE_OTHER;
 		ir_codes    = RC_MAP_AVERMEDIA_CARDBUS;
 		break;
 	}
@@ -387,8 +378,6 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 		ir_codes = init_data->ir_codes;
 		name = init_data->name;
-		if (init_data->type)
-			ir_type = init_data->type;
 
 		switch (init_data->internal_get_key_func) {
 		case IR_KBD_GET_KEY_CUSTOM:
@@ -420,7 +409,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	}
 
 	/* Make sure we are all setup before going on */
-	if (!name || !ir->get_key || !ir_type || !ir_codes) {
+	if (!name || !ir->get_key || !ir_codes) {
 		dprintk(1, ": Unsupported device at address 0x%02x\n",
 			addr);
 		err = -ENODEV;
@@ -436,7 +425,6 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		 dev_name(&client->dev));
 
 	/* init + register input device */
-	ir->ir_type = ir_type;
 	input_dev->id.bustype = BUS_I2C;
 	input_dev->name       = ir->name;
 	input_dev->phys       = ir->phys;
diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
index a5b92d1..fdd79e0 100644
--- a/drivers/media/video/ivtv/ivtv-i2c.c
+++ b/drivers/media/video/ivtv/ivtv-i2c.c
@@ -196,7 +196,6 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
 		init_data->ir_codes = RC_MAP_AVERMEDIA_CARDBUS;
 		init_data->internal_get_key_func =
 					IR_KBD_GET_KEY_AVERMEDIA_CARDBUS;
-		init_data->type = IR_TYPE_OTHER;
 		init_data->name = "AVerMedia AVerTV card";
 		break;
 	case IVTV_HW_I2C_IR_RX_HAUP_EXT:
@@ -204,14 +203,12 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
 		/* Default to old black remote */
 		init_data->ir_codes = RC_MAP_RC5_TV;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP;
-		init_data->type = IR_TYPE_RC5;
 		init_data->name = itv->card_name;
 		break;
 	case IVTV_HW_Z8F0811_IR_RX_HAUP:
 		/* Default to grey remote */
 		init_data->ir_codes = RC_MAP_HAUPPAUGE_NEW;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
-		init_data->type = IR_TYPE_RC5;
 		init_data->name = itv->card_name;
 		break;
 	}
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index e5565e2..866f9d3 100644
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
@@ -863,10 +853,6 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		ir->props.change_protocol = saa7134_ir_change_protocol;
 	}
 
-	err = ir_input_init(input_dev, &ir->ir, ir_type);
-	if (err < 0)
-		goto err_out_free;
-
 	input_dev->name = ir->name;
 	input_dev->phys = ir->phys;
 	input_dev->id.bustype = BUS_PCI;
@@ -987,7 +973,6 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 		dev->init_data.name = "BeholdTV";
 		dev->init_data.get_key = get_key_beholdm6xx;
 		dev->init_data.ir_codes = RC_MAP_BEHOLD;
-		dev->init_data.type = IR_TYPE_NEC;
 		info.addr = 0x2d;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_501:
@@ -1079,20 +1064,6 @@ static int saa7134_rc5_irq(struct saa7134_dev *dev)
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
@@ -1181,12 +1152,11 @@ static void nec_task(unsigned long data)
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
diff --git a/include/media/ir-common.h b/include/media/ir-common.h
index 528050e..6391cea 100644
--- a/include/media/ir-common.h
+++ b/include/media/ir-common.h
@@ -1,7 +1,8 @@
 /*
  *
- * some common structs and functions to handle infrared remotes via
- * input layer ...
+ * some common functions to handle infrared remote protocol decoding for
+ * drivers which have not yet been (or can't be) converted to use the
+ * regular protocol decoders...
  *
  * (c) 2003 Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]
  *
@@ -33,30 +34,17 @@
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
@@ -65,7 +53,6 @@ struct card_ir {
 	int			shift_by;
 	int			start; // What should RC5_START() be
 	int			addr; // What RC5_ADDR() should be.
-	int			rc5_key_timeout;
 	int			rc5_remote_gap;
 	struct work_struct      work;
 	struct timer_list       timer;
@@ -73,8 +60,6 @@ struct card_ir {
 	/* RC5 gpio */
 	u32 rc5_gpio;
 	struct timer_list timer_end;	/* timer_end for code completion */
-	struct timer_list timer_keyup;	/* timer_end for key release */
-	u32 last_rc5;			/* last good rc5 code */
 	u32 last_bit;			/* last raw bit seen */
 	u32 code;			/* raw code under construction */
 	struct timeval base_time;	/* time of last seen code */
@@ -89,19 +74,11 @@ struct card_ir {
 };
 
 /* Routines from ir-functions.c */
-
-int ir_input_init(struct input_dev *dev, struct ir_input_state *ir,
-		   const u64 ir_type);
-void ir_input_nokey(struct input_dev *dev, struct ir_input_state *ir);
-void ir_input_keydown(struct input_dev *dev, struct ir_input_state *ir,
-		      u32 ir_key);
 u32  ir_extract_bits(u32 data, u32 mask);
 int  ir_dump_samples(u32 *samples, int count);
 int  ir_decode_biphase(u32 *samples, int count, int low, int high);
 int  ir_decode_pulsedistance(u32 *samples, int count, int low, int high);
 u32  ir_rc5_decode(unsigned int code);
-
 void ir_rc5_timer_end(unsigned long data);
-void ir_rc5_timer_keyup(unsigned long data);
 
 #endif
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index 27ad6a2..86fc95e 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -128,7 +128,9 @@ static inline int ir_input_register(struct input_dev *dev,
 void ir_input_unregister(struct input_dev *input_dev);
 
 void ir_repeat(struct input_dev *dev);
+void ir_keyup(struct input_dev *dev);
 void ir_keydown(struct input_dev *dev, int scancode, u8 toggle);
+void ir_keydown_notimeout(struct input_dev *dev, int scancode, u8 toggle);
 u32 ir_g_keycode_from_table(struct input_dev *input_dev, u32 scancode);
 
 struct ir_raw_event {
diff --git a/include/media/ir-kbd-i2c.h b/include/media/ir-kbd-i2c.h
index 5e96d7a..328ca88 100644
--- a/include/media/ir-kbd-i2c.h
+++ b/include/media/ir-kbd-i2c.h
@@ -10,8 +10,6 @@ struct IR_i2c {
 
 	struct i2c_client      *c;
 	struct input_dev       *input;
-	struct ir_input_state  ir;
-	u64                    ir_type;
 	/* Used to avoid fast repeating */
 	unsigned char          old;
 
@@ -36,7 +34,6 @@ enum ir_kbd_get_key_fn {
 struct IR_i2c_init_data {
 	char			*ir_codes;
 	const char             *name;
-	u64          type; /* IR_TYPE_RC5, etc */
 	/*
 	 * Specify either a function pointer or a value indicating one of
 	 * ir_kbd_i2c's internal get_key functions

