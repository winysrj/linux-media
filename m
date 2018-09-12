Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:60794 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725910AbeILLgV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 07:36:21 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: laurent.pinchart@ideasonboard.com, daniel@ffwll.ch,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK),
        linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING
        FRAMEWORK), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 2/3] udmabuf: check that __pad is zero
Date: Wed, 12 Sep 2018 08:33:15 +0200
Message-Id: <20180912063316.21047-3-kraxel@redhat.com>
In-Reply-To: <20180912063316.21047-1-kraxel@redhat.com>
References: <20180912063316.21047-1-kraxel@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reported-by: Yann Droneaud <ydroneaud@opteya.com>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/dma-buf/udmabuf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index 9edabce0b8..964beadd11 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -134,6 +134,8 @@ static long udmabuf_create(const struct udmabuf_create_list *head,
 
 	pglimit = (size_limit_mb * 1024 * 1024) >> PAGE_SHIFT;
 	for (i = 0; i < head->count; i++) {
+		if (list[i].__pad)
+			goto err;
 		if (!IS_ALIGNED(list[i].offset, PAGE_SIZE))
 			goto err;
 		if (!IS_ALIGNED(list[i].size, PAGE_SIZE))
-- 
2.9.3
