Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:53694 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751488AbaLSVFx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 16:05:53 -0500
Date: Fri, 19 Dec 2014 22:05:51 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: nicolas.ferre@atmel.com, voice.shen@atmel.com,
	plagnioj@jcrosoft.com, boris.brezillon@free-electrons.com,
	devicetree@vger.kernel.org, robh+dt@kernel.org,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 7/7] ARM: at91: sama5: enable atmel-isi and ov2640 in
 defconfig
Message-ID: <20141219210551.GD4885@piout.net>
References: <1418892667-27428-1-git-send-email-josh.wu@atmel.com>
 <1418892667-27428-8-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418892667-27428-8-git-send-email-josh.wu@atmel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18/12/2014 at 16:51:07 +0800, Josh Wu wrote :
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/configs/sama5_defconfig | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm/configs/sama5_defconfig b/arch/arm/configs/sama5_defconfig
> index b58fb32..92f1d71 100644
> --- a/arch/arm/configs/sama5_defconfig
> +++ b/arch/arm/configs/sama5_defconfig
> @@ -139,6 +139,12 @@ CONFIG_POWER_RESET=y
>  CONFIG_SSB=m
>  CONFIG_REGULATOR=y
>  CONFIG_REGULATOR_ACT8865=y
> +CONFIG_MEDIA_SUPPORT=y
> +CONFIG_MEDIA_CAMERA_SUPPORT=y
> +CONFIG_V4L_PLATFORM_DRIVERS=y
> +CONFIG_SOC_CAMERA=y
> +CONFIG_SOC_CAMERA_OV2640=y
> +CONFIG_VIDEO_ATMEL_ISI=y
>  CONFIG_FB=y
>  CONFIG_BACKLIGHT_LCD_SUPPORT=y
>  # CONFIG_LCD_CLASS_DEVICE is not set
> -- 
> 1.9.1
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
