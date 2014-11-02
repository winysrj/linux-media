Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53334 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbaKBOxj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Nov 2014 09:53:39 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Michal Simek <michal.simek@xilinx.com>,
	Chris Kohn <christian.kohn@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Srikanth Thokala <srikanth.thokala@xilinx.com>
Subject: [PATCH v2 10/13] dma: xilinx: vdma: icg should be difference of stride and hsize
Date: Sun,  2 Nov 2014 16:53:35 +0200
Message-Id: <1414940018-3016-11-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1414940018-3016-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1414940018-3016-1-git-send-email-laurent.pinchart@ideasonboard.com>
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

diff --git a/drivers/dma/xilinx/xilinx_vdma.c b/drivers/dma/xilinx/xilinx_vdma.c
index 3d3f70d..4a3a8f3 100644
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
2.0.4

