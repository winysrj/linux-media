Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52837 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750992AbdBUJ4W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 04:56:22 -0500
Subject: Re: [PATCH v4 1/4] [media] exynos-gsc: Use 576p instead 720p as a
 threshold for colorspaces
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
        Hans Verkuil <hverkuil@xs4all.nl>
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <a94f6241-373a-20c2-d306-48bd979fe6c6@samsung.com>
Date: Tue, 21 Feb 2017 10:56:09 +0100
MIME-version: 1.0
In-reply-to: <20170213190836.26972-2-thibault.saunier@osg.samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
References: <20170213190836.26972-1-thibault.saunier@osg.samsung.com>
 <CGME20170213191052epcas3p3af2c3165d94bc82b77f7a7fab6550b15@epcas3p3.samsung.com>
 <20170213190836.26972-2-thibault.saunier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13.02.2017 20:08, Thibault Saunier wrote:
> From: Javier Martinez Canillas <javier@osg.samsung.com>
>
> The media documentation says that the V4L2_COLORSPACE_SMPTE170M colorspace
> should be used for SDTV and V4L2_COLORSPACE_REC709 for HDTV. But drivers
> don't agree on the display resolution that should be used as a threshold.
>
> >From EIA CEA 861B about colorimetry for various resolutions:
>
>   - 5.1 480p, 480i, 576p, 576i, 240p, and 288p
>     The color space used by the 480-line, 576-line, 240-line, and 288-line
>     formats will likely be based on SMPTE 170M [1].
>   - 5.2 1080i, 1080p, and 720p
>     The color space used by the high definition formats will likely be
>     based on ITU-R BT.709-4
>
> This indicates that in the case that userspace does not specify what
> colorspace should be used, we should use 576p  as a threshold to set
> V4L2_COLORSPACE_REC709 instead of V4L2_COLORSPACE_REC709. Even if it is
> only 'likely' and not a requirement it is the best guess we can make.
>
> The stream should have been encoded with the information and userspace
> has to pass it to the driver if it is not the case, otherwise we won't be
> able to handle it properly anyhow.
>
> Also, check for the resolution in G_FMT instead unconditionally setting
> the V4L2_COLORSPACE_REC709 colorspace.
>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> Signed-off-by: Thibault Saunier <thibault.saunier@osg.samsung.com>
> Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>

Hi Thibault,

Have you analyzed Hans response for the previous patchset [1] ?
I am not an expert in the subject but it seems he is right. GSCALER
datasheet uses term 'color space conversion' to describe conversions
between RGB and YCbCr, not for describe colorspaces as in V4L2.
GSC_(IN|OUT)_RGB_(HD|SD)_(WIDE|NARROW) macros used to set IN_CON and
OUT_CON registers of GSCALER are probably used incorrectly, they should
not be set according to pix_mp->colorspace but rather according to
pix_mp->ycbcr_enc and pix_mp->quantization. pix_mp->colorspace should be
just copied from output to capture side.

Please fix the patch accordingly, and if you are interested you can
prepare another patch to fix register setting.

[1]: https://lkml.org/lkml/2017/2/10/473

Regards
Andrzej

>
> ---
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
