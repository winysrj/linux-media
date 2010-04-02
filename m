Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:49050 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab0DBTDB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Apr 2010 15:03:01 -0400
Message-Id: <20100402190255.626698934@hardeman.nu>
Date: Fri, 02 Apr 2010 20:58:29 +0200
From: david@hardeman.nu
To: mchehab@infradead.org
Cc: linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: [patch 2/3] [PATCH] drivers/media/IR - improve keyup/keydown logic
References: <20100402185827.425741206@hardeman.nu>
Content-Disposition: inline; filename=improve-keyup-keydown-logic.patch
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The attached patch rewrites the keyup/keydown logic in
drivers/media/IR/ir-keytable.c.

(applies to http://git.linuxtv.org/mchehab/ir.git)

All knowledge of keystates etc is now internal to ir-keytable.c
and not scattered around ir-raw-event.c and ir-nec-decoder.c (where
it doesn't belong).

In addition, I've changed the API slightly so that ir_input_dev is
passed as the first argument rather than input_dev. If we're ever
going to support multiple keytables we need to move towards making
ir_input_dev the main interface from a driver POV and obscure away
the input_dev as an implementational detail in ir-core.

Mauro, once this patch is merged I'll start working on patches to
migrate drivers which use ir_input_* in ir-functions.c over to
the ir-keytable.c code instead.

Changes since last version:
Clarify a comment
Refreshed to apply on top of previous patch
Let the new functions take input_dev as their main argument
(as there's no agreement on this point yet)

Signed-off-by: David Härdeman <david@hardeman.nu>

Index: ir/drivers/media/IR/ir-keytable.c
===================================================================
--- ir.orig/drivers/media/IR/ir-keytable.c	2010-04-02 12:32:13.015233729 +0200
+++ ir/drivers/media/IR/ir-keytable.c	2010-04-02 16:40:37.908276737 +0200
@@ -20,6 +20,9 @@
 #define IR_TAB_MIN_SIZE	256
 #define IR_TAB_MAX_SIZE	8192
 
+/* FIXME: IR_KEYPRESS_TIMEOUT should be protocol specific */
+#define IR_KEYPRESS_TIMEOUT 250
+
 /**
  * ir_resize_table() - resizes a scancode table if necessary
  * @rc_tab:	the ir_scancode_table to resize
@@ -250,56 +253,124 @@
 
 /**
  * ir_keyup() - generates input event to cleanup a key press
- * @input_dev:	the struct input_dev descriptor of the device
+ * @ir:		the struct ir_input_dev descriptor of the device
  *
- * This routine is used by the input routines when a key is pressed at the
- * IR. It reports a keyup input event via input_report_key().
+ * This routine is used to signal that a key has been released on the
+ * remote control. It reports a keyup input event via input_report_key().
  */
-void ir_keyup(struct input_dev *dev)
+static void ir_keyup(struct ir_input_dev *ir)
 {
-	struct ir_input_dev *ir = input_get_drvdata(dev);
-
 	if (!ir->keypressed)
 		return;
 	
-	IR_dprintk(1, "keyup key 0x%04x\n", ir->keycode);
-	input_report_key(dev, ir->keycode, 0);
-	input_sync(dev);
-	ir->keypressed = 0;
+	IR_dprintk(1, "keyup key 0x%04x\n", ir->last_keycode);
+	input_report_key(ir->input_dev, ir->last_keycode, 0);
+	input_sync(ir->input_dev);
+	ir->keypressed = false;
+}
+
+/**
+ * ir_timer_keyup() - generates a keyup event after a timeout
+ * @cookie:	a pointer to struct ir_input_dev passed to setup_timer()
+ *
+ * This routine will generate a keyup event some time after a keydown event
+ * is generated when no further activity has been detected.
+ */
+static void ir_timer_keyup(unsigned long cookie)
+{
+	struct ir_input_dev *ir = (struct ir_input_dev *)cookie;
+	unsigned long flags;
+
+	/*
+	 * ir->keyup_jiffies is used to prevent a race condition if a
+	 * hardware interrupt occurs at this point and the keyup timer
+	 * event is moved further into the future as a result.
+	 *
+	 * The timer will then be reactivated and this function called
+	 * again in the future. We need to exit gracefully in that case
+	 * to allow the input subsystem to do its auto-repeat magic or
+	 * a keyup event might follow immediately after the keydown.
+	 */
+	spin_lock_irqsave(&ir->keylock, flags);
+	if (time_is_after_eq_jiffies(ir->keyup_jiffies))
+		ir_keyup(ir);
+	spin_unlock_irqrestore(&ir->keylock, flags);
+}
+
+/**
+ * ir_repeat() - notifies the IR core that a key is still pressed
+ * @dev:	the struct input_dev descriptor of the device
+ *
+ * This routine is used by IR decoders when a repeat message which does
+ * not include the necessary bits to reproduce the scancode has been
+ * received.
+ */
+void ir_repeat(struct input_dev *dev)
+{
+	unsigned long flags;
+	struct ir_input_dev *ir = input_get_drvdata(dev);
+
+	spin_lock_irqsave(&ir->keylock, flags);
+
+	if (!ir->keypressed)
+		goto out;
+
+	ir->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
+	mod_timer(&ir->timer_keyup, ir->keyup_jiffies);
+
+out:
+	spin_unlock_irqrestore(&ir->keylock, flags);
 }
-EXPORT_SYMBOL_GPL(ir_keyup);
+EXPORT_SYMBOL_GPL(ir_repeat);
 
 /**
  * ir_keydown() - generates input event for a key press
- * @input_dev:	the struct input_dev descriptor of the device
+ * @dev:	the struct input_dev descriptor of the device
  * @scancode:	the scancode that we're seeking
+ * @toggle:	the toggle value (protocol dependent, if the protocol doesn't
+ *		support toggle values, this should be set to zero)
  *
  * This routine is used by the input routines when a key is pressed at the
  * IR. It gets the keycode for a scancode and reports an input event via
  * input_report_key().
  */
-void ir_keydown(struct input_dev *dev, int scancode)
+void ir_keydown(struct input_dev *dev, int scancode, u8 toggle)
 {
+	unsigned long flags;
 	struct ir_input_dev *ir = input_get_drvdata(dev);
 
 	u32 keycode = ir_g_keycode_from_table(dev, scancode);
 
-	/* If already sent a keydown, do a keyup */
-	if (ir->keypressed)
-		ir_keyup(dev);
+	spin_lock_irqsave(&ir->keylock, flags);
 
-	if (KEY_RESERVED == keycode)
-		return;
+	/* Repeat event? */
+	if (ir->keypressed &&
+	    ir->last_scancode == scancode &&
+	    ir->last_toggle == toggle)
+		goto set_timer;
+
+	/* Release old keypress */
+	ir_keyup(ir);
+
+	ir->last_scancode = scancode;
+	ir->last_toggle = toggle;
+	ir->last_keycode = keycode;
 
-	ir->keycode = keycode;
-	ir->keypressed = 1;
+	if (keycode == KEY_RESERVED)
+		goto out;
 
+	/* Register a keypress */
+	ir->keypressed = true;
 	IR_dprintk(1, "%s: key down event, key 0x%04x, scancode 0x%04x\n",
-		dev->name, keycode, scancode);
-
-	input_report_key(dev, ir->keycode, 1);
+		   dev->name, keycode, scancode);
+	input_report_key(dev, ir->last_keycode, 1);
 	input_sync(dev);
-	
+
+set_timer:
+	ir->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
+	mod_timer(&ir->timer_keyup, ir->keyup_jiffies);
+out:
+	spin_unlock_irqrestore(&ir->keylock, flags);
 }
 EXPORT_SYMBOL_GPL(ir_keydown);
 
@@ -352,8 +423,12 @@
 	input_dev->getkeycode = ir_getkeycode;
 	input_dev->setkeycode = ir_setkeycode;
 	input_set_drvdata(input_dev, ir_dev);
+	ir_dev->input_dev = input_dev;
 
 	spin_lock_init(&ir_dev->rc_tab.lock);
+	spin_lock_init(&ir_dev->keylock);
+	setup_timer(&ir_dev->timer_keyup, ir_timer_keyup, (unsigned long)ir_dev);
+
 	ir_dev->rc_tab.name = rc_tab->name;
 	ir_dev->rc_tab.ir_type = rc_tab->ir_type;
 	ir_dev->rc_tab.alloc = roundup_pow_of_two(rc_tab->len *
@@ -370,6 +445,8 @@
 		   ir_dev->rc_tab.size, ir_dev->rc_tab.alloc);
 
 	set_bit(EV_KEY, input_dev->evbit);
+	set_bit(EV_REP, input_dev->evbit);
+
 	if (ir_setkeytable(input_dev, &ir_dev->rc_tab, rc_tab)) {
 		rc = -ENOMEM;
 		goto out_table;
@@ -412,7 +489,7 @@
 		return;
 
 	IR_dprintk(1, "Freed keycode table\n");
-
+	del_timer_sync(&ir_dev->timer_keyup);
 	rc_tab = &ir_dev->rc_tab;
 	rc_tab->size = 0;
 	kfree(rc_tab->scan);
Index: ir/drivers/media/IR/ir-nec-decoder.c
===================================================================
--- ir.orig/drivers/media/IR/ir-nec-decoder.c	2010-04-02 12:22:50.872195298 +0200
+++ ir/drivers/media/IR/ir-nec-decoder.c	2010-04-02 16:34:32.531192323 +0200
@@ -179,8 +179,7 @@
 	if (is_repeat(evs, len, *pos)) {
 		*pos += 2;
 		if (ir->keypressed) {
-			mod_timer(&ir->raw->timer_keyup,
-				jiffies + msecs_to_jiffies(REPEAT_TIME));
+			ir_repeat(input_dev);
 			IR_dprintk(1, "NEC repeat event\n");
 			return 1;
 		} else {
@@ -237,9 +236,7 @@
 	}
 
 	IR_dprintk(1, "NEC scancode 0x%04x\n", ircode);
-	ir_keydown(input_dev, ircode);
-	mod_timer(&ir->raw->timer_keyup,
-		  jiffies + msecs_to_jiffies(REPEAT_TIME));
+	ir_keydown(input_dev, ircode, 0);
 
 	return 1;
 err:
Index: ir/drivers/media/IR/ir-raw-event.c
===================================================================
--- ir.orig/drivers/media/IR/ir-raw-event.c	2010-04-02 12:22:50.856216460 +0200
+++ ir/drivers/media/IR/ir-raw-event.c	2010-04-02 12:34:05.395187844 +0200
@@ -53,13 +53,6 @@
 /* Used to load the decoders */
 static struct work_struct wq_load;
 
-static void ir_keyup_timer(unsigned long data)
-{
-	struct input_dev *input_dev = (struct input_dev *)data;
-
-	ir_keyup(input_dev);
-}
-
 int ir_raw_event_register(struct input_dev *input_dev)
 {
 	struct ir_input_dev *ir = input_get_drvdata(input_dev);
@@ -72,11 +65,6 @@
 	size = sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE * 2;
 	size = roundup_pow_of_two(size);
 
-	init_timer(&ir->raw->timer_keyup);
-	ir->raw->timer_keyup.function = ir_keyup_timer;
-	ir->raw->timer_keyup.data = (unsigned long)input_dev;
-	set_bit(EV_REP, input_dev->evbit);
-
 	rc = kfifo_alloc(&ir->raw->kfifo, size, GFP_KERNEL);
 	if (rc < 0) {
 		kfree (ir->raw);
@@ -103,8 +91,6 @@
 	if (!ir->raw)
 		return;
 
-	del_timer_sync(&ir->raw->timer_keyup);
-
 	RUN_DECODER(raw_unregister, input_dev);
 
 	kfifo_free(&ir->raw->kfifo);
Index: ir/include/media/ir-core.h
===================================================================
--- ir.orig/include/media/ir-core.h	2010-04-02 12:22:50.836196555 +0200
+++ ir/include/media/ir-core.h	2010-04-02 16:23:29.783236946 +0200
@@ -70,7 +70,6 @@
 struct ir_raw_event_ctrl {
 	struct kfifo			kfifo;		/* fifo for the pulse/space events */
 	struct timespec			last_event;	/* when last event occurred */
-	struct timer_list		timer_keyup;	/* timer for key release */
 };
 
 struct ir_input_dev {
@@ -80,10 +79,16 @@
 	unsigned long			devno;		/* device number */
 	const struct ir_dev_props	*props;		/* Device properties */
 	struct ir_raw_event_ctrl	*raw;		/* for raw pulse/space events */
+	struct input_dev		*input_dev;	/* the input device associated with this device */
 
 	/* key info - needed by IR keycode handlers */
-	u32				keycode;	/* linux key code */
-	int				keypressed;	/* current state */
+	spinlock_t			keylock;	/* protects the below members */
+	bool				keypressed;	/* current state */
+	unsigned long			keyup_jiffies;	/* when should the current keypress be released? */
+	struct timer_list		timer_keyup;	/* timer for releasing a keypress */
+	u32				last_keycode;	/* keycode of last command */
+	u32				last_scancode;	/* scancode of last command */
+	u8				last_toggle;	/* toggle of last command */
 };
 
 struct ir_raw_handler {
@@ -102,8 +107,8 @@
 
 u32 ir_g_keycode_from_table(struct input_dev *input_dev,
 			    u32 scancode);
-void ir_keyup(struct input_dev *dev);
-void ir_keydown(struct input_dev *dev, int scancode);
+void ir_repeat(struct input_dev *dev);
+void ir_keydown(struct input_dev *dev, int scancode, u8 toggle);
 int ir_input_register(struct input_dev *dev,
 		      const struct ir_scancode_table *ir_codes,
 		      const struct ir_dev_props *props,

