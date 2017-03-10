Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:59739 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935376AbdCJKbN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 05:31:13 -0500
Subject: Re: [PATCH v6 1/2] [media] exynos-gsc: Use user configured colorspace
 if provided
To: Thibault Saunier <thibault.saunier@osg.samsung.com>,
        linux-kernel@vger.kernel.org
References: <20170301115108.14187-1-thibault.saunier@osg.samsung.com>
 <20170301115108.14187-2-thibault.saunier@osg.samsung.com>
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
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <624d41f9-bdcb-3a9d-b462-109d1442bd7f@xs4all.nl>
Date: Fri, 10 Mar 2017 11:31:08 +0100
MIME-Version: 1.0
In-Reply-To: <20170301115108.14187-2-thibault.saunier@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/03/17 12:51, Thibault Saunier wrote:
> Use colorspace provided by the user as we are only doing scaling and
> color encoding conversion, we won't be able to transform the colorspace
> itself and the colorspace won't mater in that operation.
> 
> Also always use output colorspace on the capture side.
> 
> If the user does not provide a colorspace do no make it up, we might
> later while processing need to figure out the colorspace, which
> is possible depending on the frame size but do not ever guess and
> leak that guess to the userspace.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> Signed-off-by: Thibault Saunier <thibault.saunier@osg.samsung.com>
> Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
> 
> ---
> 
> Changes in v6:
> - Do not ever guess colorspace
> 
> Changes in v5:
> - Squash commit to always use output colorspace on the capture side
>   inside this one
> - Fix typo in commit message
> 
> Changes in v4:
> - Reword commit message to better back our assumptions on specifications
> 
> Changes in v3:
> - Do not check values in the g_fmt functions as Andrzej explained in previous review
> - Added 'Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>'
> 
> Changes in v2: None
> 
>  drivers/media/platform/exynos-gsc/gsc-core.c | 9 ++++-----
>  drivers/media/platform/exynos-gsc/gsc-core.h | 1 +
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
> index 59a634201830..0241168c85af 100644
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
> @@ -472,10 +473,8 @@ int gsc_try_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f)
>  
>  	pix_mp->num_planes = fmt->num_planes;
>  
> -	if (pix_mp->width >= 1280) /* HD */
> -		pix_mp->colorspace = V4L2_COLORSPACE_REC709;
> -	else /* SD */
> -		pix_mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
> +	if (V4L2_TYPE_IS_OUTPUT(f->type))
> +		ctx->out_colorspace = pix_mp->colorspace;
>  
>  	for (i = 0; i < pix_mp->num_planes; ++i) {
>  		struct v4l2_plane_pix_format *plane_fmt = &pix_mp->plane_fmt[i];
> @@ -519,8 +518,8 @@ int gsc_g_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f)
>  	pix_mp->height		= frame->f_height;
>  	pix_mp->field		= V4L2_FIELD_NONE;
>  	pix_mp->pixelformat	= frame->fmt->pixelformat;
> -	pix_mp->colorspace	= V4L2_COLORSPACE_REC709;
>  	pix_mp->num_planes	= frame->fmt->num_planes;
> +	pix_mp->colorspace = ctx->out_colorspace;

You need to do the same for the ycbcr_enc, xfer_func and quantization fields.
With that in place it is fully 'colorspace compliant' :-)

Regards,

	Hans

>  
>  	for (i = 0; i < pix_mp->num_planes; ++i) {
>  		pix_mp->plane_fmt[i].bytesperline = (frame->f_width *
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
> 
