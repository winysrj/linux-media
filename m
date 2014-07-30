Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:38838 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbaG3D7I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jul 2014 23:59:08 -0400
From: Zhaowei Yuan <zhaowei.yuan@samsung.com>
To: linux-media@vger.kernel.org, k.debski@samsung.com,
	kyungmin.park@samsung.com, jtp.park@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, m.chehab@samsung.com
Subject: [PATCH] media: v4l2: make alloction alogthim more robust and flexible
Date: Wed, 30 Jul 2014 11:55:32 +0800
Message-id: <1406692532-31800-1-git-send-email-zhaowei.yuan@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Current algothim relies on the fact that caller will align the
size to PAGE_SIZE, otherwise order will be decreased to negative
when remain size is less than PAGE_SIZE, it makes the function
hard to be migrated.
This patch sloves the hidden problem.

Signed-off-by: Zhaowei Yuan <zhaowei.yuan@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-dma-sg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index adefc31..40d18aa 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -58,7 +58,7 @@ static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,

 		order = get_order(size);
 		/* Dont over allocate*/
-		if ((PAGE_SIZE << order) > size)
+		if (order > 0 && (PAGE_SIZE << order) > size)
 			order--;

 		pages = NULL;
--
1.7.9.5

