Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756552Ab2CSWDz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 18:03:55 -0400
Message-ID: <4F67AD31.8030500@redhat.com>
Date: Mon, 19 Mar 2012 19:03:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Alex Gershgorin <alexg@meprolight.com>
CC: Sascha Hauer <s.hauer@pengutronix.de>,
	linux-kernel@vger.kernel.org, g.liakhovetski@gmx.de,
	fabio.estevam@freescale.com, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1] i.MX35-PDK: Add Camera support
References: <1331651129-30540-1-git-send-email-alexg@meprolight.com>
In-Reply-To: <1331651129-30540-1-git-send-email-alexg@meprolight.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 13-03-2012 12:05, Alex Gershgorin escreveu:
> In i.MX35-PDK, OV2640  camera is populated on the
> personality board. This camera is registered as a subdevice via soc-camera interface.
> 
> Signed-off-by: Alex Gershgorin <alexg@meprolight.com>

Patch doesn't apply over v3.3:

patching file arch/arm/mach-imx/mach-mx35_3ds.c
Hunk #3 FAILED at 149.
Hunk #4 succeeded at 126 with fuzz 1 (offset -55 lines).
Hunk #5 FAILED at 323.
Hunk #6 succeeded at 277 (offset -57 lines).
Hunk #7 succeeded at 293 (offset -57 lines).
2 out of 7 hunks FAILED -- saving rejects to file arch/arm/mach-imx/mach-mx35_3ds.c.rej
 arch/arm/mach-imx/mach-mx35_3ds.c |   87 ++++++++++++++++++++++++++++++++++++++


