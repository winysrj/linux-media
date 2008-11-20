Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAKKiNwW020055
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 15:44:23 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAKKheAv019487
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 15:44:04 -0500
Date: Thu, 20 Nov 2008 21:43:40 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <87y6zf76aw.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0811202055210.8290@axis700.grange>
References: <Pine.LNX.4.64.0811181945410.8628@axis700.grange>
	<Pine.LNX.4.64.0811182010460.8628@axis700.grange>
	<87y6zf76aw.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

On Wed, 19 Nov 2008, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > Use the new format-negotiation infrastructure, support all four YUV422 
> > packed and the planar formats.
> >
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >
> > ---
> Hi Guennadi,
> 
> Please find my review here.
> 
> > diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
> > index 37afdfa..1bcdb5d 100644
> > --- a/drivers/media/video/pxa_camera.c
> > +++ b/drivers/media/video/pxa_camera.c
> > @@ -765,6 +765,9 @@ static int test_platform_param(struct pxa_camera_dev *pcdev,
> >  		if (!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8))
> >  			return -EINVAL;
> >  		*flags |= SOCAM_DATAWIDTH_8;
> > +		break;
> > +	default:
> > +		return -EINVAL;
> If we're in pass-through mode, and depth is 16 (example: a today unknown RYB
> format), we return -EINVAL. Is that on purpose ?

Yes, I do not know how to pass a 16-bit format in a pass-through mode, and 
I don't have a test-case for it. Do you?

> > -static int pxa_camera_try_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
> > +static int pxa_camera_try_bus_param(struct soc_camera_device *icd,
> > +				    unsigned char buswidth)
> >  {
> >  	struct soc_camera_host *ici =
> >  		to_soc_camera_host(icd->dev.parent);
> >  	struct pxa_camera_dev *pcdev = ici->priv;
> >  	unsigned long bus_flags, camera_flags;
> > -	int ret = test_platform_param(pcdev, icd->buswidth, &bus_flags);
> > +	int ret = test_platform_param(pcdev, buswidth, &bus_flags);
> Why do we bother testing it ? If format negociation was done before, a format
> asked for is necessarily available, otherwise it should have been removed at
> format generation.
> 
> Likewise, is bus param matching necessary here, or should it be done at format
> generation ? Can that be really be dynamic, or is it constrained by hardware,
> and thus only necessary at startup, and not at each format try ?

Hm, ok, so far I don't have any cases, where bus parameters can change at 
run-time. So, yes, I think, we could shift it into 
pxa_camera_get_formats().

> <snip>
> > +static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
> > +				  const struct soc_camera_data_format **fmt)
> > +{
> > +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> > +	struct pxa_camera_dev *pcdev = ici->priv;
> > +	int formats = 0;
> > +
> > +	switch (icd->formats[idx].fourcc) {
> > +	case V4L2_PIX_FMT_UYVY:
> > +		formats++;
> > +		if (fmt && (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)) {
> > +			*fmt++ = &pxa_camera_formats[0];
> > +			dev_dbg(&ici->dev, "Providing format %s using %s\n",
> > +				pxa_camera_formats[0].name,
> > +				icd->formats[idx].name);
> > +		}
> > +	case V4L2_PIX_FMT_VYUY:
> > +	case V4L2_PIX_FMT_YUYV:
> > +	case V4L2_PIX_FMT_YVYU:
> > +	case V4L2_PIX_FMT_RGB565:
> > +	case V4L2_PIX_FMT_RGB555:
> > +		formats++;
> > +		if (fmt && (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)) {
> > +			*fmt++ = &icd->formats[idx];
> > +			dev_dbg(&ici->dev, "Providing format %s packed\n",
> > +				icd->formats[idx].name);
> > +		}
> > +		break;
> What if pcdev->platform_flags is 9 bits wide and sensor provides RGB565 ?
> Variable formats will be incremented, but fmt will never be filled in. So there
> will be holes in fmt. Shouldn't the formats++ depend on platform_flags &
> PXA_CAMERA_DATAWIDTH_8 ?

Right, that's a bug, will fix, thanks. Same as above for 
V4L2_PIX_FMT_UYVY.

> > +	default:
> > +		/* Generic pass-through */
> > +		if (depth_supported(icd, icd->formats[idx].depth)) {
> > +			formats++;
> > +			if (fmt) {
> > +				*fmt++ = &icd->formats[idx];
> > +				dev_dbg(&ici->dev,
> > +					"Providing format %s in pass-through mode\n",
> > +					icd->formats[idx].name);
> > +			}
> > +		}
> > +	}
> Dito for formats++.

No, this looks correct - it first checks for depth_supported().

> >  static int pxa_camera_set_fmt(struct soc_camera_device *icd,
> >  			      __u32 pixfmt, struct v4l2_rect *rect)
> <snip>
> > +	case V4L2_PIX_FMT_UYVY:
> > +	case V4L2_PIX_FMT_VYUY:
> > +	case V4L2_PIX_FMT_YUYV:
> > +	case V4L2_PIX_FMT_YVYU:
> > +	case V4L2_PIX_FMT_RGB565:
> > +	case V4L2_PIX_FMT_RGB555:
> > +		if (!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)) {
> > +			dev_warn(&ici->dev,
> > +				 "8 bit bus unsupported, but required for format %x\n",
> > +				 pixfmt);
> > +			return -EINVAL;
> Shouldn't that be already computed by format generation ?
> 
> > +		/* Generic pass-through */
> > +		host_fmt = soc_camera_format_by_fourcc(icd, pixfmt);
> > +		if (!host_fmt || !depth_supported(icd, host_fmt->depth)) {
> > +			dev_warn(&ici->dev,
> > +				 "Format %x unsupported in pass-through mode\n",
> > +				 pixfmt);
> > +			return -EINVAL;
> > +		}
> Ditto.

I know this code repeats, and it is not nice. But as I was writing it I 
didn't see another possibility. Or more precisely, I did see it, but I 
couldn't compare the two versions well without having at least one of them 
in code in front of my eyes:-) Now that I see it, I think, yes, there is a 
way to do this only once by using a translation struct similar to what you 
have proposed. Now _this_ would be a possibly important advantage, so it 
is useful not _only_ for debugging:-) But we would have to extend it with 
at least a buswidth. Like

	const struct soc_camera_data_format *cam_fmt;
	const struct soc_camera_data_format *host_fmt;
	unsigned char buswidth;

