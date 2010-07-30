Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45485 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758455Ab0G3LjK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 07:39:10 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 04/13] IR: fix locking in ir_raw_event_work
Date: Fri, 30 Jul 2010 14:38:44 +0300
Message-Id: <1280489933-20865-5-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1280489933-20865-1-git-send-email-maximlevitsky@gmail.com>
References: <1280489933-20865-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is prefectly possible to have ir_raw_event_work
running concurently on two cpus, thus we must protect
it from that situation.

Just switch to a thread that we wake up as soon as we have data.
This also ensures that this thread doesn't run unnessesarly.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/IR/ir-core-priv.h |    2 +-
 drivers/media/IR/ir-raw-event.c |   42 ++++++++++++++++++++++++++++----------
 2 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
index dc26e2b..84c7a9a 100644
--- a/drivers/media/IR/ir-core-priv.h
+++ b/drivers/media/IR/ir-core-priv.h
@@ -32,7 +32,7 @@ struct ir_raw_handler {
 
 struct ir_raw_event_ctrl {
 	struct list_head		list;		/* to keep track of raw clients */
-	struct work_struct		rx_work;	/* for the rx decoding workqueue */
+	struct task_struct		*thread;
 	struct kfifo			kfifo;		/* fifo for the pulse/space durations */
 	ktime_t				last_event;	/* when last event occurred */
 	enum raw_event_type		last_type;	/* last event type */
diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
index 9d5c029..d0c18db 100644
--- a/drivers/media/IR/ir-raw-event.c
+++ b/drivers/media/IR/ir-raw-event.c
@@ -12,9 +12,10 @@
  *  GNU General Public License for more details.
  */
 
-#include <linux/workqueue.h>
+#include <linux/kthread.h>
 #include <linux/mutex.h>
 #include <linux/sched.h>
+#include <linux/freezer.h>
 #include "ir-core-priv.h"
 
 /* Define the max number of pulse/space transitions to buffer */
@@ -33,20 +34,30 @@ static u64 available_protocols;
 static struct work_struct wq_load;
 #endif
 
-static void ir_raw_event_work(struct work_struct *work)
+static int ir_raw_event_thread(void *data)
 {
 	struct ir_raw_event ev;
 	struct ir_raw_handler *handler;
-	struct ir_raw_event_ctrl *raw =
-		container_of(work, struct ir_raw_event_ctrl, rx_work);
+	struct ir_raw_event_ctrl *raw = (struct ir_raw_event_ctrl *)data;
+
+	while (!kthread_should_stop()) {
+		try_to_freeze();
 
-	while (kfifo_out(&raw->kfifo, &ev, sizeof(ev)) == sizeof(ev)) {
 		mutex_lock(&ir_raw_handler_lock);
-		list_for_each_entry(handler, &ir_raw_handler_list, list)
-			handler->decode(raw->input_dev, ev);
+
+		while (kfifo_out(&raw->kfifo, &ev, sizeof(ev)) == sizeof(ev)) {
+			list_for_each_entry(handler, &ir_raw_handler_list, list)
+				handler->decode(raw->input_dev, ev);
+			raw->prev_ev = ev;
+		}
+
 		mutex_unlock(&ir_raw_handler_lock);
-		raw->prev_ev = ev;
+
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule();
 	}
+
+	return 0;
 }
 
 /**
@@ -141,7 +152,7 @@ void ir_raw_event_handle(struct input_dev *input_dev)
 	if (!ir->raw)
 		return;
 
-	schedule_work(&ir->raw->rx_work);
+	wake_up_process(ir->raw->thread);
 }
 EXPORT_SYMBOL_GPL(ir_raw_event_handle);
 
@@ -170,7 +181,7 @@ int ir_raw_event_register(struct input_dev *input_dev)
 		return -ENOMEM;
 
 	ir->raw->input_dev = input_dev;
-	INIT_WORK(&ir->raw->rx_work, ir_raw_event_work);
+
 	ir->raw->enabled_protocols = ~0;
 	rc = kfifo_alloc(&ir->raw->kfifo, sizeof(s64) * MAX_IR_EVENT_SIZE,
 			 GFP_KERNEL);
@@ -180,6 +191,15 @@ int ir_raw_event_register(struct input_dev *input_dev)
 		return rc;
 	}
 
+	ir->raw->thread = kthread_run(ir_raw_event_thread, ir->raw,
+			"rc%u",  (unsigned int)ir->devno);
+
+	if (IS_ERR(ir->raw->thread)) {
+		kfree(ir->raw);
+		ir->raw = NULL;
+		return PTR_ERR(ir->raw->thread);
+	}
+
 	mutex_lock(&ir_raw_handler_lock);
 	list_add_tail(&ir->raw->list, &ir_raw_client_list);
 	list_for_each_entry(handler, &ir_raw_handler_list, list)
@@ -198,7 +218,7 @@ void ir_raw_event_unregister(struct input_dev *input_dev)
 	if (!ir->raw)
 		return;
 
-	cancel_work_sync(&ir->raw->rx_work);
+	kthread_stop(ir->raw->thread);
 
 	mutex_lock(&ir_raw_handler_lock);
 	list_del(&ir->raw->list);
-- 
1.7.0.4

