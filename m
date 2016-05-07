Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43520 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbcEGNCB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 May 2016 09:02:01 -0400
Date: Sat, 7 May 2016 10:01:56 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] em28xx-i2c: rt_mutex_trylock() returns zero on
 failure
Message-ID: <20160507100156.30b30487@recife.lan>
In-Reply-To: <20160311081301.GD31887@mwanda>
References: <20160311081301.GD31887@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 11 Mar 2016 11:13:01 +0300
Dan Carpenter <dan.carpenter@oracle.com> escreveu:

> The code is checking for negative returns but it should be checking for
> zero.
> 
> Fixes: aab3125c43d8 ('[media] em28xx: add support for registering multiple i2c buses')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Is -EBUSY correct?  -EAGAIN?

I guess -EAGAIN would be better.

Regards,
Mauro

> 
> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> index a19b5c8..f80dd3a 100644
> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> @@ -507,9 +507,8 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
>  	if (dev->disconnected)
>  		return -ENODEV;
>  
> -	rc = rt_mutex_trylock(&dev->i2c_bus_lock);
> -	if (rc < 0)
> -		return rc;
> +	if (!rt_mutex_trylock(&dev->i2c_bus_lock))
> +		return -EBUSY;
>  
>  	/* Switch I2C bus if needed */
>  	if (bus != dev->cur_i2c_bus &&
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Thanks,
Mauro
