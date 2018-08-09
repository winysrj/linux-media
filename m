Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:32799 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730090AbeHIPKe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2018 11:10:34 -0400
Received: by mail-wr1-f68.google.com with SMTP id g6-v6so5060796wrp.0
        for <linux-media@vger.kernel.org>; Thu, 09 Aug 2018 05:45:48 -0700 (PDT)
Subject: Re: [PATCH 4/8] media: adv748x: convert to SPDX identifiers
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <87h8k8nqcf.wl-kuninori.morimoto.gx@renesas.com>
 <87bmagnq8d.wl-kuninori.morimoto.gx@renesas.com>
From: Kieran Bingham <kieran@ksquared.org.uk>
Message-ID: <a0069acc-8894-d6c8-ce0b-0d3c254ee4fa@bingham.xyz>
Date: Thu, 9 Aug 2018 13:45:46 +0100
MIME-Version: 1.0
In-Reply-To: <87bmagnq8d.wl-kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Morimoto-san,

Aha, I thought I was going to have to do this.

But you've beaten me to it :)

On 06/08/18 04:17, Kuninori Morimoto wrote:
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

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

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
> 
