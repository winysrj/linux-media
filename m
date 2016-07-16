Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:36842 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbcGPIcz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2016 04:32:55 -0400
Date: Sat, 16 Jul 2016 14:02:34 +0530
From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
To: Mike Isely <isely@pobox.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH] [media] pvrusb2: Remove deprecated
 create_singlethread_workqueue
Message-ID: <20160716083234.GA7388@Karyakshetra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The workqueue "workqueue" is involved in polling the pvrusb2 hardware
(pvr2_hdw).

It has a single work item(&hdw->workpoll) and hence doesn't require
ordering. Also, it is not being used on a memory reclaim path.
Hence, the singlethreaded workqueue has been replaced with the use of
system_wq.

System workqueues have been able to handle high level of concurrency
for a long time now and hence it's not required to have a singlethreaded
workqueue just to gain concurrency. Unlike a dedicated per-cpu workqueue
created with create_singlethread_workqueue(), system_wq allows multiple
work items to overlap executions even on the same CPU; however, a
per-cpu workqueue doesn't have any CPU locality or global ordering
guarantee unless the target CPU is explicitly specified and thus the
increase of local concurrency shouldn't make any difference.

Work item has been flushed in pvr2_hdw_destroy to ensure that there are no
pending tasks while disconnecting the driver.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h |  1 -
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c          | 23 +++++++----------------
 2 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h b/drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h
index 60141b1..23473a2 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h
@@ -170,7 +170,6 @@ struct pvr2_hdw {
 	const struct pvr2_device_desc *hdw_desc;

 	/* Kernel worker thread handling */
-	struct workqueue_struct *workqueue;
 	struct work_struct workpoll;     /* Update driver state */

 	/* Video spigot */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index 83e9a3e..85e39ec 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -2624,7 +2624,6 @@ struct pvr2_hdw *pvr2_hdw_create(struct usb_interface *intf,
 	if (cnt1 >= sizeof(hdw->name)) cnt1 = sizeof(hdw->name)-1;
 	hdw->name[cnt1] = 0;

-	hdw->workqueue = create_singlethread_workqueue(hdw->name);
 	INIT_WORK(&hdw->workpoll,pvr2_hdw_worker_poll);

 	pvr2_trace(PVR2_TRACE_INIT,"Driver unit number is %d, name is %s",
@@ -2651,11 +2650,7 @@ struct pvr2_hdw *pvr2_hdw_create(struct usb_interface *intf,
 		del_timer_sync(&hdw->decoder_stabilization_timer);
 		del_timer_sync(&hdw->encoder_run_timer);
 		del_timer_sync(&hdw->encoder_wait_timer);
-		if (hdw->workqueue) {
-			flush_workqueue(hdw->workqueue);
-			destroy_workqueue(hdw->workqueue);
-			hdw->workqueue = NULL;
-		}
+		flush_work(&hdw->workpoll);
 		usb_free_urb(hdw->ctl_read_urb);
 		usb_free_urb(hdw->ctl_write_urb);
 		kfree(hdw->ctl_read_buffer);
@@ -2712,11 +2707,7 @@ void pvr2_hdw_destroy(struct pvr2_hdw *hdw)
 {
 	if (!hdw) return;
 	pvr2_trace(PVR2_TRACE_INIT,"pvr2_hdw_destroy: hdw=%p",hdw);
-	if (hdw->workqueue) {
-		flush_workqueue(hdw->workqueue);
-		destroy_workqueue(hdw->workqueue);
-		hdw->workqueue = NULL;
-	}
+	flush_work(&hdw->workpoll);
 	del_timer_sync(&hdw->quiescent_timer);
 	del_timer_sync(&hdw->decoder_stabilization_timer);
 	del_timer_sync(&hdw->encoder_run_timer);
@@ -4439,7 +4430,7 @@ static void pvr2_hdw_quiescent_timeout(unsigned long data)
 	hdw->state_decoder_quiescent = !0;
 	trace_stbit("state_decoder_quiescent",hdw->state_decoder_quiescent);
 	hdw->state_stale = !0;
-	queue_work(hdw->workqueue,&hdw->workpoll);
+	schedule_work(&hdw->workpoll);
 }


@@ -4450,7 +4441,7 @@ static void pvr2_hdw_decoder_stabilization_timeout(unsigned long data)
 	hdw->state_decoder_ready = !0;
 	trace_stbit("state_decoder_ready", hdw->state_decoder_ready);
 	hdw->state_stale = !0;
-	queue_work(hdw->workqueue, &hdw->workpoll);
+	schedule_work(&hdw->workpoll);
 }


@@ -4461,7 +4452,7 @@ static void pvr2_hdw_encoder_wait_timeout(unsigned long data)
 	hdw->state_encoder_waitok = !0;
 	trace_stbit("state_encoder_waitok",hdw->state_encoder_waitok);
 	hdw->state_stale = !0;
-	queue_work(hdw->workqueue,&hdw->workpoll);
+	schedule_work(&hdw->workpoll);
 }


@@ -4473,7 +4464,7 @@ static void pvr2_hdw_encoder_run_timeout(unsigned long data)
 		hdw->state_encoder_runok = !0;
 		trace_stbit("state_encoder_runok",hdw->state_encoder_runok);
 		hdw->state_stale = !0;
-		queue_work(hdw->workqueue,&hdw->workpoll);
+		schedule_work(&hdw->workpoll);
 	}
 }

@@ -4987,7 +4978,7 @@ static void pvr2_hdw_state_sched(struct pvr2_hdw *hdw)
 	if (hdw->state_stale) return;
 	hdw->state_stale = !0;
 	trace_stbit("state_stale",hdw->state_stale);
-	queue_work(hdw->workqueue,&hdw->workpoll);
+	schedule_work(&hdw->workpoll);
 }


--
2.1.4

