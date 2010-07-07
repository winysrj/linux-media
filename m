Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1960 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab0GGMVx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jul 2010 08:21:53 -0400
Message-ID: <a46a4020c0260a7938bd15378945454f.squirrel@webmail.xs4all.nl>
In-Reply-To: <1278503608-9126-2-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com>
    <1278503608-9126-2-git-send-email-laurent.pinchart@ideasonboard.com>
Date: Wed, 7 Jul 2010 14:21:49 +0200
Subject: Re: [RFC/PATCH 1/6] v4l: subdev: Don't require core operations
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> There's no reason to require subdevices to implement the core
> operations. Remove the check for non-NULL core operations when
> initializing the subdev.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

Yeah, that test was a bit overkill.

Regards,

         Hans

> ---
>  include/media/v4l2-subdev.h |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 02c6f4d..6088316 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -437,8 +437,7 @@ static inline void v4l2_subdev_init(struct v4l2_subdev
> *sd,
>  					const struct v4l2_subdev_ops *ops)
>  {
>  	INIT_LIST_HEAD(&sd->list);
> -	/* ops->core MUST be set */
> -	BUG_ON(!ops || !ops->core);
> +	BUG_ON(!ops);
>  	sd->ops = ops;
>  	sd->v4l2_dev = NULL;
>  	sd->flags = 0;
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

