Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3367 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab0HDSfX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Aug 2010 14:35:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC/PATCH v3 5/7] v4l: subdev: Uninline the v4l2_subdev_init function
Date: Wed, 4 Aug 2010 20:35:00 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1278948352-17892-1-git-send-email-laurent.pinchart@ideasonboard.com> <1278948352-17892-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1278948352-17892-6-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201008042035.00612.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 12 July 2010 17:25:50 Laurent Pinchart wrote:
> The function isn't small or performance sensitive enough to be inlined.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

> ---
>  drivers/media/video/v4l2-subdev.c |   14 ++++++++++++++
>  include/media/v4l2-subdev.h       |   15 ++-------------
>  2 files changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
> index 424c9c2..052dc9c 100644
> --- a/drivers/media/video/v4l2-subdev.c
> +++ b/drivers/media/video/v4l2-subdev.c
> @@ -63,3 +63,17 @@ const struct v4l2_file_operations v4l2_subdev_fops = {
>  	.unlocked_ioctl = subdev_ioctl,
>  	.release = subdev_close,
>  };
> +
> +void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
> +{
> +	INIT_LIST_HEAD(&sd->list);
> +	BUG_ON(!ops);
> +	sd->ops = ops;
> +	sd->v4l2_dev = NULL;
> +	sd->flags = 0;
> +	sd->name[0] = '\0';
> +	sd->grp_id = 0;
> +	sd->priv = NULL;
> +	sd->initialized = 1;
> +}
> +EXPORT_SYMBOL(v4l2_subdev_init);
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index dc0ccd3..9ee45c8 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -444,19 +444,8 @@ static inline void *v4l2_get_subdevdata(const struct v4l2_subdev *sd)
>  	return sd->priv;
>  }
>  
> -static inline void v4l2_subdev_init(struct v4l2_subdev *sd,
> -					const struct v4l2_subdev_ops *ops)
> -{
> -	INIT_LIST_HEAD(&sd->list);
> -	BUG_ON(!ops);
> -	sd->ops = ops;
> -	sd->v4l2_dev = NULL;
> -	sd->flags = 0;
> -	sd->name[0] = '\0';
> -	sd->grp_id = 0;
> -	sd->priv = NULL;
> -	sd->initialized = 1;
> -}
> +void v4l2_subdev_init(struct v4l2_subdev *sd,
> +		      const struct v4l2_subdev_ops *ops);
>  
>  /* Call an ops of a v4l2_subdev, doing the right checks against
>     NULL pointers.
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
