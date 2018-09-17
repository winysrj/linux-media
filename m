Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:30601 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727660AbeIQRBO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 13:01:14 -0400
Date: Mon, 17 Sep 2018 14:34:14 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: bingbu.cao@intel.com
Cc: linux-media@vger.kernel.org, tfiga@google.com,
        rajmohan.mani@intel.com, bingbu.cao@linux.intel.com,
        tian.shu.qiu@intel.com, jian.xu.zheng@intel.com
Subject: Re: [PATCH v5] media: add imx319 camera sensor driver
Message-ID: <20180917113413.n6hd5suldwuspio3@paasikivi.fi.intel.com>
References: <1537163872-14567-1-git-send-email-bingbu.cao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1537163872-14567-1-git-send-email-bingbu.cao@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bingbu,

Thanks for the update! A few more small comments, I think we're done after
these.

On Mon, Sep 17, 2018 at 01:57:52PM +0800, bingbu.cao@intel.com wrote:
> From: Bingbu Cao <bingbu.cao@intel.com>
> 
> Add a v4l2 sub-device driver for the Sony imx319 image sensor.
> This is a camera sensor using the i2c bus for control and the
> csi-2 bus for data.
> 
> This driver supports following features:
> - manual exposure and analog/digital gain control support
> - vblank/hblank control support
> -  4 test patterns control support
> - vflip/hflip control support (will impact the output bayer order)
> - support following resolutions:
>     - 3264x2448, 3280x2464 @ 30fps
>     - 1936x1096, 1920x1080 @ 60fps
>     - 1640x1232, 1640x922, 1296x736, 1280x720 @ 120fps
> - support 4 bayer orders output (via change v/hflip)
>     - SRGGB10(default), SGRBG10, SGBRG10, SBGGR10
> 
> Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
> Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
> 
> ---
> 
> This patch is based on sakari's media-tree git:
> https://git.linuxtv.org/sailus/media_tree.git/log/?h=for-4.20-1
> 
> Changes from v4 to v5:
>  - use single PLL for all internal clocks
>  - change link frequency to 482.4MHz
>  - adjust frame timing for 2x2 binning modes
>    and enlarge frame readout time
>  - get CSI-2 link frequencies and external clock
>    from firmware
>  - use unlocked __v4l2_ctrl_grab() with change from:
>    https://git.linuxtv.org/sailus/media_tree.git/commit/?h=unlocked-ctrl-grab
> 
> Changes since v1:
>  - fix some coding style issues - line breaks
>  - add v4l2_ctrl_grab() to prevent v/hflip change
>    during streaming
>  - add v4l2 ctrl event (un)subscribe support
>  - add more info into commit message
> 
> ---
> ---
>  MAINTAINERS                |    7 +
>  drivers/media/i2c/Kconfig  |   11 +
>  drivers/media/i2c/Makefile |    1 +
>  drivers/media/i2c/imx319.c | 2524 ++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 2543 insertions(+)
>  create mode 100644 drivers/media/i2c/imx319.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a5b256b25905..abc4abb6f83c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13530,6 +13530,13 @@ S:	Maintained
>  F:	drivers/media/i2c/imx274.c
>  F:	Documentation/devicetree/bindings/media/i2c/imx274.txt
>  
> +SONY IMX319 SENSOR DRIVER
> +M:	Bingbu Cao <bingbu.cao@intel.com>
> +L:	linux-media@vger.kernel.org
> +T:	git git://linuxtv.org/media_tree.git
> +S:	Maintained
> +F:	drivers/media/i2c/imx319.c
> +
>  SONY MEMORYSTICK CARD SUPPORT
>  M:	Alex Dubov <oakad@yahoo.com>
>  W:	http://tifmxx.berlios.de/
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index bfdb494686bf..603ac087975b 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -614,6 +614,17 @@ config VIDEO_IMX274
>  	  This is a V4L2 sensor driver for the Sony IMX274
>  	  CMOS image sensor.
>  
> +config VIDEO_IMX319
> +	tristate "Sony IMX319 sensor support"
> +	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> +	depends on MEDIA_CAMERA_SUPPORT
> +	help
> +	  This is a Video4Linux2 sensor driver for the Sony
> +	  IMX319 camera.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called imx319.
> +
>  config VIDEO_OV2640
>  	tristate "OmniVision OV2640 sensor support"
>  	depends on VIDEO_V4L2 && I2C
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> index a94eb03d10d4..d10b438577be 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -108,5 +108,6 @@ obj-$(CONFIG_VIDEO_OV2659)	+= ov2659.o
>  obj-$(CONFIG_VIDEO_TC358743)	+= tc358743.o
>  obj-$(CONFIG_VIDEO_IMX258)	+= imx258.o
>  obj-$(CONFIG_VIDEO_IMX274)	+= imx274.o
> +obj-$(CONFIG_VIDEO_IMX319)	+= imx319.o
>  
>  obj-$(CONFIG_SDR_MAX2175) += max2175.o
> diff --git a/drivers/media/i2c/imx319.c b/drivers/media/i2c/imx319.c
> new file mode 100644
> index 000000000000..43c28c701431
> --- /dev/null
> +++ b/drivers/media/i2c/imx319.c
> @@ -0,0 +1,2524 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2018 Intel Corporation
> +
> +#include <asm/unaligned.h>
> +#include <linux/acpi.h>
> +#include <linux/i2c.h>
> +#include <linux/module.h>
> +#include <linux/pm_runtime.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-fwnode.h>
> +
> +#define IMX319_REG_MODE_SELECT		0x0100
> +#define IMX319_MODE_STANDBY		0x00
> +#define IMX319_MODE_STREAMING		0x01
> +
> +/* Chip ID */
> +#define IMX319_REG_CHIP_ID		0x0016
> +#define IMX319_CHIP_ID			0x0319
> +
> +/* V_TIMING internal */
> +#define IMX319_REG_FLL			0x0340
> +#define IMX319_FLL_MAX			0xffff
> +
> +/* Exposure control */
> +#define IMX319_REG_EXPOSURE		0x0202
> +#define IMX319_EXPOSURE_MIN		1
> +#define IMX319_EXPOSURE_STEP		1
> +#define IMX319_EXPOSURE_DEFAULT		0x04f6
> +
> +/* Analog gain control */
> +#define IMX319_REG_ANALOG_GAIN		0x0204
> +#define IMX319_ANA_GAIN_MIN		0
> +#define IMX319_ANA_GAIN_MAX		960
> +#define IMX319_ANA_GAIN_STEP		1
> +#define IMX319_ANA_GAIN_DEFAULT		0
> +
> +/* Digital gain control */
> +#define IMX319_REG_DPGA_USE_GLOBAL_GAIN	0x3ff9
> +#define IMX319_REG_DIG_GAIN_GLOBAL	0x020e
> +#define IMX319_DGTL_GAIN_MIN		256
> +#define IMX319_DGTL_GAIN_MAX		4095
> +#define IMX319_DGTL_GAIN_STEP		1
> +#define IMX319_DGTL_GAIN_DEFAULT	256
> +
> +/* Test Pattern Control */
> +#define IMX319_REG_TEST_PATTERN		0x0600
> +#define IMX319_TEST_PATTERN_DISABLED		0
> +#define IMX319_TEST_PATTERN_SOLID_COLOR		1
> +#define IMX319_TEST_PATTERN_COLOR_BARS		2
> +#define IMX319_TEST_PATTERN_GRAY_COLOR_BARS	3
> +#define IMX319_TEST_PATTERN_PN9			4
> +
> +/* Flip Control */
> +#define IMX319_REG_ORIENTATION		0x0101
> +
> +/* default link frequency and external clock */
> +#define IMX319_LINK_FREQ_DEFAULT	482400000
> +#define IMX319_EXT_CLK			19200000
> +
> +struct imx319_reg {
> +	u16 address;
> +	u8 val;
> +};
> +
> +struct imx319_reg_list {
> +	u32 num_of_regs;
> +	const struct imx319_reg *regs;
> +};
> +
> +/* Mode : resolution and related config&values */
> +struct imx319_mode {
> +	/* Frame width */
> +	u32 width;
> +	/* Frame height */
> +	u32 height;
> +
> +	/* V-timing */
> +	u32 fll_def;
> +	u32 fll_min;
> +
> +	/* H-timing */
> +	u32 llp;
> +
> +	/* Default register values */
> +	struct imx319_reg_list reg_list;
> +};
> +
> +struct imx319_pdata {

Could you rename this e.g. as imx319_hwcfg as this is not platform data?

> +	u32 ext_clk;		/* sensor external clk */
> +	s64 *link_freqs;	/* CSI-2 link frequencies */
> +};
> +
> +struct imx319 {
> +	struct v4l2_subdev sd;
> +	struct media_pad pad;
> +
> +	struct v4l2_ctrl_handler ctrl_handler;
> +	/* V4L2 Controls */
> +	struct v4l2_ctrl *link_freq;
> +	struct v4l2_ctrl *pixel_rate;
> +	struct v4l2_ctrl *vblank;
> +	struct v4l2_ctrl *hblank;
> +	struct v4l2_ctrl *exposure;
> +	struct v4l2_ctrl *vflip;
> +	struct v4l2_ctrl *hflip;
> +
> +	/* Current mode */
> +	const struct imx319_mode *cur_mode;
> +
> +	struct imx319_pdata *pdata;
> +	s64 link_def_freq;	/* CSI-2 link default frequency */
> +
> +	/*
> +	 * Mutex for serialized access:
> +	 * Protect sensor set pad format and start/stop streaming safely.
> +	 * Protect access to sensor v4l2 controls.
> +	 */
> +	struct mutex mutex;
> +
> +	/* Streaming on/off */
> +	bool streaming;
> +};
> +
> +static const struct imx319_reg imx319_global_regs[] = {
> +	{ 0x0136, 0x13 },
> +	{ 0x0137, 0x33 },
> +	{ 0x3c7e, 0x05 },
> +	{ 0x3c7f, 0x07 },
> +	{ 0x4d39, 0x0b },
> +	{ 0x4d41, 0x33 },
> +	{ 0x4d43, 0x0c },
> +	{ 0x4d49, 0x89 },
> +	{ 0x4e05, 0x0b },
> +	{ 0x4e0d, 0x33 },
> +	{ 0x4e0f, 0x0c },
> +	{ 0x4e15, 0x89 },
> +	{ 0x4e49, 0x2a },
> +	{ 0x4e51, 0x33 },
> +	{ 0x4e53, 0x0c },
> +	{ 0x4e59, 0x89 },
> +	{ 0x5601, 0x4f },
> +	{ 0x560b, 0x45 },
> +	{ 0x562f, 0x0a },
> +	{ 0x5643, 0x0a },
> +	{ 0x5645, 0x0c },
> +	{ 0x56ef, 0x51 },
> +	{ 0x586f, 0x33 },
> +	{ 0x5873, 0x89 },
> +	{ 0x5905, 0x33 },
> +	{ 0x5907, 0x89 },
> +	{ 0x590d, 0x33 },
> +	{ 0x590f, 0x89 },
> +	{ 0x5915, 0x33 },
> +	{ 0x5917, 0x89 },
> +	{ 0x5969, 0x1c },
> +	{ 0x596b, 0x72 },
> +	{ 0x5971, 0x33 },
> +	{ 0x5973, 0x89 },
> +	{ 0x5975, 0x33 },
> +	{ 0x5977, 0x89 },
> +	{ 0x5979, 0x1c },
> +	{ 0x597b, 0x72 },
> +	{ 0x5985, 0x33 },
> +	{ 0x5987, 0x89 },
> +	{ 0x5999, 0x1c },
> +	{ 0x599b, 0x72 },
> +	{ 0x59a5, 0x33 },
> +	{ 0x59a7, 0x89 },
> +	{ 0x7485, 0x08 },
> +	{ 0x7487, 0x0c },
> +	{ 0x7489, 0xc7 },
> +	{ 0x748b, 0x8b },
> +	{ 0x9004, 0x09 },
> +	{ 0x9200, 0x6a },
> +	{ 0x9201, 0x22 },
> +	{ 0x9202, 0x6a },
> +	{ 0x9203, 0x23 },
> +	{ 0x9204, 0x5f },
> +	{ 0x9205, 0x23 },
> +	{ 0x9206, 0x5f },
> +	{ 0x9207, 0x24 },
> +	{ 0x9208, 0x5f },
> +	{ 0x9209, 0x26 },
> +	{ 0x920a, 0x5f },
> +	{ 0x920b, 0x27 },
> +	{ 0x920c, 0x5f },
> +	{ 0x920d, 0x29 },
> +	{ 0x920e, 0x5f },
> +	{ 0x920f, 0x2a },
> +	{ 0x9210, 0x5f },
> +	{ 0x9211, 0x2c },
> +	{ 0xbc22, 0x1a },
> +	{ 0xf01f, 0x04 },
> +	{ 0xf021, 0x03 },
> +	{ 0xf023, 0x02 },
> +	{ 0xf03d, 0x05 },
> +	{ 0xf03f, 0x03 },
> +	{ 0xf041, 0x02 },
> +	{ 0xf0af, 0x04 },
> +	{ 0xf0b1, 0x03 },
> +	{ 0xf0b3, 0x02 },
> +	{ 0xf0cd, 0x05 },
> +	{ 0xf0cf, 0x03 },
> +	{ 0xf0d1, 0x02 },
> +	{ 0xf13f, 0x04 },
> +	{ 0xf141, 0x03 },
> +	{ 0xf143, 0x02 },
> +	{ 0xf15d, 0x05 },
> +	{ 0xf15f, 0x03 },
> +	{ 0xf161, 0x02 },
> +	{ 0xf1cf, 0x04 },
> +	{ 0xf1d1, 0x03 },
> +	{ 0xf1d3, 0x02 },
> +	{ 0xf1ed, 0x05 },
> +	{ 0xf1ef, 0x03 },
> +	{ 0xf1f1, 0x02 },
> +	{ 0xf287, 0x04 },
> +	{ 0xf289, 0x03 },
> +	{ 0xf28b, 0x02 },
> +	{ 0xf2a5, 0x05 },
> +	{ 0xf2a7, 0x03 },
> +	{ 0xf2a9, 0x02 },
> +	{ 0xf2b7, 0x04 },
> +	{ 0xf2b9, 0x03 },
> +	{ 0xf2bb, 0x02 },
> +	{ 0xf2d5, 0x05 },
> +	{ 0xf2d7, 0x03 },
> +	{ 0xf2d9, 0x02 },
> +};
> +
> +static const struct imx319_reg_list imx319_global_setting = {
> +	.num_of_regs = ARRAY_SIZE(imx319_global_regs),
> +	.regs = imx319_global_regs,
> +};
> +
> +static const struct imx319_reg mode_3264x2448_regs[] = {
> +	{ 0x0112, 0x0a },
> +	{ 0x0113, 0x0a },
> +	{ 0x0114, 0x03 },
> +	{ 0x0342, 0x0f },
> +	{ 0x0343, 0x80 },
> +	{ 0x0340, 0x0c },
> +	{ 0x0341, 0xaa },
> +	{ 0x0344, 0x00 },
> +	{ 0x0345, 0x00 },
> +	{ 0x0346, 0x00 },
> +	{ 0x0347, 0x00 },
> +	{ 0x0348, 0x0c },
> +	{ 0x0349, 0xcf },
> +	{ 0x034a, 0x09 },
> +	{ 0x034b, 0x9f },
> +	{ 0x0220, 0x00 },
> +	{ 0x0221, 0x11 },
> +	{ 0x0381, 0x01 },
> +	{ 0x0383, 0x01 },
> +	{ 0x0385, 0x01 },
> +	{ 0x0387, 0x01 },
> +	{ 0x0900, 0x00 },
> +	{ 0x0901, 0x11 },
> +	{ 0x0902, 0x0a },
> +	{ 0x3140, 0x02 },
> +	{ 0x3141, 0x00 },
> +	{ 0x3f0d, 0x0a },
> +	{ 0x3f14, 0x01 },
> +	{ 0x3f3c, 0x01 },
> +	{ 0x3f4d, 0x01 },
> +	{ 0x3f4c, 0x01 },
> +	{ 0x4254, 0x7f },
> +	{ 0x0401, 0x00 },
> +	{ 0x0404, 0x00 },
> +	{ 0x0405, 0x10 },
> +	{ 0x0408, 0x00 },
> +	{ 0x0409, 0x08 },
> +	{ 0x040a, 0x00 },
> +	{ 0x040b, 0x08 },
> +	{ 0x040c, 0x0c },
> +	{ 0x040d, 0xc0 },
> +	{ 0x040e, 0x09 },
> +	{ 0x040f, 0x90 },
> +	{ 0x034c, 0x0c },
> +	{ 0x034d, 0xc0 },
> +	{ 0x034e, 0x09 },
> +	{ 0x034f, 0x90 },
> +	{ 0x3261, 0x00 },
> +	{ 0x3264, 0x00 },
> +	{ 0x3265, 0x10 },
> +	{ 0x0301, 0x05 },
> +	{ 0x0303, 0x04 },
> +	{ 0x0305, 0x04 },
> +	{ 0x0306, 0x01 },
> +	{ 0x0307, 0x92 },
> +	{ 0x0309, 0x0a },
> +	{ 0x030b, 0x02 },
> +	{ 0x030d, 0x02 },
> +	{ 0x030e, 0x00 },
> +	{ 0x030f, 0xfa },
> +	{ 0x0310, 0x00 },
> +	{ 0x0820, 0x0f },
> +	{ 0x0821, 0x13 },
> +	{ 0x0822, 0x33 },
> +	{ 0x0823, 0x33 },
> +	{ 0x3e20, 0x01 },
> +	{ 0x3e37, 0x00 },
> +	{ 0x3e3b, 0x01 },
> +	{ 0x38a3, 0x01 },
> +	{ 0x38a8, 0x00 },
> +	{ 0x38a9, 0x00 },
> +	{ 0x38aa, 0x00 },
> +	{ 0x38ab, 0x00 },
> +	{ 0x3234, 0x00 },
> +	{ 0x3fc1, 0x00 },
> +	{ 0x3235, 0x00 },
> +	{ 0x3802, 0x00 },
> +	{ 0x3143, 0x04 },
> +	{ 0x360a, 0x00 },
> +	{ 0x0b00, 0x00 },
> +	{ 0x0106, 0x00 },
> +	{ 0x0b05, 0x01 },
> +	{ 0x0b06, 0x01 },
> +	{ 0x3230, 0x00 },
> +	{ 0x3602, 0x01 },
> +	{ 0x3607, 0x01 },
> +	{ 0x3c00, 0x00 },
> +	{ 0x3c01, 0x48 },
> +	{ 0x3c02, 0xc8 },
> +	{ 0x3c03, 0xaa },
> +	{ 0x3c04, 0x91 },
> +	{ 0x3c05, 0x54 },
> +	{ 0x3c06, 0x26 },
> +	{ 0x3c07, 0x20 },
> +	{ 0x3c08, 0x51 },
> +	{ 0x3d80, 0x00 },
> +	{ 0x3f50, 0x00 },
> +	{ 0x3f56, 0x00 },
> +	{ 0x3f57, 0x30 },
> +	{ 0x3f78, 0x01 },
> +	{ 0x3f79, 0x18 },
> +	{ 0x3f7c, 0x00 },
> +	{ 0x3f7d, 0x00 },
> +	{ 0x3fba, 0x00 },
> +	{ 0x3fbb, 0x00 },
> +	{ 0xa081, 0x00 },
> +	{ 0xe014, 0x00 },
> +	{ 0x0202, 0x0a },
> +	{ 0x0203, 0x7a },
> +	{ 0x0224, 0x01 },
> +	{ 0x0225, 0xf4 },
> +	{ 0x0204, 0x00 },
> +	{ 0x0205, 0x00 },
> +	{ 0x0216, 0x00 },
> +	{ 0x0217, 0x00 },
> +	{ 0x020e, 0x01 },
> +	{ 0x020f, 0x00 },
> +	{ 0x0210, 0x01 },
> +	{ 0x0211, 0x00 },
> +	{ 0x0212, 0x01 },
> +	{ 0x0213, 0x00 },
> +	{ 0x0214, 0x01 },
> +	{ 0x0215, 0x00 },
> +	{ 0x0218, 0x01 },
> +	{ 0x0219, 0x00 },
> +	{ 0x3614, 0x00 },
> +	{ 0x3616, 0x0d },
> +	{ 0x3617, 0x56 },
> +	{ 0xb612, 0x20 },
> +	{ 0xb613, 0x20 },
> +	{ 0xb614, 0x20 },
> +	{ 0xb615, 0x20 },
> +	{ 0xb616, 0x0a },
> +	{ 0xb617, 0x0a },
> +	{ 0xb618, 0x20 },
> +	{ 0xb619, 0x20 },
> +	{ 0xb61a, 0x20 },
> +	{ 0xb61b, 0x20 },
> +	{ 0xb61c, 0x0a },
> +	{ 0xb61d, 0x0a },
> +	{ 0xb666, 0x30 },
> +	{ 0xb667, 0x30 },
> +	{ 0xb668, 0x30 },
> +	{ 0xb669, 0x30 },
> +	{ 0xb66a, 0x14 },
> +	{ 0xb66b, 0x14 },
> +	{ 0xb66c, 0x20 },
> +	{ 0xb66d, 0x20 },
> +	{ 0xb66e, 0x20 },
> +	{ 0xb66f, 0x20 },
> +	{ 0xb670, 0x10 },
> +	{ 0xb671, 0x10 },
> +	{ 0x3237, 0x00 },
> +	{ 0x3900, 0x00 },
> +	{ 0x3901, 0x00 },
> +	{ 0x3902, 0x00 },
> +	{ 0x3904, 0x00 },
> +	{ 0x3905, 0x00 },
> +	{ 0x3906, 0x00 },
> +	{ 0x3907, 0x00 },
> +	{ 0x3908, 0x00 },
> +	{ 0x3909, 0x00 },
> +	{ 0x3912, 0x00 },
> +	{ 0x3930, 0x00 },
> +	{ 0x3931, 0x00 },
> +	{ 0x3933, 0x00 },
> +	{ 0x3934, 0x00 },
> +	{ 0x3935, 0x00 },
> +	{ 0x3936, 0x00 },
> +	{ 0x3937, 0x00 },
> +	{ 0x30ac, 0x00 },
> +};
> +
> +static const struct imx319_reg mode_3280x2464_regs[] = {
> +	{ 0x0112, 0x0a },
> +	{ 0x0113, 0x0a },
> +	{ 0x0114, 0x03 },
> +	{ 0x0342, 0x0f },
> +	{ 0x0343, 0x80 },
> +	{ 0x0340, 0x0c },
> +	{ 0x0341, 0xaa },
> +	{ 0x0344, 0x00 },
> +	{ 0x0345, 0x00 },
> +	{ 0x0346, 0x00 },
> +	{ 0x0347, 0x00 },
> +	{ 0x0348, 0x0c },
> +	{ 0x0349, 0xcf },
> +	{ 0x034a, 0x09 },
> +	{ 0x034b, 0x9f },
> +	{ 0x0220, 0x00 },
> +	{ 0x0221, 0x11 },
> +	{ 0x0381, 0x01 },
> +	{ 0x0383, 0x01 },
> +	{ 0x0385, 0x01 },
> +	{ 0x0387, 0x01 },
> +	{ 0x0900, 0x00 },
> +	{ 0x0901, 0x11 },
> +	{ 0x0902, 0x0a },
> +	{ 0x3140, 0x02 },
> +	{ 0x3141, 0x00 },
> +	{ 0x3f0d, 0x0a },
> +	{ 0x3f14, 0x01 },
> +	{ 0x3f3c, 0x01 },
> +	{ 0x3f4d, 0x01 },
> +	{ 0x3f4c, 0x01 },
> +	{ 0x4254, 0x7f },
> +	{ 0x0401, 0x00 },
> +	{ 0x0404, 0x00 },
> +	{ 0x0405, 0x10 },
> +	{ 0x0408, 0x00 },
> +	{ 0x0409, 0x00 },
> +	{ 0x040a, 0x00 },
> +	{ 0x040b, 0x00 },
> +	{ 0x040c, 0x0c },
> +	{ 0x040d, 0xd0 },
> +	{ 0x040e, 0x09 },
> +	{ 0x040f, 0xa0 },
> +	{ 0x034c, 0x0c },
> +	{ 0x034d, 0xd0 },
> +	{ 0x034e, 0x09 },
> +	{ 0x034f, 0xa0 },
> +	{ 0x3261, 0x00 },
> +	{ 0x3264, 0x00 },
> +	{ 0x3265, 0x10 },
> +	{ 0x0301, 0x05 },
> +	{ 0x0303, 0x04 },
> +	{ 0x0305, 0x04 },
> +	{ 0x0306, 0x01 },
> +	{ 0x0307, 0x92 },
> +	{ 0x0309, 0x0a },
> +	{ 0x030b, 0x02 },
> +	{ 0x030d, 0x02 },
> +	{ 0x030e, 0x00 },
> +	{ 0x030f, 0xfa },
> +	{ 0x0310, 0x00 },
> +	{ 0x0820, 0x0f },
> +	{ 0x0821, 0x13 },
> +	{ 0x0822, 0x33 },
> +	{ 0x0823, 0x33 },
> +	{ 0x3e20, 0x01 },
> +	{ 0x3e37, 0x00 },
> +	{ 0x3e3b, 0x01 },
> +	{ 0x38a3, 0x01 },
> +	{ 0x38a8, 0x00 },
> +	{ 0x38a9, 0x00 },
> +	{ 0x38aa, 0x00 },
> +	{ 0x38ab, 0x00 },
> +	{ 0x3234, 0x00 },
> +	{ 0x3fc1, 0x00 },
> +	{ 0x3235, 0x00 },
> +	{ 0x3802, 0x00 },
> +	{ 0x3143, 0x04 },
> +	{ 0x360a, 0x00 },
> +	{ 0x0b00, 0x00 },
> +	{ 0x0106, 0x00 },
> +	{ 0x0b05, 0x01 },
> +	{ 0x0b06, 0x01 },
> +	{ 0x3230, 0x00 },
> +	{ 0x3602, 0x01 },
> +	{ 0x3607, 0x01 },
> +	{ 0x3c00, 0x00 },
> +	{ 0x3c01, 0x48 },
> +	{ 0x3c02, 0xc8 },
> +	{ 0x3c03, 0xaa },
> +	{ 0x3c04, 0x91 },
> +	{ 0x3c05, 0x54 },
> +	{ 0x3c06, 0x26 },
> +	{ 0x3c07, 0x20 },
> +	{ 0x3c08, 0x51 },
> +	{ 0x3d80, 0x00 },
> +	{ 0x3f50, 0x00 },
> +	{ 0x3f56, 0x00 },
> +	{ 0x3f57, 0x30 },
> +	{ 0x3f78, 0x01 },
> +	{ 0x3f79, 0x18 },
> +	{ 0x3f7c, 0x00 },
> +	{ 0x3f7d, 0x00 },
> +	{ 0x3fba, 0x00 },
> +	{ 0x3fbb, 0x00 },
> +	{ 0xa081, 0x00 },
> +	{ 0xe014, 0x00 },
> +	{ 0x0202, 0x0a },
> +	{ 0x0203, 0x7a },
> +	{ 0x0224, 0x01 },
> +	{ 0x0225, 0xf4 },
> +	{ 0x0204, 0x00 },
> +	{ 0x0205, 0x00 },
> +	{ 0x0216, 0x00 },
> +	{ 0x0217, 0x00 },
> +	{ 0x020e, 0x01 },
> +	{ 0x020f, 0x00 },
> +	{ 0x0210, 0x01 },
> +	{ 0x0211, 0x00 },
> +	{ 0x0212, 0x01 },
> +	{ 0x0213, 0x00 },
> +	{ 0x0214, 0x01 },
> +	{ 0x0215, 0x00 },
> +	{ 0x0218, 0x01 },
> +	{ 0x0219, 0x00 },
> +	{ 0x3614, 0x00 },
> +	{ 0x3616, 0x0d },
> +	{ 0x3617, 0x56 },
> +	{ 0xb612, 0x20 },
> +	{ 0xb613, 0x20 },
> +	{ 0xb614, 0x20 },
> +	{ 0xb615, 0x20 },
> +	{ 0xb616, 0x0a },
> +	{ 0xb617, 0x0a },
> +	{ 0xb618, 0x20 },
> +	{ 0xb619, 0x20 },
> +	{ 0xb61a, 0x20 },
> +	{ 0xb61b, 0x20 },
> +	{ 0xb61c, 0x0a },
> +	{ 0xb61d, 0x0a },
> +	{ 0xb666, 0x30 },
> +	{ 0xb667, 0x30 },
> +	{ 0xb668, 0x30 },
> +	{ 0xb669, 0x30 },
> +	{ 0xb66a, 0x14 },
> +	{ 0xb66b, 0x14 },
> +	{ 0xb66c, 0x20 },
> +	{ 0xb66d, 0x20 },
> +	{ 0xb66e, 0x20 },
> +	{ 0xb66f, 0x20 },
> +	{ 0xb670, 0x10 },
> +	{ 0xb671, 0x10 },
> +	{ 0x3237, 0x00 },
> +	{ 0x3900, 0x00 },
> +	{ 0x3901, 0x00 },
> +	{ 0x3902, 0x00 },
> +	{ 0x3904, 0x00 },
> +	{ 0x3905, 0x00 },
> +	{ 0x3906, 0x00 },
> +	{ 0x3907, 0x00 },
> +	{ 0x3908, 0x00 },
> +	{ 0x3909, 0x00 },
> +	{ 0x3912, 0x00 },
> +	{ 0x3930, 0x00 },
> +	{ 0x3931, 0x00 },
> +	{ 0x3933, 0x00 },
> +	{ 0x3934, 0x00 },
> +	{ 0x3935, 0x00 },
> +	{ 0x3936, 0x00 },
> +	{ 0x3937, 0x00 },
> +	{ 0x30ac, 0x00 },
> +};
> +
> +static const struct imx319_reg mode_1936x1096_regs[] = {
> +	{ 0x0112, 0x0a },
> +	{ 0x0113, 0x0a },
> +	{ 0x0114, 0x03 },
> +	{ 0x0342, 0x0f },
> +	{ 0x0343, 0x80 },
> +	{ 0x0340, 0x0c },
> +	{ 0x0341, 0xaa },
> +	{ 0x0344, 0x00 },
> +	{ 0x0345, 0x00 },
> +	{ 0x0346, 0x02 },
> +	{ 0x0347, 0xac },
> +	{ 0x0348, 0x0c },
> +	{ 0x0349, 0xcf },
> +	{ 0x034a, 0x06 },
> +	{ 0x034b, 0xf3 },
> +	{ 0x0220, 0x00 },
> +	{ 0x0221, 0x11 },
> +	{ 0x0381, 0x01 },
> +	{ 0x0383, 0x01 },
> +	{ 0x0385, 0x01 },
> +	{ 0x0387, 0x01 },
> +	{ 0x0900, 0x00 },
> +	{ 0x0901, 0x11 },
> +	{ 0x0902, 0x0a },
> +	{ 0x3140, 0x02 },
> +	{ 0x3141, 0x00 },
> +	{ 0x3f0d, 0x0a },
> +	{ 0x3f14, 0x01 },
> +	{ 0x3f3c, 0x01 },
> +	{ 0x3f4d, 0x01 },
> +	{ 0x3f4c, 0x01 },
> +	{ 0x4254, 0x7f },
> +	{ 0x0401, 0x00 },
> +	{ 0x0404, 0x00 },
> +	{ 0x0405, 0x10 },
> +	{ 0x0408, 0x02 },
> +	{ 0x0409, 0xa0 },
> +	{ 0x040a, 0x00 },
> +	{ 0x040b, 0x00 },
> +	{ 0x040c, 0x07 },
> +	{ 0x040d, 0x90 },
> +	{ 0x040e, 0x04 },
> +	{ 0x040f, 0x48 },
> +	{ 0x034c, 0x07 },
> +	{ 0x034d, 0x90 },
> +	{ 0x034e, 0x04 },
> +	{ 0x034f, 0x48 },
> +	{ 0x3261, 0x00 },
> +	{ 0x3264, 0x00 },
> +	{ 0x3265, 0x10 },
> +	{ 0x0301, 0x05 },
> +	{ 0x0303, 0x04 },
> +	{ 0x0305, 0x04 },
> +	{ 0x0306, 0x01 },
> +	{ 0x0307, 0x92 },
> +	{ 0x0309, 0x0a },
> +	{ 0x030b, 0x02 },
> +	{ 0x030d, 0x02 },
> +	{ 0x030e, 0x00 },
> +	{ 0x030f, 0xfa },
> +	{ 0x0310, 0x00 },
> +	{ 0x0820, 0x0f },
> +	{ 0x0821, 0x13 },
> +	{ 0x0822, 0x33 },
> +	{ 0x0823, 0x33 },
> +	{ 0x3e20, 0x01 },
> +	{ 0x3e37, 0x00 },
> +	{ 0x3e3b, 0x01 },
> +	{ 0x38a3, 0x01 },
> +	{ 0x38a8, 0x00 },
> +	{ 0x38a9, 0x00 },
> +	{ 0x38aa, 0x00 },
> +	{ 0x38ab, 0x00 },
> +	{ 0x3234, 0x00 },
> +	{ 0x3fc1, 0x00 },
> +	{ 0x3235, 0x00 },
> +	{ 0x3802, 0x00 },
> +	{ 0x3143, 0x04 },
> +	{ 0x360a, 0x00 },
> +	{ 0x0b00, 0x00 },
> +	{ 0x0106, 0x00 },
> +	{ 0x0b05, 0x01 },
> +	{ 0x0b06, 0x01 },
> +	{ 0x3230, 0x00 },
> +	{ 0x3602, 0x01 },
> +	{ 0x3607, 0x01 },
> +	{ 0x3c00, 0x00 },
> +	{ 0x3c01, 0x48 },
> +	{ 0x3c02, 0xc8 },
> +	{ 0x3c03, 0xaa },
> +	{ 0x3c04, 0x91 },
> +	{ 0x3c05, 0x54 },
> +	{ 0x3c06, 0x26 },
> +	{ 0x3c07, 0x20 },
> +	{ 0x3c08, 0x51 },
> +	{ 0x3d80, 0x00 },
> +	{ 0x3f50, 0x00 },
> +	{ 0x3f56, 0x00 },
> +	{ 0x3f57, 0x30 },
> +	{ 0x3f78, 0x01 },
> +	{ 0x3f79, 0x18 },
> +	{ 0x3f7c, 0x00 },
> +	{ 0x3f7d, 0x00 },
> +	{ 0x3fba, 0x00 },
> +	{ 0x3fbb, 0x00 },
> +	{ 0xa081, 0x00 },
> +	{ 0xe014, 0x00 },
> +	{ 0x0202, 0x05 },
> +	{ 0x0203, 0x34 },
> +	{ 0x0224, 0x01 },
> +	{ 0x0225, 0xf4 },
> +	{ 0x0204, 0x00 },
> +	{ 0x0205, 0x00 },
> +	{ 0x0216, 0x00 },
> +	{ 0x0217, 0x00 },
> +	{ 0x020e, 0x01 },
> +	{ 0x020f, 0x00 },
> +	{ 0x0210, 0x01 },
> +	{ 0x0211, 0x00 },
> +	{ 0x0212, 0x01 },
> +	{ 0x0213, 0x00 },
> +	{ 0x0214, 0x01 },
> +	{ 0x0215, 0x00 },
> +	{ 0x0218, 0x01 },
> +	{ 0x0219, 0x00 },
> +	{ 0x3614, 0x00 },
> +	{ 0x3616, 0x0d },
> +	{ 0x3617, 0x56 },
> +	{ 0xb612, 0x20 },
> +	{ 0xb613, 0x20 },
> +	{ 0xb614, 0x20 },
> +	{ 0xb615, 0x20 },
> +	{ 0xb616, 0x0a },
> +	{ 0xb617, 0x0a },
> +	{ 0xb618, 0x20 },
> +	{ 0xb619, 0x20 },
> +	{ 0xb61a, 0x20 },
> +	{ 0xb61b, 0x20 },
> +	{ 0xb61c, 0x0a },
> +	{ 0xb61d, 0x0a },
> +	{ 0xb666, 0x30 },
> +	{ 0xb667, 0x30 },
> +	{ 0xb668, 0x30 },
> +	{ 0xb669, 0x30 },
> +	{ 0xb66a, 0x14 },
> +	{ 0xb66b, 0x14 },
> +	{ 0xb66c, 0x20 },
> +	{ 0xb66d, 0x20 },
> +	{ 0xb66e, 0x20 },
> +	{ 0xb66f, 0x20 },
> +	{ 0xb670, 0x10 },
> +	{ 0xb671, 0x10 },
> +	{ 0x3237, 0x00 },
> +	{ 0x3900, 0x00 },
> +	{ 0x3901, 0x00 },
> +	{ 0x3902, 0x00 },
> +	{ 0x3904, 0x00 },
> +	{ 0x3905, 0x00 },
> +	{ 0x3906, 0x00 },
> +	{ 0x3907, 0x00 },
> +	{ 0x3908, 0x00 },
> +	{ 0x3909, 0x00 },
> +	{ 0x3912, 0x00 },
> +	{ 0x3930, 0x00 },
> +	{ 0x3931, 0x00 },
> +	{ 0x3933, 0x00 },
> +	{ 0x3934, 0x00 },
> +	{ 0x3935, 0x00 },
> +	{ 0x3936, 0x00 },
> +	{ 0x3937, 0x00 },
> +	{ 0x30ac, 0x00 },
> +};
> +
> +static const struct imx319_reg mode_1920x1080_regs[] = {
> +	{ 0x0112, 0x0a },
> +	{ 0x0113, 0x0a },
> +	{ 0x0114, 0x03 },
> +	{ 0x0342, 0x0f },
> +	{ 0x0343, 0x80 },
> +	{ 0x0340, 0x0c },
> +	{ 0x0341, 0xaa },
> +	{ 0x0344, 0x00 },
> +	{ 0x0345, 0x00 },
> +	{ 0x0346, 0x02 },
> +	{ 0x0347, 0xb4 },
> +	{ 0x0348, 0x0c },
> +	{ 0x0349, 0xcf },
> +	{ 0x034a, 0x06 },
> +	{ 0x034b, 0xeb },
> +	{ 0x0220, 0x00 },
> +	{ 0x0221, 0x11 },
> +	{ 0x0381, 0x01 },
> +	{ 0x0383, 0x01 },
> +	{ 0x0385, 0x01 },
> +	{ 0x0387, 0x01 },
> +	{ 0x0900, 0x00 },
> +	{ 0x0901, 0x11 },
> +	{ 0x0902, 0x0a },
> +	{ 0x3140, 0x02 },
> +	{ 0x3141, 0x00 },
> +	{ 0x3f0d, 0x0a },
> +	{ 0x3f14, 0x01 },
> +	{ 0x3f3c, 0x01 },
> +	{ 0x3f4d, 0x01 },
> +	{ 0x3f4c, 0x01 },
> +	{ 0x4254, 0x7f },
> +	{ 0x0401, 0x00 },
> +	{ 0x0404, 0x00 },
> +	{ 0x0405, 0x10 },
> +	{ 0x0408, 0x02 },
> +	{ 0x0409, 0xa8 },
> +	{ 0x040a, 0x00 },
> +	{ 0x040b, 0x00 },
> +	{ 0x040c, 0x07 },
> +	{ 0x040d, 0x80 },
> +	{ 0x040e, 0x04 },
> +	{ 0x040f, 0x38 },
> +	{ 0x034c, 0x07 },
> +	{ 0x034d, 0x80 },
> +	{ 0x034e, 0x04 },
> +	{ 0x034f, 0x38 },
> +	{ 0x3261, 0x00 },
> +	{ 0x3264, 0x00 },
> +	{ 0x3265, 0x10 },
> +	{ 0x0301, 0x05 },
> +	{ 0x0303, 0x04 },
> +	{ 0x0305, 0x04 },
> +	{ 0x0306, 0x01 },
> +	{ 0x0307, 0x92 },
> +	{ 0x0309, 0x0a },
> +	{ 0x030b, 0x02 },
> +	{ 0x030d, 0x02 },
> +	{ 0x030e, 0x00 },
> +	{ 0x030f, 0xfa },
> +	{ 0x0310, 0x00 },
> +	{ 0x0820, 0x0f },
> +	{ 0x0821, 0x13 },
> +	{ 0x0822, 0x33 },
> +	{ 0x0823, 0x33 },
> +	{ 0x3e20, 0x01 },
> +	{ 0x3e37, 0x00 },
> +	{ 0x3e3b, 0x01 },
> +	{ 0x38a3, 0x01 },
> +	{ 0x38a8, 0x00 },
> +	{ 0x38a9, 0x00 },
> +	{ 0x38aa, 0x00 },
> +	{ 0x38ab, 0x00 },
> +	{ 0x3234, 0x00 },
> +	{ 0x3fc1, 0x00 },
> +	{ 0x3235, 0x00 },
> +	{ 0x3802, 0x00 },
> +	{ 0x3143, 0x04 },
> +	{ 0x360a, 0x00 },
> +	{ 0x0b00, 0x00 },
> +	{ 0x0106, 0x00 },
> +	{ 0x0b05, 0x01 },
> +	{ 0x0b06, 0x01 },
> +	{ 0x3230, 0x00 },
> +	{ 0x3602, 0x01 },
> +	{ 0x3607, 0x01 },
> +	{ 0x3c00, 0x00 },
> +	{ 0x3c01, 0x48 },
> +	{ 0x3c02, 0xc8 },
> +	{ 0x3c03, 0xaa },
> +	{ 0x3c04, 0x91 },
> +	{ 0x3c05, 0x54 },
> +	{ 0x3c06, 0x26 },
> +	{ 0x3c07, 0x20 },
> +	{ 0x3c08, 0x51 },
> +	{ 0x3d80, 0x00 },
> +	{ 0x3f50, 0x00 },
> +	{ 0x3f56, 0x00 },
> +	{ 0x3f57, 0x30 },
> +	{ 0x3f78, 0x01 },
> +	{ 0x3f79, 0x18 },
> +	{ 0x3f7c, 0x00 },
> +	{ 0x3f7d, 0x00 },
> +	{ 0x3fba, 0x00 },
> +	{ 0x3fbb, 0x00 },
> +	{ 0xa081, 0x00 },
> +	{ 0xe014, 0x00 },
> +	{ 0x0202, 0x05 },
> +	{ 0x0203, 0x34 },
> +	{ 0x0224, 0x01 },
> +	{ 0x0225, 0xf4 },
> +	{ 0x0204, 0x00 },
> +	{ 0x0205, 0x00 },
> +	{ 0x0216, 0x00 },
> +	{ 0x0217, 0x00 },
> +	{ 0x020e, 0x01 },
> +	{ 0x020f, 0x00 },
> +	{ 0x0210, 0x01 },
> +	{ 0x0211, 0x00 },
> +	{ 0x0212, 0x01 },
> +	{ 0x0213, 0x00 },
> +	{ 0x0214, 0x01 },
> +	{ 0x0215, 0x00 },
> +	{ 0x0218, 0x01 },
> +	{ 0x0219, 0x00 },
> +	{ 0x3614, 0x00 },
> +	{ 0x3616, 0x0d },
> +	{ 0x3617, 0x56 },
> +	{ 0xb612, 0x20 },
> +	{ 0xb613, 0x20 },
> +	{ 0xb614, 0x20 },
> +	{ 0xb615, 0x20 },
> +	{ 0xb616, 0x0a },
> +	{ 0xb617, 0x0a },
> +	{ 0xb618, 0x20 },
> +	{ 0xb619, 0x20 },
> +	{ 0xb61a, 0x20 },
> +	{ 0xb61b, 0x20 },
> +	{ 0xb61c, 0x0a },
> +	{ 0xb61d, 0x0a },
> +	{ 0xb666, 0x30 },
> +	{ 0xb667, 0x30 },
> +	{ 0xb668, 0x30 },
> +	{ 0xb669, 0x30 },
> +	{ 0xb66a, 0x14 },
> +	{ 0xb66b, 0x14 },
> +	{ 0xb66c, 0x20 },
> +	{ 0xb66d, 0x20 },
> +	{ 0xb66e, 0x20 },
> +	{ 0xb66f, 0x20 },
> +	{ 0xb670, 0x10 },
> +	{ 0xb671, 0x10 },
> +	{ 0x3237, 0x00 },
> +	{ 0x3900, 0x00 },
> +	{ 0x3901, 0x00 },
> +	{ 0x3902, 0x00 },
> +	{ 0x3904, 0x00 },
> +	{ 0x3905, 0x00 },
> +	{ 0x3906, 0x00 },
> +	{ 0x3907, 0x00 },
> +	{ 0x3908, 0x00 },
> +	{ 0x3909, 0x00 },
> +	{ 0x3912, 0x00 },
> +	{ 0x3930, 0x00 },
> +	{ 0x3931, 0x00 },
> +	{ 0x3933, 0x00 },
> +	{ 0x3934, 0x00 },
> +	{ 0x3935, 0x00 },
> +	{ 0x3936, 0x00 },
> +	{ 0x3937, 0x00 },
> +	{ 0x30ac, 0x00 },
> +};
> +
> +static const struct imx319_reg mode_1640x1232_regs[] = {
> +	{ 0x0112, 0x0a },
> +	{ 0x0113, 0x0a },
> +	{ 0x0114, 0x03 },
> +	{ 0x0342, 0x08 },
> +	{ 0x0343, 0x20 },
> +	{ 0x0340, 0x18 },
> +	{ 0x0341, 0x2a },
> +	{ 0x0344, 0x00 },
> +	{ 0x0345, 0x00 },
> +	{ 0x0346, 0x00 },
> +	{ 0x0347, 0x00 },
> +	{ 0x0348, 0x0c },
> +	{ 0x0349, 0xcf },
> +	{ 0x034a, 0x09 },
> +	{ 0x034b, 0x9f },
> +	{ 0x0220, 0x00 },
> +	{ 0x0221, 0x11 },
> +	{ 0x0381, 0x01 },
> +	{ 0x0383, 0x01 },
> +	{ 0x0385, 0x01 },
> +	{ 0x0387, 0x01 },
> +	{ 0x0900, 0x01 },
> +	{ 0x0901, 0x22 },
> +	{ 0x0902, 0x0a },
> +	{ 0x3140, 0x02 },
> +	{ 0x3141, 0x00 },
> +	{ 0x3f0d, 0x0a },
> +	{ 0x3f14, 0x01 },
> +	{ 0x3f3c, 0x02 },
> +	{ 0x3f4d, 0x01 },
> +	{ 0x3f4c, 0x01 },
> +	{ 0x4254, 0x7f },
> +	{ 0x0401, 0x00 },
> +	{ 0x0404, 0x00 },
> +	{ 0x0405, 0x10 },
> +	{ 0x0408, 0x00 },
> +	{ 0x0409, 0x00 },
> +	{ 0x040a, 0x00 },
> +	{ 0x040b, 0x00 },
> +	{ 0x040c, 0x06 },
> +	{ 0x040d, 0x68 },
> +	{ 0x040e, 0x04 },
> +	{ 0x040f, 0xd0 },
> +	{ 0x034c, 0x06 },
> +	{ 0x034d, 0x68 },
> +	{ 0x034e, 0x04 },
> +	{ 0x034f, 0xd0 },
> +	{ 0x3261, 0x00 },
> +	{ 0x3264, 0x00 },
> +	{ 0x3265, 0x10 },
> +	{ 0x0301, 0x05 },
> +	{ 0x0303, 0x04 },
> +	{ 0x0305, 0x04 },
> +	{ 0x0306, 0x01 },
> +	{ 0x0307, 0x92 },
> +	{ 0x0309, 0x0a },
> +	{ 0x030b, 0x02 },
> +	{ 0x030d, 0x02 },
> +	{ 0x030e, 0x00 },
> +	{ 0x030f, 0xfa },
> +	{ 0x0310, 0x00 },
> +	{ 0x0820, 0x0f },
> +	{ 0x0821, 0x13 },
> +	{ 0x0822, 0x33 },
> +	{ 0x0823, 0x33 },
> +	{ 0x3e20, 0x01 },
> +	{ 0x3e37, 0x00 },
> +	{ 0x3e3b, 0x01 },
> +	{ 0x38a3, 0x01 },
> +	{ 0x38a8, 0x00 },
> +	{ 0x38a9, 0x00 },
> +	{ 0x38aa, 0x00 },
> +	{ 0x38ab, 0x00 },
> +	{ 0x3234, 0x00 },
> +	{ 0x3fc1, 0x00 },
> +	{ 0x3235, 0x00 },
> +	{ 0x3802, 0x00 },
> +	{ 0x3143, 0x04 },
> +	{ 0x360a, 0x00 },
> +	{ 0x0b00, 0x00 },
> +	{ 0x0106, 0x00 },
> +	{ 0x0b05, 0x01 },
> +	{ 0x0b06, 0x01 },
> +	{ 0x3230, 0x00 },
> +	{ 0x3602, 0x01 },
> +	{ 0x3607, 0x01 },
> +	{ 0x3c00, 0x00 },
> +	{ 0x3c01, 0xba },
> +	{ 0x3c02, 0xc8 },
> +	{ 0x3c03, 0xaa },
> +	{ 0x3c04, 0x91 },
> +	{ 0x3c05, 0x54 },
> +	{ 0x3c06, 0x26 },
> +	{ 0x3c07, 0x20 },
> +	{ 0x3c08, 0x51 },
> +	{ 0x3d80, 0x00 },
> +	{ 0x3f50, 0x00 },
> +	{ 0x3f56, 0x00 },
> +	{ 0x3f57, 0x30 },
> +	{ 0x3f78, 0x00 },
> +	{ 0x3f79, 0x34 },
> +	{ 0x3f7c, 0x00 },
> +	{ 0x3f7d, 0x00 },
> +	{ 0x3fba, 0x00 },
> +	{ 0x3fbb, 0x00 },
> +	{ 0xa081, 0x04 },
> +	{ 0xe014, 0x00 },
> +	{ 0x0202, 0x04 },
> +	{ 0x0203, 0xf6 },
> +	{ 0x0224, 0x01 },
> +	{ 0x0225, 0xf4 },
> +	{ 0x0204, 0x00 },
> +	{ 0x0205, 0x00 },
> +	{ 0x0216, 0x00 },
> +	{ 0x0217, 0x00 },
> +	{ 0x020e, 0x01 },
> +	{ 0x020f, 0x00 },
> +	{ 0x0210, 0x01 },
> +	{ 0x0211, 0x00 },
> +	{ 0x0212, 0x01 },
> +	{ 0x0213, 0x00 },
> +	{ 0x0214, 0x01 },
> +	{ 0x0215, 0x00 },
> +	{ 0x0218, 0x01 },
> +	{ 0x0219, 0x00 },
> +	{ 0x3614, 0x00 },
> +	{ 0x3616, 0x0d },
> +	{ 0x3617, 0x56 },
> +	{ 0xb612, 0x20 },
> +	{ 0xb613, 0x20 },
> +	{ 0xb614, 0x20 },
> +	{ 0xb615, 0x20 },
> +	{ 0xb616, 0x0a },
> +	{ 0xb617, 0x0a },
> +	{ 0xb618, 0x20 },
> +	{ 0xb619, 0x20 },
> +	{ 0xb61a, 0x20 },
> +	{ 0xb61b, 0x20 },
> +	{ 0xb61c, 0x0a },
> +	{ 0xb61d, 0x0a },
> +	{ 0xb666, 0x30 },
> +	{ 0xb667, 0x30 },
> +	{ 0xb668, 0x30 },
> +	{ 0xb669, 0x30 },
> +	{ 0xb66a, 0x14 },
> +	{ 0xb66b, 0x14 },
> +	{ 0xb66c, 0x20 },
> +	{ 0xb66d, 0x20 },
> +	{ 0xb66e, 0x20 },
> +	{ 0xb66f, 0x20 },
> +	{ 0xb670, 0x10 },
> +	{ 0xb671, 0x10 },
> +	{ 0x3237, 0x00 },
> +	{ 0x3900, 0x00 },
> +	{ 0x3901, 0x00 },
> +	{ 0x3902, 0x00 },
> +	{ 0x3904, 0x00 },
> +	{ 0x3905, 0x00 },
> +	{ 0x3906, 0x00 },
> +	{ 0x3907, 0x00 },
> +	{ 0x3908, 0x00 },
> +	{ 0x3909, 0x00 },
> +	{ 0x3912, 0x00 },
> +	{ 0x3930, 0x00 },
> +	{ 0x3931, 0x00 },
> +	{ 0x3933, 0x00 },
> +	{ 0x3934, 0x00 },
> +	{ 0x3935, 0x00 },
> +	{ 0x3936, 0x00 },
> +	{ 0x3937, 0x00 },
> +	{ 0x30ac, 0x00 },
> +};
> +
> +static const struct imx319_reg mode_1640x922_regs[] = {
> +	{ 0x0112, 0x0a },
> +	{ 0x0113, 0x0a },
> +	{ 0x0114, 0x03 },
> +	{ 0x0342, 0x08 },
> +	{ 0x0343, 0x20 },
> +	{ 0x0340, 0x18 },
> +	{ 0x0341, 0x2a },
> +	{ 0x0344, 0x00 },
> +	{ 0x0345, 0x00 },
> +	{ 0x0346, 0x01 },
> +	{ 0x0347, 0x30 },
> +	{ 0x0348, 0x0c },
> +	{ 0x0349, 0xcf },
> +	{ 0x034a, 0x08 },
> +	{ 0x034b, 0x6f },
> +	{ 0x0220, 0x00 },
> +	{ 0x0221, 0x11 },
> +	{ 0x0381, 0x01 },
> +	{ 0x0383, 0x01 },
> +	{ 0x0385, 0x01 },
> +	{ 0x0387, 0x01 },
> +	{ 0x0900, 0x01 },
> +	{ 0x0901, 0x22 },
> +	{ 0x0902, 0x0a },
> +	{ 0x3140, 0x02 },
> +	{ 0x3141, 0x00 },
> +	{ 0x3f0d, 0x0a },
> +	{ 0x3f14, 0x01 },
> +	{ 0x3f3c, 0x02 },
> +	{ 0x3f4d, 0x01 },
> +	{ 0x3f4c, 0x01 },
> +	{ 0x4254, 0x7f },
> +	{ 0x0401, 0x00 },
> +	{ 0x0404, 0x00 },
> +	{ 0x0405, 0x10 },
> +	{ 0x0408, 0x00 },
> +	{ 0x0409, 0x00 },
> +	{ 0x040a, 0x00 },
> +	{ 0x040b, 0x02 },
> +	{ 0x040c, 0x06 },
> +	{ 0x040d, 0x68 },
> +	{ 0x040e, 0x03 },
> +	{ 0x040f, 0x9a },
> +	{ 0x034c, 0x06 },
> +	{ 0x034d, 0x68 },
> +	{ 0x034e, 0x03 },
> +	{ 0x034f, 0x9a },
> +	{ 0x3261, 0x00 },
> +	{ 0x3264, 0x00 },
> +	{ 0x3265, 0x10 },
> +	{ 0x0301, 0x05 },
> +	{ 0x0303, 0x04 },
> +	{ 0x0305, 0x04 },
> +	{ 0x0306, 0x01 },
> +	{ 0x0307, 0x92 },
> +	{ 0x0309, 0x0a },
> +	{ 0x030b, 0x02 },
> +	{ 0x030d, 0x02 },
> +	{ 0x030e, 0x00 },
> +	{ 0x030f, 0xfa },
> +	{ 0x0310, 0x00 },
> +	{ 0x0820, 0x0f },
> +	{ 0x0821, 0x13 },
> +	{ 0x0822, 0x33 },
> +	{ 0x0823, 0x33 },
> +	{ 0x3e20, 0x01 },
> +	{ 0x3e37, 0x00 },
> +	{ 0x3e3b, 0x01 },
> +	{ 0x38a3, 0x01 },
> +	{ 0x38a8, 0x00 },
> +	{ 0x38a9, 0x00 },
> +	{ 0x38aa, 0x00 },
> +	{ 0x38ab, 0x00 },
> +	{ 0x3234, 0x00 },
> +	{ 0x3fc1, 0x00 },
> +	{ 0x3235, 0x00 },
> +	{ 0x3802, 0x00 },
> +	{ 0x3143, 0x04 },
> +	{ 0x360a, 0x00 },
> +	{ 0x0b00, 0x00 },
> +	{ 0x0106, 0x00 },
> +	{ 0x0b05, 0x01 },
> +	{ 0x0b06, 0x01 },
> +	{ 0x3230, 0x00 },
> +	{ 0x3602, 0x01 },
> +	{ 0x3607, 0x01 },
> +	{ 0x3c00, 0x00 },
> +	{ 0x3c01, 0xba },
> +	{ 0x3c02, 0xc8 },
> +	{ 0x3c03, 0xaa },
> +	{ 0x3c04, 0x91 },
> +	{ 0x3c05, 0x54 },
> +	{ 0x3c06, 0x26 },
> +	{ 0x3c07, 0x20 },
> +	{ 0x3c08, 0x51 },
> +	{ 0x3d80, 0x00 },
> +	{ 0x3f50, 0x00 },
> +	{ 0x3f56, 0x00 },
> +	{ 0x3f57, 0x30 },
> +	{ 0x3f78, 0x00 },
> +	{ 0x3f79, 0x34 },
> +	{ 0x3f7c, 0x00 },
> +	{ 0x3f7d, 0x00 },
> +	{ 0x3fba, 0x00 },
> +	{ 0x3fbb, 0x00 },
> +	{ 0xa081, 0x04 },
> +	{ 0xe014, 0x00 },
> +	{ 0x0202, 0x04 },
> +	{ 0x0203, 0xf6 },
> +	{ 0x0224, 0x01 },
> +	{ 0x0225, 0xf4 },
> +	{ 0x0204, 0x00 },
> +	{ 0x0205, 0x00 },
> +	{ 0x0216, 0x00 },
> +	{ 0x0217, 0x00 },
> +	{ 0x020e, 0x01 },
> +	{ 0x020f, 0x00 },
> +	{ 0x0210, 0x01 },
> +	{ 0x0211, 0x00 },
> +	{ 0x0212, 0x01 },
> +	{ 0x0213, 0x00 },
> +	{ 0x0214, 0x01 },
> +	{ 0x0215, 0x00 },
> +	{ 0x0218, 0x01 },
> +	{ 0x0219, 0x00 },
> +	{ 0x3614, 0x00 },
> +	{ 0x3616, 0x0d },
> +	{ 0x3617, 0x56 },
> +	{ 0xb612, 0x20 },
> +	{ 0xb613, 0x20 },
> +	{ 0xb614, 0x20 },
> +	{ 0xb615, 0x20 },
> +	{ 0xb616, 0x0a },
> +	{ 0xb617, 0x0a },
> +	{ 0xb618, 0x20 },
> +	{ 0xb619, 0x20 },
> +	{ 0xb61a, 0x20 },
> +	{ 0xb61b, 0x20 },
> +	{ 0xb61c, 0x0a },
> +	{ 0xb61d, 0x0a },
> +	{ 0xb666, 0x30 },
> +	{ 0xb667, 0x30 },
> +	{ 0xb668, 0x30 },
> +	{ 0xb669, 0x30 },
> +	{ 0xb66a, 0x14 },
> +	{ 0xb66b, 0x14 },
> +	{ 0xb66c, 0x20 },
> +	{ 0xb66d, 0x20 },
> +	{ 0xb66e, 0x20 },
> +	{ 0xb66f, 0x20 },
> +	{ 0xb670, 0x10 },
> +	{ 0xb671, 0x10 },
> +	{ 0x3237, 0x00 },
> +	{ 0x3900, 0x00 },
> +	{ 0x3901, 0x00 },
> +	{ 0x3902, 0x00 },
> +	{ 0x3904, 0x00 },
> +	{ 0x3905, 0x00 },
> +	{ 0x3906, 0x00 },
> +	{ 0x3907, 0x00 },
> +	{ 0x3908, 0x00 },
> +	{ 0x3909, 0x00 },
> +	{ 0x3912, 0x00 },
> +	{ 0x3930, 0x00 },
> +	{ 0x3931, 0x00 },
> +	{ 0x3933, 0x00 },
> +	{ 0x3934, 0x00 },
> +	{ 0x3935, 0x00 },
> +	{ 0x3936, 0x00 },
> +	{ 0x3937, 0x00 },
> +	{ 0x30ac, 0x00 },
> +};
> +
> +static const struct imx319_reg mode_1296x736_regs[] = {
> +	{ 0x0112, 0x0a },
> +	{ 0x0113, 0x0a },
> +	{ 0x0114, 0x03 },
> +	{ 0x0342, 0x08 },
> +	{ 0x0343, 0x20 },
> +	{ 0x0340, 0x18 },
> +	{ 0x0341, 0x2a },
> +	{ 0x0344, 0x00 },
> +	{ 0x0345, 0x00 },
> +	{ 0x0346, 0x01 },
> +	{ 0x0347, 0xf0 },
> +	{ 0x0348, 0x0c },
> +	{ 0x0349, 0xcf },
> +	{ 0x034a, 0x07 },
> +	{ 0x034b, 0xaf },
> +	{ 0x0220, 0x00 },
> +	{ 0x0221, 0x11 },
> +	{ 0x0381, 0x01 },
> +	{ 0x0383, 0x01 },
> +	{ 0x0385, 0x01 },
> +	{ 0x0387, 0x01 },
> +	{ 0x0900, 0x01 },
> +	{ 0x0901, 0x22 },
> +	{ 0x0902, 0x0a },
> +	{ 0x3140, 0x02 },
> +	{ 0x3141, 0x00 },
> +	{ 0x3f0d, 0x0a },
> +	{ 0x3f14, 0x01 },
> +	{ 0x3f3c, 0x02 },
> +	{ 0x3f4d, 0x01 },
> +	{ 0x3f4c, 0x01 },
> +	{ 0x4254, 0x7f },
> +	{ 0x0401, 0x00 },
> +	{ 0x0404, 0x00 },
> +	{ 0x0405, 0x10 },
> +	{ 0x0408, 0x00 },
> +	{ 0x0409, 0xac },
> +	{ 0x040a, 0x00 },
> +	{ 0x040b, 0x00 },
> +	{ 0x040c, 0x05 },
> +	{ 0x040d, 0x10 },
> +	{ 0x040e, 0x02 },
> +	{ 0x040f, 0xe0 },
> +	{ 0x034c, 0x05 },
> +	{ 0x034d, 0x10 },
> +	{ 0x034e, 0x02 },
> +	{ 0x034f, 0xe0 },
> +	{ 0x3261, 0x00 },
> +	{ 0x3264, 0x00 },
> +	{ 0x3265, 0x10 },
> +	{ 0x0301, 0x05 },
> +	{ 0x0303, 0x04 },
> +	{ 0x0305, 0x04 },
> +	{ 0x0306, 0x01 },
> +	{ 0x0307, 0x92 },
> +	{ 0x0309, 0x0a },
> +	{ 0x030b, 0x02 },
> +	{ 0x030d, 0x02 },
> +	{ 0x030e, 0x00 },
> +	{ 0x030f, 0xfa },
> +	{ 0x0310, 0x00 },
> +	{ 0x0820, 0x0f },
> +	{ 0x0821, 0x13 },
> +	{ 0x0822, 0x33 },
> +	{ 0x0823, 0x33 },
> +	{ 0x3e20, 0x01 },
> +	{ 0x3e37, 0x00 },
> +	{ 0x3e3b, 0x01 },
> +	{ 0x38a3, 0x01 },
> +	{ 0x38a8, 0x00 },
> +	{ 0x38a9, 0x00 },
> +	{ 0x38aa, 0x00 },
> +	{ 0x38ab, 0x00 },
> +	{ 0x3234, 0x00 },
> +	{ 0x3fc1, 0x00 },
> +	{ 0x3235, 0x00 },
> +	{ 0x3802, 0x00 },
> +	{ 0x3143, 0x04 },
> +	{ 0x360a, 0x00 },
> +	{ 0x0b00, 0x00 },
> +	{ 0x0106, 0x00 },
> +	{ 0x0b05, 0x01 },
> +	{ 0x0b06, 0x01 },
> +	{ 0x3230, 0x00 },
> +	{ 0x3602, 0x01 },
> +	{ 0x3607, 0x01 },
> +	{ 0x3c00, 0x00 },
> +	{ 0x3c01, 0xba },
> +	{ 0x3c02, 0xc8 },
> +	{ 0x3c03, 0xaa },
> +	{ 0x3c04, 0x91 },
> +	{ 0x3c05, 0x54 },
> +	{ 0x3c06, 0x26 },
> +	{ 0x3c07, 0x20 },
> +	{ 0x3c08, 0x51 },
> +	{ 0x3d80, 0x00 },
> +	{ 0x3f50, 0x00 },
> +	{ 0x3f56, 0x00 },
> +	{ 0x3f57, 0x30 },
> +	{ 0x3f78, 0x00 },
> +	{ 0x3f79, 0x34 },
> +	{ 0x3f7c, 0x00 },
> +	{ 0x3f7d, 0x00 },
> +	{ 0x3fba, 0x00 },
> +	{ 0x3fbb, 0x00 },
> +	{ 0xa081, 0x04 },
> +	{ 0xe014, 0x00 },
> +	{ 0x0202, 0x04 },
> +	{ 0x0203, 0xf6 },
> +	{ 0x0224, 0x01 },
> +	{ 0x0225, 0xf4 },
> +	{ 0x0204, 0x00 },
> +	{ 0x0205, 0x00 },
> +	{ 0x0216, 0x00 },
> +	{ 0x0217, 0x00 },
> +	{ 0x020e, 0x01 },
> +	{ 0x020f, 0x00 },
> +	{ 0x0210, 0x01 },
> +	{ 0x0211, 0x00 },
> +	{ 0x0212, 0x01 },
> +	{ 0x0213, 0x00 },
> +	{ 0x0214, 0x01 },
> +	{ 0x0215, 0x00 },
> +	{ 0x0218, 0x01 },
> +	{ 0x0219, 0x00 },
> +	{ 0x3614, 0x00 },
> +	{ 0x3616, 0x0d },
> +	{ 0x3617, 0x56 },
> +	{ 0xb612, 0x20 },
> +	{ 0xb613, 0x20 },
> +	{ 0xb614, 0x20 },
> +	{ 0xb615, 0x20 },
> +	{ 0xb616, 0x0a },
> +	{ 0xb617, 0x0a },
> +	{ 0xb618, 0x20 },
> +	{ 0xb619, 0x20 },
> +	{ 0xb61a, 0x20 },
> +	{ 0xb61b, 0x20 },
> +	{ 0xb61c, 0x0a },
> +	{ 0xb61d, 0x0a },
> +	{ 0xb666, 0x30 },
> +	{ 0xb667, 0x30 },
> +	{ 0xb668, 0x30 },
> +	{ 0xb669, 0x30 },
> +	{ 0xb66a, 0x14 },
> +	{ 0xb66b, 0x14 },
> +	{ 0xb66c, 0x20 },
> +	{ 0xb66d, 0x20 },
> +	{ 0xb66e, 0x20 },
> +	{ 0xb66f, 0x20 },
> +	{ 0xb670, 0x10 },
> +	{ 0xb671, 0x10 },
> +	{ 0x3237, 0x00 },
> +	{ 0x3900, 0x00 },
> +	{ 0x3901, 0x00 },
> +	{ 0x3902, 0x00 },
> +	{ 0x3904, 0x00 },
> +	{ 0x3905, 0x00 },
> +	{ 0x3906, 0x00 },
> +	{ 0x3907, 0x00 },
> +	{ 0x3908, 0x00 },
> +	{ 0x3909, 0x00 },
> +	{ 0x3912, 0x00 },
> +	{ 0x3930, 0x00 },
> +	{ 0x3931, 0x00 },
> +	{ 0x3933, 0x00 },
> +	{ 0x3934, 0x00 },
> +	{ 0x3935, 0x00 },
> +	{ 0x3936, 0x00 },
> +	{ 0x3937, 0x00 },
> +	{ 0x30ac, 0x00 },
> +};
> +
> +static const struct imx319_reg mode_1280x720_regs[] = {
> +	{ 0x0112, 0x0a },
> +	{ 0x0113, 0x0a },
> +	{ 0x0114, 0x03 },
> +	{ 0x0342, 0x08 },
> +	{ 0x0343, 0x20 },
> +	{ 0x0340, 0x18 },
> +	{ 0x0341, 0x2a },
> +	{ 0x0344, 0x00 },
> +	{ 0x0345, 0x00 },
> +	{ 0x0346, 0x02 },
> +	{ 0x0347, 0x00 },
> +	{ 0x0348, 0x0c },
> +	{ 0x0349, 0xcf },
> +	{ 0x034a, 0x07 },
> +	{ 0x034b, 0x9f },
> +	{ 0x0220, 0x00 },
> +	{ 0x0221, 0x11 },
> +	{ 0x0381, 0x01 },
> +	{ 0x0383, 0x01 },
> +	{ 0x0385, 0x01 },
> +	{ 0x0387, 0x01 },
> +	{ 0x0900, 0x01 },
> +	{ 0x0901, 0x22 },
> +	{ 0x0902, 0x0a },
> +	{ 0x3140, 0x02 },
> +	{ 0x3141, 0x00 },
> +	{ 0x3f0d, 0x0a },
> +	{ 0x3f14, 0x01 },
> +	{ 0x3f3c, 0x02 },
> +	{ 0x3f4d, 0x01 },
> +	{ 0x3f4c, 0x01 },
> +	{ 0x4254, 0x7f },
> +	{ 0x0401, 0x00 },
> +	{ 0x0404, 0x00 },
> +	{ 0x0405, 0x10 },
> +	{ 0x0408, 0x00 },
> +	{ 0x0409, 0xb4 },
> +	{ 0x040a, 0x00 },
> +	{ 0x040b, 0x00 },
> +	{ 0x040c, 0x05 },
> +	{ 0x040d, 0x00 },
> +	{ 0x040e, 0x02 },
> +	{ 0x040f, 0xd0 },
> +	{ 0x034c, 0x05 },
> +	{ 0x034d, 0x00 },
> +	{ 0x034e, 0x02 },
> +	{ 0x034f, 0xd0 },
> +	{ 0x3261, 0x00 },
> +	{ 0x3264, 0x00 },
> +	{ 0x3265, 0x10 },
> +	{ 0x0301, 0x05 },
> +	{ 0x0303, 0x04 },
> +	{ 0x0305, 0x04 },
> +	{ 0x0306, 0x01 },
> +	{ 0x0307, 0x92 },
> +	{ 0x0309, 0x0a },
> +	{ 0x030b, 0x02 },
> +	{ 0x030d, 0x02 },
> +	{ 0x030e, 0x00 },
> +	{ 0x030f, 0xfa },
> +	{ 0x0310, 0x00 },
> +	{ 0x0820, 0x0f },
> +	{ 0x0821, 0x13 },
> +	{ 0x0822, 0x33 },
> +	{ 0x0823, 0x33 },
> +	{ 0x3e20, 0x01 },
> +	{ 0x3e37, 0x00 },
> +	{ 0x3e3b, 0x01 },
> +	{ 0x38a3, 0x01 },
> +	{ 0x38a8, 0x00 },
> +	{ 0x38a9, 0x00 },
> +	{ 0x38aa, 0x00 },
> +	{ 0x38ab, 0x00 },
> +	{ 0x3234, 0x00 },
> +	{ 0x3fc1, 0x00 },
> +	{ 0x3235, 0x00 },
> +	{ 0x3802, 0x00 },
> +	{ 0x3143, 0x04 },
> +	{ 0x360a, 0x00 },
> +	{ 0x0b00, 0x00 },
> +	{ 0x0106, 0x00 },
> +	{ 0x0b05, 0x01 },
> +	{ 0x0b06, 0x01 },
> +	{ 0x3230, 0x00 },
> +	{ 0x3602, 0x01 },
> +	{ 0x3607, 0x01 },
> +	{ 0x3c00, 0x00 },
> +	{ 0x3c01, 0xba },
> +	{ 0x3c02, 0xc8 },
> +	{ 0x3c03, 0xaa },
> +	{ 0x3c04, 0x91 },
> +	{ 0x3c05, 0x54 },
> +	{ 0x3c06, 0x26 },
> +	{ 0x3c07, 0x20 },
> +	{ 0x3c08, 0x51 },
> +	{ 0x3d80, 0x00 },
> +	{ 0x3f50, 0x00 },
> +	{ 0x3f56, 0x00 },
> +	{ 0x3f57, 0x30 },
> +	{ 0x3f78, 0x00 },
> +	{ 0x3f79, 0x34 },
> +	{ 0x3f7c, 0x00 },
> +	{ 0x3f7d, 0x00 },
> +	{ 0x3fba, 0x00 },
> +	{ 0x3fbb, 0x00 },
> +	{ 0xa081, 0x04 },
> +	{ 0xe014, 0x00 },
> +	{ 0x0202, 0x04 },
> +	{ 0x0203, 0xf6 },
> +	{ 0x0224, 0x01 },
> +	{ 0x0225, 0xf4 },
> +	{ 0x0204, 0x00 },
> +	{ 0x0205, 0x00 },
> +	{ 0x0216, 0x00 },
> +	{ 0x0217, 0x00 },
> +	{ 0x020e, 0x01 },
> +	{ 0x020f, 0x00 },
> +	{ 0x0210, 0x01 },
> +	{ 0x0211, 0x00 },
> +	{ 0x0212, 0x01 },
> +	{ 0x0213, 0x00 },
> +	{ 0x0214, 0x01 },
> +	{ 0x0215, 0x00 },
> +	{ 0x0218, 0x01 },
> +	{ 0x0219, 0x00 },
> +	{ 0x3614, 0x00 },
> +	{ 0x3616, 0x0d },
> +	{ 0x3617, 0x56 },
> +	{ 0xb612, 0x20 },
> +	{ 0xb613, 0x20 },
> +	{ 0xb614, 0x20 },
> +	{ 0xb615, 0x20 },
> +	{ 0xb616, 0x0a },
> +	{ 0xb617, 0x0a },
> +	{ 0xb618, 0x20 },
> +	{ 0xb619, 0x20 },
> +	{ 0xb61a, 0x20 },
> +	{ 0xb61b, 0x20 },
> +	{ 0xb61c, 0x0a },
> +	{ 0xb61d, 0x0a },
> +	{ 0xb666, 0x30 },
> +	{ 0xb667, 0x30 },
> +	{ 0xb668, 0x30 },
> +	{ 0xb669, 0x30 },
> +	{ 0xb66a, 0x14 },
> +	{ 0xb66b, 0x14 },
> +	{ 0xb66c, 0x20 },
> +	{ 0xb66d, 0x20 },
> +	{ 0xb66e, 0x20 },
> +	{ 0xb66f, 0x20 },
> +	{ 0xb670, 0x10 },
> +	{ 0xb671, 0x10 },
> +	{ 0x3237, 0x00 },
> +	{ 0x3900, 0x00 },
> +	{ 0x3901, 0x00 },
> +	{ 0x3902, 0x00 },
> +	{ 0x3904, 0x00 },
> +	{ 0x3905, 0x00 },
> +	{ 0x3906, 0x00 },
> +	{ 0x3907, 0x00 },
> +	{ 0x3908, 0x00 },
> +	{ 0x3909, 0x00 },
> +	{ 0x3912, 0x00 },
> +	{ 0x3930, 0x00 },
> +	{ 0x3931, 0x00 },
> +	{ 0x3933, 0x00 },
> +	{ 0x3934, 0x00 },
> +	{ 0x3935, 0x00 },
> +	{ 0x3936, 0x00 },
> +	{ 0x3937, 0x00 },
> +	{ 0x30ac, 0x00 },
> +};
> +
> +static const char * const imx319_test_pattern_menu[] = {
> +	"Disabled",
> +	"100% color bars",
> +	"Solid color",
> +	"Fade to gray color bars",
> +	"PN9"
> +};
> +
> +static const int imx319_test_pattern_val[] = {
> +	IMX319_TEST_PATTERN_DISABLED,
> +	IMX319_TEST_PATTERN_COLOR_BARS,
> +	IMX319_TEST_PATTERN_SOLID_COLOR,
> +	IMX319_TEST_PATTERN_GRAY_COLOR_BARS,
> +	IMX319_TEST_PATTERN_PN9,
> +};
> +
> +/* Configurations for supported link frequencies */
> +/* Menu items for LINK_FREQ V4L2 control */
> +static s64 link_freq_menu_items[] = {

Const, please.

> +	IMX319_LINK_FREQ_DEFAULT,
> +};
> +
> +struct imx319_pdata pdata = {

Here, too.

> +	.link_freqs = link_freq_menu_items,
> +};
> +
> +/* Mode configs */
> +static const struct imx319_mode supported_modes[] = {
> +	{
> +		.width = 3280,
> +		.height = 2464,
> +		.fll_def = 3242,
> +		.fll_min = 3242,
> +		.llp = 3968,
> +		.reg_list = {
> +			.num_of_regs = ARRAY_SIZE(mode_3280x2464_regs),
> +			.regs = mode_3280x2464_regs,
> +		},
> +	},
> +	{
> +		.width = 3264,
> +		.height = 2448,
> +		.fll_def = 3242,
> +		.fll_min = 3242,
> +		.llp = 3968,
> +		.reg_list = {
> +			.num_of_regs = ARRAY_SIZE(mode_3264x2448_regs),
> +			.regs = mode_3264x2448_regs,
> +		},
> +	},
> +	{
> +		.width = 1936,
> +		.height = 1096,
> +		.fll_def = 3242,
> +		.fll_min = 3242,
> +		.llp = 3968,
> +		.reg_list = {
> +			.num_of_regs = ARRAY_SIZE(mode_1936x1096_regs),
> +			.regs = mode_1936x1096_regs,
> +		},
> +	},
> +	{
> +		.width = 1920,
> +		.height = 1080,
> +		.fll_def = 3242,
> +		.fll_min = 3242,
> +		.llp = 3968,
> +		.reg_list = {
> +			.num_of_regs = ARRAY_SIZE(mode_1920x1080_regs),
> +			.regs = mode_1920x1080_regs,
> +		},
> +	},
> +	{
> +		.width = 1640,
> +		.height = 1232,
> +		.fll_def = 5146,
> +		.fll_min = 5146,
> +		.llp = 2500,
> +		.reg_list = {
> +			.num_of_regs = ARRAY_SIZE(mode_1640x1232_regs),
> +			.regs = mode_1640x1232_regs,
> +		},
> +	},
> +	{
> +		.width = 1640,
> +		.height = 922,
> +		.fll_def = 5146,
> +		.fll_min = 5146,
> +		.llp = 2500,
> +		.reg_list = {
> +			.num_of_regs = ARRAY_SIZE(mode_1640x922_regs),
> +			.regs = mode_1640x922_regs,
> +		},
> +	},
> +	{
> +		.width = 1296,
> +		.height = 736,
> +		.fll_def = 5146,
> +		.fll_min = 5146,
> +		.llp = 2500,
> +		.reg_list = {
> +			.num_of_regs = ARRAY_SIZE(mode_1296x736_regs),
> +			.regs = mode_1296x736_regs,
> +		},
> +	},
> +	{
> +		.width = 1280,
> +		.height = 720,
> +		.fll_def = 5146,
> +		.fll_min = 5146,
> +		.llp = 2500,
> +		.reg_list = {
> +			.num_of_regs = ARRAY_SIZE(mode_1280x720_regs),
> +			.regs = mode_1280x720_regs,
> +		},
> +	},
> +};
> +
> +static inline struct imx319 *to_imx319(struct v4l2_subdev *_sd)
> +{
> +	return container_of(_sd, struct imx319, sd);
> +}
> +
> +/* Get bayer order based on flip setting. */
> +static __u32 imx319_get_format_code(struct imx319 *imx319)

