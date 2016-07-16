Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:33886 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbcGPIub (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2016 04:50:31 -0400
Date: Sat, 16 Jul 2016 14:20:28 +0530
From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH] [media] gspca: sonixj: Remove deprecated
 create_singlethread_workqueue
Message-ID: <20160716085028.GA7758@Karyakshetra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The workqueue "work_thread" is involved in updating the JPEG quality
of the gspca_dev. It has a single work item(&sd->work) and hence doesn't
require ordering. Also, it is not being used on a memory reclaim path.
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

Work item has been flushed in sd_stop0() to ensure that there are no
pending tasks while disconnecting the driver.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 drivers/media/usb/gspca/sonixj.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/gspca/sonixj.c b/drivers/media/usb/gspca/sonixj.c
index fd1c870..d49d76e 100644
--- a/drivers/media/usb/gspca/sonixj.c
+++ b/drivers/media/usb/gspca/sonixj.c
@@ -54,7 +54,6 @@ struct sd {
 	u32 exposure;

 	struct work_struct work;
-	struct workqueue_struct *work_thread;

 	u32 pktsz;			/* (used by pkt_scan) */
 	u16 npkt;
@@ -2485,7 +2484,6 @@ static int sd_start(struct gspca_dev *gspca_dev)

 	sd->pktsz = sd->npkt = 0;
 	sd->nchg = sd->short_mark = 0;
-	sd->work_thread = create_singlethread_workqueue(MODULE_NAME);

 	return gspca_dev->usb_err;
 }
@@ -2569,12 +2567,9 @@ static void sd_stop0(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

-	if (sd->work_thread != NULL) {
-		mutex_unlock(&gspca_dev->usb_lock);
-		destroy_workqueue(sd->work_thread);
-		mutex_lock(&gspca_dev->usb_lock);
-		sd->work_thread = NULL;
-	}
+	mutex_unlock(&gspca_dev->usb_lock);
+	flush_work(&sd->work);
+	mutex_lock(&gspca_dev->usb_lock);
 }

 static void do_autogain(struct gspca_dev *gspca_dev)
@@ -2785,7 +2780,7 @@ marker_found:
 				new_qual = QUALITY_MAX;
 			if (new_qual != sd->quality) {
 				sd->quality = new_qual;
-				queue_work(sd->work_thread, &sd->work);
+				schedule_work(&sd->work);
 			}
 		}
 	} else {
--
2.1.4

