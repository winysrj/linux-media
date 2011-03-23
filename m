Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:49260 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab1CWKCJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2011 06:02:09 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 223D0189B85
	for <linux-media@vger.kernel.org>; Wed, 23 Mar 2011 11:02:08 +0100 (CET)
Date: Wed, 23 Mar 2011 11:02:08 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L: fix an error message
Message-ID: <Pine.LNX.4.64.1103231101170.6836@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

buf->size is not yet initialised in videobuf2-dma-contig at the time of
the error message, use "size."

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/videobuf2-dma-contig.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index 58205d5..a790a5f 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -46,7 +46,7 @@ static void *vb2_dma_contig_alloc(void *alloc_ctx, unsigned long size)
 					GFP_KERNEL);
 	if (!buf->vaddr) {
 		dev_err(conf->dev, "dma_alloc_coherent of size %ld failed\n",
-			buf->size);
+			size);
 		kfree(buf);
 		return ERR_PTR(-ENOMEM);
 	}
-- 
1.7.2.5

