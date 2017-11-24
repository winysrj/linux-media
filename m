Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45784 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752111AbdKXSJn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Nov 2017 13:09:43 -0500
Subject: Re: [PATCH] media: ov7670: use v4l2_async_unregister_subdev()
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1511534445-30512-1-git-send-email-akinobu.mita@gmail.com>
Reply-To: kieran.bingham@ideasonboard.com
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <016d6451-2a58-42f1-8556-6bbf6467caf2@ideasonboard.com>
Date: Fri, 24 Nov 2017 18:09:38 +0000
MIME-Version: 1.0
In-Reply-To: <1511534445-30512-1-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Akinobu,

Thankyou for the patch.

On 24/11/17 14:40, Akinobu Mita wrote:
> The sub-device for ov7670 is registered by v4l2_async_register_subdev().
> So it should be unregistered by v4l2_async_unregister_subdev() instead of
> v4l2_device_unregister_subdev().
> 
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  drivers/media/i2c/ov7670.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
> index 950a0ac..b61d88e 100644
> --- a/drivers/media/i2c/ov7670.c
> +++ b/drivers/media/i2c/ov7670.c
> @@ -1820,7 +1820,7 @@ static int ov7670_remove(struct i2c_client *client)
>  	struct v4l2_subdev *sd = i2c_get_clientdata(client);
>  	struct ov7670_info *info = to_state(sd);
>  
> -	v4l2_device_unregister_subdev(sd);
> +	v4l2_async_unregister_subdev(sd);

Good spot.

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

>  	v4l2_ctrl_handler_free(&info->hdl);
>  	clk_disable_unprepare(info->clk);
>  #if defined(CONFIG_MEDIA_CONTROLLER)
> 
