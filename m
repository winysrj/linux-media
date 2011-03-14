Return-path: <mchehab@pedra>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63382 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab1CNNii (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 09:38:38 -0400
Received: by gyf1 with SMTP id 1so874688gyf.19
        for <linux-media@vger.kernel.org>; Mon, 14 Mar 2011 06:38:37 -0700 (PDT)
From: Pawel Osciak <pawel@osciak.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, g.liakhovetski@gmx.de,
	hverkuil@xs4all.nl, Pawel Osciak <pawel@osciak.com>
Subject: [PATCH 2/2] [media] videobuf2-dma-contig: make cookie() return a pointer to dma_addr_t
Date: Mon, 14 Mar 2011 06:38:24 -0700
Message-Id: <1300109904-3991-2-git-send-email-pawel@osciak.com>
In-Reply-To: <1300109904-3991-1-git-send-email-pawel@osciak.com>
References: <1300109904-3991-1-git-send-email-pawel@osciak.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

dma_addr_t may not fit into void* on some architectures. To be safe, make
vb2_dma_contig_cookie() return a pointer to dma_addr_t and dereference it
in vb2_dma_contig_plane_paddr() back to dma_addr_t.

Signed-off-by: Pawel Osciak <pawel@osciak.com>
Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/videobuf2-dma-contig.c |    2 +-
 include/media/videobuf2-dma-contig.h       |    9 ++++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index 90495b7..58205d5 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -78,7 +78,7 @@ static void *vb2_dma_contig_cookie(void *buf_priv)
 {
 	struct vb2_dc_buf *buf = buf_priv;
 
-	return (void *)buf->paddr;
+	return &buf->paddr;
 }
 
 static void *vb2_dma_contig_vaddr(void *buf_priv)
diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
index 1d6188d..7e6c68b 100644
--- a/include/media/videobuf2-dma-contig.h
+++ b/include/media/videobuf2-dma-contig.h
@@ -14,11 +14,14 @@
 #define _MEDIA_VIDEOBUF2_DMA_COHERENT_H
 
 #include <media/videobuf2-core.h>
+#include <linux/dma-mapping.h>
 
-static inline unsigned long vb2_dma_contig_plane_paddr(
-		struct vb2_buffer *vb, unsigned int plane_no)
+static inline dma_addr_t
+vb2_dma_contig_plane_paddr(struct vb2_buffer *vb, unsigned int plane_no)
 {
-	return (unsigned long)vb2_plane_cookie(vb, plane_no);
+	dma_addr_t *paddr = vb2_plane_cookie(vb, plane_no);
+
+	return *paddr;
 }
 
 void *vb2_dma_contig_init_ctx(struct device *dev);
-- 
1.7.4.1

