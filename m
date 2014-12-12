Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53602 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S967664AbaLLNWE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 08:22:04 -0500
Date: Fri, 12 Dec 2014 15:22:00 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, prabhakar.csengg@gmail.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 8/8] v4l2-subdev: remove g/s_crop and cropcap from
 video ops
Message-ID: <20141212132200.GW15559@valkosipuli.retiisi.org.uk>
References: <1417686899-30149-1-git-send-email-hverkuil@xs4all.nl>
 <1417686899-30149-9-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417686899-30149-9-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

A few comments below.

On Thu, Dec 04, 2014 at 10:54:59AM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/i2c/ak881x.c                         |  32 +++--
>  drivers/media/i2c/soc_camera/imx074.c              |  46 ++++----
>  drivers/media/i2c/soc_camera/mt9m001.c             |  74 +++++++-----
>  drivers/media/i2c/soc_camera/mt9m111.c             |  61 +++++-----
>  drivers/media/i2c/soc_camera/mt9t031.c             |  56 +++++----
>  drivers/media/i2c/soc_camera/mt9t112.c             |  64 +++++-----
>  drivers/media/i2c/soc_camera/mt9v022.c             |  72 +++++++-----
>  drivers/media/i2c/soc_camera/ov2640.c              |  45 ++++---
>  drivers/media/i2c/soc_camera/ov5642.c              |  57 +++++----
>  drivers/media/i2c/soc_camera/ov6650.c              |  78 +++++++------
>  drivers/media/i2c/soc_camera/ov772x.c              |  48 ++++----
>  drivers/media/i2c/soc_camera/ov9640.c              |  45 ++++---
>  drivers/media/i2c/soc_camera/ov9740.c              |  49 ++++----
>  drivers/media/i2c/soc_camera/rj54n1cb0c.c          |  56 +++++----
>  drivers/media/i2c/soc_camera/tw9910.c              |  51 +++-----
>  drivers/media/i2c/tvp5150.c                        |  85 +++++++-------
>  drivers/media/platform/omap3isp/ispvideo.c         |  88 +++++++++-----
>  drivers/media/platform/sh_vou.c                    |  13 ++-
>  drivers/media/platform/soc_camera/mx2_camera.c     |  18 ++-
>  drivers/media/platform/soc_camera/mx3_camera.c     |  18 ++-
>  drivers/media/platform/soc_camera/omap1_camera.c   |  23 ++--
>  drivers/media/platform/soc_camera/pxa_camera.c     |  17 ++-
>  drivers/media/platform/soc_camera/rcar_vin.c       |  26 ++---
>  .../platform/soc_camera/sh_mobile_ceu_camera.c     |  32 +++--
>  drivers/media/platform/soc_camera/soc_camera.c     | 130 ++++++---------------
>  .../platform/soc_camera/soc_camera_platform.c      |  49 ++++----
>  drivers/media/platform/soc_camera/soc_scale_crop.c |  85 ++++++++------
>  drivers/media/platform/soc_camera/soc_scale_crop.h |   6 +-
>  drivers/staging/media/omap4iss/iss_video.c         |  88 +++++++++-----
>  include/media/soc_camera.h                         |   7 +-
>  include/media/v4l2-subdev.h                        |   3 -
>  31 files changed, 805 insertions(+), 717 deletions(-)
> 
> diff --git a/drivers/media/i2c/ak881x.c b/drivers/media/i2c/ak881x.c
> index 69aeaf3..29d3b2a 100644
> --- a/drivers/media/i2c/ak881x.c
> +++ b/drivers/media/i2c/ak881x.c
> @@ -128,21 +128,27 @@ static int ak881x_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned int index,
>  	return 0;
>  }
>  
> -static int ak881x_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
> +static int ak881x_get_selection(struct v4l2_subdev *sd,
> +				struct v4l2_subdev_pad_config *cfg,
> +				struct v4l2_subdev_selection *sel)
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct ak881x *ak881x = to_ak881x(client);
>  
> -	a->bounds.left			= 0;
> -	a->bounds.top			= 0;
> -	a->bounds.width			= 720;
> -	a->bounds.height		= ak881x->lines;
> -	a->defrect			= a->bounds;
> -	a->type				= V4L2_BUF_TYPE_VIDEO_OUTPUT;
> -	a->pixelaspect.numerator	= 1;
> -	a->pixelaspect.denominator	= 1;
> +	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
> +		return -EINVAL;
>  
> -	return 0;
> +	switch (sel->target) {
> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> +	case V4L2_SEL_TGT_CROP_DEFAULT:

The default targets are currently documented not to be applicable to the
V4L2 sub-device interface. I have to say I don't remember why that was the
conclusion, but could have as well been that there was no need for them at
the time.

Still the documentation
(Documentation/DocBook/media/v4l/selections-common.xml) should be changed to
reflect this.

> +		sel->r.left = 0;
> +		sel->r.top = 0;
> +		sel->r.width = 720;
> +		sel->r.height = ak881x->lines;
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	}
>  }
>  
...

> diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
> index cdee596..65dd272 100644
> --- a/drivers/staging/media/omap4iss/iss_video.c
> +++ b/drivers/staging/media/omap4iss/iss_video.c
> @@ -643,40 +643,45 @@ iss_video_try_format(struct file *file, void *fh, struct v4l2_format *format)
>  }
>  
>  static int
> -iss_video_cropcap(struct file *file, void *fh, struct v4l2_cropcap *cropcap)
> -{
> -	struct iss_video *video = video_drvdata(file);
> -	struct v4l2_subdev *subdev;
> -	int ret;
> -
> -	subdev = iss_video_remote_subdev(video, NULL);
> -	if (subdev == NULL)
> -		return -EINVAL;
> -
> -	mutex_lock(&video->mutex);
> -	ret = v4l2_subdev_call(subdev, video, cropcap, cropcap);
> -	mutex_unlock(&video->mutex);
> -
> -	return ret == -ENOIOCTLCMD ? -ENOTTY : ret;
> -}
> -
> -static int
> -iss_video_get_crop(struct file *file, void *fh, struct v4l2_crop *crop)
> +iss_video_get_selection(struct file *file, void *fh, struct v4l2_selection *sel)
>  {
>  	struct iss_video *video = video_drvdata(file);
>  	struct v4l2_subdev_format format;
>  	struct v4l2_subdev *subdev;
> +	struct v4l2_subdev_selection sdsel = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +		.target = sel->target,
> +	};
>  	u32 pad;
>  	int ret;
>  
> +	switch (sel->target) {
> +	case V4L2_SEL_TGT_CROP:
> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> +	case V4L2_SEL_TGT_CROP_DEFAULT:
> +		if (video->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +			return -EINVAL;
> +		break;
> +	case V4L2_SEL_TGT_COMPOSE:
> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> +		if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +			return -EINVAL;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
>  	subdev = iss_video_remote_subdev(video, &pad);
>  	if (subdev == NULL)
>  		return -EINVAL;
>  
> -	/* Try the get crop operation first and fallback to get format if not
> +	/* Try the get selection operation first and fallback to get format if not
>  	 * implemented.
>  	 */
> -	ret = v4l2_subdev_call(subdev, video, g_crop, crop);
> +	sdsel.pad = pad;
> +	ret = v4l2_subdev_call(subdev, pad, get_selection, NULL, &sdsel);
> +	if (!ret)
> +		sel->r = sdsel.r;
>  	if (ret != -ENOIOCTLCMD)
>  		return ret;
>  
> @@ -686,28 +691,50 @@ iss_video_get_crop(struct file *file, void *fh, struct v4l2_crop *crop)
>  	if (ret < 0)
>  		return ret == -ENOIOCTLCMD ? -ENOTTY : ret;
>  
> -	crop->c.left = 0;
> -	crop->c.top = 0;
> -	crop->c.width = format.format.width;
> -	crop->c.height = format.format.height;
> +	sel->r.left = 0;
> +	sel->r.top = 0;
> +	sel->r.width = format.format.width;
> +	sel->r.height = format.format.height;
>  
>  	return 0;
>  }
>  
>  static int
> -iss_video_set_crop(struct file *file, void *fh, const struct v4l2_crop *crop)
> +iss_video_set_selection(struct file *file, void *fh, struct v4l2_selection *sel)
>  {
>  	struct iss_video *video = video_drvdata(file);
>  	struct v4l2_subdev *subdev;
> +	struct v4l2_subdev_selection sdsel = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +		.target = sel->target,
> +		.flags = sel->flags,
> +		.r = sel->r,
> +	};
> +	u32 pad;
>  	int ret;
>  
> -	subdev = iss_video_remote_subdev(video, NULL);
> +	switch (sel->target) {
> +	case V4L2_SEL_TGT_CROP:
> +		if (video->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +			return -EINVAL;
> +		break;
> +	case V4L2_SEL_TGT_COMPOSE:
> +		if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +			return -EINVAL;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	subdev = iss_video_remote_subdev(video, &pad);
>  	if (subdev == NULL)
>  		return -EINVAL;
>  
> +	sdsel.pad = pad;
>  	mutex_lock(&video->mutex);
> -	ret = v4l2_subdev_call(subdev, video, s_crop, crop);
> +	ret = v4l2_subdev_call(subdev, pad, set_selection, NULL, &sdsel);

None of the omap4iss sub-devices support crop nor selection. I think this is
a leftover from a time when cropping was supported on some of the video node
of the omap3isp driver.

The compose target has never been supported on video nodes by either
drivers, so I suggest to remove the references to that from this patch.

I can submit a patch to remove support for crop on video nodes for both.

>  	mutex_unlock(&video->mutex);
> +	if (!ret)
> +		sel->r = sdsel.r;
>  
>  	return ret == -ENOIOCTLCMD ? -ENOTTY : ret;
>  }
> @@ -1013,9 +1040,8 @@ static const struct v4l2_ioctl_ops iss_video_ioctl_ops = {
>  	.vidioc_g_fmt_vid_out		= iss_video_get_format,
>  	.vidioc_s_fmt_vid_out		= iss_video_set_format,
>  	.vidioc_try_fmt_vid_out		= iss_video_try_format,
> -	.vidioc_cropcap			= iss_video_cropcap,
> -	.vidioc_g_crop			= iss_video_get_crop,
> -	.vidioc_s_crop			= iss_video_set_crop,
> +	.vidioc_g_selection		= iss_video_get_selection,
> +	.vidioc_s_selection		= iss_video_set_selection,
>  	.vidioc_g_parm			= iss_video_get_param,
>  	.vidioc_s_parm			= iss_video_set_param,
>  	.vidioc_reqbufs			= iss_video_reqbufs,

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
