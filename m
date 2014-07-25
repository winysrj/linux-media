Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:61188 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760297AbaGYOVV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 10:21:21 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, j.anaszewski@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 4/9] s5p-jpeg: Adjust jpeg_bound_align_image to Exynos3250
 needs
Date: Fri, 25 Jul 2014 16:20:48 +0200
Message-id: <1406298053-30184-5-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1406298053-30184-1-git-send-email-s.nawrocki@samsung.com>
References: <1406298053-30184-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jacek Anaszewski <j.anaszewski@samsung.com>

The jpeg_bound_align_image function needs to know the context
in which it is called, as it needs to align image dimensions in
a slight different manner for Exynos3250, which crops pixels
for specific values in case the format is RGB.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index a3f8862..5ef7f5b 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1133,7 +1133,8 @@ static struct s5p_jpeg_fmt *s5p_jpeg_find_format(struct s5p_jpeg_ctx *ctx,
 	return NULL;
 }

-static void jpeg_bound_align_image(u32 *w, unsigned int wmin, unsigned int wmax,
+static void jpeg_bound_align_image(struct s5p_jpeg_ctx *ctx,
+				   u32 *w, unsigned int wmin, unsigned int wmax,
 				   unsigned int walign,
 				   u32 *h, unsigned int hmin, unsigned int hmax,
 				   unsigned int halign)
@@ -1145,13 +1146,27 @@ static void jpeg_bound_align_image(u32 *w, unsigned int wmin, unsigned int wmax,

 	w_step = 1 << walign;
 	h_step = 1 << halign;
+
+	if (ctx->jpeg->variant->version == SJPEG_EXYNOS3250) {
+		/*
+		 * Rightmost and bottommost pixels are cropped by the
+		 * Exynos3250 JPEG IP for RGB formats, for the specific
+		 * width and height values respectively. This assignment
+		 * will result in v4l_bound_align_image returning dimensions
+		 * reduced by 1 for the aforementioned cases.
+		 */
+		if (w_step == 4 && ((width & 3) == 1)) {
+			wmax = width;
+			hmax = height;
+		}
+	}
+
 	v4l_bound_align_image(w, wmin, wmax, walign, h, hmin, hmax, halign, 0);

 	if (*w < width && (*w + w_step) < wmax)
 		*w += w_step;
 	if (*h < height && (*h + h_step) < hmax)
 		*h += h_step;
-
 }

 static int vidioc_try_fmt(struct v4l2_format *f, struct s5p_jpeg_fmt *fmt,
@@ -1167,12 +1182,12 @@ static int vidioc_try_fmt(struct v4l2_format *f, struct s5p_jpeg_fmt *fmt,
 	/* V4L2 specification suggests the driver corrects the format struct
 	 * if any of the dimensions is unsupported */
 	if (q_type == FMT_TYPE_OUTPUT)
-		jpeg_bound_align_image(&pix->width, S5P_JPEG_MIN_WIDTH,
+		jpeg_bound_align_image(ctx, &pix->width, S5P_JPEG_MIN_WIDTH,
 				       S5P_JPEG_MAX_WIDTH, 0,
 				       &pix->height, S5P_JPEG_MIN_HEIGHT,
 				       S5P_JPEG_MAX_HEIGHT, 0);
 	else
-		jpeg_bound_align_image(&pix->width, S5P_JPEG_MIN_WIDTH,
+		jpeg_bound_align_image(ctx, &pix->width, S5P_JPEG_MIN_WIDTH,
 				       S5P_JPEG_MAX_WIDTH, fmt->h_align,
 				       &pix->height, S5P_JPEG_MIN_HEIGHT,
 				       S5P_JPEG_MAX_HEIGHT, fmt->v_align);
@@ -1294,7 +1309,7 @@ static int exynos4_jpeg_get_output_buffer_size(struct s5p_jpeg_ctx *ctx,
 	else
 		wh_align = 1;

-	jpeg_bound_align_image(&w, S5P_JPEG_MIN_WIDTH,
+	jpeg_bound_align_image(ctx, &w, S5P_JPEG_MIN_WIDTH,
 			       S5P_JPEG_MAX_WIDTH, wh_align,
 			       &h, S5P_JPEG_MIN_HEIGHT,
 			       S5P_JPEG_MAX_HEIGHT, wh_align);
--
1.7.9.5

