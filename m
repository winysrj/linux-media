Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:60538 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726301AbeIKL5Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 07:57:16 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: laurent.pinchart@ideasonboard.com,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK),
        linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING
        FRAMEWORK), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 02/10] udmabuf: improve map_udmabuf error handling
Date: Tue, 11 Sep 2018 08:59:13 +0200
Message-Id: <20180911065921.23818-3-kraxel@redhat.com>
In-Reply-To: <20180911065921.23818-1-kraxel@redhat.com>
References: <20180911065921.23818-1-kraxel@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/dma-buf/udmabuf.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index e63d301bcb..19bd918209 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -51,25 +51,24 @@ static struct sg_table *map_udmabuf(struct dma_buf_attachment *at,
 {
 	struct udmabuf *ubuf = at->dmabuf->priv;
 	struct sg_table *sg;
+	int ret;
 
 	sg = kzalloc(sizeof(*sg), GFP_KERNEL);
 	if (!sg)
-		goto err1;
-	if (sg_alloc_table_from_pages(sg, ubuf->pages, ubuf->pagecount,
-				      0, ubuf->pagecount << PAGE_SHIFT,
-				      GFP_KERNEL) < 0)
-		goto err2;
+		return ERR_PTR(-ENOMEM);
+	ret = sg_alloc_table_from_pages(sg, ubuf->pages, ubuf->pagecount,
+					0, ubuf->pagecount << PAGE_SHIFT,
+					GFP_KERNEL);
+	if (ret < 0)
+		goto err;
 	if (!dma_map_sg(at->dev, sg->sgl, sg->nents, direction))
-		goto err3;
-
+		goto err;
 	return sg;
 
-err3:
+err:
 	sg_free_table(sg);
-err2:
 	kfree(sg);
-err1:
-	return ERR_PTR(-ENOMEM);
+	return ERR_PTR(ret);
 }
 
 static void unmap_udmabuf(struct dma_buf_attachment *at,
-- 
2.9.3
