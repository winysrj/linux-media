Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:26523 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab3CRDKM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Mar 2013 23:10:12 -0400
From: Jingoo Han <jg1.han@samsung.com>
To: 'Fabio Porcedda' <fabio.porcedda@gmail.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-input@vger.kernel.org, linux-fbdev@vger.kernel.org
Cc: 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>,
	'Linus Walleij' <linus.walleij@linaro.org>,
	'Samuel Ortiz' <sameo@linux.intel.com>,
	'Jingoo Han' <jg1.han@samsung.com>
References: <1363280978-24051-1-git-send-email-fabio.porcedda@gmail.com>
 <1363280978-24051-7-git-send-email-fabio.porcedda@gmail.com>
In-reply-to: <1363280978-24051-7-git-send-email-fabio.porcedda@gmail.com>
Subject: Re: [PATCH v2 6/8] drivers: mfd: use module_platform_driver_probe()
Date: Mon, 18 Mar 2013 12:10:10 +0900
Message-id: <018b01ce2386$19ba9090$4d2fb1b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, March 15, 2013 2:10 AM, Fabio Porcedda wrote:
> 
> This patch converts the drivers to use the
> module_platform_driver_probe() macro which makes the code smaller and
> a bit simpler.
> 
> Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  drivers/mfd/davinci_voicecodec.c | 12 +-----------
>  drivers/mfd/htc-pasic3.c         | 13 +------------
>  2 files changed, 2 insertions(+), 23 deletions(-)

I already submitted the patch 2 weeks ago.

https://patchwork.kernel.org/patch/2217301/
https://patchwork.kernel.org/patch/2217291/


Best regards,
Jingoo Han

> 
> diff --git a/drivers/mfd/davinci_voicecodec.c b/drivers/mfd/davinci_voicecodec.c
> index c0bcc87..c60ab0c 100644
> --- a/drivers/mfd/davinci_voicecodec.c
> +++ b/drivers/mfd/davinci_voicecodec.c
> @@ -177,17 +177,7 @@ static struct platform_driver davinci_vc_driver = {
>  	.remove	= davinci_vc_remove,
>  };
> 
> -static int __init davinci_vc_init(void)
> -{
> -	return platform_driver_probe(&davinci_vc_driver, davinci_vc_probe);
> -}
> -module_init(davinci_vc_init);
> -
> -static void __exit davinci_vc_exit(void)
> -{
> -	platform_driver_unregister(&davinci_vc_driver);
> -}
> -module_exit(davinci_vc_exit);
> +module_platform_driver_probe(davinci_vc_driver, davinci_vc_probe);
> 
>  MODULE_AUTHOR("Miguel Aguilar");
>  MODULE_DESCRIPTION("Texas Instruments DaVinci Voice Codec Core Interface");
> diff --git a/drivers/mfd/htc-pasic3.c b/drivers/mfd/htc-pasic3.c
> index 9e5453d..0285fce 100644
> --- a/drivers/mfd/htc-pasic3.c
> +++ b/drivers/mfd/htc-pasic3.c
> @@ -208,18 +208,7 @@ static struct platform_driver pasic3_driver = {
>  	.remove		= pasic3_remove,
>  };
> 
> -static int __init pasic3_base_init(void)
> -{
> -	return platform_driver_probe(&pasic3_driver, pasic3_probe);
> -}
> -
> -static void __exit pasic3_base_exit(void)
> -{
> -	platform_driver_unregister(&pasic3_driver);
> -}
> -
> -module_init(pasic3_base_init);
> -module_exit(pasic3_base_exit);
> +module_platform_driver_probe(pasic3_driver, pasic3_probe);
> 
>  MODULE_AUTHOR("Philipp Zabel <philipp.zabel@gmail.com>");
>  MODULE_DESCRIPTION("Core driver for HTC PASIC3");
> --
> 1.8.1.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

