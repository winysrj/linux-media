Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:49150 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757291AbZKRPwu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 10:52:50 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, m-karicheri2@ti.com,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH V2] VPFE Capture: Add call back function for interrupt clear to vpfe_cfg
Date: Wed, 18 Nov 2009 21:22:49 +0530
Message-Id: <1258559569-1056-1-git-send-email-hvaibhav@ti.com>
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
 drivers/media/video/davinci/vpfe_capture.c |   24 ++++++++++++++++++++----
 include/media/davinci/vpfe_capture.h       |    2 ++
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index 9b6b254..46e2939 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -563,6 +563,11 @@ static int vpfe_initialize_device(struct vpfe_device *vpfe_dev)
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
@@ -664,7 +669,7 @@ static irqreturn_t vpfe_isr(int irq, void *dev_id)

 	/* if streaming not started, don't do anything */
 	if (!vpfe_dev->started)
-		return IRQ_HANDLED;
+		goto clear_intr;

 	/* only for 6446 this will be applicable */
 	if (NULL != ccdc_dev->hw_ops.reset)
@@ -676,7 +681,7 @@ static irqreturn_t vpfe_isr(int irq, void *dev_id)
 			"frame format is progressive...\n");
 		if (vpfe_dev->cur_frm != vpfe_dev->next_frm)
 			vpfe_process_buffer_complete(vpfe_dev);
-		return IRQ_HANDLED;
+		goto clear_intr;
 	}

 	/* interlaced or TB capture check which field we are in hardware */
@@ -703,7 +708,7 @@ static irqreturn_t vpfe_isr(int irq, void *dev_id)
 			if (field == V4L2_FIELD_SEQ_TB)
 				vpfe_schedule_bottom_field(vpfe_dev);

-			return IRQ_HANDLED;
+			goto clear_intr;
 		}
 		/*
 		 * if one field is just being captured configure
@@ -723,6 +728,10 @@ static irqreturn_t vpfe_isr(int irq, void *dev_id)
 		 */
 		vpfe_dev->field_id = fid;
 	}
+clear_intr:
+	if (vpfe_dev->cfg->clr_intr)
+		vpfe_dev->cfg->clr_intr(irq);
+
 	return IRQ_HANDLED;
 }

@@ -734,8 +743,11 @@ static irqreturn_t vdint1_isr(int irq, void *dev_id)
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
@@ -743,6 +755,10 @@ static irqreturn_t vdint1_isr(int irq, void *dev_id)
 	    vpfe_dev->cur_frm == vpfe_dev->next_frm)
 		vpfe_schedule_next_buffer(vpfe_dev);
 	spin_unlock(&vpfe_dev->dma_queue_lock);
+
+	if (vpfe_dev->cfg->clr_intr)
+		vpfe_dev->cfg->clr_intr(irq);
+
 	return IRQ_HANDLED;
 }

diff --git a/include/media/davinci/vpfe_capture.h b/include/media/davinci/vpfe_capture.h
index fc83d98..5a21265 100644
--- a/include/media/davinci/vpfe_capture.h
+++ b/include/media/davinci/vpfe_capture.h
@@ -104,6 +104,8 @@ struct vpfe_config {
 	char *ccdc;
 	/* setup function for the input path */
 	int (*setup_input)(enum vpfe_subdev_id id);
+	/* Function for Clearing the interrupt */
+	void (*clr_intr)(int vdint);
 	/* number of clocks */
 	int num_clocks;
 	/* clocks used for vpfe capture */
--
1.6.2.4

