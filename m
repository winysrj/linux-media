Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:42585 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab1LAGZV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2011 01:25:21 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"sakari.ailus@iki.fi" <sakari.ailus@iki.fi>
Subject: RE: [PATCH v2 10/11] arm: omap4panda: Add support for omap4iss
 camera
Date: Thu, 1 Dec 2011 06:24:59 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A8046F94@DBDE01.ent.ti.com>
References: <1322698500-29924-1-git-send-email-saaguirre@ti.com>
 <1322698500-29924-11-git-send-email-saaguirre@ti.com>
In-Reply-To: <1322698500-29924-11-git-send-email-saaguirre@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> owner@vger.kernel.org] On Behalf Of Aguirre, Sergio
> Sent: Thursday, December 01, 2011 5:45 AM
> To: linux-media@vger.kernel.org
> Cc: linux-omap@vger.kernel.org; laurent.pinchart@ideasonboard.com;
> sakari.ailus@iki.fi; Aguirre, Sergio
> Subject: [PATCH v2 10/11] arm: omap4panda: Add support for omap4iss camera
> 
> This adds support for camera interface with the support for
> following sensors:
> 
> - OV5640
> - OV5650
> 
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  arch/arm/mach-omap2/Kconfig                   |   27 ++++
>  arch/arm/mach-omap2/Makefile                  |    1 +
>  arch/arm/mach-omap2/board-omap4panda-camera.c |  198
> +++++++++++++++++++++++++
>  3 files changed, 226 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-omap2/board-omap4panda-camera.c
> 
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index f883abb..0fc5ce9 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -358,6 +358,33 @@ config MACH_OMAP4_PANDA
>  	select OMAP_PACKAGE_CBS
>  	select REGULATOR_FIXED_VOLTAGE
> 
> +config MACH_OMAP4_PANDA_CAMERA_SUPPORT
> +	bool "OMAP4 Panda Board Camera support"
> +	depends on MACH_OMAP4_PANDA
> +	select MEDIA_SUPPORT
> +	select MEDIA_CONTROLLER
> +	select VIDEO_DEV
> +	select VIDEO_V4L2_SUBDEV_API
> +	select VIDEO_OMAP4
> +	help
> +	  Enable Camera HW support for PandaBoard.
> +	  This is for using the OMAP4 ISS CSI2A Camera sensor
> +	  interface.
> +
> +choice
> +	prompt "Camera sensor to use"
> +	depends on MACH_OMAP4_PANDA_CAMERA_SUPPORT
> +	default MACH_OMAP4_PANDA_CAM_OV5650
> +
> +	config MACH_OMAP4_PANDA_CAM_OV5640
> +		bool "Use OmniVision OV5640 Camera"
> +		select VIDEO_OV5640
> +
> +	config MACH_OMAP4_PANDA_CAM_OV5650
> +		bool "Use OmniVision OV5650 Camera"
> +		select VIDEO_OV5650
> +endchoice
> +
>  config OMAP3_EMU
>  	bool "OMAP3 debugging peripherals"
>  	depends on ARCH_OMAP3
> diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
> index 8bc446a..e80724d 100644
> --- a/arch/arm/mach-omap2/Makefile
> +++ b/arch/arm/mach-omap2/Makefile
> @@ -236,6 +236,7 @@ obj-$(CONFIG_MACH_TI8168EVM)		+= board-
> ti8168evm.o
>  # Platform specific device init code
> 
>  obj-$(CONFIG_MACH_OMAP_4430SDP_CAMERA_SUPPORT)	+= board-4430sdp-camera.o
> +obj-$(CONFIG_MACH_OMAP4_PANDA_CAMERA_SUPPORT)	+= board-omap4panda-
> camera.o
> 
Can't this be merged into single file? Do we really need separate file for every board here?

I am sure you would have thought about this.

>  omap-flash-$(CONFIG_MTD_NAND_OMAP2)	:= board-flash.o
>  omap-flash-$(CONFIG_MTD_ONENAND_OMAP2)	:= board-flash.o
> diff --git a/arch/arm/mach-omap2/board-omap4panda-camera.c
> b/arch/arm/mach-omap2/board-omap4panda-camera.c
> new file mode 100644
> index 0000000..02ef36e
> --- /dev/null
> +++ b/arch/arm/mach-omap2/board-omap4panda-camera.c
> @@ -0,0 +1,198 @@
> +#include <linux/gpio.h>
> +#include <linux/clk.h>
> +#include <linux/delay.h>
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
I believe this is not good practice to include files directly from drivers folder. You should divide the header file such that, driver specific information stays in driver/... and platform specific goes into include/...

