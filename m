Return-path: <mchehab@pedra>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64347 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab1DSOyz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 10:54:55 -0400
Received: by vxi39 with SMTP id 39so4304344vxi.19
        for <linux-media@vger.kernel.org>; Tue, 19 Apr 2011 07:54:54 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 19 Apr 2011 10:54:54 -0400
Message-ID: <BANLkTikupnA4_muR6zTuhX6VfsidnJ0Q3g@mail.gmail.com>
Subject: [PATCH] videobuf_pages_to_sg: sglist[0] length problem
From: Newson Edouard <newsondev@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On function videobuf_pages_to_sg the statement sg_set_page(&sglist[0],
pages[0], PAGE_SIZE -
offset, offset) will failed if if size is less than PAGE_SIZE.

Signed-off-by: Newson Edouard <newsondev@gmail.com

---
 drivers/media/video/videobuf-dma-sg.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/videobuf-dma-sg.c
b/drivers/media/video/videobuf-dma-sg.c
index ddb8f4b..f300dea 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -108,8 +108,9 @@ static struct scatterlist
*videobuf_pages_to_sg(struct page **pages,
 	if (PageHighMem(pages[0]))
 		/* DMA to highmem pages might not work */
 		goto highmem;
-	sg_set_page(&sglist[0], pages[0], PAGE_SIZE - offset, offset);
-	size -= PAGE_SIZE - offset;
+	sg_set_page(&sglist[0], pages[0],
+			min_t(size_t, PAGE_SIZE - offset, size), offset);
+	size -= min_t(size_t, PAGE_SIZE - offset, size);
 	for (i = 1; i < nr_pages; i++) {
 		if (NULL == pages[i])
 			goto nopage;
-- 
1.7.0.4