u32; this is kernel code.

> +{
> +	/*
> +	 * Only one bayer order is supported.
> +	 * It depends on the flip settings.
> +	 */
> +	static const __u32 codes[2][2] = {

Here, too.

> +		{ MEDIA_BUS_FMT_SRGGB10_1X10, MEDIA_BUS_FMT_SGRBG10_1X10, },
> +		{ MEDIA_BUS_FMT_SGBRG10_1X10, MEDIA_BUS_FMT_SBGGR10_1X10, },
> +	};
> +

In order to avoid locking issues (see below), please add here:

lockdep_assert_held(&imx319->mutex);

> +	return codes[imx319->vflip->val][imx319->hflip->val];
> +}
> +
> +/* Read registers up to 4 at a time */
> +static int imx319_read_reg(struct imx319 *imx319, u16 reg, u32 len, u32 *val)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&imx319->sd);
> +	struct i2c_msg msgs[2];
> +	u8 addr_buf[2];
> +	u8 data_buf[4] = { 0 };
> +	int ret;
> +
> +	if (len > 4)
> +		return -EINVAL;
> +
> +	put_unaligned_be16(reg, addr_buf);
> +	/* Write register address */
> +	msgs[0].addr = client->addr;
> +	msgs[0].flags = 0;
> +	msgs[0].len = ARRAY_SIZE(addr_buf);
> +	msgs[0].buf = addr_buf;
> +
> +	/* Read data from register */
> +	msgs[1].addr = client->addr;
> +	msgs[1].flags = I2C_M_RD;
> +	msgs[1].len = len;
> +	msgs[1].buf = &data_buf[4 - len];
> +
> +	ret = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
> +	if (ret != ARRAY_SIZE(msgs))
> +		return -EIO;
> +
> +	*val = get_unaligned_be32(data_buf);
> +
> +	return 0;
> +}
> +
> +/* Write registers up to 4 at a time */
> +static int imx319_write_reg(struct imx319 *imx319, u16 reg, u32 len, u32 val)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&imx319->sd);
> +	u8 buf[6];
> +
> +	if (len > 4)
> +		return -EINVAL;
> +
> +	put_unaligned_be16(reg, buf);
> +	put_unaligned_be32(val << (8 * (4 - len)), buf + 2);
> +	if (i2c_master_send(client, buf, len + 2) != len + 2)
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +/* Write a list of registers */
> +static int imx319_write_regs(struct imx319 *imx319,
> +			      const struct imx319_reg *regs, u32 len)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&imx319->sd);
> +	int ret;
> +	u32 i;
> +
> +	for (i = 0; i < len; i++) {
> +		ret = imx319_write_reg(imx319, regs[i].address, 1, regs[i].val);
> +		if (ret) {
> +			dev_err_ratelimited(&client->dev,
> +					    "write reg 0x%4.4x return err %d",
> +					    regs[i].address, ret);
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/* Open sub-device */
> +static int imx319_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +	struct imx319 *imx319 = to_imx319(sd);
> +	struct v4l2_mbus_framefmt *try_fmt =
> +		v4l2_subdev_get_try_format(sd, fh->pad, 0);
> +
> +	mutex_lock(&imx319->mutex);
> +
> +	/* Initialize try_fmt */
> +	try_fmt->width = imx319->cur_mode->width;
> +	try_fmt->height = imx319->cur_mode->height;
> +	try_fmt->code = MEDIA_BUS_FMT_SRGGB10_1X10;

I know I asked to use the default configuration here, but what I forgot was
that the flip controls affect the media bus code as well, and the media bus
code here needs to be valid for the given flipping configuration.

Could you switch to using imx319_get_format_code() here, please?

> +	try_fmt->field = V4L2_FIELD_NONE;
> +
> +	mutex_unlock(&imx319->mutex);
> +
> +	return 0;
> +}
> +
> +static int imx319_update_digital_gain(struct imx319 *imx319, u32 d_gain)
> +{
> +	int ret;
> +
> +	ret = imx319_write_reg(imx319, IMX319_REG_DPGA_USE_GLOBAL_GAIN, 1, 1);
> +	if (ret)
> +		return ret;

You could do this write right after powering the sensor on, couldn't you?

> +
> +	/* Digital gain = (d_gain & 0xFF00) + (d_gain & 0xFF)/256 times */
> +	return imx319_write_reg(imx319, IMX319_REG_DIG_GAIN_GLOBAL, 2, d_gain);
> +}
> +
> +static int imx319_set_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct imx319 *imx319 = container_of(ctrl->handler,
> +					     struct imx319, ctrl_handler);
> +	struct i2c_client *client = v4l2_get_subdevdata(&imx319->sd);
> +	s64 max;
> +	int ret;
> +
> +	/* Propagate change of current control to all related controls */
> +	switch (ctrl->id) {
> +	case V4L2_CID_VBLANK:
> +		/* Update max exposure while meeting expected vblanking */
> +		max = imx319->cur_mode->height + ctrl->val - 18;
> +		__v4l2_ctrl_modify_range(imx319->exposure,
> +					 imx319->exposure->minimum,
> +					 max, imx319->exposure->step, max);
> +		break;
> +	}
> +
> +	/*
> +	 * Applying V4L2 control value only happens
> +	 * when power is up for streaming
> +	 */
> +	if (pm_runtime_get_if_in_use(&client->dev) == 0)
> +		return 0;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_ANALOGUE_GAIN:
> +		/* Analog gain = 1024/(1024 - ctrl->val) times */
> +		ret = imx319_write_reg(imx319, IMX319_REG_ANALOG_GAIN, 2,
> +				       ctrl->val);
> +		break;
> +	case V4L2_CID_DIGITAL_GAIN:
> +		ret = imx319_update_digital_gain(imx319, ctrl->val);
> +		break;
> +	case V4L2_CID_EXPOSURE:
> +		ret = imx319_write_reg(imx319, IMX319_REG_EXPOSURE, 2,
> +				       ctrl->val);
> +		break;
> +	case V4L2_CID_VBLANK:
> +		/* Update FLL that meets expected vertical blanking */
> +		ret = imx319_write_reg(imx319, IMX319_REG_FLL, 2,
> +				       imx319->cur_mode->height + ctrl->val);
> +		break;
> +	case V4L2_CID_TEST_PATTERN:
> +		ret = imx319_write_reg(imx319, IMX319_REG_TEST_PATTERN,
> +				       2, imx319_test_pattern_val[ctrl->val]);
> +		break;
> +	case V4L2_CID_HFLIP:
> +	case V4L2_CID_VFLIP:
> +		ret = imx319_write_reg(imx319, IMX319_REG_ORIENTATION, 1,
> +				       imx319->hflip->val |
> +				       imx319->vflip->val << 1);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		dev_info(&client->dev, "ctrl(id:0x%x,val:0x%x) is not handled",
> +			 ctrl->id, ctrl->val);
> +		break;
> +	}
> +
> +	pm_runtime_put(&client->dev);
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_ctrl_ops imx319_ctrl_ops = {
> +	.s_ctrl = imx319_set_ctrl,
> +};
> +
> +static int imx319_enum_mbus_code(struct v4l2_subdev *sd,
> +				  struct v4l2_subdev_pad_config *cfg,
> +				  struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	struct imx319 *imx319 = to_imx319(sd);
> +
> +	if (code->index > 0)
> +		return -EINVAL;
> +
> +	code->code = imx319_get_format_code(imx319);

You need to acquire the mutex for imx319_get_format_code().

> +
> +	return 0;
> +}
> +
> +static int imx319_enum_frame_size(struct v4l2_subdev *sd,
> +				   struct v4l2_subdev_pad_config *cfg,
> +				   struct v4l2_subdev_frame_size_enum *fse)
> +{
> +	struct imx319 *imx319 = to_imx319(sd);
> +
> +	if (fse->index >= ARRAY_SIZE(supported_modes))
> +		return -EINVAL;
> +
> +	if (fse->code != imx319_get_format_code(imx319))

Same here.

> +		return -EINVAL;
> +
> +	fse->min_width = supported_modes[fse->index].width;
> +	fse->max_width = fse->min_width;
> +	fse->min_height = supported_modes[fse->index].height;
> +	fse->max_height = fse->min_height;
> +
> +	return 0;
> +}
> +
> +static void imx319_update_pad_format(struct imx319 *imx319,
> +				     const struct imx319_mode *mode,
> +				     struct v4l2_subdev_format *fmt)
> +{
> +	fmt->format.width = mode->width;
> +	fmt->format.height = mode->height;
> +	fmt->format.code = imx319_get_format_code(imx319);
> +	fmt->format.field = V4L2_FIELD_NONE;
> +}
> +
> +static int imx319_do_get_pad_format(struct imx319 *imx319,
> +				     struct v4l2_subdev_pad_config *cfg,
> +				     struct v4l2_subdev_format *fmt)
> +{
> +	struct v4l2_mbus_framefmt *framefmt;
> +	struct v4l2_subdev *sd = &imx319->sd;
> +
> +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		framefmt = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
> +		fmt->format = *framefmt;
> +	} else {
> +		imx319_update_pad_format(imx319, imx319->cur_mode, fmt);
> +	}
> +
> +	return 0;
> +}
> +
> +static int imx319_get_pad_format(struct v4l2_subdev *sd,
> +				  struct v4l2_subdev_pad_config *cfg,
> +				  struct v4l2_subdev_format *fmt)
> +{
> +	struct imx319 *imx319 = to_imx319(sd);
> +	int ret;
> +
> +	mutex_lock(&imx319->mutex);
> +	ret = imx319_do_get_pad_format(imx319, cfg, fmt);
> +	mutex_unlock(&imx319->mutex);
> +
> +	return ret;
> +}
> +
> +static int
> +imx319_set_pad_format(struct v4l2_subdev *sd,
> +		       struct v4l2_subdev_pad_config *cfg,
> +		       struct v4l2_subdev_format *fmt)
> +{
> +	struct imx319 *imx319 = to_imx319(sd);
> +	const struct imx319_mode *mode;
> +	struct v4l2_mbus_framefmt *framefmt;
> +	s32 vblank_def;
> +	s32 vblank_min;
> +	s64 h_blank;
> +	s64 pixel_rate;
> +	u32 height;
> +
> +	mutex_lock(&imx319->mutex);
> +
> +	/*
> +	 * Only one bayer order is supported.
> +	 * It depends on the flip settings.
> +	 */
> +	fmt->format.code = imx319_get_format_code(imx319);
> +
> +	mode = v4l2_find_nearest_size(supported_modes,
> +				      ARRAY_SIZE(supported_modes),
> +				      width, height,
> +				      fmt->format.width, fmt->format.height);
> +	imx319_update_pad_format(imx319, mode, fmt);
> +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		framefmt = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
> +		*framefmt = fmt->format;
> +	} else {
> +		imx319->cur_mode = mode;
> +		pixel_rate = (imx319->link_def_freq * 2 * 4) / 10;
> +		__v4l2_ctrl_s_ctrl_int64(imx319->pixel_rate, pixel_rate);
> +		/* Update limits and set FPS to default */
> +		height = imx319->cur_mode->height;
> +		vblank_def = imx319->cur_mode->fll_def - height;
> +		vblank_min = imx319->cur_mode->fll_min - height;
> +		height = IMX319_FLL_MAX - height;
> +		__v4l2_ctrl_modify_range(imx319->vblank, vblank_min, height, 1,
> +					 vblank_def);
> +		__v4l2_ctrl_s_ctrl(imx319->vblank, vblank_def);
> +		h_blank = mode->llp - imx319->cur_mode->width;
> +		/*
> +		 * Currently hblank is not changeable.
> +		 * So FPS control is done only by vblank.
> +		 */
> +		__v4l2_ctrl_modify_range(imx319->hblank, h_blank,
> +					 h_blank, 1, h_blank);
> +	}
> +
> +	mutex_unlock(&imx319->mutex);
> +
> +	return 0;
> +}
> +
> +/* Start streaming */
> +static int imx319_start_streaming(struct imx319 *imx319)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&imx319->sd);
> +	const struct imx319_reg_list *reg_list;
> +	int ret;
> +
> +	/* Global Setting */
> +	reg_list = &imx319_global_setting;
> +	ret = imx319_write_regs(imx319, reg_list->regs, reg_list->num_of_regs);
> +	if (ret) {
> +		dev_err(&client->dev, "failed to set global settings");
> +		return ret;
> +	}
> +
> +	/* Apply default values of current mode */
> +	reg_list = &imx319->cur_mode->reg_list;
> +	ret = imx319_write_regs(imx319, reg_list->regs, reg_list->num_of_regs);
> +	if (ret) {
> +		dev_err(&client->dev, "failed to set mode");
> +		return ret;
> +	}
> +
> +	/* Apply customized values from user */
> +	ret =  __v4l2_ctrl_handler_setup(imx319->sd.ctrl_handler);
> +	if (ret)
> +		return ret;
> +
> +	return imx319_write_reg(imx319, IMX319_REG_MODE_SELECT,
> +				1, IMX319_MODE_STREAMING);
> +}
> +
> +/* Stop streaming */
> +static int imx319_stop_streaming(struct imx319 *imx319)
> +{
> +	return imx319_write_reg(imx319, IMX319_REG_MODE_SELECT,
> +				1, IMX319_MODE_STANDBY);
> +}
> +
> +static int imx319_set_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct imx319 *imx319 = to_imx319(sd);
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	int ret = 0;
> +
> +	mutex_lock(&imx319->mutex);
> +	if (imx319->streaming == enable) {
> +		mutex_unlock(&imx319->mutex);
> +		return 0;
> +	}
> +
> +	if (enable) {
> +		ret = pm_runtime_get_sync(&client->dev);
> +		if (ret < 0) {
> +			pm_runtime_put_noidle(&client->dev);
> +			goto err_unlock;
> +		}
> +
> +		/*
> +		 * Apply default & customized values
> +		 * and then start streaming.
> +		 */
> +		ret = imx319_start_streaming(imx319);
> +		if (ret)
> +			goto err_rpm_put;
> +	} else {
> +		imx319_stop_streaming(imx319);
> +		pm_runtime_put(&client->dev);
> +	}
> +
> +	imx319->streaming = enable;
> +
> +	/* vflip and hflip cannot change during streaming */
> +	__v4l2_ctrl_grab(imx319->vflip, enable);
> +	__v4l2_ctrl_grab(imx319->hflip, enable);
> +
> +	mutex_unlock(&imx319->mutex);
> +
> +	return ret;
> +
> +err_rpm_put:
> +	pm_runtime_put(&client->dev);
> +err_unlock:
> +	mutex_unlock(&imx319->mutex);
> +
> +	return ret;
> +}
> +
> +static int __maybe_unused imx319_suspend(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct imx319 *imx319 = to_imx319(sd);
> +
> +	if (imx319->streaming)
> +		imx319_stop_streaming(imx319);
> +
> +	return 0;
> +}
> +
> +static int __maybe_unused imx319_resume(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct imx319 *imx319 = to_imx319(sd);
> +	int ret;
> +
> +	if (imx319->streaming) {
> +		ret = imx319_start_streaming(imx319);
> +		if (ret)
> +			goto error;
> +	}
> +
> +	return 0;
> +
> +error:
> +	imx319_stop_streaming(imx319);
> +	imx319->streaming = 0;
> +	return ret;
> +}
> +
> +/* Verify chip ID */
> +static int imx319_identify_module(struct imx319 *imx319)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&imx319->sd);
> +	int ret;
> +	u32 val;
> +
> +	ret = imx319_read_reg(imx319, IMX319_REG_CHIP_ID, 2, &val);
> +	if (ret)
> +		return ret;
> +
> +	if (val != IMX319_CHIP_ID) {
> +		dev_err(&client->dev, "chip id mismatch: %x!=%x",
> +			IMX319_CHIP_ID, val);
> +		return -EIO;
> +	}

