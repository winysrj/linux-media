Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38549 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbeJDDOe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2018 23:14:34 -0400
MIME-Version: 1.0
References: <20181003130951.19140-1-ricardo.ribalda@gmail.com> <20181003194658.zj6jkfmpbrkmnlen@kekkonen.localdomain>
In-Reply-To: <20181003194658.zj6jkfmpbrkmnlen@kekkonen.localdomain>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 3 Oct 2018 22:24:17 +0200
Message-ID: <CAPybu_0Og50WhkO2hHmg5cLQ6a2sx+KEp3_DOTKS=AJ2Shf3YQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] [media] imx214: Add imx214 camera sensor driver
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>, jacopo@jmondi.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari

Thanks for your comments. I am pushing the new version to
https://github.com/ribalda/linux/tree/imx214-v6

Tomorrow morning after testing it on real hw I will send it to the list.

Compared to v1, the driver now looks really good :)

On Wed, Oct 3, 2018 at 9:47 PM Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
>
> Hi Ricardo,
>
> Just a few more little comments.
>
> On Wed, Oct 03, 2018 at 03:09:51PM +0200, Ricardo Ribalda Delgado wrote:
> > Add a V4L2 sub-device driver for the Sony IMX214 image sensor.
> > This is a camera sensor using the I2C bus for control and the
> > CSI-2 bus for data.
> >
> > Tested on a DB820c alike board with Intrinsyc Open-Q 13MP camera.
> >
> > Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> > Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
> > ---
> > Changelog from v3:
> >
> > Sakari Ailus (Thanks!):
> > -Enable runtime PM
> > -Exposure control
> > -Use v4l2_find_nearest_size
> >
> > Notes:
> > - v4l2_find_nearest_size is my new best friend. great hack!
> > - I had to disable pm asap to avoid setting any control if we are not in
> > streamon, otherwise the qcom i2c would not work.
> >
> >
> >
> >  MAINTAINERS                |    8 +
> >  drivers/media/i2c/Kconfig  |   11 +
> >  drivers/media/i2c/Makefile |    1 +
> >  drivers/media/i2c/imx214.c | 1096 ++++++++++++++++++++++++++++++++++++
> >  4 files changed, 1116 insertions(+)
> >  create mode 100644 drivers/media/i2c/imx214.c
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 9989925f658d..2ae68894e700 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -13521,6 +13521,14 @@ S:   Maintained
> >  F:   drivers/ssb/
> >  F:   include/linux/ssb/
> >
> > +SONY IMX214 SENSOR DRIVER
> > +M:   Ricardo Ribalda <ricardo.ribalda@gmail.com>
> > +L:   linux-media@vger.kernel.org
> > +T:   git git://linuxtv.org/media_tree.git
> > +S:   Maintained
> > +F:   drivers/media/i2c/imx214.c
> > +F:   Documentation/devicetree/bindings/media/i2c/imx214.txt
> > +
> >  SONY IMX258 SENSOR DRIVER
> >  M:   Sakari Ailus <sakari.ailus@linux.intel.com>
> >  L:   linux-media@vger.kernel.org
> > diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> > index bfdb494686bf..870976dee4a2 100644
> > --- a/drivers/media/i2c/Kconfig
> > +++ b/drivers/media/i2c/Kconfig
> > @@ -595,6 +595,17 @@ config VIDEO_APTINA_PLL
> >  config VIDEO_SMIAPP_PLL
> >       tristate
> >
> > +config VIDEO_IMX214
> > +     tristate "Sony IMX214 sensor support"
> > +     depends on GPIOLIB && I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> > +     depends on MEDIA_CAMERA_SUPPORT
>
> Please add:
>
> depends on V4L2_FWNODE
>
> > +     help
> > +       This is a Video4Linux2 sensor driver for the Sony
> > +       IMX214 camera.
> > +
> > +       To compile this driver as a module, choose M here: the
> > +       module will be called imx214.
> > +
> >  config VIDEO_IMX258
> >       tristate "Sony IMX258 sensor support"
> >       depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> > diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> > index a94eb03d10d4..61305edc6165 100644
> > --- a/drivers/media/i2c/Makefile
> > +++ b/drivers/media/i2c/Makefile
> > @@ -106,6 +106,7 @@ obj-$(CONFIG_VIDEO_I2C)           += video-i2c.o
> >  obj-$(CONFIG_VIDEO_ML86V7667)        += ml86v7667.o
> >  obj-$(CONFIG_VIDEO_OV2659)   += ov2659.o
> >  obj-$(CONFIG_VIDEO_TC358743) += tc358743.o
> > +obj-$(CONFIG_VIDEO_IMX214)   += imx214.o
> >  obj-$(CONFIG_VIDEO_IMX258)   += imx258.o
> >  obj-$(CONFIG_VIDEO_IMX274)   += imx274.o
> >
> > diff --git a/drivers/media/i2c/imx214.c b/drivers/media/i2c/imx214.c
> > new file mode 100644
> > index 000000000000..0668c3a54053
> > --- /dev/null
> > +++ b/drivers/media/i2c/imx214.c
> > @@ -0,0 +1,1096 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * imx214.c - imx214 sensor driver
> > + *
> > + * Copyright 2018 Qtechnology A/S
> > + *
> > + * Ricardo Ribalda <ricardo.ribalda@gmail.com>
> > + */
> > +#include <linux/clk.h>
> > +#include <linux/delay.h>
> > +#include <linux/gpio/consumer.h>
> > +#include <linux/i2c.h>
> > +#include <linux/module.h>
> > +#include <linux/pm_runtime.h>
> > +#include <linux/regmap.h>
> > +#include <linux/regulator/consumer.h>
> > +#include <media/media-entity.h>
> > +#include <media/v4l2-ctrls.h>
> > +#include <media/v4l2-fwnode.h>
> > +#include <media/v4l2-subdev.h>
> > +
> > +#define IMX214_DEFAULT_CLK_FREQ      24000000
> > +#define IMX214_DEFAULT_LINK_FREQ 480000000
> > +#define IMX214_DEFAULT_PIXEL_RATE ((IMX214_DEFAULT_LINK_FREQ * 8LL) / 10)
> > +#define IMX214_WIDTH 4096
> > +#define IMX214_HEIGHT 2304
> > +#define IMX214_FPS 30
> > +#define IMX214_MBUS_CODE MEDIA_BUS_FMT_SRGGB10_1X10
> > +
> > +static const char * const imx214_supply_name[] = {
> > +     "vdda",
> > +     "vddd",
> > +     "vdddo",
> > +};
> > +
> > +#define IMX214_NUM_SUPPLIES ARRAY_SIZE(imx214_supply_name)
> > +
> > +struct imx214 {
> > +     struct device *dev;
> > +     struct clk *xclk;
> > +     struct regmap *regmap;
> > +
> > +     struct v4l2_subdev sd;
> > +     struct media_pad pad;
> > +     struct v4l2_mbus_framefmt fmt;
> > +     struct v4l2_rect crop;
> > +
> > +     struct v4l2_ctrl_handler ctrls;
> > +     struct v4l2_ctrl *pixel_rate;
> > +     struct v4l2_ctrl *link_freq;
> > +     struct v4l2_ctrl *exposure;
> > +
> > +     struct regulator_bulk_data      supplies[IMX214_NUM_SUPPLIES];
> > +
> > +     struct gpio_desc *enable_gpio;
> > +
> > +     bool streaming;
> > +};
> > +
> > +struct reg_8 {
> > +     u16 addr;
> > +     u8 val;
> > +};
> > +
> > +enum {
> > +     IMX214_TABLE_WAIT_MS = 0,
> > +     IMX214_TABLE_END,
> > +     IMX214_MAX_RETRIES,
> > +     IMX214_WAIT_MS
> > +};
> > +
> > +/*From imx214_mode_tbls.h*/
> > +static const struct reg_8 mode_4096x2304[] = {
> > +     {0x0114, 0x03},
> > +     {0x0220, 0x00},
> > +     {0x0221, 0x11},
> > +     {0x0222, 0x01},
> > +     {0x0340, 0x0C},
> > +     {0x0341, 0x7A},
> > +     {0x0342, 0x13},
> > +     {0x0343, 0x90},
> > +     {0x0344, 0x00},
> > +     {0x0345, 0x38},
> > +     {0x0346, 0x01},
> > +     {0x0347, 0x98},
> > +     {0x0348, 0x10},
> > +     {0x0349, 0x37},
> > +     {0x034A, 0x0A},
> > +     {0x034B, 0x97},
> > +     {0x0381, 0x01},
> > +     {0x0383, 0x01},
> > +     {0x0385, 0x01},
> > +     {0x0387, 0x01},
> > +     {0x0900, 0x00},
> > +     {0x0901, 0x00},
> > +     {0x0902, 0x00},
> > +     {0x3000, 0x35},
> > +     {0x3054, 0x01},
> > +     {0x305C, 0x11},
> > +
> > +     {0x0112, 0x0A},
> > +     {0x0113, 0x0A},
> > +     {0x034C, 0x10},
> > +     {0x034D, 0x00},
> > +     {0x034E, 0x09},
> > +     {0x034F, 0x00},
> > +     {0x0401, 0x00},
> > +     {0x0404, 0x00},
> > +     {0x0405, 0x10},
> > +     {0x0408, 0x00},
> > +     {0x0409, 0x00},
> > +     {0x040A, 0x00},
> > +     {0x040B, 0x00},
> > +     {0x040C, 0x10},
> > +     {0x040D, 0x00},
> > +     {0x040E, 0x09},
> > +     {0x040F, 0x00},
> > +
> > +     {0x0301, 0x05},
> > +     {0x0303, 0x02},
> > +     {0x0305, 0x03},
> > +     {0x0306, 0x00},
> > +     {0x0307, 0x96},
> > +     {0x0309, 0x0A},
> > +     {0x030B, 0x01},
> > +     {0x0310, 0x00},
> > +
> > +     {0x0820, 0x12},
> > +     {0x0821, 0xC0},
> > +     {0x0822, 0x00},
> > +     {0x0823, 0x00},
> > +
> > +     {0x3A03, 0x09},
> > +     {0x3A04, 0x50},
> > +     {0x3A05, 0x01},
> > +
> > +     {0x0B06, 0x01},
> > +     {0x30A2, 0x00},
> > +
> > +     {0x30B4, 0x00},
> > +
> > +     {0x3A02, 0xFF},
> > +
> > +     {0x3011, 0x00},
> > +     {0x3013, 0x01},
> > +
> > +     {0x0202, 0x0C},
> > +     {0x0203, 0x70},
> > +     {0x0224, 0x01},
> > +     {0x0225, 0xF4},
> > +
> > +     {0x0204, 0x00},
> > +     {0x0205, 0x00},
> > +     {0x020E, 0x01},
> > +     {0x020F, 0x00},
> > +     {0x0210, 0x01},
> > +     {0x0211, 0x00},
> > +     {0x0212, 0x01},
> > +     {0x0213, 0x00},
> > +     {0x0214, 0x01},
> > +     {0x0215, 0x00},
> > +     {0x0216, 0x00},
> > +     {0x0217, 0x00},
> > +
> > +     {0x4170, 0x00},
> > +     {0x4171, 0x10},
> > +     {0x4176, 0x00},
> > +     {0x4177, 0x3C},
> > +     {0xAE20, 0x04},
> > +     {0xAE21, 0x5C},
> > +
> > +     {IMX214_TABLE_WAIT_MS, 10},
> > +     {0x0138, 0x01},
> > +     {IMX214_TABLE_END, 0x00}
> > +};
> > +
> > +static const struct reg_8 mode_1920x1080[] = {
> > +     {0x0114, 0x03},
> > +     {0x0220, 0x00},
> > +     {0x0221, 0x11},
> > +     {0x0222, 0x01},
> > +     {0x0340, 0x0C},
> > +     {0x0341, 0x7A},
> > +     {0x0342, 0x13},
> > +     {0x0343, 0x90},
> > +     {0x0344, 0x04},
> > +     {0x0345, 0x78},
> > +     {0x0346, 0x03},
> > +     {0x0347, 0xFC},
> > +     {0x0348, 0x0B},
> > +     {0x0349, 0xF7},
> > +     {0x034A, 0x08},
> > +     {0x034B, 0x33},
> > +     {0x0381, 0x01},
> > +     {0x0383, 0x01},
> > +     {0x0385, 0x01},
> > +     {0x0387, 0x01},
> > +     {0x0900, 0x00},
> > +     {0x0901, 0x00},
> > +     {0x0902, 0x00},
> > +     {0x3000, 0x35},
> > +     {0x3054, 0x01},
> > +     {0x305C, 0x11},
> > +
> > +     {0x0112, 0x0A},
> > +     {0x0113, 0x0A},
> > +     {0x034C, 0x07},
> > +     {0x034D, 0x80},
> > +     {0x034E, 0x04},
> > +     {0x034F, 0x38},
> > +     {0x0401, 0x00},
> > +     {0x0404, 0x00},
> > +     {0x0405, 0x10},
> > +     {0x0408, 0x00},
> > +     {0x0409, 0x00},
> > +     {0x040A, 0x00},
> > +     {0x040B, 0x00},
> > +     {0x040C, 0x07},
> > +     {0x040D, 0x80},
> > +     {0x040E, 0x04},
> > +     {0x040F, 0x38},
> > +
> > +     {0x0301, 0x05},
> > +     {0x0303, 0x02},
> > +     {0x0305, 0x03},
> > +     {0x0306, 0x00},
> > +     {0x0307, 0x96},
> > +     {0x0309, 0x0A},
> > +     {0x030B, 0x01},
> > +     {0x0310, 0x00},
> > +
> > +     {0x0820, 0x12},
> > +     {0x0821, 0xC0},
> > +     {0x0822, 0x00},
> > +     {0x0823, 0x00},
> > +
> > +     {0x3A03, 0x04},
> > +     {0x3A04, 0xF8},
> > +     {0x3A05, 0x02},
> > +
> > +     {0x0B06, 0x01},
> > +     {0x30A2, 0x00},
> > +
> > +     {0x30B4, 0x00},
> > +
> > +     {0x3A02, 0xFF},
> > +
> > +     {0x3011, 0x00},
> > +     {0x3013, 0x01},
> > +
> > +     {0x0202, 0x0C},
> > +     {0x0203, 0x70},
> > +     {0x0224, 0x01},
> > +     {0x0225, 0xF4},
> > +
> > +     {0x0204, 0x00},
> > +     {0x0205, 0x00},
> > +     {0x020E, 0x01},
> > +     {0x020F, 0x00},
> > +     {0x0210, 0x01},
> > +     {0x0211, 0x00},
> > +     {0x0212, 0x01},
> > +     {0x0213, 0x00},
> > +     {0x0214, 0x01},
> > +     {0x0215, 0x00},
> > +     {0x0216, 0x00},
> > +     {0x0217, 0x00},
> > +
> > +     {0x4170, 0x00},
> > +     {0x4171, 0x10},
> > +     {0x4176, 0x00},
> > +     {0x4177, 0x3C},
> > +     {0xAE20, 0x04},
> > +     {0xAE21, 0x5C},
> > +
> > +     {IMX214_TABLE_WAIT_MS, 10},
> > +     {0x0138, 0x01},
> > +     {IMX214_TABLE_END, 0x00}
> > +};
> > +
> > +static const struct reg_8 mode_table_common[] = {
> > +     /* software reset */
> > +
> > +     /* software standby settings */
> > +     {0x0100, 0x00},
> > +
> > +     /* ATR setting */
> > +     {0x9300, 0x02},
> > +
> > +     /* external clock setting */
> > +     {0x0136, 0x18},
> > +     {0x0137, 0x00},
> > +
> > +     /* global setting */
> > +     /* basic config */
> > +     {0x0101, 0x00},
> > +     {0x0105, 0x01},
> > +     {0x0106, 0x01},
> > +     {0x4550, 0x02},
> > +     {0x4601, 0x00},
> > +     {0x4642, 0x05},
> > +     {0x6227, 0x11},
> > +     {0x6276, 0x00},
> > +     {0x900E, 0x06},
> > +     {0xA802, 0x90},
> > +     {0xA803, 0x11},
> > +     {0xA804, 0x62},
> > +     {0xA805, 0x77},
> > +     {0xA806, 0xAE},
> > +     {0xA807, 0x34},
> > +     {0xA808, 0xAE},
> > +     {0xA809, 0x35},
> > +     {0xA80A, 0x62},
> > +     {0xA80B, 0x83},
> > +     {0xAE33, 0x00},
> > +
> > +     /* analog setting */
> > +     {0x4174, 0x00},
> > +     {0x4175, 0x11},
> > +     {0x4612, 0x29},
> > +     {0x461B, 0x12},
> > +     {0x461F, 0x06},
> > +     {0x4635, 0x07},
> > +     {0x4637, 0x30},
> > +     {0x463F, 0x18},
> > +     {0x4641, 0x0D},
> > +     {0x465B, 0x12},
> > +     {0x465F, 0x11},
> > +     {0x4663, 0x11},
> > +     {0x4667, 0x0F},
> > +     {0x466F, 0x0F},
> > +     {0x470E, 0x09},
> > +     {0x4909, 0xAB},
> > +     {0x490B, 0x95},
> > +     {0x4915, 0x5D},
> > +     {0x4A5F, 0xFF},
> > +     {0x4A61, 0xFF},
> > +     {0x4A73, 0x62},
> > +     {0x4A85, 0x00},
> > +     {0x4A87, 0xFF},
> > +
> > +     /* embedded data */
> > +     {0x5041, 0x04},
> > +     {0x583C, 0x04},
> > +     {0x620E, 0x04},
> > +     {0x6EB2, 0x01},
> > +     {0x6EB3, 0x00},
> > +     {0x9300, 0x02},
> > +
> > +     /* imagequality */
> > +     /* HDR setting */
> > +     {0x3001, 0x07},
> > +     {0x6D12, 0x3F},
> > +     {0x6D13, 0xFF},
> > +     {0x9344, 0x03},
> > +     {0x9706, 0x10},
> > +     {0x9707, 0x03},
> > +     {0x9708, 0x03},
> > +     {0x9E04, 0x01},
> > +     {0x9E05, 0x00},
> > +     {0x9E0C, 0x01},
> > +     {0x9E0D, 0x02},
> > +     {0x9E24, 0x00},
> > +     {0x9E25, 0x8C},
> > +     {0x9E26, 0x00},
> > +     {0x9E27, 0x94},
> > +     {0x9E28, 0x00},
> > +     {0x9E29, 0x96},
> > +
> > +     /* CNR parameter setting */
> > +     {0x69DB, 0x01},
> > +
> > +     /* Moire reduction */
> > +     {0x6957, 0x01},
> > +
> > +     /* image enhancment */
> > +     {0x6987, 0x17},
> > +     {0x698A, 0x03},
> > +     {0x698B, 0x03},
> > +
> > +     /* white balanace */
> > +     {0x0B8E, 0x01},
> > +     {0x0B8F, 0x00},
> > +     {0x0B90, 0x01},
> > +     {0x0B91, 0x00},
> > +     {0x0B92, 0x01},
> > +     {0x0B93, 0x00},
> > +     {0x0B94, 0x01},
> > +     {0x0B95, 0x00},
> > +
> > +     /* ATR setting */
> > +     {0x6E50, 0x00},
> > +     {0x6E51, 0x32},
> > +     {0x9340, 0x00},
> > +     {0x9341, 0x3C},
> > +     {0x9342, 0x03},
> > +     {0x9343, 0xFF},
> > +     {IMX214_TABLE_END, 0x00}
> > +};
> > +
> > +/*
> > + * Declare modes in order, from biggest
> > + * to smallest height.
> > + */
> > +static const struct imx214_mode {
> > +     u32 width;
> > +     u32 height;
> > +     const struct reg_8 *reg_table;
> > +} imx214_modes[] = {
> > +     {
> > +             .width = 4096,
> > +             .height = 2304,
> > +             .reg_table = mode_4096x2304,
> > +     },
> > +     {
> > +             .width = 1920,
> > +             .height = 1080,
> > +             .reg_table = mode_1920x1080,
> > +     },
> > +};
> > +
> > +static inline struct imx214 *to_imx214(struct v4l2_subdev *sd)
> > +{
> > +     return container_of(sd, struct imx214, sd);
> > +}
> > +
> > +static int imx214_set_power_on(struct imx214 *imx214)
> > +{
> > +     int ret;
> > +
> > +     ret = regulator_bulk_enable(IMX214_NUM_SUPPLIES, imx214->supplies);
> > +     if (ret < 0) {
> > +             dev_err(imx214->dev, "failed to enable regulators: %d\n", ret);
> > +             return ret;
> > +     }
> > +
> > +     usleep_range(2000, 3000);
> > +
> > +     ret = clk_prepare_enable(imx214->xclk);
> > +     if (ret < 0) {
> > +             regulator_bulk_disable(IMX214_NUM_SUPPLIES, imx214->supplies);
> > +             dev_err(imx214->dev, "clk prepare enable failed\n");
> > +             return ret;
> > +     }
> > +
> > +     gpiod_set_value_cansleep(imx214->enable_gpio, 1);
> > +     usleep_range(12000, 15000);
> > +
> > +     return 0;
> > +}
> > +
> > +static void imx214_set_power_off(struct imx214 *imx214)
> > +{
> > +     gpiod_set_value_cansleep(imx214->enable_gpio, 0);
> > +
> > +     clk_disable_unprepare(imx214->xclk);
> > +
> > +     regulator_bulk_disable(IMX214_NUM_SUPPLIES, imx214->supplies);
> > +     usleep_range(10, 20);
> > +}
> > +
> > +static int imx214_enum_mbus_code(struct v4l2_subdev *sd,
> > +                              struct v4l2_subdev_pad_config *cfg,
> > +                              struct v4l2_subdev_mbus_code_enum *code)
> > +{
> > +     if (code->index > 0)
> > +             return -EINVAL;
> > +
> > +     code->code = IMX214_MBUS_CODE;
> > +
> > +     return 0;
> > +}
> > +
> > +static int imx214_enum_frame_size(struct v4l2_subdev *subdev,
> > +                               struct v4l2_subdev_pad_config *cfg,
> > +                               struct v4l2_subdev_frame_size_enum *fse)
> > +{
> > +     if (fse->code != IMX214_MBUS_CODE)
> > +             return -EINVAL;
> > +
> > +     if (fse->index >= ARRAY_SIZE(imx214_modes))
>
> array_index_nospec() ?? I find it scary that you'd need that in drivers.
> :-o
>
> > +             return -EINVAL;
> > +
> > +     fse->min_width = fse->max_width = imx214_modes[fse->index].width;
> > +     fse->min_height = fse->max_height = imx214_modes[fse->index].height;
> > +
> > +     return 0;
> > +}
> > +
> > +#ifdef CONFIG_VIDEO_ADV_DEBUG
> > +static int imx214_s_register(struct v4l2_subdev *subdev,
> > +                           const struct v4l2_dbg_register *reg)
> > +{
> > +     struct imx214 *imx214 = container_of(subdev, struct imx214, sd);
> > +
> > +     return regmap_write(imx214->regmap, reg->reg, reg->val);
> > +}
> > +
> > +static int imx214_g_register(struct v4l2_subdev *subdev,
> > +                           struct v4l2_dbg_register *reg)
> > +{
> > +     struct imx214 *imx214 = container_of(subdev, struct imx214, sd);
> > +     unsigned int aux;
> > +     int ret;
> > +
> > +     reg->size = 1;
> > +     ret = regmap_read(imx214->regmap, reg->reg, &aux);
> > +     reg->val = aux;
> > +
> > +     return ret;
> > +}
> > +#endif
> > +
> > +static const struct v4l2_subdev_core_ops imx214_core_ops = {
> > +#ifdef CONFIG_VIDEO_ADV_DEBUG
> > +     .g_register = imx214_g_register,
> > +     .s_register = imx214_s_register,
> > +#endif
> > +};
> > +
> > +static struct v4l2_mbus_framefmt *
> > +__imx214_get_pad_format(struct imx214 *imx214,
> > +                     struct v4l2_subdev_pad_config *cfg,
> > +                     unsigned int pad,
> > +                     enum v4l2_subdev_format_whence which)
> > +{
> > +     switch (which) {
> > +     case V4L2_SUBDEV_FORMAT_TRY:
> > +             return v4l2_subdev_get_try_format(&imx214->sd, cfg, pad);
> > +     case V4L2_SUBDEV_FORMAT_ACTIVE:
> > +             return &imx214->fmt;
> > +     default:
> > +             return NULL;
> > +     }
> > +}
> > +
> > +static int imx214_get_format(struct v4l2_subdev *sd,
> > +                          struct v4l2_subdev_pad_config *cfg,
> > +                          struct v4l2_subdev_format *format)
> > +{
> > +     struct imx214 *imx214 = to_imx214(sd);
> > +
> > +     format->format = *__imx214_get_pad_format(imx214, cfg, format->pad,
> > +                                               format->which);
> > +
> > +     return 0;
> > +}
> > +
> > +static struct v4l2_rect *
> > +__imx214_get_pad_crop(struct imx214 *imx214, struct v4l2_subdev_pad_config *cfg,
> > +                   unsigned int pad, enum v4l2_subdev_format_whence which)
> > +{
> > +     switch (which) {
> > +     case V4L2_SUBDEV_FORMAT_TRY:
> > +             return v4l2_subdev_get_try_crop(&imx214->sd, cfg, pad);
> > +     case V4L2_SUBDEV_FORMAT_ACTIVE:
> > +             return &imx214->crop;
> > +     default:
> > +             return NULL;
> > +     }
> > +}
> > +
> > +static int imx214_set_format(struct v4l2_subdev *sd,
> > +                          struct v4l2_subdev_pad_config *cfg,
> > +                          struct v4l2_subdev_format *format)
> > +{
> > +     struct imx214 *imx214 = to_imx214(sd);
> > +     struct v4l2_mbus_framefmt *__format;
> > +     struct v4l2_rect *__crop;
> > +     const struct imx214_mode *mode;
> > +
> > +     __crop = __imx214_get_pad_crop(imx214, cfg, format->pad, format->which);
> > +
> > +     if (format)
> > +             mode = v4l2_find_nearest_size(imx214_modes,
> > +                             ARRAY_SIZE(imx214_modes), width, height,
> > +                             format->format.width, format->format.height);
> > +     else
> > +             mode = &imx214_modes[0];
> > +
> > +
>
> Extra newline.
>
> > +     __crop->width = mode->width;
> > +     __crop->height = mode->height;
> > +
> > +     __format = __imx214_get_pad_format(imx214, cfg, format->pad,
> > +                                        format->which);
> > +     __format->width = __crop->width;
> > +     __format->height = __crop->height;
> > +     __format->code = IMX214_MBUS_CODE;
> > +     __format->field = V4L2_FIELD_NONE;
> > +     __format->colorspace = V4L2_COLORSPACE_SRGB;
> > +     __format->ycbcr_enc = V4L2_MAP_YCBCR_ENC_DEFAULT(__format->colorspace);
> > +     __format->quantization = V4L2_MAP_QUANTIZATION_DEFAULT(true,
> > +                             __format->colorspace, __format->ycbcr_enc);
> > +     __format->xfer_func = V4L2_MAP_XFER_FUNC_DEFAULT(__format->colorspace);
> > +
> > +     format->format = *__format;
>
> You'll need to serialise the above --- otherwise multiple calls setting the
> format may be ongoing at the same time, assigning the format to
> format->format.
>
> The same for get_format.
>
> > +
> > +     return 0;
> > +}
> > +
> > +static int imx214_get_selection(struct v4l2_subdev *sd,
> > +                             struct v4l2_subdev_pad_config *cfg,
> > +                             struct v4l2_subdev_selection *sel)
> > +{
> > +     struct imx214 *imx214 = to_imx214(sd);
> > +
> > +     if (sel->target != V4L2_SEL_TGT_CROP)
> > +             return -EINVAL;
> > +
> > +     sel->r = *__imx214_get_pad_crop(imx214, cfg, sel->pad,
> > +                                     sel->which);
>
> Same here.
>
> > +     return 0;
> > +}
> > +
> > +static int imx214_entity_init_cfg(struct v4l2_subdev *subdev,
> > +                               struct v4l2_subdev_pad_config *cfg)
> > +{
> > +     struct v4l2_subdev_format fmt = { };
> > +
> > +     fmt.which = cfg ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
> > +     fmt.format.width = imx214_modes[0].width;
> > +     fmt.format.height = imx214_modes[0].height;
> > +
> > +     imx214_set_format(subdev, cfg, &fmt);
> > +
> > +     return 0;
> > +}
> > +
> > +static int imx214_set_ctrl(struct v4l2_ctrl *ctrl)
> > +{
> > +     struct imx214 *imx214 = container_of(ctrl->handler,
> > +                                          struct imx214, ctrls);
> > +     u8 vals[2];
> > +     int ret;
> > +
> > +     /*
> > +      * Applying V4L2 control value only happens
> > +      * when power is up for streaming
> > +      */
> > +     if (!pm_runtime_get_if_in_use(imx214->dev))
> > +             return 0;
> > +
> > +     switch (ctrl->id) {
> > +     case V4L2_CID_EXPOSURE:
> > +             vals[1] = ctrl->val;
> > +             vals[0] = ctrl->val >> 8;
> > +             ret = regmap_bulk_write(imx214->regmap, 0x202, vals, 2);
> > +             if (ret < 0)
> > +                     dev_err(imx214->dev, "Error %d\n", ret);
> > +             ret = 0;
> > +             break;
> > +
> > +     default:
> > +             return -EINVAL;
>
> Oops!
>
> > +     }
> > +
> > +     pm_runtime_put(imx214->dev);
> > +
> > +     return ret;
> > +}
> > +
> > +static const struct v4l2_ctrl_ops imx214_ctrl_ops = {
> > +     .s_ctrl = imx214_set_ctrl,
> > +};
> > +
> > +#define MAX_CMD 4
> > +static int imx214_write_table(struct imx214 *imx214,
> > +                             const struct reg_8 table[])
> > +{
> > +     u8 vals[MAX_CMD];
> > +     int ret;
> > +     int i;
> > +
> > +     for (table = table; table->addr != IMX214_TABLE_END ; table++) {
> > +             if (table->addr == IMX214_TABLE_WAIT_MS) {
> > +                     usleep_range(table->val * 1000,
> > +                                  table->val * 1000 + 500);
> > +                     continue;
> > +             }
> > +
> > +             for (i = 0; i < MAX_CMD; i++) {
> > +                     if (table[i].addr != (table[0].addr + i))
> > +                             break;
> > +                     vals[i] = table[i].val;
> > +             }
> > +
> > +             ret = regmap_bulk_write(imx214->regmap, table->addr, vals, i);
> > +
> > +             if (ret) {
> > +                     dev_err(imx214->dev, "write_table error: %d\n", ret);
> > +                     return ret;
> > +             }
> > +
> > +             table += i - 1;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static int imx214_start_streaming(struct imx214 *imx214)
> > +{
> > +     int ret;
>
> It'd be nice to arrange variable declarations in a similar way in the
> functions. I'd just swap the above and below line.
>
> > +     const struct imx214_mode *mode;
> > +
> > +     ret = imx214_set_power_on(imx214);
> > +     if (ret < 0) {
> > +             dev_err(imx214->dev, "could not set power on %d\n", ret);
> > +             return ret;
> > +     }
> > +
> > +     ret = imx214_write_table(imx214, mode_table_common);
> > +     if (ret < 0) {
> > +             dev_err(imx214->dev, "could not sent common table %d\n", ret);
> > +             return ret;
> > +     }
> > +
> > +     mode = v4l2_find_nearest_size(imx214_modes,
> > +                             ARRAY_SIZE(imx214_modes), width, height,
> > +                             imx214->fmt.width, imx214->fmt.height);
> > +     ret = imx214_write_table(imx214, mode->reg_table);
> > +     if (ret < 0) {
> > +             dev_err(imx214->dev, "could not sent mode table %d\n", ret);
> > +             return ret;
> > +     }
> > +     ret = v4l2_ctrl_handler_setup(&imx214->ctrls);
> > +     if (ret < 0) {
> > +             dev_err(imx214->dev, "could not sync v4l2 controls\n");
> > +             return ret;
> > +     }
> > +     ret = regmap_write(imx214->regmap, 0x100, 1);
> > +     if (ret < 0) {
> > +             dev_err(imx214->dev, "could not sent start table %d\n", ret);
> > +             return ret;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static int imx214_stop_streaming(struct imx214 *imx214)
> > +{
> > +     int ret;
> > +
> > +     ret = regmap_write(imx214->regmap, 0x100, 0);
> > +     if (ret < 0)
> > +             dev_err(imx214->dev, "could not sent stop table %d\n",  ret);
> > +
> > +     imx214_set_power_off(imx214);
> > +     return ret;
> > +}
> > +
> > +static int imx214_s_stream(struct v4l2_subdev *subdev, int enable)
> > +{
> > +     struct imx214 *imx214 = to_imx214(subdev);
> > +     int ret;
> > +
> > +     if (imx214->streaming == enable)
> > +             return 0;
> > +
> > +     if (enable) {
> > +             ret = pm_runtime_get_sync(imx214->dev);
> > +             if (ret < 0) {
> > +                     pm_runtime_put_noidle(imx214->dev);
> > +                     return ret;
> > +             }
> > +
> > +             ret = imx214_start_streaming(imx214);
> > +             if (ret < 0)
> > +                     goto err_rpm_put;
> > +     } else {
> > +             ret = imx214_start_streaming(imx214);
> > +             goto err_rpm_put;
> > +     }
> > +
> > +     imx214->streaming = enable;
> > +     return 0;
> > +
> > +err_rpm_put:
> > +     pm_runtime_put(imx214->dev);
> > +     return ret;
> > +}
> > +
> > +static int imx214_g_frame_interval(struct v4l2_subdev *subdev,
> > +                                   struct v4l2_subdev_frame_interval *fival)
> > +{
> > +     fival->pad = 0;
> > +     fival->interval.numerator = 1;
> > +     fival->interval.denominator = IMX214_FPS;
> > +
> > +     return 0;
> > +}
> > +
> > +static int imx214_enum_frame_interval(struct v4l2_subdev *subdev,
> > +                             struct v4l2_subdev_pad_config *cfg,
> > +                             struct v4l2_subdev_frame_interval_enum *fie)
> > +{
> > +     const struct imx214_mode *mode;
> > +
> > +     if (fie->index != 0)
> > +             return -EINVAL;
> > +
> > +     mode = v4l2_find_nearest_size(imx214_modes,
> > +                             ARRAY_SIZE(imx214_modes), width, height,
> > +                             fie->width, fie->height);
> > +
> > +     fie->code = IMX214_MBUS_CODE;
> > +     fie->width = mode->width;
> > +     fie->height = mode->height;
> > +     fie->interval.numerator = 1;
> > +     fie->interval.denominator = IMX214_FPS;
> > +
> > +     return 0;
> > +}
> > +
> > +static const struct v4l2_subdev_video_ops imx214_video_ops = {
> > +     .s_stream = imx214_s_stream,
> > +     .g_frame_interval = imx214_g_frame_interval,
> > +     .s_frame_interval = imx214_g_frame_interval,
> > +};
> > +
> > +static const struct v4l2_subdev_pad_ops imx214_subdev_pad_ops = {
> > +     .enum_mbus_code = imx214_enum_mbus_code,
> > +     .enum_frame_size = imx214_enum_frame_size,
> > +     .enum_frame_interval = imx214_enum_frame_interval,
> > +     .get_fmt = imx214_get_format,
> > +     .set_fmt = imx214_set_format,
> > +     .get_selection = imx214_get_selection,
> > +     .init_cfg = imx214_entity_init_cfg,
> > +};
> > +
> > +static const struct v4l2_subdev_ops imx214_subdev_ops = {
> > +     .core = &imx214_core_ops,
> > +     .video = &imx214_video_ops,
> > +     .pad = &imx214_subdev_pad_ops,
> > +};
> > +
> > +static const struct regmap_config sensor_regmap_config = {
> > +     .reg_bits = 16,
> > +     .val_bits = 8,
> > +     .cache_type = REGCACHE_RBTREE,
> > +};
> > +
> > +static int imx214_get_regulators(struct device *dev, struct imx214 *imx214)
> > +{
> > +     int i;
>
> unsigned int
>
> > +
> > +     for (i = 0; i < IMX214_NUM_SUPPLIES; i++)
> > +             imx214->supplies[i].supply = imx214_supply_name[i];
> > +
> > +     return devm_regulator_bulk_get(dev,
> > +                                    IMX214_NUM_SUPPLIES,
> > +                                    imx214->supplies);
> > +}
> > +
> > +static int imx214_parse_fwnode(struct device *dev)
> > +{
> > +     struct fwnode_handle *endpoint;
> > +     struct v4l2_fwnode_endpoint *bus_cfg;
> > +     int i;
>
> unsigned int
>
> > +     int ret = 0;
> > +
> > +     endpoint = fwnode_graph_get_next_endpoint(dev_fwnode(dev), NULL);
> > +     if (!endpoint) {
> > +             dev_err(dev, "endpoint node not found\n");
> > +             return -EINVAL;
> > +     }
> > +
> > +     bus_cfg = v4l2_fwnode_endpoint_alloc_parse(endpoint);
>
> Have you seen:
>
> <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=v4l2-fwnode>
>
> I'm hopeful this would be in media tree master Soon.
>
> > +     if (IS_ERR(bus_cfg)) {
> > +             dev_err(dev, "parsing endpoint node failed\n");
> > +             return PTR_ERR(bus_cfg);
> > +     }
> > +
> > +     if (bus_cfg->bus_type != V4L2_MBUS_CSI2) {
> > +             dev_err(dev, "invalid bus type (%u), must be CSI2 (%u)\n",
> > +                     bus_cfg->bus_type, V4L2_MBUS_CSI2);
> > +             ret = -EINVAL;
> > +             goto done;
> > +     }
> > +
> > +     for (i = 0 ; i < bus_cfg->nr_of_link_frequencies; i++)
> > +             if (bus_cfg->link_frequencies[i] == IMX214_DEFAULT_LINK_FREQ)
> > +                     break;
> > +
> > +     if (i == bus_cfg->nr_of_link_frequencies) {
> > +             dev_err(dev, "link-frequencies %d not supported, Please review your DT\n",
> > +                     IMX214_DEFAULT_LINK_FREQ);
> > +             ret = -EINVAL;
> > +             goto done;
> > +     }
> > +
> > +done:
> > +     v4l2_fwnode_endpoint_free(bus_cfg);
> > +     fwnode_handle_put(endpoint);
> > +     return ret;
> > +}
> > +
> > +
> > +static int __maybe_unused imx214_suspend(struct device *dev)
> > +{
> > +     struct i2c_client *client = to_i2c_client(dev);
> > +     struct v4l2_subdev *sd = i2c_get_clientdata(client);
> > +     struct imx214 *imx214 = to_imx214(sd);
> > +
> > +     if (imx214->streaming)
> > +             imx214_stop_streaming(imx214);
> > +
> > +     return 0;
> > +}
> > +
> > +static int __maybe_unused imx214_resume(struct device *dev)
> > +{
> > +     struct i2c_client *client = to_i2c_client(dev);
> > +     struct v4l2_subdev *sd = i2c_get_clientdata(client);
> > +     struct imx214 *imx214 = to_imx214(sd);
> > +     int ret;
> > +
> > +     if (imx214->streaming) {
> > +             ret = imx214_start_streaming(imx214);
> > +             if (ret)
> > +                     goto error;
> > +     }
> > +
> > +     return 0;
> > +
> > +error:
> > +     imx214_stop_streaming(imx214);
> > +     imx214->streaming = 0;
> > +     return ret;
> > +}
> > +
> > +static int imx214_probe(struct i2c_client *client)
> > +{
> > +     struct device *dev = &client->dev;
> > +     struct imx214 *imx214;
> > +     int ret;
>
> Declare ret as last?
>
> > +     static const s64 link_freq[] = {
> > +             IMX214_DEFAULT_LINK_FREQ,
> > +     };
> > +
> > +     ret = imx214_parse_fwnode(dev);
> > +     if (ret)
> > +             return ret;
> > +
> > +     imx214 = devm_kzalloc(dev, sizeof(*imx214), GFP_KERNEL);
> > +     if (!imx214)
> > +             return -ENOMEM;
> > +
> > +     imx214->dev = dev;
> > +
> > +     imx214->xclk = devm_clk_get(dev, NULL);
> > +     if (IS_ERR(imx214->xclk)) {
> > +             dev_err(dev, "could not get xclk");
> > +             return PTR_ERR(imx214->xclk);
> > +     }
> > +
> > +     ret = clk_set_rate(imx214->xclk, IMX214_DEFAULT_CLK_FREQ);
> > +     if (ret) {
> > +             dev_err(dev, "could not set xclk frequency\n");
> > +             return ret;
> > +     }
> > +
> > +     ret = imx214_get_regulators(dev, imx214);
> > +     if (ret < 0) {
> > +             dev_err(dev, "cannot get regulators\n");
> > +             return ret;
> > +     }
> > +
> > +     imx214->enable_gpio = devm_gpiod_get(dev, "enable", GPIOD_OUT_LOW);
> > +     if (IS_ERR(imx214->enable_gpio)) {
> > +             dev_err(dev, "cannot get enable gpio\n");
> > +             return PTR_ERR(imx214->enable_gpio);
> > +     }
> > +
> > +     imx214->regmap = devm_regmap_init_i2c(client, &sensor_regmap_config);
> > +     if (IS_ERR(imx214->regmap)) {
> > +             dev_err(dev, "regmap init failed\n");
> > +             return PTR_ERR(imx214->regmap);
> > +     }
> > +
> > +     pm_runtime_set_active(imx214->dev);
> > +     pm_runtime_enable(imx214->dev);
> > +     pm_runtime_idle(imx214->dev);
>
> I think it'd help moving this just before the point where you access
> hardware.
>
> If things fail and you'll return an error, please remember:
>
>         pm_runtime_disable(imx214->dev);
>
> > +
> > +     v4l2_ctrl_handler_init(&imx214->ctrls, 3);
> > +
> > +     imx214->pixel_rate = v4l2_ctrl_new_std(&imx214->ctrls, NULL,
> > +                                            V4L2_CID_PIXEL_RATE, 0,
> > +                                            IMX214_DEFAULT_PIXEL_RATE, 1,
> > +                                            IMX214_DEFAULT_PIXEL_RATE);
> > +     imx214->link_freq = v4l2_ctrl_new_int_menu(&imx214->ctrls, NULL,
> > +                                                V4L2_CID_LINK_FREQ,
> > +                                                ARRAY_SIZE(link_freq) - 1,
> > +                                                0, link_freq);
> > +     if (imx214->link_freq)
> > +             imx214->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
> > +
> > +     /*
> > +      * WARNING!
> > +      * Values obtained reverse engineering blobs and/or devices.
> > +      * Ranges and functionality might be wrong.
> > +      *
> > +      * Sony, please release some register set documentation for the
> > +      * device.
> > +      *
> > +      * Yours sincerely, Ricardo.
> > +      */
> > +     imx214->exposure = v4l2_ctrl_new_std(&imx214->ctrls, &imx214_ctrl_ops,
> > +                                          V4L2_CID_EXPOSURE,
> > +                                          0, 0xffff, 1, 0x0c70);
>
> The exposure is in lines so it can't exceed frame height + blanking.
> There's a marginal, too. I don't know what it might be for this sensor
> though. Usually it's small, such as 8 or 16. The image will almost
> certainly be garbled if you exceed the allowed value.
>Seems that this sensor

On this sensor what I am experiencing instead of garbage is that the
fps gets reduced. So I believe it is fine to
set it up this way.

> > +
> > +     ret = imx214->ctrls.error;
> > +     if (ret) {
> > +             dev_err(&client->dev, "%s control init failed (%d)\n",
> > +                             __func__, ret);
> > +             goto free_ctrl;
> > +     }
> > +
> > +     imx214->sd.ctrl_handler = &imx214->ctrls;
> > +     ret = v4l2_ctrl_handler_setup(imx214->sd.ctrl_handler);
> > +     if (ret) {
> > +             dev_err(&client->dev,
> > +                     "Error %d setting default controls\n", ret);
> > +             goto free_ctrl;
> > +     }
> > +
> > +     v4l2_i2c_subdev_init(&imx214->sd, client, &imx214_subdev_ops);
> > +     imx214->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> > +     imx214->pad.flags = MEDIA_PAD_FL_SOURCE;
> > +     imx214->sd.dev = &client->dev;
> > +     imx214->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
> > +
> > +     ret = media_entity_pads_init(&imx214->sd.entity, 1, &imx214->pad);
> > +     if (ret < 0) {
> > +             dev_err(dev, "could not register media entity\n");
> > +             goto free_ctrl;
> > +     }
> > +
> > +     imx214_entity_init_cfg(&imx214->sd, NULL);
> > +
> > +     ret = v4l2_async_register_subdev_sensor_common(&imx214->sd);
> > +     if (ret < 0) {
> > +             dev_err(dev, "could not register v4l2 device\n");
> > +             goto free_entity;
> > +     }
> > +
> > +     return 0;
> > +
> > +free_entity:
> > +     media_entity_cleanup(&imx214->sd.entity);
> > +free_ctrl:
> > +     v4l2_ctrl_handler_free(&imx214->ctrls);
> > +
> > +     return ret;
> > +}
> > +
> > +static int imx214_remove(struct i2c_client *client)
> > +{
> > +     struct v4l2_subdev *sd = i2c_get_clientdata(client);
> > +     struct imx214 *imx214 = to_imx214(sd);
> > +
> > +     v4l2_async_unregister_subdev(&imx214->sd);
> > +     media_entity_cleanup(&imx214->sd.entity);
> > +     v4l2_ctrl_handler_free(&imx214->ctrls);
> > +
> > +     pm_runtime_disable(&client->dev);
> > +     pm_runtime_set_suspended(&client->dev);
> > +
> > +     return 0;
> > +}
> > +
> > +static const struct of_device_id imx214_of_match[] = {
> > +     { .compatible = "sony,imx214" },
> > +     { }
> > +};
> > +MODULE_DEVICE_TABLE(of, imx214_of_match);
> > +
> > +static const struct dev_pm_ops imx214_pm_ops = {
> > +     SET_SYSTEM_SLEEP_PM_OPS(imx214_suspend, imx214_resume)
>
> You'll need the runtime PM ops as well, not only the system ones. Please
> see e.g. the smiapp driver --- the runtime_resume and runtime_suspend
> callbacks replace the s_power() callback that then can be removed.
>
> > +};
> > +
> > +static struct i2c_driver imx214_i2c_driver = {
> > +     .driver = {
> > +             .of_match_table = imx214_of_match,
> > +             .pm = &imx214_pm_ops,
> > +             .name  = "imx214",
> > +     },
> > +     .probe_new  = imx214_probe,
> > +     .remove = imx214_remove,
> > +};
> > +
> > +module_i2c_driver(imx214_i2c_driver);
> > +
> > +MODULE_DESCRIPTION("Sony IMX214 Camera drier");
> > +MODULE_AUTHOR("Ricardo Ribalda <ricardo.ribalda@gmail.com>");
> > +MODULE_LICENSE("GPL v2");
>
> --
> Kind regards,
>
> Sakari Ailus
> sakari.ailus@linux.intel.com



-- 
Ricardo Ribalda
