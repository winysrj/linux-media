Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52598 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267Ab2EELjW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2012 07:39:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [media-ctl PATCH 1/3] Support selections API for crop
Date: Sat, 05 May 2012 13:39:15 +0200
Message-ID: <4626047.Gevrk9aWCk@avalon>
In-Reply-To: <1336119883-14978-1-git-send-email-sakari.ailus@iki.fi>
References: <1336119883-14978-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Friday 04 May 2012 11:24:41 Sakari Ailus wrote:
> Support the new selections API for crop. Fall back to use the old crop API
> in case the selection API isn't available.

Thanks for the patch. A few minor comments below. There's no need to resubmit, 
I've fixed the problems and applied the patch.

> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  src/main.c       |    4 ++-
>  src/v4l2subdev.c |  100 +++++++++++++++++++++++++++++++++++----------------
>  src/v4l2subdev.h |   37 +++++++++++---------
>  3 files changed, 93 insertions(+), 48 deletions(-)

[snip]

> diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
> index b886b72..92360bb 100644
> --- a/src/v4l2subdev.c
> +++ b/src/v4l2subdev.c
> @@ -104,48 +104,85 @@ int v4l2_subdev_set_format(struct media_entity
> *entity, return 0;
>  }
> 
> -int v4l2_subdev_get_crop(struct media_entity *entity, struct v4l2_rect
> *rect,
> -			 unsigned int pad, enum v4l2_subdev_format_whence which)
> +int v4l2_subdev_get_selection(
> +	struct media_entity *entity, struct v4l2_rect *r,
> +	unsigned int pad, int target, enum v4l2_subdev_format_whence which)

Let's make target an unsigned int.

>  {
> -	struct v4l2_subdev_crop crop;
> +	union {
> +		struct v4l2_subdev_selection sel;
> +		struct v4l2_subdev_crop crop;
> +	} u;
>  	int ret;
> 
>  	ret = v4l2_subdev_open(entity);
>  	if (ret < 0)
>  		return ret;
> 
> -	memset(&crop, 0, sizeof(crop));
> -	crop.pad = pad;
> -	crop.which = which;
> +	memset(&u.sel, 0, sizeof(u.sel));
> +	u.sel.pad = pad;
> +	u.sel.target = target;
> +	u.sel.which = which;
> 
> -	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_CROP, &crop);
> +	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_SELECTION, &u.sel);
> + 	if (ret >= 0) {
> +		*r = u.sel.r;
> +		return 0;
> +	}
> +	if (errno != ENOTTY
> +	    || target != V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL)

No need to split the line :-)

> + 		return -errno;
> +
> +	memset(&u.crop, 0, sizeof(u.crop));
> +	u.crop.pad = pad;
> +	u.crop.which = which;
> +
> +	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_CROP, &u.crop);
>  	if (ret < 0)
>  		return -errno;
> 
> -	*rect = crop.rect;
> +	*r = u.crop.rect;
>  	return 0;
>  }

[snip]

> @@ -355,30 +392,31 @@ static int set_format(struct media_pad *pad,
>  	return 0;
>  }
> 
> -static int set_crop(struct media_pad *pad, struct v4l2_rect *crop)
> +static int set_selection(struct media_pad *pad, int tgt,

unsigned int here as well.

> +			 struct v4l2_rect *rect)

[snip]

> @@ -429,18 +467,18 @@ static int v4l2_subdev_parse_setup_format(struct
> media_device *media, return -EINVAL;
>  	}
> 
> -	if (pad->flags & MEDIA_PAD_FL_SOURCE) {
> -		ret = set_crop(pad, &crop);
> +	if (pad->flags & MEDIA_PAD_FL_SINK) {
> +		ret = set_format(pad, &format);
>  		if (ret < 0)
>  			return ret;
>  	}
> 
> -	ret = set_format(pad, &format);
> +	ret = set_selection(pad, V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL, &crop);
>  	if (ret < 0)
>  		return ret;
> 
> -	if (pad->flags & MEDIA_PAD_FL_SINK) {
> -		ret = set_crop(pad, &crop);
> +	if (pad->flags & MEDIA_PAD_FL_SOURCE) {
> +		ret = set_format(pad, &format);
>  		if (ret < 0)
>  			return ret;
>  	}

I would just replace set_crop with set_selection here, and apply the rest of 
the change in patch 3/3.

> diff --git a/src/v4l2subdev.h b/src/v4l2subdev.h
> index 1e75f94..1020747 100644
> --- a/src/v4l2subdev.h
> +++ b/src/v4l2subdev.h
> @@ -88,34 +88,38 @@ int v4l2_subdev_set_format(struct media_entity *entity,
>  	enum v4l2_subdev_format_whence which);
> 
>  /**
> - * @brief Retrieve the crop rectangle on a pad.
> + * @brief Retrieve a selection rectangle on a pad.
>   * @param entity - subdev-device media entity.
> - * @param rect - crop rectangle to be filled.
> + * @param r - rectangle to be filled.
>   * @param pad - pad number.
> + * @param target - selection target
>   * @param which - identifier of the format to get.
>   *
> - * Retrieve the current crop rectangleon the @a entity @a pad and store it
> in
> - * the @a rect structure.
> + * Retrieve the @a target selection rectangle on the @a entity @a pad
> + * and store it in the @a rect structure.

'@a rect' doesn't match '@param r' (same for set_selection).

>   *
> - * @a which is set to V4L2_SUBDEV_FORMAT_TRY to retrieve the try crop
> rectangle
> - * stored in the file handle, of V4L2_SUBDEV_FORMAT_ACTIVE to retrieve the
> - * current active crop rectangle.
> + * @a which is set to V4L2_SUBDEV_FORMAT_TRY to retrieve the try
> + * selection rectangle stored in the file handle, of

s/of/or/ (the typo was already there, but let's fix it).

> + * V4L2_SUBDEV_FORMAT_ACTIVE to retrieve the current active selection
> + * rectangle.
>   *
>   * @return 0 on success, or a negative error code on failure.
>   */

-- 
Regards,

Laurent Pinchart

