Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47914 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758878Ab2HWNJN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Aug 2012 09:09:13 -0400
Received: by mail-yx0-f174.google.com with SMTP id l14so168915yen.19
        for <linux-media@vger.kernel.org>; Thu, 23 Aug 2012 06:09:13 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	<linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 08/10] s5p-fimc: Remove unneeded struct vb2_queue clear on queue_init()
Date: Thu, 23 Aug 2012 10:08:29 -0300
Message-Id: <1345727311-27478-8-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1345727311-27478-1-git-send-email-elezegarcia@gmail.com>
References: <1345727311-27478-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

queue_init() is always called by v4l2_m2m_ctx_init(), which allocates
a context struct v4l2_m2m_ctx with kzalloc.
Therefore, there is no need to clear vb2_queue src/dst structs.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/platform/s5p-fimc/fimc-m2m.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-m2m.c b/drivers/media/platform/s5p-fimc/fimc-m2m.c
index c587011..ab4c15a 100644
--- a/drivers/media/platform/s5p-fimc/fimc-m2m.c
+++ b/drivers/media/platform/s5p-fimc/fimc-m2m.c
@@ -620,7 +620,6 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	struct fimc_ctx *ctx = priv;
 	int ret;
 
-	memset(src_vq, 0, sizeof(*src_vq));
 	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
 	src_vq->io_modes = VB2_MMAP | VB2_USERPTR;
 	src_vq->drv_priv = ctx;
@@ -632,7 +631,6 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	if (ret)
 		return ret;
 
-	memset(dst_vq, 0, sizeof(*dst_vq));
 	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
 	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
 	dst_vq->drv_priv = ctx;
-- 
1.7.8.6

