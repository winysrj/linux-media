Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53334 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaKBOxi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Nov 2014 09:53:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Michal Simek <michal.simek@xilinx.com>,
	Chris Kohn <christian.kohn@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Srikanth Thokala <srikanth.thokala@xilinx.com>
Subject: [PATCH v2 08/13] dma: xilinx: vdma: Check if the segment list is empty in a descriptor
Date: Sun,  2 Nov 2014 16:53:33 +0200
Message-Id: <1414940018-3016-9-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1414940018-3016-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1414940018-3016-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Srikanth Thokala <srikanth.thokala@xilinx.com>

The segment list in a descriptor should be checked for empty, else
it will try to access invalid address for the first call.  This
patch fixes this issue.

Signed-off-by: Srikanth Thokala <sthokal@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/dma/xilinx/xilinx_vdma.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/xilinx/xilinx_vdma.c b/drivers/dma/xilinx/xilinx_vdma.c
index a6e6476..1093794 100644
--- a/drivers/dma/xilinx/xilinx_vdma.c
+++ b/drivers/dma/xilinx/xilinx_vdma.c
@@ -971,9 +971,11 @@ xilinx_vdma_dma_prep_interleaved(struct dma_chan *dchan,
 		hw->buf_addr = xt->src_start;
 
 	/* Link the previous next descriptor to current */
-	prev = list_last_entry(&desc->segments,
-				struct xilinx_vdma_tx_segment, node);
-	prev->hw.next_desc = segment->phys;
+	if (!list_empty(&desc->segments)) {
+		prev = list_last_entry(&desc->segments,
+				       struct xilinx_vdma_tx_segment, node);
+		prev->hw.next_desc = segment->phys;
+	}
 
 	/* Insert the segment into the descriptor segments list. */
 	list_add_tail(&segment->node, &desc->segments);
-- 
2.0.4

