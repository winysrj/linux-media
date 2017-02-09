Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:51240
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932448AbdBIUEn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Feb 2017 15:04:43 -0500
From: Thibault Saunier <thibault.saunier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-media@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Thibault Saunier <thibault.saunier@osg.samsung.com>
Subject: [PATCH v2 2/4] [media] exynos-gsc: Respect userspace colorspace setting
Date: Thu,  9 Feb 2017 17:04:18 -0300
Message-Id: <20170209200420.3046-3-thibault.saunier@osg.samsung.com>
In-Reply-To: <20170209200420.3046-1-thibault.saunier@osg.samsung.com>
References: <20170209200420.3046-1-thibault.saunier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the colorspace is specified by userspace we should respect
it and not reset it ourself if we can support it.

Signed-off-by: Thibault Saunier <thibault.saunier@osg.samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 2beb43401987..63bb4577827d 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -445,10 +445,14 @@ int gsc_try_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f)
 
 	pix_mp->num_planes = fmt->num_planes;
 
-	if (pix_mp->width > 720 && pix_mp->height > 576) /* HD */
-		pix_mp->colorspace = V4L2_COLORSPACE_REC709;
-	else /* SD */
-		pix_mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	if (pix_mp->colorspace != V4L2_COLORSPACE_REC709 &&
+		pix_mp->colorspace != V4L2_COLORSPACE_SMPTE170M &&
+		pix_mp->colorspace != V4L2_COLORSPACE_DEFAULT) {
+		if (pix_mp->width > 720 && pix_mp->height > 576) /* HD */
+		  pix_mp->colorspace = V4L2_COLORSPACE_REC709;
+		else /* SD */
+		  pix_mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	  }
 
 	for (i = 0; i < pix_mp->num_planes; ++i) {
 		struct v4l2_plane_pix_format *plane_fmt = &pix_mp->plane_fmt[i];
@@ -492,12 +496,17 @@ int gsc_g_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f)
 	pix_mp->height		= frame->f_height;
 	pix_mp->field		= V4L2_FIELD_NONE;
 	pix_mp->pixelformat	= frame->fmt->pixelformat;
-	if (pix_mp->width > 720 && pix_mp->height > 576) /* HD */
-		pix_mp->colorspace = V4L2_COLORSPACE_REC709;
-	else /* SD */
-		pix_mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
 	pix_mp->num_planes	= frame->fmt->num_planes;
 
+	if (pix_mp->colorspace != V4L2_COLORSPACE_REC709 &&
+		pix_mp->colorspace != V4L2_COLORSPACE_SMPTE170M &&
+		pix_mp->colorspace != V4L2_COLORSPACE_DEFAULT) {
+		if (pix_mp->width > 720 && pix_mp->height > 576) /* HD */
+		  pix_mp->colorspace = V4L2_COLORSPACE_REC709;
+		else /* SD */
+		  pix_mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	  }
+
 	for (i = 0; i < pix_mp->num_planes; ++i) {
 		pix_mp->plane_fmt[i].bytesperline = (frame->f_width *
 			frame->fmt->depth[i]) / 8;
-- 
2.11.1

