Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3566 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab0GZPmT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 11:42:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: V4L2: avoid name conflicts in macros
Date: Mon, 26 Jul 2010 17:42:06 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <Pine.LNX.4.64.1007261738380.9816@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1007261738380.9816@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007261742.06850.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 26 July 2010 17:39:15 Guennadi Liakhovetski wrote:
> "sd" and "err" are too common names to be used in macros for local variables.
> Prefix them with an underscore to avoid name clashing.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Good point.

Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

Regards,

	Hans

> ---
>  include/media/v4l2-device.h |   22 +++++++++++-----------
>  1 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
> index 5d5d550..aaa9f00 100644
> --- a/include/media/v4l2-device.h
> +++ b/include/media/v4l2-device.h
> @@ -99,11 +99,11 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd);
>     while walking the subdevs list. */
>  #define __v4l2_device_call_subdevs(v4l2_dev, cond, o, f, args...) 	\
>  	do { 								\
> -		struct v4l2_subdev *sd; 				\
> +		struct v4l2_subdev *__sd; 				\
>  									\
> -		list_for_each_entry(sd, &(v4l2_dev)->subdevs, list)   	\
> -			if ((cond) && sd->ops->o && sd->ops->o->f) 	\
> -				sd->ops->o->f(sd , ##args); 		\
> +		list_for_each_entry(__sd, &(v4l2_dev)->subdevs, list)   \
> +			if ((cond) && __sd->ops->o && __sd->ops->o->f) 	\
> +				__sd->ops->o->f(__sd , ##args); 	\
>  	} while (0)
>  
>  /* Call the specified callback for all subdevs matching the condition.
> @@ -112,16 +112,16 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd);
>     subdev while walking the subdevs list. */
>  #define __v4l2_device_call_subdevs_until_err(v4l2_dev, cond, o, f, args...) \
>  ({ 									\
> -	struct v4l2_subdev *sd; 					\
> -	long err = 0; 							\
> +	struct v4l2_subdev *__sd; 					\
> +	long __err = 0;							\
>  									\
> -	list_for_each_entry(sd, &(v4l2_dev)->subdevs, list) { 		\
> -		if ((cond) && sd->ops->o && sd->ops->o->f) 		\
> -			err = sd->ops->o->f(sd , ##args); 		\
> -		if (err && err != -ENOIOCTLCMD)				\
> +	list_for_each_entry(__sd, &(v4l2_dev)->subdevs, list) { 	\
> +		if ((cond) && __sd->ops->o && __sd->ops->o->f) 		\
> +			__err = __sd->ops->o->f(__sd , ##args); 	\
> +		if (__err && __err != -ENOIOCTLCMD)			\
>  			break; 						\
>  	} 								\
> -	(err == -ENOIOCTLCMD) ? 0 : err; 				\
> +	(__err == -ENOIOCTLCMD) ? 0 : __err; 				\
>  })
>  
>  /* Call the specified callback for all subdevs matching grp_id (if 0, then
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
