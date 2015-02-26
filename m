Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53349 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbbBZXS3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 18:18:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] media: i2c: mt9p031: make sure we destroy the mutex
Date: Fri, 27 Feb 2015 01:19:33 +0200
Message-ID: <1655258.KMH9gfjzu0@avalon>
In-Reply-To: <1424973938-26121-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1424973938-26121-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

Thank you for the patch.

On Thursday 26 February 2015 18:05:38 Lad Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> this patch makes sure to call mutex_destroy() in
> case of probe failure or module unload.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree with a slightly modified commit message:

Make sure to call mutex_destroy() in case of probe failure or module 
unload.

> ---
>  drivers/media/i2c/mt9p031.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> index e3acae9..af5a09d 100644
> --- a/drivers/media/i2c/mt9p031.c
> +++ b/drivers/media/i2c/mt9p031.c
> @@ -1071,6 +1071,8 @@ static int mt9p031_probe(struct i2c_client *client,
>  		return ret;
>  	}
> 
> +	mutex_init(&mt9p031->power_lock);
> +
>  	v4l2_ctrl_handler_init(&mt9p031->ctrls, ARRAY_SIZE(mt9p031_ctrls) + 6);
> 
>  	v4l2_ctrl_new_std(&mt9p031->ctrls, &mt9p031_ctrl_ops,
> @@ -1108,7 +1110,6 @@ static int mt9p031_probe(struct i2c_client *client,
>  	mt9p031->blc_offset = v4l2_ctrl_find(&mt9p031->ctrls,
>  					     V4L2_CID_BLC_DIGITAL_OFFSET);
> 
> -	mutex_init(&mt9p031->power_lock);
>  	v4l2_i2c_subdev_init(&mt9p031->subdev, client, &mt9p031_subdev_ops);
>  	mt9p031->subdev.internal_ops = &mt9p031_subdev_internal_ops;
> 
> @@ -1149,6 +1150,7 @@ done:
>  	if (ret < 0) {
>  		v4l2_ctrl_handler_free(&mt9p031->ctrls);
>  		media_entity_cleanup(&mt9p031->subdev.entity);
> +		mutex_destroy(&mt9p031->power_lock);
>  	}
> 
>  	return ret;
> @@ -1162,6 +1164,7 @@ static int mt9p031_remove(struct i2c_client *client)
>  	v4l2_ctrl_handler_free(&mt9p031->ctrls);
>  	v4l2_device_unregister_subdev(subdev);
>  	media_entity_cleanup(&subdev->entity);
> +	mutex_destroy(&mt9p031->power_lock);
> 
>  	return 0;
>  }

-- 
Regards,

Laurent Pinchart

