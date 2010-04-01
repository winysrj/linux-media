Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:46633 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354Ab0DALyD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 07:54:03 -0400
Date: Thu, 1 Apr 2010 13:53:57 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH] drivers/media/IR - improve keyup/keydown logic
Message-ID: <20100401115357.GA8618@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
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

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/IR/ir-keytable.c    |  127 +++++++++++++++++++++++++++++--------
 drivers/media/IR/ir-nec-decoder.c |    7 +--
 drivers/media/IR/ir-raw-event.c   |   14 ----
 include/media/ir-core.h           |   15 +++--
 4 files changed, 112 insertions(+), 51 deletions(-)

diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index 6b0d13e..e1fd20b 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -19,6 +19,9 @@
 #define IR_TAB_MIN_SIZE	32
 #define IR_TAB_MAX_SIZE	1024
 
+/* FIXME: IR_KEYPRESS_TIMEOUT should be protocol specific */
+#define IR_KEYPRESS_TIMEOUT 250
+
 /**
  * ir_seek_table() - returns the element order on the table
  * @rc_tab:	the ir_scancode_table with the keymap to be used
@@ -392,56 +395,122 @@ EXPORT_SYMBOL_GPL(ir_g_keycode_from_table);
 
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
 }
-EXPORT_SYMBOL_GPL(ir_keyup);
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
+ * @ir:		the struct ir_input_dev descriptor of the device
+ *
+ * This routine is used by IR decoders when a repeat message which does
+ * not include the necessary bits to reproduce the scancode has been
+ * received.
+ */
+void ir_repeat(struct ir_input_dev *ir)
+{
+	unsigned long flags;
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
+}
+EXPORT_SYMBOL_GPL(ir_repeat);
 
 /**
  * ir_keydown() - generates input event for a key press
- * @input_dev:	the struct input_dev descriptor of the device
+ * @ir:		the struct ir_input_dev descriptor of the device
  * @scancode:	the scancode that we're seeking
+ * @toggle:	the toggle value (protocol dependent, if the protocol doesn't
+ *		support toggle values, this should be set to zero)
  *
  * This routine is used by the input routines when a key is pressed at the
  * IR. It gets the keycode for a scancode and reports an input event via
  * input_report_key().
  */
-void ir_keydown(struct input_dev *dev, int scancode)
+void ir_keydown(struct ir_input_dev *ir, int scancode, u8 toggle)
 {
-	struct ir_input_dev *ir = input_get_drvdata(dev);
+	unsigned long flags;
 
-	u32 keycode = ir_g_keycode_from_table(dev, scancode);
+	u32 keycode = ir_g_keycode_from_table(ir->input_dev, scancode);
 
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
 
-	ir->keycode = keycode;
-	ir->keypressed = 1;
+	/* Optionally, release an old keypress */
+	ir_keyup(ir);
 
-	IR_dprintk(1, "%s: key down event, key 0x%04x, scancode 0x%04x\n",
-		dev->name, keycode, scancode);
+	ir->last_scancode = scancode;
+	ir->last_toggle = toggle;
+	ir->last_keycode = keycode;
 
-	input_report_key(dev, ir->keycode, 1);
-	input_sync(dev);
+	if (keycode == KEY_RESERVED)
+		goto out;
 	
+	/* Register a keypress */
+	ir->keypressed = true;
+	IR_dprintk(1, "%s: key down event, key 0x%04x, scancode 0x%04x\n",
+		   ir->input_dev->name, keycode, scancode);
+	input_report_key(ir->input_dev, ir->last_keycode, 1);
+	input_sync(ir->input_dev);
+
+set_timer:
+	ir->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
+	mod_timer(&ir->timer_keyup, ir->keyup_jiffies);
+out:
+	spin_unlock_irqrestore(&ir->keylock, flags);
 }
 EXPORT_SYMBOL_GPL(ir_keydown);
 
