Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26141 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933354Ab1FBKN1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 06:13:27 -0400
Date: Thu, 02 Jun 2011 12:12:01 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 4/7] s5p-fimc: Fix wrong buffer size in queue_setup
In-reply-to: <1307009524-1208-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1307009524-1208-5-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1307009524-1208-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Avoid dereferencing of NULL f->fmt. Correct size of the allocated
buffer in case the crop rectangle is smaller than the bounds
rectangle (configured with S_FMT). Also remove redundant check
for *num_buffer == 0 as this case is handled in videobuf2.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index c427edd..85b47a3 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -704,22 +704,18 @@ static int fimc_queue_setup(struct vb2_queue *vq, unsigned int *num_buffers,
 	f = ctx_get_frame(ctx, vq->type);
 	if (IS_ERR(f))
 		return PTR_ERR(f);
-
 	/*
 	 * Return number of non-contigous planes (plane buffers)
 	 * depending on the configured color format.
 	 */
-	if (f->fmt)
-		*num_planes = f->fmt->memplanes;
+	if (!f->fmt)
+		return -EINVAL;
 
+	*num_planes = f->fmt->memplanes;
 	for (i = 0; i < f->fmt->memplanes; i++) {
-		sizes[i] = (f->width * f->height * f->fmt->depth[i]) >> 3;
+		sizes[i] = (f->f_width * f->f_height * f->fmt->depth[i]) / 8;
 		allocators[i] = ctx->fimc_dev->alloc_ctx;
 	}
-
-	if (*num_buffers == 0)
-		*num_buffers = 1;
-
 	return 0;
 }
 
-- 
1.7.5.2

