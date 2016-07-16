Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:33884 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbcGPJNY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2016 05:13:24 -0400
Date: Sat, 16 Jul 2016 14:43:20 +0530
From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Inki Dae <inki.dae@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/2] [media] cx25821: Remove deprecated
 create_singlethread_workqueue
Message-ID: <ee0a1b0f01f07c3e0e1cbd2fa86e5da4c43629cb.1468659580.git.bhaktipriya96@gmail.com>
References: <cover.1468659580.git.bhaktipriya96@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1468659580.git.bhaktipriya96@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The workqueue "_irq_audio_queues" runs the audio upstream handler.
It has a single work item(&dev->_audio_work_entry) and hence doesn't
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

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 drivers/media/pci/cx25821/cx25821-audio-upstream.c | 11 +----------
 drivers/media/pci/cx25821/cx25821.h                |  1 -
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-audio-upstream.c b/drivers/media/pci/cx25821/cx25821-audio-upstream.c
index 05bd957..1a86dff 100644
--- a/drivers/media/pci/cx25821/cx25821-audio-upstream.c
+++ b/drivers/media/pci/cx25821/cx25821-audio-upstream.c
@@ -446,8 +446,7 @@ static int cx25821_audio_upstream_irq(struct cx25821_dev *dev, int chan_num,

 			dev->_audioframe_index = dev->_last_index_irq;

-			queue_work(dev->_irq_audio_queues,
-				   &dev->_audio_work_entry);
+			schedule_work(&dev->_audio_work_entry);
 		}

 		if (dev->_is_first_audio_frame) {
@@ -639,14 +638,6 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)

 	/* Work queue */
 	INIT_WORK(&dev->_audio_work_entry, cx25821_audioups_handler);
-	dev->_irq_audio_queues =
-	    create_singlethread_workqueue("cx25821_audioworkqueue");
-
-	if (!dev->_irq_audio_queues) {
-		printk(KERN_DEBUG
-			pr_fmt("ERROR: create_singlethread_workqueue() for Audio FAILED!\n"));
-		return -ENOMEM;
-	}

 	dev->_last_index_irq = 0;
 	dev->_audio_is_running = 0;
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index a513b68..c813d88 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -294,7 +294,6 @@ struct cx25821_dev {
 	u32 audio_upstream_riscbuf_size;
 	u32 audio_upstream_databuf_size;
 	int _audioframe_index;
-	struct workqueue_struct *_irq_audio_queues;
 	struct work_struct _audio_work_entry;
 	char *input_audiofilename;

--
2.1.4

