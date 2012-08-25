Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:44969 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab2HYDJO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 23:09:14 -0400
Received: by ggdk6 with SMTP id k6so581646ggd.19
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2012 20:09:13 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 3/9] mem2mem-emmaprp: Don't check vb2_queue_init() return value
Date: Sat, 25 Aug 2012 00:09:00 -0300
Message-Id: <1345864146-2207-3-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1345864146-2207-1-git-send-email-elezegarcia@gmail.com>
References: <1345864146-2207-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now vb2_queue_init() returns always 0
and it will be changed to return void.

Cc: Javier Martin <javier.martin@vista-silicon.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/platform/mx2_emmaprp.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 59aaca4..17e5c7e 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -764,9 +764,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->ops = &emmaprp_qops;
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 
-	ret = vb2_queue_init(src_vq);
-	if (ret)
-		return ret;
+	vb2_queue_init(src_vq);
 
 	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
@@ -775,7 +773,8 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->ops = &emmaprp_qops;
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 
-	return vb2_queue_init(dst_vq);
+	vb2_queue_init(dst_vq);
+	return 0;
 }
 
 /*
-- 
1.7.8.6

