Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:49790 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab2HYDJQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 23:09:16 -0400
Received: by ghrr11 with SMTP id r11so586536ghr.19
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2012 20:09:15 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 4/9] mem2mem-deinterlace: Don't check vb2_queue_init() return value
Date: Sat, 25 Aug 2012 00:09:01 -0300
Message-Id: <1345864146-2207-4-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1345864146-2207-1-git-send-email-elezegarcia@gmail.com>
References: <1345864146-2207-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now vb2_queue_init() returns always 0
and it will be changed to return void.

Cc: Javier Martin <javier.martin@vista-silicon.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/platform/m2m-deinterlace.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 9afd930..591e1b8 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -873,9 +873,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	q_data[V4L2_M2M_SRC].sizeimage = (640 * 480 * 3) / 2;
 	q_data[V4L2_M2M_SRC].field = V4L2_FIELD_SEQ_TB;
 
-	ret = vb2_queue_init(src_vq);
-	if (ret)
-		return ret;
+	vb2_queue_init(src_vq);
 
 	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
@@ -889,7 +887,8 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	q_data[V4L2_M2M_DST].sizeimage = (640 * 480 * 3) / 2;
 	q_data[V4L2_M2M_SRC].field = V4L2_FIELD_INTERLACED_TB;
 
-	return vb2_queue_init(dst_vq);
+	vb2_queue_init(dst_vq);
+	return 0;
 }
 
 /*
-- 
1.7.8.6

