Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:34929 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753076AbdH2L0T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 07:26:19 -0400
Received: by mail-wm0-f48.google.com with SMTP id y71so18865413wmd.0
        for <linux-media@vger.kernel.org>; Tue, 29 Aug 2017 04:26:18 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH] media: vb2: unify calling of set_page_dirty_lock
Date: Tue, 29 Aug 2017 14:26:03 +0300
Message-Id: <20170829112603.32732-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently videobuf2-dma-sg checks for dma direction for
every single page and videobuf2-dc lacks any dma direction
checks and calls set_page_dirty_lock unconditionally.

Thus unify and align the invocations of set_page_dirty_lock
for videobuf2-dc, videobuf2-sg  memory allocators with
videobuf2-vmalloc, i.e. the pattern used in vmalloc has been
copied to dc and dma-sg.

Suggested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 6 ++++--
 drivers/media/v4l2-core/videobuf2-dma-sg.c     | 7 +++----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 9f389f36566d..696e24f9128d 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -434,8 +434,10 @@ static void vb2_dc_put_userptr(void *buf_priv)
 		pages = frame_vector_pages(buf->vec);
 		/* sgt should exist only if vector contains pages... */
 		BUG_ON(IS_ERR(pages));
-		for (i = 0; i < frame_vector_count(buf->vec); i++)
-			set_page_dirty_lock(pages[i]);
+		if (buf->dma_dir == DMA_FROM_DEVICE ||
+		    buf->dma_dir == DMA_BIDIRECTIONAL)
+			for (i = 0; i < frame_vector_count(buf->vec); i++)
+				set_page_dirty_lock(pages[i]);
 		sg_free_table(sgt);
 		kfree(sgt);
 	}
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 6808231a6bdc..753ed3138dcc 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -292,11 +292,10 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
 	if (buf->vaddr)
 		vm_unmap_ram(buf->vaddr, buf->num_pages);
 	sg_free_table(buf->dma_sgt);
-	while (--i >= 0) {
-		if (buf->dma_dir == DMA_FROM_DEVICE ||
-		    buf->dma_dir == DMA_BIDIRECTIONAL)
+	if (buf->dma_dir == DMA_FROM_DEVICE ||
+	    buf->dma_dir == DMA_BIDIRECTIONAL)
+		while (--i >= 0)
 			set_page_dirty_lock(buf->pages[i]);
-	}
 	vb2_destroy_framevec(buf->vec);
 	kfree(buf);
 }
-- 
2.11.0
