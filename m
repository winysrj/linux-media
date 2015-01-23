Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60823 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659AbbAWQvj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 11:51:39 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 16/21] [media] coda: switch BIT decoder source queue to vmalloc
Date: Fri, 23 Jan 2015 17:51:30 +0100
Message-Id: <1422031895-7740-17-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
References: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since we have to copy from input buffers into the bitstream ringbuffer
with the CPU, there is no need for contiguous DMA buffers on the decoder
input side.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/Kconfig            | 1 +
 drivers/media/platform/coda/coda-common.c | 6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 765bffb..74c2101 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -140,6 +140,7 @@ config VIDEO_CODA
 	depends on HAS_DMA
 	select SRAM
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_VMALLOC
 	select V4L2_MEM2MEM_DEV
 	select GENERIC_ALLOCATOR
 	---help---
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index f7fc355..24d9f8a 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -37,6 +37,7 @@
 #include <media/v4l2-mem2mem.h>
 #include <media/videobuf2-core.h>
 #include <media/videobuf2-dma-contig.h>
+#include <media/videobuf2-vmalloc.h>
 
 #include "coda.h"
 
@@ -1121,6 +1122,7 @@ static int coda_queue_setup(struct vb2_queue *vq,
 	*nplanes = 1;
 	sizes[0] = size;
 
+	/* Set to vb2-dma-contig allocator context, ignored by vb2-vmalloc */
 	alloc_ctxs[0] = ctx->dev->alloc_ctx;
 
 	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
@@ -1567,8 +1569,8 @@ int coda_decoder_queue_init(void *priv, struct vb2_queue *src_vq,
 	int ret;
 
 	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
-	src_vq->io_modes = VB2_DMABUF | VB2_MMAP;
-	src_vq->mem_ops = &vb2_dma_contig_memops;
+	src_vq->io_modes = VB2_DMABUF | VB2_MMAP | VB2_USERPTR;
+	src_vq->mem_ops = &vb2_vmalloc_memops;
 
 	ret = coda_queue_init(priv, src_vq);
 	if (ret)
-- 
2.1.4

