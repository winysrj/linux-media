Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:32396 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaI2POU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 11:14:20 -0400
Date: Mon, 29 Sep 2014 12:14:12 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-media@vger.kernel.org, Akihiro Tsukada <tskd08@gmail.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [media] pt3: remove bogus module_is_live() check
Message-id: <20140929121412.66f2dd67.m.chehab@samsung.com>
In-reply-to: <6460819.BmnhuA22YH@wuerfel>
References: <6460819.BmnhuA22YH@wuerfel>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

Em Mon, 29 Sep 2014 16:28:55 +0200
Arnd Bergmann <arnd@arndb.de> escreveu:

> The new pt3 driver checks the module reference for presence
> before dropping it, which fails to compile when modules
> are disabled:
> 
> media/pci/pt3/pt3.c: In function 'pt3_attach_fe':
> media/pci/pt3/pt3.c:433:6: error: implicit declaration of function 'module_is_live' [-Werror=implicit-function-declaration]
>       module_is_live(pt3->adaps[i]->i2c_tuner->dev.driver->owner))
> 
> As far as I can tell however, this check is not needed at all, because
> the module will not go away as long as pt3 is holding a reference on
> it. Also the previous check for NULL pointer is not needed at all,
> because module_put has the same check.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks for this patch. Antti was quicker than you ;)

I merged the patch on my tree yesterday. It should be popping up
on the tomorrow's -next (I think that sfr didn't release one today).

> 
> diff --git a/drivers/media/pci/pt3/pt3.c b/drivers/media/pci/pt3/pt3.c
> index 90f86ce7a001..39305f07dc2e 100644
> --- a/drivers/media/pci/pt3/pt3.c
> +++ b/drivers/media/pci/pt3/pt3.c
> @@ -429,14 +429,10 @@ static int pt3_attach_fe(struct pt3_board *pt3, int i)
>  
>  err_tuner:
>  	i2c_unregister_device(pt3->adaps[i]->i2c_tuner);
> -	if (pt3->adaps[i]->i2c_tuner->dev.driver->owner &&
> -	    module_is_live(pt3->adaps[i]->i2c_tuner->dev.driver->owner))
> -		module_put(pt3->adaps[i]->i2c_tuner->dev.driver->owner);
> +	module_put(pt3->adaps[i]->i2c_tuner->dev.driver->owner);
>  err_demod:
>  	i2c_unregister_device(pt3->adaps[i]->i2c_demod);
> -	if (pt3->adaps[i]->i2c_demod->dev.driver->owner &&
> -	    module_is_live(pt3->adaps[i]->i2c_demod->dev.driver->owner))
> -		module_put(pt3->adaps[i]->i2c_demod->dev.driver->owner);
> +	module_put(pt3->adaps[i]->i2c_demod->dev.driver->owner);
>  	return ret;
>  }
>  
> 
