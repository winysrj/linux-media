Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAJNnJ28013736
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 18:49:19 -0500
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAJNmojv029181
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 18:48:50 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <Pine.LNX.4.64.0811181945410.8628@axis700.grange>
	<Pine.LNX.4.64.0811182010460.8628@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Wed, 19 Nov 2008 22:29:59 +0100
In-Reply-To: <Pine.LNX.4.64.0811182010460.8628@axis700.grange> (Guennadi
	Liakhovetski's message of "Tue\,
	18 Nov 2008 20\:25\:56 +0100 \(CET\)")
Message-ID: <87y6zf76aw.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 2/2 v3] pxa-camera: pixel format negotiation
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

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Use the new format-negotiation infrastructure, support all four YUV422 
> packed and the planar formats.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>
> ---
Hi Guennadi,

Please find my review here.

> diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
> index 37afdfa..1bcdb5d 100644
> --- a/drivers/media/video/pxa_camera.c
> +++ b/drivers/media/video/pxa_camera.c
> @@ -765,6 +765,9 @@ static int test_platform_param(struct pxa_camera_dev *pcdev,
>  		if (!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8))
>  			return -EINVAL;
>  		*flags |= SOCAM_DATAWIDTH_8;
> +		break;
> +	default:
> +		return -EINVAL;
If we're in pass-through mode, and depth is 16 (example: a today unknown RYB
format), we return -EINVAL. Is that on purpose ?

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
Why do we bother testing it ? If format negociation was done before, a format
asked for is necessarily available, otherwise it should have been removed at
format generation.

Likewise, is bus param matching necessary here, or should it be done at format
generation ? Can that be really be dynamic, or is it constrained by hardware,
and thus only necessary at startup, and not at each format try ?

<snip>
> +static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
> +				  const struct soc_camera_data_format **fmt)
> +{
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct pxa_camera_dev *pcdev = ici->priv;
> +	int formats = 0;
> +
> +	switch (icd->formats[idx].fourcc) {
> +	case V4L2_PIX_FMT_UYVY:
> +		formats++;
> +		if (fmt && (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)) {
> +			*fmt++ = &pxa_camera_formats[0];
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
> +		if (fmt && (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)) {
> +			*fmt++ = &icd->formats[idx];
> +			dev_dbg(&ici->dev, "Providing format %s packed\n",
> +				icd->formats[idx].name);
> +		}
> +		break;
What if pcdev->platform_flags is 9 bits wide and sensor provides RGB565 ?
Variable formats will be incremented, but fmt will never be filled in. So there
will be holes in fmt. Shouldn't the formats++ depend on platform_flags &
PXA_CAMERA_DATAWIDTH_8 ?

> +	default:
> +		/* Generic pass-through */
> +		if (depth_supported(icd, icd->formats[idx].depth)) {
> +			formats++;
> +			if (fmt) {
> +				*fmt++ = &icd->formats[idx];
> +				dev_dbg(&ici->dev,
> +					"Providing format %s in pass-through mode\n",
> +					icd->formats[idx].name);
> +			}
> +		}
> +	}
Dito for formats++.

>  static int pxa_camera_set_fmt(struct soc_camera_device *icd,
>  			      __u32 pixfmt, struct v4l2_rect *rect)
<snip>
> +	case V4L2_PIX_FMT_UYVY:
> +	case V4L2_PIX_FMT_VYUY:
> +	case V4L2_PIX_FMT_YUYV:
> +	case V4L2_PIX_FMT_YVYU:
> +	case V4L2_PIX_FMT_RGB565:
> +	case V4L2_PIX_FMT_RGB555:
> +		if (!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)) {
> +			dev_warn(&ici->dev,
> +				 "8 bit bus unsupported, but required for format %x\n",
> +				 pixfmt);
> +			return -EINVAL;
Shouldn't that be already computed by format generation ?

> +		/* Generic pass-through */
> +		host_fmt = soc_camera_format_by_fourcc(icd, pixfmt);
> +		if (!host_fmt || !depth_supported(icd, host_fmt->depth)) {
> +			dev_warn(&ici->dev,
> +				 "Format %x unsupported in pass-through mode\n",
> +				 pixfmt);
> +			return -EINVAL;
> +		}
Ditto.

> @@ -930,34 +1049,70 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
>  static int pxa_camera_try_fmt(struct soc_camera_device *icd,
>  			      struct v4l2_format *f)
>  {
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct pxa_camera_dev *pcdev = ici->priv;
>  	const struct soc_camera_data_format *cam_fmt;
> -	int ret = pxa_camera_try_bus_param(icd, f->fmt.pix.pixelformat);
> +	struct v4l2_pix_format *pix = &f->fmt.pix;
> +	__u32 pixfmt = pix->pixelformat;
> +	unsigned char buswidth;
> +	int ret;
>  
> -	if (ret < 0)
> -		return ret;
> +	switch (pixfmt) {
> +	case V4L2_PIX_FMT_YUV422P:
> +		pixfmt = V4L2_PIX_FMT_UYVY;
> +	case V4L2_PIX_FMT_UYVY:
> +	case V4L2_PIX_FMT_VYUY:
> +	case V4L2_PIX_FMT_YUYV:
> +	case V4L2_PIX_FMT_YVYU:
> +	case V4L2_PIX_FMT_RGB565:
> +	case V4L2_PIX_FMT_RGB555:
> +		if (!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)) {
> +			dev_warn(&ici->dev,
> +				 "try-fmt: 8 bit bus unsupported for format %x\n",
> +				 pixfmt);
> +			return -EINVAL;
> +		}
Ditto.

>  
> -	/*
> -	 * TODO: find a suitable supported by the SoC output format, check
> -	 * whether the sensor supports one of acceptable input formats.
> -	 */
> -	cam_fmt = soc_camera_format_by_fourcc(icd, f->fmt.pix.pixelformat);
> -	if (!cam_fmt)
> -		return -EINVAL;
> +		cam_fmt = soc_camera_format_by_fourcc(icd, pixfmt);
> +		if (!cam_fmt) {
> +			dev_warn(&ici->dev, "try-fmt: format %x not found\n",
> +				 pixfmt);
> +			return -EINVAL;
> +		}
> +		buswidth = 8;
> +		break;
> +	default:
> +		/* Generic pass-through */
> +		cam_fmt = soc_camera_format_by_fourcc(icd, pixfmt);
> +		if (!cam_fmt || !depth_supported(icd, cam_fmt->depth)) {
> +			dev_warn(&ici->dev,
> +				 "try-fmt: Format %x unsupported in pass-through\n",
> +				 pixfmt);
> +			return -EINVAL;
> +		}
> +		buswidth = cam_fmt->depth;
> +	}
> +
> +	ret = pxa_camera_try_bus_param(icd, buswidth);
Ditto.

All in all, I wonder why we need that many tests, and if we could reduce them at
format generation (under hypothesis that platform_flags are constant and sensor
flags are constant).

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
