Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:58353 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751967AbeADC5r (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Jan 2018 21:57:47 -0500
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: tfiga@chromium.org, rajmohan.mani@intel.com,
        Yong Zhi <yong.zhi@intel.com>,
        Cao Bing Bu <bingbu.cao@intel.com>
Subject: [PATCH 2/2] media: intel-ipu3: cio2: fix for wrong vb2buf state warnings
Date: Wed,  3 Jan 2018 20:57:17 -0600
Message-Id: <1515034637-3517-2-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1515034637-3517-1-git-send-email-yong.zhi@intel.com>
References: <1515034637-3517-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cio2 driver should release buffer with QUEUED state
when start_stream op failed, wrong buffer state will
cause vb2 core throw a warning.

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
Signed-off-by: Cao Bing Bu <bingbu.cao@intel.com>
---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 949f43d206ad..106d04306372 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -785,7 +785,8 @@ static irqreturn_t cio2_irq(int irq, void *cio2_ptr)
 
 /**************** Videobuf2 interface ****************/
 
-static void cio2_vb2_return_all_buffers(struct cio2_queue *q)
+static void cio2_vb2_return_all_buffers(struct cio2_queue *q,
+					enum vb2_buffer_state state)
 {
 	unsigned int i;
 
@@ -793,7 +794,7 @@ static void cio2_vb2_return_all_buffers(struct cio2_queue *q)
 		if (q->bufs[i]) {
 			atomic_dec(&q->bufs_queued);
 			vb2_buffer_done(&q->bufs[i]->vbb.vb2_buf,
-					VB2_BUF_STATE_ERROR);
+					state);
 		}
 	}
 }
@@ -1019,7 +1020,7 @@ static int cio2_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
 	media_pipeline_stop(&q->vdev.entity);
 fail_pipeline:
 	dev_dbg(&cio2->pci_dev->dev, "failed to start streaming (%d)\n", r);
-	cio2_vb2_return_all_buffers(q);
+	cio2_vb2_return_all_buffers(q, VB2_BUF_STATE_QUEUED);
 	pm_runtime_put(&cio2->pci_dev->dev);
 
 	return r;
@@ -1035,7 +1036,7 @@ static void cio2_vb2_stop_streaming(struct vb2_queue *vq)
 			"failed to stop sensor streaming\n");
 
 	cio2_hw_exit(cio2, q);
-	cio2_vb2_return_all_buffers(q);
+	cio2_vb2_return_all_buffers(q, VB2_BUF_STATE_ERROR);
 	media_pipeline_stop(&q->vdev.entity);
 	pm_runtime_put(&cio2->pci_dev->dev);
 	cio2->streaming = false;
-- 
2.7.4
