Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59821 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803Ab1D3Nff (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Apr 2011 09:35:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 4/4] v4l: Release module if subdev registration fails
Date: Sat, 30 Apr 2011 15:35:59 +0200
Cc: linux-media@vger.kernel.org
References: <1304170445-11978-1-git-send-email-laurent.pinchart@ideasonboard.com> <1304170445-11978-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1304170445-11978-5-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201104301536.00268.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday 30 April 2011 15:34:05 Laurent Pinchart wrote:
> If v4l2_device_register_subdev() fails, the reference to the subdev
> module taken by the function isn't released. Fix this.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: stable@kernel.org
> Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

Mauro, if it's not too late, can you pick this patch for 2.6.39 ?

> ---
>  drivers/media/video/v4l2-device.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-device.c
> b/drivers/media/video/v4l2-device.c index 5aeaf87..4aae501 100644
> --- a/drivers/media/video/v4l2-device.c
> +++ b/drivers/media/video/v4l2-device.c
> @@ -155,8 +155,10 @@ int v4l2_device_register_subdev(struct v4l2_device
> *v4l2_dev, sd->v4l2_dev = v4l2_dev;
>  	if (sd->internal_ops && sd->internal_ops->registered) {
>  		err = sd->internal_ops->registered(sd);
> -		if (err)
> +		if (err) {
> +			module_put(sd->owner);
>  			return err;
> +		}
>  	}
> 
>  	/* This just returns 0 if either of the two args is NULL */
> @@ -164,6 +166,7 @@ int v4l2_device_register_subdev(struct v4l2_device
> *v4l2_dev, if (err) {
>  		if (sd->internal_ops && sd->internal_ops->unregistered)
>  			sd->internal_ops->unregistered(sd);
> +		module_put(sd->owner);
>  		return err;
>  	}

-- 
Regards,

Laurent Pinchart
