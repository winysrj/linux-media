Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:54996 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab1GMT4A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 15:56:00 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "beagleboard@googlegroups.com" <beagleboard@googlegroups.com>
CC: "Kridner, Jason" <jdk@ti.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Kooi, Koen" <k-kooi@ti.com>, "Prakash, Punya" <pprakash@ti.com>,
	"Maupin, Chase" <chase.maupin@ti.com>,
	"Kipisz, Steven" <s-kipisz2@ti.com>,
	"Aguirre, Sergio" <saaguirre@ti.com>
Date: Thu, 14 Jul 2011 01:25:48 +0530
Subject: RE: [beagleboard] [RFC v1] mt9v113: VGA camera sensor driver and
 support for BeagleBoard
Message-ID: <19F8576C6E063C45BE387C64729E739404E35E4272@dbde02.ent.ti.com>
References: <1310581347-31102-1-git-send-email-agnel.joel@gmail.com>
In-Reply-To: <1310581347-31102-1-git-send-email-agnel.joel@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: beagleboard@googlegroups.com [mailto:beagleboard@googlegroups.com]
> On Behalf Of Joel A Fernandes
> Sent: Wednesday, July 13, 2011 11:52 PM
> To: beagleboard@googlegroups.com
> Cc: Joel A Fernandes; Kridner, Jason; Javier Martin;
> laurent.pinchart@ideasonboard.com; linux-media@vger.kernel.org; Kooi,
> Koen; Prakash, Punya; Maupin, Chase; Kipisz, Steven; Aguirre, Sergio
> Subject: [beagleboard] [RFC v1] mt9v113: VGA camera sensor driver and
> support for BeagleBoard
>
> * Adds support for mt9v113 sensor by borrowing heavily from PSP 2.6.37
> kernel patches
> * Adapted to changes in v4l2 framework and ISP driver
>
> Signed-off-by: Joel A Fernandes <agnel.joel@gmail.com>
> ---
> This patch will apply against the 2.6.39 kernel built from the OE-
> development tree (Which is essentially
> the v2.6.39 from the main tree with OE patches for BeagleBoard support and
> a few other features)
>
> If you have the Leapord imaging camera board with this particular sensor,
> I would apprecite it if anyone could
> try this patch out and provide any feedback/test results.
>
> To get the complete tree which works on a BeagleBoard-xM with all the OE
> patches and this patch,
> you can clone: https://github.com/joelagnel/linux-omap-2.6/tree/oedev-
> 2.6.39-mt9v113
>
> It will compile and work on a BeagleBoard-xM with the defconfig at:
> http://cgit.openembedded.org/cgit.cgi/openembedded/tree/recipes/linux/linu
> x-omap-2.6.39/beagleboard/defconfig
>
> Also you will need to apply my media-ctl patch (or clone the tree) to
> setup the formats:
> https://github.com/joelagnel/media-
> ctl/commit/cdf24d1249ac1ff3cd6f70ad80c3b76ac28ba0d5
>
> Binaries for quick testing on a BeagleBoard-xM:
> U-boot: http://utdallas.edu/~joel.fernandes/u-boot.bin
> U-boot: http://utdallas.edu/~joel.fernandes/MLO
> uEnv.txt: http://utdallas.edu/~joel.fernandes/uEnv.txt
> media-ctl: http://utdallas.edu/~joel.fernandes/media-ctl
> kernel: http://utdallas.edu/~joel.fernandes/uImage
>
> media-ctl/yavta commands you could use to get it to show a picture can be
> found at:
> http://utdallas.edu/~joel.fernandes/stream.sh
>
> Note:
> The BeagleBoard camera board file in this patch replaces the old one, so
> this will take away support for the 5M
> sensor (mt9p031), I hope this can be forgiven considering this is an
> RFC :). I am working on a common board file
> that will work for both sensors.
>
 [Hiremath, Vaibhav] Joel,

I am bit surprised by this patch submission, first of all, the patch has been submitted without my knowledge. And I was not aware that you are targeting linux-media for this code-snippet.

This code needs lot of cleanup and changes to get to the level where we can submit it to the linux-media, and I think I clearly mentioned about known issues with this patch/driver in the commit itself. Please refer to the below commit -

http://arago-project.org/git/projects/?p=linux-omap3.git;a=commitdiff;h=c6174e0658b9aaa8f7a3ec9fe562619084d34f59

I agree that we had some internal discussion on this and I was under assumption that this effort was only towards beagle openembedded and not for linux-media.

I also agree with the fact that, due to other critical issues I could not able to spend time on this and upstream it. But as I mentioned to you in one of private discussion, now we are working to get all this patches upstream and soon you will see patches coming in from my team.

Another important side note, you should always retain original authorship of the patches/commits/signoffs. It should always be in incremental order from baseline, which you are using.

Thanks,
Vaibhav


