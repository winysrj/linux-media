Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35303 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbcGPIz7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2016 04:55:59 -0400
Date: Sat, 16 Jul 2016 14:25:56 +0530
From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
To: Frank Zago <frank@zago.net>, Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH] [media] gspca: finepix: Remove deprecated
 create_singlethread_workqueue
Message-ID: <20160716085556.GA7841@Karyakshetra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The workqueue "work_thread" is involved in streaming the camera data.
It has a single work item(&dev->work_struct) and hence doesn't require
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

Work item has been flushed in sd_stop0() to ensure that there are no
pending tasks while disconnecting the driver.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 drivers/media/usb/gspca/finepix.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/gspca/finepix.c b/drivers/media/usb/gspca/finepix.c
index 52bdb56..ae9a55d 100644
--- a/drivers/media/usb/gspca/finepix.c
+++ b/drivers/media/usb/gspca/finepix.c
@@ -41,7 +41,6 @@ struct usb_fpix {
 	struct gspca_dev gspca_dev;	/* !! must be the first item */

 	struct work_struct work_struct;
-	struct workqueue_struct *work_thread;
 };

 /* Delay after which claim the next frame. If the delay is too small,
@@ -226,9 +225,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	/* Again, reset bulk in endpoint */
 	usb_clear_halt(gspca_dev->dev, gspca_dev->urb[0]->pipe);

-	/* Start the workqueue function to do the streaming */
-	dev->work_thread = create_singlethread_workqueue(MODULE_NAME);
-	queue_work(dev->work_thread, &dev->work_struct);
+	schedule_work(&dev->work_struct);

 	return 0;
 }
@@ -241,9 +238,8 @@ static void sd_stop0(struct gspca_dev *gspca_dev)

 	/* wait for the work queue to terminate */
 	mutex_unlock(&gspca_dev->usb_lock);
-	destroy_workqueue(dev->work_thread);
+	flush_work(&dev->work_struct);
 	mutex_lock(&gspca_dev->usb_lock);
-	dev->work_thread = NULL;
 }

 /* Table of supported USB devices */
--
2.1.4

