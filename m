Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3784 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab0GGMbf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jul 2010 08:31:35 -0400
Message-ID: <38f93094bade00b4f7a8038660164593.squirrel@webmail.xs4all.nl>
In-Reply-To: <1278503608-9126-4-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com>
    <1278503608-9126-4-git-send-email-laurent.pinchart@ideasonboard.com>
Date: Wed, 7 Jul 2010 14:31:32 +0200
Subject: Re: [RFC/PATCH 3/6] v4l: subdev: Uninline the v4l2_subdev_init
 function
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> The function isn't small or performance sensitive enough to be inlined.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

Looks good!

       Hans

> ---
>  drivers/media/video/v4l2-subdev.c |   14 ++++++++++++++
>  include/media/v4l2-subdev.h       |   15 ++-------------
>  2 files changed, 16 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/media/video/v4l2-subdev.c
> b/drivers/media/video/v4l2-subdev.c
> index a048161..a3672f0 100644
> --- a/drivers/media/video/v4l2-subdev.c
> +++ b/drivers/media/video/v4l2-subdev.c
> @@ -63,3 +63,17 @@ const struct v4l2_file_operations v4l2_subdev_fops = {
>  	.unlocked_ioctl = subdev_ioctl,
>  	.release = subdev_close,
>  };
> +
> +void v4l2_subdev_init(struct v4l2_subdev *sd, const struct
> v4l2_subdev_ops *ops)
> +{
> +	INIT_LIST_HEAD(&sd->list);
> +	BUG_ON(!ops);
> +	sd->ops = ops;
> +	sd->v4l2_dev = NULL;
> +	sd->flags = 0;
> +	sd->name[0] = '\0';
> +	sd->grp_id = 0;
> +	sd->priv = NULL;
> +	sd->initialized = 0;
> +}
> +EXPORT_SYMBOL(v4l2_subdev_init);
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 00010bd..7b6edcd 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -442,19 +442,8 @@ static inline void *v4l2_get_subdevdata(const struct
> v4l2_subdev *sd)
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
> -	sd->initialized = 0;
> -}
> +void v4l2_subdev_init(struct v4l2_subdev *sd,
> +		      const struct v4l2_subdev_ops *ops);
>
>  /* Call an ops of a v4l2_subdev, doing the right checks against
>     NULL pointers.
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

