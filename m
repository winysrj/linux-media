Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:40942 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab3LULEG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Dec 2013 06:04:06 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MY50039ALET4X30@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Sat, 21 Dec 2013 06:04:05 -0500 (EST)
Date: Sat, 21 Dec 2013 09:04:00 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: kbuild test robot <fengguang.wu@intel.com>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [linuxtv-media:master 483/499] m88ds3103.c:undefined reference to
 `i2c_del_mux_adapter'
Message-id: <20131221090400.766a9cdf@samsung.com>
In-reply-to: <20131221085048.40a00d81@samsung.com>
References: <52b4fca0.ygAJPoOJD83r3RML%fengguang.wu@intel.com>
 <20131221085048.40a00d81@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 21 Dec 2013 08:50:48 -0200
Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:

> From: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Date: Sat, 21 Dec 2013 05:42:11 -0200
> Subject: [PATCH] [media] subdev autoselect only works if I2C and I2C_MUX is selected
> 
> As reported by the kbuild test robot <fengguang.wu@intel.com>:
> 
> > warning: (VIDEO_EM28XX_DVB) selects DVB_M88DS3103 which has unmet direct dependencies (MEDIA_SUPPORT && DVB_CORE && I2C && I2C_MUX)
> >    drivers/built-in.o: In function `m88ds3103_release':  
> > >> m88ds3103.c:(.text+0x1ab1af): undefined reference to `i2c_del_mux_adapter'  
> >    drivers/built-in.o: In function `m88ds3103_attach':  
> > >> (.text+0x1ab342): undefined reference to `i2c_add_mux_adapter'  
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

It is the Christmas week. I don't think we'll have enough reviews for this,
as most are preparing themselves to properly celebrate the birth of our
Lord, or to just rest during Seasons.

Due to that, I'll likely just apply this patch with a better description,
as I intend to merge the pending patches at -next during this weekend,
and I don't want to spread compilation breakages there.

If we latter agree with some other solution, reverting this one while 
applying other changes should be trivial.

Happy Seasons!
Mauro

> 
> diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> index 8270388e2a0d..1d0758aeb8e4 100644
> --- a/drivers/media/Kconfig
> +++ b/drivers/media/Kconfig
> @@ -172,6 +172,9 @@ comment "Media ancillary drivers (tuners, sensors, i2c, frontends)"
>  config MEDIA_SUBDRV_AUTOSELECT
>  	bool "Autoselect ancillary drivers (tuners, sensors, i2c, frontends)"
>  	depends on MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_CAMERA_SUPPORT
> +	depends on HAS_IOMEM
> +	select I2C
> +	select I2C_MUX
>  	default y
>  	help
>  	  By default, a media driver auto-selects all possible ancillary
> --