Newline, please.

> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_core_ops imx319_subdev_core_ops = {
> +	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
> +	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
> +};
> +
> +static const struct v4l2_subdev_video_ops imx319_video_ops = {
> +	.s_stream = imx319_set_stream,
> +};
> +
> +static const struct v4l2_subdev_pad_ops imx319_pad_ops = {
> +	.enum_mbus_code = imx319_enum_mbus_code,
> +	.get_fmt = imx319_get_pad_format,
> +	.set_fmt = imx319_set_pad_format,
> +	.enum_frame_size = imx319_enum_frame_size,
> +};
> +
> +static const struct v4l2_subdev_ops imx319_subdev_ops = {
> +	.core = &imx319_subdev_core_ops,
> +	.video = &imx319_video_ops,
> +	.pad = &imx319_pad_ops,
> +};
> +
> +static const struct media_entity_operations imx319_subdev_entity_ops = {
> +	.link_validate = v4l2_subdev_link_validate,
> +};
> +
> +static const struct v4l2_subdev_internal_ops imx319_internal_ops = {
> +	.open = imx319_open,
> +};
> +
> +/* Initialize control handlers */
> +static int imx319_init_controls(struct imx319 *imx319)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&imx319->sd);
> +	struct v4l2_ctrl_handler *ctrl_hdlr;
> +	s64 exposure_max;
> +	s64 vblank_def;
> +	s64 vblank_min;
> +	s64 hblank;
> +	s64 pixel_rate;
> +	const struct imx319_mode *mode;
> +	int ret;
> +
> +	ctrl_hdlr = &imx319->ctrl_handler;
> +	ret = v4l2_ctrl_handler_init(ctrl_hdlr, 10);
> +	if (ret)
> +		return ret;
> +
> +	ctrl_hdlr->lock = &imx319->mutex;
> +	imx319->link_freq = v4l2_ctrl_new_int_menu(ctrl_hdlr, &imx319_ctrl_ops,
> +						   V4L2_CID_LINK_FREQ, 0, 0,
> +						   imx319->pdata->link_freqs);
> +	if (imx319->link_freq)
> +		imx319->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
> +
> +	/* pixel_rate = link_freq * 2 * nr_of_lanes / bits_per_sample */
> +	pixel_rate = (imx319->link_def_freq * 2 * 4) / 10;
> +	/* By default, PIXEL_RATE is read only */
> +	imx319->pixel_rate = v4l2_ctrl_new_std(ctrl_hdlr, &imx319_ctrl_ops,
> +					       V4L2_CID_PIXEL_RATE, pixel_rate,
> +					       pixel_rate, 1, pixel_rate);
> +
> +	/* Initialze vblank/hblank/exposure parameters based on current mode */
> +	mode = imx319->cur_mode;
> +	vblank_def = mode->fll_def - mode->height;
> +	vblank_min = mode->fll_min - mode->height;
> +	imx319->vblank = v4l2_ctrl_new_std(ctrl_hdlr, &imx319_ctrl_ops,
> +					   V4L2_CID_VBLANK, vblank_min,
> +					   IMX319_FLL_MAX - mode->height,
> +					   1, vblank_def);
> +
> +	hblank = mode->llp - mode->width;
> +	imx319->hblank = v4l2_ctrl_new_std(ctrl_hdlr, &imx319_ctrl_ops,
> +					   V4L2_CID_HBLANK, hblank, hblank,
> +					   1, hblank);
> +	if (imx319->hblank)
> +		imx319->hblank->flags |= V4L2_CTRL_FLAG_READ_ONLY;
> +
> +	exposure_max = mode->fll_def - 18;
> +	imx319->exposure = v4l2_ctrl_new_std(ctrl_hdlr, &imx319_ctrl_ops,
> +					     V4L2_CID_EXPOSURE,
> +					     IMX319_EXPOSURE_MIN, exposure_max,
> +					     IMX319_EXPOSURE_STEP,
> +					     IMX319_EXPOSURE_DEFAULT);
> +
> +	imx319->hflip = v4l2_ctrl_new_std(ctrl_hdlr, &imx319_ctrl_ops,
> +					  V4L2_CID_HFLIP, 0, 1, 1, 0);
> +	imx319->vflip = v4l2_ctrl_new_std(ctrl_hdlr, &imx319_ctrl_ops,
> +					  V4L2_CID_VFLIP, 0, 1, 1, 0);
> +
> +	v4l2_ctrl_new_std(ctrl_hdlr, &imx319_ctrl_ops, V4L2_CID_ANALOGUE_GAIN,
> +			  IMX319_ANA_GAIN_MIN, IMX319_ANA_GAIN_MAX,
> +			  IMX319_ANA_GAIN_STEP, IMX319_ANA_GAIN_DEFAULT);
> +
> +	/* Digital gain */
> +	v4l2_ctrl_new_std(ctrl_hdlr, &imx319_ctrl_ops, V4L2_CID_DIGITAL_GAIN,
> +			  IMX319_DGTL_GAIN_MIN, IMX319_DGTL_GAIN_MAX,
> +			  IMX319_DGTL_GAIN_STEP, IMX319_DGTL_GAIN_DEFAULT);
> +
> +	v4l2_ctrl_new_std_menu_items(ctrl_hdlr, &imx319_ctrl_ops,
> +				     V4L2_CID_TEST_PATTERN,
> +				     ARRAY_SIZE(imx319_test_pattern_menu) - 1,
> +				     0, 0, imx319_test_pattern_menu);
> +	if (ctrl_hdlr->error) {
> +		ret = ctrl_hdlr->error;
> +		dev_err(&client->dev, "control init failed: %d", ret);
> +		goto error;
> +	}
> +
> +	imx319->sd.ctrl_handler = ctrl_hdlr;
> +
> +	return 0;
> +
> +error:
> +	v4l2_ctrl_handler_free(ctrl_hdlr);
> +
> +	return ret;
> +}
> +
> +static void imx319_free_controls(struct imx319 *imx319)
> +{
> +	v4l2_ctrl_handler_free(imx319->sd.ctrl_handler);

You don't need a new function to do this; just call
v4l2_ctrl_handler_free() where you need it.

> +}
> +
> +static struct imx319_pdata *imx319_get_pdata(struct device *dev)

