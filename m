Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:51875 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757123AbbEVOAG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2015 10:00:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 07/11] cobalt: fix sparse warnings
Date: Fri, 22 May 2015 15:59:40 +0200
Message-Id: <1432303184-8594-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1432303184-8594-1-git-send-email-hverkuil@xs4all.nl>
References: <1432303184-8594-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/pci/cobalt/cobalt-irq.c:62:33: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-irq.c:64:17: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-irq.c:65:23: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-irq.c:72:21: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-irq.c:73:25: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-irq.c:74:25: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-irq.c:82:33: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-irq.c:83:33: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-irq.c:91:25: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-irq.c:94:23: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-irq.c:103:25: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-irq.c:107:17: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-irq.c:109:17: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-irq.c:116:13: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-irq.c:119:17: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-irq.c:120:17: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-irq.c:122:17: warning: dereference of noderef expression

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cobalt/cobalt-irq.c | 51 +++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-irq.c b/drivers/media/pci/cobalt/cobalt-irq.c
index a133dfc..dd4bff9 100644
--- a/drivers/media/pci/cobalt/cobalt-irq.c
+++ b/drivers/media/pci/cobalt/cobalt-irq.c
@@ -28,13 +28,13 @@ static void cobalt_dma_stream_queue_handler(struct cobalt_stream *s)
 {
 	struct cobalt *cobalt = s->cobalt;
 	int rx = s->video_channel;
-	volatile struct m00473_freewheel_regmap __iomem *fw =
+	struct m00473_freewheel_regmap __iomem *fw =
 		COBALT_CVI_FREEWHEEL(s->cobalt, rx);
-	volatile struct m00233_video_measure_regmap __iomem *vmr =
+	struct m00233_video_measure_regmap __iomem *vmr =
 		COBALT_CVI_VMR(s->cobalt, rx);
-	volatile struct m00389_cvi_regmap __iomem *cvi =
+	struct m00389_cvi_regmap __iomem *cvi =
 		COBALT_CVI(s->cobalt, rx);
-	volatile struct m00479_clk_loss_detector_regmap __iomem *clkloss =
+	struct m00479_clk_loss_detector_regmap __iomem *clkloss =
 		COBALT_CVI_CLK_LOSS(s->cobalt, rx);
 	struct cobalt_buffer *cb;
 	bool skip = false;
@@ -59,19 +59,21 @@ static void cobalt_dma_stream_queue_handler(struct cobalt_stream *s)
 		goto done;
 
 	if (s->unstable_frame) {
-		uint32_t stat = vmr->irq_status;
+		uint32_t stat = ioread32(&vmr->irq_status);
 
-		vmr->irq_status = stat;
-		if (!(vmr->status & M00233_STATUS_BITMAP_INIT_DONE_MSK)) {
+		iowrite32(stat, &vmr->irq_status);
+		if (!(ioread32(&vmr->status) &
+		      M00233_STATUS_BITMAP_INIT_DONE_MSK)) {
 			cobalt_dbg(1, "!init_done\n");
 			if (s->enable_freewheel)
 				goto restart_fw;
 			goto done;
 		}
 
-		if (clkloss->status & M00479_STATUS_BITMAP_CLOCK_MISSING_MSK) {
-			clkloss->ctrl = 0;
-			clkloss->ctrl = M00479_CTRL_BITMAP_ENABLE_MSK;
+		if (ioread32(&clkloss->status) &
+		    M00479_STATUS_BITMAP_CLOCK_MISSING_MSK) {
+			iowrite32(0, &clkloss->ctrl);
+			iowrite32(M00479_CTRL_BITMAP_ENABLE_MSK, &clkloss->ctrl);
 			cobalt_dbg(1, "no clock\n");
 			if (s->enable_freewheel)
 				goto restart_fw;
@@ -79,8 +81,8 @@ static void cobalt_dma_stream_queue_handler(struct cobalt_stream *s)
 		}
 		if ((stat & (M00233_IRQ_STATUS_BITMAP_VACTIVE_AREA_MSK |
 			     M00233_IRQ_STATUS_BITMAP_HACTIVE_AREA_MSK)) ||
-				vmr->vactive_area != s->timings.bt.height ||
-				vmr->hactive_area != s->timings.bt.width) {
+				ioread32(&vmr->vactive_area) != s->timings.bt.height ||
+				ioread32(&vmr->hactive_area) != s->timings.bt.width) {
 			cobalt_dbg(1, "unstable\n");
 			if (s->enable_freewheel)
 				goto restart_fw;
@@ -88,10 +90,10 @@ static void cobalt_dma_stream_queue_handler(struct cobalt_stream *s)
 		}
 		if (!s->enable_cvi) {
 			s->enable_cvi = true;
-			cvi->control = M00389_CONTROL_BITMAP_ENABLE_MSK;
+			iowrite32(M00389_CONTROL_BITMAP_ENABLE_MSK, &cvi->control);
 			goto done;
 		}
-		if (!(cvi->status & M00389_STATUS_BITMAP_LOCK_MSK)) {
+		if (!(ioread32(&cvi->status) & M00389_STATUS_BITMAP_LOCK_MSK)) {
 			cobalt_dbg(1, "cvi no lock\n");
 			if (s->enable_freewheel)
 				goto restart_fw;
@@ -100,26 +102,29 @@ static void cobalt_dma_stream_queue_handler(struct cobalt_stream *s)
 		if (!s->enable_freewheel) {
 			cobalt_dbg(1, "stable\n");
 			s->enable_freewheel = true;
-			fw->ctrl = 0;
+			iowrite32(0, &fw->ctrl);
 			goto done;
 		}
 		cobalt_dbg(1, "enabled fw\n");
-		vmr->control = M00233_CONTROL_BITMAP_ENABLE_MEASURE_MSK |
-			       M00233_CONTROL_BITMAP_ENABLE_INTERRUPT_MSK;
-		fw->ctrl = M00473_CTRL_BITMAP_ENABLE_MSK;
+		iowrite32(M00233_CONTROL_BITMAP_ENABLE_MEASURE_MSK |
+			  M00233_CONTROL_BITMAP_ENABLE_INTERRUPT_MSK,
+			  &vmr->control);
+		iowrite32(M00473_CTRL_BITMAP_ENABLE_MSK, &fw->ctrl);
 		s->enable_freewheel = false;
 		s->unstable_frame = false;
 		s->skip_first_frames = 2;
 		skip = true;
 		goto done;
 	}
-	if (fw->status & M00473_STATUS_BITMAP_FREEWHEEL_MODE_MSK) {
+	if (ioread32(&fw->status) & M00473_STATUS_BITMAP_FREEWHEEL_MODE_MSK) {
 restart_fw:
 		cobalt_dbg(1, "lost lock\n");
-		vmr->control = M00233_CONTROL_BITMAP_ENABLE_MEASURE_MSK;
-		fw->ctrl = M00473_CTRL_BITMAP_ENABLE_MSK |
-			   M00473_CTRL_BITMAP_FORCE_FREEWHEEL_MODE_MSK;
-		cvi->control = 0;
+		iowrite32(M00233_CONTROL_BITMAP_ENABLE_MEASURE_MSK,
+			  &vmr->control);
+		iowrite32(M00473_CTRL_BITMAP_ENABLE_MSK |
+			  M00473_CTRL_BITMAP_FORCE_FREEWHEEL_MODE_MSK,
+			  &fw->ctrl);
+		iowrite32(0, &cvi->control);
 		s->unstable_frame = true;
 		s->enable_freewheel = false;
 		s->enable_cvi = false;
-- 
2.1.4

