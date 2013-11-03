Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:43360 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab3KCJ1a (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 04:27:30 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MVO003IFKXUDU20@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sun, 03 Nov 2013 04:27:30 -0500 (EST)
Date: Sun, 03 Nov 2013 07:27:26 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Maik Broemme <mbroemme@parallels.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 02/12] tda18271c2dd: Fix description of NXP TDA18271C2
 silicon tuner
Message-id: <20131103072726.51dd0472@samsung.com>
In-reply-to: <20131103002523.GF7956@parallels.com>
References: <20131103002235.GD7956@parallels.com>
 <20131103002523.GF7956@parallels.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 3 Nov 2013 01:25:23 +0100
Maik Broemme <mbroemme@parallels.com> escreveu:

> Added (DD) to NXP TDA18271C2 silicon tuner as this tuner was
> specifically added for Digital Devices ddbridge driver.
> 
> Signed-off-by: Maik Broemme <mbroemme@parallels.com>
> ---
>  drivers/media/dvb-frontends/Kconfig | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
> index bddbab4..6f99eb8 100644
> --- a/drivers/media/dvb-frontends/Kconfig
> +++ b/drivers/media/dvb-frontends/Kconfig
> @@ -48,11 +48,11 @@ config DVB_DRXK
>  	  Say Y when you want to support this frontend.
>  
>  config DVB_TDA18271C2DD
> -	tristate "NXP TDA18271C2 silicon tuner"
> +	tristate "NXP TDA18271C2 silicon tuner (DD)"
>  	depends on DVB_CORE && I2C
>  	default m if !MEDIA_SUBDRV_AUTOSELECT
>  	help
> -	  NXP TDA18271 silicon tuner.
> +	  NXP TDA18271 silicon tuner (Digital Devices driver).
>  
>  	  Say Y when you want to support this tuner.
>  

The better is to use the other tda18271 driver. This one was added as a
temporary alternative, as the more complete one were lacking some
features, and were not working with DRX-K. Well, those got fixed already,
and we now want to get rid of this duplicated driver.

Regards,
Mauro
-- 

Cheers,
Mauro
