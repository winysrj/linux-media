Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4980 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaIDQ1L (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Sep 2014 12:27:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] tw68: simplify tw68_buffer_count
Date: Thu,  4 Sep 2014 18:26:52 +0200
Message-Id: <1409848013-21867-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The code to calculate the maximum number of buffers allowed in 4 MB
is 1) wrong if PAGE_SIZE != 4096 and 2) unnecessarily complex.

Fix and simplify the code.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/tw68/tw68-video.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index 66fae23..498ead9 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -361,22 +361,13 @@ int tw68_video_start_dma(struct tw68_dev *dev, struct tw68_buf *buf)
 
 /* ------------------------------------------------------------------ */
 
-/* nr of (tw68-)pages for the given buffer size */
-static int tw68_buffer_pages(int size)
-{
-	size  = PAGE_ALIGN(size);
-	size += PAGE_SIZE; /* for non-page-aligned buffers */
-	size /= 4096;
-	return size;
-}
-
 /* calc max # of buffers from size (must not exceed the 4MB virtual
  * address space per DMA channel) */
 static int tw68_buffer_count(unsigned int size, unsigned int count)
 {
 	unsigned int maxcount;
 
-	maxcount = 1024 / tw68_buffer_pages(size);
+	maxcount = (4 * 1024 * 1024) / roundup(size, PAGE_SIZE);
 	if (count > maxcount)
 		count = maxcount;
 	return count;
-- 
2.1.0

