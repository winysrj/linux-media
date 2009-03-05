Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f178.google.com ([209.85.218.178]:62307 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbZCEAXG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 19:23:06 -0500
Subject: Re: [PATCH 3/5] OV3640: Add driver
From: Alexey Klimov <klimov.linux@gmail.com>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
	"DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	MiaoStanley <stanleymiao@hotmail.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Lakhani, Amish" <amish@ti.com>, "Menon, Nishanth" <nm@ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89442E1D9222@dlee02.ent.ti.com>
References: <A24693684029E5489D1D202277BE89442E1D9222@dlee02.ent.ti.com>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 03:23:33 +0300
Message-Id: <1236212613.8608.19.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-03-03 at 14:44 -0600, Aguirre Rodriguez, Sergio Alberto
wrote:
> This driver has been currently being tested with:
>  - OMAP3430SDP platform, working in Parallel and CSI2 modes.
>  - OMAPZOOM (LDP) platform, working in CSI2 mode.
> 
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  drivers/media/video/Kconfig       |   15 +
>  drivers/media/video/Makefile      |    1 +
>  drivers/media/video/ov3640.c      | 2202 +++++++++++++++++++++++++++++++++++++
>  drivers/media/video/ov3640_regs.h |  600 ++++++++++
>  include/media/ov3640.h            |   31 +
>  5 files changed, 2849 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/ov3640.c
>  create mode 100644 drivers/media/video/ov3640_regs.h
>  create mode 100644 include/media/ov3640.h
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 225d9cf..e99c93f 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -321,6 +321,21 @@ config VIDEO_DW9710
>           DW9710 coil.  It is currently working with the TI OMAP3
>           camera controller and micron MT9P012 sensor.
> 
> +config VIDEO_OV3640
> +       tristate "OmniVision ov3640 smart sensor driver (3MP)"
> +       depends on I2C && VIDEO_V4L2
> +       ---help---
> +         This is a Video4Linux2 sensor-level driver for the OmniVision
> +         OV3640 camera.  It is currently working with the TI OMAP3
> +          camera controller.
> +
> +config VIDEO_OV3640_CSI2
> +       bool "CSI2 bus support for OmniVision ov3640 sensor"
> +       depends on I2C && VIDEO_V4L2 && VIDEO_OV3640
> +       ---help---
> +         This enables the use of the CSI2 serial bus for the ov3640
> +         camera.
> +
>  config VIDEO_SAA7110
>         tristate "Philips SAA7110 video decoder"
>         depends on VIDEO_V4L1 && I2C
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index 52a34d9..33b3976 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -113,6 +113,7 @@ obj-$(CONFIG_VIDEO_OMAP3) += omap34xxcam.o
>  obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
>  obj-$(CONFIG_VIDEO_MT9P012)     += mt9p012.o
>  obj-$(CONFIG_VIDEO_DW9710)     += dw9710.o
> +obj-$(CONFIG_VIDEO_OV3640)     += ov3640.o
> 
>  obj-$(CONFIG_USB_DABUSB)        += dabusb.o
>  obj-$(CONFIG_USB_OV511)         += ov511.o
> diff --git a/drivers/media/video/ov3640.c b/drivers/media/video/ov3640.c
> new file mode 100644
> index 0000000..9f5cb13
> --- /dev/null
> +++ b/drivers/media/video/ov3640.c
> @@ -0,0 +1,2202 @@
> +/*
> + * drivers/media/video/ov3640.c
> + *
> + * ov3640 sensor driver
> + *
> + *
> + * Copyright (C) 2008 Texas Instruments.

2009 ?

> + *
> + * Leverage ov3640.c
> + *
> + * This file is licensed under the terms of the GNU General Public License
> + * version 2. This program is licensed "as is" without any warranty of any
> + * kind, whether express or implied.
> + */
> +
> +#include <linux/i2c.h>
> +#include <linux/delay.h>
> +#include <media/v4l2-int-device.h>
> +#include <media/ov3640.h>
> +#include "ov3640_regs.h"
> +#include "omap34xxcam.h"
> +#include "isp/ispcsi2.h"
> +
> +#define OV3640_DRIVER_NAME  "ov3640"
> +#define MOD_NAME "OV3640: "
> +
> +#define I2C_M_WR 0
> +
> +/* Register initialization tables for ov3640 */
> +/* Terminating list entry for reg */
> +#define OV3640_REG_TERM                0xFFFF
> +/* Terminating list entry for val */
> +#define OV3640_VAL_TERM                0xFF
> +
> +#define OV3640_USE_XCLKA       0
> +#define OV3640_USE_XCLKB       1
> +
> +#define OV3640_CSI2_VIRTUAL_ID 0x1
> +
> +/* FPS Capabilities */
> +#define OV3640_MIN_FPS                 5
> +#define OV3640_DEF_FPS                 15
> +#define OV3640_MAX_FPS                 30
> +
> +#define OV3640_MIN_BRIGHT              0
> +#define OV3640_MAX_BRIGHT              6
> +#define OV3640_DEF_BRIGHT              0
> +#define OV3640_BRIGHT_STEP             1
> +
> +#define OV3640_DEF_CONTRAST            0
> +#define OV3640_MIN_CONTRAST            0
> +#define OV3640_MAX_CONTRAST            6
> +#define OV3640_CONTRAST_STEP           1
> +
> +#define OV3640_DEF_COLOR               0
> +#define OV3640_MIN_COLOR               0
> +#define OV3640_MAX_COLOR               2
> +#define OV3640_COLOR_STEP              1
> +
> +#define SENSOR_DETECTED                1
> +#define SENSOR_NOT_DETECTED    0
> +
> +/* NOTE: Set this as 0 for enabling SoC mode */
> +#define OV3640_RAW_MODE        1
> +
> +/* XCLK Frequency in Hz*/
> +#define OV3640_XCLK_MIN                24000000
> +#define OV3640_XCLK_MAX                24000000
> +
> +
> +/* High byte of product ID */
> +#define OV3640_PIDH_MAGIC      0x36
> +/* Low byte of product ID  */
> +#define OV3640_PIDL_MAGIC1     0x41
> +#define OV3640_PIDL_MAGIC2     0x4C
> +
> +/* define a structure for ov3640 register initialization values */
> +struct ov3640_reg {
> +       unsigned int reg;
> +       unsigned char val;
> +};
> +
> +enum image_size_ov {
> +       XGA,
> +       QXGA
> +};
> +enum pixel_format_ov {
> +       YUV,
> +       RGB565,
> +       RGB555,
> +       RAW10
> +};
> +
> +#define OV_NUM_IMAGE_SIZES             2
> +#define OV_NUM_PIXEL_FORMATS           4
> +#define OV_NUM_FPS                     3
> +
> +struct capture_size_ov {
> +       unsigned long width;
> +       unsigned long height;
> +};
> +
> +const static struct ov3640_reg ov3640_common[2][100] = {
> +       /* XGA_Default settings */
> +       {
> +               {OV3640_AEC_H, 0x03},
> +               {OV3640_AEC_L, 0x0F},
> +               {OV3640_AGC_L, 0x07},
> +               {0x304d, 0x45},
> +               {0x30aa, 0x45},
> +               {OV3640_IO_CTRL1, 0xff},
> +               {OV3640_IO_CTRL2, 0x10},
> +               {OV3640_WPT_HISH, 0x38},
> +               {OV3640_BPT_HISL, 0x30},
> +               {OV3640_VPT, 0x61},
> +               {0x3082, 0x20},
> +               {OV3640_AUTO_3, OV3640_AUTO_3_DUMMYFC_1FRAME |
> +                                               OV3640_AUTO_3_AGCGAINCEIL_32X},
> +               {OV3640_AUTO_1, OV3640_AUTO_1_FASTAEC |
> +                                       OV3640_AUTO_1_AECBIGSTEPS |
> +                                       OV3640_AUTO_1_BANDINGFILTEREN |
> +                                       OV3640_AUTO_1_AUTOBANDINGFILTER |
> +                                       OV3640_AUTO_1_EXTRBRIGHTEXPEN
> +#if (OV3640_RAW_MODE == 0)
> +                                       | OV3640_AUTO_1_AGCEN
> +                                       | OV3640_AUTO_1_AECEN
> +#endif
> +                                       },
> +               {OV3640_AHW_H, 0x08},
> +               {OV3640_AHW_L, 0x18},
> +               {OV3640_AVH_H, 0x06},
> +               {OV3640_AVH_L, 0x0c},
> +               {OV3640_WEIGHT0, 0x62},
> +               {OV3640_WEIGHT1, 0x26},
> +               {OV3640_WEIGHT2, 0xe6},
> +               {OV3640_WEIGHT3, 0x6e},
> +               {OV3640_WEIGHT4, 0xea},
> +               {OV3640_WEIGHT5, 0xae},
> +               {OV3640_WEIGHT6, 0xa6},
> +               {OV3640_WEIGHT7, 0x6a},
> +               {OV3640_SC_SYN_CTRL0, 0x02},
> +               {OV3640_SC_SYN_CTRL1, 0xfd},
> +               {OV3640_SC_SYN_CTRL2, 0x00},
> +               {OV3640_SC_SYN_CTRL3, 0xff},
> +               {OV3640_DSP_CTRL_0, 0x13},
> +               {OV3640_DSP_CTRL_1, 0xde},
> +               {OV3640_DSP_CTRL_2, 0xef},
> +               {0x3316, 0xff},
> +               {0x3317, 0x00},
> +               {0x3312, 0x26},
> +               {0x3314, 0x42},
> +               {0x3313, 0x2b},
> +               {0x3315, 0x42},
> +               {0x3310, 0xd0},
> +               {0x3311, 0xbd},
> +               {0x330c, 0x18},
> +               {0x330d, 0x18},
> +               {0x330e, 0x56},
> +               {0x330f, 0x5c},
> +               {0x330b, 0x1c},
> +               {0x3306, 0x5c},
> +               {0x3307, 0x11},
> +               {OV3640_R_A1, 0x52},
> +               {OV3640_G_A1, 0x46},
> +               {OV3640_B_A1, 0x38},
> +               {OV3640_DSPC0, 0x20},
> +               {OV3640_DSPC1, 0x17},
> +               {OV3640_DSPC2, 0x04},
> +               {OV3640_DSPC3, 0x08},
> +               {0x3507, 0x06},
> +               {0x350a, 0x4f},
> +               {OV3640_SC_CTRL0, 0x02},
> +               {OV3640_DSP_CTRL_1, 0xde},
> +               {OV3640_DSP_CTRL_4, 0xfc},
> +               {OV3640_SYS, OV3640_SYS_BASERES_XGA},
> +               {OV3640_VS_L, 0x06 + 1},
> +               {OV3640_VH_H, 0x03},
> +               {OV3640_VH_L, 0x04},
> +               {OV3640_VSYNCOPT, 0x24},
> +               {OV3640_PCLK, OV3640_PCLK_DIVBY2},
> +               {0x30d7, 0x90},
> +               {OV3640_SIZE_IN_MISC, 0x34},
> +               {OV3640_HSIZE_IN_L, 0x0c},
> +               {OV3640_VSIZE_IN_L, 0x04},
> +               {OV3640_SIZE_OUT_MISC, 0x34},
> +               {OV3640_HSIZE_OUT_L, 0x08},
> +               {OV3640_VSIZE_OUT_L, 0x04},
> +               {OV3640_ISP_PAD_CTR2, 0x42},
> +               {OV3640_ISP_XOUT_H, 0x04},
> +               {OV3640_ISP_XOUT_L, 0x00},
> +               {OV3640_ISP_YOUT_H, 0x03},
> +               {OV3640_ISP_YOUT_L, 0x00},
> +               {OV3640_TMC13, 0x04},
> +               {OV3640_OUT_CTRL00, OV3640_OUT_CTRL00_VSYNCSEL2 |
> +                                       OV3640_OUT_CTRL00_VSYNCGATE |
> +                                       OV3640_OUT_CTRL00_VSYNCPOL_NEG},
> +               {OV3640_MISC_CTRL, 0x00},
> +               {OV3640_Y_EDGE_MT, 0x60},
> +               {OV3640_BASE1, 0x03},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       /* QXGA Default settings */
> +       {
> +               {OV3640_AEC_H, 0x06},
> +               {OV3640_AEC_L, 0x1F},
> +               {OV3640_AGC_L, 0x12},
> +               {0x304d, 0x45},
> +               {0x30aa, 0x45},
> +               {OV3640_IO_CTRL0, 0xff},
> +               {OV3640_IO_CTRL1, 0xff},
> +               {OV3640_IO_CTRL2, 0x10},
> +               {0x30d7, 0x10},
> +               {OV3640_HISTO7, 0x00},
> +               {OV3640_WPT_HISH, 0x60},
> +               {OV3640_BPT_HISL, 0x58},
> +               {OV3640_VPT, 0xa1},
> +               {OV3640_TMC11, 0x02},
> +               {0x3082, 0x20},
> +               {OV3640_AHW_H, 0x08},
> +               {OV3640_AHW_L, 0x18},
> +               {OV3640_AVH_H, 0x06},
> +               {OV3640_AVH_L, 0x0c},
> +               {OV3640_WEIGHT0, 0x62},
> +               {OV3640_WEIGHT1, 0x26},
> +               {OV3640_WEIGHT2, 0xe6},
> +               {OV3640_WEIGHT3, 0x6e},
> +               {OV3640_WEIGHT4, 0xea},
> +               {OV3640_WEIGHT5, 0xae},
> +               {OV3640_WEIGHT6, 0xa6},
> +               {OV3640_WEIGHT7, 0x6a},
> +               {OV3640_AUTO_3, OV3640_AUTO_3_DUMMYFC_1FRAME |
> +                                               OV3640_AUTO_3_AGCGAINCEIL_8X},
> +               {OV3640_AUTO_1, OV3640_AUTO_1_FASTAEC |
> +                                       OV3640_AUTO_1_AECBIGSTEPS |
> +                                       OV3640_AUTO_1_BANDINGFILTEREN |
> +                                       OV3640_AUTO_1_AUTOBANDINGFILTER |
> +                                       OV3640_AUTO_1_EXTRBRIGHTEXPEN
> +#if (OV3640_RAW_MODE == 0)
> +                                       | OV3640_AUTO_1_AGCEN
> +                                       | OV3640_AUTO_1_AECEN
> +#endif
> +                                       },
> +               {OV3640_SC_SYN_CTRL0, 0x02},
> +               {OV3640_SC_SYN_CTRL1, 0xfd},
> +               {OV3640_SC_SYN_CTRL2, 0x00},
> +               {OV3640_SC_SYN_CTRL3, 0xff},
> +               {OV3640_AWB_CTRL_3, 0xa5},
> +               {0x3316, 0xff},
> +               {0x3317, 0x00},
> +               {OV3640_TMC11, 0x02},
> +               {0x3082, 0x20},
> +               {OV3640_DSP_CTRL_0, 0x13},
> +               {OV3640_DSP_CTRL_1, 0xd6},
> +               {OV3640_DSP_CTRL_2, 0xef},
> +               {OV3640_DSPC0, 0x20},
> +               {OV3640_DSPC1, 0x17},
> +               {OV3640_DSPC2, 0x04},
> +               {OV3640_DSPC3, 0x08},
> +               {OV3640_HS_H, 0x01},
> +               {OV3640_HS_L, 0x1d},
> +               {OV3640_VS_H, 0x00},
> +               {OV3640_VS_L, 0x0a + 1},
> +               {OV3640_HW_H, 0x08},
> +               {OV3640_HW_L, 0x18},
> +               {OV3640_VH_H, 0x06},
> +               {OV3640_VH_L, 0x0c},
> +               {OV3640_SIZE_IN_MISC, 0x68},
> +               {OV3640_HSIZE_IN_L, 0x18},
> +               {OV3640_VSIZE_IN_L, 0x0c},
> +               {OV3640_SIZE_OUT_MISC, 0x68},
> +               {OV3640_HSIZE_OUT_L, 0x08},
> +               {OV3640_VSIZE_OUT_L, 0x04},
> +               {OV3640_ISP_PAD_CTR2, 0x42},
> +               {OV3640_ISP_XOUT_H, 0x08},
> +               {OV3640_ISP_XOUT_L, 0x00},
> +               {OV3640_ISP_YOUT_H, 0x06},
> +               {OV3640_ISP_YOUT_L, 0x00},
> +               {0x3507, 0x06},
> +               {0x350a, 0x4f},
> +               {OV3640_OUT_CTRL00, 0xc4},
> +               /* Light Mode - Auto */
> +               {OV3640_MISC_CTRL, 0x00},
> +               /* Sharpness - Level 5 */
> +               {OV3640_Y_EDGE_MT, 0x45},
> +               /* Sharpness - Auto */
> +               {OV3640_Y_EDGE_MT, 0x60},
> +               {OV3640_BASE1, 0x03},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +};
> +
> +const static struct ov3640_reg ov3640_common_csi2[] = {
> +       /* NM OUT_CONTROL2 SOL/EOL off */
> +       {OV3640_MIPI_CTRL02, 0x22},
> +       /* NM OUT_CONTROL1E h_sel? */
> +       {OV3640_OUT_CTRL1E, 0x00},
> +       /* min_hs_zero: 6UI + 105ns */
> +       {OV3640_MIPI_CTRL22, ((6 & 0x3F) << 2) | ((105 & 0x300) >> 8)},
> +       {OV3640_MIPI_CTRL23, (105 & 0xFF)},
> +       /* min_clk_zero: 240ns */
> +       {OV3640_MIPI_CTRL26, ((0 & 0x3F) << 2) | ((240 & 0x300) >> 8)},
> +       {OV3640_MIPI_CTRL27, (240 & 0xFF)},
> +       /* min_clk_prepare: 38ns */
> +       {OV3640_MIPI_CTRL28, ((0 & 0x3F) << 2) | ((38 & 0x300) >> 8)},
> +       {OV3640_MIPI_CTRL29, (38 & 0xFF)},
> +       /* max_clk_prepare: 95ns */
> +       {OV3640_MIPI_CTRL2A, ((0 & 0x3F) << 2) | ((95 & 0x300) >> 8)},
> +       {OV3640_MIPI_CTRL2B, (95 & 0xFF)},
> +       /* min_clk_post: 52UI + 60ns */
> +       {OV3640_MIPI_CTRL2C, ((52 & 0x3F) << 2) | ((60 & 0x300) >> 8)},
> +       {OV3640_MIPI_CTRL2D, (60 & 0xFF)},
> +       /* min_hs_prepare: 4UI + 40ns */
> +       {OV3640_MIPI_CTRL32, ((4 & 0x3F) << 2) | ((40 & 0x300) >> 8)},
> +       {OV3640_MIPI_CTRL33, (40 & 0xFF)},
> +       /* ph_byte_order {DI,WC_h,WC_l} */
> +       {OV3640_MIPI_CTRL03, 0x49 | OV3640_MIPI_CTRL03_ECC_PHBYTEORDER},
> +       /* ph_byte_order2 ph={WC,DI} */
> +       {OV3640_MIPI_CTRL4C, OV3640_MIPI_CTRL4C_ECC_PHBYTEORDER2},
> +       {0x309e, 0x00},
> +       {OV3640_REG_TERM, OV3640_VAL_TERM},
> +};
> +
> +/* Array of image sizes supported by OV3640.  These must be ordered from
> + * smallest image size to largest.
> + */
> +const static struct capture_size_ov ov3640_sizes[] = {
> +       /* XGA */
> +       { 1024, 768 },
> +       /* QXGA */
> +       { 2048, 1536 },
> +};
> +
> +/**
> + * struct ov3640_sensor - main structure for storage of sensor information
> + * @pdata: access functions and data for platform level information
> + * @v4l2_int_device: V4L2 device structure structure
> + * @i2c_client: iic client device structure
> + * @pix: V4L2 pixel format information structure
> + * @timeperframe: time per frame expressed as V4L fraction
> + * @isize: base image size
> + * @ver: ov3640 chip version
> + * @width: configured width
> + * @height: configuredheight
> + * @vsize: vertical size for the image
> + * @hsize: horizontal size for the image
> + * @crop_rect: crop rectangle specifying the left,top and width and height
> + */
> +struct ov3640_sensor {
> +       const struct ov3640_platform_data *pdata;
> +       struct v4l2_int_device *v4l2_int_device;
> +       struct i2c_client *i2c_client;
> +       struct v4l2_pix_format pix;
> +       struct v4l2_fract timeperframe;
> +       int isize;
> +       int ver;
> +       int fps;
> +       unsigned long width;
> +       unsigned long height;
> +       unsigned long vsize;
> +       unsigned long hsize;
> +       struct v4l2_rect crop_rect;
> +       int state;
> +};
> +
> +static struct ov3640_sensor ov3640;
> +static struct i2c_driver ov3640sensor_i2c_driver;
> +static unsigned long xclk_current = OV3640_XCLK_MIN;
> +
> +/* List of image formats supported by OV3640 sensor */
> +const static struct v4l2_fmtdesc ov3640_formats[] = {
> +#if OV3640_RAW_MODE
> +       {
> +               .description    = "RAW10",
> +               .pixelformat    = V4L2_PIX_FMT_SGRBG10,
> +       },
> +#else
> +       {
> +               /* Note:  V4L2 defines RGB565 as:
> +                *
> +                *      Byte 0                    Byte 1
> +                *      g2 g1 g0 r4 r3 r2 r1 r0   b4 b3 b2 b1 b0 g5 g4 g3
> +                *
> +                * We interpret RGB565 as:
> +                *
> +                *      Byte 0                    Byte 1
> +                *      g2 g1 g0 b4 b3 b2 b1 b0   r4 r3 r2 r1 r0 g5 g4 g3
> +                */
> +               .description    = "RGB565, le",
> +               .pixelformat    = V4L2_PIX_FMT_RGB565,
> +       },
> +       {
> +               /* Note:  V4L2 defines RGB565X as:
> +                *
> +                *      Byte 0                    Byte 1
> +                *      b4 b3 b2 b1 b0 g5 g4 g3   g2 g1 g0 r4 r3 r2 r1 r0
> +                *
> +                * We interpret RGB565X as:
> +                *
> +                *      Byte 0                    Byte 1
> +                *      r4 r3 r2 r1 r0 g5 g4 g3   g2 g1 g0 b4 b3 b2 b1 b0
> +                */
> +               .description    = "RGB565, be",
> +               .pixelformat    = V4L2_PIX_FMT_RGB565X,
> +       },
> +       {
> +               .description    = "YUYV (YUV 4:2:2), packed",
> +               .pixelformat    = V4L2_PIX_FMT_YUYV,
> +       },
> +       {
> +               .description    = "UYVY, packed",
> +               .pixelformat    = V4L2_PIX_FMT_UYVY,
> +       },
> +       {
> +               /* Note:  V4L2 defines RGB555 as:
> +                *
> +                *      Byte 0                    Byte 1
> +                *      g2 g1 g0 r4 r3 r2 r1 r0   x  b4 b3 b2 b1 b0 g4 g3
> +                *
> +                * We interpret RGB555 as:
> +                *
> +                *      Byte 0                    Byte 1
> +                *      g2 g1 g0 b4 b3 b2 b1 b0   x  r4 r3 r2 r1 r0 g4 g3
> +                */
> +               .description    = "RGB555, le",
> +               .pixelformat    = V4L2_PIX_FMT_RGB555,
> +       },
> +       {
> +               /* Note:  V4L2 defines RGB555X as:
> +                *
> +                *      Byte 0                    Byte 1
> +                *      x  b4 b3 b2 b1 b0 g4 g3   g2 g1 g0 r4 r3 r2 r1 r0
> +                *
> +                * We interpret RGB555X as:
> +                *
> +                *      Byte 0                    Byte 1
> +                *      x  r4 r3 r2 r1 r0 g4 g3   g2 g1 g0 b4 b3 b2 b1 b0
> +                */
> +               .description    = "RGB555, be",
> +               .pixelformat    = V4L2_PIX_FMT_RGB555X,
> +       },
> +#endif
> +};
> +
> +#define NUM_CAPTURE_FORMATS (sizeof(ov3640_formats) / sizeof(ov3640_formats[0]))
> +
> +/* register initialization tables for ov3640 */
> +#define OV3640_REG_TERM 0xFFFF /* terminating list entry for reg */
> +#define OV3640_VAL_TERM 0xFF   /* terminating list entry for val */
> +
> +const static struct ov3640_reg ov3640_out_xga[] = {
> +       {OV3640_ISP_XOUT_H, 0x04},  /* ISP_XOUT */
> +       {OV3640_ISP_XOUT_L, 0x00},  /* ISP_XOUT */
> +       {OV3640_ISP_YOUT_H, 0x03},  /* ISP_YOUT */
> +       {OV3640_ISP_YOUT_L, 0x00},  /* ISP_YOUT */
> +       {OV3640_REG_TERM, OV3640_VAL_TERM}
> +};
> +
> +const static struct ov3640_reg ov3640_out_qxga[] = {
> +       {OV3640_ISP_XOUT_H, 0x08},  /* ISP_XOUT */
> +       {OV3640_ISP_XOUT_L, 0x00},  /* ISP_XOUT */
> +       {OV3640_ISP_YOUT_H, 0x06},  /* ISP_YOUT */
> +       {OV3640_ISP_YOUT_L, 0x00},  /* ISP_YOUT */
> +       {OV3640_REG_TERM, OV3640_VAL_TERM}
> +};
> +
> +/* Brightness Settings - 7 levels */
> +const static struct ov3640_reg brightness[7][5] = {
> +       {
> +               {OV3640_SDE_CTRL, 0x04},
> +               {OV3640_SGNSET, 0x09},
> +               {OV3640_YBRIGHT, 0x30},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       {
> +               {OV3640_SDE_CTRL, 0x04},
> +               {OV3640_SGNSET, 0x09},
> +               {OV3640_YBRIGHT, 0x20},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       {
> +               {OV3640_SDE_CTRL, 0x04},
> +               {OV3640_SGNSET, 0x09},
> +               {OV3640_YBRIGHT, 0x10},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       {
> +               {OV3640_SDE_CTRL, 0x04},
> +               {OV3640_SGNSET, 0x01},
> +               {OV3640_YBRIGHT, 0x00},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       {
> +               {OV3640_SDE_CTRL, 0x04},
> +               {OV3640_SGNSET, 0x01},
> +               {OV3640_YBRIGHT, 0x10},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       {
> +               {OV3640_SDE_CTRL, 0x04},
> +               {OV3640_SGNSET, 0x01},
> +               {OV3640_YBRIGHT, 0x20},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       {
> +               {OV3640_SDE_CTRL, 0x04},
> +               {OV3640_SGNSET, 0x01},
> +               {OV3640_YBRIGHT, 0x30},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +};
> +
> +/* Contrast Settings - 7 levels */
> +const static struct ov3640_reg contrast[7][5] = {
> +       {
> +               {OV3640_SDE_CTRL, 0x04},
> +               {OV3640_YOFFSET, 0x14},
> +               {OV3640_YGAIN, 0x14},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       {
> +               {OV3640_SDE_CTRL, 0x04},
> +               {OV3640_YOFFSET, 0x18},
> +               {OV3640_YGAIN, 0x18},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       {
> +               {OV3640_SDE_CTRL, 0x04},
> +               {OV3640_YOFFSET, 0x1c},
> +               {OV3640_YGAIN, 0x1c},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       {
> +               {OV3640_SDE_CTRL, 0x04},
> +               {OV3640_YOFFSET, 0x20},
> +               {OV3640_YGAIN, 0x20},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       {
> +               {OV3640_SDE_CTRL, 0x04},
> +               {OV3640_YOFFSET, 0x24},
> +               {OV3640_YGAIN, 0x24},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       {
> +               {OV3640_SDE_CTRL, 0x04},
> +               {OV3640_YOFFSET, 0x28},
> +               {OV3640_YGAIN, 0x28},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       {
> +               {OV3640_SDE_CTRL, 0x04},
> +               {OV3640_YOFFSET, 0x2c},
> +               {OV3640_YGAIN, 0x2c},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +};
> +
> +/* Color Settings - 3 colors */
> +const static struct ov3640_reg colors[3][5] = {
> +       {
> +               {OV3640_SDE_CTRL, 0x00},
> +               {OV3640_UREG, 0x80},
> +               {OV3640_VREG, 0x80},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       {
> +               {OV3640_SDE_CTRL, 0x18},
> +               {OV3640_UREG, 0x40},
> +               {OV3640_VREG, 0xa6},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       {
> +               {OV3640_SDE_CTRL, 0x18},
> +               {OV3640_UREG, 0x80},
> +               {OV3640_VREG, 0x80},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +};
> +
> +/* Average Based Algorithm - Based on target Luminance */
> +const static struct ov3640_reg exposure_avg[11][5] = {
> +       /* -1.7EV */
> +       {
> +               {OV3640_HISTO7, 0x00},
> +               {OV3640_WPT_HISH, 0x10},
> +               {OV3640_BPT_HISL, 0x08},
> +               {OV3640_VPT, 0x21},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       /* -1.3EV */
> +       {
> +               {OV3640_HISTO7, 0x00},
> +               {OV3640_WPT_HISH, 0x18},
> +               {OV3640_BPT_HISL, 0x10},
> +               {OV3640_VPT, 0x31},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       /* -1.0EV */
> +       {
> +               {OV3640_HISTO7, 0x00},
> +               {OV3640_WPT_HISH, 0x20},
> +               {OV3640_BPT_HISL, 0x18},
> +               {OV3640_VPT, 0x41},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       /* -0.7EV */
> +       {
> +               {OV3640_HISTO7, 0x00},
> +               {OV3640_WPT_HISH, 0x28},
> +               {OV3640_BPT_HISL, 0x20},
> +               {OV3640_VPT, 0x51},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       /* -0.3EV */
> +       {
> +               {OV3640_HISTO7, 0x00},
> +               {OV3640_WPT_HISH, 0x30},
> +               {OV3640_BPT_HISL, 0x28},
> +               {OV3640_VPT, 0x61},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       /* default */
> +       {
> +               {OV3640_HISTO7, 0x00},
> +               {OV3640_WPT_HISH, 0x38},
> +               {OV3640_BPT_HISL, 0x30},
> +               {OV3640_VPT, 0x61},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       /* 0.3EV */
> +       {
> +               {OV3640_HISTO7, 0x00},
> +               {OV3640_WPT_HISH, 0x40},
> +               {OV3640_BPT_HISL, 0x38},
> +               {OV3640_VPT, 0x71},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       /* 0.7EV */
> +       {
> +               {OV3640_HISTO7, 0x00},
> +               {OV3640_WPT_HISH, 0x48},
> +               {OV3640_BPT_HISL, 0x40},
> +               {OV3640_VPT, 0x81},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       /* 1.0EV */
> +       {
> +               {OV3640_HISTO7, 0x00},
> +               {OV3640_WPT_HISH, 0x50},
> +               {OV3640_BPT_HISL, 0x48},
> +               {OV3640_VPT, 0x91},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       /* 1.3EV */
> +       {
> +               {OV3640_HISTO7, 0x00},
> +               {OV3640_WPT_HISH, 0x58},
> +               {OV3640_BPT_HISL, 0x50},
> +               {OV3640_VPT, 0x91},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       /* 1.7EV */
> +       {
> +               {OV3640_HISTO7, 0x00},
> +               {OV3640_WPT_HISH, 0x60},
> +               {OV3640_BPT_HISL, 0x58},
> +               {OV3640_VPT, 0xa1},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +};
> +
> +/* Histogram Based Algorithm - Based on histogram and probability */
> +const static struct ov3640_reg exposure_hist[11][5] = {
> +       /* -1.7EV */
> +       {
> +               {OV3640_HISTO7, 0x80},
> +               {OV3640_WPT_HISH, 0x58},
> +               {OV3640_BPT_HISL, 0x38},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       /* -1.3EV */
> +       {
> +               {OV3640_HISTO7, 0x80},
> +               {OV3640_WPT_HISH, 0x60},
> +               {OV3640_BPT_HISL, 0x40},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       /* -1.0EV */
> +       {
> +               {OV3640_HISTO7, 0x80},
> +               {OV3640_WPT_HISH, 0x68},
> +               {OV3640_BPT_HISL, 0x48},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       /* -0.7EV */
> +       {
> +               {OV3640_HISTO7, 0x80},
> +               {OV3640_WPT_HISH, 0x70},
> +               {OV3640_BPT_HISL, 0x50},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       /* -0.3EV */
> +       {
> +               {OV3640_HISTO7, 0x80},
> +               {OV3640_WPT_HISH, 0x78},
> +               {OV3640_BPT_HISL, 0x58},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       /* default */
> +       {
> +               {OV3640_HISTO7, 0x80},
> +               {OV3640_WPT_HISH, 0x80},
> +               {OV3640_BPT_HISL, 0x60},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       /* 0.3EV */
> +       {
> +               {OV3640_HISTO7, 0x80},
> +               {OV3640_WPT_HISH, 0x88},
> +               {OV3640_BPT_HISL, 0x68},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       /* 0.7EV */
> +       {
> +               {OV3640_HISTO7, 0x80},
> +               {OV3640_WPT_HISH, 0x90},
> +               {OV3640_BPT_HISL, 0x70},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       /* 1.0EV */
> +       {
> +               {OV3640_HISTO7, 0x80},
> +               {OV3640_WPT_HISH, 0x98},
> +               {OV3640_BPT_HISL, 0x78},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       /* 1.3EV */
> +       {
> +               {OV3640_HISTO7, 0x80},
> +               {OV3640_WPT_HISH, 0xa0},
> +               {OV3640_BPT_HISL, 0x80},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +       /* 1.7EV */
> +       {
> +               {OV3640_HISTO7, 0x80},
> +               {OV3640_WPT_HISH, 0xa8},
> +               {OV3640_BPT_HISL, 0x88},
> +               {OV3640_REG_TERM, OV3640_VAL_TERM}
> +       },
> +};
> +
> +/* ov3640 register configuration for combinations of pixel format and
> + * image size
> + */
> +
> +const static struct ov3640_reg qxga_yuv[] = {
> +       {OV3640_SC_CTRL0, 0x02},
> +       {OV3640_DSP_CTRL_4, 0xFC},
> +       {OV3640_FMT_MUX_CTRL0, 0x00},
> +       {OV3640_FMT_CTRL00, 0x00},
> +       {OV3640_OUT_CTRL01, OV3640_OUT_CTRL01_MIPIBIT8},
> +       {OV3640_VTS_H, 0x06},
> +       {OV3640_VTS_L, 0x20},
> +       {OV3640_REG_TERM, OV3640_VAL_TERM}
> +};
> +
> +const static struct ov3640_reg qxga_565[] = {
> +       {OV3640_SC_CTRL0, 0x02},
> +       {OV3640_DSP_CTRL_4, 0xFC},
> +       {OV3640_FMT_MUX_CTRL0, 0x01},
> +       {OV3640_FMT_CTRL00, 0x11},
> +       {OV3640_OUT_CTRL01, OV3640_OUT_CTRL01_MIPIBIT8},
> +       {OV3640_VTS_H, 0x06},
> +       {OV3640_VTS_L, 0x20},
> +       {OV3640_REG_TERM, OV3640_VAL_TERM}
> +};
> +
> +const static struct ov3640_reg qxga_555[] = {
> +       {OV3640_SC_CTRL0, 0x02},
> +       {OV3640_DSP_CTRL_4, 0xFC},
> +       {OV3640_FMT_MUX_CTRL0, 0x01},
> +       {OV3640_FMT_CTRL00, 0x13},
> +       {OV3640_OUT_CTRL01, OV3640_OUT_CTRL01_MIPIBIT8},
> +       {OV3640_VTS_H, 0x06},
> +       {OV3640_VTS_L, 0x20},
> +       {OV3640_REG_TERM, OV3640_VAL_TERM}
> +};
> +
> +const static struct ov3640_reg qxga_raw10[] = {
> +       {OV3640_SC_CTRL0, 0x22},
> +       {OV3640_DSP_CTRL_4, 0x01},
> +       {OV3640_FMT_MUX_CTRL0, 0x04},
> +       {OV3640_FMT_CTRL00, 0x18},
> +       {OV3640_OUT_CTRL01, 0x00},
> +       {OV3640_VTS_H, 0x06},
> +       {OV3640_VTS_L, 0x20},
> +       {OV3640_REG_TERM, OV3640_VAL_TERM}
> +};
> +
> +const static struct ov3640_reg xga_yuv[] = {
> +       {OV3640_SC_CTRL0, 0x02},
> +       {OV3640_DSP_CTRL_4, 0xFC},
> +       {OV3640_FMT_MUX_CTRL0, 0x00},
> +       {OV3640_FMT_CTRL00, 0x00},
> +       {OV3640_OUT_CTRL01, OV3640_OUT_CTRL01_MIPIBIT8},
> +       {OV3640_VTS_H, 0x03},
> +       {OV3640_VTS_L, 0x10},
> +       {OV3640_REG_TERM, OV3640_VAL_TERM}
> +};
> +
> +const static struct ov3640_reg xga_565[] = {
> +       {OV3640_SC_CTRL0, 0x02},
> +       {OV3640_DSP_CTRL_4, 0xFC},
> +       {OV3640_FMT_MUX_CTRL0, 0x01},
> +       {OV3640_FMT_CTRL00, 0x11},
> +       {OV3640_OUT_CTRL01, OV3640_OUT_CTRL01_MIPIBIT8},
> +       {OV3640_VTS_H, 0x03},
> +       {OV3640_VTS_L, 0x10},
> +       {OV3640_REG_TERM, OV3640_VAL_TERM}
> +};
> +
> +const static struct ov3640_reg xga_555[] = {
> +       {OV3640_SC_CTRL0, 0x02},
> +       {OV3640_DSP_CTRL_4, 0xFC},
> +       {OV3640_FMT_MUX_CTRL0, 0x01},
> +       {OV3640_FMT_CTRL00, 0x13},
> +       {OV3640_OUT_CTRL01, OV3640_OUT_CTRL01_MIPIBIT8},
> +       {OV3640_VTS_H, 0x03},
> +       {OV3640_VTS_L, 0x10},
> +       {OV3640_REG_TERM, OV3640_VAL_TERM}
> +};
> +
> +const static struct ov3640_reg xga_raw10[] = {
> +       {OV3640_SC_CTRL0, 0x22},
> +       {OV3640_DSP_CTRL_4, 0x01},
> +       {OV3640_FMT_MUX_CTRL0, 0x04},
> +       {OV3640_FMT_CTRL00, 0x18},
> +       {OV3640_OUT_CTRL01, 0x00},
> +       {OV3640_VTS_H, 0x03},
> +       {OV3640_VTS_L, 0x10},
> +       {OV3640_REG_TERM, OV3640_VAL_TERM}
> +};
> +
> +const static struct ov3640_reg
> +       *ov3640_reg_init[OV_NUM_PIXEL_FORMATS][OV_NUM_IMAGE_SIZES] = {
> +       {xga_yuv, qxga_yuv},
> +       {xga_565, qxga_565},
> +       {xga_555, qxga_555},
> +       {xga_raw10, qxga_raw10}
> +};
> +
> +/*
> + * struct vcontrol - Video controls
> + * @v4l2_queryctrl: V4L2 VIDIOC_QUERYCTRL ioctl structure
> + * @current_value: current value of this control
> + */
> +static struct vcontrol {
> +       struct v4l2_queryctrl qc;
> +       int current_value;
> +} video_control[] = {
> +#if (OV3640_RAW_MODE == 0)
> +       {
> +               {
> +               .id = V4L2_CID_BRIGHTNESS,
> +               .type = V4L2_CTRL_TYPE_INTEGER,
> +               .name = "Brightness",
> +               .minimum = OV3640_MIN_BRIGHT,
> +               .maximum = OV3640_MAX_BRIGHT,
> +               .step = OV3640_BRIGHT_STEP,
> +               .default_value = OV3640_DEF_BRIGHT,
> +               },
> +       .current_value = OV3640_DEF_BRIGHT,
> +       },
> +       {
> +               {
> +               .id = V4L2_CID_CONTRAST,
> +               .type = V4L2_CTRL_TYPE_INTEGER,
> +               .name = "Contrast",
> +               .minimum = OV3640_MIN_CONTRAST,
> +               .maximum = OV3640_MAX_CONTRAST,
> +               .step = OV3640_CONTRAST_STEP,
> +               .default_value = OV3640_DEF_CONTRAST,
> +               },
> +       .current_value = OV3640_DEF_CONTRAST,
> +       },
> +       {
> +               {
> +               .id = V4L2_CID_PRIVATE_BASE,
> +               .type = V4L2_CTRL_TYPE_INTEGER,
> +               .name = "Color Effects",
> +               .minimum = OV3640_MIN_COLOR,
> +               .maximum = OV3640_MAX_COLOR,
> +               .step = OV3640_COLOR_STEP,
> +               .default_value = OV3640_DEF_COLOR,
> +               },
> +       .current_value = OV3640_DEF_COLOR,
> +       }
> +#endif
> +};
> +
> +/*
> + * find_vctrl - Finds the requested ID in the video control structure array
> + * @id: ID of control to search the video control array.
> + *
> + * Returns the index of the requested ID from the control structure array
> + */
> +static int find_vctrl(int id)
> +{
> +       int i = 0;
> +
> +       if (id < V4L2_CID_BASE)
> +               return -EDOM;
> +
> +       for (i = (ARRAY_SIZE(video_control) - 1); i >= 0; i--)
> +               if (video_control[i].qc.id == id)
> +                       break;
> +       if (i < 0)
> +               i = -EINVAL;
> +       return i;
> +}
> +
> +/*
> + * Read a value from a register in ov3640 sensor device.
> + * The value is returned in 'val'.
> + * Returns zero if successful, or non-zero otherwise.
> + */
> +static int ov3640_read_reg(struct i2c_client *client, u16 data_length, u16 reg,
> +                                                               u32 *val)
> +{
> +       int err = 0;
> +       struct i2c_msg msg[1];
> +       unsigned char data[4];
> +
> +       if (!client->adapter)
> +               return -ENODEV;
> +
> +       msg->addr = client->addr;
> +       msg->flags = I2C_M_WR;
> +       msg->len = 2;
> +       msg->buf = data;
> +
> +       /* High byte goes out first */
> +       data[0] = (u8) (reg >> 8);
> +       data[1] = (u8) (reg & 0xff);
> +
> +       err = i2c_transfer(client->adapter, msg, 1);

Please, let me understand.. You call i2c_transfer() and ask it to
transfer one message(third parameter), right ?
So, the returned value is negative errno or the number of messages
executed. Logic says that you should check somethin like this:
	if (err = 1) {
		good;
	} else {
		i2c_transfer failed;
		we should deal with it(printk, try again, etc)
	}

Or even:
	if (unlikely(err != 1)) {
		i2c_transfer failed;
	}
	Good code continue;

Right or wrong ?

> +       if (err >= 0) {
> +               mdelay(3);
> +               msg->flags = I2C_M_RD;
> +               msg->len = data_length;
> +               err = i2c_transfer(client->adapter, msg, 1);
> +       }
> +       if (err >= 0) {
> +               *val = 0;
> +               /* High byte comes first */
> +               if (data_length == 1)
> +                       *val = data[0];
> +               else if (data_length == 2)
> +                       *val = data[1] + (data[0] << 8);
> +               else
> +                       *val = data[3] + (data[2] << 8) +
> +                               (data[1] << 16) + (data[0] << 24);
> +               return 0;
> +       }
> +       dev_err(&client->dev, "read from offset 0x%x error %d", reg, err);

"\n" should be in dev_err.

> +       return err;
> +}
> +
> +/* Write a value to a register in ov3640 sensor device.
> + * @client: i2c driver client structure.
> + * @reg: Address of the register to read value from.
> + * @val: Value to be written to a specific register.
> + * Returns zero if successful, or non-zero otherwise.
> + */
> +static int ov3640_write_reg(struct i2c_client *client, u16 reg, u8 val)
> +{
> +       int err = 0;
> +       struct i2c_msg msg[1];
> +       unsigned char data[3];
> +       int retries = 0;
> +
> +       if (!client->adapter)
> +               return -ENODEV;
> +retry:
> +       msg->addr = client->addr;
> +       msg->flags = I2C_M_WR;
> +       msg->len = 3;
> +       msg->buf = data;
> +
> +       /* high byte goes out first */
> +       data[0] = (u8) (reg >> 8);
> +       data[1] = (u8) (reg & 0xff);
> +       data[2] = val;
> +
> +       err = i2c_transfer(client->adapter, msg, 1);
> +       udelay(50);
> +
> +       if (err >= 0)

Well, probably all checks of returned values after i2c_transfer should
be reformatted in right way.


> +               return 0;
> +
> +       if (retries <= 5) {
> +               dev_dbg(&client->dev, "Retrying I2C... %d", retries);

"\n"

> +               retries++;
> +               set_current_state(TASK_UNINTERRUPTIBLE);
> +               schedule_timeout(msecs_to_jiffies(20));
> +               goto retry;
> +       }
> +
> +       return err;
> +}
> +
> +/*
> + * Initialize a list of ov3640 registers.
> + * The list of registers is terminated by the pair of values
> + * {OV3640_REG_TERM, OV3640_VAL_TERM}.
> + * @client: i2c driver client structure.
> + * @reglist[]: List of address of the registers to write data.
> + * Returns zero if successful, or non-zero otherwise.
> + */
> +static int ov3640_write_regs(struct i2c_client *client,
> +                                       const struct ov3640_reg reglist[])
> +{
> +       int err = 0;
> +       const struct ov3640_reg *next = reglist;
> +
> +       while (!((next->reg == OV3640_REG_TERM)
> +               && (next->val == OV3640_VAL_TERM))) {
> +               err = ov3640_write_reg(client, next->reg, next->val);
> +               udelay(100);
> +               if (err)
> +                       return err;
> +               next++;
> +       }
> +       return 0;
> +}
> +
> +/* Find the best match for a requested image capture size.  The best match
> + * is chosen as the nearest match that has the same number or fewer pixels
> + * as the requested size, or the smallest image size if the requested size
> + * has fewer pixels than the smallest image.
> + */
> +static enum image_size_ov
> +ov3640_find_size(unsigned int width, unsigned int height)
> +{
> +       if ((width > ov3640_sizes[XGA].width) ||
> +               (height > ov3640_sizes[XGA].height))
> +               return QXGA;
> +       return XGA;
> +}
> +
> +/*
> + * Set CSI2 Virtual ID.
> + */
> +static int ov3640_set_virtual_id(struct i2c_client *client, u32 id)
> +{
> +       return ov3640_write_reg(client, OV3640_MIPI_CTRL0C, (0x3 & id) << 6 |
> +                                                                       0x02);
> +}
> +
> +
> +/*
> + * Calculates the MIPIClk.
> + * 1) Calculate fclk
> + *     fclk = (64 - OV3640_PLL_1[5:0]) * N * Bit8Div * MCLK / M
> + *    where N = 1/1.5/2/3 for OV3640_PLL_2[7:6]=0~3
> + *          M = 1/1.5/2/3 for OV3640_PLL_2[1:0]=0~3
> + *    Bit8Div = 1/1/4/5 for OV3640_PLL_2[5:4]
> + * 2) Calculate MIPIClk
> + *     MIPIClk = fclk / ScaleDiv / MIPIDiv
> + *             = fclk * (1/ScaleDiv) / MIPIDiv
> + *    where 1/ScaleDiv = 0x3010[3:0]*2
> + *          MIPIDiv = 0x3010[5] + 1
> + * NOTE:
> + *  - The lookup table 'lut1' has been multiplied by 2 so all its values
> + *    are integers. Since both N & M use the same table, and they are
> + *    used as a ratio then the factor of 2 is already take into account.
> + *    i.e.  2N/2M = N/M
> + */
> +static u32 ov3640_calc_mipiclk(struct v4l2_int_device *s)
> +{
> +       struct ov3640_sensor *sensor = s->priv;
> +       struct i2c_client *client = sensor->i2c_client;
> +       u32 rxpll, val, n, m, bit8div;
> +       u32 sdiv_inv, mipidiv;
> +       u32 fclk, mipiclk, mclk = 24000000;
> +       u8 lut1[4] = {2, 3, 4, 6};
> +       u8 lut2[4] = {1, 1, 4, 5};
> +
> +       /* Calculate fclk */
> +       ov3640_read_reg(client, 1, OV3640_PLL_1, &val);
> +       rxpll = val & 0x3F;
> +
> +       ov3640_read_reg(client, 1, OV3640_PLL_2, &val);
> +       n = lut1[(val >> 6) & 0x3];
> +       m = lut1[val & 0x3];
> +       bit8div = lut2[(val >> 4) & 0x3];
> +       fclk = (64 - rxpll) * n * bit8div * mclk / m;
> +
> +       ov3640_read_reg(client, 1, OV3640_PLL_3, &val);
> +       mipidiv = ((val >> 5) & 1) + 1;
> +       sdiv_inv = (val & 0xF) * 2;
> +
> +       if ((val & 0xF) >= 1)
> +               mipiclk = fclk / sdiv_inv / mipidiv;
> +       else
> +               mipiclk = fclk / mipidiv;
> +       dev_dbg(&client->dev, "mipiclk=%u  fclk=%u  val&0xF=%u  sdiv_inv=%u  "
> +                                                       "mipidiv=%u\n",
> +                                                       mipiclk, fclk, val&0xF,
> +                                                       sdiv_inv, mipidiv);
> +       return mipiclk;
> +}
> +
> +/**
> + * ov3640_set_framerate
> + **/
> +static int ov3640_set_framerate(struct i2c_client *client,
> +                                               struct v4l2_fract *fper,
> +                                               enum image_size_ov isize)
> +{
> +       u32 tempfps1, tempfps2;
> +       u8 clkval;
> +/*
> +       u32 origvts, newvts, templineperiod;
> +       u32 origvts_h, origvts_l, newvts_h, newvts_l;
> +*/
> +       int err = 0;
> +
> +       /* FIXME: QXGA framerate setting forced to 15 FPS */
> +       if (isize == QXGA) {
> +               err = ov3640_write_reg(client, OV3640_PLL_1, 0x32);
> +               err = ov3640_write_reg(client, OV3640_PLL_2, 0x21);
> +               err = ov3640_write_reg(client, OV3640_PLL_3, 0x21);
> +               err = ov3640_write_reg(client, OV3640_CLK, 0x01);
> +               err = ov3640_write_reg(client, 0x304c, 0x81);

I see no checking of returned values. For example, if first function
failed, rest functions will keep going.


> +               return err;
> +       }
> +
> +       tempfps1 = fper->denominator * 10000;
> +       tempfps1 /= fper->numerator;
> +       tempfps2 = fper->denominator / fper->numerator;
> +       if ((tempfps1 % 10000) != 0)
> +               tempfps2++;
> +       clkval = (u8)((30 / tempfps2) - 1);
> +
> +       err = ov3640_write_reg(client, OV3640_CLK, clkval);
> +       /* RxPLL = 50d = 32h */
> +       err = ov3640_write_reg(client, OV3640_PLL_1, 0x32);
> +       /* RxPLL = 50d = 32h */
> +       err = ov3640_write_reg(client, OV3640_PLL_2,
> +                                       OV3640_PLL_2_BIT8DIV_4 |
> +                                       OV3640_PLL_2_INDIV_1_5);
> +       /*
> +        * NOTE: Sergio's Fix for MIPI CLK timings, not suggested by OV
> +        */
> +       err = ov3640_write_reg(client, OV3640_PLL_3, 0x21 +
> +                                                       (clkval & 0xF));
> +       /* Setting DVP divisor value */
> +       err = ov3640_write_reg(client, 0x304c, 0x82);
> +/* FIXME: Time adjustment to add granularity to the available fps */
> +/*
> +       ov3640_read_reg(client, 1, OV3640_VTS_H, &origvts_h);
> +       ov3640_read_reg(client, 1, OV3640_VTS_L, &origvts_l);
> +       origvts = (u32)((origvts_h << 8) + origvts_l);
> +       templineperiod = 1000000 / (tempfps2 * origvts);
> +       newvts = 1000000 / (tempfps2 * templineperiod);
> +       newvts_h = (u8)((newvts & 0xFF00) >> 8);
> +       newvts_l = (u8)(newvts & 0xFF);
> +       err = ov3640_write_reg(client, OV3640_VTS_H, newvts_h);
> +       err = ov3640_write_reg(client, OV3640_VTS_L, newvts_l);
> +*/
> +       return err;
> +}
> +
> +/*
> + * Configure the ov3640 for a specified image size, pixel format, and frame
> + * period.  xclk is the frequency (in Hz) of the xclk input to the OV3640.
> + * fper is the frame period (in seconds) expressed as a fraction.
> + * Returns zero if successful, or non-zero otherwise.
> + * The actual frame period is returned in fper.
> + */
> +static int ov3640_configure(struct v4l2_int_device *s)
> +{
> +       struct ov3640_sensor *sensor = s->priv;
> +       struct v4l2_pix_format *pix = &sensor->pix;
> +       struct i2c_client *client = sensor->i2c_client;
> +       enum image_size_ov isize = XGA;
> +       unsigned char hsize_l = 0, hsize_h = 0;
> +       unsigned char vsize_l = 0, vsize_h = 0;
> +       int vsize = 0, hsize = 0, height_l = 0, height_h = 0, width_l = 0;
> +       int width_h = 0, ratio = 0, err = 0;
> +       u32 mipiclk;
> +       enum pixel_format_ov pfmt = YUV;
> +       u32 min_hs_zero_nui, min_hs_zero, min_hs_zero_total;
> +       u32 min_hs_prepare_nui, min_hs_prepare, min_hs_prepare_total;
> +       u32 max_hs_prepare_nui, max_hs_prepare, max_hs_prepare_total;
> +       u32 ubound_hs_settle, lbound_hs_settle;
> +       u32 val;
> +
> +       switch (pix->pixelformat) {
> +
> +       case V4L2_PIX_FMT_RGB565:
> +       case V4L2_PIX_FMT_RGB565X:
> +               pfmt = RGB565;
> +               break;
> +
> +       case V4L2_PIX_FMT_RGB555:
> +       case V4L2_PIX_FMT_RGB555X:
> +               pfmt = RGB555;
> +               break;
> +
> +       case V4L2_PIX_FMT_SGRBG10:
> +               pfmt = RAW10;
> +               break;
> +
> +       case V4L2_PIX_FMT_YUYV:
> +       case V4L2_PIX_FMT_UYVY:
> +       default:
> +               pfmt = YUV;
> +       }
> +
> +       /* Set receivers virtual channel before sensor setup starts.
> +        * Only set the sensors virtual channel after all other setup
> +        * for the sensor is complete.
> +        */
> +       isp_csi2_ctx_config_virtual_id(0, OV3640_CSI2_VIRTUAL_ID);
> +       isp_csi2_ctx_update(0, false);
> +
> +       if (ov3640_find_size(pix->width, pix->height) == XGA)
> +               isize = XGA;
> +       else
> +               isize = QXGA;
> +
> +       /* Reset */
> +       ov3640_write_reg(client, OV3640_SYS, 0x80);
> +       mdelay(5);
> +
> +       /* Common registers */
> +       err = ov3640_write_regs(client, ov3640_common[isize]);
> +
> +       /* Configure image size and pixel format */
> +       err = ov3640_write_regs(client, ov3640_reg_init[pfmt][isize]);
> +
> +       /* Setting of frame rate (OV suggested way) */
> +       err = ov3640_set_framerate(client, &sensor->timeperframe, isize);
> +#ifdef CONFIG_VIDEO_OV3640_CSI2
> +       /* Set CSI2 common register settings */
> +       err = ov3640_write_regs(client, ov3640_common_csi2);
> +#endif

Again, no checking of err.

> +
> +       sensor->isize = isize;
> +
> +       /* Scale image if needed*/
> +       if (((pix->width == ov3640_sizes[QXGA].width) &&
> +               (pix->height == ov3640_sizes[QXGA].height) && (isize == QXGA))
> +               || ((pix->width == ov3640_sizes[XGA].width) &&
> +               (pix->height == ov3640_sizes[XGA].height) &&
> +               (isize == XGA)) || (pfmt == RAW10)) {
> +
> +               /* if the image size correspond to one of the base image sizes
> +                       then we don't need to scale the image */
> +               sensor->hsize = pix->width;
> +               sensor->vsize = pix->height;
> +
> +               if (isize == XGA)
> +                       ov3640_write_regs(client, ov3640_out_xga);
> +               else
> +                       ov3640_write_regs(client, ov3640_out_qxga);
> +
> +       } else {
> +       /* Default Ver and Hor sizes for QXGA and XGA*/
> +               if (isize == QXGA) {
> +                       vsize = 0x600;/* 0x60c; */
> +                       hsize = 0x800;/* 0x818; */
> +               } else {
> +                       vsize = 0x304;
> +                       hsize = 0x40c;
> +               }
> +               /* Scaling */
> +               /* Adjust V and H sizes for image sizes not derived form VGA*/
> +               ratio = (pix->width * 1000) / pix->height;
> +
> +               if  (((vsize * ratio + 500) / 1000) > hsize)
> +                       vsize = (hsize * 1000) / ratio ;
> +
> +               else
> +                       hsize = (vsize * ratio + 500) / 1000;
> +
> +               /* We need even numbers */
> +               if (vsize & 1)
> +                       vsize--;
> +               if (hsize & 1)
> +                       hsize--;
> +
> +               /* Adjusting numbers to set registers correctly */
> +               hsize_l = (0xFF & hsize);
> +               hsize_h = (0xF00 & hsize) >> 8;
> +               vsize_l = (0xFF & vsize);
> +               vsize_h = (0x700 & vsize) >> 4;
> +
> +               /* According to Software app notes we have to add 0x08 and 0x04
> +                * in order to scale correctly
> +                */
> +               width_l = (0xFF & pix->width) + 0x08;
> +               width_h = (0xF00 & pix->width) >> 8;
> +               height_l = (0xFF & pix->height) + 0x04;
> +               height_h = (0x700 & pix->height) >> 4;
> +
> +               err = ov3640_write_reg(client, OV3640_SIZE_IN_MISC,
> +                                                       (vsize_h | hsize_h));
> +               err = ov3640_write_reg(client, OV3640_HSIZE_IN_L, hsize_l);
> +               err = ov3640_write_reg(client, OV3640_VSIZE_IN_L, vsize_l);
> +               err = ov3640_write_reg(client, OV3640_SIZE_OUT_MISC,
> +                                                       (height_h | width_h));
> +               err = ov3640_write_reg(client, OV3640_HSIZE_OUT_L, width_l);
> +               err = ov3640_write_reg(client, OV3640_VSIZE_OUT_L, height_l);
> +               err = ov3640_write_reg(client, OV3640_ISP_PAD_CTR2, 0x42);
> +               err = ov3640_write_reg(client, OV3640_ISP_XOUT_H, width_h);
> +               err = ov3640_write_reg(client, OV3640_ISP_XOUT_L,
> +                                                       (width_l  - 0x08));
> +               err = ov3640_write_reg(client, OV3640_ISP_YOUT_H,
> +                                                       (height_h >> 4));
> +               err = ov3640_write_reg(client, OV3640_ISP_YOUT_L,
> +                                                       (height_l - 0x04));

The same thing here.

> +
> +               sensor->hsize = hsize;
> +               sensor->vsize = vsize;
> +
> +               dev_dbg(&client->dev, "HSIZE_IN =%i  VSIZE_IN =%i\n", hsize,
> +                                                                       vsize);
> +               dev_dbg(&client->dev, "HSIZE_OUT=%u  VSIZE_OUT=%u\n",
> +                                                       (pix->width + 8),
> +                                                       (pix->height + 4));
> +               dev_dbg(&client->dev, "ISP_XOUT =%u  ISP_YOUT =%u\n",
> +                                                               pix->width,
> +                                                               pix->height);
> +       }
> +
> +       /* Setup the ISP VP based on image format */
> +       if (pix->pixelformat == V4L2_PIX_FMT_SGRBG10) {
> +               isp_csi2_ctrl_config_vp_out_ctrl(2);
> +               isp_csi2_ctrl_update(false);
> +       } else {
> +               isp_csi2_ctrl_config_vp_out_ctrl(1);
> +               isp_csi2_ctrl_update(false);
> +       }
> +
> +       /* Store image size */
> +       sensor->width = pix->width;
> +       sensor->height = pix->height;
> +
> +       sensor->crop_rect.left = 0;
> +       sensor->crop_rect.width = pix->width;
> +       sensor->crop_rect.top = 0;
> +       sensor->crop_rect.height = pix->height;
> +
> +#ifdef CONFIG_VIDEO_OV3640_CSI2
> +       mipiclk = ov3640_calc_mipiclk(s);
> +
> +       /* Calculate Valid bounds for High speed settle timing in UIs */
> +       ov3640_read_reg(client, 1, OV3640_MIPI_CTRL22, &val);
> +       min_hs_zero_nui = ((val & OV3640_MIPI_CTRL22_MIN_HS_ZERO_NUI_MASK) >>
> +                               OV3640_MIPI_CTRL22_MIN_HS_ZERO_NUI_SHIFT);
> +       min_hs_zero = ((val & OV3640_MIPI_CTRL22_MIN_HS_ZERO_H_MASK) << 8);
> +       ov3640_read_reg(client, 1, OV3640_MIPI_CTRL23, &val);
> +       min_hs_zero |= (val & OV3640_MIPI_CTRL23_MIN_HS_ZERO_L_MASK);
> +       min_hs_zero_total = ((min_hs_zero_nui * 1000000 * 1000) / mipiclk) +
> +                                                               min_hs_zero;
> +
> +       ov3640_read_reg(client, 1, OV3640_MIPI_CTRL32, &val);
> +       min_hs_prepare_nui = ((val &
> +                               OV3640_MIPI_CTRL32_MIN_HS_PREPARE_NUI_MASK) >>
> +                               OV3640_MIPI_CTRL32_MIN_HS_PREPARE_NUI_SHIFT);
> +       min_hs_prepare = ((val &
> +                               OV3640_MIPI_CTRL32_MIN_HS_PREPARE_H_MASK) << 8);
> +       ov3640_read_reg(client, 1, OV3640_MIPI_CTRL33, &val);
> +       min_hs_prepare |= (val & OV3640_MIPI_CTRL33_MIN_HS_PREPARE_L_MASK);
> +       min_hs_prepare_total = ((min_hs_prepare_nui * 1000000 * 1000) /
> +                                               mipiclk) + min_hs_prepare;
> +
> +       ov3640_read_reg(client, 1, OV3640_MIPI_CTRL34, &val);
> +       max_hs_prepare_nui = ((val &
> +                               OV3640_MIPI_CTRL34_MAX_HS_PREPARE_NUI_MASK) >>
> +                               OV3640_MIPI_CTRL34_MAX_HS_PREPARE_NUI_SHIFT);
> +       max_hs_prepare = ((val &
> +                               OV3640_MIPI_CTRL34_MAX_HS_PREPARE_H_MASK) << 8);
> +       ov3640_read_reg(client, 1, OV3640_MIPI_CTRL35, &val);
> +       max_hs_prepare |= (val & OV3640_MIPI_CTRL35_MAX_HS_PREPARE_L_MASK);
> +       max_hs_prepare_total = ((max_hs_prepare_nui * 1000000 * 1000) /
> +                                               mipiclk) + max_hs_prepare;
> +
> +       ubound_hs_settle = ((min_hs_zero_total + min_hs_prepare_total) *
> +                                       ((mipiclk >> 1) / 1000000)) / 1000;
> +       lbound_hs_settle = (max_hs_prepare_total * ((mipiclk >> 1) /
> +                                                       1000000)) / 1000;
> +
> +       /* Send settings to ISP-CSI2 Receiver PHY */
> +       isp_csi2_calc_phy_cfg0(mipiclk, lbound_hs_settle, ubound_hs_settle);
> +
> +       /* Set sensors virtual channel*/
> +       ov3640_set_virtual_id(client, OV3640_CSI2_VIRTUAL_ID);
> +#endif
> +       return err;
> +}
> +
> +
> +/* Detect if an ov3640 is present, returns a negative error number if no
> + * device is detected, or pidl as version number if a device is detected.
> + */
> +static int ov3640_detect(struct i2c_client *client)
> +{
> +       u32 pidh, pidl;
> +
> +       if (!client)
> +               return -ENODEV;
> +
> +       if (ov3640_read_reg(client, 1, OV3640_PIDH, &pidh))
> +               return -ENODEV;
> +
> +       if (ov3640_read_reg(client, 1, OV3640_PIDL, &pidl))
> +               return -ENODEV;
> +
> +       if ((pidh == OV3640_PIDH_MAGIC) && ((pidl == OV3640_PIDL_MAGIC1) ||
> +                                               (pidl == OV3640_PIDL_MAGIC2))) {
> +               dev_dbg(&client->dev, "Detect success (%02X,%02X)\n", pidh,
> +                                                                       pidl);
> +               return pidl;
> +       }
> +
> +       return -ENODEV;
> +}
> +
> +/* To get the cropping capabilities of ov3640 sensor
> + * Returns zero if successful, or non-zero otherwise.
> + */
> +static int ioctl_cropcap(struct v4l2_int_device *s,
> +                                               struct v4l2_cropcap *cropcap)
> +{
> +       struct ov3640_sensor *sensor = s->priv;
> +
> +       cropcap->bounds.top = 0;
> +       cropcap->bounds.left = 0;
> +       cropcap->bounds.width = sensor->width;
> +       cropcap->bounds.height = sensor->height;
> +       cropcap->defrect = cropcap->bounds;
> +       cropcap->pixelaspect.numerator = 1;
> +       cropcap->pixelaspect.denominator = 1;
> +       return 0;
> +}
> +
> +/* To get the current crop window for of ov3640 sensor
> + * Returns zero if successful, or non-zero otherwise.
> + */
> +static int ioctl_g_crop(struct v4l2_int_device *s, struct  v4l2_crop *crop)
> +{
> +       struct ov3640_sensor *sensor = s->priv;
> +
> +       crop->c = sensor->crop_rect;
> +       return 0;
> +}
> +
> +/* To set the crop window for of ov3640 sensor
> + * Returns zero if successful, or non-zero otherwise.
> + */
> +static int ioctl_s_crop(struct v4l2_int_device *s, struct  v4l2_crop *crop)
> +{
> +       struct ov3640_sensor *sensor = s->priv;
> +       /* FIXME: Temporary workaround for avoiding Zoom setting */
> +       /* struct i2c_client *client = sensor->i2c_client; */
> +       struct v4l2_rect *cur_rect;
> +       unsigned long *cur_width, *cur_height;
> +       int hstart, vstart, hsize, vsize, hsize_l, vsize_l, hsize_h, vsize_h;
> +       int hratio, vratio, zoomfactor, err = 0;
> +
> +       cur_rect = &sensor->crop_rect;
> +       cur_width = &sensor->width;
> +       cur_height = &sensor->height;
> +
> +       if ((crop->c.left == cur_rect->left) &&
> +           (crop->c.width == cur_rect->width) &&
> +           (crop->c.top == cur_rect->top) &&
> +           (crop->c.height == cur_rect->height))
> +               return 0;
> +
> +       /* out of range? then return the current crop rectangle */
> +       if ((crop->c.left + crop->c.width) > sensor->width ||
> +           (crop->c.top + crop->c.height) > sensor->height) {
> +               crop->c = *cur_rect;
> +               return 0;
> +       }
> +
> +       if (sensor->isize == QXGA)
> +               zoomfactor = 1;
> +       else
> +               zoomfactor = 2;
> +
> +       hratio = (sensor->hsize * 1000) / sensor->width;
> +       vratio = (sensor->vsize * 1000) / sensor->height;
> +       hstart = (((crop->c.left * hratio + 500) / 1000) * zoomfactor) + 0x11d;
> +       vstart = (((crop->c.top * vratio + 500) / 1000) + 0x0a);
> +       hsize  = (crop->c.width * hratio + 500) / 1000;
> +       vsize  = (crop->c.height * vratio + 500) / 1000;
> +
> +       if (vsize & 1)
> +               vsize--;
> +       if (hsize & 1)
> +               hsize--;
> +
> +       /* Adjusting numbers to set register correctly */
> +       hsize_l = (0xFF & hsize);
> +       hsize_h = (0xF00 & hsize) >> 8;
> +       vsize_l = (0xFF & vsize);
> +       vsize_h = (0x700 & vsize) >> 4;
> +
> +       if ((sensor->height > vsize) || (sensor->width > hsize))
> +               return -EINVAL;
> +
> +       hsize = hsize * zoomfactor;
> +/*
> +       err = ov3640_write_reg(client, OV3640_DSP_CTRL_2, 0xEF);
> +       err = ov3640_write_reg(client, OV3640_SIZE_IN_MISC, (vsize_h |
> +                                                               hsize_h));
> +       err = ov3640_write_reg(client, OV3640_HSIZE_IN_L, hsize_l);
> +       err = ov3640_write_reg(client, OV3640_VSIZE_IN_L, vsize_l);
> +       err = ov3640_write_reg(client, OV3640_HS_H, (hstart >> 8) & 0xFF);
> +       err = ov3640_write_reg(client, OV3640_HS_L, hstart & 0xFF);
> +       err = ov3640_write_reg(client, OV3640_VS_H, (vstart >> 8) & 0xFF);
> +       err = ov3640_write_reg(client, OV3640_VS_L, vstart & 0xFF);
> +       err = ov3640_write_reg(client, OV3640_HW_H, ((hsize) >> 8) & 0xFF);
> +       err = ov3640_write_reg(client, OV3640_HW_L, hsize & 0xFF);
> +       err = ov3640_write_reg(client, OV3640_VH_H, ((vsize) >> 8) & 0xFF);
> +       err = ov3640_write_reg(client, OV3640_VH_L, vsize & 0xFF);
> +*/
> +       if (err)
> +               return err;
> +
> +       /* save back */
> +       *cur_rect = crop->c;
> +
> +       /* Setting crop too fast can cause frame out-of-sync. */
> +
> +       set_current_state(TASK_UNINTERRUPTIBLE);
> +       schedule_timeout(msecs_to_jiffies(20));
> +       return 0;
> +}
> +
> +
> +/*
> + * ioctl_queryctrl - V4L2 sensor interface handler for VIDIOC_QUERYCTRL ioctl
> + * @s: pointer to standard V4L2 device structure
> + * @qc: standard V4L2 VIDIOC_QUERYCTRL ioctl structure
> + *
> + * If the requested control is supported, returns the control information
> + * from the video_control[] array.  Otherwise, returns -EINVAL if the
> + * control is not supported.
> + */
> +static int ioctl_queryctrl(struct v4l2_int_device *s,
> +                                               struct v4l2_queryctrl *qc)
> +{
> +       int i;
> +
> +       i = find_vctrl(qc->id);
> +       if (i == -EINVAL)
> +               qc->flags = V4L2_CTRL_FLAG_DISABLED;
> +
> +       if (i < 0)
> +               return -EINVAL;
> +
> +       *qc = video_control[i].qc;
> +       return 0;
> +}
> +
> +/*
> + * ioctl_g_ctrl - V4L2 sensor interface handler for VIDIOC_G_CTRL ioctl
> + * @s: pointer to standard V4L2 device structure
> + * @vc: standard V4L2 VIDIOC_G_CTRL ioctl structure
> + *
> + * If the requested control is supported, returns the control's current
> + * value from the video_control[] array.  Otherwise, returns -EINVAL
> + * if the control is not supported.
> + */
> +
> +static int ioctl_g_ctrl(struct v4l2_int_device *s,
> +                            struct v4l2_control *vc)
> +{
> +       struct vcontrol *lvc;
> +       int i;
> +
> +       i = find_vctrl(vc->id);
> +       if (i < 0)
> +               return -EINVAL;
> +       lvc = &video_control[i];
> +
> +       switch (vc->id) {
> +       case V4L2_CID_BRIGHTNESS:
> +               vc->value = lvc->current_value;
> +               break;
> +       case V4L2_CID_CONTRAST:
> +               vc->value = lvc->current_value;
> +               break;
> +       case V4L2_CID_PRIVATE_BASE:
> +               vc->value = lvc->current_value;
> +               break;
> +       }
> +       return 0;
> +}
> +
> +/*
> + * ioctl_s_ctrl - V4L2 sensor interface handler for VIDIOC_S_CTRL ioctl
> + * @s: pointer to standard V4L2 device structure
> + * @vc: standard V4L2 VIDIOC_S_CTRL ioctl structure
> + *
> + * If the requested control is supported, sets the control's current
> + * value in HW (and updates the video_control[] array).  Otherwise,
> + * returns -EINVAL if the control is not supported.
> + */
> +static int ioctl_s_ctrl(struct v4l2_int_device *s,
> +                            struct v4l2_control *vc)
> +{
> +       int retval = -EINVAL;
> +       int i;
> +       struct ov3640_sensor *sensor = s->priv;
> +       struct i2c_client *client = sensor->i2c_client;
> +       struct vcontrol *lvc;
> +
> +       i = find_vctrl(vc->id);
> +       if (i < 0)
> +               return -EINVAL;
> +
> +       lvc = &video_control[i];
> +
> +       switch (vc->id) {
> +       case V4L2_CID_BRIGHTNESS:
> +               if (vc->value >= 0 && vc->value <= 6) {
> +                       retval = ov3640_write_regs(client,
> +                                                       brightness[vc->value]);
> +               } else {
> +                       dev_err(&client->dev, "BRIGHTNESS LEVEL NOT SUPPORTED");
> +                       return -EINVAL;
> +               }
> +               break;
> +       case V4L2_CID_CONTRAST:
> +               if (vc->value >= 0 && vc->value <= 6)
> +                       retval = ov3640_write_regs(client, contrast[vc->value]);
> +               else {
> +                       dev_err(&client->dev, "CONTRAST LEVEL NOT SUPPORTED");
> +                       return -EINVAL;
> +               }
> +               break;
> +       case V4L2_CID_PRIVATE_BASE:
> +               if (vc->value >= 0 && vc->value <= 2)
> +                       retval = ov3640_write_regs(client, colors[vc->value]);
> +               else {
> +                       dev_err(&client->dev, "COLOR LEVEL NOT SUPPORTED");
> +                       return -EINVAL;

I don't sure - may be you like big letters in logs..
Anyway, "\n" is absent in this 3 dev_err.


> +               }
> +               break;
> +       }
> +       if (!retval)
> +               lvc->current_value = vc->value;
> +       return retval;
> +}
> +
> +/*
> + * ioctl_enum_fmt_cap - Implement the CAPTURE buffer VIDIOC_ENUM_FMT ioctl
> + * @s: pointer to standard V4L2 device structure
> + * @fmt: standard V4L2 VIDIOC_ENUM_FMT ioctl structure
> + *
> + * Implement the VIDIOC_ENUM_FMT ioctl for the CAPTURE buffer type.
> + */
> + static int ioctl_enum_fmt_cap(struct v4l2_int_device *s,
> +                                  struct v4l2_fmtdesc *fmt)
> +{
> +       int index = fmt->index;
> +       enum v4l2_buf_type type = fmt->type;
> +
> +       memset(fmt, 0, sizeof(*fmt));
> +       fmt->index = index;
> +       fmt->type = type;
> +
> +       switch (fmt->type) {
> +       case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> +               if (index >= NUM_CAPTURE_FORMATS)
> +                       return -EINVAL;
> +       break;
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       fmt->flags = ov3640_formats[index].flags;
> +       strlcpy(fmt->description, ov3640_formats[index].description,
> +                                       sizeof(fmt->description));
> +       fmt->pixelformat = ov3640_formats[index].pixelformat;
> +
> +       return 0;
> +}
> +
> +
> +/*
> + * ioctl_try_fmt_cap - Implement the CAPTURE buffer VIDIOC_TRY_FMT ioctl
> + * @s: pointer to standard V4L2 device structure
> + * @f: pointer to standard V4L2 VIDIOC_TRY_FMT ioctl structure
> + *
> + * Implement the VIDIOC_TRY_FMT ioctl for the CAPTURE buffer type.  This
> + * ioctl is used to negotiate the image capture size and pixel format
> + * without actually making it take effect.
> + */
> +
> +static int ioctl_try_fmt_cap(struct v4l2_int_device *s,
> +                            struct v4l2_format *f)
> +{
> +       int ifmt;
> +       enum image_size_ov isize;
> +       struct v4l2_pix_format *pix = &f->fmt.pix;
> +
> +       if (pix->width > ov3640_sizes[QXGA].width)
> +               pix->width = ov3640_sizes[QXGA].width;
> +       if (pix->height > ov3640_sizes[QXGA].height)
> +               pix->height = ov3640_sizes[QXGA].height;
> +
> +       isize = ov3640_find_size(pix->width, pix->height);
> +       pix->width = ov3640_sizes[isize].width;
> +       pix->height = ov3640_sizes[isize].height;
> +
> +       for (ifmt = 0; ifmt < NUM_CAPTURE_FORMATS; ifmt++) {
> +               if (pix->pixelformat == ov3640_formats[ifmt].pixelformat)
> +                       break;
> +       }
> +       if (ifmt == NUM_CAPTURE_FORMATS)
> +               ifmt = 0;
> +       pix->pixelformat = ov3640_formats[ifmt].pixelformat;
> +       pix->field = V4L2_FIELD_NONE;
> +       pix->bytesperline = pix->width*2;
> +       pix->sizeimage = pix->bytesperline*pix->height;
> +       pix->priv = 0;
> +       switch (pix->pixelformat) {
> +       case V4L2_PIX_FMT_YUYV:
> +       case V4L2_PIX_FMT_UYVY:
> +       default:
> +               pix->colorspace = V4L2_COLORSPACE_JPEG;
> +               break;
> +       case V4L2_PIX_FMT_SGRBG10:
> +       case V4L2_PIX_FMT_RGB565:
> +       case V4L2_PIX_FMT_RGB565X:
> +       case V4L2_PIX_FMT_RGB555:
> +       case V4L2_PIX_FMT_RGB555X:
> +               pix->colorspace = V4L2_COLORSPACE_SRGB;
> +               break;
> +       }
> +       return 0;
> +}
> +
> +
> +/*
> + * ioctl_s_fmt_cap - V4L2 sensor interface handler for VIDIOC_S_FMT ioctl
> + * @s: pointer to standard V4L2 device structure
> + * @f: pointer to standard V4L2 VIDIOC_S_FMT ioctl structure
> + *
> + * If the requested format is supported, configures the HW to use that
> + * format, returns error code if format not supported or HW can't be
> + * correctly configured.
> + */
> + static int ioctl_s_fmt_cap(struct v4l2_int_device *s,
> +                               struct v4l2_format *f)
> +{
> +       struct ov3640_sensor *sensor = s->priv;
> +       struct v4l2_pix_format *pix = &f->fmt.pix;
> +       int rval;
> +
> +       rval = ioctl_try_fmt_cap(s, f);
> +       if (rval)
> +               return rval;
> +
> +       sensor->pix = *pix;
> +
> +       return 0;
> +}
> +
> +/*
> + * ioctl_g_fmt_cap - V4L2 sensor interface handler for ioctl_g_fmt_cap
> + * @s: pointer to standard V4L2 device structure
> + * @f: pointer to standard V4L2 v4l2_format structure
> + *
> + * Returns the sensor's current pixel format in the v4l2_format
> + * parameter.
> + */
> +static int ioctl_g_fmt_cap(struct v4l2_int_device *s,
> +                               struct v4l2_format *f)
> +{
> +       struct ov3640_sensor *sensor = s->priv;
> +       f->fmt.pix = sensor->pix;
> +
> +       return 0;
> +}
> +
> +/*
> + * ioctl_g_parm - V4L2 sensor interface handler for VIDIOC_G_PARM ioctl
> + * @s: pointer to standard V4L2 device structure
> + * @a: pointer to standard V4L2 VIDIOC_G_PARM ioctl structure
> + *
> + * Returns the sensor's video CAPTURE parameters.
> + */
> +static int ioctl_g_parm(struct v4l2_int_device *s,
> +                            struct v4l2_streamparm *a)
> +{
> +       struct ov3640_sensor *sensor = s->priv;
> +       struct v4l2_captureparm *cparm = &a->parm.capture;
> +
> +       if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +               return -EINVAL;
> +
> +       memset(a, 0, sizeof(*a));
> +       a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +
> +       cparm->capability = V4L2_CAP_TIMEPERFRAME;
> +       cparm->timeperframe = sensor->timeperframe;
> +
> +       return 0;
> +}
> +
> +/*
> + * ioctl_s_parm - V4L2 sensor interface handler for VIDIOC_S_PARM ioctl
> + * @s: pointer to standard V4L2 device structure
> + * @a: pointer to standard V4L2 VIDIOC_S_PARM ioctl structure
> + *
> + * Configures the sensor to use the input parameters, if possible.  If
> + * not possible, reverts to the old parameters and returns the
> + * appropriate error code.
> + */
> +static int ioctl_s_parm(struct v4l2_int_device *s,
> +                            struct v4l2_streamparm *a)
> +{
> +       int rval = 0;
> +       struct ov3640_sensor *sensor = s->priv;
> +       struct v4l2_fract *timeperframe = &a->parm.capture.timeperframe;
> +       struct v4l2_fract timeperframe_old;
> +       int desired_fps;
> +       timeperframe_old = sensor->timeperframe;
> +       sensor->timeperframe = *timeperframe;
> +
> +       desired_fps = timeperframe->denominator / timeperframe->numerator;
> +       if ((desired_fps < OV3640_MIN_FPS) || (desired_fps > OV3640_MAX_FPS))
> +               rval = -EINVAL;
> +
> +       if (rval)
> +               sensor->timeperframe = timeperframe_old;
> +       else
> +               *timeperframe = sensor->timeperframe;
> +
> +       return rval;
> +}
> +
> +/*
> + * ioctl_g_priv - V4L2 sensor interface handler for vidioc_int_g_priv_num
> + * @s: pointer to standard V4L2 device structure
> + * @p: void pointer to hold sensor's private data address
> + *
> + * Returns device's (sensor's) private data area address in p parameter
> + */
> +static int ioctl_g_priv(struct v4l2_int_device *s, void *p)
> +{
> +       struct ov3640_sensor *sensor = s->priv;
> +
> +       return sensor->pdata->priv_data_set(p);
> +}
> +
> +/*
> + * ioctl_s_power - V4L2 sensor interface handler for vidioc_int_s_power_num
> + * @s: pointer to standard V4L2 device structure
> + * @on: power state to which device is to be set
> + *
> + * Sets devices power state to requrested state, if possible.
> + */
> + static int ioctl_s_power(struct v4l2_int_device *s, enum v4l2_power on)
> +{
> +       struct ov3640_sensor *sensor = s->priv;
> +       struct i2c_client *c = sensor->i2c_client;
> +       struct omap34xxcam_hw_config hw_config;
> +       int rval;
> +
> +       rval = ioctl_g_priv(s, &hw_config);
> +       if (rval) {
> +               dev_err(&c->dev, "Unable to get hw params\n");
> +               return rval;
> +       }
> +
> +       rval = sensor->pdata->power_set(on);
> +       if (rval < 0) {
> +               dev_err(&c->dev, "Unable to set the power state: "
> +                       OV3640_DRIVER_NAME " sensor\n");
> +               sensor->pdata->set_xclk(0);
> +               return rval;
> +       }
> +
> +       if (on == V4L2_POWER_ON)
> +               sensor->pdata->set_xclk(xclk_current);
> +       else
> +               sensor->pdata->set_xclk(0);
> +
> +       if ((on == V4L2_POWER_ON) && (sensor->state == SENSOR_DETECTED))
> +               ov3640_configure(s);
> +
> +       if ((on == V4L2_POWER_ON) && (sensor->state == SENSOR_NOT_DETECTED)) {
> +               rval = ov3640_detect(c);
> +               if (rval < 0) {
> +                       dev_err(&c->dev, "Unable to detect "
> +                                       OV3640_DRIVER_NAME " sensor\n");
> +                       sensor->state = SENSOR_NOT_DETECTED;
> +                       return rval;
> +               }
> +               sensor->state = SENSOR_DETECTED;
> +               sensor->ver = rval;
> +               pr_info(OV3640_DRIVER_NAME " Chip version 0x%02x detected\n",
> +                                                               sensor->ver);
> +       }
> +       return 0;
> +}
> +
> +/*
> + * ioctl_init - V4L2 sensor interface handler for VIDIOC_INT_INIT
> + * @s: pointer to standard V4L2 device structure
> + *
> + * Initialize the sensor device (call ov3640_configure())
> + */
> +static int ioctl_init(struct v4l2_int_device *s)
> +{
> +       return 0;
> +}
> +
> +/**
> + * ioctl_dev_exit - V4L2 sensor interface handler for vidioc_int_dev_exit_num
> + * @s: pointer to standard V4L2 device structure
> + *
> + * Delinitialise the dev. at slave detach.  The complement of ioctl_dev_init.
> + */
> +static int ioctl_dev_exit(struct v4l2_int_device *s)
> +{
> +       return 0;
> +}
> +
> +/**
> + * ioctl_dev_init - V4L2 sensor interface handler for vidioc_int_dev_init_num
> + * @s: pointer to standard V4L2 device structure
> + *
> + * Initialise the device when slave attaches to the master.  Returns 0 if
> + * ov3640 device could be found, otherwise returns appropriate error.
> + */
> +static int ioctl_dev_init(struct v4l2_int_device *s)
> +{
> +       return 0;
> +}
> +
> +/**
> + * ioctl_enum_framesizes - V4L2 sensor if handler for vidioc_int_enum_framesizes
> + * @s: pointer to standard V4L2 device structure
> + * @frms: pointer to standard V4L2 framesizes enumeration structure
> + *
> + * Returns possible framesizes depending on choosen pixel format
> + **/
> +static int ioctl_enum_framesizes(struct v4l2_int_device *s,
> +                                       struct v4l2_frmsizeenum *frms)
> +{
> +       int ifmt;
> +
> +       for (ifmt = 0; ifmt < NUM_CAPTURE_FORMATS; ifmt++) {
> +               if (frms->pixel_format == ov3640_formats[ifmt].pixelformat)
> +                       break;
> +       }
> +       /* Is requested pixelformat not found on sensor? */
> +       if (ifmt == NUM_CAPTURE_FORMATS)
> +               return -EINVAL;
> +
> +       /* Do we already reached all discrete framesizes? */
> +       if (frms->index >= 2)
> +               return -EINVAL;
> +
> +       frms->type = V4L2_FRMSIZE_TYPE_DISCRETE;
> +       frms->discrete.width = ov3640_sizes[frms->index].width;
> +       frms->discrete.height = ov3640_sizes[frms->index].height;
> +
> +       return 0;
> +}
> +
> +const struct v4l2_fract ov3640_frameintervals[] = {
> +       { .numerator = 2, .denominator = 15 },
> +       { .numerator = 1, .denominator = 15 },
> +       { .numerator = 1, .denominator = 30 },
> +};
> +
> +static int ioctl_enum_frameintervals(struct v4l2_int_device *s,
> +                                       struct v4l2_frmivalenum *frmi)
> +{
> +       int ifmt;
> +
> +       for (ifmt = 0; ifmt < NUM_CAPTURE_FORMATS; ifmt++) {
> +               if (frmi->pixel_format == ov3640_formats[ifmt].pixelformat)
> +                       break;
> +       }
> +       /* Is requested pixelformat not found on sensor? */
> +       if (ifmt == NUM_CAPTURE_FORMATS)
> +               return -EINVAL;
> +
> +       /* Do we already reached all discrete framesizes? */
> +
> +       if ((frmi->width == ov3640_sizes[1].width) &&
> +                               (frmi->height == ov3640_sizes[1].height)) {
> +               /* FIXME: The only frameinterval supported by QXGA capture is
> +                * 2/15 fps
> +                */
> +               if (frmi->index != 0)
> +                       return -EINVAL;
> +       } else {
> +               if (frmi->index >= 3)
> +                       return -EINVAL;
> +       }
> +
> +       frmi->type = V4L2_FRMIVAL_TYPE_DISCRETE;
> +       frmi->discrete.numerator =
> +                               ov3640_frameintervals[frmi->index].numerator;
> +       frmi->discrete.denominator =
> +                               ov3640_frameintervals[frmi->index].denominator;
> +
> +       return 0;
> +}
> +
> +static struct v4l2_int_ioctl_desc ov3640_ioctl_desc[] = {
> +       {vidioc_int_enum_framesizes_num,
> +         (v4l2_int_ioctl_func *)ioctl_enum_framesizes},
> +       {vidioc_int_enum_frameintervals_num,
> +         (v4l2_int_ioctl_func *)ioctl_enum_frameintervals},
> +       {vidioc_int_dev_init_num,
> +         (v4l2_int_ioctl_func *)ioctl_dev_init},
> +       {vidioc_int_dev_exit_num,
> +         (v4l2_int_ioctl_func *)ioctl_dev_exit},
> +       {vidioc_int_s_power_num,
> +         (v4l2_int_ioctl_func *)ioctl_s_power},
> +       {vidioc_int_g_priv_num,
> +         (v4l2_int_ioctl_func *)ioctl_g_priv},
> +       {vidioc_int_init_num,
> +         (v4l2_int_ioctl_func *)ioctl_init},
> +       {vidioc_int_enum_fmt_cap_num,
> +         (v4l2_int_ioctl_func *)ioctl_enum_fmt_cap},
> +       {vidioc_int_try_fmt_cap_num,
> +         (v4l2_int_ioctl_func *)ioctl_try_fmt_cap},
> +       {vidioc_int_g_fmt_cap_num,
> +         (v4l2_int_ioctl_func *)ioctl_g_fmt_cap},
> +       {vidioc_int_s_fmt_cap_num,
> +         (v4l2_int_ioctl_func *)ioctl_s_fmt_cap},
> +       {vidioc_int_g_parm_num,
> +         (v4l2_int_ioctl_func *)ioctl_g_parm},
> +       {vidioc_int_s_parm_num,
> +         (v4l2_int_ioctl_func *)ioctl_s_parm},
> +       {vidioc_int_queryctrl_num,
> +         (v4l2_int_ioctl_func *)ioctl_queryctrl},
> +       {vidioc_int_g_ctrl_num,
> +         (v4l2_int_ioctl_func *)ioctl_g_ctrl},
> +       {vidioc_int_s_ctrl_num,
> +         (v4l2_int_ioctl_func *)ioctl_s_ctrl},
> +         { vidioc_int_g_crop_num,
> +         (v4l2_int_ioctl_func *)ioctl_g_crop},
> +       {vidioc_int_s_crop_num,
> +         (v4l2_int_ioctl_func *)ioctl_s_crop},
> +         { vidioc_int_cropcap_num,
> +         (v4l2_int_ioctl_func *)ioctl_cropcap},
> +};
> +
> +static struct v4l2_int_slave ov3640_slave = {
> +       .ioctls         = ov3640_ioctl_desc,
> +       .num_ioctls     = ARRAY_SIZE(ov3640_ioctl_desc),
> +};
> +
> +static struct v4l2_int_device ov3640_int_device = {
> +       .module = THIS_MODULE,
> +       .name   = OV3640_DRIVER_NAME,
> +       .priv   = &ov3640,
> +       .type   = v4l2_int_type_slave,
> +       .u      = {
> +               .slave = &ov3640_slave,
> +       },
> +};
> +
> +/*
> + * ov3640_probe - sensor driver i2c probe handler
> + * @client: i2c driver client device structure
> + *
> + * Register sensor as an i2c client device and V4L2
> + * device.
> + */
> +static int __init
> +ov3640_probe(struct i2c_client *client, const struct i2c_device_id *id)
> +{
> +       struct ov3640_sensor *sensor = &ov3640;
> +       int err;
> +
> +       if (i2c_get_clientdata(client))
> +               return -EBUSY;
> +
> +       sensor->pdata = client->dev.platform_data;
> +
> +       if (!sensor->pdata) {
> +               dev_err(&client->dev, "No platform data?\n");
> +               return -ENODEV;
> +       }
> +
> +       sensor->v4l2_int_device = &ov3640_int_device;
> +       sensor->i2c_client = client;
> +
> +       i2c_set_clientdata(client, sensor);
> +
> +       /* Make the default capture format XGA RGB565 */
> +       sensor->pix.width = ov3640_sizes[XGA].width;
> +       sensor->pix.height = ov3640_sizes[XGA].height;
> +       sensor->pix.pixelformat = V4L2_PIX_FMT_RGB565;
> +
> +       err = v4l2_int_device_register(sensor->v4l2_int_device);
> +       if (err)
> +               i2c_set_clientdata(client, NULL);
> +
> +       return 0;
> +}
> +
> +/*
> + * ov3640_remove - sensor driver i2c remove handler
> + * @client: i2c driver client device structure
> + *
> + * Unregister sensor as an i2c client device and V4L2
> + * device. Complement of ov3640_probe().
> + */
> +static int __exit
> +ov3640_remove(struct i2c_client *client)
> +{
> +       struct ov3640_sensor *sensor = i2c_get_clientdata(client);
> +
> +       if (!client->adapter)
> +               return -ENODEV; /* our client isn't attached */
> +
> +       v4l2_int_device_unregister(sensor->v4l2_int_device);
> +       i2c_set_clientdata(client, NULL);
> +
> +       return 0;
> +}
> +
> +static const struct i2c_device_id ov3640_id[] = {
> +       { OV3640_DRIVER_NAME, 0 },
> +       { },
> +};
> +MODULE_DEVICE_TABLE(i2c, ov3640_id);
> +
> +static struct i2c_driver ov3640sensor_i2c_driver = {
> +       .driver = {
> +               .name   = OV3640_DRIVER_NAME,
> +               .owner = THIS_MODULE,
> +       },
> +       .probe  = ov3640_probe,
> +       .remove = __exit_p(ov3640_remove),
> +       .id_table = ov3640_id,
> +};
> +
> +static struct ov3640_sensor ov3640 = {
> +       .timeperframe = {
> +               .numerator = 1,
> +               .denominator = 15,
> +       },
> +       .state = SENSOR_NOT_DETECTED,
> +};
> +
> +/*
> + * ov3640sensor_init - sensor driver module_init handler
> + *
> + * Registers driver as an i2c client driver.  Returns 0 on success,
> + * error code otherwise.
> + */
> +static int __init ov3640sensor_init(void)
> +{
> +       int err;
> +
> +       err = i2c_add_driver(&ov3640sensor_i2c_driver);
> +       if (err) {
> +               printk(KERN_ERR "Failed to register" OV3640_DRIVER_NAME ".\n");
> +               return err;
> +       }
> +       return 0;
> +}
> +module_init(ov3640sensor_init);
> +
> +/*
> + * ov3640sensor_cleanup - sensor driver module_exit handler
> + *
> + * Unregisters/deletes driver as an i2c client driver.
> + * Complement of ov3640sensor_init.
> + */
> +static void __exit ov3640sensor_cleanup(void)
> +{
> +       i2c_del_driver(&ov3640sensor_i2c_driver);
> +}
> +module_exit(ov3640sensor_cleanup);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("OV3640 camera sensor driver");
> +
> +
> diff --git a/drivers/media/video/ov3640_regs.h b/drivers/media/video/ov3640_regs.h
> new file mode 100644
> index 0000000..735be86
> --- /dev/null
> +++ b/drivers/media/video/ov3640_regs.h
> @@ -0,0 +1,600 @@
> +/*
> + * drivers/media/video/ov3640_regs.h
> + *
> + * Register definitions for the OV3640 CameraChip.
> + *
> + * Contributors:
> + *   Pallavi Kulkarni <p-kulkarni@ti.com>
> + *   Sergio Aguirre <saaguirre@ti.com>
> + *
> + * Copyright (C) 2009 Texas Instruments.
> + *
> + * This file is licensed under the terms of the GNU General Public License
> + * version 2. This program is licensed "as is" without any warranty of any
> + * kind, whether express or implied.
> + */
> +
> +#ifndef OV3640_REGS_H
> +#define OV3640_REGS_H
> +
> +/*
> + * System Control Registers
> + */
> +#define OV3640_AGC_H                           0x3000
> +#define OV3640_AGC_L                           0x3001
> +#define OV3640_AEC_H                           0x3002
> +#define OV3640_AEC_L                           0x3003
> +#define OV3640_AECL                            0x3004
> +#define OV3640_RED                             0x3005
> +#define OV3640_GREEN                           0x3006
> +#define OV3640_BLUE                            0x3007
> +#define OV3640_PIDH                            0x300A
> +#define OV3640_PIDL                            0x300B
> +#define OV3640_SCCB_ID                         0x300C
> +#define OV3640_PCLK                            0x300D
> +#define OV3640_PCLK_HREFQUAL_OUT               (1 << 5)
> +#define OV3640_PCLK_REVERSE                    (1 << 4)
> +#define OV3640_PCLK_DIVBY4                     (1 << 1)
> +#define OV3640_PCLK_DIVBY2                     1
> +
> +#define OV3640_PLL_1                           0x300E
> +#define OV3640_PLL_1_RXPLL_MASK                        0x3F
> +
> +#define OV3640_PLL_2                           0x300F
> +#define OV3640_PLL_2_FREQDIV_MASK              (0x3 << 6)
> +#define OV3640_PLL_2_FREQDIV_1                 (0x0 << 6)
> +#define OV3640_PLL_2_FREQDIV_1_5               (0x1 << 6)
> +#define OV3640_PLL_2_FREQDIV_2                 (0x2 << 6)
> +#define OV3640_PLL_2_FREQDIV_3                 (0x3 << 6)
> +
> +#define OV3640_PLL_2_BIT8DIV_MASK              (0x3 << 4)
> +#define OV3640_PLL_2_BIT8DIV_1                 (0x0 << 4)
> +#define OV3640_PLL_2_BIT8DIV_1_2               (0x1 << 4)
> +#define OV3640_PLL_2_BIT8DIV_4                 (0x2 << 4)
> +#define OV3640_PLL_2_BIT8DIV_5                 (0x3 << 4)
> +#define OV3640_PLL_2_BYPASS                    (1 << 3)
> +
> +#define OV3640_PLL_2_INDIV_MASK                        0x3
> +#define OV3640_PLL_2_INDIV_1                   0x0
> +#define OV3640_PLL_2_INDIV_1_5                 0x1
> +#define OV3640_PLL_2_INDIV_2                   0x2
> +#define OV3640_PLL_2_INDIV_3                   0x3
> +
> +#define OV3640_PLL_3                           0x3010
> +#define OV3640_PLL_3_DVPDIV_MASK               (0x3 << 6)
> +#define OV3640_PLL_3_DVPDIV_1                  (0x0 << 6)
> +#define OV3640_PLL_3_DVPDIV_2                  (0x1 << 6)
> +#define OV3640_PLL_3_DVPDIV_8                  (0x2 << 6)
> +#define OV3640_PLL_3_DVPDIV_16                 (0x3 << 6)
> +
> +#define OV3640_PLL_3_LANEDIV2LANES             (1 << 5)
> +#define OV3640_PLL_3_SENSORDIV2                        (1 << 4)
> +
> +#define OV3640_PLL_3_SCALEDIV_MASK             0xF
> +
> +#define OV3640_CLK                             0x3011
> +#define OV3640_CLK_DFREQDBL                    (1 << 7)
> +#define OV3640_CLK_SLAVEMODE                   (1 << 6)
> +#define OV3640_CLK_DIV_MASK                    0x3F
> +
> +#define OV3640_SYS                             0x3012
> +#define OV3640_SYS_SRST                                (1 << 7)
> +#define OV3640_SYS_BASERES_MASK                        (0x7 << 4)
> +#define OV3640_SYS_BASERES_QXGA                        (0x0 << 4)
> +#define OV3640_SYS_BASERES_XGA                 (0x1 << 4)
> +#define OV3640_SYS_BASERES_SXGA                        (0x7 << 4)
> +
> +#define OV3640_AUTO_1                          0x3013
> +#define OV3640_AUTO_1_FASTAEC                  (1 << 7)
> +#define OV3640_AUTO_1_AECBIGSTEPS              (1 << 6)
> +#define OV3640_AUTO_1_BANDINGFILTEREN          (1 << 5)
> +#define OV3640_AUTO_1_AUTOBANDINGFILTER                (1 << 4)
> +#define OV3640_AUTO_1_EXTRBRIGHTEXPEN          (1 << 3)
> +#define OV3640_AUTO_1_AGCEN                    (1 << 2)
> +#define OV3640_AUTO_1_AECEN                    1
> +
> +#define OV3640_AUTO_2                          0x3014
> +#define OV3640_AUTO_2_MANBANDING50             (1 << 7)
> +#define OV3640_AUTO_2_AUTOBANDINGDETEN         (1 << 6)
> +#define OV3640_AUTO_2_AGCADDLT1F               (1 << 5)
> +#define OV3640_AUTO_2_FREEZEAECAGC             (1 << 4)
> +#define OV3640_AUTO_2_NIGHTMODEEN              (1 << 3)
> +#define OV3640_AUTO_2_BANDINGSMOOTHSW          (1 << 2)
> +#define OV3640_AUTO_2_MANEXTRBRIGHTEXPEN       (1 << 1)
> +#define OV3640_AUTO_2_BANDINGFILTEREN          1
> +
> +#define OV3640_AUTO_3                          0x3015
> +#define OV3640_AUTO_3_DUMMYFC_MASK             (0x7 << 4)
> +#define OV3640_AUTO_3_DUMMYFC_NONE             (0x0 << 4)
> +#define OV3640_AUTO_3_DUMMYFC_1FRAME           (0x1 << 4)
> +#define OV3640_AUTO_3_DUMMYFC_2FRAME           (0x2 << 4)
> +#define OV3640_AUTO_3_DUMMYFC_3FRAME           (0x3 << 4)
> +#define OV3640_AUTO_3_DUMMYFC_7FRAME           (0x7 << 4)
> +
> +#define OV3640_AUTO_3_AGCGAINCEIL_MASK         0x7
> +#define OV3640_AUTO_3_AGCGAINCEIL_2X           0x0
> +#define OV3640_AUTO_3_AGCGAINCEIL_4X           0x1
> +#define OV3640_AUTO_3_AGCGAINCEIL_8X           0x2
> +#define OV3640_AUTO_3_AGCGAINCEIL_16X          0x3
> +#define OV3640_AUTO_3_AGCGAINCEIL_32X          0x4
> +#define OV3640_AUTO_3_AGCGAINCEIL_64X          0x5
> +#define OV3640_AUTO_3_AGCGAINCEIL_128X         0x6
> +#define OV3640_AUTO_3_AGCGAINCEIL_128X_2       0x7
> +
> +#define OV3640_AUTO_5                          0x3017
> +#define OV3640_AUTO_5_MANBANDINGCNT_MASK       0x3F
> +
> +#define OV3640_WPT_HISH                                0x3018
> +#define OV3640_BPT_HISL                                0x3019
> +#define OV3640_VPT                             0x301A
> +#define OV3640_YAVG                            0x301B
> +#define OV3640_AECG_MAX50                      0x301C
> +#define OV3640_AECG_MAX60                      0x301D
> +#define OV3640_RZM_H                           0x301E
> +#define OV3640_RZM_L                           0x301F
> +
> +#define OV3640_HS_H                            0x3020
> +#define OV3640_HS_L                            0x3021
> +#define OV3640_VS_H                            0x3022
> +#define OV3640_VS_L                            0x3023
> +#define OV3640_HW_H                            0x3024
> +#define OV3640_HW_L                            0x3025
> +#define OV3640_VH_H                            0x3026
> +#define OV3640_VH_L                            0x3027
> +#define OV3640_HTS_H                           0x3028
> +#define OV3640_HTS_L                           0x3029
> +#define OV3640_VTS_H                           0x302A
> +#define OV3640_VTS_L                           0x302B
> +#define OV3640_EXHTS                           0x302C
> +#define OV3640_EXVTS_H                         0x302D
> +#define OV3640_EXVTS_L                         0x302E
> +
> +#define OV3640_WEIGHT0                         0x3030
> +#define OV3640_WEIGHT1                         0x3031
> +#define OV3640_WEIGHT2                         0x3032
> +#define OV3640_WEIGHT3                         0x3033
> +#define OV3640_WEIGHT4                         0x3034
> +#define OV3640_WEIGHT5                         0x3035
> +#define OV3640_WEIGHT6                         0x3036
> +#define OV3640_WEIGHT7                         0x3037
> +#define OV3640_AHS_H                           0x3038
> +#define OV3640_AHS_L                           0x3039
> +#define OV3640_AVS_H                           0x303A
> +#define OV3640_AVS_L                           0x303B
> +#define OV3640_AHW_H                           0x303C
> +#define OV3640_AHW_L                           0x303D
> +#define OV3640_AVH_H                           0x303E
> +#define OV3640_AVH_L                           0x303F
> +
> +#define OV3640_HISTO0                          0x3040
> +#define OV3640_HISTO1                          0x3041
> +#define OV3640_HISTO2                          0x3042
> +#define OV3640_HISTO3                          0x3043
> +#define OV3640_HISTO4                          0x3044
> +#define OV3640_HISTO5                          0x3045
> +#define OV3640_HISTO6                          0x3046
> +#define OV3640_HISTO7                          0x3047
> +#define OV3640_D56C1                           0x3048
> +
> +#define OV3640_BLC9                            0x3069
> +
> +#define OV3640_BD50_H                          0x3070
> +#define OV3640_BD50_L                          0x3071
> +#define OV3640_BD60_H                          0x3072
> +#define OV3640_BD60_L                          0x3073
> +#define OV3640_VSYNCOPT                                0x3075
> +#define OV3640_TMC1                            0x3077
> +#define OV3640_TMC1_CHSYNCSWAP                 (1 << 7)
> +#define OV3640_TMC1_HREFSWAP                   (1 << 6)
> +#define OV3640_TMC1_HREFPOL_NEG                        (1 << 3)
> +#define OV3640_TMC1_VSYNCPOL_NEG               (1 << 1)
> +#define OV3640_TMC1_HSYNCPOL_NEG               1
> +
> +#define OV3640_TMC2                            0x3078
> +#define OV3640_TMC2_VSYNCDROP                  (1 << 1)
> +#define OV3640_TMC2_FRAMEDATADROP              1
> +
> +#define OV3640_TMC3                            0x3079
> +#define OV3640_TMC3_VSLATCH                    (1 << 7)
> +
> +#define OV3640_TMC4                            0x307A
> +#define OV3640_TMC5                            0x307B
> +#define OV3640_TMC5_AWB_GAINWRITE_DIS          (1 << 7)
> +#define OV3640_TMC5_DCOLORBAREN                        (1 << 3)
> +#define OV3640_TMC5_DCOLORBARPAT_MASK          0x7
> +
> +#define OV3640_TMC6                            0x307C
> +#define OV3640_TMC6_DGAINEN                    (1 << 5)
> +#define OV3640_TMC6_HMIRROR                    (1 << 1)
> +#define OV3640_TMC6_VFLIP                      (1 << 0)
> +
> +#define OV3640_TMC7                            0x307D
> +#define OV3640_TMC7_COLORBARTESTPATEN          (1 << 7)
> +#define OV3640_TMC7_AVGHIST_SENSOR             (1 << 5)
> +
> +#define OV3640_TMC8                            0x307E
> +
> +#define OV3640_TMCA                            0x3080
> +#define OV3640_TMCB                            0x3081
> +#define OV3640_TMCB_MIRROROPTEN                        (1 << 7)
> +#define OV3640_TMCB_OTPFASTMEMCLK              (1 << 6)
> +#define OV3640_TMCB_SWAPBYTESOUT               1
> +
> +#define OV3640_TMCF                            0x3085
> +#define OV3640_TMC10                           0x3086
> +#define OV3640_TMC10_SYSRST                    (1 << 3)
> +#define OV3640_TMC10_REGSLEEPOPT               (1 << 2)
> +#define OV3640_TMC10_SLEEPOPT                  (1 << 1)
> +#define OV3640_TMC10_SLEEPEN                   1
> +
> +#define OV3640_TMC11                           0x3087
> +#define OV3640_ISP_XOUT_H                      0x3088
> +#define OV3640_ISP_XOUT_L                      0x3089
> +#define OV3640_ISP_YOUT_H                      0x308A
> +#define OV3640_ISP_YOUT_L                      0x308B
> +#define OV3640_TMC13                           0x308D
> +#define OV3640_5060                            0x308E
> +#define OV3640_OTP                             0x308F
> +
> +#define OV3640_IO_CTRL0                                0x30B0
> +#define OV3640_IO_CTRL1                                0x30B1
> +#define OV3640_IO_CTRL2                                0x30B2
> +#define OV3640_DVP0                            0x30B4
> +#define OV3640_DVP1                            0x30B5
> +#define OV3640_DVP2                            0x30B6
> +#define OV3640_DVP3                            0x30B7
> +#define OV3640_DSPC0                           0x30B8
> +#define OV3640_DSPC1                           0x30B9
> +#define OV3640_DSPC2                           0x30BA
> +#define OV3640_DSPC3                           0x30BB
> +#define OV3640_DSPC7                           0x30BF
> +/*
> + * END - System Control Registers
> + */
> +
> +/*
> + * SC Registers
> + */
> +#define OV3640_SC_CTRL0                                0x3100
> +#define OV3640_SC_CTRL2                                0x3102
> +#define OV3640_SC_SYN_CTRL0                    0x3104
> +#define OV3640_SC_SYN_CTRL1                    0x3105
> +#define OV3640_SC_SYN_CTRL2                    0x3106
> +#define OV3640_SC_SYN_CTRL3                    0x3107
> +/*
> + * END - SC Registers
> + */
> +
> +/*
> + * CIF Registers
> + */
> +#define OV3640_CIF_CTRL0                       0x3200
> +#define OV3640_CIF_CTRL4                       0x3204
> +/*
> + * END - CIF Registers
> + */
> +
> +/*
> + * DSP Registers
> + */
> +#define OV3640_DSP_CTRL_0                      0x3300
> +#define OV3640_DSP_CTRL_1                      0x3301
> +#define OV3640_DSP_CTRL_2                      0x3302
> +#define OV3640_DSP_CTRL_4                      0x3304
> +#define OV3640_AWB_CTRL_3                      0x3308
> +
> +#define OV3640_YST1                            0x331B
> +#define OV3640_YST2                            0x331C
> +#define OV3640_YST3                            0x331D
> +#define OV3640_YST4                            0x331E
> +#define OV3640_YST5                            0x331F
> +
> +#define OV3640_YST6                            0x3320
> +#define OV3640_YST7                            0x3321
> +#define OV3640_YST8                            0x3322
> +#define OV3640_YST9                            0x3323
> +#define OV3640_YST10                           0x3324
> +#define OV3640_YST11                           0x3325
> +#define OV3640_YST12                           0x3326
> +#define OV3640_YST13                           0x3327
> +#define OV3640_YST14                           0x3328
> +#define OV3640_YST15                           0x3329
> +#define OV3640_YSLP15                          0x332A
> +#define OV3640_MISC_CTRL                       0x332B
> +#define OV3640_DNS_TH                          0x332C
> +#define OV3640_Y_EDGE_MT                       0x332D
> +#define OV3640_Y_EDGE_TH_TM                    0x332E
> +#define OV3640_BASE1                           0x332F
> +
> +#define OV3640_BASE2                           0x3330
> +#define OV3640_OFFSET                          0x3331
> +#define OV3640_CMXSIGN_MISC                    0x333F
> +
> +#define OV3640_CMX_1                           0x3340
> +#define OV3640_CMX_2                           0x3341
> +#define OV3640_CMX_3                           0x3342
> +#define OV3640_CMX_4                           0x3343
> +#define OV3640_CMX_5                           0x3344
> +#define OV3640_CMX_6                           0x3345
> +#define OV3640_CMX_7                           0x3346
> +#define OV3640_CMX_8                           0x3347
> +#define OV3640_CMX_9                           0x3348
> +#define OV3640_CMXSIGN                         0x3349
> +
> +#define OV3640_SGNSET                          0x3354
> +#define OV3640_SDE_CTRL                                0x3355
> +#define OV3640_HUE_COS                         0x3356
> +#define OV3640_HUE_SIN                         0x3357
> +#define OV3640_SAT_U                           0x3358
> +#define OV3640_SAT_V                           0x3359
> +#define OV3640_UREG                            0x335A
> +#define OV3640_VREG                            0x335B
> +#define OV3640_YOFFSET                         0x335C
> +#define OV3640_YGAIN                           0x335D
> +#define OV3640_YBRIGHT                         0x335E
> +#define OV3640_SIZE_IN_MISC                    0x335F
> +
> +#define OV3640_HSIZE_IN_L                      0x3360
> +#define OV3640_VSIZE_IN_L                      0x3361
> +#define OV3640_SIZE_OUT_MISC                   0x3362
> +#define OV3640_HSIZE_OUT_L                     0x3363
> +#define OV3640_VSIZE_OUT_L                     0x3364
> +
> +#define OV3640_R_XY0                           0x3367
> +#define OV3640_R_X0                            0x3368
> +#define OV3640_R_Y0                            0x3369
> +#define OV3640_R_A1                            0x336A
> +#define OV3640_R_A2_B2                         0x336B
> +#define OV3640_R_B1                            0x336C
> +#define OV3640_G_XY0                           0x336D
> +#define OV3640_G_X0                            0x336E
> +#define OV3640_G_Y0                            0x336F
> +
> +#define OV3640_G_A1                            0x3370
> +#define OV3640_G_A2_B2                         0x3371
> +#define OV3640_G_B1                            0x3372
> +#define OV3640_B_XY0                           0x3373
> +#define OV3640_B_X0                            0x3374
> +#define OV3640_B_Y0                            0x3375
> +#define OV3640_B_A1                            0x3376
> +#define OV3640_B_A2_B2                         0x3377
> +#define OV3640_B_B1                            0x3378
> +
> +#define OV3640_MISC_DCW_SIZE                   0x33A4
> +#define OV3640_DCW_OH                          0x33A5
> +#define OV3640_DCW_OV                          0x33A6
> +#define OV3640_R_GAIN_M                                0x33A7
> +#define OV3640_G_GAIN_M                                0x33A8
> +#define OV3640_B_GAIN_M                                0x33A9
> +#define OV3640_OVLY_MISC1                      0x33AA
> +#define OV3640_OVLY_LEFT                       0x33AB
> +#define OV3640_OVLY_TOP                                0x33AC
> +#define OV3640_OVLY_MISC2                      0x33AD
> +#define OV3640_OVLY_RIGHT                      0x33AE
> +#define OV3640_OVLY_BOTTEM                     0x33AF
> +
> +#define OV3640_OVLY_MISC3                      0x33B0
> +#define OV3640_OVLY_EXT_WIDTH_H                        0x33B1
> +#define OV3640_OVLY_EXT_WIDTH_L                        0x33B2
> +#define OV3640_OVLY_Y                          0x33B3
> +#define OV3640_OVLY_U                          0x33B4
> +#define OV3640_OVLY_V                          0x33B5
> +/*
> + * END - DSP Registers
> + */
> +
> +/*
> + * FMT MUX Registers
> + */
> +#define OV3640_FMT_MUX_CTRL0                   0x3400
> +#define OV3640_ISP_PAD_CTR2                    0x3403
> +#define OV3640_FMT_CTRL00                      0x3404
> +#define OV3640_FMT_CTRL00_UV_sel_SHIFT         7
> +#define OV3640_FMT_CTRL00_UV_sel_MASK          (0x1 << \
> +                                               OV3640_FMT_CTRL00_UV_sel_SHIFT)
> +#define OV3640_FMT_CTRL00_UV_sel_USE_UV_avg_Y  (0x0 << \
> +                                               OV3640_FMT_CTRL00_UV_sel_SHIFT)
> +#define OV3640_FMT_CTRL00_UV_sel_USE_U0Y0_V0Y1 (0x1 << \
> +                                               OV3640_FMT_CTRL00_UV_sel_SHIFT)
> +
> +#define OV3640_FMT_CTRL00_YUV422_in_SHIFT      6
> +#define OV3640_FMT_CTRL00_YUV422_in_MASK       (0x1 << \
> +                                       OV3640_FMT_CTRL00_YUV422_in_SHIFT)
> +#define OV3640_FMT_CTRL00_YUV422_in_DISABLE    (0x0 << \
> +                                       OV3640_FMT_CTRL00_YUV422_in_SHIFT)
> +#define OV3640_FMT_CTRL00_YUV422_in_ENABLE     (0x1 << \
> +                                       OV3640_FMT_CTRL00_YUV422_in_SHIFT)
> +
> +#define OV3640_FMT_CTRL00_FMT_SHIFT            0
> +#define OV3640_FMT_CTRL00_FMT_MASK             (0x3F << \
> +                                               OV3640_FMT_CTRL00_FMT_SHIFT)
> +#define OV3640_DITHER_CTRL0                    0x3405
> +/*
> + * END - FMT MUX Registers
> + */
> +
> +/*
> + * OUT_TOP Registers
> + */
> +#define OV3640_OUT_CTRL00                      0x3600
> +#define OV3640_OUT_CTRL00_VSYNCSEL2            (1 << 7)
> +#define OV3640_OUT_CTRL00_VSYNCGATE            (1 << 6)
> +#define OV3640_OUT_CTRL00_PCLKPOL_NEG          (1 << 4)
> +#define OV3640_OUT_CTRL00_HREFPOL_NEG          (1 << 3)
> +#define OV3640_OUT_CTRL00_VSYNCPOL_NEG         (1 << 2)
> +#define OV3640_OUT_CTRL00_VSYNCSEL             (1 << 1)
> +#define OV3640_OUT_CTRL00_DVPOUTDATAORDERINV   1
> +
> +#define OV3640_OUT_CTRL01                      0x3601
> +#define OV3640_OUT_CTRL01_PCLKGATEEN           (1 << 7)
> +#define OV3640_OUT_CTRL01_CCIR656EN            (1 << 4)
> +#define OV3640_OUT_CTRL01_MIPIBIT8             1
> +
> +#define OV3640_MIPI_CTRL02                     0x3602
> +#define OV3640_MIPI_CTRL02_DVPDISABLE          (1 << 4)
> +#define OV3640_MIPI_CTRL02_MIPILINESYNCEN      (1 << 2)
> +#define OV3640_MIPI_CTRL02_MIPIGATESCEN                (1 << 1)
> +
> +#define OV3640_MIPI_CTRL03                     0x3603
> +#define OV3640_MIPI_CTRL03_ECC_PHBYTEORDER     (1 << 2)
> +#define OV3640_MIPI_CTRL03_ECC_PHBITORDER      (1 << 1)
> +
> +#define OV3640_OUT_CTRL08                      0x3608
> +#define OV3640_OUT_CTRL08_HREF_DLY_SHIFT       4
> +#define OV3640_OUT_CTRL08_HREF_DLY_MASK                (0xF << \
> +                                       OV3640_OUT_CTRL08_HREF_DLY_SHIFT)
> +
> +
> +#define OV3640_OUT_CTRL09                      0x3609
> +#define OV3640_OUT_CTRL0A                      0x360A
> +#define OV3640_OUT_CTRL0B                      0x360B
> +#define OV3640_MIPI_CTRL0C                     0x360C
> +#define OV3640_MIPI_CTRL0C_VIRTUALCH_ID_MASK   (0x3 << 6)
> +
> +#define OV3640_OUT_CTRL0D                      0x360D
> +#define OV3640_MIPI_CTRL0E                     0x360E
> +#define OV3640_MIPI_CTRL0E_WKUPDELAY_MASK      0x3F
> +
> +
> +#define OV3640_MIPI_CTRL10                     0x3610
> +#define OV3640_MIPI_CTRL10_WIDTH_MAN_L_MASK    0xFF
> +
> +#define OV3640_MIPI_CTRL11                     0x3611
> +#define OV3640_MIPI_CTRL11_WIDTH_MAN_H_MASK    (0x7 << 5)
> +
> +#define OV3640_CLIP_MIN                                0x3614
> +#define OV3640_CLIP_MAX                                0x3615
> +#define OV3640_OUT_CTRL16                      0x3616
> +#define OV3640_OUT_CTRL1D                      0x361D
> +#define OV3640_OUT_CTRL1E                      0x361E
> +#define OV3640_MIPI_CTRL1F                     0x361F
> +#define OV3640_MIPI_CTRL1F_PCLK_PERIOD_MASK    0xFF
> +
> +#define OV3640_MIPI_CTRL22                     0x3622
> +#define OV3640_MIPI_CTRL22_MIN_HS_ZERO_NUI_SHIFT       2
> +#define OV3640_MIPI_CTRL22_MIN_HS_ZERO_NUI_MASK                (0x3F << \
> +                               OV3640_MIPI_CTRL22_MIN_HS_ZERO_NUI_SHIFT)
> +#define OV3640_MIPI_CTRL22_MIN_HS_ZERO_H_MASK  0x3
> +
> +#define OV3640_MIPI_CTRL23                     0x3623
> +#define OV3640_MIPI_CTRL23_MIN_HS_ZERO_L_MASK  0xFF
> +
> +#define OV3640_MIPI_CTRL24                     0x3624
> +#define OV3640_MIPI_CTRL24_MIN_HS_TRAIL_NUI_SHIFT      2
> +#define OV3640_MIPI_CTRL24_MIN_HS_TRAIL_NUI_MASK       (0x3F << \
> +                               OV3640_MIPI_CTRL24_MIN_HS_TRAIL_NUI_SHIFT)
> +#define OV3640_MIPI_CTRL24_MIN_HS_TRAIL_H_MASK 0x3
> +
> +#define OV3640_MIPI_CTRL25                     0x3625
> +#define OV3640_MIPI_CTRL25_MIN_HS_TRAIL_L_MASK 0xFF
> +
> +#define OV3640_MIPI_CTRL26                     0x3626
> +#define OV3640_MIPI_CTRL26_MIN_CLK_ZERO_NUI_SHIFT      2
> +#define OV3640_MIPI_CTRL26_MIN_CLK_ZERO_NUI_MASK       (0x3F << \
> +                               OV3640_MIPI_CTRL26_MIN_CLK_ZERO_NUI_SHIFT)
> +#define OV3640_MIPI_CTRL26_MIN_CLK_ZERO_H_MASK 0x3
> +
> +#define OV3640_MIPI_CTRL27                     0x3627
> +#define OV3640_MIPI_CTRL27_MIN_CLK_ZERO_L_MASK 0xFF
> +
> +#define OV3640_MIPI_CTRL28                     0x3628
> +#define OV3640_MIPI_CTRL28_MIN_CLK_PREPARE_NUI_SHIFT   2
> +#define OV3640_MIPI_CTRL28_MIN_CLK_PREPARE_NUI_MASK            (0x3F << \
> +                               OV3640_MIPI_CTRL28_MIN_CLK_PREPARE_NUI_SHIFT)
> +#define OV3640_MIPI_CTRL28_MIN_CLK_PREPARE_H_MASK      0x3
> +
> +#define OV3640_MIPI_CTRL29                     0x3629
> +#define OV3640_MIPI_CTRL29_MIN_CLK_PREPARE_L_MASK      0xFF
> +
> +#define OV3640_MIPI_CTRL2A                     0x362A
> +#define OV3640_MIPI_CTRL2A_MAX_CLK_PREPARE_NUI_SHIFT   2
> +#define OV3640_MIPI_CTRL2A_MAX_CLK_PREPARE_NUI_MASK            (0x3F << \
> +                               OV3640_MIPI_CTRL2A_MAX_CLK_PREPARE_NUI_SHIFT)
> +#define OV3640_MIPI_CTRL2A_MAX_CLK_PREPARE_H_MASK      0x3
> +
> +#define OV3640_MIPI_CTRL2B                     0x362B
> +#define OV3640_MIPI_CTRL2B_MAX_CLK_PREPARE_L_MASK      0xFF
> +
> +#define OV3640_MIPI_CTRL2C                     0x362C
> +#define OV3640_MIPI_CTRL2C_MIN_CLK_POST_NUI_SHIFT      2
> +#define OV3640_MIPI_CTRL2C_MIN_CLK_POST_NUI_MASK       (0x3F << \
> +                               OV3640_MIPI_CTRL2C_MIN_CLK_POST_NUI_SHIFT)
> +#define OV3640_MIPI_CTRL2C_MIN_CLK_POST_H_MASK 0x3
> +
> +#define OV3640_MIPI_CTRL2D                     0x362D
> +#define OV3640_MIPI_CTRL2D_MIN_CLK_POST_L_MASK 0xFF
> +
> +#define OV3640_MIPI_CTRL2E                     0x362E
> +#define OV3640_MIPI_CTRL2E_MIN_CLK_TRAIL_NUI_SHIFT     2
> +#define OV3640_MIPI_CTRL2E_MIN_CLK_TRAIL_NUI_MASK      (0x3F << \
> +                               OV3640_MIPI_CTRL2E_MIN_CLK_TRAIL_NUI_SHIFT)
> +#define OV3640_MIPI_CTRL2E_MIN_CLK_TRAIL_H_MASK        0x3
> +
> +#define OV3640_MIPI_CTRL2F                     0x362F
> +#define OV3640_MIPI_CTRL2F_MIN_CLK_TRAIL_L_MASK        0xFF
> +
> +#define OV3640_MIPI_CTRL30                     0x3630
> +#define OV3640_MIPI_CTRL30_MIN_LPX_P_NUI_SHIFT 2
> +#define OV3640_MIPI_CTRL30_MIN_LPX_P_NUI_MASK  (0x3F << \
> +                                       OV3640_MIPI_CTRL30_MIN_LPX_P_NUI_SHIFT)
> +#define OV3640_MIPI_CTRL30_MIN_LPX_P_H_MASK    0x3
> +
> +#define OV3640_MIPI_CTRL31                     0x3631
> +#define OV3640_MIPI_CTRL31_MIN_LPX_P_L_MASK    0xFF
> +
> +#define OV3640_MIPI_CTRL32                     0x3632
> +#define OV3640_MIPI_CTRL32_MIN_HS_PREPARE_NUI_SHIFT    2
> +#define OV3640_MIPI_CTRL32_MIN_HS_PREPARE_NUI_MASK     (0x3F << \
> +                               OV3640_MIPI_CTRL32_MIN_HS_PREPARE_NUI_SHIFT)
> +#define OV3640_MIPI_CTRL32_MIN_HS_PREPARE_H_MASK       0x3
> +
> +#define OV3640_MIPI_CTRL33                     0x3633
> +#define OV3640_MIPI_CTRL33_MIN_HS_PREPARE_L_MASK       0xFF
> +
> +#define OV3640_MIPI_CTRL34                     0x3634
> +#define OV3640_MIPI_CTRL34_MAX_HS_PREPARE_NUI_SHIFT    2
> +#define OV3640_MIPI_CTRL34_MAX_HS_PREPARE_NUI_MASK     (0x3F << \
> +                               OV3640_MIPI_CTRL34_MAX_HS_PREPARE_NUI_SHIFT)
> +#define OV3640_MIPI_CTRL34_MAX_HS_PREPARE_H_MASK       0x3
> +
> +#define OV3640_MIPI_CTRL35                     0x3635
> +#define OV3640_MIPI_CTRL35_MAX_HS_PREPARE_L_MASK       0xFF
> +
> +#define OV3640_MIPI_CTRL36                     0x3636
> +#define OV3640_MIPI_CTRL36_MIN_HS_EXIT_NUI_SHIFT       2
> +#define OV3640_MIPI_CTRL36_MIN_HS_EXIT_NUI_MASK        (0x3F << \
> +                               OV3640_MIPI_CTRL36_MIN_HS_EXIT_NUI_SHIFT)
> +#define OV3640_MIPI_CTRL36_MIN_HS_EXIT_H_MASK  0x3
> +
> +#define OV3640_MIPI_CTRL37                     0x3637
> +#define OV3640_MIPI_CTRL37_MIN_HS_EXIT_L_MASK  0xFF
> +
> +#define OV3640_OUT_CTRL3C                      0x363C
> +#define OV3640_MIPI_CTRL3D                     0x363D
> +#define OV3640_MIPI_CTRL3D_JPGPADEN            (1 << 6)
> +#define OV3640_OUT_CTRL3E                      0x363E
> +#define OV3640_OUT_CTRL3F                      0x363F
> +
> +#define OV3640_OUT_CTRL40                      0x3640
> +#define OV3640_OUT_CTRL43                      0x3643
> +#define OV3640_OUT_CTRL44                      0x3644
> +#define OV3640_OUT_CTRL46                      0x3646
> +#define OV3640_MIPI_CTRL4C                     0x364C
> +#define OV3640_MIPI_CTRL4C_ECC_PHBYTEORDER2    (1 << 2)
> +/*
> + * END - OUT_TOP Registers
> + */
> +/*
> + * MC Registers
> + */
> +#define OV3640_INTR_MASK0                      0x3700
> +#define OV3640_INTR_MASK1                      0x3701
> +#define OV3640_INTR0                           0x3708
> +#define OV3640_INTR1                           0x3709
> +/*
> + * END - MC Registers
> + */
> +
> +#endif /* ifndef OV3640_REGS_H */
> +
> +
> diff --git a/include/media/ov3640.h b/include/media/ov3640.h
> new file mode 100644
> index 0000000..a26009e
> --- /dev/null
> +++ b/include/media/ov3640.h
> @@ -0,0 +1,31 @@
> +/*
> + * include/media/ov3640.h
> + *
> + * Shared settings for the OV3640 CameraChip.
> + *
> + * Contributors:
> + *   Pallavi Kulkarni <p-kulkarni@ti.com>
> + *   Sergio Aguirre <saaguirre@ti.com>
> + *
> + * Copyright (C) 2009 Texas Instruments.
> + *
> + * This file is licensed under the terms of the GNU General Public License
> + * version 2. This program is licensed "as is" without any warranty of any
> + * kind, whether express or implied.
> + */
> +
> +#ifndef OV3640_H
> +#define OV3640_H
> +
> +#define OV3640_I2C_ADDR                (0x78 >> 1)
> +
> +struct ov3640_platform_data {
> +       /* Set power state, zero is off, non-zero is on. */
> +       int (*power_set)(enum v4l2_power power);
> +       u32 (*set_xclk)(u32 xclkfreq);
> +       int (*priv_data_set)(void *);
> +};
> +
> +#endif /* ifndef OV3640_H */
> +
> +
> --
> 1.5.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Best regards, Klimov Alexey

