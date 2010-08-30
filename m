Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50033 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab0H3Iwl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Aug 2010 04:52:41 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 1/7] IR: plug races in handling threads.
Date: Mon, 30 Aug 2010 11:52:21 +0300
Message-Id: <1283158348-7429-2-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1283158348-7429-1-git-send-email-maximlevitsky@gmail.com>
References: <1283158348-7429-1-git-send-email-maximlevitsky@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Unfortunelly (my fault) the kernel thread that now handles IR processing
has classical races in regard to wakeup and stop.
This patch hopefully closes them all.
Tested with module reload running in a loop, while receiver is blasted
with IR data for 10 minutes.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/IR/ir-core-priv.h |    2 ++
 drivers/media/IR/ir-raw-event.c |   34 +++++++++++++++++++++++++---------
 2 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
index a85a8c7..761e7f4 100644
--- a/drivers/media/IR/ir-core-priv.h
+++ b/drivers/media/IR/ir-core-priv.h
@@ -17,6 +17,7 @@
 #define _IR_RAW_EVENT
 
 #include <linux/slab.h>
+#include <linux/spinlock.h>
 #include <media/ir-core.h>
 
 struct ir_raw_handler {
@@ -33,6 +34,7 @@ struct ir_raw_handler {
 struct ir_raw_event_ctrl {
 	struct list_head		list;		/* to keep track of raw clients */
 	struct task_struct		*thread;
+	spinlock_t			lock;
 	struct kfifo			kfifo;		/* fifo for the pulse/space durations */
 	ktime_t				last_event;	/* when last event occurred */
 	enum raw_event_type		last_type;	/* last event type */
diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
index 43094e7..56797be 100644
--- a/drivers/media/IR/ir-raw-event.c
+++ b/drivers/media/IR/ir-raw-event.c
@@ -39,22 +39,34 @@ static int ir_raw_event_thread(void *data)
 	struct ir_raw_event ev;
 	struct ir_raw_handler *handler;
 	struct ir_raw_event_ctrl *raw = (struct ir_raw_event_ctrl *)data;
+	int retval;
 
 	while (!kthread_should_stop()) {
-		try_to_freeze();
 
-		mutex_lock(&ir_raw_handler_lock);
+		spin_lock_irq(&raw->lock);
+		retval = kfifo_out(&raw->kfifo, &ev, sizeof(ev));
+
+		if (!retval) {
+			set_current_state(TASK_INTERRUPTIBLE);
 
-		while (kfifo_out(&raw->kfifo, &ev, sizeof(ev)) == sizeof(ev)) {
-			list_for_each_entry(handler, &ir_raw_handler_list, list)
-				handler->decode(raw->input_dev, ev);
-			raw->prev_ev = ev;
+			if (kthread_should_stop())
+				set_current_state(TASK_RUNNING);
+
+			spin_unlock_irq(&raw->lock);
+			schedule();
+			continue;
 		}
 
-		mutex_unlock(&ir_raw_handler_lock);
+		spin_unlock_irq(&raw->lock);
 
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule();
+
+		BUG_ON(retval != sizeof(ev));
+
+		mutex_lock(&ir_raw_handler_lock);
+		list_for_each_entry(handler, &ir_raw_handler_list, list)
+			handler->decode(raw->input_dev, ev);
+		raw->prev_ev = ev;
+		mutex_unlock(&ir_raw_handler_lock);
 	}
 
 	return 0;
@@ -232,11 +244,14 @@ EXPORT_SYMBOL_GPL(ir_raw_event_set_idle);
 void ir_raw_event_handle(struct input_dev *input_dev)
 {
 	struct ir_input_dev *ir = input_get_drvdata(input_dev);
+	unsigned long flags;
 
 	if (!ir->raw)
 		return;
 
+	spin_lock_irqsave(&ir->raw->lock, flags);
 	wake_up_process(ir->raw->thread);
+	spin_unlock_irqrestore(&ir->raw->lock, flags);
 }
 EXPORT_SYMBOL_GPL(ir_raw_event_handle);
 
@@ -275,6 +290,7 @@ int ir_raw_event_register(struct input_dev *input_dev)
 		return rc;
 	}
 
+	spin_lock_init(&ir->raw->lock);
 	ir->raw->thread = kthread_run(ir_raw_event_thread, ir->raw,
 			"rc%u",  (unsigned int)ir->devno);
 
-- 
1.7.0.4

