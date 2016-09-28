Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:58230 "EHLO bear.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933832AbcI1VXL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 17:23:11 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [Patch 27/35] media: ti-vpe: vpe: Fix line stride for output motion vector
Date: Wed, 28 Sep 2016 16:23:03 -0500
Message-ID: <20160928212303.27535-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Nikhil Devshatwar <nikhil.nd@ti.com>

For deinterlacing operation, VPE hardware uses motion vectors.
MV calculated in the previous iteration are used for next interation.
Therefore driver allocates two motion vectors in ping-pong fashion.

For every transaction, one MV is DMAed in and one is DMAed out.
All the outbound DMAs (DMA to memory) use output parameters, but as
the motion vectors is generated purely out of input fields, it should
use the input parameters for DMA.

Fix the add_out_dtd to use source q_data for creating descriptor.
If the output size is greater than input stride, without this change,
MV DMA may overwrite the buffer causing memory corruption.

This CRITICAL fix ensures that the motion vector DMA descriptor is
created based on the attributes with which the buffer was allocated.

Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
Signed-off-by: Ravikumar Kattekola <rk@ti.com>
Signed-off-by: Ravi Babu <ravibabu@ti.com>
Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index c09247960550..3e1b8b1ccb7c 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1046,6 +1046,7 @@ static void add_out_dtd(struct vpe_ctx *ctx, int port)
 	if (port == VPE_PORT_MV_OUT) {
 		vpdma_fmt = &vpdma_misc_fmts[VPDMA_DATA_FMT_MV];
 		dma_addr = ctx->mv_buf_dma[mv_buf_selector];
+		q_data = &ctx->q_data[Q_DATA_SRC];
 	} else {
 		/* to incorporate interleaved formats */
 		int plane = fmt->coplanar ? p_data->vb_part : 0;
-- 
2.9.0

