Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:55121 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab2HWNI6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Aug 2012 09:08:58 -0400
Received: by mail-gh0-f174.google.com with SMTP id r11so169562ghr.19
        for <linux-media@vger.kernel.org>; Thu, 23 Aug 2012 06:08:58 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	<linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 04/10] mem2mem_testdev: Remove unneeded struct vb2_queue clear on queue_init()
Date: Thu, 23 Aug 2012 10:08:25 -0300
Message-Id: <1345727311-27478-4-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1345727311-27478-1-git-send-email-elezegarcia@gmail.com>
References: <1345727311-27478-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

queue_init() is always called by v4l2_m2m_ctx_init(), which allocates
a context struct v4l2_m2m_ctx with kzalloc.
Therefore, there is no need to clear vb2_queue src/dst structs.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/platform/mem2mem_testdev.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
index 51b6dd4..9a8b14f 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/mem2mem_testdev.c
@@ -838,7 +838,6 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 	struct m2mtest_ctx *ctx = priv;
 	int ret;
 
-	memset(src_vq, 0, sizeof(*src_vq));
 	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
 	src_vq->io_modes = VB2_MMAP;
 	src_vq->drv_priv = ctx;
@@ -850,7 +849,6 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 	if (ret)
 		return ret;
 
-	memset(dst_vq, 0, sizeof(*dst_vq));
 	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	dst_vq->io_modes = VB2_MMAP;
 	dst_vq->drv_priv = ctx;
-- 
1.7.8.6

