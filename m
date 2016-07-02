Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33645 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbcGBKrf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jul 2016 06:47:35 -0400
Date: Sat, 2 Jul 2016 16:17:31 +0530
From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Markus Elfring <elfring@users.sourceforge.net>
Cc: Tejun Heo <tj@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [media] hdpvr: Remove deprecated
 create_singlethread_workqueue
Message-ID: <20160702104731.GA2358@Karyakshetra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The workqueue "workqueue" is involved in tranmitting hdpvr buffers.
It has a single work item(&dev->worker) and hence doesn't require
ordering. Also, it is not being used on a memory reclaim path. Hence,
the singlethreaded workqueue has been replaced with the use of system_wq.

System workqueues have been able to handle high level of concurrency
for a long time now and hence it's not required to have a singlethreaded
workqueue just to gain concurrency. Unlike a dedicated per-cpu workqueue
created with create_singlethread_workqueue(), system_wq allows multiple
work items to overlap executions even on the same CPU; however, a
per-cpu workqueue doesn't have any CPU locality or global ordering
guarantee unless the target CPU is explicitly specified and thus the
increase of local concurrency shouldn't make any difference.

Work item has been flushed in hdpvr_device_release() to ensure
that there are no pending tasks while disconnecting the driver.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 drivers/media/usb/hdpvr/hdpvr-core.c  | 10 ++--------
 drivers/media/usb/hdpvr/hdpvr-video.c |  6 +++---
 drivers/media/usb/hdpvr/hdpvr.h       |  2 --
 3 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
index 08f0ca7..a61d8fd 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -310,10 +310,6 @@ static int hdpvr_probe(struct usb_interface *interface,
 	init_waitqueue_head(&dev->wait_buffer);
 	init_waitqueue_head(&dev->wait_data);

-	dev->workqueue = create_singlethread_workqueue("hdpvr_buffer");
-	if (!dev->workqueue)
-		goto error;
-
 	dev->options = hdpvr_default_options;

 	if (default_video_input < HDPVR_VIDEO_INPUTS)
@@ -404,9 +400,7 @@ reg_fail:
 #endif
 error:
 	if (dev) {
-		/* Destroy single thread */
-		if (dev->workqueue)
-			destroy_workqueue(dev->workqueue);
+		flush_work(&dev->worker);
 		/* this frees allocated memory */
 		hdpvr_delete(dev);
 	}
@@ -427,7 +421,7 @@ static void hdpvr_disconnect(struct usb_interface *interface)
 	mutex_unlock(&dev->io_mutex);
 	v4l2_device_disconnect(&dev->v4l2_dev);
 	msleep(100);
-	flush_workqueue(dev->workqueue);
+	flush_work(&dev->worker);
 	mutex_lock(&dev->io_mutex);
 	hdpvr_cancel_queue(dev);
 	mutex_unlock(&dev->io_mutex);
diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index ba7f022..2a3a8b4 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -316,7 +316,7 @@ static int hdpvr_start_streaming(struct hdpvr_device *dev)
 	dev->status = STATUS_STREAMING;

 	INIT_WORK(&dev->worker, hdpvr_transmit_buffers);
-	queue_work(dev->workqueue, &dev->worker);
+	schedule_work(&dev->worker);

 	v4l2_dbg(MSG_BUFFER, hdpvr_debug, &dev->v4l2_dev,
 			"streaming started\n");
@@ -350,7 +350,7 @@ static int hdpvr_stop_streaming(struct hdpvr_device *dev)
 	wake_up_interruptible(&dev->wait_buffer);
 	msleep(50);

-	flush_workqueue(dev->workqueue);
+	flush_work(&dev->worker);

 	mutex_lock(&dev->io_mutex);
 	/* kill the still outstanding urbs */
@@ -1123,7 +1123,7 @@ static void hdpvr_device_release(struct video_device *vdev)

 	hdpvr_delete(dev);
 	mutex_lock(&dev->io_mutex);
-	destroy_workqueue(dev->workqueue);
+	flush_work(&dev->worker);
 	mutex_unlock(&dev->io_mutex);

 	v4l2_device_unregister(&dev->v4l2_dev);
diff --git a/drivers/media/usb/hdpvr/hdpvr.h b/drivers/media/usb/hdpvr/hdpvr.h
index 78e8154..a12e0af 100644
--- a/drivers/media/usb/hdpvr/hdpvr.h
+++ b/drivers/media/usb/hdpvr/hdpvr.h
@@ -107,8 +107,6 @@ struct hdpvr_device {
 	/* waitqueue for data */
 	wait_queue_head_t	wait_data;
 	/**/
-	struct workqueue_struct	*workqueue;
-	/**/
 	struct work_struct	worker;
 	/* current stream owner */
 	struct v4l2_fh		*owner;
--
2.1.4

