Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:57450 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727690AbeIKSlm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 14:41:42 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: laurent.pinchart@ideasonboard.com, daniel@ffwll.ch,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK),
        linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING
        FRAMEWORK), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 04/13] udmabuf: constify udmabuf_ops
Date: Tue, 11 Sep 2018 15:42:07 +0200
Message-Id: <20180911134216.9760-5-kraxel@redhat.com>
In-Reply-To: <20180911134216.9760-1-kraxel@redhat.com>
References: <20180911134216.9760-1-kraxel@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/dma-buf/udmabuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index d99a9b59d3..e3560e840d 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -104,7 +104,7 @@ static void kunmap_udmabuf(struct dma_buf *buf, unsigned long page_num,
 	kunmap(vaddr);
 }
 
-static struct dma_buf_ops udmabuf_ops = {
+static const struct dma_buf_ops udmabuf_ops = {
 	.map_dma_buf	  = map_udmabuf,
 	.unmap_dma_buf	  = unmap_udmabuf,
 	.release	  = release_udmabuf,
-- 
2.9.3
