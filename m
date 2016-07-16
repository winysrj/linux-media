Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:35262 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbcGPIwW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2016 04:52:22 -0400
Date: Sat, 16 Jul 2016 14:22:19 +0530
From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH] [media] gspca: vicam: Remove deprecated
 create_singlethread_workqueue
Message-ID: <20160716085219.GA7792@Karyakshetra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The workqueue "work_thread" is involved in streaming the camera data.
It has a single work item(&sd->work_struct) and hence doesn't require
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
 drivers/media/usb/gspca/vicam.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/gspca/vicam.c b/drivers/media/usb/gspca/vicam.c
index 103f6c4..8860510 100644
--- a/drivers/media/usb/gspca/vicam.c
+++ b/drivers/media/usb/gspca/vicam.c
@@ -47,7 +47,6 @@ MODULE_FIRMWARE(VICAM_FIRMWARE);
 struct sd {
 	struct gspca_dev gspca_dev;	/* !! must be the first item */
 	struct work_struct work_struct;
-	struct workqueue_struct *work_thread;
 };

 /* The vicam sensor has a resolution of 512 x 244, with I believe square
@@ -278,9 +277,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	if (ret < 0)
 		return ret;

-	/* Start the workqueue function to do the streaming */
-	sd->work_thread = create_singlethread_workqueue(MODULE_NAME);
-	queue_work(sd->work_thread, &sd->work_struct);
+	schedule_work(&sd->work_struct);

 	return 0;
 }
@@ -294,8 +291,7 @@ static void sd_stop0(struct gspca_dev *gspca_dev)
 	/* wait for the work queue to terminate */
 	mutex_unlock(&gspca_dev->usb_lock);
 	/* This waits for vicam_dostream to finish */
-	destroy_workqueue(dev->work_thread);
-	dev->work_thread = NULL;
+	flush_work(&dev->work_struct);
 	mutex_lock(&gspca_dev->usb_lock);

 	if (gspca_dev->present)
--
2.1.4

