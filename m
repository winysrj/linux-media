Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51860 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727002AbeHCAwA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 20:52:00 -0400
Date: Thu, 2 Aug 2018 19:58:24 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lee Jones <lee.jones@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: platform: cros-ec-cec: fix dependency on
 MFD_CROS_EC
Message-ID: <20180802195824.26a9720a@coco.lan>
In-Reply-To: <20180724093624.1670671-1-arnd@arndb.de>
References: <20180724093624.1670671-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 24 Jul 2018 11:35:59 +0200
Arnd Bergmann <arnd@arndb.de> escreveu:

> Without the MFD driver, we run into a link error:

Weird... I'm not seeing this driver at the media tree... was it merged via
some other tree?

> 
> drivers/media/platform/cros-ec-cec/cros-ec-cec.o: In function `cros_ec_cec_transmit':
> cros-ec-cec.c:(.text+0x474): undefined reference to `cros_ec_cmd_xfer_status'
> drivers/media/platform/cros-ec-cec/cros-ec-cec.o: In function `cros_ec_cec_set_log_addr':
> cros-ec-cec.c:(.text+0x60b): undefined reference to `cros_ec_cmd_xfer_status'
> drivers/media/platform/cros-ec-cec/cros-ec-cec.o: In function `cros_ec_cec_adap_enable':
> cros-ec-cec.c:(.text+0x77d): undefined reference to `cros_ec_cmd_xfer_status'
> 
> As we can compile-test all the dependency, the extra '| COMPILE_TEST' is
> not needed to get the build coverage, and we can simply turn MFD_CROS_EC
> into a hard dependency to make it build in all configurations.
> 
> Fixes: cd70de2d356e ("media: platform: Add ChromeOS EC CEC driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/platform/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 92b182da8e4d..018fcbed82e4 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -535,7 +535,7 @@ if CEC_PLATFORM_DRIVERS
>  
>  config VIDEO_CROS_EC_CEC
>  	tristate "ChromeOS EC CEC driver"
> -	depends on MFD_CROS_EC || COMPILE_TEST
> +	depends on MFD_CROS_EC
>  	select CEC_CORE
>  	select CEC_NOTIFIER
>  	---help---



Thanks,
Mauro
