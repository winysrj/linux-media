Return-path: <mchehab@gaivota>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2080 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab0LVPBw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 10:01:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 02/13] v4l: Add multi-planar ioctl handling code
Date: Wed, 22 Dec 2010 16:01:37 +0100
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	andrzej.p@samsung.com
References: <1293025239-9977-1-git-send-email-m.szyprowski@samsung.com> <1293025239-9977-3-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1293025239-9977-3-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012221601.37554.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Darn, I'd hoped I could ack the whole lot, but there are a few small
problems with error checking here:

On Wednesday, December 22, 2010 14:40:32 Marek Szyprowski wrote:
> From: Pawel Osciak <p.osciak@samsung.com>
> 
> Add multi-planar API core ioctl handling and conversion functions.
> 
> Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/media/video/v4l2-ioctl.c |  418 ++++++++++++++++++++++++++++++++++----
>  include/media/v4l2-ioctl.h       |   16 ++
>  2 files changed, 390 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index 8516669..5d46aa2 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c

<snip>

>  static long __video_do_ioctl(struct file *file,
>  		unsigned int cmd, void *arg)
>  {
>  	struct video_device *vfd = video_devdata(file);
>  	const struct v4l2_ioctl_ops *ops = vfd->ioctl_ops;
>  	void *fh = file->private_data;
> +	struct v4l2_format f_copy;
>  	long ret = -EINVAL;
>  
>  	if (ops == NULL) {
> @@ -721,6 +823,11 @@ static long __video_do_ioctl(struct file *file,
>  			if (ops->vidioc_enum_fmt_vid_cap)
>  				ret = ops->vidioc_enum_fmt_vid_cap(file, fh, f);
>  			break;
> +		case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +			if (ops->vidioc_enum_fmt_vid_cap_mplane)
> +				ret = ops->vidioc_enum_fmt_vid_cap_mplane(file,
> +									fh, f);
> +			break;
>  		case V4L2_BUF_TYPE_VIDEO_OVERLAY:
>  			if (ops->vidioc_enum_fmt_vid_overlay)
>  				ret = ops->vidioc_enum_fmt_vid_overlay(file,
> @@ -730,6 +837,11 @@ static long __video_do_ioctl(struct file *file,
>  			if (ops->vidioc_enum_fmt_vid_out)
>  				ret = ops->vidioc_enum_fmt_vid_out(file, fh, f);
>  			break;
> +		case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +			if (ops->vidioc_enum_fmt_vid_out_mplane)
> +				ret = ops->vidioc_enum_fmt_vid_out_mplane(file,
> +									fh, f);
> +			break;
>  		case V4L2_BUF_TYPE_PRIVATE:
>  			if (ops->vidioc_enum_fmt_type_private)
>  				ret = ops->vidioc_enum_fmt_type_private(file,
> @@ -758,22 +870,79 @@ static long __video_do_ioctl(struct file *file,
>  
>  		switch (f->type) {
>  		case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> -			if (ops->vidioc_g_fmt_vid_cap)
> +			if (ops->vidioc_g_fmt_vid_cap) {
>  				ret = ops->vidioc_g_fmt_vid_cap(file, fh, f);
> +			} else if (ops->vidioc_g_fmt_vid_cap_mplane) {
> +				if (fmt_sp_to_mp(f, &f_copy))
> +					break;
> +				ret = ops->vidioc_g_fmt_vid_cap_mplane(file, fh,
> +								       &f_copy);
> +				/* Driver is currently in multi-planar format,
> +				 * we can't return it in single-planar API*/
> +				if (!ret && f_copy.fmt.pix_mp.num_planes > 1) {
> +					ret = -EBUSY;
> +					break;
> +				}
> +
> +				ret = fmt_mp_to_sp(&f_copy, f);

Here and also in the cases below the ret value is overwritten by the sp to mp
(or vice versa) conversion function. I would suggest adding a 'if (ret == 0)' before
each conversion function.

I actually wonder whether these conversion functions can ever fail. Perhaps a
void return value and perhaps a WARN_ON for invalid types would be sufficient.
Any failures here are really driver errors and not application errors.

> +			}
>  			if (!ret)
>  				v4l_print_pix_fmt(vfd, &f->fmt.pix);
>  			break;
> +		case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +			if (ops->vidioc_g_fmt_vid_cap_mplane) {
> +				ret = ops->vidioc_g_fmt_vid_cap_mplane(file,
> +									fh, f);
> +			} else if (ops->vidioc_g_fmt_vid_cap) {
> +				if (fmt_mp_to_sp(f, &f_copy))
> +					break;
> +				ret = ops->vidioc_g_fmt_vid_cap(file,
> +								fh, &f_copy);
> +				ret = fmt_sp_to_mp(&f_copy, f);

Ditto.

> +			}
> +			if (!ret)
> +				v4l_print_pix_fmt_mplane(vfd, &f->fmt.pix_mp);
> +			break;
>  		case V4L2_BUF_TYPE_VIDEO_OVERLAY:
>  			if (ops->vidioc_g_fmt_vid_overlay)
>  				ret = ops->vidioc_g_fmt_vid_overlay(file,
>  								    fh, f);
>  			break;
>  		case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> -			if (ops->vidioc_g_fmt_vid_out)
> +			if (ops->vidioc_g_fmt_vid_out) {
>  				ret = ops->vidioc_g_fmt_vid_out(file, fh, f);
> +			} else if (ops->vidioc_g_fmt_vid_out_mplane) {
> +				if (fmt_sp_to_mp(f, &f_copy))
> +					break;
> +				ret = ops->vidioc_g_fmt_vid_out_mplane(file, fh,
> +									&f_copy);
> +				/* Driver is currently in multi-planar format,
> +				 * we can't return it in single-planar API*/
> +				if (!ret && f_copy.fmt.pix_mp.num_planes > 1) {
> +					ret = -EBUSY;
> +					break;
> +				}
> +
> +				ret = fmt_mp_to_sp(&f_copy, f);

Ditto. And in more places in this code as well.

<snip>

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
