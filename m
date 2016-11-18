Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:17474 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753463AbcKRXVT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 18:21:19 -0500
From: Benoit Parrot <bparrot@ti.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jyri Sarha <jsarha@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch v2 27/35] media: ti-vpe: vpe: Fix line stride for output motion vector
Date: Fri, 18 Nov 2016 17:20:37 -0600
Message-ID: <20161118232045.24665-28-bparrot@ti.com>
In-Reply-To: <20161118232045.24665-1-bparrot@ti.com>
References: <20161118232045.24665-1-bparrot@ti.com>
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
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 15e846b95719..608d11344147 100644
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