> ---
>  arch/arm/mach-imx/mach-mx35_3ds.c |   96 +++++++++++++++++++++++++++++++++++++
>  1 files changed, 96 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/mach-mx35_3ds.c b/arch/arm/mach-imx/mach-mx35_3ds.c
> index 0af6c9c..a7dd8e6 100644
> --- a/arch/arm/mach-imx/mach-mx35_3ds.c
> +++ b/arch/arm/mach-imx/mach-mx35_3ds.c
> @@ -4,6 +4,11 @@
>   *
>   * Author: Fabio Estevam <fabio.estevam@freescale.com>
>   *
> + * Copyright (C) 2011 Meprolight, Ltd.
> + * Alex Gershgorin <alexg@meprolight.com>
> + *
> + * Modified from i.MX31 3-Stack Development System
> + *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
>   * the Free Software Foundation; either version 2 of the License, or
> @@ -34,6 +39,7 @@
>  #include <asm/mach/arch.h>
>  #include <asm/mach/time.h>
>  #include <asm/mach/map.h>
> +#include <asm/memblock.h>
>  
>  #include <mach/hardware.h>
>  #include <mach/common.h>
> @@ -41,6 +47,8 @@
>  #include <mach/irqs.h>
>  #include <mach/3ds_debugboard.h>
>  
> +#include <media/soc_camera.h>
> +
>  #include "devices-imx35.h"
>  
>  #define EXPIO_PARENT_INT	gpio_to_irq(IMX_GPIO_NR(1, 1))
> @@ -120,6 +128,83 @@ static iomux_v3_cfg_t mx35pdk_pads[] = {
>  	/* I2C1 */
>  	MX35_PAD_I2C1_CLK__I2C1_SCL,
>  	MX35_PAD_I2C1_DAT__I2C1_SDA,
> +	/* CSI */
> +	MX35_PAD_TX1__IPU_CSI_D_6,
> +	MX35_PAD_TX0__IPU_CSI_D_7,
> +	MX35_PAD_CSI_D8__IPU_CSI_D_8,
> +	MX35_PAD_CSI_D9__IPU_CSI_D_9,
> +	MX35_PAD_CSI_D10__IPU_CSI_D_10,
> +	MX35_PAD_CSI_D11__IPU_CSI_D_11,
> +	MX35_PAD_CSI_D12__IPU_CSI_D_12,
> +	MX35_PAD_CSI_D13__IPU_CSI_D_13,
> +	MX35_PAD_CSI_D14__IPU_CSI_D_14,
> +	MX35_PAD_CSI_D15__IPU_CSI_D_15,
> +	MX35_PAD_CSI_HSYNC__IPU_CSI_HSYNC,
> +	MX35_PAD_CSI_MCLK__IPU_CSI_MCLK,
> +	MX35_PAD_CSI_PIXCLK__IPU_CSI_PIXCLK,
> +	MX35_PAD_CSI_VSYNC__IPU_CSI_VSYNC,
> +};
> +
> +/*
> + * Camera support
> +*/
> +static phys_addr_t mx3_camera_base __initdata;
> +#define MX35_3DS_CAMERA_BUF_SIZE SZ_8M
> +
> +static const struct mx3_camera_pdata mx35_3ds_camera_pdata __initconst = {
> +	.flags = MX3_CAMERA_DATAWIDTH_8,
> +	.mclk_10khz = 2000,
> +};
> +
> +static int __init imx35_3ds_init_camera(void)
> +{
> +	int dma, ret = -ENOMEM;
> +	struct platform_device *pdev =
> +		imx35_alloc_mx3_camera(&mx35_3ds_camera_pdata);
> +
> +	if (IS_ERR(pdev))
> +		return PTR_ERR(pdev);
> +
> +	if (!mx3_camera_base)
> +		goto err;
> +
> +	dma = dma_declare_coherent_memory(&pdev->dev,
> +					mx3_camera_base, mx3_camera_base,
> +					MX35_3DS_CAMERA_BUF_SIZE,
> +					DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);
> +
> +	if (!(dma & DMA_MEMORY_MAP))
> +		goto err;
> +
> +	ret = platform_device_add(pdev);
> +	if (ret)
> +err:
> +		platform_device_put(pdev);
> +
> +	return ret;
> +}
> +
> +static const struct ipu_platform_data mx35_3ds_ipu_data __initconst = {
> +	.irq_base = MXC_IPU_IRQ_START,
> +};
> +
> +static struct i2c_board_info mx35_3ds_i2c_camera = {
> +	I2C_BOARD_INFO("ov2640", 0x30),
> +};
> +
> +static struct soc_camera_link iclink_ov2640 = {
> +	.bus_id		= 0,
> +	.board_info	= &mx35_3ds_i2c_camera,
> +	.i2c_adapter_id	= 0,
> +	.power		= NULL,
> +};
> +
> +static struct platform_device mx35_3ds_ov2640 = {
> +	.name	= "soc-camera-pdrv",
> +	.id	= 0,
> +	.dev	= {
> +		.platform_data = &iclink_ov2640,
> +	},
>  };
>  
>  static int mx35_3ds_otg_init(struct platform_device *pdev)
> @@ -204,6 +289,9 @@ static void __init mx35_3ds_init(void)
>  		pr_warn("Init of the debugboard failed, all "
>  				"devices on the debugboard are unusable.\n");
>  	imx35_add_imx_i2c0(&mx35_3ds_i2c0_data);
> +	imx35_add_ipu_core(&mx35_3ds_ipu_data);
> +	platform_device_register(&mx35_3ds_ov2640);
> +	imx35_3ds_init_camera();
>  }
>  
>  static void __init mx35pdk_timer_init(void)
> @@ -215,6 +303,13 @@ struct sys_timer mx35pdk_timer = {
>  	.init	= mx35pdk_timer_init,
>  };
>  
> +static void __init mx35_3ds_reserve(void)
> +{
> +	/* reserve MX35_3DS_CAMERA_BUF_SIZE bytes for mx3-camera */
> +	mx3_camera_base = arm_memblock_steal(MX35_3DS_CAMERA_BUF_SIZE,
> +					 MX35_3DS_CAMERA_BUF_SIZE);
> +}
> +
>  MACHINE_START(MX35_3DS, "Freescale MX35PDK")
>  	/* Maintainer: Freescale Semiconductor, Inc */
>  	.atag_offset = 0x100,
> @@ -224,5 +319,6 @@ MACHINE_START(MX35_3DS, "Freescale MX35PDK")
>  	.handle_irq = imx35_handle_irq,
>  	.timer = &mx35pdk_timer,
>  	.init_machine = mx35_3ds_init,
> +	.reserve = mx35_3ds_reserve,
>  	.restart	= mxc_restart,
>  MACHINE_END

