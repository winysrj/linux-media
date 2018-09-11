Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:57462 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727693AbeIKSlm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 14:41:42 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: laurent.pinchart@ideasonboard.com, daniel@ffwll.ch,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK),
        linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING
        FRAMEWORK), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 03/13] udmabuf: use pgoff_t for pagecount
Date: Tue, 11 Sep 2018 15:42:06 +0200
Message-Id: <20180911134216.9760-4-kraxel@redhat.com>
In-Reply-To: <20180911134216.9760-1-kraxel@redhat.com>
References: <20180911134216.9760-1-kraxel@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/dma-buf/udmabuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index 0d03367c57..d99a9b59d3 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -13,7 +13,7 @@
 #include <linux/udmabuf.h>
 
 struct udmabuf {
-	u32 pagecount;
+	pgoff_t pagecount;
 	struct page **pages;
 };
 
-- 
2.9.3
