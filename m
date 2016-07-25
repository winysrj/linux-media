Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33349 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbcGYPF6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2016 11:05:58 -0400
Date: Mon, 25 Jul 2016 20:35:53 +0530
From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Inki Dae <inki.dae@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] [media] cx25821: Remove deprecated
 create_singlethread_workqueue
Message-ID: <4499de0921c2455eb6299f543a18186a769dbef3.1469458280.git.bhaktipriya96@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160725144952.GA11594@Karyakshetra>
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

The work item has been flushed in cx25821_stop_upstream_audio() to ensure
that nothing is pending when the driver is disconnected.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 Changes in v2:
	-Flushed work item and updated the commit description to reflect
	 the same.

 drivers/media/pci/cx25821/cx25821-audio-upstream.c | 14 ++------------
 drivers/media/pci/cx25821/cx25821.h                |  1 -
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-audio-upstream.c b/drivers/media/pci/cx25821/cx25821-audio-upstream.c
index 05bd957..7c8edb6 100644
--- a/drivers/media/pci/cx25821/cx25821-audio-upstream.c
+++ b/drivers/media/pci/cx25821/cx25821-audio-upstream.c
@@ -242,8 +242,7 @@ void cx25821_stop_upstream_audio(struct cx25821_dev *dev)
 	dev->_audioframe_count = 0;
 	dev->_audiofile_status = END_OF_FILE;

-	destroy_workqueue(dev->_irq_audio_queues);
-	dev->_irq_audio_queues = NULL;
+	flush_work(&dev->_audio_work_entry);

 	kfree(dev->_audiofilename);
 }
@@ -446,8 +445,7 @@ static int cx25821_audio_upstream_irq(struct cx25821_dev *dev, int chan_num,

 			dev->_audioframe_index = dev->_last_index_irq;

-			queue_work(dev->_irq_audio_queues,
-				   &dev->_audio_work_entry);
+			schedule_work(&dev->_audio_work_entry);
 		}

 		if (dev->_is_first_audio_frame) {
@@ -639,14 +637,6 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)

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

