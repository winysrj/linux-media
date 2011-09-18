Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45833 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255Ab1IRV6w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Sep 2011 17:58:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: Re: [PATCH v2] arm: omap3evm: Add support for an MT9M032 based camera board.
Date: Sun, 18 Sep 2011 23:58:55 +0200
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1316252097-4213-1-git-send-email-martin@neutronstar.dyndns.org>
In-Reply-To: <1316252097-4213-1-git-send-email-martin@neutronstar.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109182358.55816.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

On Saturday 17 September 2011 11:34:57 Martin Hostettler wrote:
> Adds board support for an MT9M032 based camera to omap3evm.
> 
> Sigend-off-by: Martin Hostettler <martin@neutronstar.dyndns.org>
> ---
>  arch/arm/mach-omap2/Makefile                |    1 +
>  arch/arm/mach-omap2/board-omap3evm-camera.c |  183
> +++++++++++++++++++++++++++ 2 files changed, 184 insertions(+), 0
> deletions(-)
>  create mode 100644 arch/arm/mach-omap2/board-omap3evm-camera.c
> 
> Changes in V2:
>  * ported to current mainline
>  * Style fixes
>  * Fix error handling
> 
> diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
> index f343365..8ae3d25 100644
> --- a/arch/arm/mach-omap2/Makefile
> +++ b/arch/arm/mach-omap2/Makefile
> @@ -202,6 +202,7 @@ obj-$(CONFIG_MACH_OMAP3_TORPEDO)        +=
> board-omap3logic.o \ obj-$(CONFIG_MACH_OVERO)		+= board-overo.o \
>  					   hsmmc.o
>  obj-$(CONFIG_MACH_OMAP3EVM)		+= board-omap3evm.o \
> +					   board-omap3evm-camera.o \
>  					   hsmmc.o
>  obj-$(CONFIG_MACH_OMAP3_PANDORA)	+= board-omap3pandora.o \
>  					   hsmmc.o
> diff --git a/arch/arm/mach-omap2/board-omap3evm-camera.c
> b/arch/arm/mach-omap2/board-omap3evm-camera.c new file mode 100644
> index 0000000..be987d9
> --- /dev/null
> +++ b/arch/arm/mach-omap2/board-omap3evm-camera.c
> @@ -0,0 +1,183 @@
> +/*
> + * Copyright (C) 2010-2011 Lund Engineering
> + * Contact: Gil Lund <gwlund@lundeng.com>
> + * Author: Martin Hostettler <martin@neutronstar.dyndns.org>
> + *
> + * Board intregration for a MT9M032 camera connected to IMAGE_CONN and I2C
> Bus 2 + *
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
> + *                           different peripherals present on new EVM
> board + * @mux_id: enum, mux id to enable
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
> +static int __init camera_init(void)
> +{
> +	int ret = -EINVAL;
> +
> +	omap_mux_init_gpio(nCAM_VD_SEL, OMAP_PIN_OUTPUT);
> +	if (gpio_request(nCAM_VD_SEL, "nCAM_VD_SEL") < 0) {
> +		pr_err("omap3evm-camera: Failed to get GPIO nCAM_VD_SEL(%d)\n",
> +		       nCAM_VD_SEL);
> +		goto err;
> +	}
> +	if (gpio_direction_output(nCAM_VD_SEL, 1) < 0) {
> +		pr_err("omap3evm-camera: Failed to set GPIO nCAM_VD_SEL(%d)
> direction\n", +		       nCAM_VD_SEL);
> +		goto err_vdsel;
> +	}
> +
> +	if (gpio_request(EVM_TWL_GPIO_BASE + 2, "T2_GPIO2") < 0) {
> +		pr_err("omap3evm-camera: Failed to get GPIO T2_GPIO2(%d)\n",
> +		       EVM_TWL_GPIO_BASE + 2);
> +		goto err_vdsel;
> +	}
> +	if (gpio_direction_output(EVM_TWL_GPIO_BASE + 2, 0) < 0) {
> +		pr_err("omap3evm-camera: Failed to set GPIO T2_GPIO2(%d) direction\n",
> +		       EVM_TWL_GPIO_BASE + 2);
> +		goto err_2;
> +	}
> +
> +	if (gpio_request(EVM_TWL_GPIO_BASE + 8, "nCAM_VD_EN") < 0) {
> +		pr_err("omap3evm-camera: Failed to get GPIO nCAM_VD_EN(%d)\n",
> +		       EVM_TWL_GPIO_BASE + 8);
> +		goto err_2;
> +	}
> +	if (gpio_direction_output(EVM_TWL_GPIO_BASE + 8, 0) < 0) {
> +		pr_err("omap3evm-camera: Failed to set GPIO nCAM_VD_EN(%d) direction\n",
> +		       EVM_TWL_GPIO_BASE + 8);
> +		goto err_8;
> +	}
> +
> +	omap3evm_set_mux(MUX_CAMERA_SENSOR);
> +
> +
> +	ret = omap3_init_camera(&isp_platform_data);
> +	if (ret < 0)
> +		goto err_8;
> +	return 0;
> +
> +err_8:
> +	gpio_free(EVM_TWL_GPIO_BASE + 8);
> +err_2:
> +	gpio_free(EVM_TWL_GPIO_BASE + 2);
> +err_vdsel:
> +	gpio_free(nCAM_VD_SEL);
> +err:
> +	return ret;
> +}
> +
> +device_initcall(camera_init);

Please don't use device_initcall(), but call the function directly from the 
OMAP3 EVM init handler. Otherwise camera_init() will be called if OMAP3 EVM 
support is compiled in the kernel, regardless of the board the kernel runs on.

-- 
Regards,

Laurent Pinchart
