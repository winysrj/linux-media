Return-path: <linux-media-owner@vger.kernel.org>
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:55799
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753477Ab1LNJcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Dec 2011 04:32:12 -0500
Message-ID: <4EE86CF7.1010002@compulab.co.il>
Date: Wed, 14 Dec 2011 11:31:35 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
MIME-Version: 1.0
To: Martin Hostettler <martin@neutronstar.dyndns.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
	Hiremath Vaibhav <hvaibhav@ti.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] arm: omap3evm: Add support for an MT9M032 based camera
 board.
References: <1323825934-13320-1-git-send-email-martin@neutronstar.dyndns.org>
In-Reply-To: <1323825934-13320-1-git-send-email-martin@neutronstar.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

On 12/14/11 03:25, Martin Hostettler wrote:
> Adds board support for an MT9M032 based camera to omap3evm.
> 
> Signed-off-by: Martin Hostettler <martin@neutronstar.dyndns.org>
> ---
>  arch/arm/mach-omap2/Makefile                |    3 +-
>  arch/arm/mach-omap2/board-omap3evm-camera.c |  155 +++++++++++++++++++++++++++
>  arch/arm/mach-omap2/board-omap3evm.c        |    4 +
>  3 files changed, 161 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/mach-omap2/board-omap3evm-camera.c
> 
> Changes in V3
>  * Added missing copyright and attribution.
>  * switched to gpio_request_array for gpio init.
>  * removed device_initcall and added call to omap3_evm_camera_init into omap3_evm_init
> 
> Changes in V2:
>  * ported to current mainline
>  * Style fixes
>  * Fix error handling
> 
> diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
> index b009f17..6045789 100644
> --- a/arch/arm/mach-omap2/Makefile
> +++ b/arch/arm/mach-omap2/Makefile
> @@ -196,7 +196,8 @@ obj-$(CONFIG_MACH_OMAP3530_LV_SOM)      += board-omap3logic.o
>  obj-$(CONFIG_MACH_OMAP3_TORPEDO)        += board-omap3logic.o
>  obj-$(CONFIG_MACH_ENCORE)		+= board-omap3encore.o
>  obj-$(CONFIG_MACH_OVERO)		+= board-overo.o
> -obj-$(CONFIG_MACH_OMAP3EVM)		+= board-omap3evm.o
> +obj-$(CONFIG_MACH_OMAP3EVM)		+= board-omap3evm.o \
> +					   board-omap3evm-camera.o
>  obj-$(CONFIG_MACH_OMAP3_PANDORA)	+= board-omap3pandora.o
>  obj-$(CONFIG_MACH_OMAP_3430SDP)		+= board-3430sdp.o
>  obj-$(CONFIG_MACH_NOKIA_N8X0)		+= board-n8x0.o
> diff --git a/arch/arm/mach-omap2/board-omap3evm-camera.c b/arch/arm/mach-omap2/board-omap3evm-camera.c
> new file mode 100644
> index 0000000..bffd5b8
> --- /dev/null
> +++ b/arch/arm/mach-omap2/board-omap3evm-camera.c
> @@ -0,0 +1,155 @@
> +/*
> + * Copyright (C) 2011 Texas Instruments Inc
> + * Copyright (C) 2010-2011 Lund Engineering
> + * Contact: Gil Lund <gwlund@lundeng.com>
> + * Authors:
> + *    Vaibhav Hiremath <hvaibhav@ti.com>
> + *    Martin Hostettler <martin@neutronstar.dyndns.org>
> + *
> + * Board intregration for a MT9M032 camera connected to IMAGE_CONN and I2C Bus 2
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + */
> +
> +#include <linux/i2c.h>
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +
> +#include <linux/gpio.h>
> +#include <plat/mux.h>
> +#include "mux.h"
> +
> +#include "../../../drivers/media/video/omap3isp/isp.h"

Laurent,
In one of the previous reviews, you stated:
"I'll probably split it and move the part required by board files to 
include/media/omap3isp.h".
Is there any progress on that?

