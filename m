Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44201 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758430Ab2CUKnZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 06:43:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] uvcvideo: remove unneeded access_ok() check
Date: Wed, 21 Mar 2012 11:43:51 +0100
Message-ID: <3912096.1JJ7uXGCOH@avalon>
In-Reply-To: <20120321063523.GA20062@elgon.mountain>
References: <20120321063523.GA20062@elgon.mountain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

Thank you for the patch.

On Wednesday 21 March 2012 09:35:23 Dan Carpenter wrote:
> copy_in_user() already checks for write permission, so we don't need to
> do it here.  This was added in 1a5e4c867c "[media] uvcvideo: Implement
> compat_ioctl32 for custom ioctls".
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

And applied to my tree.

> diff --git a/drivers/media/video/uvc/uvc_v4l2.c
> b/drivers/media/video/uvc/uvc_v4l2.c index ff2cddd..111bfff 100644
> --- a/drivers/media/video/uvc/uvc_v4l2.c
> +++ b/drivers/media/video/uvc/uvc_v4l2.c
> @@ -1105,8 +1105,6 @@ static int uvc_v4l2_put_xu_mapping(const struct
> uvc_xu_control_mapping *kp, if (get_user(p, &up->menu_info))
>  		return -EFAULT;
>  	umenus = compat_ptr(p);
> -	if (!access_ok(VERIFY_WRITE, umenus, kp->menu_count * sizeof(*umenus)))
> -		return -EFAULT;
> 
>  	if (copy_in_user(umenus, kmenus, kp->menu_count * sizeof(*umenus)))
>  		return -EFAULT;

-- 
Regards,

Laurent Pinchart

