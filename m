Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:54871 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726782AbeJCOle (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2018 10:41:34 -0400
Date: Wed, 3 Oct 2018 09:54:10 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v4 2/2] [media] imx214: Add imx214 camera sensor driver
Message-ID: <20181003075410.GE20786@w540>
References: <20181003072905.21786-1-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="FN+gV9K+162wdwwF"
Content-Disposition: inline
In-Reply-To: <20181003072905.21786-1-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--FN+gV9K+162wdwwF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Ricardo,

On Wed, Oct 03, 2018 at 09:29:05AM +0200, Ricardo Ribalda Delgado wrote:
> Add a V4L2 sub-device driver for the Sony IMX214 image sensor.
> This is a camera sensor using the I2C bus for control and the
> CSI-2 bus for data.
>
> Tested on a DB820c alike board with Intrinsyc Open-Q 13MP camera.
>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Thanks for addressing my comments on v2. Please add my:
Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>

Thanks
   j

> ---
> Changelog from v3:
>
> Sakari Ailus:
> - remove depends on OF
> - enum {\n};
> - only enable_gpio=0 in power_off
> - disable regulators on error
> - remove dup parenthesis
> - dev_fwnode(dev)
>
>  MAINTAINERS                |   8 +
>  drivers/media/i2c/Kconfig  |  11 +
>  drivers/media/i2c/Makefile |   1 +
>  drivers/media/i2c/imx214.c | 981 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 1001 insertions(+)
>  create mode 100644 drivers/media/i2c/imx214.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9989925f658d..2ae68894e700 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13521,6 +13521,14 @@ S:	Maintained
>  F:	drivers/ssb/
>  F:	include/linux/ssb/
>
> +SONY IMX214 SENSOR DRIVER
> +M:	Ricardo Ribalda <ricardo.ribalda@gmail.com>
> +L:	linux-media@vger.kernel.org
> +T:	git git://linuxtv.org/media_tree.git
> +S:	Maintained
> +F:	drivers/media/i2c/imx214.c
> +F:	Documentation/devicetree/bindings/media/i2c/imx214.txt
> +
>  SONY IMX258 SENSOR DRIVER
>  M:	Sakari Ailus <sakari.ailus@linux.intel.com>
>  L:	linux-media@vger.kernel.org
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index bfdb494686bf..870976dee4a2 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -595,6 +595,17 @@ config VIDEO_APTINA_PLL
>  config VIDEO_SMIAPP_PLL
>  	tristate
>
> +config VIDEO_IMX214
> +	tristate "Sony IMX214 sensor support"
> +	depends on GPIOLIB && I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> +	depends on MEDIA_CAMERA_SUPPORT
> +	help
> +	  This is a Video4Linux2 sensor driver for the Sony
> +	  IMX214 camera.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called imx214.
> +
>  config VIDEO_IMX258
>  	tristate "Sony IMX258 sensor support"
>  	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> index a94eb03d10d4..61305edc6165 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -106,6 +106,7 @@ obj-$(CONFIG_VIDEO_I2C)		+= video-i2c.o
>  obj-$(CONFIG_VIDEO_ML86V7667)	+= ml86v7667.o
>  obj-$(CONFIG_VIDEO_OV2659)	+= ov2659.o
>  obj-$(CONFIG_VIDEO_TC358743)	+= tc358743.o
> +obj-$(CONFIG_VIDEO_IMX214)	+= imx214.o
>  obj-$(CONFIG_VIDEO_IMX258)	+= imx258.o
>  obj-$(CONFIG_VIDEO_IMX274)	+= imx274.o
>
> diff --git a/drivers/media/i2c/imx214.c b/drivers/media/i2c/imx214.c
> new file mode 100644
> index 000000000000..7c94ac0d957c
> --- /dev/null
> +++ b/drivers/media/i2c/imx214.c
> @@ -0,0 +1,981 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * imx214.c - imx214 sensor driver
> + *
> + * Copyright 2018 Qtechnology A/S
> + *
> + * Ricardo Ribalda <ricardo.ribalda@gmail.com>
> + */
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/gpio/consumer.h>
> +#include <linux/i2c.h>
> +#include <linux/module.h>
> +#include <linux/regmap.h>
> +#include <linux/regulator/consumer.h>
> +#include <media/media-entity.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-fwnode.h>
> +#include <media/v4l2-subdev.h>
> +
> +#define IMX214_DEFAULT_CLK_FREQ	24000000
> +#define IMX214_DEFAULT_LINK_FREQ 480000000
> +#define IMX214_DEFAULT_PIXEL_RATE ((IMX214_DEFAULT_LINK_FREQ * 8LL) / 10)
> +#define IMX214_WIDTH 4096
> +#define IMX214_HEIGHT 2304
> +#define IMX214_FPS 30
> +#define IMX214_MBUS_CODE MEDIA_BUS_FMT_SRGGB10_1X10
> +
> +static const char * const imx214_supply_name[] = {
> +	"vdda",
> +	"vddd",
> +	"vdddo",
> +};
> +
> +#define IMX214_NUM_SUPPLIES ARRAY_SIZE(imx214_supply_name)
> +
> +struct imx214 {
> +	struct device *dev;
> +	struct clk *xclk;
> +	struct regmap *regmap;
> +
> +	struct v4l2_subdev sd;
> +	struct media_pad pad;
> +	struct v4l2_mbus_framefmt fmt;
> +	struct v4l2_rect crop;
> +
> +	struct v4l2_ctrl_handler ctrls;
> +	struct v4l2_ctrl *pixel_rate;
> +	struct v4l2_ctrl *link_freq;
> +
> +	struct regulator_bulk_data	supplies[IMX214_NUM_SUPPLIES];
> +
> +	struct gpio_desc *enable_gpio;
> +
> +	bool power_on;
> +};
> +
> +struct reg_8 {
> +	u16 addr;
> +	u8 val;
> +};
> +
> +enum {
> +	IMX214_TABLE_WAIT_MS = 0,
> +	IMX214_TABLE_END,
> +	IMX214_MAX_RETRIES,
> +	IMX214_WAIT_MS
> +};
> +
> +/*From imx214_mode_tbls.h*/
> +static const struct reg_8 mode_4096x2304[] = {
> +	{0x0114, 0x03},
> +	{0x0220, 0x00},
> +	{0x0221, 0x11},
> +	{0x0222, 0x01},
> +	{0x0340, 0x0C},
> +	{0x0341, 0x7A},
> +	{0x0342, 0x13},
> +	{0x0343, 0x90},
> +	{0x0344, 0x00},
> +	{0x0345, 0x38},
> +	{0x0346, 0x01},
> +	{0x0347, 0x98},
> +	{0x0348, 0x10},
> +	{0x0349, 0x37},
> +	{0x034A, 0x0A},
> +	{0x034B, 0x97},
> +	{0x0381, 0x01},
> +	{0x0383, 0x01},
> +	{0x0385, 0x01},
> +	{0x0387, 0x01},
> +	{0x0900, 0x00},
> +	{0x0901, 0x00},
> +	{0x0902, 0x00},
> +	{0x3000, 0x35},
> +	{0x3054, 0x01},
> +	{0x305C, 0x11},
> +
> +	{0x0112, 0x0A},
> +	{0x0113, 0x0A},
> +	{0x034C, 0x10},
> +	{0x034D, 0x00},
> +	{0x034E, 0x09},
> +	{0x034F, 0x00},
> +	{0x0401, 0x00},
> +	{0x0404, 0x00},
> +	{0x0405, 0x10},
> +	{0x0408, 0x00},
> +	{0x0409, 0x00},
> +	{0x040A, 0x00},
> +	{0x040B, 0x00},
> +	{0x040C, 0x10},
> +	{0x040D, 0x00},
> +	{0x040E, 0x09},
> +	{0x040F, 0x00},
> +
> +	{0x0301, 0x05},
> +	{0x0303, 0x02},
> +	{0x0305, 0x03},
> +	{0x0306, 0x00},
> +	{0x0307, 0x96},
> +	{0x0309, 0x0A},
> +	{0x030B, 0x01},
> +	{0x0310, 0x00},
> +
> +	{0x0820, 0x12},
> +	{0x0821, 0xC0},
> +	{0x0822, 0x00},
> +	{0x0823, 0x00},
> +
> +	{0x3A03, 0x09},
> +	{0x3A04, 0x50},
> +	{0x3A05, 0x01},
> +
> +	{0x0B06, 0x01},
> +	{0x30A2, 0x00},
> +
> +	{0x30B4, 0x00},
> +
> +	{0x3A02, 0xFF},
> +
> +	{0x3011, 0x00},
> +	{0x3013, 0x01},
> +
> +	{0x0202, 0x0C},
> +	{0x0203, 0x70},
> +	{0x0224, 0x01},
> +	{0x0225, 0xF4},
> +
> +	{0x0204, 0x00},
> +	{0x0205, 0x00},
> +	{0x020E, 0x01},
> +	{0x020F, 0x00},
> +	{0x0210, 0x01},
> +	{0x0211, 0x00},
> +	{0x0212, 0x01},
> +	{0x0213, 0x00},
> +	{0x0214, 0x01},
> +	{0x0215, 0x00},
> +	{0x0216, 0x00},
> +	{0x0217, 0x00},
> +
> +	{0x4170, 0x00},
> +	{0x4171, 0x10},
> +	{0x4176, 0x00},
> +	{0x4177, 0x3C},
> +	{0xAE20, 0x04},
> +	{0xAE21, 0x5C},
> +
> +	{IMX214_TABLE_WAIT_MS, 10},
> +	{0x0138, 0x01},
> +	{IMX214_TABLE_END, 0x00}
> +};
> +
> +static const struct reg_8 mode_1920x1080[] = {
> +	{0x0114, 0x03},
> +	{0x0220, 0x00},
> +	{0x0221, 0x11},
> +	{0x0222, 0x01},
> +	{0x0340, 0x0C},
> +	{0x0341, 0x7A},
> +	{0x0342, 0x13},
> +	{0x0343, 0x90},
> +	{0x0344, 0x04},
> +	{0x0345, 0x78},
> +	{0x0346, 0x03},
> +	{0x0347, 0xFC},
> +	{0x0348, 0x0B},
> +	{0x0349, 0xF7},
> +	{0x034A, 0x08},
> +	{0x034B, 0x33},
> +	{0x0381, 0x01},
> +	{0x0383, 0x01},
> +	{0x0385, 0x01},
> +	{0x0387, 0x01},
> +	{0x0900, 0x00},
> +	{0x0901, 0x00},
> +	{0x0902, 0x00},
> +	{0x3000, 0x35},
> +	{0x3054, 0x01},
> +	{0x305C, 0x11},
> +
> +	{0x0112, 0x0A},
> +	{0x0113, 0x0A},
> +	{0x034C, 0x07},
> +	{0x034D, 0x80},
> +	{0x034E, 0x04},
> +	{0x034F, 0x38},
> +	{0x0401, 0x00},
> +	{0x0404, 0x00},
> +	{0x0405, 0x10},
> +	{0x0408, 0x00},
> +	{0x0409, 0x00},
> +	{0x040A, 0x00},
> +	{0x040B, 0x00},
> +	{0x040C, 0x07},
> +	{0x040D, 0x80},
> +	{0x040E, 0x04},
> +	{0x040F, 0x38},
> +
> +	{0x0301, 0x05},
> +	{0x0303, 0x02},
> +	{0x0305, 0x03},
> +	{0x0306, 0x00},
> +	{0x0307, 0x96},
> +	{0x0309, 0x0A},
> +	{0x030B, 0x01},
> +	{0x0310, 0x00},
> +
> +	{0x0820, 0x12},
> +	{0x0821, 0xC0},
> +	{0x0822, 0x00},
> +	{0x0823, 0x00},
> +
> +	{0x3A03, 0x04},
> +	{0x3A04, 0xF8},
> +	{0x3A05, 0x02},
> +
> +	{0x0B06, 0x01},
> +	{0x30A2, 0x00},
> +
> +	{0x30B4, 0x00},
> +
> +	{0x3A02, 0xFF},
> +
> +	{0x3011, 0x00},
> +	{0x3013, 0x01},
> +
> +	{0x0202, 0x0C},
> +	{0x0203, 0x70},
> +	{0x0224, 0x01},
> +	{0x0225, 0xF4},
> +
> +	{0x0204, 0x00},
> +	{0x0205, 0x00},
> +	{0x020E, 0x01},
> +	{0x020F, 0x00},
> +	{0x0210, 0x01},
> +	{0x0211, 0x00},
> +	{0x0212, 0x01},
> +	{0x0213, 0x00},
> +	{0x0214, 0x01},
> +	{0x0215, 0x00},
> +	{0x0216, 0x00},
> +	{0x0217, 0x00},
> +
> +	{0x4170, 0x00},
> +	{0x4171, 0x10},
> +	{0x4176, 0x00},
> +	{0x4177, 0x3C},
> +	{0xAE20, 0x04},
> +	{0xAE21, 0x5C},
> +
> +	{IMX214_TABLE_WAIT_MS, 10},
> +	{0x0138, 0x01},
> +	{IMX214_TABLE_END, 0x00}
> +};
> +
> +static const struct reg_8 mode_table_common[] = {
> +	/* software reset */
> +
> +	/* software standby settings */
> +	{0x0100, 0x00},
> +
> +	/* ATR setting */
> +	{0x9300, 0x02},
> +
> +	/* external clock setting */
> +	{0x0136, 0x18},
> +	{0x0137, 0x00},
> +
> +	/* global setting */
> +	/* basic config */
> +	{0x0101, 0x00},
> +	{0x0105, 0x01},
> +	{0x0106, 0x01},
> +	{0x4550, 0x02},
> +	{0x4601, 0x00},
> +	{0x4642, 0x05},
> +	{0x6227, 0x11},
> +	{0x6276, 0x00},
> +	{0x900E, 0x06},
> +	{0xA802, 0x90},
> +	{0xA803, 0x11},
> +	{0xA804, 0x62},
> +	{0xA805, 0x77},
> +	{0xA806, 0xAE},
> +	{0xA807, 0x34},
> +	{0xA808, 0xAE},
> +	{0xA809, 0x35},
> +	{0xA80A, 0x62},
> +	{0xA80B, 0x83},
> +	{0xAE33, 0x00},
> +
> +	/* analog setting */
> +	{0x4174, 0x00},
> +	{0x4175, 0x11},
> +	{0x4612, 0x29},
> +	{0x461B, 0x12},
> +	{0x461F, 0x06},
> +	{0x4635, 0x07},
> +	{0x4637, 0x30},
> +	{0x463F, 0x18},
> +	{0x4641, 0x0D},
> +	{0x465B, 0x12},
> +	{0x465F, 0x11},
> +	{0x4663, 0x11},
> +	{0x4667, 0x0F},
> +	{0x466F, 0x0F},
> +	{0x470E, 0x09},
> +	{0x4909, 0xAB},
> +	{0x490B, 0x95},
> +	{0x4915, 0x5D},
> +	{0x4A5F, 0xFF},
> +	{0x4A61, 0xFF},
> +	{0x4A73, 0x62},
> +	{0x4A85, 0x00},
> +	{0x4A87, 0xFF},
> +
> +	/* embedded data */
> +	{0x5041, 0x04},
> +	{0x583C, 0x04},
> +	{0x620E, 0x04},
> +	{0x6EB2, 0x01},
> +	{0x6EB3, 0x00},
> +	{0x9300, 0x02},
> +
> +	/* imagequality */
> +	/* HDR setting */
> +	{0x3001, 0x07},
> +	{0x6D12, 0x3F},
> +	{0x6D13, 0xFF},
> +	{0x9344, 0x03},
> +	{0x9706, 0x10},
> +	{0x9707, 0x03},
> +	{0x9708, 0x03},
> +	{0x9E04, 0x01},
> +	{0x9E05, 0x00},
> +	{0x9E0C, 0x01},
> +	{0x9E0D, 0x02},
> +	{0x9E24, 0x00},
> +	{0x9E25, 0x8C},
> +	{0x9E26, 0x00},
> +	{0x9E27, 0x94},
> +	{0x9E28, 0x00},
> +	{0x9E29, 0x96},
> +
> +	/* CNR parameter setting */
> +	{0x69DB, 0x01},
> +
> +	/* Moire reduction */
> +	{0x6957, 0x01},
> +
> +	/* image enhancment */
> +	{0x6987, 0x17},
> +	{0x698A, 0x03},
> +	{0x698B, 0x03},
> +
> +	/* white balanace */
> +	{0x0B8E, 0x01},
> +	{0x0B8F, 0x00},
> +	{0x0B90, 0x01},
> +	{0x0B91, 0x00},
> +	{0x0B92, 0x01},
> +	{0x0B93, 0x00},
> +	{0x0B94, 0x01},
> +	{0x0B95, 0x00},
> +
> +	/* ATR setting */
> +	{0x6E50, 0x00},
> +	{0x6E51, 0x32},
> +	{0x9340, 0x00},
> +	{0x9341, 0x3C},
> +	{0x9342, 0x03},
> +	{0x9343, 0xFF},
> +	{IMX214_TABLE_END, 0x00}
> +};
> +
> +/*
> + * Declare modes in order, from biggest
> + * to smallest height.
> + */
> +static const struct imx214_mode {
> +	u32 width;
> +	u32 height;
> +	const struct reg_8 *reg_table;
> +} imx214_modes[] = {
> +	{
> +		.width = 4096,
> +		.height = 2304,
> +		.reg_table = mode_4096x2304,
> +	},
> +	{
> +		.width = 1920,
> +		.height = 1080,
> +		.reg_table = mode_1920x1080,
> +	},
> +};
> +
> +static inline struct imx214 *to_imx214(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct imx214, sd);
> +}
> +
> +static int imx214_set_power_on(struct imx214 *imx214)
> +{
> +	int ret;
> +
> +	ret = regulator_bulk_enable(IMX214_NUM_SUPPLIES, imx214->supplies);
> +	if (ret < 0) {
> +		dev_err(imx214->dev, "failed to enable regulators: %d\n", ret);
> +		return ret;
> +	}
> +
> +	usleep_range(2000, 3000);
> +
> +	ret = clk_prepare_enable(imx214->xclk);
> +	if (ret < 0) {
> +		regulator_bulk_disable(IMX214_NUM_SUPPLIES, imx214->supplies);
> +		dev_err(imx214->dev, "clk prepare enable failed\n");
> +		return ret;
> +	}
> +
> +	gpiod_set_value_cansleep(imx214->enable_gpio, 1);
> +	usleep_range(12000, 15000);
> +
> +	return 0;
> +}
> +
> +static void imx214_set_power_off(struct imx214 *imx214)
> +{
> +	gpiod_set_value_cansleep(imx214->enable_gpio, 0);
> +
> +	clk_disable_unprepare(imx214->xclk);
> +
> +	regulator_bulk_disable(IMX214_NUM_SUPPLIES, imx214->supplies);
> +	usleep_range(10, 20);
> +}
> +
> +static int imx214_s_power(struct v4l2_subdev *sd, int on)
> +{
> +	struct imx214 *imx214 = to_imx214(sd);
> +	int ret = 0;
> +
> +	on = !!on;
> +
> +	if (imx214->power_on == on)
> +		return 0;
> +
> +	if (on)
> +		ret = imx214_set_power_on(imx214);
> +	else
> +		imx214_set_power_off(imx214);
> +
> +	imx214->power_on = on;
> +
> +	return 0;
> +}
> +
> +static int imx214_enum_mbus_code(struct v4l2_subdev *sd,
> +				 struct v4l2_subdev_pad_config *cfg,
> +				 struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	if (code->index > 0)
> +		return -EINVAL;
> +
> +	code->code = IMX214_MBUS_CODE;
> +
> +	return 0;
> +}
> +
> +static int imx214_enum_frame_size(struct v4l2_subdev *subdev,
> +				  struct v4l2_subdev_pad_config *cfg,
> +				  struct v4l2_subdev_frame_size_enum *fse)
> +{
> +	if (fse->code != IMX214_MBUS_CODE)
> +		return -EINVAL;
> +
> +	if (fse->index >= ARRAY_SIZE(imx214_modes))
> +		return -EINVAL;
> +
> +	fse->min_width = fse->max_width = imx214_modes[fse->index].width;
> +	fse->min_height = fse->max_height = imx214_modes[fse->index].height;
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +static int imx214_s_register(struct v4l2_subdev *subdev,
> +			      const struct v4l2_dbg_register *reg)
> +{
> +	struct imx214 *imx214 = container_of(subdev, struct imx214, sd);
> +
> +	return regmap_write(imx214->regmap, reg->reg, reg->val);
> +}
> +
> +static int imx214_g_register(struct v4l2_subdev *subdev,
> +			      struct v4l2_dbg_register *reg)
> +{
> +	struct imx214 *imx214 = container_of(subdev, struct imx214, sd);
> +	unsigned int aux;
> +	int ret;
> +
> +	reg->size = 1;
> +	ret = regmap_read(imx214->regmap, reg->reg, &aux);
> +	reg->val = aux;
> +
> +	return ret;
> +}
> +#endif
> +
> +static const struct v4l2_subdev_core_ops imx214_core_ops = {
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +	.g_register = imx214_g_register,
> +	.s_register = imx214_s_register,
> +#endif
> +	.s_power = imx214_s_power,
> +};
> +
> +static struct v4l2_mbus_framefmt *
> +__imx214_get_pad_format(struct imx214 *imx214,
> +			struct v4l2_subdev_pad_config *cfg,
> +			unsigned int pad,
> +			enum v4l2_subdev_format_whence which)
> +{
> +	switch (which) {
> +	case V4L2_SUBDEV_FORMAT_TRY:
> +		return v4l2_subdev_get_try_format(&imx214->sd, cfg, pad);
> +	case V4L2_SUBDEV_FORMAT_ACTIVE:
> +		return &imx214->fmt;
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +static int imx214_get_format(struct v4l2_subdev *sd,
> +			     struct v4l2_subdev_pad_config *cfg,
> +			     struct v4l2_subdev_format *format)
> +{
> +	struct imx214 *imx214 = to_imx214(sd);
> +
> +	format->format = *__imx214_get_pad_format(imx214, cfg, format->pad,
> +						  format->which);
> +
> +	return 0;
> +}
> +
> +static struct v4l2_rect *
> +__imx214_get_pad_crop(struct imx214 *imx214, struct v4l2_subdev_pad_config *cfg,
> +		      unsigned int pad, enum v4l2_subdev_format_whence which)
> +{
> +	switch (which) {
> +	case V4L2_SUBDEV_FORMAT_TRY:
> +		return v4l2_subdev_get_try_crop(&imx214->sd, cfg, pad);
> +	case V4L2_SUBDEV_FORMAT_ACTIVE:
> +		return &imx214->crop;
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +static int imx214_find_mode(u32 height)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(imx214_modes) - 1 ; i++)
> +		if (height >= imx214_modes[i].height)
> +			return i;
> +
> +	return i;
> +}
> +
> +static int imx214_set_format(struct v4l2_subdev *sd,
> +			     struct v4l2_subdev_pad_config *cfg,
> +			     struct v4l2_subdev_format *format)
> +{
> +	struct imx214 *imx214 = to_imx214(sd);
> +	struct v4l2_mbus_framefmt *__format;
> +	struct v4l2_rect *__crop;
> +	int mode;
> +
> +	__crop = __imx214_get_pad_crop(imx214, cfg, format->pad, format->which);
> +
> +	mode = format ? imx214_find_mode(format->format.height) : 0;
> +
> +	__crop->width = imx214_modes[mode].width;
> +	__crop->height = imx214_modes[mode].height;
> +
> +	__format = __imx214_get_pad_format(imx214, cfg, format->pad,
> +					   format->which);
> +	__format->width = __crop->width;
> +	__format->height = __crop->height;
> +	__format->code = IMX214_MBUS_CODE;
> +	__format->field = V4L2_FIELD_NONE;
> +	__format->colorspace = V4L2_COLORSPACE_SRGB;
> +	__format->ycbcr_enc = V4L2_MAP_YCBCR_ENC_DEFAULT(__format->colorspace);
> +	__format->quantization = V4L2_MAP_QUANTIZATION_DEFAULT(true,
> +				__format->colorspace, __format->ycbcr_enc);
> +	__format->xfer_func = V4L2_MAP_XFER_FUNC_DEFAULT(__format->colorspace);
> +
> +	format->format = *__format;
> +
> +	return 0;
> +}
> +
> +static int imx214_get_selection(struct v4l2_subdev *sd,
> +				struct v4l2_subdev_pad_config *cfg,
> +				struct v4l2_subdev_selection *sel)
> +{
> +	struct imx214 *imx214 = to_imx214(sd);
> +
> +	if (sel->target != V4L2_SEL_TGT_CROP)
> +		return -EINVAL;
> +
> +	sel->r = *__imx214_get_pad_crop(imx214, cfg, sel->pad,
> +					sel->which);
> +	return 0;
> +}
> +
> +static int imx214_entity_init_cfg(struct v4l2_subdev *subdev,
> +				  struct v4l2_subdev_pad_config *cfg)
> +{
> +	struct v4l2_subdev_format fmt = { };
> +
> +	fmt.which = cfg ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
> +	fmt.format.width = imx214_modes[0].width;
> +	fmt.format.height = imx214_modes[0].height;
> +
> +	imx214_set_format(subdev, cfg, &fmt);
> +
> +	return 0;
> +}
> +
> +#define MAX_CMD 4
> +static int imx214_write_table(struct imx214 *imx214,
> +				const struct reg_8 table[])
> +{
> +	u8 vals[MAX_CMD];
> +	int ret;
> +	int i;
> +
> +	for (table = table; table->addr != IMX214_TABLE_END ; table++) {
> +		if (table->addr == IMX214_TABLE_WAIT_MS) {
> +			usleep_range(table->val * 1000,
> +				     table->val * 1000 + 500);
> +			continue;
> +		}
> +
> +		for (i = 0; i < MAX_CMD; i++) {
> +			if (table[i].addr != (table[0].addr + i))
> +				break;
> +			vals[i] = table[i].val;
> +		}
> +
> +		ret = regmap_bulk_write(imx214->regmap, table->addr, vals, i);
> +
> +		if (ret) {
> +			dev_err(imx214->dev, "write_table error: %d\n", ret);
> +			return ret;
> +		}
> +
> +		table += i - 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int imx214_s_stream(struct v4l2_subdev *subdev, int enable)
> +{
> +	struct imx214 *imx214 = to_imx214(subdev);
> +	int ret;
> +
> +	if (enable) {
> +		int mode = imx214_find_mode(imx214->fmt.height);
> +
> +		ret = imx214_write_table(imx214, mode_table_common);
> +		if (ret < 0) {
> +			dev_err(imx214->dev, "could not sent common table %d\n",
> +				ret);
> +			return ret;
> +		}
> +		ret = imx214_write_table(imx214, imx214_modes[mode].reg_table);
> +		if (ret < 0) {
> +			dev_err(imx214->dev, "could not sent mode table %d\n",
> +				ret);
> +			return ret;
> +		}
> +		ret = v4l2_ctrl_handler_setup(&imx214->ctrls);
> +		if (ret < 0) {
> +			dev_err(imx214->dev, "could not sync v4l2 controls\n");
> +			return ret;
> +		}
> +		ret = regmap_write(imx214->regmap, 0x100, 1);
> +		if (ret < 0) {
> +			dev_err(imx214->dev, "could not sent start table %d\n",
> +				ret);
> +			return ret;
> +		}
> +	} else {
> +		ret = regmap_write(imx214->regmap, 0x100, 0);
> +		if (ret < 0) {
> +			dev_err(imx214->dev, "could not sent stop table %d\n",
> +				ret);
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int imx214_g_frame_interval(struct v4l2_subdev *subdev,
> +				      struct v4l2_subdev_frame_interval *fival)
> +{
> +	fival->pad = 0;
> +	fival->interval.numerator = 1;
> +	fival->interval.denominator = IMX214_FPS;
> +
> +	return 0;
> +}
> +
> +static int imx214_enum_frame_interval(struct v4l2_subdev *subdev,
> +				struct v4l2_subdev_pad_config *cfg,
> +				struct v4l2_subdev_frame_interval_enum *fie)
> +{
> +	int mode;
> +
> +	if (fie->index != 0)
> +		return -EINVAL;
> +
> +	mode = imx214_find_mode(fie->height);
> +
> +	fie->code = IMX214_MBUS_CODE;
> +	fie->width = imx214_modes[mode].width;
> +	fie->height = imx214_modes[mode].height;
> +	fie->interval.numerator = 1;
> +	fie->interval.denominator = IMX214_FPS;
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_video_ops imx214_video_ops = {
> +	.s_stream = imx214_s_stream,
> +	.g_frame_interval = imx214_g_frame_interval,
> +	.s_frame_interval = imx214_g_frame_interval,
> +};
> +
> +static const struct v4l2_subdev_pad_ops imx214_subdev_pad_ops = {
> +	.enum_mbus_code = imx214_enum_mbus_code,
> +	.enum_frame_size = imx214_enum_frame_size,
> +	.enum_frame_interval = imx214_enum_frame_interval,
> +	.get_fmt = imx214_get_format,
> +	.set_fmt = imx214_set_format,
> +	.get_selection = imx214_get_selection,
> +	.init_cfg = imx214_entity_init_cfg,
> +};
> +
> +static const struct v4l2_subdev_ops imx214_subdev_ops = {
> +	.core = &imx214_core_ops,
> +	.video = &imx214_video_ops,
> +	.pad = &imx214_subdev_pad_ops,
> +};
> +
> +static const struct regmap_config sensor_regmap_config = {
> +	.reg_bits = 16,
> +	.val_bits = 8,
> +	.cache_type = REGCACHE_RBTREE,
> +};
> +
> +static int imx214_get_regulators(struct device *dev, struct imx214 *imx214)
> +{
> +	int i;
> +
> +	for (i = 0; i < IMX214_NUM_SUPPLIES; i++)
> +		imx214->supplies[i].supply = imx214_supply_name[i];
> +
> +	return devm_regulator_bulk_get(dev,
> +				       IMX214_NUM_SUPPLIES,
> +				       imx214->supplies);
> +}
> +
> +static int imx214_parse_fwnode(struct device *dev)
> +{
> +	struct fwnode_handle *endpoint;
> +	struct v4l2_fwnode_endpoint *bus_cfg;
> +	int i;
> +	int ret = 0;
> +
> +	endpoint = fwnode_graph_get_next_endpoint(dev_fwnode(dev), NULL);
> +	if (!endpoint) {
> +		dev_err(dev, "endpoint node not found\n");
> +		return -EINVAL;
> +	}
> +
> +	bus_cfg = v4l2_fwnode_endpoint_alloc_parse(endpoint);
> +	if (IS_ERR(bus_cfg)) {
> +		dev_err(dev, "parsing endpoint node failed\n");
> +		return PTR_ERR(bus_cfg);
> +	}
> +
> +	if (bus_cfg->bus_type != V4L2_MBUS_CSI2) {
> +		dev_err(dev, "invalid bus type (%u), must be CSI2 (%u)\n",
> +			bus_cfg->bus_type, V4L2_MBUS_CSI2);
> +		ret = -EINVAL;
> +		goto done;
> +	}
> +
> +	for (i = 0 ; i < bus_cfg->nr_of_link_frequencies; i++)
> +		if (bus_cfg->link_frequencies[i] == IMX214_DEFAULT_LINK_FREQ)
> +			break;
> +
> +	if (i == bus_cfg->nr_of_link_frequencies) {
> +		dev_err(dev, "link-frequencies %d not supported, Please review your DT\n",
> +			IMX214_DEFAULT_LINK_FREQ);
> +		ret = -EINVAL;
> +		goto done;
> +	}
> +
> +done:
> +	v4l2_fwnode_endpoint_free(bus_cfg);
> +	fwnode_handle_put(endpoint);
> +	return ret;
> +}
> +
> +static int imx214_probe(struct i2c_client *client)
> +{
> +	struct device *dev = &client->dev;
> +	struct imx214 *imx214;
> +	int ret;
> +	static const s64 link_freq[] = {
> +		IMX214_DEFAULT_LINK_FREQ,
> +	};
> +
> +	ret = imx214_parse_fwnode(dev);
> +	if (ret)
> +		return ret;
> +
> +	imx214 = devm_kzalloc(dev, sizeof(*imx214), GFP_KERNEL);
> +	if (!imx214)
> +		return -ENOMEM;
> +
> +	imx214->dev = dev;
> +
> +	imx214->xclk = devm_clk_get(dev, NULL);
> +	if (IS_ERR(imx214->xclk)) {
> +		dev_err(dev, "could not get xclk");
> +		return PTR_ERR(imx214->xclk);
> +	}
> +
> +	ret = clk_set_rate(imx214->xclk, IMX214_DEFAULT_CLK_FREQ);
> +	if (ret) {
> +		dev_err(dev, "could not set xclk frequency\n");
> +		return ret;
> +	}
> +
> +	ret = imx214_get_regulators(dev, imx214);
> +	if (ret < 0) {
> +		dev_err(dev, "cannot get regulators\n");
> +		return ret;
> +	}
> +
> +	imx214->enable_gpio = devm_gpiod_get(dev, "enable", GPIOD_OUT_LOW);
> +	if (IS_ERR(imx214->enable_gpio)) {
> +		dev_err(dev, "cannot get enable gpio\n");
> +		return PTR_ERR(imx214->enable_gpio);
> +	}
> +
> +	imx214->regmap = devm_regmap_init_i2c(client, &sensor_regmap_config);
> +	if (IS_ERR(imx214->regmap)) {
> +		dev_err(dev, "regmap init failed\n");
> +		return PTR_ERR(imx214->regmap);
> +	}
> +
> +	v4l2_ctrl_handler_init(&imx214->ctrls, 2);
> +
> +	imx214->pixel_rate = v4l2_ctrl_new_std(&imx214->ctrls, NULL,
> +					       V4L2_CID_PIXEL_RATE, 0,
> +					       IMX214_DEFAULT_PIXEL_RATE, 1,
> +					       IMX214_DEFAULT_PIXEL_RATE);
> +	imx214->link_freq = v4l2_ctrl_new_int_menu(&imx214->ctrls, NULL,
> +						   V4L2_CID_LINK_FREQ,
> +						   ARRAY_SIZE(link_freq) - 1,
> +						   0, link_freq);
> +	if (imx214->link_freq)
> +		imx214->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
> +	ret = imx214->ctrls.error;
> +	if (ret) {
> +		dev_err(&client->dev, "%s control init failed (%d)\n",
> +				__func__, ret);
> +		goto free_ctrl;
> +	}
> +
> +	imx214->sd.ctrl_handler = &imx214->ctrls;
> +	ret = v4l2_ctrl_handler_setup(imx214->sd.ctrl_handler);
> +	if (ret) {
> +		dev_err(&client->dev,
> +			"Error %d setting default controls\n", ret);
> +		goto free_ctrl;
> +	}
> +
> +	v4l2_i2c_subdev_init(&imx214->sd, client, &imx214_subdev_ops);
> +	imx214->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	imx214->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	imx214->sd.dev = &client->dev;
> +	imx214->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
> +
> +	ret = media_entity_pads_init(&imx214->sd.entity, 1, &imx214->pad);
> +	if (ret < 0) {
> +		dev_err(dev, "could not register media entity\n");
> +		goto free_ctrl;
> +	}
> +
> +	imx214_entity_init_cfg(&imx214->sd, NULL);
> +
> +	ret = v4l2_async_register_subdev_sensor_common(&imx214->sd);
> +	if (ret < 0) {
> +		dev_err(dev, "could not register v4l2 device\n");
> +		goto free_entity;
> +	}
> +
> +	return 0;
> +
> +free_entity:
> +	media_entity_cleanup(&imx214->sd.entity);
> +free_ctrl:
> +	v4l2_ctrl_handler_free(&imx214->ctrls);
> +
> +	return ret;
> +}
> +
> +static int imx214_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct imx214 *imx214 = to_imx214(sd);
> +
> +	v4l2_async_unregister_subdev(&imx214->sd);
> +	media_entity_cleanup(&imx214->sd.entity);
> +	v4l2_ctrl_handler_free(&imx214->ctrls);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id imx214_of_match[] = {
> +	{ .compatible = "sony,imx214" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, imx214_of_match);
> +
> +static struct i2c_driver imx214_i2c_driver = {
> +	.driver = {
> +		.of_match_table = imx214_of_match,
> +		.name  = "imx214",
> +	},
> +	.probe_new  = imx214_probe,
> +	.remove = imx214_remove,
> +};
> +
> +module_i2c_driver(imx214_i2c_driver);
> +
> +MODULE_DESCRIPTION("Sony IMX214 Camera drier");
> +MODULE_AUTHOR("Ricardo Ribalda <ricardo.ribalda@gmail.com>");
> +MODULE_LICENSE("GPL v2");
> --
> 2.19.0
>

--FN+gV9K+162wdwwF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbtHWiAAoJEHI0Bo8WoVY8RPcP/joqVECqfSjpnleqkz0Vlptl
EFZtcKvtR+MinVpcYmSxKWFaSAJRKJX7D/aLokDPzZXI9Z+wdfNIsFNgaLZ1RNrC
WqMPNxnwRvE7Us7gNxpIbnfm5badr6pQp0cywmKDvskxfi3Up3dsMSPIBE0YSYOl
97xW2hDzFJcRX5lAHlggSYOW6DdX2fyPgjhiJDCoJIzTJ1SHcQQTUVz5h6sBFDdj
Do6ddqTK3/G2aTTFyWAWYOaxem0HBvybC6Cf+R/LfPauAABeLeeg3Nx/AiI/eKFz
ljYKbGkdLGOFa4LGA0S0k29N3QH34bFxyk5VU0q0f1wIUXO5M21f0kzge5IGG/k8
dvl/De6sBWOU+Yxx/Nt9HCUA2Cruyaz9ps90BhciBXZFoPHtCAVte0gdYkDfTj+W
tjoV0d/jiVa0uBvsbWTOzjhw7gh69QmiTkgl4J71T6+oQIGi1EhbaLkWbas8m3+Z
X4Pf4QFhkyDxrr2/XCaU/kfhmVETOq/iRhGwOK10bSPxOBi3AeBnAyK1gfaC8D0z
K6ihdKX9JizfFTQ6rlOaMqFwioNE9VmbF22fcso/hzuT0H54N/4O5N3qABkQf44r
KrdeyK0wc04WozX9EiHIAgjiNET6Rzw/Ye1ayFFJ0LBtofDzzugq1AHnzEdviv0e
YPppegaqRuvs1k9JXZdb
=IT9B
-----END PGP SIGNATURE-----

--FN+gV9K+162wdwwF--
