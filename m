Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:41641 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S964922AbeGBKME (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jul 2018 06:12:04 -0400
Subject: Re: [PATCH v11 10/10] arch: sh: migor: Use new renesas-ceu camera
 driver
To: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, festevam@gmail.com,
        sakari.ailus@iki.fi, robh+dt@kernel.org, mark.rutland@arm.com,
        pombredanne@nexb.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1519295846-11612-1-git-send-email-jacopo+renesas@jmondi.org>
 <1519295846-11612-11-git-send-email-jacopo+renesas@jmondi.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3a262281-2f47-af79-970a-c8ec5ac82778@xs4all.nl>
Date: Mon, 2 Jul 2018 12:11:59 +0200
MIME-Version: 1.0
In-Reply-To: <1519295846-11612-11-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/02/18 11:37, Jacopo Mondi wrote:
> Migo-R platform uses sh_mobile_ceu camera driver, which is now being
> replaced by a proper V4L2 camera driver named 'renesas-ceu'.
> 
> Move Migo-R platform to use the v4l2 renesas-ceu camera driver
> interface and get rid of soc_camera defined components used to register
> sensor drivers and of platform specific enable/disable routines.
> 
> Register clock source and GPIOs for sensor drivers, so they can use
> clock and gpio APIs.
> 
> Also, memory for CEU video buffers is now reserved with membocks APIs,
> and need to be declared as dma_coherent during machine initialization to
> remove that architecture specific part from CEU driver.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  arch/sh/boards/mach-migor/setup.c      | 225 +++++++++++++++------------------
>  arch/sh/kernel/cpu/sh4a/clock-sh7722.c |   2 +-
>  2 files changed, 101 insertions(+), 126 deletions(-)
> 
> diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
> index 0bcbe58..271dfc2 100644
> --- a/arch/sh/boards/mach-migor/setup.c
> +++ b/arch/sh/boards/mach-migor/setup.c
> @@ -1,17 +1,16 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Renesas System Solutions Asia Pte. Ltd - Migo-R
>   *
>   * Copyright (C) 2008 Magnus Damm
> - *
> - * This file is subject to the terms and conditions of the GNU General Public
> - * License.  See the file "COPYING" in the main directory of this archive
> - * for more details.
>   */
> +#include <linux/clkdev.h>
>  #include <linux/init.h>
>  #include <linux/platform_device.h>
>  #include <linux/interrupt.h>
>  #include <linux/input.h>
>  #include <linux/input/sh_keysc.h>
> +#include <linux/memblock.h>
>  #include <linux/mmc/host.h>
>  #include <linux/mtd/physmap.h>
>  #include <linux/mfd/tmio.h>
> @@ -23,10 +22,11 @@
>  #include <linux/delay.h>
>  #include <linux/clk.h>
>  #include <linux/gpio.h>
> +#include <linux/gpio/machine.h>
>  #include <linux/videodev2.h>
>  #include <linux/sh_intc.h>
>  #include <video/sh_mobile_lcdc.h>
> -#include <media/drv-intf/sh_mobile_ceu.h>
> +#include <media/drv-intf/renesas-ceu.h>
>  #include <media/i2c/ov772x.h>
>  #include <media/soc_camera.h>

You left a stray soc_camera.h include here.

Can you make a patch that removes this and verify that everything compiles?

I also see CONFIG_SOC_CAMERA in several arch/sh/configs/*_defconfig files.
Should those be updated?

Regards,

	Hans
