Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54107 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab2HYDJY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 23:09:24 -0400
Received: by mail-yx0-f174.google.com with SMTP id l14so583846yen.19
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2012 20:09:24 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 8/9] mem2mem_testdev: Don't check vb2_queue_init() return value
Date: Sat, 25 Aug 2012 00:09:05 -0300
Message-Id: <1345864146-2207-8-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1345864146-2207-1-git-send-email-elezegarcia@gmail.com>
References: <1345864146-2207-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now vb2_queue_init() returns always 0
and it will be changed to return void.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/platform/mem2mem_testdev.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
index 9a8b14f..a2bd0b8 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/mem2mem_testdev.c
@@ -845,9 +845,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 	src_vq->ops = &m2mtest_qops;
 	src_vq->mem_ops = &vb2_vmalloc_memops;
 
-	ret = vb2_queue_init(src_vq);
-	if (ret)
-		return ret;
+	vb2_queue_init(src_vq);
 
 	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	dst_vq->io_modes = VB2_MMAP;
@@ -856,7 +854,8 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 	dst_vq->ops = &m2mtest_qops;
 	dst_vq->mem_ops = &vb2_vmalloc_memops;
 
-	return vb2_queue_init(dst_vq);
+	vb2_queue_init(dst_vq);
+	return 0;
 }
 
 static const struct v4l2_ctrl_config m2mtest_ctrl_trans_time_msec = {
-- 
1.7.8.6

