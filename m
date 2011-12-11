Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:59353 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab1LKIFZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Dec 2011 03:05:25 -0500
Date: Sun, 11 Dec 2011 10:05:19 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sergio Aguirre <saaguirre@ti.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v2 09/11] arm: omap4430sdp: Add support for omap4iss
 camera
Message-ID: <20111211080518.GH1967@valkosipuli.localdomain>
References: <1322698500-29924-1-git-send-email-saaguirre@ti.com>
 <1322698500-29924-10-git-send-email-saaguirre@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322698500-29924-10-git-send-email-saaguirre@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

Thanks for the patches!!

I think the general direction for such configurations is that the device
tree is favoured over the platform data.

On Wed, Nov 30, 2011 at 06:14:58PM -0600, Sergio Aguirre wrote:
> This adds support for camera interface with the support for
> following sensors:
> 
> - OV5640
> - OV5650
> 
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  arch/arm/mach-omap2/Kconfig                |   27 ++++
>  arch/arm/mach-omap2/Makefile               |    2 +
>  arch/arm/mach-omap2/board-4430sdp-camera.c |  221 ++++++++++++++++++++++++++++
>  3 files changed, 250 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-omap2/board-4430sdp-camera.c
> 
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index 5034147..f883abb 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -323,6 +323,33 @@ config MACH_OMAP_4430SDP
>  	select OMAP_PACKAGE_CBS
>  	select REGULATOR_FIXED_VOLTAGE
>  
> +config MACH_OMAP_4430SDP_CAMERA_SUPPORT
> +	bool "OMAP 4430 SDP board Camera support"
> +	depends on MACH_OMAP_4430SDP
> +	select MEDIA_SUPPORT
> +	select MEDIA_CONTROLLER
> +	select VIDEO_DEV
> +	select VIDEO_V4L2_SUBDEV_API
> +	select VIDEO_OMAP4
> +	help
> +	  Enable Camera HW support for OMAP 4430 SDP board
> +	  This is for using the OMAP4 ISS CSI2A Camera sensor
> +	  interface.
> +
> +choice
> +	prompt "Camera sensor to use"
> +	depends on MACH_OMAP_4430SDP_CAMERA_SUPPORT
> +	default MACH_OMAP_4430SDP_CAM_OV5650
> +
> +	config MACH_OMAP_4430SDP_CAM_OV5640
> +		bool "Use OmniVision OV5640 Camera"
> +		select VIDEO_OV5640
> +
> +	config MACH_OMAP_4430SDP_CAM_OV5650
> +		bool "Use OmniVision OV5650 Camera"
> +		select VIDEO_OV5650
> +endchoice
> +
>  config MACH_OMAP4_PANDA
>  	bool "OMAP4 Panda Board"
>  	default y
> diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
> index 69ab1c0..8bc446a 100644
> --- a/arch/arm/mach-omap2/Makefile
> +++ b/arch/arm/mach-omap2/Makefile
> @@ -235,6 +235,8 @@ obj-$(CONFIG_MACH_TI8168EVM)		+= board-ti8168evm.o
>  
>  # Platform specific device init code
>  
> +obj-$(CONFIG_MACH_OMAP_4430SDP_CAMERA_SUPPORT)	+= board-4430sdp-camera.o
> +
>  omap-flash-$(CONFIG_MTD_NAND_OMAP2)	:= board-flash.o
>  omap-flash-$(CONFIG_MTD_ONENAND_OMAP2)	:= board-flash.o
>  obj-y					+= $(omap-flash-y) $(omap-flash-m)
> diff --git a/arch/arm/mach-omap2/board-4430sdp-camera.c b/arch/arm/mach-omap2/board-4430sdp-camera.c
> new file mode 100644
> index 0000000..e62ee50
> --- /dev/null
> +++ b/arch/arm/mach-omap2/board-4430sdp-camera.c
> @@ -0,0 +1,221 @@
> +#include <linux/gpio.h>
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/i2c/twl.h>
> +#include <linux/mfd/twl6040.h>
> +
> +#include <plat/i2c.h>
> +#include <plat/omap-pm.h>
> +
> +#include <asm/mach-types.h>
> +
> +#include <media/ov5640.h>
> +#include <media/ov5650.h>
> +
> +#include "devices.h"
> +#include "../../../drivers/media/video/omap4iss/iss.h"
> +
> +#include "control.h"
> +#include "mux.h"
> +
> +#define OMAP4430SDP_GPIO_CAM_PDN_C	39
> +
> +static struct clk *sdp4430_cam_aux_clk;
> +
> +static int sdp4430_ov5640_power(struct v4l2_subdev *subdev, int on)
> +{
> +	struct iss_device *iss = v4l2_dev_to_iss_device(subdev->v4l2_dev);
> +	int ret = 0;
> +	struct iss_csiphy_dphy_cfg dphy;
> +	struct iss_csiphy_lanes_cfg lanes;
> +#ifdef CONFIG_MACH_OMAP_4430SDP_CAM_OV5650
> +	unsigned int ddr_freq = 480; /* FIXME: Do an actual query for this */
> +#elif defined(CONFIG_MACH_OMAP_4430SDP_CAM_OV5640)
> +	unsigned int ddr_freq = 336; /* FIXME: Do an actual query for this */
> +#endif
> +
> +	memset(&lanes, 0, sizeof(lanes));
> +	memset(&dphy, 0, sizeof(dphy));
> +
> +	lanes.clk.pos = 1;
> +	lanes.clk.pol = 0;
> +	lanes.data[0].pos = 2;
> +	lanes.data[0].pol = 0;
> +#ifdef CONFIG_MACH_OMAP_4430SDP_CAM_OV5650
> +	lanes.data[1].pos = 3;
> +	lanes.data[1].pol = 0;
> +#endif

Lane configuration should be static and be set by the driver according to
data from DT.

I don't know about OMAP 4 but I think it should work on OMAP 3. I still need
to try that out myself! :p

> +
> +	dphy.ths_term = ((((12500 * ddr_freq + 1000000) / 1000000) - 1) & 0xFF);
> +	dphy.ths_settle = ((((90000 * ddr_freq + 1000000) / 1000000) + 3) & 0xFF);
> +	dphy.tclk_term = 0;
> +	dphy.tclk_miss = 1;
> +	dphy.tclk_settle = 14;

How sensor / board dependent is the dphy configuration? Could this make it
to the CSI-2 receiver driver instead? I'm actually working on the same on
the OMAP 3. :)

