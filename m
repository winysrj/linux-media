Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35643 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbbCHNha (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2015 09:37:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] media: i2c: mt9p031: add support for asynchronous probing
Date: Sun, 08 Mar 2015 15:37:30 +0200
Message-ID: <1429405.sJNtm14NRT@avalon>
In-Reply-To: <1425053419-30042-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1425053419-30042-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

Thank you for the patch.

On Friday 27 February 2015 16:10:19 Lad Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> Both synchronous and asynchronous mt9p031 subdevice probing
> is supported by this patch.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

I have the exact same patch in my tree, so

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I'll pick yours as I haven't posted mine before. It should remind me to post 
early next time :-)

> ---
>  drivers/media/i2c/mt9p031.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> index af5a09d..9df4e2f 100644
> --- a/drivers/media/i2c/mt9p031.c
> +++ b/drivers/media/i2c/mt9p031.c
> @@ -28,6 +28,7 @@
>  #include <linux/videodev2.h>
> 
>  #include <media/mt9p031.h>
> +#include <media/v4l2-async.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-subdev.h>
> @@ -1145,6 +1146,10 @@ static int mt9p031_probe(struct i2c_client *client,
>  	}
> 
>  	ret = mt9p031_clk_setup(mt9p031);
> +	if (ret)
> +		goto done;
> +
> +	ret = v4l2_async_register_subdev(&mt9p031->subdev);
> 
>  done:
>  	if (ret < 0) {
> @@ -1162,7 +1167,7 @@ static int mt9p031_remove(struct i2c_client *client)
>  	struct mt9p031 *mt9p031 = to_mt9p031(subdev);
> 
>  	v4l2_ctrl_handler_free(&mt9p031->ctrls);
> -	v4l2_device_unregister_subdev(subdev);
> +	v4l2_async_unregister_subdev(subdev);
>  	media_entity_cleanup(&subdev->entity);
>  	mutex_destroy(&mt9p031->power_lock);

-- 
Regards,

Laurent Pinchart

