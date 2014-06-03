Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49610 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbaFCRPr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jun 2014 13:15:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] v4l: subdev: Unify argument validation across IOCTLs
Date: Tue, 03 Jun 2014 19:16:13 +0200
Message-ID: <1693642.21y0Pscz7q@avalon>
In-Reply-To: <1401787516-16545-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1401787516-16545-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Tuesday 03 June 2014 12:25:16 Sakari Ailus wrote:
> Separate validation of different argument types. There's no reason to do
> this separately for every IOCTL.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/v4l2-core/v4l2-subdev.c | 119 ++++++++++++++++++-------------
>  1 file changed, 73 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c
> b/drivers/media/v4l2-core/v4l2-subdev.c index 058c1a6..496f9bc 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -126,6 +126,55 @@ static int subdev_close(struct file *file)
>  	return 0;
>  }
> 
> +static int check_format(struct v4l2_subdev *sd,
> +			struct v4l2_subdev_format *format)
> +{
> +	if (format->which != V4L2_SUBDEV_FORMAT_TRY &&
> +	    format->which != V4L2_SUBDEV_FORMAT_ACTIVE)
> +		return -EINVAL;
> +
> +	if (format->pad >= sd->entity.num_pads)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int check_crop(struct v4l2_subdev *sd, struct v4l2_subdev_crop
> *crop) +{
> +	if (crop->which != V4L2_SUBDEV_FORMAT_TRY &&
> +	    crop->which != V4L2_SUBDEV_FORMAT_ACTIVE)
> +		return -EINVAL;
> +
> +	if (crop->pad >= sd->entity.num_pads)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int check_selection(struct v4l2_subdev *sd,
> +			   struct v4l2_subdev_selection *sel)
> +{
> +	if (sel->which != V4L2_SUBDEV_FORMAT_TRY &&
> +	    sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
> +		return -EINVAL;
> +
> +	if (sel->pad >= sd->entity.num_pads)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int check_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid
> *edid)
> +{
> +	if (edid->pad >= sd->entity.num_pads)
> +		return -EINVAL;
> +
> +	if (edid->blocks && edid->edid == NULL)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>  static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
> {
>  	struct video_device *vdev = video_devdata(file);
> @@ -202,26 +251,20 @@ static long subdev_do_ioctl(struct file *file,
> unsigned int cmd, void *arg) #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
>  	case VIDIOC_SUBDEV_G_FMT: {
>  		struct v4l2_subdev_format *format = arg;
> +		int rval = check_format(sd, format);

How about declaring the variable once only at the beginning of the function ?

Apart from that,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> 
> -		if (format->which != V4L2_SUBDEV_FORMAT_TRY &&
> -		    format->which != V4L2_SUBDEV_FORMAT_ACTIVE)
> -			return -EINVAL;
> -
> -		if (format->pad >= sd->entity.num_pads)
> -			return -EINVAL;
> +		if (rval)
> +			return rval;
> 
>  		return v4l2_subdev_call(sd, pad, get_fmt, subdev_fh, format);
>  	}
> 
>  	case VIDIOC_SUBDEV_S_FMT: {
>  		struct v4l2_subdev_format *format = arg;
> +		int rval = check_format(sd, format);
> 
> -		if (format->which != V4L2_SUBDEV_FORMAT_TRY &&
> -		    format->which != V4L2_SUBDEV_FORMAT_ACTIVE)
> -			return -EINVAL;
> -
> -		if (format->pad >= sd->entity.num_pads)
> -			return -EINVAL;
> +		if (rval)
> +			return rval;
> 
>  		return v4l2_subdev_call(sd, pad, set_fmt, subdev_fh, format);
>  	}
> @@ -229,14 +272,10 @@ static long subdev_do_ioctl(struct file *file,
> unsigned int cmd, void *arg) case VIDIOC_SUBDEV_G_CROP: {
>  		struct v4l2_subdev_crop *crop = arg;
>  		struct v4l2_subdev_selection sel;
> -		int rval;
> -
> -		if (crop->which != V4L2_SUBDEV_FORMAT_TRY &&
> -		    crop->which != V4L2_SUBDEV_FORMAT_ACTIVE)
> -			return -EINVAL;
> +		int rval = check_crop(sd, crop);
> 
> -		if (crop->pad >= sd->entity.num_pads)
> -			return -EINVAL;
> +		if (rval)
> +			return rval;
> 
>  		rval = v4l2_subdev_call(sd, pad, get_crop, subdev_fh, crop);
>  		if (rval != -ENOIOCTLCMD)
> @@ -258,14 +297,10 @@ static long subdev_do_ioctl(struct file *file,
> unsigned int cmd, void *arg) case VIDIOC_SUBDEV_S_CROP: {
>  		struct v4l2_subdev_crop *crop = arg;
>  		struct v4l2_subdev_selection sel;
> -		int rval;
> -
> -		if (crop->which != V4L2_SUBDEV_FORMAT_TRY &&
> -		    crop->which != V4L2_SUBDEV_FORMAT_ACTIVE)
> -			return -EINVAL;
> +		int rval = check_crop(sd, crop);
> 
> -		if (crop->pad >= sd->entity.num_pads)
> -			return -EINVAL;
> +		if (rval)
> +			return rval;
> 
>  		rval = v4l2_subdev_call(sd, pad, set_crop, subdev_fh, crop);
>  		if (rval != -ENOIOCTLCMD)
> @@ -335,13 +370,10 @@ static long subdev_do_ioctl(struct file *file,
> unsigned int cmd, void *arg)
> 
>  	case VIDIOC_SUBDEV_G_SELECTION: {
>  		struct v4l2_subdev_selection *sel = arg;
> +		int rval = check_selection(sd, sel);
> 
> -		if (sel->which != V4L2_SUBDEV_FORMAT_TRY &&
> -		    sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
> -			return -EINVAL;
> -
> -		if (sel->pad >= sd->entity.num_pads)
> -			return -EINVAL;
> +		if (rval)
> +			return rval;
> 
>  		return v4l2_subdev_call(
>  			sd, pad, get_selection, subdev_fh, sel);
> @@ -349,13 +381,10 @@ static long subdev_do_ioctl(struct file *file,
> unsigned int cmd, void *arg)
> 
>  	case VIDIOC_SUBDEV_S_SELECTION: {
>  		struct v4l2_subdev_selection *sel = arg;
> +		int rval = check_selection(sd, sel);
> 
> -		if (sel->which != V4L2_SUBDEV_FORMAT_TRY &&
> -		    sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
> -			return -EINVAL;
> -
> -		if (sel->pad >= sd->entity.num_pads)
> -			return -EINVAL;
> +		if (rval)
> +			return rval;
> 
>  		return v4l2_subdev_call(
>  			sd, pad, set_selection, subdev_fh, sel);
> @@ -363,22 +392,20 @@ static long subdev_do_ioctl(struct file *file,
> unsigned int cmd, void *arg)
> 
>  	case VIDIOC_G_EDID: {
>  		struct v4l2_subdev_edid *edid = arg;
> +		int rval = check_edid(sd, edid);
> 
> -		if (edid->pad >= sd->entity.num_pads)
> -			return -EINVAL;
> -		if (edid->blocks && edid->edid == NULL)
> -			return -EINVAL;
> +		if (rval)
> +			return rval;
> 
>  		return v4l2_subdev_call(sd, pad, get_edid, edid);
>  	}
> 
>  	case VIDIOC_S_EDID: {
>  		struct v4l2_subdev_edid *edid = arg;
> +		int rval = check_edid(sd, edid);
> 
> -		if (edid->pad >= sd->entity.num_pads)
> -			return -EINVAL;
> -		if (edid->blocks && edid->edid == NULL)
> -			return -EINVAL;
> +		if (rval)
> +			return rval;
> 
>  		return v4l2_subdev_call(sd, pad, set_edid, edid);
>  	}

-- 
Regards,

Laurent Pinchart