> +
> +	if (on) {
> +		u8 gpoctl = 0;
> +
> +		/* TWL6030_BASEADD_AUX */
> +		twl_i2c_write_u8(15, 0x00, 0xB);
> +		twl_i2c_write_u8(15, 0x80, 0x1);

The regulators should be added to twl6030. The power sequences also should
be part of the sensor driver.

> +
> +		mdelay(50);

s/delay/sleep/. mdelay is busy-loop.

> +
> +		/* TWL6030_BASEADD_PM_SLAVE_MISC */
> +		twl_i2c_write_u8(21, 0xFF, 0x5E);
> +		twl_i2c_write_u8(21, 0x13, 0x5F);
> +
> +		mdelay(50);
> +
> +		twl_i2c_write_u8(15, 0x40, 0x1);
> +
> +		twl_i2c_read_u8(TWL_MODULE_AUDIO_VOICE, &gpoctl,
> +				TWL6040_REG_GPOCTL);
> +		twl_i2c_write_u8(TWL_MODULE_AUDIO_VOICE, gpoctl | TWL6040_GPO3,
> +				TWL6040_REG_GPOCTL);
> +
> +		mdelay(10);
> +
> +		gpio_set_value(OMAP4430SDP_GPIO_CAM_PDN_C, 1);
> +		mdelay(10);
> +		clk_enable(sdp4430_cam_aux_clk); /* Enable XCLK */
> +		mdelay(10);
> +
> +		iss->platform_cb.csiphy_config(&iss->csiphy1, &dphy, &lanes);
> +	} else {
> +		clk_disable(sdp4430_cam_aux_clk);
> +		mdelay(1);
> +		gpio_set_value(OMAP4430SDP_GPIO_CAM_PDN_C, 0);
> +	}
> +
> +	return ret;
> +}
> +
> +#define OV5640_I2C_ADDRESS   (0x3C)
> +#define OV5650_I2C_ADDRESS   (0x36)
> +
> +#ifdef CONFIG_MACH_OMAP_4430SDP_CAM_OV5650
> +static struct ov5650_platform_data ov_platform_data = {
> +#elif defined(CONFIG_MACH_OMAP_4430SDP_CAM_OV5640)
> +static struct ov5640_platform_data ov_platform_data = {
> +#endif
> +      .s_power = sdp4430_ov5640_power,
> +};
> +
> +static struct i2c_board_info ov_camera_i2c_device = {
> +#ifdef CONFIG_MACH_OMAP_4430SDP_CAM_OV5650
> +	I2C_BOARD_INFO("ov5650", OV5650_I2C_ADDRESS),
> +#elif defined(CONFIG_MACH_OMAP_4430SDP_CAM_OV5640)
> +	I2C_BOARD_INFO("ov5640", OV5640_I2C_ADDRESS),
> +#endif
> +	.platform_data = &ov_platform_data,
> +};
> +
> +static struct iss_subdev_i2c_board_info ov_camera_subdevs[] = {
> +	{
> +		.board_info = &ov_camera_i2c_device,
> +		.i2c_adapter_id = 3,
> +	},
> +	{ NULL, 0, },
> +};
> +
> +static struct iss_v4l2_subdevs_group sdp4430_camera_subdevs[] = {
> +	{
> +		.subdevs = ov_camera_subdevs,
> +		.interface = ISS_INTERFACE_CSI2A_PHY1,
> +	},
> +	{ },
> +};
> +
> +static void sdp4430_omap4iss_set_constraints(struct iss_device *iss, bool enable)
> +{
> +	if (!iss)
> +		return;
> +
> +	/* FIXME: Look for something more precise as a good throughtput limit */
> +	omap_pm_set_min_bus_tput(iss->dev, OCP_INITIATOR_AGENT,
> +				 enable ? 800000 : -1);

Are there still no generic APIs to do this? :I

> +}
> +
> +static struct iss_platform_data sdp4430_iss_platform_data = {
> +	.subdevs = sdp4430_camera_subdevs,
> +	.set_constraints = sdp4430_omap4iss_set_constraints,
> +};
> +
> +static struct omap_device_pad omap4iss_pads[] = {
> +	{
> +		.name   = "csi21_dx0.csi21_dx0",
> +		.enable = OMAP_MUX_MODE0 | OMAP_INPUT_EN,
> +	},
> +	{
> +		.name   = "csi21_dy0.csi21_dy0",
> +		.enable = OMAP_MUX_MODE0 | OMAP_INPUT_EN,
> +	},
> +	{
> +		.name   = "csi21_dx1.csi21_dx1",
> +		.enable = OMAP_MUX_MODE0 | OMAP_INPUT_EN,
> +	},
> +	{
> +		.name   = "csi21_dy1.csi21_dy1",
> +		.enable = OMAP_MUX_MODE0 | OMAP_INPUT_EN,
> +	},
> +	{
> +		.name   = "csi21_dx2.csi21_dx2",
> +		.enable = OMAP_MUX_MODE0 | OMAP_INPUT_EN,
> +	},
> +	{
> +		.name   = "csi21_dy2.csi21_dy2",
> +		.enable = OMAP_MUX_MODE0 | OMAP_INPUT_EN,
> +	},
> +};
> +
> +static struct omap_board_data omap4iss_data = {
> +	.id	    		= 1,
> +	.pads	 		= omap4iss_pads,
> +	.pads_cnt       	= ARRAY_SIZE(omap4iss_pads),
> +};
> +
> +static int __init sdp4430_camera_init(void)
> +{
> +	if (!machine_is_omap_4430sdp())
> +		return 0;
> +
> +	sdp4430_cam_aux_clk = clk_get(NULL, "auxclk3_ck");
> +	if (IS_ERR(sdp4430_cam_aux_clk)) {
> +		printk(KERN_ERR "Unable to get auxclk3_ck\n");
> +		return -ENODEV;
> +	}
> +
> +	if (clk_set_rate(sdp4430_cam_aux_clk,
> +			clk_round_rate(sdp4430_cam_aux_clk, 24000000)))
> +		return -EINVAL;
> +
> +	/*
> +	 * CSI2 1(A):
> +	 *   LANEENABLE[4:0] = 00111(0x7) - Lanes 0, 1 & 2 enabled
> +	 *   CTRLCLKEN = 1 - Active high enable for CTRLCLK
> +	 *   CAMMODE = 0 - DPHY mode
> +	 */
> +	omap4_ctrl_pad_writel((omap4_ctrl_pad_readl(
> +				OMAP4_CTRL_MODULE_PAD_CORE_CONTROL_CAMERA_RX) &
> +			  ~(OMAP4_CAMERARX_CSI21_LANEENABLE_MASK |
> +			    OMAP4_CAMERARX_CSI21_CAMMODE_MASK)) |
> +			 (0x7 << OMAP4_CAMERARX_CSI21_LANEENABLE_SHIFT) |
> +			 OMAP4_CAMERARX_CSI21_CTRLCLKEN_MASK,
> +			 OMAP4_CTRL_MODULE_PAD_CORE_CONTROL_CAMERA_RX);
> +
> +	omap_mux_init_gpio(OMAP4430SDP_GPIO_CAM_PDN_C, OMAP_PIN_OUTPUT);
> +
> +	/* Init FREF_CLK3_OUT */
> +	omap_mux_init_signal("fref_clk3_out", OMAP_PIN_OUTPUT);
> +
> +	if (gpio_request(OMAP4430SDP_GPIO_CAM_PDN_C, "CAM_PDN_C"))
> +		printk(KERN_WARNING "Cannot request GPIO %d\n",
> +			OMAP4430SDP_GPIO_CAM_PDN_C);
> +	else
> +		gpio_direction_output(OMAP4430SDP_GPIO_CAM_PDN_C, 0);
> +
> +	omap4_init_camera(&sdp4430_iss_platform_data, &omap4iss_data);
> +	return 0;
> +}
> +late_initcall(sdp4430_camera_init);
> -- 
> 1.7.7.4
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
