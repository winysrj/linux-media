Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:60550 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726554AbeIKL5R (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 07:57:17 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: laurent.pinchart@ideasonboard.com,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK),
        linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING
        FRAMEWORK), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 05/10] udmabuf: constify udmabuf_create args
Date: Tue, 11 Sep 2018 08:59:16 +0200
Message-Id: <20180911065921.23818-6-kraxel@redhat.com>
In-Reply-To: <20180911065921.23818-1-kraxel@redhat.com>
References: <20180911065921.23818-1-kraxel@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/dma-buf/udmabuf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index 44c3c1bf20..0cf7e85585 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -116,8 +116,8 @@ static const struct dma_buf_ops udmabuf_ops = {
 #define SEALS_WANTED (F_SEAL_SHRINK)
 #define SEALS_DENIED (F_SEAL_WRITE)
 
-static long udmabuf_create(struct udmabuf_create_list *head,
-			   struct udmabuf_create_item *list)
+static long udmabuf_create(struct const udmabuf_create_list *head,
+			   struct const udmabuf_create_item *list)
 {
 	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
 	struct file *memfd = NULL;
-- 
2.9.3
