Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64595 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbbBMHmC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 02:42:02 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@osg.samsung.com
Subject: [REVIEW PATCH FOR v3.19 1/1] vb2: Fix dma_dir setting for dma-contig mem type
Date: Fri, 13 Feb 2015 09:42:37 +0200
Message-Id: <1423813357-31446-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The last argument of vb2_dc_get_user_pages() is of type enum
dma_data_direction, but the caller, vb2_dc_get_userptr() passes a value
which is the result of comparison dma_dir == DMA_FROM_DEVICE. This results
in the write parameter to get_user_pages() being zero in all cases, i.e.
that the caller has no intent to write there.

This was broken by patch "vb2: replace 'write' by 'dma_dir'".

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index b481d20..69e0483 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -632,8 +632,7 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	}
 
 	/* extract page list from userspace mapping */
-	ret = vb2_dc_get_user_pages(start, pages, n_pages, vma,
-				    dma_dir == DMA_FROM_DEVICE);
+	ret = vb2_dc_get_user_pages(start, pages, n_pages, vma, dma_dir);
 	if (ret) {
 		unsigned long pfn;
 		if (vb2_dc_get_user_pfn(start, n_pages, vma, &pfn) == 0) {
-- 
2.1.0.231.g7484e3b

