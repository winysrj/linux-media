Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47868 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab1FWNUo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jun 2011 09:20:44 -0400
Received: by vws1 with SMTP id 1so1290675vws.19
        for <linux-media@vger.kernel.org>; Thu, 23 Jun 2011 06:20:44 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 23 Jun 2011 21:20:43 +0800
Message-ID: <BANLkTimHtpaScRYe2kuFNW9Ja9x343aOTQ@mail.gmail.com>
Subject: [PATCH] [media] videobuf2-dma-contig: return NULL if alloc fails
From: Jun Nie <niej0001@gmail.com>
To: Pawel Osciak <pawel@osciak.com>, Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

return NULL if alloc fails to avoid taking error code as
buffer pointer

Signed-off-by: Jun Nie <njun@marvell.com>
---
 drivers/media/video/videobuf2-dma-contig.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c
b/drivers/media/video/videobuf2-dma-contig.c
index a790a5f..8e8c7aa 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -40,7 +40,7 @@ static void *vb2_dma_contig_alloc(void *alloc_ctx,
unsigned long size)

 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
-		return ERR_PTR(-ENOMEM);
+		return NULL;

 	buf->vaddr = dma_alloc_coherent(conf->dev, size, &buf->paddr,
 					GFP_KERNEL);
@@ -48,7 +48,7 @@ static void *vb2_dma_contig_alloc(void *alloc_ctx,
unsigned long size)
 		dev_err(conf->dev, "dma_alloc_coherent of size %ld failed\n",
 			size);
 		kfree(buf);
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 	}

 	buf->conf = conf;
-- 
1.7.0.4
