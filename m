Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36198
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752433AbdBMTJL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 14:09:11 -0500
From: Thibault Saunier <thibault.saunier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        linux-media@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Thibault Saunier <thibault.saunier@osg.samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v4 2/4] [media] exynos-gsc: Respect userspace colorspace setting in try_fmt
Date: Mon, 13 Feb 2017 16:08:34 -0300
Message-Id: <20170213190836.26972-3-thibault.saunier@osg.samsung.com>
In-Reply-To: <20170213190836.26972-1-thibault.saunier@osg.samsung.com>
References: <20170213190836.26972-1-thibault.saunier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

User userspace provided by the user as we are only doing scaling and
color encoding conversion, we won't be able to transform the colorspace
itself and the colorspace won't mater in that operation.

Also always use output colorspace on the capture side.

Signed-off-by: Thibault Saunier <thibault.saunier@osg.samsung.com>

---

Changes in v4:
- Use any colorspace provided by the user as it won't affect the way we
  handle our operations (guessing it if none is provided)
- Always use output colorspace on the capture side

Changes in v3:
- Do not check values in the g_fmt functions as Andrzej explained in previous review
- Set colorspace if user passed V4L2_COLORSPACE_DEFAULT in

Changes in v2: None

 drivers/media/platform/exynos-gsc/gsc-core.c | 14 ++++++++++----
 drivers/media/platform/exynos-gsc/gsc-core.h |  1 +
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index db7d9883861b..772599de8c13 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -454,6 +454,7 @@ int gsc_try_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f)
 	} else {
 		min_w = variant->pix_min->target_rot_dis_w;
 		min_h = variant->pix_min->target_rot_dis_h;
+		pix_mp->colorspace = ctx->out_colorspace;
 	}
 
 	pr_debug("mod_x: %d, mod_y: %d, max_w: %d, max_h = %d",
@@ -472,10 +473,15 @@ int gsc_try_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f)
 
 	pix_mp->num_planes = fmt->num_planes;
 
-	if (pix_mp->width > 720 && pix_mp->height > 576) /* HD */
-		pix_mp->colorspace = V4L2_COLORSPACE_REC709;
-	else /* SD */
-		pix_mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	if (pix_mp->colorspace == V4L2_COLORSPACE_DEFAULT) {
+		if (pix_mp->width > 720 && pix_mp->height > 576) /* HD */
+			pix_mp->colorspace = V4L2_COLORSPACE_REC709;
+		else /* SD */
+			pix_mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	}
+
+	if (V4L2_TYPE_IS_OUTPUT(f->type))
+		ctx->out_colorspace = pix_mp->colorspace;
 
 	for (i = 0; i < pix_mp->num_planes; ++i) {
 		struct v4l2_plane_pix_format *plane_fmt = &pix_mp->plane_fmt[i];
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
index 696217e9af66..715d9c9d8d30 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.h
+++ b/drivers/media/platform/exynos-gsc/gsc-core.h
@@ -376,6 +376,7 @@ struct gsc_ctx {
 	struct v4l2_ctrl_handler ctrl_handler;
 	struct gsc_ctrls	gsc_ctrls;
 	bool			ctrls_rdy;
+	enum v4l2_colorspace out_colorspace;
 };
 
 void gsc_set_prefbuf(struct gsc_dev *gsc, struct gsc_frame *frm);
-- 
2.11.1
