Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab0BSLw3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2010 06:52:29 -0500
Message-ID: <4B7E7B75.3040205@redhat.com>
Date: Fri, 19 Feb 2010 09:52:21 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	sameo@linux.intel.com
Subject: Re: [PATCH] mfd: Add timb-radio to the timberdale MFD
References: <4B7845F0.1070800@pelagicore.com>
In-Reply-To: <4B7845F0.1070800@pelagicore.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Richard Röjfors wrote:
> This patch addes timb-radio to all configurations of the timberdale MFD.
> 
> Connected to the FPGA is a TEF6862 tuner and a SAA7706H DSP, the I2C
> board info of these devices is passed via the timb-radio platform data.

Hi Richard,

I'm trying to apply it to my git tree (http://git.linuxtv.org/v4l-dvb.git),
but it is failing:

patching file drivers/mfd/timberdale.c
Hunk #1 FAILED at 37.
Hunk #2 FAILED at 215.
Hunk #3 FAILED at 276.
Hunk #4 FAILED at 325.
Hunk #5 FAILED at 364.
Hunk #6 FAILED at 405.
6 out of 6 hunks FAILED -- saving rejects to file drivers/mfd/timberdale.c.rej
Patch doesn't apply

Could you please verify what's going wrong?	

> 
> Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
> ---
> diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
> index 603cf06..1ed44d2 100644
> --- a/drivers/mfd/timberdale.c
> +++ b/drivers/mfd/timberdale.c
> @@ -37,6 +37,8 @@
>  #include <linux/spi/max7301.h>
>  #include <linux/spi/mc33880.h>
> 
> +#include <media/timb_radio.h>
> +
>  #include "timberdale.h"
> 
>  #define DRIVER_NAME "timberdale"
> @@ -213,6 +215,40 @@ const static __devinitconst struct resource
> timberdale_uartlite_resources[] = {
>      },
>  };
> 
> +const static __devinitconst struct resource
> timberdale_radio_resources[] = {
> +    {
> +        .start    = RDSOFFSET,
> +        .end    = RDSEND,
> +        .flags    = IORESOURCE_MEM,
> +    },
> +    {
> +        .start    = IRQ_TIMBERDALE_RDS,
> +        .end    = IRQ_TIMBERDALE_RDS,
> +        .flags    = IORESOURCE_IRQ,
> +    },
> +};
> +
> +static __devinitdata struct i2c_board_info
> timberdale_tef6868_i2c_board_info = {
> +    I2C_BOARD_INFO("tef6862", 0x60)
> +};
> +
> +static __devinitdata struct i2c_board_info
> timberdale_saa7706_i2c_board_info = {
> +    I2C_BOARD_INFO("saa7706h", 0x1C)
> +};
> +
> +static __devinitdata struct timb_radio_platform_data
> +    timberdale_radio_platform_data = {
> +    .i2c_adapter = 0,
> +    .tuner = {
> +        .module_name = "tef6862",
> +        .info = &timberdale_tef6868_i2c_board_info
> +    },
> +    .dsp = {
> +        .module_name = "saa7706h",
> +        .info = &timberdale_saa7706_i2c_board_info
> +    }
> +};
> +
>  const static __devinitconst struct resource timberdale_dma_resources[] = {
>      {
>          .start    = DMAOFFSET,
> @@ -240,6 +276,13 @@ static __devinitdata struct mfd_cell
> timberdale_cells_bar0_cfg0[] = {
>          .data_size = sizeof(timberdale_gpio_platform_data),
>      },
>      {
> +        .name = "timb-radio",
> +        .num_resources = ARRAY_SIZE(timberdale_radio_resources),
> +        .resources = timberdale_radio_resources,
> +        .platform_data = &timberdale_radio_platform_data,
> +        .data_size = sizeof(timberdale_radio_platform_data),
> +    },
> +    {
>          .name = "xilinx_spi",
>          .num_resources = ARRAY_SIZE(timberdale_spi_resources),
>          .resources = timberdale_spi_resources,
> @@ -282,6 +325,13 @@ static __devinitdata struct mfd_cell
> timberdale_cells_bar0_cfg1[] = {
>          .resources = timberdale_mlogicore_resources,
>      },
>      {
> +        .name = "timb-radio",
> +        .num_resources = ARRAY_SIZE(timberdale_radio_resources),
> +        .resources = timberdale_radio_resources,
> +        .platform_data = &timberdale_radio_platform_data,
> +        .data_size = sizeof(timberdale_radio_platform_data),
> +    },
> +    {
>          .name = "xilinx_spi",
>          .num_resources = ARRAY_SIZE(timberdale_spi_resources),
>          .resources = timberdale_spi_resources,
> @@ -314,6 +364,13 @@ static __devinitdata struct mfd_cell
> timberdale_cells_bar0_cfg2[] = {
>          .data_size = sizeof(timberdale_gpio_platform_data),
>      },
>      {
> +        .name = "timb-radio",
> +        .num_resources = ARRAY_SIZE(timberdale_radio_resources),
> +        .resources = timberdale_radio_resources,
> +        .platform_data = &timberdale_radio_platform_data,
> +        .data_size = sizeof(timberdale_radio_platform_data),
> +    },
> +    {
>          .name = "xilinx_spi",
>          .num_resources = ARRAY_SIZE(timberdale_spi_resources),
>          .resources = timberdale_spi_resources,
> @@ -348,6 +405,13 @@ static __devinitdata struct mfd_cell
> timberdale_cells_bar0_cfg3[] = {
>          .data_size = sizeof(timberdale_gpio_platform_data),
>      },
>      {
> +        .name = "timb-radio",
> +        .num_resources = ARRAY_SIZE(timberdale_radio_resources),
> +        .resources = timberdale_radio_resources,
> +        .platform_data = &timberdale_radio_platform_data,
> +        .data_size = sizeof(timberdale_radio_platform_data),
> +    },
> +    {
>          .name = "xilinx_spi",
>          .num_resources = ARRAY_SIZE(timberdale_spi_resources),
>          .resources = timberdale_spi_resources,
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
