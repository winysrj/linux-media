Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:52111 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752977AbdJEAxV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Oct 2017 20:53:21 -0400
Received: by mail-pf0-f181.google.com with SMTP id n14so5232697pfh.8
        for <linux-media@vger.kernel.org>; Wed, 04 Oct 2017 17:53:21 -0700 (PDT)
Date: Wed, 4 Oct 2017 17:53:18 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geliang Tang <geliangtang@gmail.com>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] input: Convert timers to use timer_setup()
Message-ID: <20171005005318.GA23738@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

One input_dev user hijacks the input_dev software autorepeat timer to
perform its own repeat management. However, there is not path back
to the existing status variable, so add a generic one to the input
structure and use that instead.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Geliang Tang <geliangtang@gmail.com>
Cc: linux-input@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
This requires commit 686fef928bba ("timer: Prepare to change timer
callback argument type") in v4.14-rc3, but should be otherwise
stand-alone.
---
 drivers/input/input.c               | 12 ++++++------
 drivers/media/pci/ttpci/av7110.h    |  1 -
 drivers/media/pci/ttpci/av7110_ir.c | 16 ++++++++--------
 include/linux/input.h               |  2 ++
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index d268fdc23c64..497ad2dcb699 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -76,7 +76,7 @@ static void input_start_autorepeat(struct input_dev *dev, int code)
 {
 	if (test_bit(EV_REP, dev->evbit) &&
 	    dev->rep[REP_PERIOD] && dev->rep[REP_DELAY] &&
-	    dev->timer.data) {
+	    dev->timer.function) {
 		dev->repeat_key = code;
 		mod_timer(&dev->timer,
 			  jiffies + msecs_to_jiffies(dev->rep[REP_DELAY]));
@@ -179,9 +179,9 @@ static void input_pass_event(struct input_dev *dev,
  * dev->event_lock here to avoid racing with input_event
  * which may cause keys get "stuck".
  */
-static void input_repeat_key(unsigned long data)
+static void input_repeat_key(struct timer_list *t)
 {
-	struct input_dev *dev = (void *) data;
+	struct input_dev *dev = from_timer(dev, t, timer);
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->event_lock, flags);
@@ -1790,7 +1790,7 @@ struct input_dev *input_allocate_device(void)
 		device_initialize(&dev->dev);
 		mutex_init(&dev->mutex);
 		spin_lock_init(&dev->event_lock);
-		init_timer(&dev->timer);
+		timer_setup(&dev->timer, NULL, 0);
 		INIT_LIST_HEAD(&dev->h_list);
 		INIT_LIST_HEAD(&dev->node);
 
@@ -2053,8 +2053,8 @@ static void devm_input_device_unregister(struct device *dev, void *res)
  */
 void input_enable_softrepeat(struct input_dev *dev, int delay, int period)
 {
-	dev->timer.data = (unsigned long) dev;
-	dev->timer.function = input_repeat_key;
+	dev->timer.function = (TIMER_FUNC_TYPE)input_repeat_key;
+	dev->timer_data = 0;
 	dev->rep[REP_DELAY] = delay;
 	dev->rep[REP_PERIOD] = period;
 }
diff --git a/drivers/media/pci/ttpci/av7110.h b/drivers/media/pci/ttpci/av7110.h
index 347827925c14..b98a4f3006df 100644
--- a/drivers/media/pci/ttpci/av7110.h
+++ b/drivers/media/pci/ttpci/av7110.h
@@ -93,7 +93,6 @@ struct infrared {
 	u8			inversion;
 	u16			last_key;
 	u16			last_toggle;
-	u8			delay_timer_finished;
 };
 
 
diff --git a/drivers/media/pci/ttpci/av7110_ir.c b/drivers/media/pci/ttpci/av7110_ir.c
index ca05198de2c2..a883caa6488c 100644
--- a/drivers/media/pci/ttpci/av7110_ir.c
+++ b/drivers/media/pci/ttpci/av7110_ir.c
@@ -155,16 +155,16 @@ static void av7110_emit_key(unsigned long parm)
 	if (timer_pending(&ir->keyup_timer)) {
 		del_timer(&ir->keyup_timer);
 		if (ir->last_key != keycode || toggle != ir->last_toggle) {
-			ir->delay_timer_finished = 0;
+			ir->input_dev->timer_data = 0;
 			input_event(ir->input_dev, EV_KEY, ir->last_key, 0);
 			input_event(ir->input_dev, EV_KEY, keycode, 1);
 			input_sync(ir->input_dev);
-		} else if (ir->delay_timer_finished) {
+		} else if (ir->input_dev->timer_data) {
 			input_event(ir->input_dev, EV_KEY, keycode, 2);
 			input_sync(ir->input_dev);
 		}
 	} else {
-		ir->delay_timer_finished = 0;
+		ir->input_dev->timer_data = 0;
 		input_event(ir->input_dev, EV_KEY, keycode, 1);
 		input_sync(ir->input_dev);
 	}
@@ -206,11 +206,12 @@ static void input_register_keys(struct infrared *ir)
 
 
 /* called by the input driver after rep[REP_DELAY] ms */
-static void input_repeat_key(unsigned long parm)
+static void input_repeat_key(struct timer_list *t)
 {
-	struct infrared *ir = (struct infrared *) parm;
+	struct input_dev *dev = from_timer(dev, t, timer);
 
-	ir->delay_timer_finished = 1;
+	/* Key repeat started */
+	dev->timer_data = 1;
 }
 
 
@@ -365,8 +366,7 @@ int av7110_ir_init(struct av7110 *av7110)
 		input_free_device(input_dev);
 		return err;
 	}
-	input_dev->timer.function = input_repeat_key;
-	input_dev->timer.data = (unsigned long) &av7110->ir;
+	input_dev->timer.function = (TIMER_FUNC_TYPE)input_repeat_key;
 
 	if (av_cnt == 1) {
 		e = proc_create("av7110_ir", S_IWUSR, NULL, &av7110_ir_proc_fops);
diff --git a/include/linux/input.h b/include/linux/input.h
index fb5e23c7ed98..dcd117bf1027 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -70,6 +70,7 @@ struct input_value {
  * @repeat_key: stores key code of the last key pressed; used to implement
  *	software autorepeat
  * @timer: timer for software autorepeat
+ * @timer_data: timer data for software autorepeat overrides
  * @rep: current values for autorepeat parameters (delay, rate)
  * @mt: pointer to multitouch state
  * @absinfo: array of &struct input_absinfo elements holding information
@@ -152,6 +153,7 @@ struct input_dev {
 
 	unsigned int repeat_key;
 	struct timer_list timer;
+	unsigned long timer_data;
 
 	int rep[REP_CNT];
 
-- 
2.7.4


-- 
Kees Cook
Pixel Security
