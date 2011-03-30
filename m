Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1834 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab1C3Hza (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2011 03:55:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] v4l: Release module if subdev registration fails
Date: Wed, 30 Mar 2011 09:55:10 +0200
Cc: linux-media@vger.kernel.org
References: <1301471301-8946-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1301471301-8946-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103300955.11024.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, March 30, 2011 09:48:21 Laurent Pinchart wrote:
> If v4l2_device_register_subdev() fails, the reference to the subdev
> module taken by the function isn't released. Fix this.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

That is definitely for 2.6.39.

Regards,

	Hans

> ---
>  drivers/media/video/v4l2-device.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
> index 5aeaf87..4aae501 100644
> --- a/drivers/media/video/v4l2-device.c
> +++ b/drivers/media/video/v4l2-device.c
> @@ -155,8 +155,10 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
>  	sd->v4l2_dev = v4l2_dev;
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
> @@ -164,6 +166,7 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
>  	if (err) {
>  		if (sd->internal_ops && sd->internal_ops->unregistered)
>  			sd->internal_ops->unregistered(sd);
> +		module_put(sd->owner);
>  		return err;
>  	}
>  
> 
