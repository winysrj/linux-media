Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBJAHM12029666
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 05:17:22 -0500
Received: from devils.ext.ti.com (devils.ext.ti.com [198.47.26.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBJAFxXo022462
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 05:15:59 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Fri, 19 Dec 2008 15:45:43 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403ECE3B4C6@dbde02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894415E6E1A5@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Sakari Ailus <sakari.ailus@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>, "Nagalla,
	Hari" <hnagalla@ti.com>
Subject: RE: [REVIEW PATCH 14/14] OMAP34XX: CAM: Add Sensors Support
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>



Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: Aguirre Rodriguez, Sergio Alberto
> Sent: Friday, December 12, 2008 2:09 AM
> To: linux-omap@vger.kernel.org; video4linux-list@redhat.com
> Cc: Sakari Ailus; Tuukka.O Toivonen; Hiremath, Vaibhav; Nagalla,
> Hari
> Subject: [REVIEW PATCH 14/14] OMAP34XX: CAM: Add Sensors Support
> 
> From 4fa46d05b1ecb83ccf2dd1c158ecba70dafc5888 Mon Sep 17 00:00:00
> 2001
> From: Sergio Aguirre <saaguirre@ti.com>
> Date: Thu, 11 Dec 2008 13:42:51 -0600
> Subject: [PATCH] OMAP34XX: CAM: Add Sensors Support
> 
> This adds support in OMAP34xx SDP board file for Sensor and Lens
> driver.
> 
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  arch/arm/mach-omap2/board-3430sdp.c |  300
> ++++++++++++++++++++++++++++++++++-
>  1 files changed, 299 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-3430sdp.c b/arch/arm/mach-
> omap2/board-3430sdp.c
> index ade186b..59a2765 100644
> --- a/arch/arm/mach-omap2/board-3430sdp.c
> +++ b/arch/arm/mach-omap2/board-3430sdp.c
> @@ -23,6 +23,7 @@
>  #include <linux/spi/spi.h>
>  #include <linux/spi/ads7846.h>
>  #include <linux/i2c/twl4030.h>
> +#include <linux/mm.h>
> 
>  #include <mach/hardware.h>
>  #include <asm/mach-types.h>
> @@ -40,6 +41,20 @@
>  #include <mach/dma.h>
>  #include <mach/gpmc.h>
> 
> +#ifdef CONFIG_VIDEO_OMAP3
> +#include <media/v4l2-int-device.h>
> +#include <../drivers/media/video/omap34xxcam.h>
> +#include <../drivers/media/video/isp/ispreg.h>

[Hiremath, Vaibhav] Is it acceptable to include the private header files of drivers here? 

> +#if defined(CONFIG_VIDEO_MT9P012) ||
> defined(CONFIG_VIDEO_MT9P012_MODULE)
> +#include <media/mt9p012.h>
> +static enum v4l2_power mt9p012_previous_power = V4L2_POWER_OFF;
> +#endif
> +#endif
> +
> +#ifdef CONFIG_VIDEO_DW9710
> +#include <../drivers/media/video/dw9710.h>
> +#endif
> +
>  #include <asm/io.h>
>  #include <asm/delay.h>
>  #include <mach/control.h>
> @@ -238,6 +253,273 @@ static struct spi_board_info
> sdp3430_spi_board_info[] __initdata = {
>  	},
>  };
> 
> +#ifdef CONFIG_VIDEO_OMAP3
> +static void __iomem *fpga_map_addr;
> +
> +static void enable_fpga_vio_1v8(u8 enable)
> +{
> +	u16 reg_val;
> +
> +	fpga_map_addr = ioremap(DEBUG_BASE, 4096);
> +	reg_val = readw(fpga_map_addr + REG_SDP3430_FPGA_GPIO_2);
> +
> +	/* Ensure that the SPR_GPIO1_3v3 is 0 - powered off.. 1 is on
> */
> +	if (reg_val & FPGA_SPR_GPIO1_3v3) {
> +		reg_val |= FPGA_SPR_GPIO1_3v3;
> +		reg_val |= FPGA_GPIO6_DIR_CTRL; /* output mode */
> +		writew(reg_val, fpga_map_addr +
> REG_SDP3430_FPGA_GPIO_2);
> +		/* give a few milli sec to settle down
> +		 * Let the sensor also settle down.. if required..
> +		 */
> +		if (enable)
> +			mdelay(10);
> +	}
> +
> +	if (enable) {
> +		reg_val |= FPGA_SPR_GPIO1_3v3 | FPGA_GPIO6_DIR_CTRL;
> +		writew(reg_val, fpga_map_addr +
> REG_SDP3430_FPGA_GPIO_2);
> +	}
> +	/* Vrise time for the voltage - should be less than 1 ms */
> +	mdelay(1);
> +}
> +#endif
> +
> +#ifdef CONFIG_VIDEO_DW9710
> +static int dw9710_lens_power_set(enum v4l2_power power)
> +{
> +
> +	/* The power change depends on MT9P012 powerup, so if we
> request a
> +	 * power state different from sensor, we should return error
> +	 */
> +	if ((mt9p012_previous_power != V4L2_POWER_OFF) &&
> +					(power != mt9p012_previous_power))
> +		return -EIO;
> +
> +	switch (power) {
> +	case V4L2_POWER_OFF:
> +		/* Power Down Sequence */
> +#ifdef CONFIG_TWL4030_CORE
> +		twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
> +				VAUX_DEV_GRP_NONE, TWL4030_VAUX2_DEV_GRP);
> +#else
> +#error "no power companion board defined!"
> +#endif
> +		enable_fpga_vio_1v8(0);
> +		omap_free_gpio(MT9P012_RESET_GPIO);
> +		iounmap(fpga_map_addr);
> +		omap_free_gpio(MT9P012_STANDBY_GPIO);
> +		break;
> +	case V4L2_POWER_ON:
> +		/* Request and configure gpio pins */
> +		if (omap_request_gpio(MT9P012_STANDBY_GPIO) != 0) {
> +			printk(KERN_WARNING "Could not request GPIO %d"
> +						" for MT9P012\n",
> +						MT9P012_STANDBY_GPIO);
> +			return -EIO;
> +		}
> +
> +		/* Request and configure gpio pins */
> +		if (omap_request_gpio(MT9P012_RESET_GPIO) != 0)
> +			return -EIO;
> +
> +		/* set to output mode */
> +		gpio_direction_output(MT9P012_STANDBY_GPIO, true);
> +		/* set to output mode */
> +		gpio_direction_output(MT9P012_RESET_GPIO, true);
> +
> +		/* STANDBY_GPIO is active HIGH for set LOW to release */
> +		gpio_set_value(MT9P012_STANDBY_GPIO, 1);
> +
> +		/* nRESET is active LOW. set HIGH to release reset */
> +		gpio_set_value(MT9P012_RESET_GPIO, 1);
> +
> +		/* turn on digital power */
> +		enable_fpga_vio_1v8(1);
> +#ifdef CONFIG_TWL4030_CORE
> +		/* turn on analog power */
> +		twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
> +				VAUX_2_8_V, TWL4030_VAUX2_DEDICATED);
> +		twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
> +				VAUX_DEV_GRP_P1, TWL4030_VAUX2_DEV_GRP);
> +#else
> +#error "no power companion board defined!"
> +#endif
> +		/* out of standby */
> +		gpio_set_value(MT9P012_STANDBY_GPIO, 0);
> +		udelay(1000);
> +
> +		/* have to put sensor to reset to guarantee detection */
> +		gpio_set_value(MT9P012_RESET_GPIO, 0);
> +
> +		udelay(1500);
> +
> +		/* nRESET is active LOW. set HIGH to release reset */
> +		gpio_set_value(MT9P012_RESET_GPIO, 1);
> +		/* give sensor sometime to get out of the reset.
> +		 * Datasheet says 2400 xclks. At 6 MHz, 400 usec is
> +		 * enough
> +		 */
> +		udelay(300);
> +		break;
> +	case V4L2_POWER_STANDBY:
> +		break;
> +	}
> +	return 0;
> +}
> +
> +static int dw9710_lens_set_prv_data(void *priv)
> +{
> +	struct omap34xxcam_hw_config *hwc = priv;
> +
> +	hwc->dev_index = 0;
> +	hwc->dev_minor = 0;
> +	hwc->dev_type = OMAP34XXCAM_SLAVE_LENS;
> +
> +	return 0;
> +}
> +
> +static struct dw9710_platform_data sdp3430_dw9710_platform_data = {
> +	.power_set      = dw9710_lens_power_set,
> +	.priv_data_set  = dw9710_lens_set_prv_data,
> +};
> +#endif
> +
> +#if defined(CONFIG_VIDEO_MT9P012) ||
> defined(CONFIG_VIDEO_MT9P012_MODULE)
> +static struct omap34xxcam_sensor_config cam_hwc = {
> +	.sensor_isp = 0,
> +	.xclk = OMAP34XXCAM_XCLK_A,
> +	.capture_mem = PAGE_ALIGN(2592 * 1944 * 2) * 4,
> +};
> +
> +static int mt9p012_sensor_set_prv_data(void *priv)
> +{
> +	struct omap34xxcam_hw_config *hwc = priv;
> +
> +	hwc->u.sensor.xclk = cam_hwc.xclk;
> +	hwc->u.sensor.sensor_isp = cam_hwc.sensor_isp;
> +	hwc->u.sensor.capture_mem = cam_hwc.capture_mem;
> +	hwc->dev_index = 0;
> +	hwc->dev_minor = 0;
> +	hwc->dev_type = OMAP34XXCAM_SLAVE_SENSOR;
> +	return 0;
> +}
> +
> +static struct isp_interface_config mt9p012_if_config = {
> +	.ccdc_par_ser = ISP_PARLL,
> +	.dataline_shift = 0x1,
> +	.hsvs_syncdetect = ISPCTRL_SYNC_DETECT_VSRISE,
> +	.vdint0_timing = 0x0,
> +	.vdint1_timing = 0x0,
> +	.strobe = 0x0,
> +	.prestrobe = 0x0,
> +	.shutter = 0x0,
> +	.prev_sph = 2,
> +	.prev_slv = 0,
> +	.wenlog = ISPCCDC_CFG_WENLOG_OR,
> +	.u.par.par_bridge = 0x0,
> +	.u.par.par_clk_pol = 0x0,
> +};
> +
> +static int mt9p012_sensor_power_set(enum v4l2_power power)
> +{
> +	switch (power) {
> +	case V4L2_POWER_OFF:
> +		/* Power Down Sequence */
> +#ifdef CONFIG_TWL4030_CORE
> +		twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
> +				VAUX_DEV_GRP_NONE, TWL4030_VAUX2_DEV_GRP);
> +#else
> +#error "no power companion board defined!"
> +#endif
> +		enable_fpga_vio_1v8(0);
> +		omap_free_gpio(MT9P012_RESET_GPIO);
> +		iounmap(fpga_map_addr);
> +		omap_free_gpio(MT9P012_STANDBY_GPIO);
> +		break;
> +	case V4L2_POWER_ON:
> +		if (mt9p012_previous_power == V4L2_POWER_OFF) {
> +			/* Power Up Sequence */
> +			isp_configure_interface(&mt9p012_if_config);
> +
> +			/* Request and configure gpio pins */
> +			if (omap_request_gpio(MT9P012_STANDBY_GPIO) != 0)
> {
> +				printk(KERN_WARNING "Could not request GPIO
> %d"
> +							" for MT9P012\n",
> +							MT9P012_STANDBY_GPIO);
> +				return -EIO;
> +			}
> +
> +			/* Request and configure gpio pins */
> +			if (omap_request_gpio(MT9P012_RESET_GPIO) != 0)
> +				return -EIO;
> +
> +			/* set to output mode */
> +			gpio_direction_output(MT9P012_STANDBY_GPIO, true);
> +			/* set to output mode */
> +			gpio_direction_output(MT9P012_RESET_GPIO, true);
> +
> +			/* STANDBY_GPIO is active HIGH for set LOW to
> release */
> +			gpio_set_value(MT9P012_STANDBY_GPIO, 1);
> +
> +			/* nRESET is active LOW. set HIGH to release reset
> */
> +			gpio_set_value(MT9P012_RESET_GPIO, 1);
> +
> +			/* turn on digital power */
> +			enable_fpga_vio_1v8(1);
> +#ifdef CONFIG_TWL4030_CORE
> +			/* turn on analog power */
> +			twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
> +					VAUX_2_8_V, TWL4030_VAUX2_DEDICATED);
> +			twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
> +					VAUX_DEV_GRP_P1,
> TWL4030_VAUX2_DEV_GRP);
> +#else
> +#error "no power companion board defined!"
> +#endif
> +		}
> +
> +		/* out of standby */
> +		gpio_set_value(MT9P012_STANDBY_GPIO, 0);
> +		udelay(1000);
> +
> +		if (mt9p012_previous_power == V4L2_POWER_OFF) {
> +			/* have to put sensor to reset to guarantee
> detection */
> +			gpio_set_value(MT9P012_RESET_GPIO, 0);
> +
> +			udelay(1500);
> +
> +			/* nRESET is active LOW. set HIGH to release reset
> */
> +			gpio_set_value(MT9P012_RESET_GPIO, 1);
> +			/* give sensor sometime to get out of the reset.
> +			 * Datasheet says 2400 xclks. At 6 MHz, 400 usec
> is
> +			 * enough
> +			 */
> +			udelay(300);
> +		}
> +		break;
> +	case V4L2_POWER_STANDBY:
> +		/* stand by */
> +		gpio_set_value(MT9P012_STANDBY_GPIO, 1);
> +		break;
> +	}
> +	/* Save powerstate to know what was before calling POWER_ON.
> */
> +	mt9p012_previous_power = power;
> +	return 0;
> +}
> +
> +static u32 mt9p012_sensor_set_xclk(u32 xclkfreq)
> +{
> +	return isp_set_xclk(xclkfreq, MT9P012_USE_XCLKA);
> +}
> +
> +static struct mt9p012_platform_data sdp3430_mt9p012_platform_data =
> {
> +	.power_set      = mt9p012_sensor_power_set,
> +	.priv_data_set  = mt9p012_sensor_set_prv_data,
> +	.set_xclk       = mt9p012_sensor_set_xclk,
> +};
> +
> +#endif
> +
> +
>  static struct platform_device sdp3430_lcd_device = {
>  	.name		= "sdp2430_lcd",
>  	.id		= -1,
> @@ -434,11 +716,27 @@ static struct i2c_board_info __initdata
> sdp3430_i2c_boardinfo[] = {
>  	},
>  };
> 
> +static struct i2c_board_info __initdata sdp3430_i2c_boardinfo_2[] =
> {
> +#if defined(CONFIG_VIDEO_MT9P012) ||
> defined(CONFIG_VIDEO_MT9P012_MODULE)
> +	{
> +		I2C_BOARD_INFO("mt9p012", MT9P012_I2C_ADDR),
> +		.platform_data = &sdp3430_mt9p012_platform_data,
> +	},
> +#ifdef CONFIG_VIDEO_DW9710
> +	{
> +		I2C_BOARD_INFO(DW9710_NAME,  DW9710_AF_I2C_ADDR),
> +		.platform_data = &sdp3430_dw9710_platform_data,
> +	},
> +#endif
> +#endif
> +};
> +
>  static int __init omap3430_i2c_init(void)
>  {
>  	omap_register_i2c_bus(1, 2600, sdp3430_i2c_boardinfo,
>  			ARRAY_SIZE(sdp3430_i2c_boardinfo));
> -	omap_register_i2c_bus(2, 400, NULL, 0);
> +	omap_register_i2c_bus(2, 400, sdp3430_i2c_boardinfo_2,
> +			ARRAY_SIZE(sdp3430_i2c_boardinfo_2));
>  	omap_register_i2c_bus(3, 400, NULL, 0);
>  	return 0;
>  }
> --
> 1.5.6.5


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
