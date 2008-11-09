Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA90lvqn005955
	for <video4linux-list@redhat.com>; Sat, 8 Nov 2008 19:47:57 -0500
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA90llLJ013278
	for <video4linux-list@redhat.com>; Sat, 8 Nov 2008 19:47:47 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <Pine.LNX.4.64.0811081917070.8956@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sun, 09 Nov 2008 01:47:46 +0100
In-Reply-To: <Pine.LNX.4.64.0811081917070.8956@axis700.grange> (Guennadi
	Liakhovetski's message of "Sat\,
	8 Nov 2008 19\:48\:05 +0100 \(CET\)")
Message-ID: <87tzahwwr1.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 3/3] soc-camera: let camera host drivers decide upon
	pixel format
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

> diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
> index 2a811f8..a375872 100644
> --- a/drivers/media/video/pxa_camera.c
> +++ b/drivers/media/video/pxa_camera.c
> @@ -907,17 +907,43 @@ static int pxa_camera_try_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
>  static int pxa_camera_set_fmt_cap(struct soc_camera_device *icd,
>  				  __u32 pixfmt, struct v4l2_rect *rect)
>  {
> -	return icd->ops->set_fmt_cap(icd, pixfmt, rect);
> +	const struct soc_camera_data_format *cam_fmt;
> +	int ret;
> +
> +	/*
> +	 * TODO: find a suitable supported by the SoC output format, check
> +	 * whether the sensor supports one of acceptable input formats.
> +	 */
> +	if (pixfmt) {
> +		cam_fmt = soc_camera_format_by_fourcc(icd, pixfmt);
> +		if (!cam_fmt)
> +			return -EINVAL;
> +	}
All right, here is something I don't understand.

Let's take an example : the pxa_camera was asked a YUV422P pixel format. It can
deserve it by asking the sensor a UYVY format. So the logical step would be to
do something like :

	if (pixfmt == V4L2_PIX_FMT_YUV422P)
		pixfmt = V4L2_PIX_FMT_UYVY;

at the beginning of pxa_camera_set_fmt_cap().

> +
> +	ret = icd->ops->set_fmt_cap(icd, pixfmt, rect);
> +	if (pixfmt && !ret)
> +		icd->current_fmt = cam_fmt;
So here, icd->current_fmt = V4L2_PIX_FMT_UYVY, and not V4L2_PIX_FMT_YUV422P;

> @@ -345,14 +325,21 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
>  	rect.width	= f->fmt.pix.width;
>  	rect.height	= f->fmt.pix.height;
>  	ret = ici->ops->set_fmt_cap(icd, f->fmt.pix.pixelformat, &rect);
> -	if (ret < 0)
> +	if (ret < 0) {
>  		return ret;
> +	} else if (!icd->current_fmt ||
> +		   icd->current_fmt->fourcc != f->fmt.pix.pixelformat) {
> +		dev_err(&ici->dev, "Host driver hasn't set up current "
> +			"format correctly!\n");
> +		return -EINVAL;
> +	}
And here, we fall into the error case, because icd->current_fmt is
V4L2_PIX_FMT_UYVY, and f->fmt.pix.pixelformat = V4L2_PIX_FMT_YUV422P.

So there is still something to improve, or have I missed something ?

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
