Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:35449 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424Ab0ADODQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2010 09:03:16 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, hverkuil@xs4all.nl,
	davinci-linux-open-source@linux.davincidsp.com,
	m-karicheri2@ti.com, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 8/9] VPFE Capture: Add call back function for interrupt clear to vpfe_cfg
Date: Mon,  4 Jan 2010 19:33:01 +0530
Message-Id: <1262613782-20463-9-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

For the devices like AM3517, it is expected that driver clears the
interrupt in ISR. Since this is device spcific, callback function
added to the platform_data.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/ti-media/vpfe_capture.c |   24 ++++++++++++++++++++----
 include/media/ti-media/vpfe_capture.h       |    2 ++
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/ti-media/vpfe_capture.c b/drivers/media/video/ti-media/vpfe_capture.c
index 7187eaa..95538b2 100644
--- a/drivers/media/video/ti-media/vpfe_capture.c
+++ b/drivers/media/video/ti-media/vpfe_capture.c
@@ -475,6 +475,11 @@ static int vpfe_initialize_device(struct vpfe_device *vpfe_dev)
 	ret = ccdc_dev->hw_ops.open(vpfe_dev->pdev);
 	if (!ret)
 		vpfe_dev->initialized = 1;
+
+	/* Clear all VPFE/CCDC interrupts */
+	if (vpfe_dev->cfg->clr_intr)
+		vpfe_dev->cfg->clr_intr(-1);
+
 unlock:
 	mutex_unlock(&ccdc_lock);
 	return ret;
@@ -562,7 +567,7 @@ static irqreturn_t vpfe_isr(int irq, void *dev_id)
 
 	/* if streaming not started, don't do anything */
 	if (!vpfe_dev->started)
-		return IRQ_HANDLED;
+		goto clear_intr;
 
 	/* only for 6446 this will be applicable */
 	if (NULL != ccdc_dev->hw_ops.reset)
@@ -574,7 +579,7 @@ static irqreturn_t vpfe_isr(int irq, void *dev_id)
 			"frame format is progressive...\n");
 		if (vpfe_dev->cur_frm != vpfe_dev->next_frm)
 			vpfe_process_buffer_complete(vpfe_dev);
-		return IRQ_HANDLED;
+		goto clear_intr;
 	}
 
 	/* interlaced or TB capture check which field we are in hardware */
@@ -604,7 +609,7 @@ static irqreturn_t vpfe_isr(int irq, void *dev_id)
 				addr += vpfe_dev->field_off;
 				ccdc_dev->hw_ops.setfbaddr(addr);
 			}
-			return IRQ_HANDLED;
+			goto clear_intr;
 		}
 		/*
 		 * if one field is just being captured configure
@@ -624,6 +629,10 @@ static irqreturn_t vpfe_isr(int irq, void *dev_id)
 		 */
 		vpfe_dev->field_id = fid;
 	}
+clear_intr:
+	if (vpfe_dev->cfg->clr_intr)
+		vpfe_dev->cfg->clr_intr(irq);
+
 	return IRQ_HANDLED;
 }
 
@@ -635,8 +644,11 @@ static irqreturn_t vdint1_isr(int irq, void *dev_id)
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "\nInside vdint1_isr...\n");
 
 	/* if streaming not started, don't do anything */
-	if (!vpfe_dev->started)
+	if (!vpfe_dev->started) {
+		if (vpfe_dev->cfg->clr_intr)
+			vpfe_dev->cfg->clr_intr(irq);
 		return IRQ_HANDLED;
+	}
 
 	spin_lock(&vpfe_dev->dma_queue_lock);
 	if ((vpfe_dev->fmt.fmt.pix.field == V4L2_FIELD_NONE) &&
@@ -644,6 +656,10 @@ static irqreturn_t vdint1_isr(int irq, void *dev_id)
 	    vpfe_dev->cur_frm == vpfe_dev->next_frm)
 		vpfe_schedule_next_buffer(vpfe_dev);
 	spin_unlock(&vpfe_dev->dma_queue_lock);
+
+	if (vpfe_dev->cfg->clr_intr)
+		vpfe_dev->cfg->clr_intr(irq);
+
 	return IRQ_HANDLED;
 }
 
diff --git a/include/media/ti-media/vpfe_capture.h b/include/media/ti-media/vpfe_capture.h
index 5287368..f0a7b7a 100644
--- a/include/media/ti-media/vpfe_capture.h
+++ b/include/media/ti-media/vpfe_capture.h
@@ -94,6 +94,8 @@ struct vpfe_config {
 	/* vpfe clock */
 	struct clk *vpssclk;
 	struct clk *slaveclk;
+	/* Function for Clearing the interrupt */
+	void (*clr_intr)(int vdint);
 };
 
 struct vpfe_device {
-- 
1.6.2.4

