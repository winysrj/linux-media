Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44287 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933052Ab2EWJyz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:55 -0400
Subject: [PATCH 33/43] rc-ir-raw: simplify locking
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:44:53 +0200
Message-ID: <20120523094453.14474.60054.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify and improve the locking in rc-ir-raw by making better use of
the existing kfifo functionality and by using RCU where possible.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-core-priv.h |    6 +-
 drivers/media/rc/rc-ir-raw.c    |  119 ++++++++++++++++-----------------------
 2 files changed, 52 insertions(+), 73 deletions(-)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index b2a5d99..b0e1686 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -33,11 +33,13 @@ struct ir_raw_handler {
 	int (*raw_unregister)(struct rc_dev *dev);
 };
 
+/* max number of pulse/space transitions to buffer */
+#define RC_MAX_IR_EVENTS	512
+
 struct ir_raw_event_ctrl {
 	struct list_head		list;		/* to keep track of raw clients */
 	struct task_struct		*thread;
-	spinlock_t			lock;
-	struct kfifo_rec_ptr_1		kfifo;		/* fifo for the pulse/space durations */
+	DECLARE_KFIFO(kfifo, struct ir_raw_event, RC_MAX_IR_EVENTS); /* for pulse/space durations */
 	ktime_t				last_event;	/* when last event occurred */
 	enum raw_event_type		last_type;	/* last event type */
 	struct rc_dev			*dev;		/* pointer to the parent rc_dev */
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index a0d3508..42769b4 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -23,15 +23,12 @@
 
 #include "rc-core-priv.h"
 
-/* Define the max number of pulse/space transitions to buffer */
-#define MAX_IR_EVENT_SIZE      512
-
-/* Used to keep track of IR raw clients, protected by ir_raw_handler_lock */
+/* IR raw clients/handlers, writers synchronize with ir_raw_mutex */
+static DEFINE_MUTEX(ir_raw_mutex);
 static LIST_HEAD(ir_raw_client_list);
-
-/* Used to handle IR raw handler extensions */
-static DEFINE_MUTEX(ir_raw_handler_lock);
 static LIST_HEAD(ir_raw_handler_list);
+
+/* protocols supported by the currently loaded decoders */
 static u64 available_protocols;
 
 static int ir_raw_event_thread(void *data)
@@ -39,32 +36,19 @@ static int ir_raw_event_thread(void *data)
 	struct ir_raw_event ev;
 	struct ir_raw_handler *handler;
 	struct ir_raw_event_ctrl *raw = (struct ir_raw_event_ctrl *)data;
-	int retval;
 
 	while (!kthread_should_stop()) {
-
-		spin_lock_irq(&raw->lock);
-		retval = kfifo_len(&raw->kfifo);
-
-		if (retval < sizeof(ev)) {
+		if (kfifo_out(&raw->kfifo, &ev, 1) == 0) {
 			set_current_state(TASK_INTERRUPTIBLE);
-
-			if (kthread_should_stop())
-				set_current_state(TASK_RUNNING);
-
-			spin_unlock_irq(&raw->lock);
 			schedule();
 			continue;
 		}
 
-		retval = kfifo_out(&raw->kfifo, &ev, sizeof(ev));
-		spin_unlock_irq(&raw->lock);
-
-		mutex_lock(&ir_raw_handler_lock);
-		list_for_each_entry(handler, &ir_raw_handler_list, list)
+		rcu_read_lock();
+		list_for_each_entry_rcu(handler, &ir_raw_handler_list, list)
 			handler->decode(raw->dev, ev);
+		rcu_read_unlock();
 		raw->prev_ev = ev;
-		mutex_unlock(&ir_raw_handler_lock);
 	}
 
 	return 0;
@@ -78,7 +62,8 @@ static int ir_raw_event_thread(void *data)
  * This routine (which may be called from an interrupt context) stores a
  * pulse/space duration for the raw ir decoding state machines. Pulses are
  * signalled as positive values and spaces as negative values. A zero value
- * will reset the decoding state machines.
+ * will reset the decoding state machines. Drivers are responsible for
+ * synchronizing calls to this function.
  */
 int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev)
 {
@@ -88,7 +73,7 @@ int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev)
 	IR_dprintk(2, "sample: (%05dus %s)\n",
 		   TO_US(ev->duration), TO_STR(ev->pulse));
 
-	if (kfifo_in(&dev->raw->kfifo, ev, sizeof(*ev)) != sizeof(*ev))
+	if (kfifo_in(&dev->raw->kfifo, ev, 1) != 1)
 		return -ENOMEM;
 
 	return 0;
@@ -217,14 +202,8 @@ EXPORT_SYMBOL_GPL(ir_raw_event_set_idle);
  */
 void ir_raw_event_handle(struct rc_dev *dev)
 {
-	unsigned long flags;
-
-	if (!dev->raw)
-		return;
-
-	spin_lock_irqsave(&dev->raw->lock, flags);
-	wake_up_process(dev->raw->thread);
-	spin_unlock_irqrestore(&dev->raw->lock, flags);
+	if (dev->raw)
+		wake_up_process(dev->raw->thread);
 }
 EXPORT_SYMBOL_GPL(ir_raw_event_handle);
 
@@ -233,9 +212,9 @@ static u64
 ir_raw_get_allowed_protocols(struct rc_dev *dev)
 {
 	u64 protocols;
-	mutex_lock(&ir_raw_handler_lock);
+	mutex_lock(&ir_raw_mutex);
 	protocols = available_protocols;
-	mutex_unlock(&ir_raw_handler_lock);
+	mutex_unlock(&ir_raw_mutex);
 	return protocols;
 }
 
@@ -245,50 +224,46 @@ ir_raw_get_allowed_protocols(struct rc_dev *dev)
 int rc_register_ir_raw_device(struct rc_dev *dev)
 {
 	int rc;
+	struct ir_raw_event_ctrl *raw;
 	struct ir_raw_handler *handler;
 
 	if (!dev)
 		return -EINVAL;
 
-	dev->raw = kzalloc(sizeof(*dev->raw), GFP_KERNEL);
-	if (!dev->raw)
+	raw = kzalloc(sizeof(*raw), GFP_KERNEL);
+	if (!raw)
 		return -ENOMEM;
 
-	dev->raw->dev = dev;
-	dev->enabled_protocols = ~0;
-	dev->get_protocols = ir_raw_get_allowed_protocols;
-	dev->driver_type = RC_DRIVER_IR_RAW;
-	spin_lock_init(&dev->raw->lock);
-	rc = kfifo_alloc(&dev->raw->kfifo,
-			 sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE,
-			 GFP_KERNEL);
-	if (rc < 0)
-		goto out;
-
-	dev->raw->thread = kthread_run(ir_raw_event_thread, dev->raw,
-				       "rc-ir-raw-decode");
-	if (IS_ERR(dev->raw->thread)) {
-		rc = PTR_ERR(dev->raw->thread);
+	raw->dev = dev;
+	INIT_KFIFO(raw->kfifo);
+	raw->thread = kthread_run(ir_raw_event_thread, raw, "rc-ir-raw-decode");
+	if (IS_ERR(raw->thread)) {
+		rc = PTR_ERR(raw->thread);
 		goto out;
 	}
 
+	dev->raw = raw;
+	dev->enabled_protocols = ~0;
+	dev->get_protocols = ir_raw_get_allowed_protocols;
+	dev->driver_type = RC_DRIVER_IR_RAW;
 	rc = rc_register_device(dev);
 	if (rc < 0)
 		goto out_thread;
 
-	mutex_lock(&ir_raw_handler_lock);
-	list_add_tail(&dev->raw->list, &ir_raw_client_list);
-	list_for_each_entry(handler, &ir_raw_handler_list, list)
+	mutex_lock(&ir_raw_mutex);
+	list_add_tail_rcu(&dev->raw->list, &ir_raw_client_list);
+	list_for_each_entry_rcu(handler, &ir_raw_handler_list, list)
 		if (handler->raw_register)
 			handler->raw_register(dev);
-	mutex_unlock(&ir_raw_handler_lock);
+	mutex_unlock(&ir_raw_mutex);
+	synchronize_rcu();
 
 	return 0;
 
 out_thread:
 	kthread_stop(dev->raw->thread);
 out:
-	kfree(dev->raw);
+	kfree(raw);
 	dev->raw = NULL;
 	return rc;
 }
@@ -303,14 +278,14 @@ void rc_unregister_ir_raw_device(struct rc_dev *dev)
 
 	kthread_stop(dev->raw->thread);
 
-	mutex_lock(&ir_raw_handler_lock);
-	list_del(&dev->raw->list);
-	list_for_each_entry(handler, &ir_raw_handler_list, list)
+	mutex_lock(&ir_raw_mutex);
+	list_del_rcu(&dev->raw->list);
+	list_for_each_entry_rcu(handler, &ir_raw_handler_list, list)
 		if (handler->raw_unregister)
 			handler->raw_unregister(dev);
-	mutex_unlock(&ir_raw_handler_lock);
+	mutex_unlock(&ir_raw_mutex);
+	synchronize_rcu();
 
-	kfifo_free(&dev->raw->kfifo);
 	kfree(dev->raw);
 	dev->raw = NULL;
 	rc_unregister_device(dev);
@@ -325,13 +300,14 @@ int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler)
 {
 	struct ir_raw_event_ctrl *raw;
 
-	mutex_lock(&ir_raw_handler_lock);
-	list_add_tail(&ir_raw_handler->list, &ir_raw_handler_list);
+	mutex_lock(&ir_raw_mutex);
+	list_add_tail_rcu(&ir_raw_handler->list, &ir_raw_handler_list);
 	if (ir_raw_handler->raw_register)
-		list_for_each_entry(raw, &ir_raw_client_list, list)
+		list_for_each_entry_rcu(raw, &ir_raw_client_list, list)
 			ir_raw_handler->raw_register(raw->dev);
 	available_protocols |= ir_raw_handler->protocols;
-	mutex_unlock(&ir_raw_handler_lock);
+	mutex_unlock(&ir_raw_mutex);
+	synchronize_rcu();
 
 	return 0;
 }
@@ -341,13 +317,14 @@ void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
 {
 	struct ir_raw_event_ctrl *raw;
 
-	mutex_lock(&ir_raw_handler_lock);
-	list_del(&ir_raw_handler->list);
+	mutex_lock(&ir_raw_mutex);
+	list_del_rcu(&ir_raw_handler->list);
 	if (ir_raw_handler->raw_unregister)
-		list_for_each_entry(raw, &ir_raw_client_list, list)
+		list_for_each_entry_rcu(raw, &ir_raw_client_list, list)
 			ir_raw_handler->raw_unregister(raw->dev);
 	available_protocols &= ~ir_raw_handler->protocols;
-	mutex_unlock(&ir_raw_handler_lock);
+	mutex_unlock(&ir_raw_mutex);
+	synchronize_rcu();
 }
 EXPORT_SYMBOL(ir_raw_handler_unregister);
 