@@ -487,7 +556,10 @@ int ir_input_register(struct input_dev *input_dev,
 		return -ENOMEM;
 
 	spin_lock_init(&ir_dev->rc_tab.lock);
+	spin_lock_init(&ir_dev->keylock);
+	setup_timer(&ir_dev->timer_keyup, ir_timer_keyup, (unsigned long)ir_dev);
 
+	ir_dev->input_dev = input_dev;
 	ir_dev->driver_name = kmalloc(strlen(driver_name) + 1, GFP_KERNEL);
 	if (!ir_dev->driver_name)
 		return -ENOMEM;
@@ -522,6 +594,7 @@ int ir_input_register(struct input_dev *input_dev,
 	clear_bit(0, input_dev->keybit);
 
 	set_bit(EV_KEY, input_dev->evbit);
+	set_bit(EV_REP, input_dev->evbit);
 
 	input_dev->getkeycode = ir_getkeycode;
 	input_dev->setkeycode = ir_setkeycode;
@@ -555,7 +628,7 @@ void ir_input_unregister(struct input_dev *dev)
 		return;
 
 	IR_dprintk(1, "Freed keycode table\n");
-
+	del_timer_sync(&ir_dev->timer_keyup);
 	rc_tab = &ir_dev->rc_tab;
 	rc_tab->size = 0;
 	kfree(rc_tab->scan);
diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
index c0579d3..69c2388 100644
--- a/drivers/media/IR/ir-nec-decoder.c
+++ b/drivers/media/IR/ir-nec-decoder.c
@@ -179,8 +179,7 @@ static int __ir_nec_decode(struct input_dev *input_dev,
 	if (is_repeat(evs, len, *pos)) {
 		*pos += 2;
 		if (ir->keypressed) {
-			mod_timer(&ir->raw->timer_keyup,
-				jiffies + msecs_to_jiffies(REPEAT_TIME));
+			ir_repeat(ir);
 			IR_dprintk(1, "NEC repeat event\n");
 			return 1;
 		} else {
@@ -237,9 +236,7 @@ static int __ir_nec_decode(struct input_dev *input_dev,
 	}
 
 	IR_dprintk(1, "NEC scancode 0x%04x\n", ircode);
-	ir_keydown(input_dev, ircode);
-	mod_timer(&ir->raw->timer_keyup,
-		  jiffies + msecs_to_jiffies(REPEAT_TIME));
+	ir_keydown(ir, ircode, 0);
 
 	return 1;
 err:
diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
index 1f72223..e539455 100644
--- a/drivers/media/IR/ir-raw-event.c
+++ b/drivers/media/IR/ir-raw-event.c
@@ -53,13 +53,6 @@ static spinlock_t ir_raw_handler_lock;
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
@@ -72,11 +65,6 @@ int ir_raw_event_register(struct input_dev *input_dev)
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
@@ -103,8 +91,6 @@ void ir_raw_event_unregister(struct input_dev *input_dev)
 	if (!ir->raw)
 		return;
 
-	del_timer_sync(&ir->raw->timer_keyup);
-
 	RUN_DECODER(raw_unregister, input_dev);
 
 	kfifo_free(&ir->raw->kfifo);
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index 60ee020..72e4b3e 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -68,7 +68,6 @@ struct ir_raw_event {
 struct ir_raw_event_ctrl {
 	struct kfifo			kfifo;		/* fifo for the pulse/space events */
 	struct timespec			last_event;	/* when last event occurred */
-	struct timer_list		timer_keyup;	/* timer for key release */
 };
 
 struct ir_input_dev {
@@ -78,10 +77,16 @@ struct ir_input_dev {
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
@@ -100,8 +105,8 @@ struct ir_raw_handler {
 
 u32 ir_g_keycode_from_table(struct input_dev *input_dev,
 			    u32 scancode);
-void ir_keyup(struct input_dev *dev);
-void ir_keydown(struct input_dev *dev, int scancode);
+void ir_repeat(struct ir_input_dev *ir);
+void ir_keydown(struct ir_input_dev *ir, int scancode, u8 toggle);
 int ir_input_register(struct input_dev *dev,
 		      const struct ir_scancode_table *ir_codes,
 		      const struct ir_dev_props *props,
-- 
1.7.0.3


