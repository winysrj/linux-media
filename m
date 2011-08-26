Return-path: <linux-media-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1764 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190Ab1HZGY0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 02:24:26 -0400
From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
To: tj@kernel.org
cc: bprakash@broadcom.com, "Andy Walls" <awalls@md.metrocast.net>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
Subject: [PATCH 02/11] ivtv: use kthread_worker instead of workqueue
Date: Thu, 25 Aug 2011 23:24:03 -0700
Message-ID: <1314339850-32666-3-git-send-email-bprakash@broadcom.com>
In-Reply-To: <1314339850-32666-1-git-send-email-bprakash@broadcom.com>
References: <1314339850-32666-1-git-send-email-bprakash@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tejun Heo <tj@kernel.org>

Upcoming workqueue updates will no longer guarantee fixed workqueue to
worker kthread association, so giving RT priority to the irq worker
won't work.  Use kthread_worker which guarantees specific kthread
association instead.  This also makes setting the priority cleaner.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andy Walls <awalls@md.metrocast.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: ivtv-devel@ivtvdriver.org
Cc: linux-media@vger.kernel.org
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/media/video/ivtv/ivtv-driver.c |   26 ++++++++++++++++----------
 drivers/media/video/ivtv/ivtv-driver.h |    8 ++++----
 drivers/media/video/ivtv/ivtv-irq.c    |   15 +++------------
 drivers/media/video/ivtv/ivtv-irq.h    |    2 +-
 4 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/ivtv/ivtv-driver.c
