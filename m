Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60647 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbaLBMnp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Dec 2014 07:43:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH 1/2] v4l2 subdevs: replace get/set_crop by get/set_selection
Date: Tue, 02 Dec 2014 14:44:19 +0200
Message-ID: <1428296.tTGq2DZjd2@avalon>
In-Reply-To: <1417522901-43604-1-git-send-email-hverkuil@xs4all.nl>
References: <1417522901-43604-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Tuesday 02 December 2014 13:21:40 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The crop and selection pad ops are duplicates. Replace all uses of
> get/set_crop by get/set_selection. This will make it possible to drop
> get/set_crop altogether.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/i2c/mt9m032.c                     | 40 +++++++-------
>  drivers/media/i2c/mt9p031.c                     | 40 +++++++-------
>  drivers/media/i2c/mt9t001.c                     | 41 ++++++++-------
>  drivers/media/i2c/mt9v032.c                     | 43 ++++++++-------
>  drivers/media/i2c/s5k6aa.c                      | 44 +++++++++-------
>  drivers/staging/media/davinci_vpfe/dm365_isif.c | 69 +++++++++++-----------
>  6 files changed, 153 insertions(+), 124 deletions(-)
> 
> diff --git a/drivers/media/i2c/mt9m032.c b/drivers/media/i2c/mt9m032.c
> index 45b3fca..7b81eab 100644
> --- a/drivers/media/i2c/mt9m032.c
> +++ b/drivers/media/i2c/mt9m032.c
> @@ -422,22 +422,24 @@ done:
>  	return ret;
>  }
> 
> -static int mt9m032_get_pad_crop(struct v4l2_subdev *subdev,
> -				struct v4l2_subdev_fh *fh,
> -				struct v4l2_subdev_crop *crop)
> +static int mt9m032_get_pad_selection(struct v4l2_subdev *subdev,
> +				     struct v4l2_subdev_fh *fh,
> +				     struct v4l2_subdev_selection *sel)
>  {
>  	struct mt9m032 *sensor = to_mt9m032(subdev);
> 
> +	if (sel->pad || sel->target != V4L2_SEL_TGT_CROP)
> +		return -EINVAL;

Nitpicking, could you please add a blank line here ? Same for similar 
locations below in the Aptina sensors drivers.

>  	mutex_lock(&sensor->lock);
> -	crop->rect = *__mt9m032_get_pad_crop(sensor, fh, crop->which);
> +	sel->r = *__mt9m032_get_pad_crop(sensor, fh, sel->which);
>  	mutex_unlock(&sensor->lock);
> 
>  	return 0;
>  }

[snip]

> diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> index edb76bd..b613456 100644
> --- a/drivers/media/i2c/mt9p031.c
> +++ b/drivers/media/i2c/mt9p031.c
> @@ -581,37 +581,41 @@ static int mt9p031_set_format(struct v4l2_subdev
> *subdev, return 0;
>  }
> 
> -static int mt9p031_get_crop(struct v4l2_subdev *subdev,
> -			    struct v4l2_subdev_fh *fh,
> -			    struct v4l2_subdev_crop *crop)
> +static int mt9p031_get_selection(struct v4l2_subdev *subdev,
> +				 struct v4l2_subdev_fh *fh,
> +				 struct v4l2_subdev_selection *sel)
>  {
>  	struct mt9p031 *mt9p031 = to_mt9p031(subdev);
> 
> -	crop->rect = *__mt9p031_get_pad_crop(mt9p031, fh, crop->pad,
> -					     crop->which);
> +	if (sel->pad || sel->target != V4L2_SEL_TGT_CROP)
> +		return -EINVAL;
> +	sel->r = *__mt9p031_get_pad_crop(mt9p031, fh, sel->pad,
> +					     sel->which);

And a bit more nitpicking, could you please keep the sel->which alignment with 
mt9p031 ?

>  	return 0;
>  }

[snip]

> diff --git a/drivers/media/i2c/mt9t001.c b/drivers/media/i2c/mt9t001.c
> index d9e9889..2a907a9 100644
> --- a/drivers/media/i2c/mt9t001.c
> +++ b/drivers/media/i2c/mt9t001.c
> @@ -401,39 +401,44 @@ static int mt9t001_set_format(struct v4l2_subdev
> *subdev, return 0;
>  }
> 
> -static int mt9t001_get_crop(struct v4l2_subdev *subdev,
> -			    struct v4l2_subdev_fh *fh,
> -			    struct v4l2_subdev_crop *crop)
> +static int mt9t001_get_selection(struct v4l2_subdev *subdev,
> +				 struct v4l2_subdev_fh *fh,
> +				 struct v4l2_subdev_selection *sel)
>  {
>  	struct mt9t001 *mt9t001 = to_mt9t001(subdev);
> 
> -	crop->rect = *__mt9t001_get_pad_crop(mt9t001, fh, crop->pad,
> -					     crop->which);
> +	if (sel->pad || sel->target != V4L2_SEL_TGT_CROP)
> +		return -EINVAL;
> +	sel->r = *__mt9t001_get_pad_crop(mt9t001, fh, sel->pad,
> +					     sel->which);

Ditto.

>  	return 0;
>  }

[snip]

> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> index 93687c1..0d56b4e 100644
> --- a/drivers/media/i2c/mt9v032.c
> +++ b/drivers/media/i2c/mt9v032.c
> @@ -552,39 +552,44 @@ static int mt9v032_set_format(struct v4l2_subdev
> *subdev, return 0;
>  }
> 
> -static int mt9v032_get_crop(struct v4l2_subdev *subdev,
> -			    struct v4l2_subdev_fh *fh,
> -			    struct v4l2_subdev_crop *crop)
> +static int mt9v032_get_selection(struct v4l2_subdev *subdev,
> +				 struct v4l2_subdev_fh *fh,
> +				 struct v4l2_subdev_selection *sel)
>  {
>  	struct mt9v032 *mt9v032 = to_mt9v032(subdev);
> 
> -	crop->rect = *__mt9v032_get_pad_crop(mt9v032, fh, crop->pad,
> -					     crop->which);
> +	if (sel->pad || sel->target != V4L2_SEL_TGT_CROP)
> +		return -EINVAL;
> +	sel->r = *__mt9v032_get_pad_crop(mt9v032, fh, sel->pad,
> +					     sel->which);

And here too.

>  	return 0;
>  }

[snip]

For the Aptina sensors drivers,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

