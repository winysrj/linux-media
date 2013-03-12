Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:64636 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3CLHFP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 03:05:15 -0400
Date: Tue, 12 Mar 2013 08:05:13 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Paul Bolle <pebolle@tiscali.nl>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] soc_camera: remove two outdated selects
In-Reply-To: <1363037403.3137.114.camel@x61.thuisdomein>
Message-ID: <Pine.LNX.4.64.1303120804280.680@axis700.grange>
References: <1363037403.3137.114.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Paul

On Mon, 11 Mar 2013, Paul Bolle wrote:

> Release v2.6.30 removed the MT9M001_PCA9536_SWITCH and
> MT9V022_PCA9536_SWITCH Kconfig symbols, in commits
> 36034dc325ecab63c8cfb992fbf9a1a8e94738a2 ("V4L/DVB (11032): mt9m001:
> allow setting of bus width from board code") and
> e958e27adeade7fa085dd396a8a0dfaef7e338c1 ("V4L/DVB (11033): mt9v022:
> allow setting of bus width from board code").
> 
> These two commits removed all gpio related code from these two drivers.
> But they skipped removing their two selects of GPIO_PCA953X. Remove
> these now as they are outdated. Their dependencies can never evaluate to
> true anyhow.

Thanks, this is definitely a left-over. Queued for 3.10.

Thanks
Guennadi

> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Tested by grepping the tree.
> 
>  drivers/media/i2c/soc_camera/Kconfig | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/media/i2c/soc_camera/Kconfig b/drivers/media/i2c/soc_camera/Kconfig
> index 6dff2b7..23d352f 100644
> --- a/drivers/media/i2c/soc_camera/Kconfig
> +++ b/drivers/media/i2c/soc_camera/Kconfig
> @@ -9,7 +9,6 @@ config SOC_CAMERA_IMX074
>  config SOC_CAMERA_MT9M001
>  	tristate "mt9m001 support"
>  	depends on SOC_CAMERA && I2C
> -	select GPIO_PCA953X if MT9M001_PCA9536_SWITCH
>  	help
>  	  This driver supports MT9M001 cameras from Micron, monochrome
>  	  and colour models.
> @@ -36,7 +35,6 @@ config SOC_CAMERA_MT9T112
>  config SOC_CAMERA_MT9V022
>  	tristate "mt9v022 and mt9v024 support"
>  	depends on SOC_CAMERA && I2C
> -	select GPIO_PCA953X if MT9V022_PCA9536_SWITCH
>  	help
>  	  This driver supports MT9V022 cameras from Micron
>  
> -- 
> 1.7.11.7
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
