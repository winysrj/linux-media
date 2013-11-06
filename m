Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:58142 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab3KFSso (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Nov 2013 13:48:44 -0500
Received: by mail-lb0-f172.google.com with SMTP id c11so56935lbj.17
        for <linux-media@vger.kernel.org>; Wed, 06 Nov 2013 10:48:43 -0800 (PST)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org (open list:VIDEOBUF2 FRAMEWORK)
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] videobuf2-dma-sg: Fix typo on debug message
Date: Wed,  6 Nov 2013 19:48:38 +0100
Message-Id: <1383763718-6207-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

num_pages_from_user and buf->num_pages were swapped.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/v4l2-core/videobuf2-dma-sg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 16ae3dc..72353e4 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -174,7 +174,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 
 userptr_fail_get_user_pages:
 	dprintk(1, "get_user_pages requested/got: %d/%d]\n",
-	       num_pages_from_user, buf->sg_desc.num_pages);
+		buf->sg_desc.num_pages, num_pages_from_user);
 	while (--num_pages_from_user >= 0)
 		put_page(buf->pages[num_pages_from_user]);
 	kfree(buf->pages);
-- 
1.8.4.rc3