>  arch/arm/mach-omap2/board-omap3beagle-camera.c |  218 ++++--
>  drivers/media/video/Kconfig                    |    7 +
>  drivers/media/video/Makefile                   |    1 +
>  drivers/media/video/mt9v113.c                  | 1027
> ++++++++++++++++++++++++
>  drivers/media/video/mt9v113_regs.h             |  294 +++++++
>  drivers/media/video/omap3isp/ispccdc.c         |   10 +-
>  drivers/media/video/omap3isp/ispvideo.c        |    7 +-
>  include/media/mt9v113.h                        |   70 ++
>  include/media/v4l2-chip-ident.h                |    1 +
>  9 files changed, 1577 insertions(+), 58 deletions(-)
>  create mode 100644 drivers/media/video/mt9v113.c
>  create mode 100644 drivers/media/video/mt9v113_regs.h
>  create mode 100644 include/media/mt9v113.h
>
> diff --git a/arch/arm/mach-omap2/board-omap3beagle-camera.c
> b/arch/arm/mach-omap2/board-omap3beagle-camera.c
> index 2632557..3d3ae53 100644
> --- a/arch/arm/mach-omap2/board-omap3beagle-camera.c
> +++ b/arch/arm/mach-omap2/board-omap3beagle-camera.c
> @@ -1,95 +1,203 @@
> -#include <linux/gpio.h>
> -#include <linux/regulator/machine.h>
> +/*
> + * BeagleXM: Driver for Leopard Module Board
> + *
> + * Copyright (C) 2011 Texas Instruments Inc
> + * Author: Vaibhav Hiremath <hvaibhav@ti.com>
> + *
> + * This package is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/io.h>
> +#include <linux/i2c.h>
> +#include <linux/delay.h>
> +#include <linux/platform_device.h>
> +#include <linux/regulator/consumer.h>
> +
> +#include <mach/gpio.h>
> +
> +#include <media/mt9v113.h>
> +
> +#include <../drivers/media/video/omap3isp/isp.h>
>
> -#include <plat/i2c.h>
> -
> -#include <media/mt9p031.h>
> -#include <asm/mach-types.h>
>  #include "devices.h"
> -#include "../../../drivers/media/video/omap3isp/isp.h"
>
> -#define MT9P031_RESET_GPIO   98
> -#define MT9P031_XCLK         ISP_XCLK_A
> +#define CAM_USE_XCLKA                        1
> +#define LEOPARD_RESET_GPIO           98
> +
> +static struct regulator *beagle_1v8;
> +static struct regulator *beagle_2v8;
>
> -static struct regulator *reg_1v8, *reg_2v8;
> +#define debg(msg) printk(KERN_ERR "BB Debug: " #msg)
>
> -static int beagle_cam_set_xclk(struct v4l2_subdev *subdev, int hz)
> +static int beagle_mt9v113_s_power(struct v4l2_subdev *subdev, int on)
>  {
>       struct isp_device *isp = v4l2_dev_to_isp_device(subdev->v4l2_dev);
> -     int ret;
>
> -     ret = isp->platform_cb.set_xclk(isp, hz, MT9P031_XCLK);
> +     if (!beagle_1v8 || !beagle_2v8) {
> +             dev_err(isp->dev, "No regulator available\n");
> +             return -ENODEV;
> +     }
> +     if (on) {
> +             debg(Powering on);
> +             /*
> +              * Power Up Sequence
> +              */
> +             /* Set RESET_BAR to 0 */
> +             gpio_set_value(LEOPARD_RESET_GPIO, 0);
> +             /* Turn on VDD */
> +             debg(Regulator 1v8 switching on);
> +             regulator_enable(beagle_1v8);
> +             mdelay(1);
> +             debg(Regulator 2v8 switching on);
> +             regulator_enable(beagle_2v8);
> +
> +             mdelay(50);
> +             /* Enable EXTCLK */
> +             debg(Setting isp xclk);
> +             if (isp->platform_cb.set_xclk)
> +                     isp->platform_cb.set_xclk(isp, 24000000, CAM_USE_XCLKA);
> +             /*
> +              * Wait at least 70 CLK cycles (w/EXTCLK = 24MHz):
> +              * ((1000000 * 70) / 24000000) = aprox 3 us.
> +              */
> +             udelay(3);
> +             /* Set RESET_BAR to 1 */
> +             gpio_set_value(LEOPARD_RESET_GPIO, 1);
> +             /*
> +              * Wait at least 100 CLK cycles (w/EXTCLK = 24MHz):
> +              * ((1000000 * 100) / 24000000) = aprox 5 us.
> +              */
> +             udelay(5);
> +     } else {
> +             debg(Power off);
> +             /*
> +              * Power Down Sequence
> +              */
> +             if (regulator_is_enabled(beagle_1v8))
> +                     regulator_disable(beagle_1v8);
> +             if (regulator_is_enabled(beagle_2v8))
> +                     regulator_disable(beagle_2v8);
> +
> +             if (isp->platform_cb.set_xclk)
> +                     isp->platform_cb.set_xclk(isp, 0, CAM_USE_XCLKA);
> +     }
> +
>       return 0;
>  }
>
> -static int beagle_cam_reset(struct v4l2_subdev *subdev, int active)
> +static int beagle_mt9v113_configure_interface(struct v4l2_subdev *subdev,
> +                                           u32 pixclk)
>  {
> -     /* Set RESET_BAR to !active */
> -     gpio_set_value(MT9P031_RESET_GPIO, !active);
> +     struct isp_device *isp = v4l2_dev_to_isp_device(subdev->v4l2_dev);
> +
> +     if (isp->platform_cb.set_pixel_clock)
> +             isp->platform_cb.set_pixel_clock(isp, pixclk);
>
>       return 0;
>  }
>
> -static struct mt9p031_platform_data beagle_mt9p031_platform_data = {
> -     .set_xclk               = beagle_cam_set_xclk,
> -     .reset                  = beagle_cam_reset,
> -     .vdd_io                 = MT9P031_VDD_IO_1V8,
> -     .version                = MT9P031_COLOR_VERSION,
> +static struct mt9v113_platform_data beagle_mt9v113_platform_data = {
> +     .s_power                = beagle_mt9v113_s_power,
> +     .configure_interface    = beagle_mt9v113_configure_interface,
>  };
>
> -static struct i2c_board_info mt9p031_camera_i2c_device = {
> -     I2C_BOARD_INFO("mt9p031", 0x48),
> -     .platform_data = &beagle_mt9p031_platform_data,
> +
> +#define MT9V113_I2C_BUS_NUM          2
> +
> +static struct i2c_board_info beagle_camera_i2c_devices[] = {
> +     {
> +             I2C_BOARD_INFO(MT9V113_MODULE_NAME, MT9V113_I2C_ADDR),
> +             .platform_data = &beagle_mt9v113_platform_data,
> +     },
>  };
>
> -static struct isp_subdev_i2c_board_info mt9p031_camera_subdevs[] = {
> +static struct isp_subdev_i2c_board_info beagle_camera_primary_subdevs[] =
> {
>       {
> -             .board_info = &mt9p031_camera_i2c_device,
> -             .i2c_adapter_id = 2,
> +             .board_info = &beagle_camera_i2c_devices[0],
> +             .i2c_adapter_id = MT9V113_I2C_BUS_NUM,
>       },
> -     { NULL, 0, },
> +     { NULL, 0 },
>  };
>
>  static struct isp_v4l2_subdevs_group beagle_camera_subdevs[] = {
>       {
> -             .subdevs = mt9p031_camera_subdevs,
> +             .subdevs = beagle_camera_primary_subdevs,
>               .interface = ISP_INTERFACE_PARALLEL,
>               .bus = {
> -                             .parallel = {
> -                                     .data_lane_shift = 0,
> -                                     .clk_pol = 1,
> -                                     .bridge = ISPCTRL_PAR_BRIDGE_DISABLE,
> -                             }
> +                     .parallel = {
> +                             .data_lane_shift        = 2,
> +                             .clk_pol                = 0,
> +                             .bridge                 = 3,
> +                     },
>               },
>       },
> -     { },
> +     { NULL, 0 },
>  };
>
>  static struct isp_platform_data beagle_isp_platform_data = {
>       .subdevs = beagle_camera_subdevs,
>  };
>
> -static int __init beagle_camera_init(void)
> +static int __init beagle_cam_init(void)
>  {
> -     if (!machine_is_omap3_beagle() || !cpu_is_omap3630())
> -             return 0;
> -
> -     reg_1v8 = regulator_get(NULL, "cam_1v8");
> -     if (IS_ERR(reg_1v8))
> -             pr_err("%s: cannot get cam_1v8 regulator\n", __func__);
> -     else
> -             regulator_enable(reg_1v8);
> -
> -     reg_2v8 = regulator_get(NULL, "cam_2v8");
> -     if (IS_ERR(reg_2v8))
> -             pr_err("%s: cannot get cam_2v8 regulator\n", __func__);
> -     else
> -             regulator_enable(reg_2v8);
> -
> -     omap_register_i2c_bus(2, 100, NULL, 0);
> -     gpio_request(MT9P031_RESET_GPIO, "cam_rst");
> -     gpio_direction_output(MT9P031_RESET_GPIO, 0);
> +     /*
> +      * Regulator supply required for camera interface
> +      */
> +     beagle_1v8 = regulator_get(NULL, "cam_1v8");
> +     if (IS_ERR(beagle_1v8)) {
> +             printk(KERN_ERR "cam_1v8 regulator missing\n");
> +             return PTR_ERR(beagle_1v8);
> +     }
> +     beagle_2v8 = regulator_get(NULL, "cam_2v8");
> +     if (IS_ERR(beagle_2v8)) {
> +             printk(KERN_ERR "cam_2v8 regulator missing\n");
> +             regulator_put(beagle_1v8);
> +             return PTR_ERR(beagle_2v8);
> +     }
> +     /*
> +      * Sensor reset GPIO
> +      */
> +     if (gpio_request(LEOPARD_RESET_GPIO, "cam_rst") != 0) {
> +             printk(KERN_ERR "beagle-cam: Could not request GPIO %d\n",
> +                             LEOPARD_RESET_GPIO);
> +             regulator_put(beagle_1v8);
> +             regulator_put(beagle_2v8);
> +             return -ENODEV;
> +     }
> +     /* set to output mode */
> +     gpio_direction_output(LEOPARD_RESET_GPIO, 0);
> +
>       omap3_init_camera(&beagle_isp_platform_data);
> +
>       return 0;
>  }
> -late_initcall(beagle_camera_init);
> +
> +static void __exit beagle_cam_exit(void)
> +{
> +     if (regulator_is_enabled(beagle_1v8))
> +             regulator_disable(beagle_1v8);
> +     regulator_put(beagle_1v8);
> +     if (regulator_is_enabled(beagle_2v8))
> +             regulator_disable(beagle_2v8);
> +     regulator_put(beagle_2v8);
> +
> +     gpio_free(LEOPARD_RESET_GPIO);
> +}
> +
> +module_init(beagle_cam_init);
> +module_exit(beagle_cam_exit);
> +
> +MODULE_AUTHOR("Texas Instruments");
> +MODULE_DESCRIPTION("BeagleXM Camera Module");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 3a5bc57..7721aaa 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -351,6 +351,13 @@ config VIDEO_MT9V032
>         This is a Video4Linux2 sensor-level driver for the Micron
>         MT9V032 752x480 CMOS sensor.
>
> +config VIDEO_MT9V113
> +       tristate "Aptina MT9V113 VGA CMOS IMAGE SENSOR"
> +       depends on VIDEO_V4L2 && I2C
> +       ---help---
> +         This is a Video4Linux2 sensor-level driver for the Aptina
> MT9V113
> +         image sensor.
> +
>  config VIDEO_TCM825X
>       tristate "TCM825x camera sensor support"
>       depends on I2C && VIDEO_V4L2
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index 6679c6a..b2c13f2 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -68,6 +68,7 @@ obj-$(CONFIG_VIDEO_TVEEPROM) += tveeprom.o
>  obj-$(CONFIG_VIDEO_MT9P031) += mt9p031.o
>  obj-$(CONFIG_VIDEO_MT9V011) += mt9v011.o
>  obj-$(CONFIG_VIDEO_MT9V032) += mt9v032.o
> +obj-$(CONFIG_VIDEO_MT9V113) += mt9v113.o
>  obj-$(CONFIG_VIDEO_SR030PC30)        += sr030pc30.o
>  obj-$(CONFIG_VIDEO_NOON010PC30)      += noon010pc30.o
>
> diff --git a/drivers/media/video/mt9v113.c b/drivers/media/video/mt9v113.c
> new file mode 100644
> index 0000000..96512a4
> --- /dev/null
> +++ b/drivers/media/video/mt9v113.c
> @@ -0,0 +1,1027 @@
> +/*
> + * drivers/media/video/mt9v113.c
> + *
> + * Based on TI TVP5146/47 decoder driver
> + *
> + *
> + * This package is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + *
> + */
> +
> +#include <linux/i2c.h>
> +#include <linux/delay.h>
> +#include <linux/slab.h>
> +#include <linux/v4l2-mediabus.h>
> +
> +#include <media/v4l2-chip-ident.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/mt9v113.h>
> +
> +#include "mt9v113_regs.h"
> +
> +/* Macro's */
> +#define I2C_RETRY_COUNT                 (5)
> +
> +#define MT9V113_DEF_WIDTH            640
> +#define MT9V113_DEF_HEIGHT           480
> +
> +/* Debug functions */
> +static int debug = 1;
> +module_param(debug, bool, 0644);
> +MODULE_PARM_DESC(debug, "Debug level (0-1)");
> +
> +/*
> + * struct mt9v113 - sensor object
> + * @subdev: v4l2_subdev associated data
> + * @pad: media entity associated data
> + * @format: associated media bus format
> + * @rect: configured resolution/window
> + * @pdata: Board specific
> + * @ver: Chip version
> + * @power: Current power state (0: off, 1: on)
> + */
> +struct mt9v113 {
> +     struct v4l2_subdev subdev;
> +     struct media_pad pad;
> +     struct v4l2_mbus_framefmt format;
> +     struct v4l2_rect rect;
> +
> +     struct v4l2_ctrl_handler ctrls;
> +
> +     const struct mt9v113_platform_data *pdata;
> +     unsigned int ver;
> +     bool power;
> +};
> +
> +#define to_mt9v113(sd)       container_of(sd, struct mt9v113, subdev)
> +/*
> + * struct mt9v113_fmt -
> + * @mbus_code: associated media bus code
> + * @fmt: format descriptor
> + */
> +struct mt9v113_fmt {
> +     unsigned int mbus_code;
> +     struct v4l2_fmtdesc fmt;
> +};
> +/*
> + * List of image formats supported by mt9v113
> + * Currently we are using 8 bit and 8x2 bit mode only, but can be
> + * extended to 10 bit mode.
> + */
> +static const struct mt9v113_fmt mt9v113_fmt_list[] = {
> +     {
> +             .mbus_code = V4L2_MBUS_FMT_UYVY8_2X8,
> +             .fmt = {
> +                     .index = 0,
> +                     .type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> +                     .flags = 0,
> +                     .description = "8-bit UYVY 4:2:2 Format",
> +                     .pixelformat = V4L2_PIX_FMT_UYVY,
> +             },
> +     },
> +     {
> +             .mbus_code = V4L2_MBUS_FMT_YUYV8_2X8,
> +             .fmt = {
> +                     .index = 1,
> +                     .type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> +                     .flags = 0,
> +                     .description = "8-bit YUYV 4:2:2 Format",
> +                     .pixelformat = V4L2_PIX_FMT_YUYV,
> +             },
> +     },
> +     {
> +             .mbus_code = V4L2_MBUS_FMT_RGB565_2X8_LE,
> +             .fmt = {
> +                     .index = 2,
> +                     .type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> +                     .flags = 0,
> +                     .description = "16-bit RGB565 format",
> +                     .pixelformat = V4L2_PIX_FMT_RGB565,
> +             },
> +     },
> +};
> +
> +/* MT9V113 register set for VGA mode */
> +static struct mt9v113_reg mt9v113_vga_reg[] = {
> +     {TOK_WRITE, 0x098C, 0x2739}, /* crop_X0_A */
> +     {TOK_WRITE, 0x0990, 0x0000}, /* val: 0 */
> +     {TOK_WRITE, 0x098C, 0x273B}, /* crop_X1_A */
> +     {TOK_WRITE, 0x0990, 0x027F}, /* val: 639 */
> +     {TOK_WRITE, 0x098C, 0x273D}, /* crop_Y0_A */
> +     {TOK_WRITE, 0x0990, 0x0000}, /* val: 0 */
> +     {TOK_WRITE, 0x098C, 0x273F}, /* crop_Y1_A */
> +     {TOK_WRITE, 0x0990, 0x01DF}, /* val: 479 */
> +     {TOK_WRITE, 0x098C, 0x2703}, /* output_width_A */
> +     {TOK_WRITE, 0x0990, 0x0280}, /* val: 640 */
> +     {TOK_WRITE, 0x098C, 0x2705}, /* out_height_A */
> +     {TOK_WRITE, 0x0990, 0x01E0}, /* val: 480 */
> +     {TOK_WRITE, 0x098C, 0xA103}, /* cmd */
> +     {TOK_WRITE, 0x0990, 0x0005}, /* val: 5 - Refresh */
> +     {TOK_DELAY, 0, 100},
> +     {TOK_TERM, 0, 0},
> +};
> +
> +/* MT9V113 default register values */
> +static struct mt9v113_reg mt9v113_reg_list[] = {
> +     {TOK_WRITE, 0x0018, 0x4028},
> +     {TOK_DELAY, 0, 100},
> +     {TOK_WRITE, 0x001A, 0x0011},
> +     {TOK_WRITE, 0x001A, 0x0010},
> +     {TOK_WRITE, 0x0018, 0x4028},
> +     {TOK_DELAY, 0, 100},
> +     {TOK_WRITE, 0x098C, 0x02F0},
> +     {TOK_WRITE, 0x0990, 0x0000},
> +     {TOK_WRITE, 0x098C, 0x02F2},
> +     {TOK_WRITE, 0x0990, 0x0210},
> +     {TOK_WRITE, 0x098C, 0x02F4},
> +     {TOK_WRITE, 0x0990, 0x001A},
> +     {TOK_WRITE, 0x098C, 0x2145},
> +     {TOK_WRITE, 0x0990, 0x02F4},
> +     {TOK_WRITE, 0x098C, 0xA134},
> +     {TOK_WRITE, 0x0990, 0x0001},
> +     {TOK_WRITE, 0x31E0, 0x0001},
> +     {TOK_WRITE, 0x001A, 0x0210},
> +     {TOK_WRITE, 0x001E, 0x0777},
> +     {TOK_WRITE, 0x0016, 0x42DF},
> +     {TOK_WRITE, 0x0014, 0x2145},
> +     {TOK_WRITE, 0x0014, 0x2145},
> +     {TOK_WRITE, 0x0010, 0x0431},
> +     {TOK_WRITE, 0x0012, 0x0000},
> +     {TOK_WRITE, 0x0014, 0x244B},
> +     {TOK_WRITE, 0x0014, 0x304B},
> +     {TOK_DELAY, 0, 100},
> +     {TOK_WRITE, 0x0014, 0xB04A},
> +     {TOK_WRITE, 0x098C, 0xAB1F},
> +     {TOK_WRITE, 0x0990, 0x00C7},
> +     {TOK_WRITE, 0x098C, 0xAB31},
> +     {TOK_WRITE, 0x0990, 0x001E},
> +     {TOK_WRITE, 0x098C, 0x274F},
> +     {TOK_WRITE, 0x0990, 0x0004},
> +     {TOK_WRITE, 0x098C, 0x2741},
> +     {TOK_WRITE, 0x0990, 0x0004},
> +     {TOK_WRITE, 0x098C, 0xAB20},
> +     {TOK_WRITE, 0x0990, 0x0054},
> +     {TOK_WRITE, 0x098C, 0xAB21},
> +     {TOK_WRITE, 0x0990, 0x0046},
> +     {TOK_WRITE, 0x098C, 0xAB22},
> +     {TOK_WRITE, 0x0990, 0x0002},
> +     {TOK_WRITE, 0x098C, 0xAB24},
> +     {TOK_WRITE, 0x0990, 0x0005},
> +     {TOK_WRITE, 0x098C, 0x2B28},
> +     {TOK_WRITE, 0x0990, 0x170C},
> +     {TOK_WRITE, 0x098C, 0x2B2A},
> +     {TOK_WRITE, 0x0990, 0x3E80},
> +     {TOK_WRITE, 0x3210, 0x09A8},
> +     {TOK_WRITE, 0x098C, 0x2306},
> +     {TOK_WRITE, 0x0990, 0x0315},
> +     {TOK_WRITE, 0x098C, 0x2308},
> +     {TOK_WRITE, 0x0990, 0xFDDC},
> +     {TOK_WRITE, 0x098C, 0x230A},
> +     {TOK_WRITE, 0x0990, 0x003A},
> +     {TOK_WRITE, 0x098C, 0x230C},
> +     {TOK_WRITE, 0x0990, 0xFF58},
> +     {TOK_WRITE, 0x098C, 0x230E},
> +     {TOK_WRITE, 0x0990, 0x02B7},
> +     {TOK_WRITE, 0x098C, 0x2310},
> +     {TOK_WRITE, 0x0990, 0xFF31},
> +     {TOK_WRITE, 0x098C, 0x2312},
> +     {TOK_WRITE, 0x0990, 0xFF4C},
> +     {TOK_WRITE, 0x098C, 0x2314},
> +     {TOK_WRITE, 0x0990, 0xFE4C},
> +     {TOK_WRITE, 0x098C, 0x2316},
> +     {TOK_WRITE, 0x0990, 0x039E},
> +     {TOK_WRITE, 0x098C, 0x2318},
> +     {TOK_WRITE, 0x0990, 0x001C},
> +     {TOK_WRITE, 0x098C, 0x231A},
> +     {TOK_WRITE, 0x0990, 0x0039},
> +     {TOK_WRITE, 0x098C, 0x231C},
> +     {TOK_WRITE, 0x0990, 0x007F},
> +     {TOK_WRITE, 0x098C, 0x231E},
> +     {TOK_WRITE, 0x0990, 0xFF77},
> +     {TOK_WRITE, 0x098C, 0x2320},
> +     {TOK_WRITE, 0x0990, 0x000A},
> +     {TOK_WRITE, 0x098C, 0x2322},
> +     {TOK_WRITE, 0x0990, 0x0020},
> +     {TOK_WRITE, 0x098C, 0x2324},
> +     {TOK_WRITE, 0x0990, 0x001B},
> +     {TOK_WRITE, 0x098C, 0x2326},
> +     {TOK_WRITE, 0x0990, 0xFFC6},
> +     {TOK_WRITE, 0x098C, 0x2328},
> +     {TOK_WRITE, 0x0990, 0x0086},
> +     {TOK_WRITE, 0x098C, 0x232A},
> +     {TOK_WRITE, 0x0990, 0x00B5},
> +     {TOK_WRITE, 0x098C, 0x232C},
> +     {TOK_WRITE, 0x0990, 0xFEC3},
> +     {TOK_WRITE, 0x098C, 0x232E},
> +     {TOK_WRITE, 0x0990, 0x0001},
> +     {TOK_WRITE, 0x098C, 0x2330},
> +     {TOK_WRITE, 0x0990, 0xFFEF},
> +     {TOK_WRITE, 0x098C, 0xA348},
> +     {TOK_WRITE, 0x0990, 0x0008},
> +     {TOK_WRITE, 0x098C, 0xA349},
> +     {TOK_WRITE, 0x0990, 0x0002},
> +     {TOK_WRITE, 0x098C, 0xA34A},
> +     {TOK_WRITE, 0x0990, 0x0090},
> +     {TOK_WRITE, 0x098C, 0xA34B},
> +     {TOK_WRITE, 0x0990, 0x00FF},
> +     {TOK_WRITE, 0x098C, 0xA34C},
> +     {TOK_WRITE, 0x0990, 0x0075},
> +     {TOK_WRITE, 0x098C, 0xA34D},
> +     {TOK_WRITE, 0x0990, 0x00EF},
> +     {TOK_WRITE, 0x098C, 0xA351},
> +     {TOK_WRITE, 0x0990, 0x0000},
> +     {TOK_WRITE, 0x098C, 0xA352},
> +     {TOK_WRITE, 0x0990, 0x007F},
> +     {TOK_WRITE, 0x098C, 0xA354},
> +     {TOK_WRITE, 0x0990, 0x0043},
> +     {TOK_WRITE, 0x098C, 0xA355},
> +     {TOK_WRITE, 0x0990, 0x0001},
> +     {TOK_WRITE, 0x098C, 0xA35D},
> +     {TOK_WRITE, 0x0990, 0x0078},
> +     {TOK_WRITE, 0x098C, 0xA35E},
> +     {TOK_WRITE, 0x0990, 0x0086},
> +     {TOK_WRITE, 0x098C, 0xA35F},
> +     {TOK_WRITE, 0x0990, 0x007E},
> +     {TOK_WRITE, 0x098C, 0xA360},
> +     {TOK_WRITE, 0x0990, 0x0082},
> +     {TOK_WRITE, 0x098C, 0x2361},
> +     {TOK_WRITE, 0x0990, 0x0040},
> +     {TOK_WRITE, 0x098C, 0xA363},
> +     {TOK_WRITE, 0x0990, 0x00D2},
> +     {TOK_WRITE, 0x098C, 0xA364},
> +     {TOK_WRITE, 0x0990, 0x00F6},
> +     {TOK_WRITE, 0x098C, 0xA302},
> +     {TOK_WRITE, 0x0990, 0x0000},
> +     {TOK_WRITE, 0x098C, 0xA303},
> +     {TOK_WRITE, 0x0990, 0x00EF},
> +     {TOK_WRITE, 0x098C, 0xAB20},
> +     {TOK_WRITE, 0x0990, 0x0024},
> +     {TOK_WRITE, 0x098C, 0xA103},
> +     {TOK_WRITE, 0x0990, 0x0006},
> +     {TOK_DELAY, 0, 100},
> +     {TOK_WRITE, 0x098C, 0xA103},
> +     {TOK_WRITE, 0x0990, 0x0005},
> +     {TOK_DELAY, 0, 100},
> +     {TOK_WRITE, 0x098C, 0x222D},
> +     {TOK_WRITE, 0x0990, 0x0088},
> +     {TOK_WRITE, 0x098C, 0xA408},
> +     {TOK_WRITE, 0x0990, 0x0020},
> +     {TOK_WRITE, 0x098C, 0xA409},
> +     {TOK_WRITE, 0x0990, 0x0023},
> +     {TOK_WRITE, 0x098C, 0xA40A},
> +     {TOK_WRITE, 0x0990, 0x0027},
> +     {TOK_WRITE, 0x098C, 0xA40B},
> +     {TOK_WRITE, 0x0990, 0x002A},
> +     {TOK_WRITE, 0x098C, 0x2411},
> +     {TOK_WRITE, 0x0990, 0x0088},
> +     {TOK_WRITE, 0x098C, 0x2413},
> +     {TOK_WRITE, 0x0990, 0x00A4},
> +     {TOK_WRITE, 0x098C, 0x2415},
> +     {TOK_WRITE, 0x0990, 0x0088},
> +     {TOK_WRITE, 0x098C, 0x2417},
> +     {TOK_WRITE, 0x0990, 0x00A4},
> +     {TOK_WRITE, 0x098C, 0xA404},
> +     {TOK_WRITE, 0x0990, 0x0010},
> +     {TOK_WRITE, 0x098C, 0xA40D},
> +     {TOK_WRITE, 0x0990, 0x0002},
> +     {TOK_WRITE, 0x098C, 0xA40E},
> +     {TOK_WRITE, 0x0990, 0x0003},
> +     {TOK_WRITE, 0x098C, 0xA103},
> +     {TOK_WRITE, 0x0990, 0x0006},
> +     {TOK_DELAY, 0, 100},
> +     /* test pattern all white*/
> +     /* {TOK_WRITE, 0x098C, 0xA766},
> +     {TOK_WRITE, 0x0990, 0x0001},
> +     */
> +     {TOK_WRITE, 0x098C, 0xA103},
> +     {TOK_WRITE, 0x0990, 0x0005},
> +     {TOK_DELAY, 0, 100},
> +     {TOK_TERM, 0, 0},
> +};
> +
> +static int mt9v113_read_reg(struct i2c_client *client, unsigned short
> reg)
> +{
> +     int err = 0;
> +     struct i2c_msg msg[1];
> +     unsigned char data[2];
> +     unsigned short val = 0;
> +
> +     if (!client->adapter)
> +             return -ENODEV;
> +
> +     msg->addr = client->addr;
> +     msg->flags = 0;
> +     msg->len = I2C_TWO_BYTE_TRANSFER;
> +     msg->buf = data;
> +     data[0] = (reg & I2C_TXRX_DATA_MASK_UPPER) >> I2C_TXRX_DATA_SHIFT;
> +     data[1] = (reg & I2C_TXRX_DATA_MASK);
> +     err = i2c_transfer(client->adapter, msg, 1);
> +     if (err >= 0) {
> +             msg->flags = I2C_M_RD;
> +             msg->len = I2C_TWO_BYTE_TRANSFER;       /* 2 byte read */
> +             err = i2c_transfer(client->adapter, msg, 1);
> +             if (err >= 0) {
> +                     val = ((data[0] & I2C_TXRX_DATA_MASK) <<
> +                             I2C_TXRX_DATA_SHIFT) |
> +                             (data[1] & I2C_TXRX_DATA_MASK);
> +             }
> +     }
> +
> +     v4l_dbg(1, debug, client,
> +              "mt9v113_read_reg reg=0x%x, val=0x%x\n", reg, val);
> +
> +     return (int)(0xffff & val);
> +}
> +
> +static int mt9v113_write_reg(struct i2c_client *client, unsigned short
> reg,
> +                          unsigned short val)
> +{
> +     int err = -EAGAIN; /* To enter below loop, err has to be negative */
> +     int trycnt = 0;
> +     struct i2c_msg msg[1];
> +     unsigned char data[4];
> +
> +     v4l_dbg(1, debug, client,
> +                     "mt9v113_write_reg reg=0x%x, val=0x%x\n", reg, val);
> +
> +     if (!client->adapter)
> +             return -ENODEV;
> +
> +     while ((err < 0) && (trycnt < I2C_RETRY_COUNT)) {
> +             trycnt++;
> +             msg->addr = client->addr;
> +             msg->flags = 0;
> +             msg->len = I2C_FOUR_BYTE_TRANSFER;
> +             msg->buf = data;
> +             data[0] = (reg & I2C_TXRX_DATA_MASK_UPPER) >>
> +                     I2C_TXRX_DATA_SHIFT;
> +             data[1] = (reg & I2C_TXRX_DATA_MASK);
> +             data[2] = (val & I2C_TXRX_DATA_MASK_UPPER) >>
> +                     I2C_TXRX_DATA_SHIFT;
> +             data[3] = (val & I2C_TXRX_DATA_MASK);
> +             err = i2c_transfer(client->adapter, msg, 1);
> +     }
> +     if (err < 0)
> +             printk(KERN_INFO "\n I2C write failed");
> +
> +     return err;
> +}
> +
> +/*
> + * mt9v113_write_regs : Initializes a list of registers
> + *           if token is TOK_TERM, then entire write operation terminates
> + *           if token is TOK_DELAY, then a delay of 'val' msec is
> introduced
> + *           if token is TOK_SKIP, then the register write is skipped
> + *           if token is TOK_WRITE, then the register write is performed
> + *
> + * reglist - list of registers to be written
> + * Returns zero if successful, or non-zero otherwise.
> + */
> +static int mt9v113_write_regs(struct i2c_client *client,
> +                           const struct mt9v113_reg reglist[])
> +{
> +     int err;
> +     const struct mt9v113_reg *next = reglist;
> +
> +     for (; next->token != TOK_TERM; next++) {
> +             if (next->token == TOK_DELAY) {
> +                     msleep(next->val);
> +                     continue;
> +             }
> +
> +             if (next->token == TOK_SKIP)
> +                     continue;
> +
> +             err = mt9v113_write_reg(client, next->reg, next->val);
> +             if (err < 0) {
> +                     v4l_err(client, "Write failed. Err[%d]\n", err);
> +                     return err;
> +             }
> +     }
> +     return 0;
> +}
> +
> +/*
> + * Configure the mt9v113 with the current register settings
> + * Returns zero if successful, or non-zero otherwise.
> + */
> +static int mt9v113_def_config(struct v4l2_subdev *subdev)
> +{
> +     struct i2c_client *client = v4l2_get_subdevdata(subdev);
> +
> +     /* common register initialization */
> +     return mt9v113_write_regs(client, mt9v113_reg_list);
> +}
> +
> +/*
> + * Configure the MT9V113 to VGA mode
> + * Returns zero if successful, or non-zero otherwise.
> + */
> +static int mt9v113_vga_mode(struct v4l2_subdev *subdev)
> +{
> +     struct i2c_client *client = v4l2_get_subdevdata(subdev);
> +
> +     return mt9v113_write_regs(client, mt9v113_vga_reg);
> +}
> +
> +/*
> + * Detect if an mt9v113 is present, and if so which revision.
> + * A device is considered to be detected if the chip ID (LSB and MSB)
> + * registers match the expected values.
> + * Any value of the rom version register is accepted.
> + * Returns ENODEV error number if no device is detected, or zero
> + * if a device is detected.
> + */
> +static int mt9v113_detect(struct v4l2_subdev *subdev)
> +{
> +     struct mt9v113 *decoder = to_mt9v113(subdev);
> +     struct i2c_client *client = v4l2_get_subdevdata(subdev);
> +     unsigned short val = 0;
> +
> +     val = mt9v113_read_reg(client, REG_CHIP_ID);
> +     v4l_dbg(1, debug, client, "chip id detected 0x%x\n", val);
> +
> +     if (MT9V113_CHIP_ID != val) {
> +             /* We didn't read the values we expected, so this must not be
> +              * MT9V113.
> +              */
> +             v4l_err(client, "chip id mismatch read 0x%x, expecting 0x%x\n",
> +                             val, MT9V113_CHIP_ID);
> +             return -ENODEV;
> +     }
> +
> +     decoder->ver = val;
> +
> +     v4l_info(client, "%s found at 0x%x (%s)\n", client->name,
> +                     client->addr << 1, client->adapter->name);
> +     return 0;
> +}
> +
> +
> +/* ----------------------------------------------------------------------
> ----
> + * V4L2 subdev core operations
> + */
> +/*
> + * mt9v113_g_chip_ident - get chip identifier
> + */
> +static int mt9v113_g_chip_ident(struct v4l2_subdev *subdev,
> +                            struct v4l2_dbg_chip_ident *chip)
> +{
> +     struct i2c_client *client = v4l2_get_subdevdata(subdev);
> +
> +     return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_MT9V113,
> 0);
> +}
> +
> +/*
> + * mt9v113_dev_init - sensor init, tries to detect the sensor
> + * @subdev: pointer to standard V4L2 subdev structure
> + */
> +static int mt9v113_dev_init(struct v4l2_subdev *subdev)
> +{
> +     struct mt9v113 *decoder = to_mt9v113(subdev);
> +     int rval;
> +
> +     rval = decoder->pdata->s_power(subdev, 1);
> +     if (rval)
> +             return rval;
> +
> +     rval = mt9v113_detect(subdev);
> +
> +     decoder->pdata->s_power(subdev, 0);
> +
> +     return rval;
> +}
> +
> +/*
> + * mt9v113_s_config - set the platform data for future use
> + * @subdev: pointer to standard V4L2 subdev structure
> + * @irq:
> + * @platform_data: sensor platform_data
> + */
> +static int mt9v113_s_config(struct v4l2_subdev *subdev, int irq,
> +                        void *platform_data)
> +{
> +     struct mt9v113 *decoder = to_mt9v113(subdev);
> +     int rval;
> +
> +     if (platform_data == NULL)
> +             return -ENODEV;
> +
> +     decoder->pdata = platform_data;
> +
> +     rval = mt9v113_dev_init(subdev);
> +     if (rval)
> +             return rval;
> +
> +     return 0;
> +}
> +
> +/*
> + * mt9v113_s_power - Set power function
> + * @subdev: pointer to standard V4L2 subdev structure
> + * @on: power state to which device is to be set
> + *
> + * Sets devices power state to requested state, if possible.
> + */
> +static int mt9v113_s_power(struct v4l2_subdev *subdev, int on)
> +{
> +     struct mt9v113 *decoder = to_mt9v113(subdev);
> +     struct i2c_client *client = v4l2_get_subdevdata(subdev);
> +     int rval;
> +
> +     if (on) {
> +             rval = decoder->pdata->s_power(subdev, 1);
> +             if (rval)
> +                     goto out;
> +             rval = mt9v113_def_config(subdev);
> +             if (rval) {
> +                     decoder->pdata->s_power(subdev, 0);
> +                     goto out;
> +             }
> +             rval = mt9v113_vga_mode(subdev);
> +             if (rval) {
> +                     decoder->pdata->s_power(subdev, 0);
> +                     goto out;
> +             }
> +     } else {
> +             rval = decoder->pdata->s_power(subdev, 0);
> +             if (rval)
> +                     goto out;
> +     }
> +
> +     decoder->power = on;
> +out:
> +     if (rval < 0)
> +             v4l_err(client, "Unable to set target power state\n");
> +
> +     return rval;
> +}
> +
> +/* ----------------------------------------------------------------------
> ----
> + * V4L2 subdev file operations
> + */
> +static int mt9v113_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh
> *fh)
> +{
> +     struct v4l2_mbus_framefmt *format;
> +     struct v4l2_rect *crop;
> +
> +     /*
> +      * Default configuration -
> +      *      Resolution: VGA
> +      *      Format: UYVY
> +      *      crop = window
> +      */
> +     crop = v4l2_subdev_get_try_crop(fh, 0);
> +     crop->left = 0;
> +     crop->top = 0;
> +     crop->width = MT9V113_DEF_WIDTH;
> +     crop->height = MT9V113_DEF_HEIGHT;
> +
> +     format = v4l2_subdev_get_try_format(fh, 0);
> +     format->code = V4L2_MBUS_FMT_UYVY8_2X8;
> +     format->width = MT9V113_DEF_WIDTH;
> +     format->height = MT9V113_DEF_HEIGHT;
> +     format->field = V4L2_FIELD_NONE;
> +     format->colorspace = V4L2_COLORSPACE_JPEG;
> +
> +     return 0;
> +}
> +
> +/* ----------------------------------------------------------------------
> ----
> + * V4L2 subdev video operations
> + */
> +static int mt9v113_s_stream(struct v4l2_subdev *subdev, int streaming)
> +{
> +     /*
> +      * FIXME: We should put here the specific reg setting to turn on
> +      * streaming in sensor.
> +      */
> +     return 0;
> +}
> +
> +/* ----------------------------------------------------------------------
> ----
> + * V4L2 subdev pad operations
> + */
> +static int mt9v113_enum_mbus_code(struct v4l2_subdev *subdev,
> +                               struct v4l2_subdev_fh *fh,
> +                               struct v4l2_subdev_mbus_code_enum *code)
> +{
> +     struct mt9v113 *mt9v113 = to_mt9v113(subdev);
> +
> +     if (code->index >= ARRAY_SIZE(mt9v113_fmt_list))
> +             return -EINVAL;
> +
> +     code->code = mt9v113->format.code;
> +
> +     return 0;
> +}
> +
> +static int mt9v113_enum_frame_size(struct v4l2_subdev *subdev,
> +                                struct v4l2_subdev_fh *fh,
> +                                struct v4l2_subdev_frame_size_enum *fse)
> +{
> +     int i;
> +
> +     /* Is requested media-bus format/pixelformat not found on sensor? */
> +     for (i = 0; i < ARRAY_SIZE(mt9v113_fmt_list); i++) {
> +             if (fse->code == mt9v113_fmt_list[i].mbus_code)
> +                     goto fmt_found;
> +     }
> +     if (i >= ARRAY_SIZE(mt9v113_fmt_list))
> +             return -EINVAL;
> +
> +fmt_found:
> +     /*
> +      * Currently only supports VGA resolution
> +      */
> +     fse->min_width = fse->max_width = MT9V113_DEF_WIDTH;
> +     fse->min_height = fse->max_height = MT9V113_DEF_HEIGHT;
> +
> +     return 0;
> +}
> +
> +static int mt9v113_get_pad_format(struct v4l2_subdev *subdev,
> +                               struct v4l2_subdev_fh *fh,
> +                               struct v4l2_subdev_format *fmt)
> +{
> +     struct mt9v113 *mt9v113 = to_mt9v113(subdev);
> +
> +     fmt->format = mt9v113->format;
> +     return 0;
> +}
> +
> +static int mt9v113_set_pad_format(struct v4l2_subdev *subdev,
> +                               struct v4l2_subdev_fh *fh,
> +                               struct v4l2_subdev_format *fmt)
> +{
> +     int i;
> +     struct mt9v113 *mt9v113 = to_mt9v113(subdev);
> +
> +     for (i = 0; i < ARRAY_SIZE(mt9v113_fmt_list); i++) {
> +             if (fmt->format.code == mt9v113_fmt_list[i].mbus_code)
> +                     goto fmt_found;
> +     }
> +     if (i >= ARRAY_SIZE(mt9v113_fmt_list))
> +             return -EINVAL;
> +
> +fmt_found:
> +     /*
> +      * Only VGA resolution supported
> +      */
> +     fmt->format.width = MT9V113_DEF_WIDTH;
> +     fmt->format.height = MT9V113_DEF_HEIGHT;
> +     fmt->format.field = V4L2_FIELD_NONE;
> +     fmt->format.colorspace = V4L2_COLORSPACE_JPEG;
> +
> +     mt9v113->format = fmt->format;
> +
> +     return 0;
> +}
> +
> +static int mt9v113_get_crop(struct v4l2_subdev *subdev,
> +             struct v4l2_subdev_fh *fh, struct v4l2_subdev_crop *crop)
> +{
> +     struct mt9v113 *mt9v113 = to_mt9v113(subdev);
> +
> +     crop->rect = mt9v113->rect;
> +     return 0;
> +}
> +
> +static int mt9v113_set_crop(struct v4l2_subdev *subdev,
> +             struct v4l2_subdev_fh *fh, struct v4l2_subdev_crop *crop)
> +{
> +     struct mt9v113 *mt9v113 = to_mt9v113(subdev);
> +     struct v4l2_rect rect;
> +
> +     /*
> +      * Only VGA resolution/window is supported
> +      */
> +     rect.left = 0;
> +     rect.top = 0;
> +     rect.width = MT9V113_DEF_WIDTH;
> +     rect.height = MT9V113_DEF_HEIGHT;
> +
> +     mt9v113->rect = rect;
> +     crop->rect = rect;
> +
> +     return 0;
> +}
> +
> +static const struct v4l2_subdev_core_ops mt9v113_core_ops = {
> +     .g_chip_ident = mt9v113_g_chip_ident,
> +//   .s_config = mt9v113_s_config,
> +     .s_power = mt9v113_s_power,
> +};
> +
> +static const struct v4l2_subdev_internal_ops mt9v113_subdev_internal_ops
> = {
> +     .open           = mt9v113_open,
> +     .registered     = mt9v113_dev_init,
> +};
> +
> +static const struct v4l2_subdev_video_ops mt9v113_video_ops = {
> +     .s_stream = mt9v113_s_stream,
> +};
> +
> +static const struct v4l2_subdev_pad_ops mt9v113_pad_ops = {
> +     .enum_mbus_code  = mt9v113_enum_mbus_code,
> +     .enum_frame_size = mt9v113_enum_frame_size,
> +     .get_fmt         = mt9v113_get_pad_format,
> +     .set_fmt         = mt9v113_set_pad_format,
> +     .get_crop        = mt9v113_get_crop,
> +     .set_crop        = mt9v113_set_crop,
> +};
> +
> +static const struct v4l2_subdev_ops mt9v113_ops = {
> +     .core   = &mt9v113_core_ops,
> +     .video  = &mt9v113_video_ops,
> +     .pad    = &mt9v113_pad_ops,
> +};
> +
> +
> +/* ----------------------------------------------------------------------
> -------
> + * V4L2 subdev control operations
> + */
> +
> +#define V4L2_CID_TEST_PATTERN                (V4L2_CID_USER_BASE | 0x1001)
> +
> +/*
> + * mt9v113_s_ctrl - V4L2 decoder interface handler for VIDIOC_S_CTRL
> ioctl
> + * @s: pointer to standard V4L2 device structure
> + * @ctrl: pointer to v4l2_control structure
> + *
> + * If the requested control is supported, sets the control's current
> + * value in HW. Otherwise, returns -EINVAL if the control is not
> supported.
> + */
> +static int mt9v113_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +        struct mt9v113 *mt9v113 =
> +                     container_of(ctrl->handler, struct mt9v113, ctrls);
> +
> +     struct i2c_client *client = v4l2_get_subdevdata(&mt9v113->subdev);
> +     int err = -EINVAL, value;
> +
> +     if (ctrl == NULL)
> +             return err;
> +
> +     value = (__s32) ctrl->val;
> +
> +     switch (ctrl->id) {
> +     case V4L2_CID_BRIGHTNESS:
> +             if (ctrl->val < 0 || ctrl->val > 255) {
> +                     v4l_err(client, "invalid brightness setting %d\n",
> +                                     ctrl->val);
> +                     return -ERANGE;
> +             }
> +             err = mt9v113_write_reg(client, REG_BRIGHTNESS, value);
> +             if (err)
> +                     return err;
> +
> +             mt9v113_reg_list[REG_BRIGHTNESS].val = value;
> +             break;
> +     case V4L2_CID_CONTRAST:
> +             if (ctrl->val < 0 || ctrl->val > 255) {
> +                     v4l_err(client, "invalid contrast setting %d\n",
> +                                     ctrl->val);
> +                     return -ERANGE;
> +             }
> +             err = mt9v113_write_reg(client, REG_CONTRAST, value);
> +             if (err)
> +                     return err;
> +
> +             mt9v113_reg_list[REG_CONTRAST].val = value;
> +             break;
> +     case V4L2_CID_SATURATION:
> +             if (ctrl->val < 0 || ctrl->val > 255) {
> +                     v4l_err(client, "invalid saturation setting %d\n",
> +                                     ctrl->val);
> +                     return -ERANGE;
> +             }
> +             err = mt9v113_write_reg(client, REG_SATURATION, value);
> +             if (err)
> +                     return err;
> +
> +             mt9v113_reg_list[REG_SATURATION].val = value;
> +             break;
> +     case V4L2_CID_HUE:
> +             if (value == 180)
> +                     value = 0x7F;
> +             else if (value == -180)
> +                     value = 0x80;
> +             else if (value == 0)
> +                     value = 0;
> +             else {
> +                     v4l_err(client, "invalid hue setting %d\n",
> +                                     ctrl->val);
> +                     return -ERANGE;
> +             }
> +             err = mt9v113_write_reg(client, REG_HUE, value);
> +             if (err)
> +                     return err;
> +
> +             mt9v113_reg_list[REG_HUE].val = value;
> +             break;
> +     case V4L2_CID_AUTOGAIN:
> +             if (value == 1)
> +                     value = 0x0F;
> +             else if (value == 0)
> +                     value = 0x0C;
> +             else {
> +                     v4l_err(client, "invalid auto gain setting %d\n",
> +                                     ctrl->val);
> +                     return -ERANGE;
> +             }
> +             err = mt9v113_write_reg(client, REG_AFE_GAIN_CTRL, value);
> +             if (err)
> +                     return err;
> +
> +             mt9v113_reg_list[REG_AFE_GAIN_CTRL].val = value;
> +             break;
> +     case V4L2_CID_TEST_PATTERN:
> +             switch (ctrl->val) {
> +             case 0:
> +                     break;
> +             }
> +             /* FIXME Add proper Test pattern code here */
> +             return mt9v113_write_reg(client, 0, 0);
> +
> +     default:
> +             v4l_err(client, "invalid control id %d\n", ctrl->id);
> +             return err;
> +     }
> +
> +     v4l_dbg(1, debug, client,
> +                     "Set Control: ID - %d - %d", ctrl->id, ctrl->val);
> +
> +     return err;
> +}
> +
> +static struct v4l2_ctrl_ops mt9v113_ctrl_ops = {
> +     .s_ctrl = mt9v113_s_ctrl,
> +};
> +
> +static const struct v4l2_ctrl_config mt9v113_ctrls[] = {
> +     {
> +             .ops            = &mt9v113_ctrl_ops,
> +             .id             = V4L2_CID_TEST_PATTERN,
> +             .type           = V4L2_CTRL_TYPE_INTEGER,
> +             .name           = "Test pattern",
> +             .min            = 0,
> +             .max            = 1023,
> +             .step           = 1,
> +             .def            = 0,
> +             .flags          = 0,
> +     }
> +};
> +
> +
> +/*
> + * mt9v113_probe - sensor driver i2c probe handler
> + * @client: i2c driver client device structure
> + *
> + * Register sensor as an i2c client device and V4L2
> + * sub-device.
> + */
> +static int mt9v113_probe(struct i2c_client *client,
> +                      const struct i2c_device_id *id)
> +{
> +     struct mt9v113 *mt9v113;
> +     int i, ret;
> +
> +     /* Check if the adapter supports the needed features */
> +     if (!i2c_check_functionality(client->adapter,
> +                             I2C_FUNC_SMBUS_BYTE_DATA)) {
> +             v4l_err(client, "mt9v113: I2C Adapter doesn't support" \
> +                             " I2C_FUNC_SMBUS_WORD\n");
> +             return -EIO;
> +     }
> +     if (!client->dev.platform_data) {
> +             v4l_err(client, "No platform data!!\n");
> +             return -ENODEV;
> +     }
> +
> +     mt9v113 = kzalloc(sizeof(*mt9v113), GFP_KERNEL);
> +     if (mt9v113 == NULL) {
> +             v4l_err(client, "Could not able to alocate memory!!\n");
> +             return -ENOMEM;
> +     }
> +
> +     mt9v113->pdata = client->dev.platform_data;
> +
> +     /*
> +      * Initialize and register available controls
> +      */
> +     v4l2_ctrl_handler_init(&mt9v113->ctrls, ARRAY_SIZE(mt9v113_ctrls) +
> 4);
> +     v4l2_ctrl_new_std(&mt9v113->ctrls, &mt9v113_ctrl_ops,
> +                     V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
> +
> +     for (i = 0; i < ARRAY_SIZE(mt9v113_ctrls); ++i)
> +             v4l2_ctrl_new_custom(&mt9v113->ctrls, &mt9v113_ctrls[i],
> NULL);
> +
> +     mt9v113->subdev.ctrl_handler = &mt9v113->ctrls;
> +
> +     if (mt9v113->ctrls.error)
> +             v4l_info(client, "%s: error while initialization control %d\n",
> +                             __func__, mt9v113->ctrls.error);
> +
> +     /*
> +      * Default configuration -
> +      *      Resolution: VGA
> +      *      Format: UYVY
> +      *      crop = window
> +      */
> +     mt9v113->rect.left = 0;
> +     mt9v113->rect.top = 0;
> +     mt9v113->rect.width = MT9V113_DEF_WIDTH;
> +     mt9v113->rect.height = MT9V113_DEF_HEIGHT;
> +
> +     mt9v113->format.code = V4L2_MBUS_FMT_UYVY8_2X8;
> +     mt9v113->format.width = MT9V113_DEF_WIDTH;
> +     mt9v113->format.height = MT9V113_DEF_HEIGHT;
> +     mt9v113->format.field = V4L2_FIELD_NONE;
> +     mt9v113->format.colorspace = V4L2_COLORSPACE_JPEG;
> +
> +     /*
> +      * Register as a subdev
> +      */
> +     v4l2_i2c_subdev_init(&mt9v113->subdev, client, &mt9v113_ops);
> +     mt9v113->subdev.internal_ops = &mt9v113_subdev_internal_ops;
> +     mt9v113->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +     /*
> +      * Register as media entity
> +      */
> +     mt9v113->pad.flags = MEDIA_PAD_FL_SOURCE;
> +     ret = media_entity_init(&mt9v113->subdev.entity, 1, &mt9v113->pad,
> 0);
> +     if (ret < 0) {
> +             v4l_err(client, "failed to register as a media entity\n");
> +             kfree(mt9v113);
> +     }
> +
> +     return ret;
> +}
> +
> +/*
> + * mt9v113_remove - Sensor driver i2c remove handler
> + * @client: i2c driver client device structure
> + *
> + * Unregister sensor as an i2c client device and V4L2
> + * sub-device.
> + */
> +static int __exit mt9v113_remove(struct i2c_client *client)
> +{
> +     struct v4l2_subdev *subdev = i2c_get_clientdata(client);
> +     struct mt9v113 *mt9v113 = to_mt9v113(subdev);
> +
> +     v4l2_device_unregister_subdev(subdev);
> +     media_entity_cleanup(&subdev->entity);
> +     kfree(mt9v113);
> +
> +     return 0;
> +}
> +
> +static const struct i2c_device_id mt9v113_id[] = {
> +     { MT9V113_MODULE_NAME, 0 },
> +     { },
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, mt9v113_id);
> +
> +static struct i2c_driver mt9v113_i2c_driver = {
> +     .driver = {
> +             .name = MT9V113_MODULE_NAME,
> +             .owner = THIS_MODULE,
> +     },
> +     .probe = mt9v113_probe,
> +     .remove = __exit_p(mt9v113_remove),
> +     .id_table = mt9v113_id,
> +};
> +
> +static int __init mt9v113_init(void)
> +{
> +     return i2c_add_driver(&mt9v113_i2c_driver);
> +}
> +
> +static void __exit mt9v113_cleanup(void)
> +{
> +     i2c_del_driver(&mt9v113_i2c_driver);
> +}
> +
> +module_init(mt9v113_init);
> +module_exit(mt9v113_cleanup);
> +
> +MODULE_AUTHOR("Texas Instruments");
> +MODULE_DESCRIPTION("MT9V113 camera sensor driver");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/video/mt9v113_regs.h
> b/drivers/media/video/mt9v113_regs.h
> new file mode 100644
> index 0000000..64b065f
> --- /dev/null
> +++ b/drivers/media/video/mt9v113_regs.h
> @@ -0,0 +1,294 @@
> +/*
> + * drivers/media/video/mt9v113_regs.h
> + *
> + * Copyright (C) 2008 Texas Instruments Inc
> + * Author: Vaibhav Hiremath <hvaibhav@ti.com>
> + *
> + * Contributors:
> + *     Sivaraj R <sivaraj@ti.com>
> + *     Brijesh R Jadav <brijesh.j@ti.com>
> + *     Hardik Shah <hardik.shah@ti.com>
> + *     Manjunath Hadli <mrh@ti.com>
> + *     Karicheri Muralidharan <m-karicheri2@ti.com>
> + *
> + * This package is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + *
> + */
> +
> +#ifndef _MT9V113_REGS_H
> +#define _MT9V113_REGS_H
> +
> +/*
> + * MT9V113 registers
> + */
> +#define REG_CHIP_ID                          (0x00)
> +
> +/*
> + * MT9V113 registers
> + */
> +#define REG_INPUT_SEL                        (0x00)
> +#define REG_AFE_GAIN_CTRL            (0x01)
> +#define REG_VIDEO_STD                        (0x02)
> +#define REG_OPERATION_MODE           (0x03)
> +#define REG_AUTOSWITCH_MASK          (0x04)
> +
> +#define REG_COLOR_KILLER             (0x05)
> +#define REG_LUMA_CONTROL1            (0x06)
> +#define REG_LUMA_CONTROL2            (0x07)
> +#define REG_LUMA_CONTROL3            (0x08)
> +
> +#define REG_BRIGHTNESS                       (0x09)
> +#define REG_CONTRAST                 (0x0A)
> +#define REG_SATURATION                       (0x0B)
> +#define REG_HUE                              (0x0C)
> +
> +#define REG_CHROMA_CONTROL1          (0x0D)
> +#define REG_CHROMA_CONTROL2          (0x0E)
> +
> +/* 0x0F Reserved */
> +
> +#define REG_COMP_PR_SATURATION               (0x10)
> +#define REG_COMP_Y_CONTRAST          (0x11)
> +#define REG_COMP_PB_SATURATION               (0x12)
> +
> +/* 0x13 Reserved */
> +
> +#define REG_COMP_Y_BRIGHTNESS                (0x14)
> +
> +/* 0x15 Reserved */
> +
> +#define REG_AVID_START_PIXEL_LSB     (0x16)
> +#define REG_AVID_START_PIXEL_MSB     (0x17)
> +#define REG_AVID_STOP_PIXEL_LSB              (0x18)
> +#define REG_AVID_STOP_PIXEL_MSB              (0x19)
> +
> +#define REG_HSYNC_START_PIXEL_LSB    (0x1A)
> +#define REG_HSYNC_START_PIXEL_MSB    (0x1B)
> +#define REG_HSYNC_STOP_PIXEL_LSB     (0x1C)
> +#define REG_HSYNC_STOP_PIXEL_MSB     (0x1D)
> +
> +#define REG_VSYNC_START_LINE_LSB     (0x1E)
> +#define REG_VSYNC_START_LINE_MSB     (0x1F)
> +#define REG_VSYNC_STOP_LINE_LSB              (0x20)
> +#define REG_VSYNC_STOP_LINE_MSB              (0x21)
> +
> +#define REG_VBLK_START_LINE_LSB              (0x22)
> +#define REG_VBLK_START_LINE_MSB              (0x23)
> +#define REG_VBLK_STOP_LINE_LSB               (0x24)
> +#define REG_VBLK_STOP_LINE_MSB               (0x25)
> +
> +/* 0x26 - 0x27 Reserved */
> +
> +#define REG_FAST_SWTICH_CONTROL              (0x28)
> +
> +/* 0x29 Reserved */
> +
> +#define REG_FAST_SWTICH_SCART_DELAY  (0x2A)
> +
> +/* 0x2B Reserved */
> +
> +#define REG_SCART_DELAY                      (0x2C)
> +#define REG_CTI_DELAY                        (0x2D)
> +#define REG_CTI_CONTROL                      (0x2E)
> +
> +/* 0x2F - 0x31 Reserved */
> +
> +#define REG_SYNC_CONTROL             (0x32)
> +#define REG_OUTPUT_FORMATTER1                (0x33)
> +#define REG_OUTPUT_FORMATTER2                (0x34)
> +#define REG_OUTPUT_FORMATTER3                (0x35)
> +#define REG_OUTPUT_FORMATTER4                (0x36)
> +#define REG_OUTPUT_FORMATTER5                (0x37)
> +#define REG_OUTPUT_FORMATTER6                (0x38)
> +#define REG_CLEAR_LOST_LOCK          (0x39)
> +
> +#define REG_STATUS1                  (0x3A)
> +#define REG_STATUS2                  (0x3B)
> +
> +#define REG_AGC_GAIN_STATUS_LSB              (0x3C)
> +#define REG_AGC_GAIN_STATUS_MSB              (0x3D)
> +
> +/* 0x3E Reserved */
> +
> +#define REG_VIDEO_STD_STATUS         (0x3F)
> +#define REG_GPIO_INPUT1                      (0x40)
> +#define REG_GPIO_INPUT2                      (0x41)
> +
> +/* 0x42 - 0x45 Reserved */
> +
> +#define REG_AFE_COARSE_GAIN_CH1              (0x46)
> +#define REG_AFE_COARSE_GAIN_CH2              (0x47)
> +#define REG_AFE_COARSE_GAIN_CH3              (0x48)
> +#define REG_AFE_COARSE_GAIN_CH4              (0x49)
> +
> +#define REG_AFE_FINE_GAIN_PB_B_LSB   (0x4A)
> +#define REG_AFE_FINE_GAIN_PB_B_MSB   (0x4B)
> +#define REG_AFE_FINE_GAIN_Y_G_CHROMA_LSB     (0x4C)
> +#define REG_AFE_FINE_GAIN_Y_G_CHROMA_MSB     (0x4D)
> +#define REG_AFE_FINE_GAIN_PR_R_LSB   (0x4E)
> +#define REG_AFE_FINE_GAIN_PR_R_MSB   (0x4F)
> +#define REG_AFE_FINE_GAIN_CVBS_LUMA_LSB      (0x50)
> +#define REG_AFE_FINE_GAIN_CVBS_LUMA_MSB      (0x51)
> +
> +/* 0x52 - 0x68 Reserved */
> +
> +#define REG_FBIT_VBIT_CONTROL1               (0x69)
> +
> +/* 0x6A - 0x6B Reserved */
> +
> +#define REG_BACKEND_AGC_CONTROL              (0x6C)
> +
> +/* 0x6D - 0x6E Reserved */
> +
> +#define REG_AGC_DECREMENT_SPEED_CONTROL      (0x6F)
> +#define REG_ROM_VERSION                      (0x70)
> +
> +/* 0x71 - 0x73 Reserved */
> +
> +#define REG_AGC_WHITE_PEAK_PROCESSING        (0x74)
> +#define REG_FBIT_VBIT_CONTROL2               (0x75)
> +#define REG_VCR_TRICK_MODE_CONTROL   (0x76)
> +#define REG_HORIZONTAL_SHAKE_INCREMENT       (0x77)
> +#define REG_AGC_INCREMENT_SPEED              (0x78)
> +#define REG_AGC_INCREMENT_DELAY              (0x79)
> +
> +/* 0x7A - 0x7F Reserved */
> +
> +#define REG_CHIP_ID_MSB                      (0x80)
> +#define REG_CHIP_ID_LSB                      (0x81)
> +
> +/* 0x82 Reserved */
> +
> +#define REG_CPLL_SPEED_CONTROL               (0x83)
> +
> +/* 0x84 - 0x96 Reserved */
> +
> +#define REG_STATUS_REQUEST           (0x97)
> +
> +/* 0x98 - 0x99 Reserved */
> +
> +#define REG_VERTICAL_LINE_COUNT_LSB  (0x9A)
> +#define REG_VERTICAL_LINE_COUNT_MSB  (0x9B)
> +
> +/* 0x9C - 0x9D Reserved */
> +
> +#define REG_AGC_DECREMENT_DELAY              (0x9E)
> +
> +/* 0x9F - 0xB0 Reserved */
> +
> +#define REG_VDP_TTX_FILTER_1_MASK1   (0xB1)
> +#define REG_VDP_TTX_FILTER_1_MASK2   (0xB2)
> +#define REG_VDP_TTX_FILTER_1_MASK3   (0xB3)
> +#define REG_VDP_TTX_FILTER_1_MASK4   (0xB4)
> +#define REG_VDP_TTX_FILTER_1_MASK5   (0xB5)
> +#define REG_VDP_TTX_FILTER_2_MASK1   (0xB6)
> +#define REG_VDP_TTX_FILTER_2_MASK2   (0xB7)
> +#define REG_VDP_TTX_FILTER_2_MASK3   (0xB8)
> +#define REG_VDP_TTX_FILTER_2_MASK4   (0xB9)
> +#define REG_VDP_TTX_FILTER_2_MASK5   (0xBA)
> +#define REG_VDP_TTX_FILTER_CONTROL   (0xBB)
> +#define REG_VDP_FIFO_WORD_COUNT              (0xBC)
> +#define REG_VDP_FIFO_INTERRUPT_THRLD (0xBD)
> +
> +/* 0xBE Reserved */
> +
> +#define REG_VDP_FIFO_RESET           (0xBF)
> +#define REG_VDP_FIFO_OUTPUT_CONTROL  (0xC0)
> +#define REG_VDP_LINE_NUMBER_INTERRUPT        (0xC1)
> +#define REG_VDP_PIXEL_ALIGNMENT_LSB  (0xC2)
> +#define REG_VDP_PIXEL_ALIGNMENT_MSB  (0xC3)
> +
> +/* 0xC4 - 0xD5 Reserved */
> +
> +#define REG_VDP_LINE_START           (0xD6)
> +#define REG_VDP_LINE_STOP            (0xD7)
> +#define REG_VDP_GLOBAL_LINE_MODE     (0xD8)
> +#define REG_VDP_FULL_FIELD_ENABLE    (0xD9)
> +#define REG_VDP_FULL_FIELD_MODE              (0xDA)
> +
> +/* 0xDB - 0xDF Reserved */
> +
> +#define REG_VBUS_DATA_ACCESS_NO_VBUS_ADDR_INCR       (0xE0)
> +#define REG_VBUS_DATA_ACCESS_VBUS_ADDR_INCR  (0xE1)
> +#define REG_FIFO_READ_DATA                   (0xE2)
> +
> +/* 0xE3 - 0xE7 Reserved */
> +
> +#define REG_VBUS_ADDRESS_ACCESS1     (0xE8)
> +#define REG_VBUS_ADDRESS_ACCESS2     (0xE9)
> +#define REG_VBUS_ADDRESS_ACCESS3     (0xEA)
> +
> +/* 0xEB - 0xEF Reserved */
> +
> +#define REG_INTERRUPT_RAW_STATUS0    (0xF0)
> +#define REG_INTERRUPT_RAW_STATUS1    (0xF1)
> +#define REG_INTERRUPT_STATUS0                (0xF2)
> +#define REG_INTERRUPT_STATUS1                (0xF3)
> +#define REG_INTERRUPT_MASK0          (0xF4)
> +#define REG_INTERRUPT_MASK1          (0xF5)
> +#define REG_INTERRUPT_CLEAR0         (0xF6)
> +#define REG_INTERRUPT_CLEAR1         (0xF7)
> +
> +/* 0xF8 - 0xFF Reserved */
> +
> +/* The ID values we are looking for */
> +#define MT9V113_CHIP_ID_MSB          (0x51)
> +
> +#define MT9V113_IMAGE_STD_VGA                        (0x01)
> +#define MT9V113_IMAGE_STD_QVGA                       (0x02)
> +#define MT9V113_IMAGE_STD_INVALID            (0xFF)
> +
> +/*
> + * Status bit
> + */
> +#define STATUS_TV_VCR_BIT            (1<<0)
> +#define STATUS_HORZ_SYNC_LOCK_BIT    (1<<1)
> +#define STATUS_VIRT_SYNC_LOCK_BIT    (1<<2)
> +#define STATUS_CLR_SUBCAR_LOCK_BIT   (1<<3)
> +#define STATUS_LOST_LOCK_DETECT_BIT  (1<<4)
> +#define STATUS_FEILD_RATE_BIT                (1<<5)
> +#define STATUS_LINE_ALTERNATING_BIT  (1<<6)
> +#define STATUS_PEAK_WHITE_DETECT_BIT (1<<7)
> +
> +/* Tokens for register write */
> +#define TOK_WRITE                       (0)     /* token for write
> operation */
> +#define TOK_TERM                        (1)     /* terminating token */
> +#define TOK_DELAY                       (2)     /* delay token for reg
> list */
> +#define TOK_SKIP                        (3)     /* token to skip a
> register */
> +/**
> + * struct mt9v113_reg - Structure for TVP5146/47 register initialization
> values
> + * @token - Token: TOK_WRITE, TOK_TERM etc..
> + * @reg - Register offset
> + * @val - Register Value for TOK_WRITE or delay in ms for TOK_DELAY
> + */
> +struct mt9v113_reg {
> +     unsigned short token;
> +     unsigned short reg;
> +     unsigned short val;
> +};
> +
> +/**
> + * struct mt9v113_init_seq - Structure for TVP5146/47/46M2/47M1 power up
> + *           Sequence.
> + * @ no_regs - Number of registers to write for power up sequence.
> + * @ init_reg_seq - Array of registers and respective value to write.
> + */
> +struct mt9v113_init_seq {
> +     unsigned int no_regs;
> +     const struct mt9v113_reg *init_reg_seq;
> +};
> +
> +#define MT9V113_CHIP_ID                      (0x2280)
> +
> +#endif                               /* ifndef _MT9V113_REGS_H */
> diff --git a/drivers/media/video/omap3isp/ispccdc.c
> b/drivers/media/video/omap3isp/ispccdc.c
> index 39d501b..cc62f66 100644
> --- a/drivers/media/video/omap3isp/ispccdc.c
> +++ b/drivers/media/video/omap3isp/ispccdc.c
> @@ -57,6 +57,8 @@ static const unsigned int ccdc_fmts[] = {
>       V4L2_MBUS_FMT_SRGGB12_1X12,
>       V4L2_MBUS_FMT_SBGGR12_1X12,
>       V4L2_MBUS_FMT_SGBRG12_1X12,
> +        V4L2_MBUS_FMT_UYVY8_2X8,
> +        V4L2_MBUS_FMT_YUYV8_2X8,
>  };
>
>  /*
> @@ -1176,7 +1178,13 @@ static void ccdc_configure(struct isp_ccdc_device
> *ccdc)
>       else
>               syn_mode &= ~ISPCCDC_SYN_MODE_PACK8;
>
> -     isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC,
> ISPCCDC_SYN_MODE);
> +       if ((format->code == V4L2_MBUS_FMT_YUYV8_2X8) ||
> +                       (format->code == V4L2_MBUS_FMT_UYVY8_2X8))
> +               syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR16;
> +       else
> +               syn_mode &= ~ISPCCDC_SYN_MODE_INPMOD_MASK;
> +
> +       isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC,
> ISPCCDC_SYN_MODE);
>
>       /* Mosaic filter */
>       switch (format->code) {
> diff --git a/drivers/media/video/omap3isp/ispvideo.c
> b/drivers/media/video/omap3isp/ispvideo.c
> index 9cd8f1a..b47fb6e 100644
> --- a/drivers/media/video/omap3isp/ispvideo.c
> +++ b/drivers/media/video/omap3isp/ispvideo.c
> @@ -97,9 +97,12 @@ static struct isp_format_info formats[] = {
>       { V4L2_MBUS_FMT_UYVY8_1X16, V4L2_MBUS_FMT_UYVY8_1X16,
>         V4L2_MBUS_FMT_UYVY8_1X16, 0,
>         V4L2_PIX_FMT_UYVY, 16, },
> -     { V4L2_MBUS_FMT_YUYV8_1X16, V4L2_MBUS_FMT_YUYV8_1X16,
> -       V4L2_MBUS_FMT_YUYV8_1X16, 0,
> +     { V4L2_MBUS_FMT_YUYV8_2X8, V4L2_MBUS_FMT_YUYV8_2X8,
> +       V4L2_MBUS_FMT_YUYV8_2X8, 0,
>         V4L2_PIX_FMT_YUYV, 16, },
> +     { V4L2_MBUS_FMT_UYVY8_2X8, V4L2_MBUS_FMT_UYVY8_2X8,
> +       V4L2_MBUS_FMT_UYVY8_2X8, 0,
> +       V4L2_PIX_FMT_UYVY, 16, },
>  };
>
>  const struct isp_format_info *
> diff --git a/include/media/mt9v113.h b/include/media/mt9v113.h
> new file mode 100644
> index 0000000..0d37f17
> --- /dev/null
> +++ b/include/media/mt9v113.h
> @@ -0,0 +1,70 @@
> +/*
> + * drivers/media/video/mt9v113.h
> + *
> + * Copyright (C) 2008 Texas Instruments Inc
> + * Author: Vaibhav Hiremath <hvaibhav@ti.com>
> + *
> + * Contributors:
> + *     Sivaraj R <sivaraj@ti.com>
> + *     Brijesh R Jadav <brijesh.j@ti.com>
> + *     Hardik Shah <hardik.shah@ti.com>
> + *     Manjunath Hadli <mrh@ti.com>
> + *     Karicheri Muralidharan <m-karicheri2@ti.com>
> + *
> + * This package is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + *
> + */
> +
> +#ifndef _MT9V113_H
> +#define _MT9V113_H
> +
> +#include <media/v4l2-subdev.h>
> +#include <media/media-entity.h>
> +
> +/*
> + * Other macros
> + */
> +#define MT9V113_MODULE_NAME          "mt9v113"
> +
> +/* Number of pixels and number of lines per frame for different standards
> */
> +#define VGA_NUM_ACTIVE_PIXELS                640
> +#define VGA_NUM_ACTIVE_LINES         480
> +#define QVGA_NUM_ACTIVE_PIXELS               320
> +#define QVGA_NUM_ACTIVE_LINES                240
> +
> +struct mt9v113_platform_data {
> +     int (*s_power)(struct v4l2_subdev *subdev, int on);
> +     int (*set_xclk)(struct v4l2_subdev *subdev, int hz);
> +     int (*configure_interface)(struct v4l2_subdev *subdev, u32 pixclk);
> +};
> +
> +/*i2c adress for MT9V113*/
> +#define MT9V113_I2C_ADDR             (0x78 >> 1)
> +
> +#define I2C_ONE_BYTE_TRANSFER                (1)
> +#define I2C_TWO_BYTE_TRANSFER                (2)
> +#define I2C_THREE_BYTE_TRANSFER              (3)
> +#define I2C_FOUR_BYTE_TRANSFER               (4)
> +#define I2C_TXRX_DATA_MASK           (0x00FF)
> +#define I2C_TXRX_DATA_MASK_UPPER     (0xFF00)
> +#define I2C_TXRX_DATA_SHIFT          (8)
> +
> +#define MT9V113_VGA_30FPS  (1130)
> +#define MT9V113_QVGA_30FPS  (1131)
> +
> +#define MT9V113_CLK_MAX              (54000000) /* 54MHz */
> +#define MT9V113_CLK_MIN              (6000000)  /* 6Mhz */
> +
> +#endif                               /* ifndef _MT9V113_H */
> +
> diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-
> ident.h
> index b3edb67..a3446cf 100644
> --- a/include/media/v4l2-chip-ident.h
> +++ b/include/media/v4l2-chip-ident.h
> @@ -297,6 +297,7 @@ enum {
>       V4L2_IDENT_MT9T112              = 45022,
>       V4L2_IDENT_MT9V111              = 45031,
>       V4L2_IDENT_MT9V112              = 45032,
> +     V4L2_IDENT_MT9V113              = 45033,
>
>       /* HV7131R CMOS sensor: just ident 46000 */
>       V4L2_IDENT_HV7131R              = 46000,
> --
> 1.7.0.4
>
> --
> You received this message because you are subscribed to the Google Groups
> "Beagle Board" group.
> To post to this group, send email to beagleboard@googlegroups.com.
> To unsubscribe from this group, send email to
> beagleboard+unsubscribe@googlegroups.com.
> For more options, visit this group at
> http://groups.google.com/group/beagleboard?hl=en.

