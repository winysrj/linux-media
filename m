Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.246]:42680 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751622AbbKCFjO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Nov 2015 00:39:14 -0500
From: Josh Wu <josh.wu@atmel.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Josh Wu <josh.wu@atmel.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/5] media: atmel-isi: prepare for the support of preview path
Date: Tue, 3 Nov 2015 13:45:09 +0800
Message-ID: <1446529512-19109-3-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1446529512-19109-1-git-send-email-josh.wu@atmel.com>
References: <1446529512-19109-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Atmel ISI support a preview path which can output RGB data.

So this patch introduces a bool variable to choose which path is
enabled currently. And also we need setup corresponding path registers.

By default the preview path is disabled. We only use Codec path.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---

Changes in v2: None

 drivers/media/platform/soc_camera/atmel-isi.c | 72 ++++++++++++++++++---------
 1 file changed, 49 insertions(+), 23 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index ce87a16..24501a4 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -79,6 +79,7 @@ struct atmel_isi {
 	dma_addr_t			fb_descriptors_phys;
 	struct				list_head dma_desc_head;
 	struct isi_dma_desc		dma_desc[MAX_BUFFER_NUM];
+	bool				enable_preview_path;
 
 	struct completion		complete;
 	/* ISI peripherial clock */
@@ -195,11 +196,19 @@ static irqreturn_t atmel_isi_handle_streaming(struct atmel_isi *isi)
 		/* start next dma frame. */
 		isi->active = list_entry(isi->video_buffer_list.next,
 					struct frame_buffer, list);
-		isi_writel(isi, ISI_DMA_C_DSCR,
-			(u32)isi->active->p_dma_desc->fbd_phys);
-		isi_writel(isi, ISI_DMA_C_CTRL,
-			ISI_DMA_CTRL_FETCH | ISI_DMA_CTRL_DONE);
-		isi_writel(isi, ISI_DMA_CHER, ISI_DMA_CHSR_C_CH);
+		if (!isi->enable_preview_path) {
+			isi_writel(isi, ISI_DMA_C_DSCR,
+				(u32)isi->active->p_dma_desc->fbd_phys);
+			isi_writel(isi, ISI_DMA_C_CTRL,
+				ISI_DMA_CTRL_FETCH | ISI_DMA_CTRL_DONE);
+			isi_writel(isi, ISI_DMA_CHER, ISI_DMA_CHSR_C_CH);
+		} else {
+			isi_writel(isi, ISI_DMA_P_DSCR,
+				(u32)isi->active->p_dma_desc->fbd_phys);
+			isi_writel(isi, ISI_DMA_P_CTRL,
+				ISI_DMA_CTRL_FETCH | ISI_DMA_CTRL_DONE);
+			isi_writel(isi, ISI_DMA_CHER, ISI_DMA_CHSR_P_CH);
+		}
 	}
 	return IRQ_HANDLED;
 }
@@ -226,7 +235,8 @@ static irqreturn_t isi_interrupt(int irq, void *dev_id)
 		isi_writel(isi, ISI_INTDIS, ISI_CTRL_DIS);
 		ret = IRQ_HANDLED;
 	} else {
-		if (likely(pending & ISI_SR_CXFR_DONE))
+		if (likely(pending & ISI_SR_CXFR_DONE) ||
+				likely(pending & ISI_SR_PXFR_DONE))
 			ret = atmel_isi_handle_streaming(isi);
 	}
 
@@ -368,21 +378,35 @@ static void start_dma(struct atmel_isi *isi, struct frame_buffer *buffer)
 			ISI_SR_CXFR_DONE | ISI_SR_PXFR_DONE);
 
 	/* Check if already in a frame */
-	if (isi_readl(isi, ISI_STATUS) & ISI_CTRL_CDC) {
-		dev_err(isi->soc_host.icd->parent, "Already in frame handling.\n");
-		return;
-	}
+	if (!isi->enable_preview_path) {
+		if (isi_readl(isi, ISI_STATUS) & ISI_CTRL_CDC) {
+			dev_err(isi->soc_host.icd->parent, "Already in frame handling.\n");
+			return;
+		}
 
-	isi_writel(isi, ISI_DMA_C_DSCR, (u32)buffer->p_dma_desc->fbd_phys);
-	isi_writel(isi, ISI_DMA_C_CTRL, ISI_DMA_CTRL_FETCH | ISI_DMA_CTRL_DONE);
-	isi_writel(isi, ISI_DMA_CHER, ISI_DMA_CHSR_C_CH);
+		isi_writel(isi, ISI_DMA_C_DSCR,
+				(u32)buffer->p_dma_desc->fbd_phys);
+		isi_writel(isi, ISI_DMA_C_CTRL,
+				ISI_DMA_CTRL_FETCH | ISI_DMA_CTRL_DONE);
+		isi_writel(isi, ISI_DMA_CHER, ISI_DMA_CHSR_C_CH);
+	} else {
+		isi_writel(isi, ISI_DMA_P_DSCR,
+				(u32)buffer->p_dma_desc->fbd_phys);
+		isi_writel(isi, ISI_DMA_P_CTRL,
+				ISI_DMA_CTRL_FETCH | ISI_DMA_CTRL_DONE);
+		isi_writel(isi, ISI_DMA_CHER, ISI_DMA_CHSR_P_CH);
+	}
 
 	cfg1 &= ~ISI_CFG1_FRATE_DIV_MASK;
 	/* Enable linked list */
 	cfg1 |= isi->pdata.frate | ISI_CFG1_DISCR;
 
-	/* Enable codec path and ISI */
-	ctrl = ISI_CTRL_CDC | ISI_CTRL_EN;
+	/* Enable ISI */
+	ctrl = ISI_CTRL_EN;
+
+	if (!isi->enable_preview_path)
+		ctrl |= ISI_CTRL_CDC;
+
 	isi_writel(isi, ISI_CTRL, ctrl);
 	isi_writel(isi, ISI_CFG1, cfg1);
 }
@@ -458,15 +482,17 @@ static void stop_streaming(struct vb2_queue *vq)
 	}
 	spin_unlock_irq(&isi->lock);
 
-	timeout = jiffies + FRAME_INTERVAL_MILLI_SEC * HZ;
-	/* Wait until the end of the current frame. */
-	while ((isi_readl(isi, ISI_STATUS) & ISI_CTRL_CDC) &&
-			time_before(jiffies, timeout))
-		msleep(1);
+	if (!isi->enable_preview_path) {
+		timeout = jiffies + FRAME_INTERVAL_MILLI_SEC * HZ;
+		/* Wait until the end of the current frame. */
+		while ((isi_readl(isi, ISI_STATUS) & ISI_CTRL_CDC) &&
+				time_before(jiffies, timeout))
+			msleep(1);
 
-	if (time_after(jiffies, timeout))
-		dev_err(icd->parent,
-			"Timeout waiting for finishing codec request\n");
+		if (time_after(jiffies, timeout))
+			dev_err(icd->parent,
+				"Timeout waiting for finishing codec request\n");
+	}
 
 	/* Disable interrupts */
 	isi_writel(isi, ISI_INTDIS,
-- 
1.9.1

