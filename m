Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:63021 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131AbaJUOzn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 10:55:43 -0400
Received: by mail-lb0-f175.google.com with SMTP id u10so1193068lbd.34
        for <linux-media@vger.kernel.org>; Tue, 21 Oct 2014 07:55:42 -0700 (PDT)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] [media] s5p_mfc: Remove redundant casts
Date: Tue, 21 Oct 2014 16:55:35 +0200
Message-Id: <1413903335-3196-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Both sides of these assignments actually have type "const struct
vb2_mem_ops *", so the casts are unnecessary and slightly confusing.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 165bc86..8daf291 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -815,7 +815,7 @@ static int s5p_mfc_open(struct file *file)
 		ret = -ENOENT;
 		goto err_queue_init;
 	}
-	q->mem_ops = (struct vb2_mem_ops *)&vb2_dma_contig_memops;
+	q->mem_ops = &vb2_dma_contig_memops;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	ret = vb2_queue_init(q);
 	if (ret) {
@@ -837,7 +837,7 @@ static int s5p_mfc_open(struct file *file)
 		ret = -ENOENT;
 		goto err_queue_init;
 	}
-	q->mem_ops = (struct vb2_mem_ops *)&vb2_dma_contig_memops;
+	q->mem_ops = &vb2_dma_contig_memops;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	ret = vb2_queue_init(q);
 	if (ret) {
-- 
2.0.4

