Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:47440 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3KYJ6t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Nov 2013 04:58:49 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWT00JN8D1Z9P20@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 25 Nov 2013 18:58:47 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, andrzej.p@samsung.com,
	s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 04/16] s5p-jpeg: Remove superfluous call to the
 jpeg_bound_align_image function
Date: Mon, 25 Nov 2013 10:58:11 +0100
Message-id: <1385373503-1657-5-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1385373503-1657-1-git-send-email-j.anaszewski@samsung.com>
References: <1385373503-1657-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Aligning capture queue image dimensions while enqueuing output
queue doesn't make a sense as the S_FMT ioctl might have not
been called for the capture queue until that moment, whereas
it is required to know capture format as the type of alignment
heavily depends on it.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index a1366f0..a6ec8c6 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1089,13 +1089,6 @@ static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
 		q_data = &ctx->cap_q;
 		q_data->w = tmp.w;
 		q_data->h = tmp.h;
-
-		jpeg_bound_align_image(&q_data->w, S5P_JPEG_MIN_WIDTH,
-				       S5P_JPEG_MAX_WIDTH, q_data->fmt->h_align,
-				       &q_data->h, S5P_JPEG_MIN_HEIGHT,
-				       S5P_JPEG_MAX_HEIGHT, q_data->fmt->v_align
-				      );
-		q_data->size = q_data->w * q_data->h * q_data->fmt->depth >> 3;
 	}
 
 	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
-- 
1.7.9.5

