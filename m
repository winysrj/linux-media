Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:34329 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbcGBLBy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jul 2016 07:01:54 -0400
Date: Sat, 2 Jul 2016 16:19:28 +0530
From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Tejun Heo <tj@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [media] zc3xx: Remove deprecated
 create_singlethread_workqueue
Message-ID: <20160702104928.GA2672@Karyakshetra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The workqueue "work_thread" is involved in updating parameters for
transfers. It has a single work item(&sd->work) and hence
doesn't require ordering. Also, it is not being used on a memory
reclaim path. Hence, the singlethreaded workqueue has been replaced with
the use of system_wq.

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
 drivers/media/usb/gspca/zc3xx.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/gspca/zc3xx.c b/drivers/media/usb/gspca/zc3xx.c
index c5d8ee6..ebdfed4d6 100644
--- a/drivers/media/usb/gspca/zc3xx.c
+++ b/drivers/media/usb/gspca/zc3xx.c
@@ -53,7 +53,6 @@ struct sd {
 	struct v4l2_ctrl *jpegqual;

 	struct work_struct work;
-	struct workqueue_struct *work_thread;

 	u8 reg08;		/* webcam compression quality */

@@ -6826,8 +6825,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		return gspca_dev->usb_err;

 	/* Start the transfer parameters update thread */
-	sd->work_thread = create_singlethread_workqueue(KBUILD_MODNAME);
-	queue_work(sd->work_thread, &sd->work);
+	schedule_work(&sd->work);

 	return 0;
 }
@@ -6838,12 +6836,9 @@ static void sd_stop0(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

-	if (sd->work_thread != NULL) {
-		mutex_unlock(&gspca_dev->usb_lock);
-		destroy_workqueue(sd->work_thread);
-		mutex_lock(&gspca_dev->usb_lock);
-		sd->work_thread = NULL;
-	}
+	mutex_unlock(&gspca_dev->usb_lock);
+	schedule_work(&sd->work);
+	mutex_lock(&gspca_dev->usb_lock);
 	if (!gspca_dev->present)
 		return;
 	send_unknown(gspca_dev, sd->sensor);
--
2.1.4