> +#include "media/mt9m032.h"
> +
> +#include "devices.h"
> +
> +#define EVM_TWL_GPIO_BASE OMAP_MAX_GPIO_LINES
> +#define GPIO98_VID_DEC_RES	98
> +#define nCAM_VD_SEL		157
> +
> +#define MT9M032_I2C_BUS_NUM	2
> +
> +
> +enum omap3evmdc_mux {
> +	MUX_TVP5146,
> +	MUX_CAMERA_SENSOR,
> +	MUX_EXP_CAMERA_SENSOR,
> +};
> +
> +/**
> + * omap3evm_set_mux - Sets mux to enable signal routing to
> + *                           different peripherals present on new EVM board
> + * @mux_id: enum, mux id to enable
> + *
> + * Returns 0 for success or a negative error code
> + */
> +static int omap3evm_set_mux(enum omap3evmdc_mux mux_id)
> +{
> +	/* Set GPIO6 = 1 */
> +	gpio_set_value_cansleep(EVM_TWL_GPIO_BASE + 6, 1);
> +	gpio_set_value_cansleep(EVM_TWL_GPIO_BASE + 2, 0);
> +
> +	switch (mux_id) {
> +	case MUX_TVP5146:
> +		gpio_set_value_cansleep(EVM_TWL_GPIO_BASE + 2, 0);
> +		gpio_set_value(nCAM_VD_SEL, 1);
> +		break;
> +
> +	case MUX_CAMERA_SENSOR:
> +		gpio_set_value_cansleep(EVM_TWL_GPIO_BASE + 2, 0);
> +		gpio_set_value(nCAM_VD_SEL, 0);
> +		break;
> +
> +	case MUX_EXP_CAMERA_SENSOR:
> +		gpio_set_value_cansleep(EVM_TWL_GPIO_BASE + 2, 1);
> +		break;
> +
> +	default:
> +		pr_err("omap3evm-camera: Invalid mux id #%d\n", mux_id);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}

I don't really care about that, but I don't see any mux
being set in the above function so the name and comments
are misleading.

> +
> +static struct mt9m032_platform_data mt9m032_platform_data = {
> +	.ext_clock = 13500000,
> +	.pll_pre_div = 6,
> +	.pll_mul = 120,
> +	.pll_out_div = 5,
> +	.invert_pixclock = 1,
> +};
> +
> +static struct i2c_board_info camera_i2c_devices[] = {
> +	{
> +		I2C_BOARD_INFO(MT9M032_NAME, MT9M032_I2C_ADDR),
> +		.platform_data = &mt9m032_platform_data,
> +	},
> +};
> +
> +static struct isp_subdev_i2c_board_info camera_i2c_subdevs[] = {
> +	{
> +		.board_info = &camera_i2c_devices[0],
> +		.i2c_adapter_id = MT9M032_I2C_BUS_NUM,
> +	},
> +	{},
> +};
> +
> +static struct isp_v4l2_subdevs_group camera_subdevs[] = {
> +	{
> +		.subdevs = camera_i2c_subdevs,
> +		.interface = ISP_INTERFACE_PARALLEL,
> +		.bus = {
> +			.parallel = {
> +				.data_lane_shift = 1,
> +				.clk_pol = 0,
> +				.bridge = ISPCTRL_PAR_BRIDGE_DISABLE,
> +			}
> +		},
> +	},
> +	{},
> +};
> +
> +static struct isp_platform_data isp_platform_data = {
> +	.subdevs = camera_subdevs,
> +};
> +
> +
> +static struct gpio setup_gpios[] = {
> +	{ nCAM_VD_SEL,           GPIOF_OUT_INIT_HIGH, "nCAM_VD_SEL" },
> +	{ EVM_TWL_GPIO_BASE + 2, GPIOF_OUT_INIT_LOW,  "T2_GPIO2" },
> +	{ EVM_TWL_GPIO_BASE + 8, GPIOF_OUT_INIT_LOW, "nCAM_VD_EN" },
> +};
> +
> +
> +int __init omap3_evm_camera_init(void)
> +{
> +	int ret = -EINVAL;

No need to initialize the variable, as it is done three line below.

> +
> +	omap_mux_init_gpio(nCAM_VD_SEL, OMAP_PIN_OUTPUT);
> +	ret = gpio_request_array(setup_gpios, ARRAY_SIZE(setup_gpios));
> +	if (ret < 0) {
> +		pr_err("omap3evm-camera: Failed to setup camera signal routing.\n");
> +		return ret;
> +	}

It looks like both above calls (gpio_request and mux_init)
can be moved to omap3evm_set_mux() function (or a renamed version of it),
so all the GPIO stuff will be close to each other instead of requesting
in one place and playing with values in another...

> +	omap3evm_set_mux(MUX_CAMERA_SENSOR);

So the plan is to add support for the 3 types,
but hard code to only one?
Can't this be runtime detected somehow?

> +	ret = omap3_init_camera(&isp_platform_data);
> +	if (ret < 0) {
> +		gpio_free_array(setup_gpios, ARRAY_SIZE(setup_gpios));
> +		return ret;
> +	}
> +	return 0;
> +}
> diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
> index ec00b2e..1b50539 100644
> --- a/arch/arm/mach-omap2/board-omap3evm.c
> +++ b/arch/arm/mach-omap2/board-omap3evm.c
> @@ -617,6 +617,8 @@ static struct gpio omap3_evm_ehci_gpios[] __initdata = {
>  	{ OMAP3_EVM_EHCI_SELECT, GPIOF_OUT_INIT_LOW,   "select EHCI port" },
>  };
>  
> +int omap3_evm_camera_init(void);
> +
>  static void __init omap3_evm_init(void)
>  {
>  	omap3_evm_get_revision();
> @@ -672,6 +674,8 @@ static void __init omap3_evm_init(void)
>  		pr_err("error setting wl12xx data\n");
>  	platform_device_register(&omap3evm_wlan_regulator);
>  #endif
> +
> +	omap3_evm_camera_init();
>  }
>  
>  MACHINE_START(OMAP3EVM, "OMAP3 EVM")

-- 
Regards,
Igor.
