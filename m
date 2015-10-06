Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbbJFJYy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Oct 2015 05:24:54 -0400
From: Jan Kara <jack@suse.com>
To: linux-mm@kvack.org
Cc: Jan Kara <jack@suse.cz>, Andy Walls <awalls@md.metrocast.net>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 7/7] [media] ivtv: Convert to get_user_pages_unlocked()
Date: Tue,  6 Oct 2015 11:24:30 +0200
Message-Id: <1444123470-4932-8-git-send-email-jack@suse.com>
In-Reply-To: <1444123470-4932-1-git-send-email-jack@suse.com>
References: <1444123470-4932-1-git-send-email-jack@suse.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

Convert ivtv_yuv_prep_user_dma() to use get_user_pages_unlocked() so
that we don't unnecessarily leak knowledge about mm locking into drivers
code.

CC: Andy Walls <awalls@md.metrocast.net>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: linux-media@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/media/pci/ivtv/ivtv-yuv.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-yuv.c b/drivers/media/pci/ivtv/ivtv-yuv.c
index 2ad65eb29832..2b8e7b2f2b86 100644
--- a/drivers/media/pci/ivtv/ivtv-yuv.c
+++ b/drivers/media/pci/ivtv/ivtv-yuv.c
@@ -75,15 +75,15 @@ static int ivtv_yuv_prep_user_dma(struct ivtv *itv, struct ivtv_user_dma *dma,
 	ivtv_udma_get_page_info (&uv_dma, (unsigned long)args->uv_source, 360 * uv_decode_height);
 
 	/* Get user pages for DMA Xfer */
-	down_read(&current->mm->mmap_sem);
-	y_pages = get_user_pages(current, current->mm, y_dma.uaddr, y_dma.page_count, 0, 1, &dma->map[0], NULL);
+	y_pages = get_user_pages_unlocked(current, current->mm,
+				y_dma.uaddr, y_dma.page_count, 0, 1,
+				&dma->map[0]);
 	uv_pages = 0; /* silence gcc. value is set and consumed only if: */
 	if (y_pages == y_dma.page_count) {
-		uv_pages = get_user_pages(current, current->mm,
-					  uv_dma.uaddr, uv_dma.page_count, 0, 1,
-					  &dma->map[y_pages], NULL);
+		uv_pages = get_user_pages_unlocked(current, current->mm,
+					uv_dma.uaddr, uv_dma.page_count, 0, 1,
+					&dma->map[y_pages]);
 	}
-	up_read(&current->mm->mmap_sem);
 
 	if (y_pages != y_dma.page_count || uv_pages != uv_dma.page_count) {
 		int rc = -EFAULT;
-- 
2.1.4

