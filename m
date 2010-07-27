Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:41511 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046Ab0G0MHH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jul 2010 08:07:07 -0400
From: Baruch Siach <baruch@tkos.co.il>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <kernel@pengutronix.de>,
	Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH 2/4] mx2_camera: return IRQ_NONE when doing nothing
Date: Tue, 27 Jul 2010 15:06:08 +0300
Message-Id: <49da2476310a921b19226d572503b7c04175204d.1280229966.git.baruch@tkos.co.il>
In-Reply-To: <cover.1280229966.git.baruch@tkos.co.il>
References: <cover.1280229966.git.baruch@tkos.co.il>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/media/video/mx2_camera.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 1536bd4..b42ad8d 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -420,15 +420,17 @@ static irqreturn_t mx25_camera_irq(int irq_csi, void *data)
 	struct mx2_camera_dev *pcdev = data;
 	u32 status = readl(pcdev->base_csi + CSISR);
 
-	if (status & CSISR_DMA_TSF_FB1_INT)
+	writel(status, pcdev->base_csi + CSISR);
+
+	if (!(status & (CSISR_DMA_TSF_FB1_INT | CSISR_DMA_TSF_FB2_INT)))
+		return IRQ_NONE;
+	else if (status & CSISR_DMA_TSF_FB1_INT)
 		mx25_camera_frame_done(pcdev, 1, VIDEOBUF_DONE);
 	else if (status & CSISR_DMA_TSF_FB2_INT)
 		mx25_camera_frame_done(pcdev, 2, VIDEOBUF_DONE);
 
 	/* FIXME: handle CSISR_RFF_OR_INT */
 
-	writel(status, pcdev->base_csi + CSISR);
-
 	return IRQ_HANDLED;
 }
 
-- 
1.7.1

