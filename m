Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34836 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbcGBKvZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jul 2016 06:51:25 -0400
Date: Sat, 2 Jul 2016 16:21:22 +0530
From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
To: Brian Johnson <brijohn@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Tejun Heo <tj@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [media] sn9c20x: Remove deprecated
 create_singlethread_workqueue
Message-ID: <20160702105122.GA3059@Karyakshetra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The workqueue "work_thread" is involved in JPEG quality update.
It has a single work item(&sd->work) and hence doesn't require ordering.
Also, it is not being used on a memory reclaim path. Hence, the
singlethreaded workqueue has been replaced with the use of system_wq.

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
 drivers/media/usb/gspca/sn9c20x.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/gspca/sn9c20x.c b/drivers/media/usb/gspca/sn9c20x.c
index d0ee899..10269da 100644
--- a/drivers/media/usb/gspca/sn9c20x.c
+++ b/drivers/media/usb/gspca/sn9c20x.c
@@ -92,7 +92,6 @@ struct sd {
 	struct v4l2_ctrl *jpegqual;

 	struct work_struct work;
-	struct workqueue_struct *work_thread;

 	u32 pktsz;			/* (used by pkt_scan) */
 	u16 npkt;
@@ -2051,8 +2050,6 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	if (mode & MODE_JPEG) {
 		sd->pktsz = sd->npkt = 0;
 		sd->nchg = 0;
-		sd->work_thread =
-			create_singlethread_workqueue(KBUILD_MODNAME);
 	}

 	return gspca_dev->usb_err;
@@ -2070,12 +2067,9 @@ static void sd_stop0(struct gspca_dev *gspca_dev)
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

 static void do_autoexposure(struct gspca_dev *gspca_dev, u16 avg_lum)
@@ -2228,7 +2222,7 @@ static void transfer_check(struct gspca_dev *gspca_dev,
 				new_qual = sd->jpegqual->maximum;
 			if (new_qual != curqual) {
 				sd->jpegqual->cur.val = new_qual;
-				queue_work(sd->work_thread, &sd->work);
+				schedule_work(&sd->work);
 			}
 		}
 	} else {
--
2.1.4

