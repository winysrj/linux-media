Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38249 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab2EWK76 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 06:59:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] as3645a: Remove set_power() from platform data
Date: Wed, 23 May 2012 13:00:08 +0200
Message-ID: <5818890.hvZb7JEbAH@avalon>
In-Reply-To: <1337137969-30575-1-git-send-email-sakari.ailus@iki.fi>
References: <1337137969-30575-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Wednesday 16 May 2012 06:12:49 Sakari Ailus wrote:
> The chip is typically powered constantly and no board uses the set_power()
> callback. Remove it.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/video/as3645a.c |   39 +++++++++----------------------------
>  include/media/as3645a.h       |    1 -
>  2 files changed, 9 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/media/video/as3645a.c b/drivers/media/video/as3645a.c
> index c4b0357..7454660 100644
> --- a/drivers/media/video/as3645a.c
> +++ b/drivers/media/video/as3645a.c
> @@ -512,31 +512,6 @@ static int as3645a_setup(struct as3645a *flash)
>  	return ret & ~AS_FAULT_INFO_LED_AMOUNT ? -EIO : 0;
>  }
> 
> -static int __as3645a_set_power(struct as3645a *flash, int on)
> -{
> -	int ret;
> -
> -	if (!on)
> -		as3645a_set_control(flash, AS_MODE_EXT_TORCH, false);
> -
> -	if (flash->pdata->set_power) {
> -		ret = flash->pdata->set_power(&flash->subdev, on);
> -		if (ret < 0)
> -			return ret;
> -	}
> -
> -	if (!on)
> -		return 0;
> -
> -	ret = as3645a_setup(flash);
> -	if (ret < 0) {
> -		if (flash->pdata->set_power)
> -			flash->pdata->set_power(&flash->subdev, 0);
> -	}
> -
> -	return ret;
> -}
> -
>  static int as3645a_set_power(struct v4l2_subdev *sd, int on)
>  {
>  	struct as3645a *flash = to_as3645a(sd);
> @@ -545,9 +520,13 @@ static int as3645a_set_power(struct v4l2_subdev *sd,
> int on) mutex_lock(&flash->power_lock);
> 
>  	if (flash->power_count == !on) {
> -		ret = __as3645a_set_power(flash, !!on);
> -		if (ret < 0)
> -			goto done;
> +		if (!on) {
> +			as3645a_set_control(flash, AS_MODE_EXT_TORCH, false);
> +		} else {
> +			ret = as3645a_setup(flash);
> +			if (ret < 0)
> +				goto done;
> +		}
>  	}
> 

If the chip is powered on constantly, why do we need a .s_power() subdev 
operation at all ?

>  	flash->power_count += on ? 1 : -1;
> @@ -675,7 +654,7 @@ static int as3645a_suspend(struct device *dev)
>  	if (flash->power_count == 0)
>  		return 0;
> 
> -	rval = __as3645a_set_power(flash, 0);
> +	rval = as3645a_set_control(flash, AS_MODE_EXT_TORCH, false);
> 
>  	dev_dbg(&client->dev, "Suspend %s\n", rval < 0 ? "failed" : "ok");
> 
> @@ -692,7 +671,7 @@ static int as3645a_resume(struct device *dev)
>  	if (flash->power_count == 0)
>  		return 0;
> 
> -	rval = __as3645a_set_power(flash, 1);
> +	rval = as3645a_setup(flash);
> 
>  	dev_dbg(&client->dev, "Resume %s\n", rval < 0 ? "fail" : "ok");
> 
> diff --git a/include/media/as3645a.h b/include/media/as3645a.h
> index 5075496..a83ab3a 100644
> --- a/include/media/as3645a.h
> +++ b/include/media/as3645a.h
> @@ -57,7 +57,6 @@
>   * @timeout_max:	Max flash timeout (us, <= AS3645A_FLASH_TIMEOUT_MAX)
>   */
>  struct as3645a_platform_data {
> -	int (*set_power)(struct v4l2_subdev *subdev, int on);
>  	unsigned int vref;
>  	unsigned int peak;
>  	bool ext_strobe;

-- 
Regards,

Laurent Pinchart

