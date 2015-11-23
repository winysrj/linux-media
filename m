Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41395 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbbKWTjN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2015 14:39:13 -0500
Subject: Re: [PATCH] tda10071: Fix dependency to REGMAP_I2C
To: Matthias Schwarzott <zzam@gentoo.org>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com
References: <1448306344-7691-1-git-send-email-zzam@gentoo.org>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <56536B5D.7050708@iki.fi>
Date: Mon, 23 Nov 2015 21:39:09 +0200
MIME-Version: 1.0
In-Reply-To: <1448306344-7691-1-git-send-email-zzam@gentoo.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!
Thank you for the patch! Usually these are nowadays found by automated 
build test, but for some reason not that one...


On 11/23/2015 09:19 PM, Matthias Schwarzott wrote:
> Without I get this error for by dvb-card:
>    tda10071: Unknown symbol devm_regmap_init_i2c (err 0)
>    cx23885_dvb_register() dvb_register failed err = -22
>    cx23885_dev_setup() Failed to register dvb adapters on VID_B
>
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>

Reviewed-by: Antti Palosaari <crope@iki.fi>


> ---
>   drivers/media/dvb-frontends/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
> index 292c947..310e4b8 100644
> --- a/drivers/media/dvb-frontends/Kconfig
> +++ b/drivers/media/dvb-frontends/Kconfig
> @@ -264,7 +264,7 @@ config DVB_MB86A16
>   config DVB_TDA10071
>   	tristate "NXP TDA10071"
>   	depends on DVB_CORE && I2C
> -	select REGMAP
> +	select REGMAP_I2C
>   	default m if !MEDIA_SUBDRV_AUTOSELECT
>   	help
>   	  Say Y when you want to support this frontend.
>

-- 
http://palosaari.fi/
