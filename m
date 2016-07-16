Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:35533 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbcGPIxv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2016 04:53:51 -0400
Date: Sat, 16 Jul 2016 14:23:48 +0530
From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH] [media] gspca: jl2005bcd: Remove deprecated
 create_singlethread_workqueue
Message-ID: <20160716085348.GA7817@Karyakshetra>
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
 drivers/media/usb/gspca/jl2005bcd.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/gspca/jl2005bcd.c b/drivers/media/usb/gspca/jl2005bcd.c
index 5b481fa..ac295f0 100644
--- a/drivers/media/usb/gspca/jl2005bcd.c
+++ b/drivers/media/usb/gspca/jl2005bcd.c
@@ -45,7 +45,6 @@ struct sd {
 	const struct v4l2_pix_format *cap_mode;
 	/* Driver stuff */
 	struct work_struct work_struct;
-	struct workqueue_struct *work_thread;
 	u8 frame_brightness;
 	int block_size;	/* block size of camera */
 	int vga;	/* 1 if vga cam, 0 if cif cam */
@@ -477,9 +476,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		return -1;
 	}

-	/* Start the workqueue function to do the streaming */
-	sd->work_thread = create_singlethread_workqueue(MODULE_NAME);
-	queue_work(sd->work_thread, &sd->work_struct);
+	schedule_work(&sd->work_struct);

 	return 0;
 }
@@ -493,8 +490,7 @@ static void sd_stop0(struct gspca_dev *gspca_dev)
 	/* wait for the work queue to terminate */
 	mutex_unlock(&gspca_dev->usb_lock);
 	/* This waits for sq905c_dostream to finish */
-	destroy_workqueue(dev->work_thread);
-	dev->work_thread = NULL;
+	flush_work(&dev->work_struct);
 	mutex_lock(&gspca_dev->usb_lock);
 }

--
2.1.4

