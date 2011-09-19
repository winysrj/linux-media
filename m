Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54191 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab1ISICA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Sep 2011 04:02:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: Re: [PATCH v2] v4l subdev: add dispatching for VIDIOC_DBG_G_REGISTER and VIDIOC_DBG_S_REGISTER.
Date: Mon, 19 Sep 2011 10:02:04 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <201109190053.08451.laurent.pinchart@ideasonboard.com> <1316412296-17465-1-git-send-email-martin@neutronstar.dyndns.org>
In-Reply-To: <1316412296-17465-1-git-send-email-martin@neutronstar.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109191002.04950.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

On Monday 19 September 2011 08:04:56 Martin Hostettler wrote:
> Ioctls on the subdevs node currently don't dispatch the register access
> debug driver callbacks. Add the dispatching with the same security checks
> are for non subdev video nodes (i.e. only capable(CAP_SYS_ADMIN may call
> the register access ioctls).
> 
> Sigend-off-by: Martin Hostettler <martin <at> neutronstar.dyndns.org>

I assume you mean Signed-off-by :-)

git commit -s avoid such mistakes.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/video/v4l2-subdev.c |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-subdev.c
> b/drivers/media/video/v4l2-subdev.c index b7967c9..179e20e 100644
> --- a/drivers/media/video/v4l2-subdev.c
> +++ b/drivers/media/video/v4l2-subdev.c
> @@ -173,6 +173,25 @@ static long subdev_do_ioctl(struct file *file,
> unsigned int cmd, void *arg)
> 
>  	case VIDIOC_UNSUBSCRIBE_EVENT:
>  		return v4l2_subdev_call(sd, core, unsubscribe_event, vfh, arg);
> +
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +	case VIDIOC_DBG_G_REGISTER:
> +	{
> +		struct v4l2_dbg_register *p = arg;
> +
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EPERM;
> +		return v4l2_subdev_call(sd, core, g_register, p);
> +	}
> +	case VIDIOC_DBG_S_REGISTER:
> +	{
> +		struct v4l2_dbg_register *p = arg;
> +
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EPERM;
> +		return v4l2_subdev_call(sd, core, s_register, p);
> +	}
> +#endif
>  #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
>  	case VIDIOC_SUBDEV_G_FMT: {
>  		struct v4l2_subdev_format *format = arg;

-- 
Regards,

Laurent Pinchart
