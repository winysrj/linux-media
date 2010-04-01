Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758079Ab0DAR55 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 13:57:57 -0400
Date: Thu, 1 Apr 2010 14:56:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 09/15] V4L/DVB: ir-core: prepare to add more operations for
 ir decoders
Message-ID: <20100401145631.21d1d40a@pedra>
In-Reply-To: <cover.1270142346.git.mchehab@redhat.com>
References: <cover.1270142346.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some decoders and a lirc_dev interface may need some other operations to work.
For example: IR device register/unregister and ir_keydown events may need to
be tracked.

As some operations can occur in interrupt time, and a lock is needed to prevent
un-registering a decode while decoding a key, the lock needed to be convert
into a spin lock.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
index c9a986d..cb57cc2 100644
--- a/drivers/media/IR/ir-nec-decoder.c
+++ b/drivers/media/IR/ir-nec-decoder.c
@@ -178,8 +178,7 @@ err:
  * @input_dev:	the struct input_dev descriptor of the device
  * @evs:	event array with type/duration of pulse/space
  * @len:	length of the array
- * This function returns the number of decoded pulses or -EINVAL if no
- * pulse got decoded
+ * This function returns the number of decoded pulses
  */
 static int ir_nec_decode(struct input_dev *input_dev,
 			 struct ir_raw_event *evs,
@@ -192,9 +191,6 @@ static int ir_nec_decode(struct input_dev *input_dev,
 		if (__ir_nec_decode(input_dev, evs, len, &pos) > 0)
 			rc++;
 	}
-
-	if (!rc)
-		return -EINVAL;
 	return rc;
 }
 
diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
index 3eae128..11f23f4 100644
--- a/drivers/media/IR/ir-raw-event.c
+++ b/drivers/media/IR/ir-raw-event.c
@@ -14,13 +14,41 @@
 
 #include <media/ir-core.h>
 #include <linux/workqueue.h>
+#include <linux/spinlock.h>
 
 /* Define the max number of bit transitions per IR keycode */
 #define MAX_IR_EVENT_SIZE	256
 
 /* Used to handle IR raw handler extensions */
 static LIST_HEAD(ir_raw_handler_list);
-static DEFINE_MUTEX(ir_raw_handler_lock);
+static spinlock_t ir_raw_handler_lock;
+
+/**
+ * RUN_DECODER()	- runs an operation on all IR decoders
+ * @ops:	IR raw handler operation to be called
+ * @arg:	arguments to be passed to the callback
+ *
+ * Calls ir_raw_handler::ops for all registered IR handlers. It prevents
+ * new decode addition/removal while running, by locking ir_raw_handler_lock
+ * mutex. If an error occurs, it stops the ops. Otherwise, it returns a sum
+ * of the return codes.
+ */
+#define RUN_DECODER(ops, ...) ({					    \
+	struct ir_raw_handler		*_ir_raw_handler;		    \
+	int _sumrc = 0, _rc;						    \
+	spin_lock(&ir_raw_handler_lock);				    \
+	list_for_each_entry(_ir_raw_handler, &ir_raw_handler_list, list) {  \
+		if (_ir_raw_handler->ops) {				    \
+			_rc = _ir_raw_handler->ops(__VA_ARGS__);	    \
+			if (_rc < 0)					    \
+				break;					    \
+			_sumrc += _rc;					    \
+		}							    \
+	}								    \
+	spin_unlock(&ir_raw_handler_lock);				    \
+	_sumrc;								    \
+})
+
 
 /* Used to load the decoders */
 static struct work_struct wq_load;
@@ -38,6 +66,8 @@ int ir_raw_event_register(struct input_dev *input_dev)
 	int rc, size;
 
 	ir->raw = kzalloc(sizeof(*ir->raw), GFP_KERNEL);
+	if (!ir->raw)
+		return -ENOMEM;
 
 	size = sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE * 2;
 	size = roundup_pow_of_two(size);
@@ -48,6 +78,19 @@ int ir_raw_event_register(struct input_dev *input_dev)
 	set_bit(EV_REP, input_dev->evbit);
 
 	rc = kfifo_alloc(&ir->raw->kfifo, size, GFP_KERNEL);
