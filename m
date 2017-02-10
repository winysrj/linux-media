Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:47575 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752090AbdBJPID (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 10:08:03 -0500
Subject: Re: [PATCH v3 1/4] [media] exynos-gsc: Use 576p instead 720p as a
 threshold for colorspaces
To: Thibault Saunier <thibault.saunier@osg.samsung.com>,
        linux-kernel@vger.kernel.org
References: <20170210141022.25412-1-thibault.saunier@osg.samsung.com>
 <20170210141022.25412-2-thibault.saunier@osg.samsung.com>
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
        Ulf Hansson <ulf.hansson@linaro.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4270fc60-579b-64d0-4256-403e4e5bf371@xs4all.nl>
Date: Fri, 10 Feb 2017 16:07:54 +0100
MIME-Version: 1.0
In-Reply-To: <20170210141022.25412-2-thibault.saunier@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/10/2017 03:10 PM, Thibault Saunier wrote:
> From: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> The media documentation says that the V4L2_COLORSPACE_SMPTE170M colorspace
> should be used for SDTV and V4L2_COLORSPACE_REC709 for HDTV. But drivers
> don't agree on the display resolution that should be used as a threshold.
> 
> Some drivers set V4L2_COLORSPACE_REC709 for 720p and higher while others
> set V4L2_COLORSPACE_REC709 for anything higher than 576p. Newers drivers
> use the latter and that also matches what user-space multimedia programs
> do (i.e: GStreamer), so change the driver logic to be aligned with this.
> 
> Also, check for the resolution in G_FMT instead unconditionally setting
> the V4L2_COLORSPACE_REC709 colorspace.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
> 
> Signed-off-by: Thibault Saunier <thibault.saunier@osg.samsung.com>
> ---
> 
> Changes in v3:
> - Do not check values in the g_fmt functions as Andrzej explained in previous review
> - Added 'Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>'
> 
> Changes in v2: None
> 
>  drivers/media/platform/exynos-gsc/gsc-core.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
> index 59a634201830..db7d9883861b 100644
> --- a/drivers/media/platform/exynos-gsc/gsc-core.c
> +++ b/drivers/media/platform/exynos-gsc/gsc-core.c
> @@ -472,7 +472,7 @@ int gsc_try_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f)
>  
>  	pix_mp->num_planes = fmt->num_planes;
>  
> -	if (pix_mp->width >= 1280) /* HD */
> +	if (pix_mp->width > 720 && pix_mp->height > 576) /* HD */
>  		pix_mp->colorspace = V4L2_COLORSPACE_REC709;
>  	else /* SD */
>  		pix_mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
> @@ -519,9 +519,13 @@ int gsc_g_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f)
>  	pix_mp->height		= frame->f_height;
>  	pix_mp->field		= V4L2_FIELD_NONE;
>  	pix_mp->pixelformat	= frame->fmt->pixelformat;
> -	pix_mp->colorspace	= V4L2_COLORSPACE_REC709;
>  	pix_mp->num_planes	= frame->fmt->num_planes;
>  
> +	if (pix_mp->width > 720 && pix_mp->height > 576) /* HD */
> +		pix_mp->colorspace = V4L2_COLORSPACE_REC709;
> +	else /* SD */
> +		pix_mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
> +
>  	for (i = 0; i < pix_mp->num_planes; ++i) {
>  		pix_mp->plane_fmt[i].bytesperline = (frame->f_width *
>  			frame->fmt->depth[i]) / 8;
> 

This is a mem2mem device, right? In the case of mem2mem devices the driver should never
set the colorspace, instead it just copies it from what the application provides (the
video output side) to the capture side.

After all, you are just scaling here so the input and output colorspaces are
exactly the same, and the scaler doesn't care what the colorspace is.

Regards,

	Hans
