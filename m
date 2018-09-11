Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:35586 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726305AbeIKL5R (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 07:57:17 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: laurent.pinchart@ideasonboard.com,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK),
        linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING
        FRAMEWORK), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 09/10] udmabuf: use EBADFD in case we didn't got a memfd
Date: Tue, 11 Sep 2018 08:59:20 +0200
Message-Id: <20180911065921.23818-10-kraxel@redhat.com>
In-Reply-To: <20180911065921.23818-1-kraxel@redhat.com>
References: <20180911065921.23818-1-kraxel@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/dma-buf/udmabuf.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index ec46513a47..1862bb6bed 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -154,14 +154,17 @@ static long udmabuf_create(struct const udmabuf_create_list *head,
 
 	pgbuf = 0;
 	for (i = 0; i < head->count; i++) {
+		ret = -EBADFD;
 		memfd = fget(list[i].memfd);
 		if (!memfd)
 			goto err;
 		if (!shmem_mapping(file_inode(memfd)->i_mapping))
 			goto err;
 		seals = memfd_fcntl(memfd, F_GET_SEALS, 0);
-		if (seals == -EINVAL ||
-		    (seals & SEALS_WANTED) != SEALS_WANTED ||
+		if (seals == -EINVAL)
+			goto err;
+		ret = -EINVAL;
+		if ((seals & SEALS_WANTED) != SEALS_WANTED ||
 		    (seals & SEALS_DENIED) != 0)
 			goto err;
 		pgoff = list[i].offset >> PAGE_SHIFT;
-- 
2.9.3
