Return-path: <linux-media-owner@vger.kernel.org>
Received: from d594e42d.dsl.concepts.nl ([213.148.228.45]:34568 "EHLO
	his10.thuis.hoogenraad.info" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753107AbaCXSRd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 14:17:33 -0400
Message-ID: <533074B2.4000007@hoogenraad.net>
Date: Mon, 24 Mar 2014 19:08:50 +0100
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
CC: Hans Verkuil <hverkuil@xs4all.nl>
Subject: How to build I2C_MUX in media_build as rtl28xxu depends on it ?
References: <1394756071-22410-1-git-send-email-crope@iki.fi> <1394756071-22410-12-git-send-email-crope@iki.fi>
In-Reply-To: <1394756071-22410-12-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After recent changes, I cannot build  rtl28xxu on systems with linux
2.6.32 or 3.2.0.
rtl28xxu is one of the few drivers depending on  I2C_MUX.
Kconfig.kern lists I2C_MUX (correctly) as not in the kernel of the system.
I don't know if it is possible to load a new module for that.

Who can help me with this ?

Antti Palosaari wrote:
> We need depend on I2C_MUX as rtl2832 demod used requires it.
>
> All error/warnings:
> warning: (DVB_USB_RTL28XXU) selects DVB_RTL2832 which has unmet direct dependencies (MEDIA_SUPPORT && DVB_CORE && I2C && I2C_MUX)
> ERROR: "i2c_add_mux_adapter" [drivers/media/dvb-frontends/rtl2832.ko] undefined!
> ERROR: "i2c_del_mux_adapter" [drivers/media/dvb-frontends/rtl2832.ko] undefined!
>
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/usb/dvb-usb-v2/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
> index bfb7378..037e519 100644
> --- a/drivers/media/usb/dvb-usb-v2/Kconfig
> +++ b/drivers/media/usb/dvb-usb-v2/Kconfig
> @@ -126,7 +126,7 @@ config DVB_USB_MXL111SF
>  
>  config DVB_USB_RTL28XXU
>  	tristate "Realtek RTL28xxU DVB USB support"
> -	depends on DVB_USB_V2
> +	depends on DVB_USB_V2 && I2C_MUX
>  	select DVB_RTL2830
>  	select DVB_RTL2832
>  	select MEDIA_TUNER_QT1010 if MEDIA_SUBDRV_AUTOSELECT


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht

