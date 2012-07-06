Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39714 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757795Ab2GFRsf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 13:48:35 -0400
Date: Fri, 6 Jul 2012 18:48:30 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, fabio.estevam@freescale.com,
	sakari.ailus@maxwell.research.nokia.com, kernel@pengutronix.de,
	arnaud.patard@rtp-net.org, mchehab@infradead.org,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, p.zabel@pengutronix.de,
	shawn.guo@linaro.org, linux-arm-kernel@lists.infradead.org,
	richard.zhu@linaro.org
Subject: Re: [PATCH 2/3] media: coda: Add driver for Coda video codec.
Message-ID: <20120706174830.GE31508@n2100.arm.linux.org.uk>
References: <1341579471-25208-1-git-send-email-javier.martin@vista-silicon.com> <1341579471-25208-3-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341579471-25208-3-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 06, 2012 at 02:57:50PM +0200, Javier Martin wrote:
> +config VIDEO_CODA
> +	tristate "Chips&Media Coda multi-standard codec IP"
> +	depends on VIDEO_DEV && VIDEO_V4L2 && SOC_IMX27
> +	select VIDEOBUF2_DMA_CONTIG
> +	select V4L2_MEM2MEM_DEV
> +	default n

Please, no more 'default n'... it's the default default anyway.

> +	---help---
> +	   Coda is a range of video codec IPs that supports
> +	   H.264, MPEG-4, and other video formats.
> +
>  config VIDEO_SAMSUNG_S5P_G2D
>  	tristate "Samsung S5P and EXYNOS4 G2D 2d graphics accelerator driver"
>  	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index d209de0..a04c307 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -187,6 +187,7 @@ obj-$(CONFIG_VIDEO_OMAP1)		+= omap1_camera.o
>  obj-$(CONFIG_VIDEO_ATMEL_ISI)		+= atmel-isi.o
>  
>  obj-$(CONFIG_VIDEO_MX2_EMMAPRP)		+= mx2_emmaprp.o
> +obj-$(CONFIG_VIDEO_CODA) 			+= coda.o
>  
>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) 	+= s5p-fimc/
>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG)	+= s5p-jpeg/
> diff --git a/drivers/media/video/coda.c b/drivers/media/video/coda.c
> new file mode 100644
> index 0000000..7b43345
> --- /dev/null
> +++ b/drivers/media/video/coda.c
> @@ -0,0 +1,1916 @@
> +/*
> + * Coda multi-standard codec IP
> + *
> + * Copyright (C) 2012 Vista Silicon S.L.
> + *    Javier Martin, <javier.martin@vista-silicon.com>
> + *    Xavier Duret
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/firmware.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/irq.h>
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/videodev2.h>
> +
> +#include <mach/hardware.h>

What in here needs mach/hardware.h ?  We really should be questioning any
new driver that needs mach/ headers...
