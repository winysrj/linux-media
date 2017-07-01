Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36381 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751683AbdGALhi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 1 Jul 2017 07:37:38 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: pawel@osciak.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: vb2 vmalloc: Constify dma_buf_ops structures.
Date: Sat,  1 Jul 2017 17:07:26 +0530
Message-Id: <bb06167b83b6241201c2adc12b2b18b212078762.1498908989.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dma_buf_ops are not supposed to change at runtime. All functions
working with dma_buf_ops provided by <linux/dma-buf.h> work with
const dma_buf_ops. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
   3171	    192	      0	   3363	    d23 drivers/media/v4l2-core/videobuf2-vmalloc.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
   3291	     80	      0	   3371	    d2b drivers/media/v4l2-core/videobuf2-vmalloc.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/v4l2-core/videobuf2-vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index b337d78..6bc130f 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -338,7 +338,7 @@ static int vb2_vmalloc_dmabuf_ops_mmap(struct dma_buf *dbuf,
 	return vb2_vmalloc_mmap(dbuf->priv, vma);
 }
 
-static struct dma_buf_ops vb2_vmalloc_dmabuf_ops = {
+static const struct dma_buf_ops vb2_vmalloc_dmabuf_ops = {
 	.attach = vb2_vmalloc_dmabuf_ops_attach,
 	.detach = vb2_vmalloc_dmabuf_ops_detach,
 	.map_dma_buf = vb2_vmalloc_dmabuf_ops_map,
-- 
2.7.4
