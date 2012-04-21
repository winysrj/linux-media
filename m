Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58793 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab2DUT6H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Apr 2012 15:58:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] as3645a: move .remove under .devexit.text
Date: Sat, 21 Apr 2012 19:36:53 +0200
Message-ID: <1578696.ouKf8xKIQt@avalon>
In-Reply-To: <1334843290-29668-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1334843290-29668-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

Thanks for the patch.

On Thursday 19 April 2012 16:48:10 Andy Shevchenko wrote:
> There is no needs to keep .remove under .exit.text. This driver is for a
> standalone chip that could be on any board and connected to any i2c bus.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/as3645a.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/as3645a.c b/drivers/media/video/as3645a.c
> index 7a3371f..dc2571f 100644
> --- a/drivers/media/video/as3645a.c
> +++ b/drivers/media/video/as3645a.c
> @@ -846,7 +846,7 @@ done:
>  	return ret;
>  }
> 
> -static int __exit as3645a_remove(struct i2c_client *client)
> +static int __devexit as3645a_remove(struct i2c_client *client)

What about also marking as3645a_probe() with __devinit ? I might be missing 
something though, as we have very few I2C drivers in drivers/media/video with 
a probe function marked with __devinit (or remove function marked with 
__devexit). Is it time for some cleanup ?

>  {
>  	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
>  	struct as3645a *flash = to_as3645a(subdev);
> @@ -877,7 +877,7 @@ static struct i2c_driver as3645a_i2c_driver = {
>  		.pm   = &as3645a_pm_ops,
>  	},
>  	.probe	= as3645a_probe,
> -	.remove	= __exit_p(as3645a_remove),
> +	.remove	= __devexit_p(as3645a_remove),
>  	.id_table = as3645a_id_table,
>  };

-- 
Regards,

Laurent Pinchart

