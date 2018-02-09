Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:29985 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752018AbeBIAOn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 19:14:43 -0500
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: tfiga@chromium.org, tian.shu.qiu@intel.com,
        jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH] media: intel-ipu3: cio2: Disable and sync irq before stream off
Date: Thu,  8 Feb 2018 16:14:24 -0800
Message-Id: <1518135264-32310-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is to avoid pending interrupts to be handled during
stream off, in which case, the ready buffer will be removed
from buffer list, thus not all buffers can be returned to VB2
as expected. Disable CIO2 irq at cio2_hw_exit() so no new
interrupts are generated.

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 6c4444b..b6b0cfe 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -526,6 +526,8 @@ static void cio2_hw_exit(struct cio2_device *cio2, struct cio2_queue *q)
 	unsigned int i, maxloops = 1000;
 
 	/* Disable CSI receiver and MIPI backend devices */
+	writel(0, q->csi_rx_base + CIO2_REG_IRQCTRL_MASK);
+	writel(0, q->csi_rx_base + CIO2_REG_IRQCTRL_ENABLE);
 	writel(0, q->csi_rx_base + CIO2_REG_CSIRX_ENABLE);
 	writel(0, q->csi_rx_base + CIO2_REG_MIPIBE_ENABLE);
 
@@ -1035,6 +1037,7 @@ static void cio2_vb2_stop_streaming(struct vb2_queue *vq)
 			"failed to stop sensor streaming\n");
 
 	cio2_hw_exit(cio2, q);
+	synchronize_irq(cio2->pci_dev->irq);
 	cio2_vb2_return_all_buffers(q, VB2_BUF_STATE_ERROR);
 	media_pipeline_stop(&q->vdev.entity);
 	pm_runtime_put(&cio2->pci_dev->dev);
@@ -1976,6 +1979,7 @@ static int __maybe_unused cio2_suspend(struct device *dev)
 
 	/* Stop stream */
 	cio2_hw_exit(cio2, q);
+	synchronize_irq(pci_dev->irq);
 
 	pm_runtime_force_suspend(dev);
 
-- 
1.9.1
