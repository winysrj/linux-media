Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33175 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729107AbeGZLtF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Jul 2018 07:49:05 -0400
Received: by mail-lj1-f195.google.com with SMTP id s12-v6so1063920ljj.0
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2018 03:32:51 -0700 (PDT)
Date: Thu, 26 Jul 2018 12:32:48 +0200
From: =?iso-8859-1?Q?=22Niklas_S=F6derlund=22?=
        <niklas.soderlund@ragnatech.se>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran@ksquared.org.uk>,
        Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 02/11] media: rcar-vin: convert to SPDX identifiers
Message-ID: <20180726103248.GJ14991@bigcity.dyn.berto.se>
References: <87h8kmd938.wl-kuninori.morimoto.gx@renesas.com>
 <87effqd915.wl-kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87effqd915.wl-kuninori.morimoto.gx@renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Morimoto-san,

Thanks for your patch.

On 2018-07-26 02:35:06 +0000, Kuninori Morimoto wrote:
> 
> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> 
> Kconfig and Makefile doesn't have license line, thus,
> these are GPL-2.0 as default.
> All ohter files are GPL-2.0+ as original license.
> 
> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/platform/rcar-vin/Kconfig     | 1 +
>  drivers/media/platform/rcar-vin/Makefile    | 1 +
>  drivers/media/platform/rcar-vin/rcar-core.c | 8 ++------
>  drivers/media/platform/rcar-vin/rcar-dma.c  | 6 +-----
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 6 +-----
>  drivers/media/platform/rcar-vin/rcar-vin.h  | 6 +-----
>  6 files changed, 7 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/Kconfig b/drivers/media/platform/rcar-vin/Kconfig
> index baf4eaf..e3eb8fe 100644
> --- a/drivers/media/platform/rcar-vin/Kconfig
> +++ b/drivers/media/platform/rcar-vin/Kconfig
> @@ -1,3 +1,4 @@
> +# SPDX-License-Identifier: GPL-2.0
>  config VIDEO_RCAR_CSI2
>  	tristate "R-Car MIPI CSI-2 Receiver"
>  	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF
> diff --git a/drivers/media/platform/rcar-vin/Makefile b/drivers/media/platform/rcar-vin/Makefile
> index 5ab803d..00d809f 100644
> --- a/drivers/media/platform/rcar-vin/Makefile
> +++ b/drivers/media/platform/rcar-vin/Makefile
> @@ -1,3 +1,4 @@
> +# SPDX-License-Identifier: GPL-2.0
>  rcar-vin-objs = rcar-core.o rcar-dma.o rcar-v4l2.o
>  
>  obj-$(CONFIG_VIDEO_RCAR_CSI2) += rcar-csi2.o
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index 8843367..ce09799 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Driver for Renesas R-Car VIN
>   *
> @@ -7,11 +8,6 @@
>   * Copyright (C) 2008 Magnus Damm
>   *
>   * Based on the soc-camera rcar_vin driver
> - *
> - * This program is free software; you can redistribute  it and/or modify it
> - * under  the terms of  the GNU General  Public License as published by the
> - * Free Software Foundation;  either version 2 of the  License, or (at your
> - * option) any later version.
>   */
>  
>  #include <linux/module.h>
> @@ -1275,4 +1271,4 @@ module_platform_driver(rcar_vin_driver);
>  
>  MODULE_AUTHOR("Niklas Söderlund <niklas.soderlund@ragnatech.se>");
>  MODULE_DESCRIPTION("Renesas R-Car VIN camera host driver");
> -MODULE_LICENSE("GPL v2");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> index 65917d2..84adebc 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Driver for Renesas R-Car VIN
>   *
> @@ -7,11 +8,6 @@
>   * Copyright (C) 2008 Magnus Damm
>   *
>   * Based on the soc-camera rcar_vin driver
> - *
> - * This program is free software; you can redistribute  it and/or modify it
> - * under  the terms of  the GNU General  Public License as published by the
> - * Free Software Foundation;  either version 2 of the  License, or (at your
> - * option) any later version.
>   */
>  
>  #include <linux/delay.h>
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index f8f0519..37d35a2 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Driver for Renesas R-Car VIN
>   *
> @@ -7,11 +8,6 @@
>   * Copyright (C) 2008 Magnus Damm
>   *
>   * Based on the soc-camera rcar_vin driver
> - *
> - * This program is free software; you can redistribute  it and/or modify it
> - * under  the terms of  the GNU General  Public License as published by the
> - * Free Software Foundation;  either version 2 of the  License, or (at your
> - * option) any later version.
>   */
>  
>  #include <linux/pm_runtime.h>
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
> index 57117da..f684e47 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
>  /*
>   * Driver for Renesas R-Car VIN
>   *
> @@ -7,11 +8,6 @@
>   * Copyright (C) 2008 Magnus Damm
>   *
>   * Based on the soc-camera rcar_vin driver
> - *
> - * This program is free software; you can redistribute  it and/or modify it
> - * under  the terms of  the GNU General  Public License as published by the
> - * Free Software Foundation;  either version 2 of the  License, or (at your
> - * option) any later version.
>   */
>  
>  #ifndef __RCAR_VIN__
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
