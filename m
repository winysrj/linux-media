Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35898 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbcGFK4s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 06:56:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 3/9] omap_vout: convert g/s_crop to g/s_selection.
Date: Wed, 06 Jul 2016 13:56:44 +0300
Message-ID: <1954235.TnArPKMBKU@avalon>
In-Reply-To: <1467621142-8064-4-git-send-email-hverkuil@xs4all.nl>
References: <1467621142-8064-1-git-send-email-hverkuil@xs4all.nl> <1467621142-8064-4-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Monday 04 Jul 2016 10:32:16 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This is part of a final push to convert all drivers to g/s_selection.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/platform/omap/omap_vout.c | 54 +++++++++++++++---------------
>  1 file changed, 28 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/media/platform/omap/omap_vout.c
> b/drivers/media/platform/omap/omap_vout.c index 70c28d1..2702b17 100644
> --- a/drivers/media/platform/omap/omap_vout.c
> +++ b/drivers/media/platform/omap/omap_vout.c
> @@ -1247,36 +1247,34 @@ static int vidioc_g_fmt_vid_overlay(struct file
> *file, void *fh, return 0;
>  }
> 
> -static int vidioc_cropcap(struct file *file, void *fh,
> -		struct v4l2_cropcap *cropcap)
> +static int vidioc_g_selection(struct file *file, void *fh, struct
> v4l2_selection *sel) {
>  	struct omap_vout_device *vout = fh;
>  	struct v4l2_pix_format *pix = &vout->pix;
> 
> -	if (cropcap->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +	if (sel->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
>  		return -EINVAL;
> 
> -	/* Width and height are always even */
> -	cropcap->bounds.width = pix->width & ~1;
> -	cropcap->bounds.height = pix->height & ~1;
> -
> -	omap_vout_default_crop(&vout->pix, &vout->fbuf, &cropcap->defrect);
> -	cropcap->pixelaspect.numerator = 1;
> -	cropcap->pixelaspect.denominator = 1;
> -	return 0;
> -}
> -
> -static int vidioc_g_crop(struct file *file, void *fh, struct v4l2_crop
> *crop)
> -{
> -	struct omap_vout_device *vout = fh;
> -
> -	if (crop->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +	switch (sel->target) {
> +	case V4L2_SEL_TGT_CROP:
> +		sel->r = vout->crop;
> +		break;
> +	case V4L2_SEL_TGT_CROP_DEFAULT:
> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> +		/* Width and height are always even */
> +		sel->r.width = pix->width & ~1;
> +		sel->r.height = pix->height & ~1;
> +
> +		if (sel->target == V4L2_SEL_TGT_CROP_DEFAULT)
> +			omap_vout_default_crop(&vout->pix, &vout->fbuf, &sel-
>r);

The omap_vout_default_crop() overwrites sel->r.width and sel->r.height, how 
about the gollowing code instead ?

	case V4L2_SEL_TGT_CROP_DEFAULT:
		omap_vout_default_crop(&vout->pix, &vout->fbuf, &sel-r);
		break;

	case V4L2_SEL_TGT_CROP_BOUNDS:
		/* Width and height are always even */
		sel->r.width = pix->width & ~1;
		sel->r.height = pix->height & ~1;
		break;

Apart from that the patch looks good to me.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> +		break;
> +	default:
>  		return -EINVAL;
> -	crop->c = vout->crop;
> +	}
>  	return 0;
>  }
> 
> -static int vidioc_s_crop(struct file *file, void *fh, const struct
> v4l2_crop *crop) +static int vidioc_s_selection(struct file *file, void
> *fh, struct v4l2_selection *sel) {
>  	int ret = -EINVAL;
>  	struct omap_vout_device *vout = fh;
> @@ -1285,6 +1283,12 @@ static int vidioc_s_crop(struct file *file, void *fh,
> const struct v4l2_crop *cr struct omap_video_timings *timing;
>  	struct omap_dss_device *dssdev;
> 
> +	if (sel->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +		return -EINVAL;
> +
> +	if (sel->target != V4L2_SEL_TGT_CROP)
> +		return -EINVAL;
> +
>  	if (vout->streaming)
>  		return -EBUSY;
> 
> @@ -1309,9 +1313,8 @@ static int vidioc_s_crop(struct file *file, void *fh,
> const struct v4l2_crop *cr vout->fbuf.fmt.width = timing->x_res;
>  	}
> 
> -	if (crop->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> -		ret = omap_vout_new_crop(&vout->pix, &vout->crop, &vout->win,
> -				&vout->fbuf, &crop->c);
> +	ret = omap_vout_new_crop(&vout->pix, &vout->crop, &vout->win,
> +				 &vout->fbuf, &sel->r);
> 
>  s_crop_err:
>  	mutex_unlock(&vout->lock);
> @@ -1839,9 +1842,8 @@ static const struct v4l2_ioctl_ops vout_ioctl_ops = {
>  	.vidioc_try_fmt_vid_out_overlay		= vidioc_try_fmt_vid_overlay,
>  	.vidioc_s_fmt_vid_out_overlay		= vidioc_s_fmt_vid_overlay,
>  	.vidioc_g_fmt_vid_out_overlay		= vidioc_g_fmt_vid_overlay,
> -	.vidioc_cropcap				= vidioc_cropcap,
> -	.vidioc_g_crop				= vidioc_g_crop,
> -	.vidioc_s_crop				= vidioc_s_crop,
> +	.vidioc_g_selection			= vidioc_g_selection,
> +	.vidioc_s_selection			= vidioc_s_selection,
>  	.vidioc_reqbufs				= vidioc_reqbufs,
>  	.vidioc_querybuf			= vidioc_querybuf,
>  	.vidioc_qbuf				= vidioc_qbuf,

-- 
Regards,

Laurent Pinchart