> +#include "control.h"
> +#include "mux.h"
> +
> +#define PANDA_GPIO_CAM_PWRDN		45
> +#define PANDA_GPIO_CAM_RESET		83
> +
> +static struct clk *panda_cam_aux_clk;
> +
> +static int panda_ov5640_power(struct v4l2_subdev *subdev, int on)
> +{
> +	struct iss_device *iss = v4l2_dev_to_iss_device(subdev->v4l2_dev);
> +	int ret = 0;
You are not using this variable at all, you can get rid of this.

> +	struct iss_csiphy_dphy_cfg dphy;
> +	struct iss_csiphy_lanes_cfg lanes;
> +	unsigned int ddr_freq = 480; /* FIXME: Do an actual query for this
> */
> +
> +	memset(&lanes, 0, sizeof(lanes));
> +	memset(&dphy, 0, sizeof(dphy));
> +
> +	lanes.clk.pos = 1;
> +	lanes.clk.pol = 0;
> +	lanes.data[0].pos = 2;
> +	lanes.data[0].pol = 0;
> +	lanes.data[1].pos = 3;
> +	lanes.data[1].pol = 0;
> +
> +	dphy.ths_term = ((((12500 * ddr_freq + 1000000) / 1000000) - 1) &
> 0xFF);
> +	dphy.ths_settle = ((((90000 * ddr_freq + 1000000) / 1000000) + 3) &
> 0xFF);
> +	dphy.tclk_term = 0;
> +	dphy.tclk_miss = 1;
> +	dphy.tclk_settle = 14;
> +
> +	if (on) {
> +		gpio_set_value(PANDA_GPIO_CAM_PWRDN, 0);
> +		clk_enable(panda_cam_aux_clk);
> +		mdelay(2);
> +
> +		iss->platform_cb.csiphy_config(&iss->csiphy1, &dphy, &lanes);
> +	} else {
> +		clk_disable(panda_cam_aux_clk);
> +		gpio_set_value(PANDA_GPIO_CAM_PWRDN, 1);
> +	}
You may want to check return values for above API's.

> +
> +	return ret;
> +}
> +
> +#define OV5640_I2C_ADDRESS   (0x3C)
> +#define OV5650_I2C_ADDRESS   (0x36)
> +
> +#ifdef CONFIG_MACH_OMAP4_PANDA_CAM_OV5650
> +static struct ov5650_platform_data ov_platform_data = {
> +#elif defined(CONFIG_MACH_OMAP4_PANDA_CAM_OV5640)
> +static struct ov5640_platform_data ov_platform_data = {
> +#endif
> +      .s_power = panda_ov5640_power,
> +};
> +
> +static struct i2c_board_info ov_camera_i2c_device = {
> +#ifdef CONFIG_MACH_OMAP4_PANDA_CAM_OV5650
> +	I2C_BOARD_INFO("ov5650", OV5650_I2C_ADDRESS),
> +#elif defined(CONFIG_MACH_OMAP4_PANDA_CAM_OV5640)
> +	I2C_BOARD_INFO("ov5640", OV5640_I2C_ADDRESS),
> +#endif
> +	.platform_data = &ov_platform_data,
> +};
> +
I may be wrong, but don't you think, we can clean all this #ifdefs here. 
The drivers will get connected cleanly without any issues based on probing and ID (i2c_device_id defined in driver).

Thanks,
Vaibhav

> +static struct iss_subdev_i2c_board_info ov_camera_subdevs[] = {
> +	{
> +		.board_info = &ov_camera_i2c_device,
> +		.i2c_adapter_id = 3,
> +	},
> +	{ NULL, 0, },
> +};
> +
> +static struct iss_v4l2_subdevs_group panda_camera_subdevs[] = {
> +	{
> +		.subdevs = ov_camera_subdevs,
> +		.interface = ISS_INTERFACE_CSI2A_PHY1,
> +	},
> +	{ },
> +};
> +
> +static void panda_omap4iss_set_constraints(struct iss_device *iss, bool
> enable)
> +{
> +	if (!iss)
> +		return;
> +
> +	/* FIXME: Look for something more precise as a good throughtput
> limit */
> +	omap_pm_set_min_bus_tput(iss->dev, OCP_INITIATOR_AGENT,
> +				 enable ? 800000 : -1);
> +}
> +
> +static struct iss_platform_data panda_iss_platform_data = {
> +	.subdevs = panda_camera_subdevs,
> +	.set_constraints = panda_omap4iss_set_constraints,
> +};
> +
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
> +static int __init panda_camera_init(void)
> +{
> +	if (!machine_is_omap4_panda())
> +		return 0;
> +
> +	panda_cam_aux_clk = clk_get(NULL, "auxclk1_ck");
> +	if (IS_ERR(panda_cam_aux_clk)) {
> +		printk(KERN_ERR "Unable to get auxclk1_ck\n");
> +		return -ENODEV;
> +	}
> +
> +	if (clk_set_rate(panda_cam_aux_clk,
> +			clk_round_rate(panda_cam_aux_clk, 24000000)))
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
> +	/* Select GPIO 45 */
> +	omap_mux_init_gpio(PANDA_GPIO_CAM_PWRDN, OMAP_PIN_OUTPUT);
> +
> +	/* Select GPIO 83 */
> +	omap_mux_init_gpio(PANDA_GPIO_CAM_RESET, OMAP_PIN_OUTPUT);
> +
> +	/* Init FREF_CLK1_OUT */
> +	omap_mux_init_signal("fref_clk1_out", OMAP_PIN_OUTPUT);
> +
> +	if (gpio_request_one(PANDA_GPIO_CAM_PWRDN, GPIOF_OUT_INIT_HIGH,
> +			     "CAM_PWRDN"))
> +		printk(KERN_WARNING "Cannot request GPIO %d\n",
> +			PANDA_GPIO_CAM_PWRDN);
> +
> +	if (gpio_request_one(PANDA_GPIO_CAM_RESET, GPIOF_OUT_INIT_HIGH,
> +			     "CAM_RESET"))
> +		printk(KERN_WARNING "Cannot request GPIO %d\n",
> +			PANDA_GPIO_CAM_RESET);
> +
> +	omap4_init_camera(&panda_iss_platform_data, &omap4iss_data);
> +	return 0;
> +}
> +late_initcall(panda_camera_init);
> --
> 1.7.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
