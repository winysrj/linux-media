Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54898 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752610AbbC2Nav (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2015 09:30:51 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, hverkuil@xs4all.nl, stable@vger.kernel.org
Subject: [RESEND 2 PATCH 1/1] vb2: Fix dma_dir setting for dma-contig mem type
Date: Sun, 29 Mar 2015 16:30:48 +0300
Message-Id: <1427635848-30253-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

(This time with correct stable address.)

The last argument of vb2_dc_get_user_pages() is of type enum
dma_data_direction, but the caller, vb2_dc_get_userptr() passes a value
which is the result of comparison dma_dir == DMA_FROM_DEVICE. This results
in the write parameter to get_user_pages() being zero in all cases, i.e.
that the caller has no intent to write there.

This was broken by patch "vb2: replace 'write' by 'dma_dir'".

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: stable@vger.kernel.org
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Fixes: cd474037c4a9 ("[media] vb2: replace 'write' by 'dma_dir'")
---
Hi,

This fixes videobuf2 dma-contig memory type USERPTR support for v3.19. The
pull req for the patch was submitted some time ago:

<URL:http://www.spinics.net/lists/linux-media/msg86425.html>

Mauro, let us know if you have objections.

Thanks.

 drivers/media/v4l2-core/videobuf2-dma-contig.c |    3 +--
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
1.7.10.4

