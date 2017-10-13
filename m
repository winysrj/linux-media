Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:37278 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751617AbdJMXlj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 19:41:39 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH] build: Fixed patches for Kernel 2.6.35
Date: Sat, 14 Oct 2017 01:41:32 +0200
Message-Id: <1507938092-22927-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 backports/v2.6.35_kfifo.patch        | 11 ++++++-----
 backports/v2.6.35_work_handler.patch | 18 +++++++++---------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/backports/v2.6.35_kfifo.patch b/backports/v2.6.35_kfifo.patch
index 6837f27..5ff8a3c 100644
--- a/backports/v2.6.35_kfifo.patch
+++ b/backports/v2.6.35_kfifo.patch
@@ -6,12 +6,13 @@ diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
 index 96f0a8b..b72f858 100644
 --- a/drivers/media/rc/rc-core-priv.h
 +++ b/drivers/media/rc/rc-core-priv.h
-@@ -35,7 +35,7 @@ struct ir_raw_event_ctrl {
+@@ -39,7 +39,7 @@
  	struct list_head		list;		/* to keep track of raw clients */
  	struct task_struct		*thread;
- 	spinlock_t			lock;
--	struct kfifo_rec_ptr_1		kfifo;		/* fifo for the pulse/space durations */
-+	struct kfifo			kfifo;		/* fifo for the pulse/space durations */
+ 	/* fifo for the pulse/space durations */
+-	DECLARE_KFIFO(kfifo, struct ir_raw_event, MAX_IR_EVENT_SIZE);
++	struct kfifo			kfifo;
  	ktime_t				last_event;	/* when last event occurred */
- 	enum raw_event_type		last_type;	/* last event type */
  	struct rc_dev			*dev;		/* pointer to the parent rc_dev */
+ 	/* edge driver */
+
diff --git a/backports/v2.6.35_work_handler.patch b/backports/v2.6.35_work_handler.patch
index 9d12b34..dc94f09 100644
--- a/backports/v2.6.35_work_handler.patch
+++ b/backports/v2.6.35_work_handler.patch
@@ -15,7 +15,7 @@ index c08ae3e..2e453ff 100644
  	spin_lock_init(&itv->lock);
  	spin_lock_init(&itv->dma_reg_lock);
  
--	init_kthread_worker(&itv->irq_worker);
+-	kthread_init_worker(&itv->irq_worker);
 -	itv->irq_worker_task = kthread_run(kthread_worker_fn, &itv->irq_worker,
 -					   "%s", itv->v4l2_dev.name);
 -	if (IS_ERR(itv->irq_worker_task)) {
@@ -28,7 +28,7 @@ index c08ae3e..2e453ff 100644
 -	/* must use the FIFO scheduler as it is realtime sensitive */
 -	sched_setscheduler(itv->irq_worker_task, SCHED_FIFO, &param);
 -
--	init_kthread_work(&itv->irq_work, ivtv_irq_work_handler);
+-	kthread_init_work(&itv->irq_work, ivtv_irq_work_handler);
 +	INIT_WORK(&itv->irq_work_queue, ivtv_irq_work_handler);
  
  	/* Initial settings */
@@ -58,7 +58,7 @@ index c08ae3e..2e453ff 100644
  	del_timer_sync(&itv->dma_timer);
  
 -	/* Kill irq worker */
--	flush_kthread_worker(&itv->irq_worker);
+-	kthread_flush_worker(&itv->irq_worker);
 -	kthread_stop(itv->irq_worker_task);
 +	/* Stop all Work Queues */
 +	flush_workqueue(itv->irq_work_queues);
@@ -71,14 +71,14 @@ index bc309f42c..6c0fa73 100644
 --- a/drivers/media/pci/ivtv/ivtv-driver.h
 +++ b/drivers/media/pci/ivtv/ivtv-driver.h
 @@ -50,7 +50,7 @@
- #include <linux/unistd.h>
- #include <linux/pagemap.h>
- #include <linux/scatterlist.h>
+ #include <linux/interrupt.h>
+ #include <linux/ivtv.h>
+ #include <linux/kernel.h>
 -#include <linux/kthread.h>
 +#include <linux/workqueue.h>
+ #include <linux/list.h>
+ #include <linux/module.h>
  #include <linux/mutex.h>
- #include <linux/slab.h>
- #include <asm/uaccess.h>
 @@ -260,6 +260,7 @@ struct ivtv_mailbox_data {
  #define IVTV_F_I_INITED		   21 	/* set after first open */
  #define IVTV_F_I_FAILED		   22 	/* set if first open failed */
@@ -129,7 +129,7 @@ index 19a7c9b..ed51a8b 100644
  	}
  
  	if (test_and_clear_bit(IVTV_F_I_HAVE_WORK, &itv->i_flags)) {
--		queue_kthread_work(&itv->irq_worker, &itv->irq_work);
+-		kthread_queue_work(&itv->irq_worker, &itv->irq_work);
 +		queue_work(itv->irq_work_queues, &itv->irq_work_queue);
  	}
  
-- 
2.7.4
