Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35309 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010Ab2DIJvD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2012 05:51:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] V4L: mt9m032: fix two dead-locks
Date: Mon, 09 Apr 2012 11:51:04 +0200
Message-ID: <3076345.89Inf54hBS@avalon>
In-Reply-To: <Pine.LNX.4.64.1204082230360.808@axis700.grange>
References: <Pine.LNX.4.64.1204082230360.808@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the patch.

On Sunday 08 April 2012 22:31:24 Guennadi Liakhovetski wrote:
> Fix a copy-paste typo and a nested locking function call in mt9m032.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> ---
>  drivers/media/video/mt9m032.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/mt9m032.c b/drivers/media/video/mt9m032.c
> index 7636672..645973c 100644
> --- a/drivers/media/video/mt9m032.c
> +++ b/drivers/media/video/mt9m032.c
> @@ -392,10 +392,11 @@ static int mt9m032_set_pad_format(struct v4l2_subdev
> *subdev, }
> 
>  	/* Scaling is not supported, the format is thus fixed. */
> -	ret = mt9m032_get_pad_format(subdev, fh, fmt);
> +	fmt->format = *__mt9m032_get_pad_format(sensor, fh, fmt->which);
> +	ret = 0;
> 
>  done:
> -	mutex_lock(&sensor->lock);
> +	mutex_unlock(&sensor->lock);
>  	return ret;
>  }
-- 
Regards,

Laurent Pinchart