+	if (rc < 0) {
+		kfree(ir->raw);
+		ir->raw = NULL;
+		return rc;
+	}
+
+	rc = RUN_DECODER(raw_register, input_dev);
+	if (rc < 0) {
+		kfifo_free(&ir->raw->kfifo);
+		kfree(ir->raw);
+		ir->raw = NULL;
+		return rc;
+	}
 
 	return rc;
 }
@@ -62,6 +105,8 @@ void ir_raw_event_unregister(struct input_dev *input_dev)
 
 	del_timer_sync(&ir->raw->timer_keyup);
 
+	RUN_DECODER(raw_unregister, input_dev);
+
 	kfifo_free(&ir->raw->kfifo);
 	kfree(ir->raw);
 	ir->raw = NULL;
@@ -109,7 +154,6 @@ int ir_raw_event_handle(struct input_dev *input_dev)
 	int				rc;
 	struct ir_raw_event		*evs;
 	int 				len, i;
-	struct ir_raw_handler		*ir_raw_handler;
 
 	/*
 	 * Store the events into a temporary buffer. This allows calling more than
@@ -133,13 +177,10 @@ int ir_raw_event_handle(struct input_dev *input_dev)
 
 	/*
 	 * Call all ir decoders. This allows decoding the same event with
-	 * more than one protocol handler.
-	 * FIXME: better handle the returned code: does it make sense to use
-	 * other decoders, if the first one already handled the IR?
+	 * more than one protocol handler. It returns the number of keystrokes
+	 * sent to the event interface
 	 */
-	list_for_each_entry(ir_raw_handler, &ir_raw_handler_list, list) {
-		rc = ir_raw_handler->decode(input_dev, evs, len);
-	}
+	rc = RUN_DECODER(decode, input_dev, evs, len);
 
 	kfree(evs);
 
@@ -153,18 +194,18 @@ EXPORT_SYMBOL_GPL(ir_raw_event_handle);
 
 int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler)
 {
-	mutex_lock(&ir_raw_handler_lock);
+	spin_lock(&ir_raw_handler_lock);
 	list_add_tail(&ir_raw_handler->list, &ir_raw_handler_list);
-	mutex_unlock(&ir_raw_handler_lock);
+	spin_unlock(&ir_raw_handler_lock);
 	return 0;
 }
 EXPORT_SYMBOL(ir_raw_handler_register);
 
 void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
 {
-	mutex_lock(&ir_raw_handler_lock);
+	spin_lock(&ir_raw_handler_lock);
 	list_del(&ir_raw_handler->list);
-	mutex_unlock(&ir_raw_handler_lock);
+	spin_unlock(&ir_raw_handler_lock);
 }
 EXPORT_SYMBOL(ir_raw_handler_unregister);
 
@@ -181,6 +222,10 @@ static void init_decoders(struct work_struct *work)
 
 void ir_raw_init(void)
 {
+	spin_lock_init(&ir_raw_handler_lock);
+	
+#ifdef MODULE
 	INIT_WORK(&wq_load, init_decoders);
 	schedule_work(&wq_load);
-}
\ No newline at end of file
+#endif
+}
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 38f60e4..8dd74ae 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -960,7 +960,7 @@ static int saa7134_raw_decode_irq(struct saa7134_dev *dev)
 	saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
 	saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
 	pulse = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2) & ir->mask_keydown;
-	ir_raw_event_store(dev->remote->dev, pulse? IR_PULSE : IR_SPACE);
+	ir_raw_event_store(dev->remote->dev, pulse ? IR_PULSE : IR_SPACE);
 
 
 	/*
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index c377bf4..c704fa7 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -88,6 +88,8 @@ struct ir_raw_handler {
 	int (*decode)(struct input_dev *input_dev,
 		      struct ir_raw_event *evs,
 		      int len);
+	int (*raw_register)(struct input_dev *input_dev);
+	int (*raw_unregister)(struct input_dev *input_dev);
 };
 
 #define to_ir_input_dev(_attr) container_of(_attr, struct ir_input_dev, attr)
@@ -116,12 +118,7 @@ int ir_raw_event_store(struct input_dev *input_dev, enum raw_event_type type);
 int ir_raw_event_handle(struct input_dev *input_dev);
 int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler);
 void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler);
-
-#ifdef MODULE
 void ir_raw_init(void);
-#else
-#define ir_raw_init() 0
-#endif
 
 /* from ir-nec-decoder.c */
 #ifdef CONFIG_IR_NEC_DECODER_MODULE
-- 
1.6.6.1


