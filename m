Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56524 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab2B0BGq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Feb 2012 20:06:46 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 33/33] rm680: Add camera init
Date: Mon, 27 Feb 2012 02:06:54 +0100
Message-ID: <2304066.XHbnXjxlmi@avalon>
In-Reply-To: <1329703032-31314-33-git-send-email-sakari.ailus@iki.fi>
References: <20120220015605.GI7784@valkosipuli.localdomain> <1329703032-31314-33-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Monday 20 February 2012 03:57:12 Sakari Ailus wrote:
> From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> 
> This currently introduces an extra file to the arch/arm/mach-omap2
> directory: board-rm680-camera.c. Keeping the device tree in mind, the
> context of the file could be represented as static data with one exception:
> the external clock to the sensor.
> 
> This external clock is provided by the OMAP 3 SoC and required by the
> sensor. The issue is that the clock originates from the ISP and not from
> PRCM block as the other clocks and thus is not supported by the clock
> framework. Otherwise the sensor driver could just clk_get() and clk_enable()
> it, just like the regulators and gpios.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> ---
>  arch/arm/mach-omap2/Makefile             |    3 +-
>  arch/arm/mach-omap2/board-rm680-camera.c |  375 +++++++++++++++++++++++++++
>  arch/arm/mach-omap2/board-rm680.c        |   38 +++
>  3 files changed, 415 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/mach-omap2/board-rm680-camera.c
> 

[snip]

> diff --git a/arch/arm/mach-omap2/board-rm680-camera.c
> b/arch/arm/mach-omap2/board-rm680-camera.c new file mode 100644
> index 0000000..5059821
> --- /dev/null
> +++ b/arch/arm/mach-omap2/board-rm680-camera.c

[snip]

> +#include <asm/mach-types.h>
> +#include <plat/omap-pm.h>
> +
> +#include <media/omap3isp.h>
> +#include <media/smiapp.h>
> +
> +#include "../../../drivers/media/video/omap3isp/isp.h"

Do we still need the private OMAP3 ISP header ? You can move the ISP_XCLK_* 
macros to the public header (and maybe rename them to OMAP3ISP_XCLK_*).

> +#include "devices.h"
> +
> +#define SEC_CAMERA_RESET_GPIO	97
> +
> +#define RM680_PRI_SENSOR	1
> +#define RM680_PRI_LENS		2
> +#define RM680_SEC_SENSOR	3
> +#define MAIN_CAMERA_XCLK	ISP_XCLK_A
> +#define SEC_CAMERA_XCLK		ISP_XCLK_B
> +
> +/*
> + *
> + * Main Camera Module EXTCLK
> + * Used by the sensor and the actuator driver.
> + *
> + */
> +static struct camera_xclk {
> +	u32 hz;
> +	u32 lock;
> +	u8 xclksel;
> +} cameras_xclk;
> +
> +static DEFINE_MUTEX(lock_xclk);
> +
> +static int rm680_update_xclk(struct v4l2_subdev *subdev, u32 hz, u32 which,
> +			     u8 xclksel)
> +{
> +	struct isp_device *isp = v4l2_dev_to_isp_device(subdev->v4l2_dev);
> +	int ret;
> +
> +	mutex_lock(&lock_xclk);
> +
> +	if (which == RM680_SEC_SENSOR) {
> +		if (cameras_xclk.xclksel == MAIN_CAMERA_XCLK) {
> +			ret = -EBUSY;
> +			goto done;
> +		}
> +	} else {
> +		if (cameras_xclk.xclksel == SEC_CAMERA_XCLK) {
> +			ret = -EBUSY;
> +			goto done;
> +		}
> +	}
> +
> +	if (hz) {	/* Turn on */
> +		cameras_xclk.lock |= which;
> +		if (cameras_xclk.hz == 0) {
> +			isp->platform_cb.set_xclk(isp, hz, xclksel);
> +			cameras_xclk.hz = hz;
> +			cameras_xclk.xclksel = xclksel;
> +		}
> +	} else {	/* Turn off */
> +		cameras_xclk.lock &= ~which;
> +		if (cameras_xclk.lock == 0) {
> +			isp->platform_cb.set_xclk(isp, 0, xclksel);
> +			cameras_xclk.hz = 0;
> +			cameras_xclk.xclksel = 0;
> +		}
> +	}
> +
> +	ret = cameras_xclk.hz;
> +
> +done:
> +	mutex_unlock(&lock_xclk);
> +	return ret;
> +}

I don't like this, but we can't do much better until the generic struct clk is 
available :-) However, in addition to handling the ISP clocks, the above code 
also prevents the two sensors from being used at the same time. This won't be 
handle by the clock framework and will need to be implemented somewhere else. 
Shouldn't we already split the two functions ?

