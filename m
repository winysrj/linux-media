Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35653 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbcGPIaa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2016 04:30:30 -0400
Date: Sat, 16 Jul 2016 14:00:25 +0530
From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
To: Kyungmin Park <kyungmin.park@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH] [media] s5p-mfc: Remove deprecated
 create_singlethread_workqueue
Message-ID: <20160716083025.GA7294@Karyakshetra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

alloc_workqueue replaces deprecated create_singlethread_workqueue().

The MFC device driver is a v4l2 driver which can encode/decode video
raw/elementary streams and has support for all popular video codecs.

The driver's watchdog_workqueue has been replaced with system_wq since
it queues a single work item, &dev->watchdog_work, which calls for no
ordering requirement. The work item is involved in running the watchdog
timer and is not being used on a memory reclaim path.

Work item has been flushed in s5p_mfc_remove() to ensure
that there are no pending tasks while disconnecting the driver.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index b16466f..1bc27ec 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -152,7 +152,7 @@ static void s5p_mfc_watchdog(unsigned long arg)
 		 * error. Now it is time to kill all instances and
 		 * reset the MFC. */
 		mfc_err("Time out during waiting for HW\n");
-		queue_work(dev->watchdog_workqueue, &dev->watchdog_work);
+		schedule_work(&dev->watchdog_work);
 	}
 	dev->watchdog_timer.expires = jiffies +
 					msecs_to_jiffies(MFC_WATCHDOG_INTERVAL);
@@ -1238,7 +1238,6 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, dev);

 	dev->hw_lock = 0;
-	dev->watchdog_workqueue = create_singlethread_workqueue(S5P_MFC_NAME);
 	INIT_WORK(&dev->watchdog_work, s5p_mfc_watchdog_worker);
 	atomic_set(&dev->watchdog_cnt, 0);
 	init_timer(&dev->watchdog_timer);
@@ -1284,8 +1283,7 @@ static int s5p_mfc_remove(struct platform_device *pdev)
 	v4l2_info(&dev->v4l2_dev, "Removing %s\n", pdev->name);

 	del_timer_sync(&dev->watchdog_timer);
-	flush_workqueue(dev->watchdog_workqueue);
-	destroy_workqueue(dev->watchdog_workqueue);
+	flush_work(&dev->watchdog_work);

 	video_unregister_device(dev->vfd_enc);
 	video_unregister_device(dev->vfd_dec);
--
2.1.4

