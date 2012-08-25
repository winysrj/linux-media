Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54107 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab2HYDJL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 23:09:11 -0400
Received: by yenl14 with SMTP id l14so583846yen.19
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2012 20:09:11 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 2/9] coda: Don't check vb2_queue_init() return value
Date: Sat, 25 Aug 2012 00:08:59 -0300
Message-Id: <1345864146-2207-2-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1345864146-2207-1-git-send-email-elezegarcia@gmail.com>
References: <1345864146-2207-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now vb2_queue_init() returns always 0
and it will be changed to return void.

Cc: Javier Martin <javier.martin@vista-silicon.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/platform/coda.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 3ea822f..fc246ab 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1256,9 +1256,7 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->ops = &coda_qops;
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 
-	ret = vb2_queue_init(src_vq);
-	if (ret)
-		return ret;
+	vb2_queue_init(src_vq);
 
 	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	dst_vq->io_modes = VB2_MMAP;
@@ -1267,7 +1265,8 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->ops = &coda_qops;
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 
-	return vb2_queue_init(dst_vq);
+	vb2_queue_init(dst_vq);
+	return 0;
 }
 
 static int coda_open(struct file *file)
-- 
1.7.8.6