index fe7847b..3994642 100644
--- a/drivers/media/video/ivtv/ivtv-driver.c
+++ b/drivers/media/video/ivtv/ivtv-driver.c
@@ -706,6 +706,8 @@ done:
  */
 static int __devinit ivtv_init_struct1(struct ivtv *itv)
 {
+	struct sched_param param = { .sched_priority = 99 };
+
 	itv->base_addr = pci_resource_start(itv->pdev, 0);
 	itv->enc_mbox.max_mbox = 2; /* the encoder has 3 mailboxes (0-2) */
 	itv->dec_mbox.max_mbox = 1; /* the decoder has 2 mailboxes (0-1) */
@@ -717,13 +719,17 @@ static int __devinit ivtv_init_struct1(struct ivtv *itv)
 	spin_lock_init(&itv->lock);
 	spin_lock_init(&itv->dma_reg_lock);
 
-	itv->irq_work_queues = create_singlethread_workqueue(itv->v4l2_dev.name);
-	if (itv->irq_work_queues == NULL) {
-		IVTV_ERR("Could not create ivtv workqueue\n");
+	init_kthread_worker(&itv->irq_worker);
+	itv->irq_worker_task = kthread_run(kthread_worker_fn, &itv->irq_worker,
+					   itv->v4l2_dev.name);
+	if (IS_ERR(itv->irq_worker_task)) {
+		IVTV_ERR("Could not create ivtv task\n");
 		return -1;
 	}
+	/* must use the FIFO scheduler as it is realtime sensitive */
+	sched_setscheduler(itv->irq_worker_task, SCHED_FIFO, &param);
 
-	INIT_WORK(&itv->irq_work_queue, ivtv_irq_work_handler);
+	init_kthread_work(&itv->irq_work, ivtv_irq_work_handler);
 
 	/* start counting open_id at 1 */
 	itv->open_id = 1;
@@ -1013,7 +1019,7 @@ static int __devinit ivtv_probe(struct pci_dev *pdev,
 	/* PCI Device Setup */
 	retval = ivtv_setup_pci(itv, pdev, pci_id);
 	if (retval == -EIO)
-		goto free_workqueue;
+		goto free_worker;
 	if (retval == -ENXIO)
 		goto free_mem;
 
@@ -1241,8 +1247,8 @@ free_mem:
 	release_mem_region(itv->base_addr + IVTV_REG_OFFSET, IVTV_REG_SIZE);
 	if (itv->has_cx23415)
 		release_mem_region(itv->base_addr + IVTV_DECODER_OFFSET, IVTV_DECODER_SIZE);
-free_workqueue:
-	destroy_workqueue(itv->irq_work_queues);
+free_worker:
+	kthread_stop(itv->irq_worker_task);
 err:
 	if (retval == 0)
 		retval = -ENODEV;
@@ -1381,9 +1387,9 @@ static void ivtv_remove(struct pci_dev *pdev)
 	ivtv_set_irq_mask(itv, 0xffffffff);
 	del_timer_sync(&itv->dma_timer);
 
-	/* Stop all Work Queues */
-	flush_workqueue(itv->irq_work_queues);
-	destroy_workqueue(itv->irq_work_queues);
+	/* Kill irq worker */
+	flush_kthread_worker(&itv->irq_worker);
+	kthread_stop(itv->irq_worker_task);
 
 	ivtv_streams_cleanup(itv, 1);
 	ivtv_udma_free(itv);
diff --git a/drivers/media/video/ivtv/ivtv-driver.h b/drivers/media/video/ivtv/ivtv-driver.h
index e8137a2..04bacdb 100644
--- a/drivers/media/video/ivtv/ivtv-driver.h
+++ b/drivers/media/video/ivtv/ivtv-driver.h
@@ -51,7 +51,7 @@
 #include <linux/unistd.h>
 #include <linux/pagemap.h>
 #include <linux/scatterlist.h>
-#include <linux/workqueue.h>
+#include <linux/kthread.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <asm/uaccess.h>
@@ -261,7 +261,6 @@ struct ivtv_mailbox_data {
 #define IVTV_F_I_DEC_PAUSED	   20 	/* the decoder is paused */
 #define IVTV_F_I_INITED		   21 	/* set after first open */
 #define IVTV_F_I_FAILED		   22 	/* set if first open failed */
-#define IVTV_F_I_WORK_INITED       23	/* worker thread was initialized */
 
 /* Event notifications */
 #define IVTV_F_I_EV_DEC_STOPPED	   28	/* decoder stopped event */
@@ -668,8 +667,9 @@ struct ivtv {
 	/* Interrupts & DMA */
 	u32 irqmask;                    /* active interrupts */
 	u32 irq_rr_idx;                 /* round-robin stream index */
-	struct workqueue_struct *irq_work_queues;       /* workqueue for PIO/YUV/VBI actions */
-	struct work_struct irq_work_queue;              /* work entry */
+	struct kthread_worker irq_worker;		/* kthread worker for PIO/YUV/VBI actions */
+	struct task_struct *irq_worker_task;		/* task for irq_worker */
+	struct kthread_work irq_work;	/* kthread work entry */
 	spinlock_t dma_reg_lock;        /* lock access to DMA engine registers */
 	int cur_dma_stream;		/* index of current stream doing DMA (-1 if none) */
 	int cur_pio_stream;		/* index of current stream doing PIO (-1 if none) */
diff --git a/drivers/media/video/ivtv/ivtv-irq.c b/drivers/media/video/ivtv/ivtv-irq.c
index 11abce2..9c29e96 100644
--- a/drivers/media/video/ivtv/ivtv-irq.c
+++ b/drivers/media/video/ivtv/ivtv-irq.c
@@ -71,19 +71,10 @@ static void ivtv_pio_work_handler(struct ivtv *itv)
 	write_reg(IVTV_IRQ_ENC_PIO_COMPLETE, 0x44);
 }
 
-void ivtv_irq_work_handler(struct work_struct *work)
+void ivtv_irq_work_handler(struct kthread_work *work)
 {
-	struct ivtv *itv = container_of(work, struct ivtv, irq_work_queue);
+	struct ivtv *itv = container_of(work, struct ivtv, irq_work);
 
-	DEFINE_WAIT(wait);
-
-	if (test_and_clear_bit(IVTV_F_I_WORK_INITED, &itv->i_flags)) {
-		struct sched_param param = { .sched_priority = 99 };
-
-		/* This thread must use the FIFO scheduler as it
-		   is realtime sensitive. */
-		sched_setscheduler(current, SCHED_FIFO, &param);
-	}
 	if (test_and_clear_bit(IVTV_F_I_WORK_HANDLER_PIO, &itv->i_flags))
 		ivtv_pio_work_handler(itv);
 
@@ -1019,7 +1010,7 @@ irqreturn_t ivtv_irq_handler(int irq, void *dev_id)
 	}
 
 	if (test_and_clear_bit(IVTV_F_I_HAVE_WORK, &itv->i_flags)) {
-		queue_work(itv->irq_work_queues, &itv->irq_work_queue);
+		queue_kthread_work(&itv->irq_worker, &itv->irq_work);
 	}
 
 	spin_unlock(&itv->dma_reg_lock);
diff --git a/drivers/media/video/ivtv/ivtv-irq.h b/drivers/media/video/ivtv/ivtv-irq.h
index f879a58..1e84433 100644
--- a/drivers/media/video/ivtv/ivtv-irq.h
+++ b/drivers/media/video/ivtv/ivtv-irq.h
@@ -46,7 +46,7 @@
 
 irqreturn_t ivtv_irq_handler(int irq, void *dev_id);
 
-void ivtv_irq_work_handler(struct work_struct *work);
+void ivtv_irq_work_handler(struct kthread_work *work);
 void ivtv_dma_stream_dec_prepare(struct ivtv_stream *s, u32 offset, int lock);
 void ivtv_unfinished_dma(unsigned long arg);
 
-- 
1.7.1


