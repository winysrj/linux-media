Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35518 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751981AbdGAMSf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 1 Jul 2017 08:18:35 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: pawel@osciak.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: vb2 dma-sg: Constify dma_buf_ops structures.
Date: Sat,  1 Jul 2017 17:48:24 +0530
Message-Id: <568fa73b15a4fead5ee803b9c38b47c374c91314.1498909383.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dma_buf_ops are not supposed to change at runtime. All functions
working with dma_buf_ops provided by <linux/dma-buf.h> work with
const dma_buf_ops. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
   5238	    112	      4	   5354	   14ea drivers/media/v4l2-core/videobuf2-dma-sg.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
   5358	      0	      4	   5362	   14f2 drivers/media/v4l2-core/videobuf2-dma-sg.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/v4l2-core/videobuf2-dma-sg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 8e8798a..f8b4643 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -500,7 +500,7 @@ static int vb2_dma_sg_dmabuf_ops_mmap(struct dma_buf *dbuf,
 	return vb2_dma_sg_mmap(dbuf->priv, vma);
 }
 
-static struct dma_buf_ops vb2_dma_sg_dmabuf_ops = {
+static const struct dma_buf_ops vb2_dma_sg_dmabuf_ops = {
 	.attach = vb2_dma_sg_dmabuf_ops_attach,
 	.detach = vb2_dma_sg_dmabuf_ops_detach,
 	.map_dma_buf = vb2_dma_sg_dmabuf_ops_map,
-- 
2.7.4
