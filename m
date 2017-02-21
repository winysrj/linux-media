Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:54640 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751740AbdBUKQC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 05:16:02 -0500
Subject: Re: [PATCH v4 2/4] [media] exynos-gsc: Respect userspace colorspace
 setting in try_fmt
To: Thibault Saunier <thibault.saunier@osg.samsung.com>,
        linux-kernel@vger.kernel.org
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
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <096e059d-0a49-f1e0-a4e3-5c223ff15b3e@samsung.com>
Date: Tue, 21 Feb 2017 11:15:54 +0100
MIME-version: 1.0
In-reply-to: <20170213190836.26972-3-thibault.saunier@osg.samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
References: <20170213190836.26972-1-thibault.saunier@osg.samsung.com>
 <CGME20170213191038epcas2p2539b687d2abe16c8ca4e1deb21e9fb59@epcas2p2.samsung.com>
 <20170213190836.26972-3-thibault.saunier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13.02.2017 20:08, Thibault Saunier wrote:
> User userspace provided by the user as we are only doing scaling and
> color encoding conversion, we won't be able to transform the colorspace
> itself and the colorspace won't mater in that operation.
>
> Also always use output colorspace on the capture side.
>
> Signed-off-by: Thibault Saunier <thibault.saunier@osg.samsung.com>

This patch can be squashed with previous one as the only thing to do is
to set output colorspace the same as capture colorspace.

--
Regards
Andrzej

>
> ---
>
> Changes in v4:
> - Use any colorspace provided by the user as it won't affect the way we
>   handle our operations (guessing it if none is provided)
> - Always use output colorspace on the capture side
>
> Changes in v3:
> - Do not check values in the g_fmt functions as Andrzej explained in previous review
> - Set colorspace if user passed V4L2_COLORSPACE_DEFAULT in
>
> Changes in v2: None
>
>  drivers/media/platform/exynos-gsc/gsc-core.c | 14 ++++++++++----
>  drivers/media/platform/exynos-gsc/gsc-core.h |  1 +
>  2 files changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
> index db7d9883861b..772599de8c13 100644
> --- a/drivers/media/platform/exynos-gsc/gsc-core.c
> +++ b/drivers/media/platform/exynos-gsc/gsc-core.c
> @@ -454,6 +454,7 @@ int gsc_try_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f)
>  	} else {
>  		min_w = variant->pix_min->target_rot_dis_w;
>  		min_h = variant->pix_min->target_rot_dis_h;
> +		pix_mp->colorspace = ctx->out_colorspace;
>  	}
>  
>  	pr_debug("mod_x: %d, mod_y: %d, max_w: %d, max_h = %d",
> @@ -472,10 +473,15 @@ int gsc_try_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f)
>  
>  	pix_mp->num_planes = fmt->num_planes;
>  
> -	if (pix_mp->width > 720 && pix_mp->height > 576) /* HD */
> -		pix_mp->colorspace = V4L2_COLORSPACE_REC709;
> -	else /* SD */
> -		pix_mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
> +	if (pix_mp->colorspace == V4L2_COLORSPACE_DEFAULT) {
> +		if (pix_mp->width > 720 && pix_mp->height > 576) /* HD */
> +			pix_mp->colorspace = V4L2_COLORSPACE_REC709;
> +		else /* SD */
> +			pix_mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
> +	}
> +
> +	if (V4L2_TYPE_IS_OUTPUT(f->type))
> +		ctx->out_colorspace = pix_mp->colorspace;
>  
>  	for (i = 0; i < pix_mp->num_planes; ++i) {
>  		struct v4l2_plane_pix_format *plane_fmt = &pix_mp->plane_fmt[i];
> diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
> index 696217e9af66..715d9c9d8d30 100644
> --- a/drivers/media/platform/exynos-gsc/gsc-core.h
> +++ b/drivers/media/platform/exynos-gsc/gsc-core.h
> @@ -376,6 +376,7 @@ struct gsc_ctx {
>  	struct v4l2_ctrl_handler ctrl_handler;
>  	struct gsc_ctrls	gsc_ctrls;
>  	bool			ctrls_rdy;
> +	enum v4l2_colorspace out_colorspace;
>  };
>  
>  void gsc_set_prefbuf(struct gsc_dev *gsc, struct gsc_frame *frm);
