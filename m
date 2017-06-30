Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37964 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751649AbdF3OP5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 10:15:57 -0400
From: Thierry Escande <thierry.escande@collabora.com>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/8] [media] s5p-jpeg: Call jpeg_bound_align_image after qbuf
Date: Fri, 30 Jun 2017 16:15:40 +0200
Message-Id: <1498832147-16316-2-git-send-email-thierry.escande@collabora.com>
In-Reply-To: <1498832147-16316-1-git-send-email-thierry.escande@collabora.com>
References: <1498832147-16316-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset = "utf-8"
Content-Transfert-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tony K Nadackal <tony.kn@samsung.com>

When queuing an OUTPUT buffer for decoder, s5p_jpeg_parse_hdr()
function parses the input jpeg file and takes the width and height
parameters from its header. These new width/height values will be used
for the calculation of stride. HX_JPEG Hardware needs the width and
height values aligned on a 16 bits boundary. This width/height alignment
is handled in the s5p_jpeg_s_fmt_vid_cap() function during the S_FMT
ioctl call.

But if user space calls the QBUF of OUTPUT buffer after the S_FMT of
CAPTURE buffer, these aligned values will be replaced by the values in
jpeg header. If the width/height values of jpeg are not aligned, the
decoder output will be corrupted. So in this patch we call
jpeg_bound_align_image() to align the width/height values of Capture
buffer in s5p_jpeg_buf_queue().

Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
Acked-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Acked-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 52dc794..623508d 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2523,6 +2523,25 @@ static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
 		q_data = &ctx->cap_q;
 		q_data->w = tmp.w;
 		q_data->h = tmp.h;
+
+		/*
+		 * This call to jpeg_bound_align_image() takes care of width and
+		 * height values alignment when user space calls the QBUF of
+		 * OUTPUT buffer after the S_FMT of CAPTURE buffer.
+		 * Please note that on Exynos4x12 SoCs, resigning from executing
+		 * S_FMT on capture buffer for each JPEG image can result in a
+		 * hardware hangup if subsampling is lower than the one of input
+		 * JPEG.
+		 */
+		jpeg_bound_align_image(ctx,
+				       &q_data->w,
+				       S5P_JPEG_MIN_WIDTH, S5P_JPEG_MAX_WIDTH,
+				       q_data->fmt->h_align,
+				       &q_data->h,
+				       S5P_JPEG_MIN_HEIGHT, S5P_JPEG_MAX_HEIGHT,
+				       q_data->fmt->v_align);
+
+		q_data->size = q_data->w * q_data->h * q_data->fmt->depth >> 3;
 	}
 
 	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
-- 
2.7.4
