Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52434 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbaDCWiK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Apr 2014 18:38:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 17/25] omap3isp: queue: Use sg_alloc_table_from_pages()
Date: Fri,  4 Apr 2014 00:39:47 +0200
Message-Id: <1396564795-27192-18-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1396564795-27192-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1396564795-27192-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the custom implementation with a call to the scatterlist helper
function.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispqueue.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispqueue.c b/drivers/media/platform/omap3isp/ispqueue.c
index 4a271c7..cee1b5d 100644
--- a/drivers/media/platform/omap3isp/ispqueue.c
+++ b/drivers/media/platform/omap3isp/ispqueue.c
@@ -233,12 +233,10 @@ static void isp_video_buffer_cleanup(struct isp_video_buffer *buf)
  */
 static int isp_video_buffer_prepare_user(struct isp_video_buffer *buf)
 {
-	struct scatterlist *sg;
 	unsigned int offset;
 	unsigned long data;
 	unsigned int first;
 	unsigned int last;
-	unsigned int i;
 	int ret;
 
 	data = buf->vbuf.m.userptr;
@@ -267,21 +265,11 @@ static int isp_video_buffer_prepare_user(struct isp_video_buffer *buf)
 	if (ret < 0)
 		return ret;
 
-	ret = sg_alloc_table(&buf->sgt, buf->npages, GFP_KERNEL);
+	ret = sg_alloc_table_from_pages(&buf->sgt, buf->pages, buf->npages,
+					offset, buf->vbuf.length, GFP_KERNEL);
 	if (ret < 0)
 		return ret;
 
-	for (sg = buf->sgt.sgl, i = 0; i < buf->npages; ++i) {
-		if (PageHighMem(buf->pages[i])) {
-			sg_free_table(&buf->sgt);
-			return -EINVAL;
-		}
-
-		sg_set_page(sg, buf->pages[i], PAGE_SIZE - offset, offset);
-		sg = sg_next(sg);
-		offset = 0;
-	}
-
 	return 0;
 }
 
-- 
1.8.3.2

