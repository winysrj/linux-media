Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599Ab0CQM7O (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 08:59:14 -0400
Message-ID: <4BA0D214.3050506@redhat.com>
Date: Wed, 17 Mar 2010 09:59:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] V4L: introduce a Kconfig variable to disable helper-chip
 autoselection
References: <Pine.LNX.4.64.1003171336180.4354@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1003171336180.4354@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 17-03-2010 09:38, Guennadi Liakhovetski escreveu:
> Helper-chip autoselection doesn't work in some situations. Add a configuration
> variable to let drivers disable it. Use it to disable autoselection if
> SOC_CAMERA is selected.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> This will also be used from VOU video-output driver, other SoC drivers 
> might also want to select this option.
> 
>  drivers/media/video/Kconfig |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 64682bf..73f3808 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -77,8 +77,12 @@ config VIDEO_FIXED_MINOR_RANGES
>  
>  	  When in doubt, say N.
>  
> +config VIDEO_HELPER_CHIPS_AUTO_DISABLE
> +	bool
> +
>  config VIDEO_HELPER_CHIPS_AUTO
>  	bool "Autoselect pertinent encoders/decoders and other helper chips"
> +	depends on !VIDEO_HELPER_CHIPS_AUTO_DISABLE
>  	default y
>  	---help---
>  	  Most video cards may require additional modules to encode or
> @@ -816,6 +820,7 @@ config SOC_CAMERA
>  	tristate "SoC camera support"
>  	depends on VIDEO_V4L2 && HAS_DMA && I2C
>  	select VIDEOBUF_GEN
> +	select VIDEO_HELPER_CHIPS_AUTO_DISABLE
>  	help
>  	  SoC Camera is a common API to several cameras, not connecting
>  	  over a bus like PCI or USB. For example some i2c camera connected
NACK.

If this is not working, please fix, instead of doing a workaround.

What's the exact problem?

Cheers,
Mauro
