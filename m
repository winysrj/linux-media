Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35406 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751683AbdGAL1Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 1 Jul 2017 07:27:25 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: pawel@osciak.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: vb2 dma-contig: Constify dma_buf_ops structures.
Date: Sat,  1 Jul 2017 16:57:13 +0530
Message-Id: <f1403ce121c467e3c6fb33ead41ff665985a431f.1498908191.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dma_buf_ops are not supposed to change at runtime. All functions
working with dma_buf_ops provided by <linux/dma-buf.h> work with
const dma_buf_ops. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
   6035	    272	      0	   6307	   18a3 drivers/media/v4l2-core/videobuf2-dma-contig.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
   6155	    160	      0	   6315	   18ab drivers/media/v4l2-core/videobuf2-dma-contig.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 4f246d1..5b90a66 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -352,7 +352,7 @@ static int vb2_dc_dmabuf_ops_mmap(struct dma_buf *dbuf,
 	return vb2_dc_mmap(dbuf->priv, vma);
 }
 
-static struct dma_buf_ops vb2_dc_dmabuf_ops = {
+static const struct dma_buf_ops vb2_dc_dmabuf_ops = {
 	.attach = vb2_dc_dmabuf_ops_attach,
 	.detach = vb2_dc_dmabuf_ops_detach,
 	.map_dma_buf = vb2_dc_dmabuf_ops_map,
-- 
2.7.4