Same for this one as for imx319_pdata struct --- the driver does not
support platform data, so please do not use "pdata".

> +{
> +	struct imx319_pdata *cfg;
> +	struct v4l2_fwnode_endpoint *bus_cfg;
> +	struct fwnode_handle *ep;
> +	struct fwnode_handle *fwnode = dev_fwnode(dev);
> +	int i;

unsigned int i

> +	int ret;
> +
> +	if (!fwnode)
> +		return &pdata;
> +
> +	ep = fwnode_graph_get_next_endpoint(fwnode, NULL);
> +	if (!ep)
> +		return NULL;
> +
> +	bus_cfg = v4l2_fwnode_endpoint_alloc_parse(ep);
> +	if (IS_ERR(bus_cfg))
> +		goto out_err;
> +
> +	cfg = devm_kzalloc(dev, sizeof(*cfg), GFP_KERNEL);
> +	if (!cfg)
> +		goto out_err;
> +
> +	ret = fwnode_property_read_u32(dev_fwnode(dev), "clock-frequency",
> +					&cfg->ext_clk);
> +	if (ret) {
> +		dev_err(dev, "can't get clock frequency");
> +		goto out_err;
> +	}
> +
> +	dev_dbg(dev, "ext clk: %d", cfg->ext_clk);
> +	if (cfg->ext_clk != IMX319_EXT_CLK) {
> +		dev_err(dev, "external clock %d is not supported",
> +			 cfg->ext_clk);
> +		goto out_err;
> +	}
> +
> +	dev_dbg(dev, "number of link freqs: %d", bus_cfg->nr_of_link_frequencies);
> +	if (!bus_cfg->nr_of_link_frequencies) {
> +		dev_warn(dev, "no link frequencies defined");
> +		goto out_err;
> +	}
> +
> +	cfg->link_freqs = devm_kcalloc(
> +		dev, bus_cfg->nr_of_link_frequencies + 1,
> +		sizeof(*cfg->link_freqs), GFP_KERNEL);
> +	if (!cfg->link_freqs)
> +		goto out_err;
> +
> +	for (i = 0; i < bus_cfg->nr_of_link_frequencies; i++) {
> +		cfg->link_freqs[i] = bus_cfg->link_frequencies[i];
> +		dev_dbg(dev, "link_freq[%d] = %lld", i, cfg->link_freqs[i]);
> +	}
> +
> +	v4l2_fwnode_endpoint_free(bus_cfg);
> +	fwnode_handle_put(ep);
> +	return cfg;
> +
> +out_err:
> +	v4l2_fwnode_endpoint_free(bus_cfg);
> +	fwnode_handle_put(ep);
> +	return NULL;
> +}
> +
> +static int imx319_probe(struct i2c_client *client)
> +{
> +	struct imx319 *imx319;
> +	int ret;
> +
> +	imx319 = devm_kzalloc(&client->dev, sizeof(*imx319), GFP_KERNEL);
> +	if (!imx319)
> +		return -ENOMEM;
> +
> +	mutex_init(&imx319->mutex);
> +
> +	/* Initialize subdev */
> +	v4l2_i2c_subdev_init(&imx319->sd, client, &imx319_subdev_ops);
> +
> +	/* Check module identity */
> +	ret = imx319_identify_module(imx319);
> +	if (ret) {
> +		dev_err(&client->dev, "failed to find sensor: %d", ret);
> +		goto error_probe;
> +	}
> +
> +	if (!(imx319->pdata = imx319_get_pdata(&client->dev))) {

Please separate the assigment and the test.

> +		dev_err(&client->dev, "failed to get pdata");

And set ret before goto.

> +		goto error_probe;
> +	}
> +
> +	/* Set default link freqency */
> +	imx319->link_def_freq = imx319->pdata->link_freqs[0];

Which frequency the register lists are related to? Could you add a check
for that, and return an error if the check files?

> +
> +	/* Set default mode to max resolution */
> +	imx319->cur_mode = &supported_modes[0];
> +
> +	ret = imx319_init_controls(imx319);
> +	if (ret) {
> +		dev_err(&client->dev, "failed to init controls: %d", ret);
> +		goto error_probe;
> +	}
> +
> +	/* Initialize subdev */
> +	imx319->sd.internal_ops = &imx319_internal_ops;
> +	imx319->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE |
> +		V4L2_SUBDEV_FL_HAS_EVENTS;
> +	imx319->sd.entity.ops = &imx319_subdev_entity_ops;
> +	imx319->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
> +
> +	/* Initialize source pad */
> +	imx319->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	ret = media_entity_pads_init(&imx319->sd.entity, 1, &imx319->pad);
> +	if (ret) {
> +		dev_err(&client->dev, "failed to init entity pads: %d", ret);
> +		goto error_handler_free;
> +	}
> +
> +	ret = v4l2_async_register_subdev_sensor_common(&imx319->sd);
> +	if (ret < 0)
> +		goto error_media_entity;
> +
> +	/*
> +	 * Device is already turned on by i2c-core with ACPI domain PM.
> +	 * Enable runtime PM and turn off the device.
> +	 */
> +	pm_runtime_set_active(&client->dev);
> +	pm_runtime_enable(&client->dev);
> +	pm_runtime_idle(&client->dev);
> +
> +	return 0;
> +
> +error_media_entity:
> +	media_entity_cleanup(&imx319->sd.entity);
> +
> +error_handler_free:
> +	imx319_free_controls(imx319);
> +
> +error_probe:
> +	mutex_destroy(&imx319->mutex);
> +
> +	return ret;
> +}
> +
> +static int imx319_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct imx319 *imx319 = to_imx319(sd);
> +
> +	v4l2_async_unregister_subdev(sd);
> +	media_entity_cleanup(&sd->entity);
> +	imx319_free_controls(imx319);
> +
> +	pm_runtime_disable(&client->dev);
> +	pm_runtime_set_suspended(&client->dev);
> +
> +	mutex_destroy(&imx319->mutex);
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops imx319_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(imx319_suspend, imx319_resume)
> +};
> +
> +static const struct acpi_device_id imx319_acpi_ids[] = {
> +	{ "SONY319A" },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(acpi, imx319_acpi_ids);
> +
> +static struct i2c_driver imx319_i2c_driver = {
> +	.driver = {
> +		.name = "imx319",
> +		.pm = &imx319_pm_ops,
> +		.acpi_match_table = ACPI_PTR(imx319_acpi_ids),
> +	},
> +	.probe_new = imx319_probe,
> +	.remove = imx319_remove,
> +};
> +module_i2c_driver(imx319_i2c_driver);
> +
> +MODULE_AUTHOR("Qiu, Tianshu <tian.shu.qiu@intel.com>");
> +MODULE_AUTHOR("Rapolu, Chiranjeevi <chiranjeevi.rapolu@intel.com>");
> +MODULE_AUTHOR("Bingbu Cao <bingbu.cao@intel.com>");
> +MODULE_AUTHOR("Yang, Hyungwoo <hyungwoo.yang@intel.com>");
> +MODULE_DESCRIPTION("Sony imx319 sensor driver");
> +MODULE_LICENSE("GPL v2");

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