Now this _seems_ to provide the complete information so far... In 
pxa_camera_get_formats() we would

1. compute camera- and host-formats and buswidth
2. call pxa_camera_try_bus_param() to check bus-parameter compatibility

and then in try_fmt() and set_fmt() just traverse the list of translation 
structs and adjust geometry?

> > @@ -930,34 +1049,70 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
> >  static int pxa_camera_try_fmt(struct soc_camera_device *icd,
> >  			      struct v4l2_format *f)
> >  {
> > +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> > +	struct pxa_camera_dev *pcdev = ici->priv;
> >  	const struct soc_camera_data_format *cam_fmt;
> > -	int ret = pxa_camera_try_bus_param(icd, f->fmt.pix.pixelformat);
> > +	struct v4l2_pix_format *pix = &f->fmt.pix;
> > +	__u32 pixfmt = pix->pixelformat;
> > +	unsigned char buswidth;
> > +	int ret;
> >  
> > -	if (ret < 0)
> > -		return ret;
> > +	switch (pixfmt) {
> > +	case V4L2_PIX_FMT_YUV422P:
> > +		pixfmt = V4L2_PIX_FMT_UYVY;
> > +	case V4L2_PIX_FMT_UYVY:
> > +	case V4L2_PIX_FMT_VYUY:
> > +	case V4L2_PIX_FMT_YUYV:
> > +	case V4L2_PIX_FMT_YVYU:
> > +	case V4L2_PIX_FMT_RGB565:
> > +	case V4L2_PIX_FMT_RGB555:
> > +		if (!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)) {
> > +			dev_warn(&ici->dev,
> > +				 "try-fmt: 8 bit bus unsupported for format %x\n",
> > +				 pixfmt);
> > +			return -EINVAL;
> > +		}
> Ditto.
> 
> >  
> > -	/*
> > -	 * TODO: find a suitable supported by the SoC output format, check
> > -	 * whether the sensor supports one of acceptable input formats.
> > -	 */
> > -	cam_fmt = soc_camera_format_by_fourcc(icd, f->fmt.pix.pixelformat);
> > -	if (!cam_fmt)
> > -		return -EINVAL;
> > +		cam_fmt = soc_camera_format_by_fourcc(icd, pixfmt);
> > +		if (!cam_fmt) {
> > +			dev_warn(&ici->dev, "try-fmt: format %x not found\n",
> > +				 pixfmt);
> > +			return -EINVAL;
> > +		}
> > +		buswidth = 8;
> > +		break;
> > +	default:
> > +		/* Generic pass-through */
> > +		cam_fmt = soc_camera_format_by_fourcc(icd, pixfmt);
> > +		if (!cam_fmt || !depth_supported(icd, cam_fmt->depth)) {
> > +			dev_warn(&ici->dev,
> > +				 "try-fmt: Format %x unsupported in pass-through\n",
> > +				 pixfmt);
> > +			return -EINVAL;
> > +		}
> > +		buswidth = cam_fmt->depth;
> > +	}
> > +
> > +	ret = pxa_camera_try_bus_param(icd, buswidth);
> Ditto.
> 
> All in all, I wonder why we need that many tests, and if we could reduce them at
> format generation (under hypothesis that platform_flags are constant and sensor
> flags are constant).

Ok, I propose you make the next round:-) I would be pleased if you base 
your new patches on these my two, and just replace the user_formats with a 
translation list, and modify pxa try_fmt() and set_fmt() as discussed 
above. I would be quite happy if you mark them "From: <you>". Or if you do 
not want to - let me know, I'll do it. And please do not make 13 patches 
this time:-) I think, two should be enough.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
