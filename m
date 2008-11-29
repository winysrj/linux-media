Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mATFoAxq023897
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 10:50:10 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mATFmtjN018006
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 10:48:55 -0500
Date: Sat, 29 Nov 2008 16:49:06 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <1227968224-21577-2-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.0811291644200.8352@axis700.grange>
References: <Pine.LNX.4.64.0811181945410.8628@axis700.grange>
	<1227968224-21577-1-git-send-email-robert.jarzmik@free.fr>
	<1227968224-21577-2-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH v4 2/2] pxa-camera: pixel format negotiation
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Heh, couldn't wait until tomorrow?:-)

On Sat, 29 Nov 2008, Robert Jarzmik wrote:

> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

I haven't looked at the patches yet - will do tomorrow or on monday, but - 
I actually wanted them to be "from you" - that's why I suggested you to do 
the final version. Otherwise I would have done that myself - don't want to 
steal your work. But if you insist, I think, we can share - I make 1/2 
(spc-camera) "from me" and 2/2 (pxa) "from you" - agree?

Thanks
Guennadi

> 
> Use the new format-negotiation infrastructure, support all four YUV422
> packed and the planar formats.
> 
> The new translation structure enables to build the format
> list with buswidth, depth, host format and camera format
> checked, so that it's not done anymore on try_fmt nor
> set_fmt.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>  drivers/media/video/pxa_camera.c |  207 ++++++++++++++++++++++++++++++--------
>  1 files changed, 165 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
> index 37afdfa..8219a6c 100644
> --- a/drivers/media/video/pxa_camera.c
> +++ b/drivers/media/video/pxa_camera.c
> @@ -765,6 +765,9 @@ static int test_platform_param(struct pxa_camera_dev *pcdev,
>  		if (!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8))
>  			return -EINVAL;
>  		*flags |= SOCAM_DATAWIDTH_8;
> +		break;
> +	default:
> +		return -EINVAL;
>  	}
>  
>  	return 0;
> @@ -823,12 +826,10 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
>  	 * We fix bit-per-pixel equal to data-width... */
>  	switch (common_flags & SOCAM_DATAWIDTH_MASK) {
>  	case SOCAM_DATAWIDTH_10:
> -		icd->buswidth = 10;
>  		dw = 4;
>  		bpp = 0x40;
>  		break;
>  	case SOCAM_DATAWIDTH_9:
> -		icd->buswidth = 9;
>  		dw = 3;
>  		bpp = 0x20;
>  		break;
> @@ -836,7 +837,6 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
>  		/* Actually it can only be 8 now,
>  		 * default is just to silence compiler warnings */
>  	case SOCAM_DATAWIDTH_8:
> -		icd->buswidth = 8;
>  		dw = 2;
>  		bpp = 0;
>  	}
> @@ -862,7 +862,17 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
>  	case V4L2_PIX_FMT_YUV422P:
>  		pcdev->channels = 3;
>  		cicr1 |= CICR1_YCBCR_F;
> +		/*
> +		 * Normally, pxa bus wants as input UYVY format. We allow all
> +		 * reorderings of the YUV422 format, as no processing is done,
> +		 * and the YUV stream is just passed through without any
> +		 * transformation. Note that UYVY is the only format that
> +		 * should be used if pxa framebuffer Overlay2 is used.
> +		 */
> +	case V4L2_PIX_FMT_UYVY:
> +	case V4L2_PIX_FMT_VYUY:
>  	case V4L2_PIX_FMT_YUYV:
> +	case V4L2_PIX_FMT_YVYU:
>  		cicr1 |= CICR1_COLOR_SP_VAL(2);
>  		break;
>  	case V4L2_PIX_FMT_RGB555:
> @@ -888,13 +898,14 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
>  	return 0;
>  }
>  
> -static int pxa_camera_try_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
> +static int pxa_camera_try_bus_param(struct soc_camera_device *icd,
> +				    unsigned char buswidth)
>  {
>  	struct soc_camera_host *ici =
>  		to_soc_camera_host(icd->dev.parent);
>  	struct pxa_camera_dev *pcdev = ici->priv;
>  	unsigned long bus_flags, camera_flags;
> -	int ret = test_platform_param(pcdev, icd->buswidth, &bus_flags);
> +	int ret = test_platform_param(pcdev, buswidth, &bus_flags);
>  
>  	if (ret < 0)
>  		return ret;
> @@ -904,25 +915,139 @@ static int pxa_camera_try_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
>  	return soc_camera_bus_param_compatible(camera_flags, bus_flags) ? 0 : -EINVAL;
>  }
>  
> +static const struct soc_camera_data_format pxa_camera_formats[] = {
> +	{
> +		.name		= "Planar YUV422 16 bit",
> +		.depth		= 16,
> +		.fourcc		= V4L2_PIX_FMT_YUV422P,
> +		.colorspace	= V4L2_COLORSPACE_JPEG,
> +	},
> +};
> +
> +static bool buswidth_supported(struct soc_camera_device *icd, int depth)
> +{
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct pxa_camera_dev *pcdev = ici->priv;
> +
> +	switch (depth) {
> +	case 8:
> +		return !!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8);
> +	case 9:
> +		return !!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_9);
> +	case 10:
> +		return !!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_10);
> +	}
> +	return false;
> +}
> +
> +static int required_buswidth(const struct soc_camera_data_format *fmt)
> +{
> +	switch (fmt->fourcc) {
> +	case V4L2_PIX_FMT_UYVY:
> +	case V4L2_PIX_FMT_VYUY:
> +	case V4L2_PIX_FMT_YUYV:
> +	case V4L2_PIX_FMT_YVYU:
> +	case V4L2_PIX_FMT_RGB565:
> +	case V4L2_PIX_FMT_RGB555:
> +		return 8;
> +	default:
> +		return fmt->depth;
> +	}
> +}
> +
> +static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
> +				  struct soc_camera_format_xlate *xlate)
> +{
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	int formats = 0, buswidth, ret;
> +
> +	buswidth = required_buswidth(icd->formats + idx);
> +
> +	if (!buswidth_supported(icd, buswidth))
> +		return 0;
> +
> +	ret = pxa_camera_try_bus_param(icd, buswidth);
> +	if (ret < 0)
> +		return 0;
> +
> +	switch (icd->formats[idx].fourcc) {
> +	case V4L2_PIX_FMT_UYVY:
> +		formats++;
> +		if (xlate) {
> +			xlate->host_fmt = &pxa_camera_formats[0];
> +			xlate->cam_fmt = icd->formats + idx;
> +			xlate->buswidth = buswidth;
> +			xlate++;
> +			dev_dbg(&ici->dev, "Providing format %s using %s\n",
> +				pxa_camera_formats[0].name,
> +				icd->formats[idx].name);
> +		}
> +	case V4L2_PIX_FMT_VYUY:
> +	case V4L2_PIX_FMT_YUYV:
> +	case V4L2_PIX_FMT_YVYU:
> +	case V4L2_PIX_FMT_RGB565:
> +	case V4L2_PIX_FMT_RGB555:
> +		formats++;
> +		if (xlate) {
> +			xlate->host_fmt = icd->formats + idx;
> +			xlate->cam_fmt = icd->formats + idx;
> +			xlate->buswidth = buswidth;
> +			xlate++;
> +			dev_dbg(&ici->dev, "Providing format %s packed\n",
> +				icd->formats[idx].name);
> +		}
> +		break;
> +	default:
> +		/* Generic pass-through */
> +		formats++;
> +		if (xlate) {
> +			xlate->host_fmt = icd->formats + idx;
> +			xlate->cam_fmt = icd->formats + idx;
> +			xlate->buswidth = icd->formats[idx].depth;
> +			xlate++;
> +			dev_dbg(&ici->dev,
> +				"Providing format %s in pass-through mode\n",
> +				icd->formats[idx].name);
> +		}
> +	}
> +
> +	return formats;
> +}
> +
>  static int pxa_camera_set_fmt(struct soc_camera_device *icd,
>  			      __u32 pixfmt, struct v4l2_rect *rect)
>  {
> -	const struct soc_camera_data_format *cam_fmt;
> -	int ret;
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	const struct soc_camera_data_format *host_fmt, *cam_fmt = NULL;
> +	const struct soc_camera_format_xlate *xlate;
> +	int ret, buswidth;
>  
> -	/*
> -	 * TODO: find a suitable supported by the SoC output format, check
> -	 * whether the sensor supports one of acceptable input formats.
> -	 */
> -	if (pixfmt) {
> -		cam_fmt = soc_camera_format_by_fourcc(icd, pixfmt);
> -		if (!cam_fmt)
> -			return -EINVAL;
> +	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
> +	if (!xlate) {
> +		dev_warn(&ici->dev, "Format %x not found\n", pixfmt);
> +		return -EINVAL;
>  	}
>  
> -	ret = icd->ops->set_fmt(icd, pixfmt, rect);
> -	if (pixfmt && !ret)
> -		icd->current_fmt = cam_fmt;
> +	buswidth = xlate->buswidth;
> +	host_fmt = xlate->host_fmt;
> +	cam_fmt = xlate->cam_fmt;
> +
> +	switch (pixfmt) {
> +	case 0:				/* Only geometry change */
> +		ret = icd->ops->set_fmt(icd, pixfmt, rect);
> +		break;
> +	default:
> +		ret = icd->ops->set_fmt(icd, cam_fmt->fourcc, rect);
> +	}
> +
> +	if (ret < 0)
> +		dev_warn(&ici->dev, "Failed to configure for format %x\n",
> +			 pixfmt);
> +
> +	if (pixfmt && !ret) {
> +		icd->buswidth = buswidth;
> +		icd->current_fmt = host_fmt;
> +	}
>  
>  	return ret;
>  }
> @@ -930,34 +1055,31 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
>  static int pxa_camera_try_fmt(struct soc_camera_device *icd,
>  			      struct v4l2_format *f)
>  {
> -	const struct soc_camera_data_format *cam_fmt;
> -	int ret = pxa_camera_try_bus_param(icd, f->fmt.pix.pixelformat);
> -
> -	if (ret < 0)
> -		return ret;
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	const struct soc_camera_format_xlate *xlate;
> +	struct v4l2_pix_format *pix = &f->fmt.pix;
> +	__u32 pixfmt = pix->pixelformat;
>  
> -	/*
> -	 * TODO: find a suitable supported by the SoC output format, check
> -	 * whether the sensor supports one of acceptable input formats.
> -	 */
> -	cam_fmt = soc_camera_format_by_fourcc(icd, f->fmt.pix.pixelformat);
> -	if (!cam_fmt)
> +	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
> +	if (!xlate) {
> +		dev_warn(&ici->dev, "Format %x not found\n", pixfmt);
>  		return -EINVAL;
> +	}
>  
>  	/* limit to pxa hardware capabilities */
> -	if (f->fmt.pix.height < 32)
> -		f->fmt.pix.height = 32;
> -	if (f->fmt.pix.height > 2048)
> -		f->fmt.pix.height = 2048;
> -	if (f->fmt.pix.width < 48)
> -		f->fmt.pix.width = 48;
> -	if (f->fmt.pix.width > 2048)
> -		f->fmt.pix.width = 2048;
> -	f->fmt.pix.width &= ~0x01;
> -
> -	f->fmt.pix.bytesperline = f->fmt.pix.width *
> -		DIV_ROUND_UP(cam_fmt->depth, 8);
> -	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
> +	if (pix->height < 32)
> +		pix->height = 32;
> +	if (pix->height > 2048)
> +		pix->height = 2048;
> +	if (pix->width < 48)
> +		pix->width = 48;
> +	if (pix->width > 2048)
> +		pix->width = 2048;
> +	pix->width &= ~0x01;
> +
> +	pix->bytesperline = pix->width *
> +		DIV_ROUND_UP(xlate->host_fmt->depth, 8);
> +	pix->sizeimage = pix->height * pix->bytesperline;
>  
>  	/* limit to sensor capabilities */
>  	return icd->ops->try_fmt(icd, f);
> @@ -1068,6 +1190,7 @@ static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
>  	.remove		= pxa_camera_remove_device,
>  	.suspend	= pxa_camera_suspend,
>  	.resume		= pxa_camera_resume,
> +	.get_formats	= pxa_camera_get_formats,
>  	.set_fmt	= pxa_camera_set_fmt,
>  	.try_fmt	= pxa_camera_try_fmt,
>  	.init_videobuf	= pxa_camera_init_videobuf,
> -- 
> 1.5.6.5
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
