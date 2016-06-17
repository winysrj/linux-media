Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:38795 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752080AbcFQHNy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 03:13:54 -0400
Subject: Re: [PATCH 6/6] [media] gsc-m2m: improve v4l2_capability driver and
 card fields
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-kernel@vger.kernel.org
References: <1466113235-25909-1-git-send-email-javier@osg.samsung.com>
 <1466113235-25909-7-git-send-email-javier@osg.samsung.com>
Cc: Junghak Sung <jh1009.sung@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5763A32C.2000307@xs4all.nl>
Date: Fri, 17 Jun 2016 09:13:48 +0200
MIME-Version: 1.0
In-Reply-To: <1466113235-25909-7-git-send-email-javier@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2016 11:40 PM, Javier Martinez Canillas wrote:
> According to the V4L2 documentation the driver and card fields should be
> used to identify the driver and the device but the gsc-m2m driver fills
> those field using the platform device name, which in turn is the name of
> the device DT node.
> 
> So not only the filled information isn't correct but also the same values
> are used in the driver, card and bus_info fields.
> 
> Before this patch:
> 
> Driver Info (not using libv4l2):
>         Driver name   : 13e00000.video-
>         Card type     : 13e00000.video-scaler
>         Bus info      : platform:13e00000.video-scaler
>         Driver version: 4.7.0
> 
> After this patch:
> 
> Driver Info (not using libv4l2):
>         Driver name   : exynos-gsc
>         Card type     : exynos-gsc gscaler
>         Bus info      : platform:13e00000.video-scaler
>         Driver version: 4.7.0
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

Hans

> 
> ---
> 
>  drivers/media/platform/exynos-gsc/gsc-m2m.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
> index af81383086b8..274861c27367 100644
> --- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
> +++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
> @@ -279,8 +279,8 @@ static int gsc_m2m_querycap(struct file *file, void *fh,
>  	struct gsc_ctx *ctx = fh_to_ctx(fh);
>  	struct gsc_dev *gsc = ctx->gsc_dev;
>  
> -	strlcpy(cap->driver, gsc->pdev->name, sizeof(cap->driver));
> -	strlcpy(cap->card, gsc->pdev->name, sizeof(cap->card));
> +	strlcpy(cap->driver, GSC_MODULE_NAME, sizeof(cap->driver));
> +	strlcpy(cap->card, GSC_MODULE_NAME " gscaler", sizeof(cap->card));
>  	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
>  		 dev_name(&gsc->pdev->dev));
>  	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE |
> 