> +
> +/*
> + *
> + * Main Camera Sensor
> + *
> + */
> +
> +static int rm680_main_camera_set_xclk(struct v4l2_subdev *sd, int hz)
> +{
> +	return rm680_update_xclk(sd, hz, RM680_PRI_SENSOR, MAIN_CAMERA_XCLK);
> +}
> +
> +static struct smiapp_flash_strobe_parms rm680_main_camera_strobe_setup = {
> +	.mode			= 0x0c,
> +	.strobe_width_high_us	= 100000,
> +	.strobe_delay		= 0,
> +	.stobe_start_point	= 0,
> +	.trigger		= 0,
> +};
> +
> +static struct smiapp_platform_data rm696_main_camera_platform_data = {
> +	.i2c_addr_dfl		= SMIAPP_DFL_I2C_ADDR,
> +	.i2c_addr_alt		= SMIAPP_ALT_I2C_ADDR,
> +	.nvm_size		= 16 * 64,
> +	.ext_clk		= (9.6 * 1000 * 1000),

Parenthesis are not needed.

> +	.lanes			= 2,
> +	/* bit rate / ddr / lanes */
> +	.op_sys_clock		= (s64 []){ 796800000 / 2 / 2,
> +					    840000000 / 2 / 2,
> +					    1996800000 / 2 / 2, 0 },
> +	.csi_signalling_mode	= SMIAPP_CSI_SIGNALLING_MODE_CSI2,
> +	.strobe_setup		= &rm680_main_camera_strobe_setup,

What about embedding the flash strobe parameters in smiapp_platform_data ? Do 
you think that would be better ?

> +	.set_xclk		= rm680_main_camera_set_xclk,
> +	.xshutdown		= SMIAPP_NO_XSHUTDOWN,
> +};
> +
> +static struct smiapp_platform_data rm680_main_camera_platform_data = {
> +	.i2c_addr_dfl		= SMIAPP_DFL_I2C_ADDR,
> +	.i2c_addr_alt		= SMIAPP_ALT_I2C_ADDR,
> +	.nvm_size		= 16 * 64,
> +	.ext_clk		= (9.6 * 1000 * 1000),
> +	.lanes			= 2,
> +	.op_sys_clock		= (s64 []){ 840000000 / 2 / 2,
> +					    1334400000 / 2 / 2,
> +					    1593600000 / 2 / 2, 0 },
> +	.csi_signalling_mode	= SMIAPP_CSI_SIGNALLING_MODE_CSI2,
> +	.module_board_orient	= SMIAPP_MODULE_BOARD_ORIENT_180,
> +	.strobe_setup		= &rm680_main_camera_strobe_setup,
> +	.set_xclk		= rm680_main_camera_set_xclk,
> +	.xshutdown		= SMIAPP_NO_XSHUTDOWN,
> +};
> +
> +/*
> + *
> + * SECONDARY CAMERA Sensor
> + *
> + */
> +
> +#define SEC_CAMERA_XCLK		ISP_XCLK_B
> +
> +static int rm680_sec_camera_set_xclk(struct v4l2_subdev *sd, int hz)
> +{
> +	return rm680_update_xclk(sd, hz, RM680_SEC_SENSOR, SEC_CAMERA_XCLK);
> +}
> +
> +static struct smiapp_platform_data rm696_sec_camera_platform_data = {
> +	.ext_clk		= (10.8 * 1000 * 1000),
> +	.lanes			= 1,
> +	/* bit rate / ddr */
> +	.op_sys_clock		= (s64 []){ 13770000 * 10 / 2, 0 },
> +	.csi_signalling_mode	= SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_CLOCK,
> +	.module_board_orient	= SMIAPP_MODULE_BOARD_ORIENT_180,
> +	.set_xclk		= rm680_sec_camera_set_xclk,
> +	.xshutdown		= SEC_CAMERA_RESET_GPIO,
> +};
> +
> +static struct smiapp_platform_data rm680_sec_camera_platform_data = {
> +	.ext_clk		= (10.8 * 1000 * 1000),
> +	.lanes			= 1,
> +	/* bit rate / ddr */
> +	.op_sys_clock		= (s64 []){ 11880000 * 10 / 2, 0 },
> +	.csi_signalling_mode	= SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_CLOCK,
> +	.set_xclk		= rm680_sec_camera_set_xclk,
> +	.xshutdown		= SEC_CAMERA_RESET_GPIO,
> +};
> +
> +/*
> + *
> + * Init all the modules
> + *
> + */
> +
> +#define CAMERA_I2C_BUS_NUM		2
> +#define AD5836_I2C_BUS_NUM		2
> +#define AS3645A_I2C_BUS_NUM		2
> +
> +static struct i2c_board_info rm696_camera_i2c_devices[] = {
> +	{
> +		I2C_BOARD_INFO(SMIAPP_NAME, SMIAPP_ALT_I2C_ADDR),
> +		.platform_data = &rm696_main_camera_platform_data,
> +	},
> +	{
> +		I2C_BOARD_INFO(SMIAPP_NAME, SMIAPP_DFL_I2C_ADDR),
> +		.platform_data = &rm696_sec_camera_platform_data,
> +	},
> +};
> +
> +static struct i2c_board_info rm680_camera_i2c_devices[] = {
> +	{
> +		I2C_BOARD_INFO(SMIAPP_NAME, SMIAPP_ALT_I2C_ADDR),
> +		.platform_data = &rm680_main_camera_platform_data,
> +	},
> +	{
> +		I2C_BOARD_INFO(SMIAPP_NAME, SMIAPP_DFL_I2C_ADDR),
> +		.platform_data = &rm680_sec_camera_platform_data,
> +	},
> +};
> +
> +static struct isp_subdev_i2c_board_info rm696_camera_primary_subdevs[] = {
> +	{
> +		.board_info = &rm696_camera_i2c_devices[0],
> +		.i2c_adapter_id = CAMERA_I2C_BUS_NUM,
> +	},
> +	{ NULL, 0, },
> +};
> +
> +static struct isp_subdev_i2c_board_info rm696_camera_secondary_subdevs[] =
> { +	{
> +		.board_info = &rm696_camera_i2c_devices[1],
> +		.i2c_adapter_id = CAMERA_I2C_BUS_NUM,
> +	},
> +	{ NULL, 0, },
> +};
> +
> +static struct isp_subdev_i2c_board_info rm680_camera_primary_subdevs[] = {
> +	{
> +		.board_info = &rm680_camera_i2c_devices[0],
> +		.i2c_adapter_id = CAMERA_I2C_BUS_NUM,
> +	},
> +	{ NULL, 0, },
> +};
> +
> +static struct isp_subdev_i2c_board_info rm680_camera_secondary_subdevs[] =
> { +	{
> +		.board_info = &rm680_camera_i2c_devices[1],
> +		.i2c_adapter_id = CAMERA_I2C_BUS_NUM,
> +	},
> +	{ NULL, 0, },
> +};
> +
> +static struct isp_v4l2_subdevs_group rm696_camera_subdevs[] = {
> +	{
> +		.subdevs = rm696_camera_primary_subdevs,
> +		.interface = ISP_INTERFACE_CSI2A_PHY2,
> +		.bus = { .csi2 = {
> +			.crc		= 1,
> +			.vpclk_div	= 1,

Just wondering, is vpclk_div really needed in platform data, or should it be 
computed by the driver at runtime based on the clock frequencies ?

> +			.lanecfg	= {
> +				.clk = {
> +					.pol = 1,
> +					.pos = 2,
> +				},
> +				.data[0] = {
> +					.pol = 1,
> +					.pos = 1,
> +				},
> +				.data[1] = {
> +					.pol = 1,
> +					.pos = 3,
> +				},
> +			},
> +		} },
> +	},
> +	{
> +		.subdevs = rm696_camera_secondary_subdevs,
> +		.interface = ISP_INTERFACE_CCP2B_PHY1,
> +		.bus = { .ccp2 = {
> +			.strobe_clk_pol	= 0,
> +			.crc		= 0,
> +			.ccp2_mode	= 0,
> +			.phy_layer	= 0,
> +			.vpclk_div	= 2,
> +			.lanecfg	= {
> +				.clk = {
> +					.pol = 0,
> +					.pos = 1,
> +				},
> +				.data[0] = {
> +					.pol = 0,
> +					.pos = 2,
> +				},
> +			},
> +		} },
> +	},
> +	{ NULL, 0, },
> +};
> +
> +static struct isp_v4l2_subdevs_group rm680_camera_subdevs[] = {
> +	{
> +		.subdevs = rm680_camera_primary_subdevs,
> +		.interface = ISP_INTERFACE_CSI2A_PHY2,
> +		.bus = { .csi2 = {
> +			.crc		= 1,
> +			.vpclk_div	= 1,
> +			.lanecfg	= {
> +				.clk = {
> +					.pol = 1,
> +					.pos = 2,
> +				},
> +				.data[0] = {
> +					.pol = 1,
> +					.pos = 3,
> +				},
> +				.data[1] = {
> +					.pol = 1,
> +					.pos = 1,
> +				},
> +			},
> +		} },
> +	},
> +	{
> +		.subdevs = rm680_camera_secondary_subdevs,
> +		.interface = ISP_INTERFACE_CCP2B_PHY1,
> +		.bus = { .ccp2 = {
> +			.strobe_clk_pol	= 0,
> +			.crc		= 0,
> +			.ccp2_mode	= 0,
> +			.phy_layer	= 0,
> +			.vpclk_div	= 2,
> +			.lanecfg	= {
> +				.clk = {
> +					.pol = 0,
> +					.pos = 1,
> +				},
> +				.data[0] = {
> +					.pol = 0,
> +					.pos = 2,
> +				},
> +			},
> +		} },
> +	},
> +	{ NULL, 0, },
> +};

-- 
Regards,

Laurent Pinchart
