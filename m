Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49618 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbaI2U2I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 16:28:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Michal Simek <michal.simek@xilinx.com>,
	Chris Kohn <christian.kohn@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Srikanth Thokala <sthokal@xilinx.com>,
	dmaengine@vger.kernel.org
Subject: [PATCH 08/11] dma: xilinx: vdma: icg should be difference of stride and hsize
Date: Mon, 29 Sep 2014 23:27:54 +0300
Message-Id: <1412022477-28749-9-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1412022477-28749-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1412022477-28749-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Srikanth Thokala <srikanth.thokala@xilinx.com>

This patch modifies the icg field to match the description
as mentioned in the DMA Linux framework.

Signed-off-by: Srikanth Thokala <sthokal@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/dma/xilinx/xilinx_vdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Cc: dmaengine@vger.kernel.org

diff --git a/drivers/dma/xilinx/xilinx_vdma.c b/drivers/dma/xilinx/xilinx_vdma.c
index b3b8761..a67ced1 100644
--- a/drivers/dma/xilinx/xilinx_vdma.c
+++ b/drivers/dma/xilinx/xilinx_vdma.c
@@ -963,7 +963,7 @@ xilinx_vdma_dma_prep_interleaved(struct dma_chan *dchan,
 	hw = &segment->hw;
 	hw->vsize = xt->numf;
 	hw->hsize = xt->sgl[0].size;
-	hw->stride = xt->sgl[0].icg <<
+	hw->stride = (xt->sgl[0].icg + xt->sgl[0].size) <<
 			XILINX_VDMA_FRMDLY_STRIDE_STRIDE_SHIFT;
 	hw->stride |= chan->config.frm_dly <<
 			XILINX_VDMA_FRMDLY_STRIDE_FRMDLY_SHIFT;
-- 
1.8.5.5

