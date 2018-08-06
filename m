Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35566 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726746AbeHFLL2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2018 07:11:28 -0400
Received: by mail-lf1-f66.google.com with SMTP id f18-v6so8514895lfc.2
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2018 02:03:22 -0700 (PDT)
Date: Mon, 6 Aug 2018 11:03:20 +0200
From: =?iso-8859-1?Q?=22Niklas_S=F6derlund=22?=
        <niklas.soderlund@ragnatech.se>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran@ksquared.org.uk>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 4/8] media: adv748x: convert to SPDX identifiers
Message-ID: <20180806090320.GB15583@bigcity.dyn.berto.se>
References: <87h8k8nqcf.wl-kuninori.morimoto.gx@renesas.com>
 <87bmagnq8d.wl-kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87bmagnq8d.wl-kuninori.morimoto.gx@renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Morimoto-san,

Thanks for your patch.

On 2018-08-06 03:17:48 +0000, Kuninori Morimoto wrote:
> 
> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> 
> As original license mentioned, it is GPL-2.0+ in SPDX.
> Then, MODULE_LICENSE() should be "GPL" instead of "GPL v2".
> See ${LINUX}/include/linux/module.h
> 
> 	"GPL"		[GNU Public License v2 or later]
> 	"GPL v2"	[GNU Public License v2]
> 
> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/i2c/adv748x/adv748x-afe.c  | 6 +-----
>  drivers/media/i2c/adv748x/adv748x-core.c | 8 ++------
>  drivers/media/i2c/adv748x/adv748x-csi2.c | 6 +-----
>  drivers/media/i2c/adv748x/adv748x-hdmi.c | 6 +-----
>  drivers/media/i2c/adv748x/adv748x.h      | 6 +-----
>  5 files changed, 6 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c b/drivers/media/i2c/adv748x/adv748x-afe.c
> index edd25e8..6e6ea1d 100644
> --- a/drivers/media/i2c/adv748x/adv748x-afe.c
> +++ b/drivers/media/i2c/adv748x/adv748x-afe.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Driver for Analog Devices ADV748X 8 channel analog front end (AFE) receiver
>   * with standard definition processor (SDP)
>   *
>   * Copyright (C) 2017 Renesas Electronics Corp.
> - *
> - * This program is free software; you can redistribute  it and/or modify it
> - * under  the terms of  the GNU General  Public License as published by the
> - * Free Software Foundation;  either version 2 of the  License, or (at your
> - * option) any later version.
>   */
>  
>  #include <linux/delay.h>
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> index 6ca88daa..85c027b 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Driver for Analog Devices ADV748X HDMI receiver with AFE
>   *
>   * Copyright (C) 2017 Renesas Electronics Corp.
>   *
> - * This program is free software; you can redistribute  it and/or modify it
> - * under  the terms of  the GNU General  Public License as published by the
> - * Free Software Foundation;  either version 2 of the  License, or (at your
> - * option) any later version.
> - *
>   * Authors:
>   *	Koji Matsuoka <koji.matsuoka.xm@renesas.com>
>   *	Niklas Söderlund <niklas.soderlund@ragnatech.se>
> @@ -755,4 +751,4 @@ module_i2c_driver(adv748x_driver);
>  
>  MODULE_AUTHOR("Kieran Bingham <kieran.bingham@ideasonboard.com>");
>  MODULE_DESCRIPTION("ADV748X video decoder");
> -MODULE_LICENSE("GPL v2");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> index 469be87..265d9f5 100644
> --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> @@ -1,12 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Driver for Analog Devices ADV748X CSI-2 Transmitter
>   *
>   * Copyright (C) 2017 Renesas Electronics Corp.
> - *
> - * This program is free software; you can redistribute  it and/or modify it
> - * under  the terms of  the GNU General  Public License as published by the
> - * Free Software Foundation;  either version 2 of the  License, or (at your
> - * option) any later version.
>   */
>  
>  #include <linux/module.h>
> diff --git a/drivers/media/i2c/adv748x/adv748x-hdmi.c b/drivers/media/i2c/adv748x/adv748x-hdmi.c
> index aecc2a8..2641deb 100644
> --- a/drivers/media/i2c/adv748x/adv748x-hdmi.c
> +++ b/drivers/media/i2c/adv748x/adv748x-hdmi.c
> @@ -1,12 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Driver for Analog Devices ADV748X HDMI receiver and Component Processor (CP)
>   *
>   * Copyright (C) 2017 Renesas Electronics Corp.
> - *
> - * This program is free software; you can redistribute  it and/or modify it
> - * under  the terms of  the GNU General  Public License as published by the
> - * Free Software Foundation;  either version 2 of the  License, or (at your
> - * option) any later version.
>   */
>  
>  #include <linux/module.h>
> diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
> index 65f8374..c9016ac 100644
> --- a/drivers/media/i2c/adv748x/adv748x.h
> +++ b/drivers/media/i2c/adv748x/adv748x.h
> @@ -1,13 +1,9 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
>  /*
>   * Driver for Analog Devices ADV748X video decoder and HDMI receiver
>   *
>   * Copyright (C) 2017 Renesas Electronics Corp.
>   *
> - * This program is free software; you can redistribute  it and/or modify it
> - * under  the terms of  the GNU General  Public License as published by the
> - * Free Software Foundation;  either version 2 of the  License, or (at your
> - * option) any later version.
> - *
>   * Authors:
>   *	Koji Matsuoka <koji.matsuoka.xm@renesas.com>
>   *	Niklas Söderlund <niklas.soderlund@ragnatech.se>
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
