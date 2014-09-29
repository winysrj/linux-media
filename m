Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49619 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaI2U2H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 16:28:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Michal Simek <michal.simek@xilinx.com>,
	Chris Kohn <christian.kohn@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Srikanth Thokala <sthokal@xilinx.com>,
	dmaengine@vger.kernel.org
Subject: [PATCH 07/11] dma: xilinx: vdma: Allow only one chunk in a line
Date: Mon, 29 Sep 2014 23:27:53 +0300
Message-Id: <1412022477-28749-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1412022477-28749-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1412022477-28749-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Srikanth Thokala <srikanth.thokala@xilinx.com>

This patch adds a sanity check to see if frame_size is 1.

Signed-off-by: Srikanth Thokala <sthokal@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/dma/xilinx/xilinx_vdma.c | 3 +++
 1 file changed, 3 insertions(+)

Cc: dmaengine@vger.kernel.org

diff --git a/drivers/dma/xilinx/xilinx_vdma.c b/drivers/dma/xilinx/xilinx_vdma.c
index 8e9f2a6..b3b8761 100644
--- a/drivers/dma/xilinx/xilinx_vdma.c
+++ b/drivers/dma/xilinx/xilinx_vdma.c
@@ -942,6 +942,9 @@ xilinx_vdma_dma_prep_interleaved(struct dma_chan *dchan,
 	if (!xt->numf || !xt->sgl[0].size)
 		return NULL;
 
+	if (xt->frame_size != 1)
+		return NULL;
+
 	/* Allocate a transaction descriptor. */
 	desc = xilinx_vdma_alloc_tx_descriptor(chan);
 	if (!desc)
-- 
1.8.5.5

