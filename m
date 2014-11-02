Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53331 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaKBOxi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Nov 2014 09:53:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Michal Simek <michal.simek@xilinx.com>,
	Chris Kohn <christian.kohn@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Srikanth Thokala <srikanth.thokala@xilinx.com>
Subject: [PATCH v2 09/13] dma: xilinx: vdma: Allow only one chunk in a line
Date: Sun,  2 Nov 2014 16:53:34 +0200
Message-Id: <1414940018-3016-10-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1414940018-3016-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1414940018-3016-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Srikanth Thokala <srikanth.thokala@xilinx.com>

This patch adds a sanity check to see if frame_size is 1.

Signed-off-by: Srikanth Thokala <sthokal@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/dma/xilinx/xilinx_vdma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/xilinx/xilinx_vdma.c b/drivers/dma/xilinx/xilinx_vdma.c
index 1093794..3d3f70d 100644
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
2.0.4

