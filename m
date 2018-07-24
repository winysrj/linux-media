Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay10.mail.gandi.net ([217.70.178.230]:34117 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388364AbeGXOPT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jul 2018 10:15:19 -0400
Date: Tue, 24 Jul 2018 15:08:45 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 2/2] media: i2c: Add driver for Aptina MT9V111
Message-ID: <20180724130845.GM6784@w540>
References: <1528730253-25135-1-git-send-email-jacopo+renesas@jmondi.org>
 <1528730253-25135-3-git-send-email-jacopo+renesas@jmondi.org>
 <20180723142835.xl6qrj35lcv2e3vg@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bPrm2PuLP7ysUh6c"
Content-Disposition: inline
In-Reply-To: <20180723142835.xl6qrj35lcv2e3vg@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--bPrm2PuLP7ysUh6c
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello Sakari,
   thanks for the comments..

On Mon, Jul 23, 2018 at 05:28:35PM +0300, Sakari Ailus wrote:
> Hi Jacopo,
>
> Apologies for the late review. Please see my comments below.
>
> On Mon, Jun 11, 2018 at 05:17:33PM +0200, Jacopo Mondi wrote:
> > Add V4L2 sensor driver for Aptina MT9V111 CMOS image sensor.
> >
> > The MT9V111 is a 1/4-Inch CMOS image sensor based on MT9V011 with an
> > integrated Image Flow Processor.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  MAINTAINERS                 |    8 +
>
> Could you move the MAINTAINERS change to the DT binding documentation
> patch? Currently I presume adding a binding file which isn't accounted for
> produces a checkpatch.pl warning.
>

Yup!

> >  drivers/media/i2c/Kconfig   |   12 +
> >  drivers/media/i2c/Makefile  |    1 +
> >  drivers/media/i2c/mt9v111.c | 1297 +++++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 1318 insertions(+)
> >  create mode 100644 drivers/media/i2c/mt9v111.c
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index a38e24a..2c2fe60 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -9523,6 +9523,14 @@ F:	Documentation/devicetree/bindings/media/i2c/mt9v032.txt
> >  F:	drivers/media/i2c/mt9v032.c
> >  F:	include/media/i2c/mt9v032.h
> >
> > +MT9V111 APTINA CAMERA SENSOR
> > +M:	Jacopo Mondi <jacopo@jmondi.org>
> > +L:	linux-media@vger.kernel.org
> > +T:	git git://linuxtv.org/media_tree.git
> > +S:	Maintained
> > +F:	Documentation/devicetree/bindings/media/i2c/aptina,mt9v111.txt
> > +F:	drivers/media/i2c/mt9v111.c
> > +
> >  MULTIFUNCTION DEVICES (MFD)
> >  M:	Lee Jones <lee.jones@linaro.org>
> >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git
> > diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> > index 341452f..0bd867d 100644
> > --- a/drivers/media/i2c/Kconfig
> > +++ b/drivers/media/i2c/Kconfig
> > @@ -841,6 +841,18 @@ config VIDEO_MT9V032
> >  	  This is a Video4Linux2 sensor-level driver for the Micron
> >  	  MT9V032 752x480 CMOS sensor.
> >
> > +config VIDEO_MT9V111
> > +	tristate "Aptina MT9V111 sensor support"
> > +	depends on I2C && VIDEO_V4L2
> > +	depends on MEDIA_CAMERA_SUPPORT
> > +	depends on OF
>
> Why OF? I see no effective OF dependencies in the driver.
>

Isn't the driver probing through OF?

> > +	help
> > +	  This is a Video4Linux2 sensor-level driver for the Aptina/Micron

I'll change sensor-level to sensor, has you've been doing lately on
all other Kconfig entries

> > +	  MT9V111 sensor.
> > +
> > +	  To compile this driver as a module, choose M here: the
> > +	  module will be called mt9v111.
> > +
> >  config VIDEO_SR030PC30
> >  	tristate "Siliconfile SR030PC30 sensor support"
> >  	depends on I2C && VIDEO_V4L2
> > diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> > index d679d57..f0e8618 100644
> > --- a/drivers/media/i2c/Makefile
> > +++ b/drivers/media/i2c/Makefile
> > @@ -84,6 +84,7 @@ obj-$(CONFIG_VIDEO_MT9T001) += mt9t001.o
> >  obj-$(CONFIG_VIDEO_MT9T112) += mt9t112.o
> >  obj-$(CONFIG_VIDEO_MT9V011) += mt9v011.o
> >  obj-$(CONFIG_VIDEO_MT9V032) += mt9v032.o
> > +obj-$(CONFIG_VIDEO_MT9V111) += mt9v111.o
> >  obj-$(CONFIG_VIDEO_SR030PC30)	+= sr030pc30.o
> >  obj-$(CONFIG_VIDEO_NOON010PC30)	+= noon010pc30.o
> >  obj-$(CONFIG_VIDEO_S5K6AA)	+= s5k6aa.o
> > diff --git a/drivers/media/i2c/mt9v111.c b/drivers/media/i2c/mt9v111.c
> > new file mode 100644
> > index 0000000..36e7424
> > --- /dev/null
> > +++ b/drivers/media/i2c/mt9v111.c
> > @@ -0,0 +1,1297 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * V4L2 sensor driver for Aptina MT9V111 image sensor
> > + * Copyright (C) 2018 Jacopo Mondi <jacopo@jmondi.org>
> > + *
> > + * Based on mt9v032 driver
> > + * Copyright (C) 2010, Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > + * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
> > + *
> > + * Base on mt9v011 driver
> > + * Copyright (c) 2009 Mauro Carvalho Chehab <mchehab@kernel.org>
> > + */
> > +
> > +#include <linux/clk.h>
> > +#include <linux/delay.h>
> > +#include <linux/gpio/consumer.h>
> > +#include <linux/i2c.h>
> > +#include <linux/of.h>
> > +#include <linux/slab.h>
> > +#include <linux/videodev2.h>
> > +#include <linux/v4l2-mediabus.h>
> > +#include <linux/module.h>
> > +
> > +#include <media/v4l2-ctrls.h>
> > +#include <media/v4l2-device.h>
> > +#include <media/v4l2-fwnode.h>
> > +#include <media/v4l2-image-sizes.h>
> > +#include <media/v4l2-subdev.h>
> > +
> > +/*
> > + * MT9V111 is a 1/4-Inch CMOS digital image sensor with an integrated
> > + * Image Flow Processing (IFP) engine and a sensor core loosely based on
> > + * MT9V011.
> > + *
> > + * The IFP can produce several output image formats from the sensor core
> > + * output, this driver currently supports only YUYV format permutations.
> > + *
> > + * As the auto exposure algorithms controls exposure time and modifies the
> > + * frame rate, this driver disables auto exposure control, auto white balancing
> > + * and auto flickering avoidance to allow manual frame rate control through
> > + * s_frame_interval subdev operation or V4L2_CID_V/HBLANK controls.
> > + *
> > + * While it seems possible to instruct the auto-exposure control algorithm to
> > + * respect a programmed frame rate when adjusting the pixel integration time,
> > + * registers controlling this feature are not documented in the public
> > + * available sensor manual used to develop this driver (09005aef80e90084,
> > + * MT9V111_1.fm - Rev. G 1/05 EN).
> > + */
> > +
> > +#define MT9V111_CHIP_ID_HIGH				0x82
> > +#define MT9V111_CHIP_ID_LOW				0x3a
> > +
> > +#define MT9V111_R01_ADDR_SPACE				0x01
> > +#define MT9V111_R01_IFP					0x01
> > +#define MT9V111_R01_CORE				0x04
> > +
> > +#define MT9V111_IFP_R06_OPMODE_CTRL			0x06
> > +#define		MT9V111_IFP_R06_OPMODE_CTRL_AWB_EN	BIT(1)
> > +#define		MT9V111_IFP_R06_OPMODE_CTRL_AE_EN	BIT(14)
> > +#define MT9V111_IFP_R07_IFP_RESET			0x07
> > +#define		MT9V111_IFP_R07_IFP_RESET_MASK		BIT(0)
> > +#define MT9V111_IFP_R08_OUTFMT_CTRL			0x08
> > +#define		MT9V111_IFP_R08_OUTFMT_CTRL_FLICKER	BIT(11)
> > +#define		MT9V111_IFP_R08_OUTFMT_CTRL_PCLK	BIT(5)
> > +#define MT9V111_IFP_R3A_OUTFMT_CTRL2			0x3a
> > +#define		MT9V111_IFP_R3A_OUTFMT_CTRL2_SWAP_CBCR	BIT(0)
> > +#define		MT9V111_IFP_R3A_OUTFMT_CTRL2_SWAP_YC	BIT(1)
> > +#define		MT9V111_IFP_R3A_OUTFMT_CTRL2_SWAP_MASK	GENMASK(2, 0)
> > +#define MT9V111_IFP_RA5_HPAN				0xa5
> > +#define MT9V111_IFP_RA6_HZOOM				0xa6
> > +#define MT9V111_IFP_RA7_HOUT				0xa7
> > +#define MT9V111_IFP_RA8_VPAN				0xa8
> > +#define MT9V111_IFP_RA9_VZOOM				0xa9
> > +#define MT9V111_IFP_RAA_VOUT				0xaa
> > +#define MT9V111_IFP_DECIMATION_MASK			GENMASK(9, 0)
> > +#define MT9V111_IFP_DECIMATION_FREEZE			BIT(15)
> > +
> > +#define MT9V111_CORE_R03_WIN_HEIGHT			0x03
> > +#define		MT9V111_CORE_R03_WIN_V_OFFS		2
> > +#define MT9V111_CORE_R04_WIN_WIDTH			0x04
> > +#define		MT9V111_CORE_R04_WIN_H_OFFS		114
> > +#define MT9V111_CORE_R05_HBLANK				0x05
> > +#define		MT9V111_CORE_R05_MIN_HBLANK		0x09
> > +#define		MT9V111_CORE_R05_MAX_HBLANK		GENMASK(9, 0)
> > +#define		MT9V111_CORE_R05_DEF_HBLANK		0x26
> > +#define MT9V111_CORE_R06_VBLANK				0x06
> > +#define		MT9V111_CORE_R06_MIN_VBLANK		0x03
> > +#define		MT9V111_CORE_R06_MAX_VBLANK		GENMASK(11, 0)
> > +#define		MT9V111_CORE_R06_DEF_VBLANK		0x04
> > +#define MT9V111_CORE_R07_OUT_CTRL			0x07
> > +#define		MT9V111_CORE_R07_OUT_CTRL_SAMPLE	BIT(4)
> > +#define MT9V111_CORE_R09_PIXEL_INT			0x09
> > +#define		MT9V111_CORE_R09_PIXEL_INT_MASK		GENMASK(11, 0)
> > +#define MT9V111_CORE_R0D_CORE_RESET			0x0d
> > +#define		MT9V111_CORE_R0D_CORE_RESET_MASK	BIT(0)
> > +#define MT9V111_CORE_RFF_CHIP_VER			0xff
> > +
> > +#define MT9V111_PIXEL_ARRAY_WIDTH			640
> > +#define MT9V111_PIXEL_ARRAY_HEIGHT			480
> > +
> > +#define MT9V111_MAX_CLKIN				27000000
> > +
> > +struct mt9v111_dev {
> > +	struct device *dev;
> > +	struct i2c_client *client;
> > +
> > +	/* Protects address space change operations. */
> > +	spinlock_t addr_lock;
> > +	u8 addr_space;
> > +
> > +	struct v4l2_subdev sd;
> > +#if defined(CONFIG_MEDIA_CONTROLLER)
> > +	struct media_pad pad;
> > +#endif
> > +
> > +	struct v4l2_ctrl *hblank;
> > +	struct v4l2_ctrl *vblank;
> > +	struct v4l2_ctrl_handler ctrls;
> > +
> > +	/* Output image format and sizes. */
> > +	struct v4l2_mbus_framefmt fmt;
> > +	unsigned int fps;
> > +
> > +	/* Protects power up/down sequences. */
> > +	struct mutex pwr_mutex;
> > +	int pwr_count;
> > +
> > +	/* Protects stream on/off sequences. */
> > +	struct mutex stream_mutex;
> > +	bool streaming;
> > +
> > +	/* Flags to mark HW settings as not yet applied. */
> > +	bool pending;
> > +
> > +	/* Clock provider and system clock frequency. */
> > +	struct clk *clk;
> > +	u32 sysclk;
> > +
> > +	struct gpio_desc *oe;
> > +	struct gpio_desc *standby;
> > +	struct gpio_desc *reset;
> > +};
> > +
> > +#define sd_to_mt9v111(__sd) container_of(__sd, struct mt9v111_dev, sd)
> > +
> > +/*
> > + * mt9v111_mbus_fmt - List all media bus formats supported by the driver.
> > + *
> > + * Only list the media bus code here. The image sizes are freely configurable
> > + * in the pixel array sizes range.
> > + *
> > + * The frame desired frame interval, in the supported frame interval range, is
> > + * obtained by configuring blanking as the sensor does not have a PLL but
> > + * only a fixed clock divider that generates the output pixel clock.
> > + */
> > +static struct mt9v111_mbus_fmt {
> > +	u32	code;
> > +} mt9v111_formats[] = {
> > +	{
> > +		.code	= MEDIA_BUS_FMT_UYVY8_2X8,
> > +	},
> > +	{
> > +		.code	= MEDIA_BUS_FMT_YUYV8_2X8,
> > +	},
> > +	{
> > +		.code	= MEDIA_BUS_FMT_VYUY8_2X8,
> > +	},
> > +	{
> > +		.code	= MEDIA_BUS_FMT_YVYU8_2X8,
> > +	},
> > +};
> > +
> > +static u32 mt9v111_frame_intervals[] = {5, 10, 15, 20, 30};
> > +
> > +/*
> > + * mt9v111_frame_sizes - List sensor's supported resolutions.
> > + *
> > + * Resolution generated through decimation in the IFP block from the
> > + * full VGA pixel array.
> > + */
> > +static struct v4l2_rect mt9v111_frame_sizes[] = {
> > +	{
> > +		.width	= 640,
> > +		.height	= 480,
> > +	},
> > +	{
> > +		.width	= 352,
> > +		.height	= 288
> > +	},
> > +	{
> > +		.width	= 320,
> > +		.height	= 240,
> > +	},
> > +	{
> > +		.width	= 176,
> > +		.height	= 144,
> > +	},
> > +	{
> > +		.width	= 160,
> > +		.height	= 120,
> > +	},
> > +};
> > +
> > +/* Initial register configuration. */
> > +static struct mt9v111_reg_list {
> > +	u8 space;
> > +	u8 reg;
> > +	u16 mask;
> > +	u16 val;
> > +} mt9v111_init_config[] = {
> > +	{
> > +		/* Disable AE and AWB to enable manual frame rate control. */
> > +		.space	= MT9V111_R01_IFP,
> > +		.reg	= MT9V111_IFP_R06_OPMODE_CTRL,
> > +		.mask	= MT9V111_IFP_R06_OPMODE_CTRL_AWB_EN |
> > +			  MT9V111_IFP_R06_OPMODE_CTRL_AE_EN,
> > +		.val	= 0,
> > +	},
> > +	{
> > +		/* Disable anti-flicker to enable manual frame rate control. */
> > +		.space	= MT9V111_R01_IFP,
> > +		.reg	= MT9V111_IFP_R08_OUTFMT_CTRL,
> > +		.mask	= MT9V111_IFP_R08_OUTFMT_CTRL_FLICKER,
> > +		.val	= 0,
> > +	},
> > +
> > +	/* TODO: AE and AWB manual configuration. */
> > +};
> > +
> > +/* --- Device I/O access --- */
> > +
> > +static int __mt9v111_read(struct i2c_client *c, u8 reg, u16 *val)
> > +{
> > +	struct i2c_msg msg[2];
> > +	__be16 buf;
> > +	int ret;
> > +
> > +	msg[0].addr = c->addr;
> > +	msg[0].flags = 0;
> > +	msg[0].len = 1;
> > +	msg[0].buf = &reg;
> > +
> > +	msg[1].addr = c->addr;
> > +	msg[1].flags = I2C_M_RD;
> > +	msg[1].len = 2;
> > +	msg[1].buf = (char *)&buf;
> > +
> > +	ret = i2c_transfer(c->adapter, msg, 2);
> > +	if (ret < 0) {
> > +		dev_err(&c->dev, "i2c read transfer error: %d\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	*val = be16_to_cpu(buf);
> > +
> > +	dev_info(&c->dev, "%s: %x=%x\n", __func__, reg, *val);
> > +
> > +	return 0;
> > +}
> > +
> > +static int __mt9v111_write(struct i2c_client *c, u8 reg, u16 val)
> > +{
> > +	struct i2c_msg msg;
> > +	u8 buf[3] = { 0 };
> > +	int ret;
> > +
> > +	buf[0] = reg;
> > +	buf[1] = val >> 8;
> > +	buf[2] = val & 0xff;
> > +
> > +	msg.addr = c->addr;
> > +	msg.flags = 0;
> > +	msg.len = 3;
> > +	msg.buf = (char *)buf;
> > +
> > +	dev_info(&c->dev, "%s: %x = %x%x\n", __func__, reg, buf[1], buf[2]);
> > +
> > +	ret = i2c_transfer(c->adapter, &msg, 1);
> > +	if (ret < 0) {
> > +		dev_err(&c->dev, "i2c write transfer error: %d\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int __mt9v111_addr_space_select(struct i2c_client *c, u16 addr_space)
> > +{
> > +	struct v4l2_subdev *sd = i2c_get_clientdata(c);
> > +	struct mt9v111_dev *mt9v111 = sd_to_mt9v111(sd);
> > +	u16 val;
> > +	int ret;
> > +
> > +	spin_lock(&mt9v111->addr_lock);
> > +	if (mt9v111->addr_space == addr_space) {
> > +		spin_unlock(&mt9v111->addr_lock);
> > +		return 0;
> > +	}
> > +	spin_unlock(&mt9v111->addr_lock);
> > +
> > +	ret = __mt9v111_write(c, MT9V111_R01_ADDR_SPACE, addr_space);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* Verify address space has been updated */
> > +	ret = __mt9v111_read(c, MT9V111_R01_ADDR_SPACE, &val);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (val != addr_space)
> > +		return -EINVAL;
> > +
> > +	mt9v111->addr_space = addr_space;
> > +
> > +	return 0;
> > +}
> > +
> > +static int mt9v111_read(struct i2c_client *c, u8 addr_space, u8 reg, u16 *val)
> > +{
> > +	int ret;
> > +
> > +	/* Select register address space first. */
> > +	ret = __mt9v111_addr_space_select(c, addr_space);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = __mt9v111_read(c, reg, val);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return 0;
> > +}
> > +
> > +static int mt9v111_write(struct i2c_client *c, u8 addr_space, u8 reg, u16 val)
> > +{
> > +	int ret;
> > +
> > +	/* Select register address space first. */
> > +	ret = __mt9v111_addr_space_select(c, addr_space);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = __mt9v111_write(c, reg, val);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return 0;
> > +}
> > +
> > +static int mt9v111_update(struct i2c_client *c, u8 addr_space, u8 reg,
> > +			  u16 mask, u16 val)
> > +{
> > +	u16 current_val;
> > +	int ret;
> > +
> > +	/* Select register address space first. */
> > +	ret = __mt9v111_addr_space_select(c, addr_space);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* Read the current register value, then update it. */
> > +	ret = __mt9v111_read(c, reg, &current_val);
> > +	if (ret)
> > +		return ret;
> > +
> > +	current_val &= ~mask;
> > +	current_val |= (val & mask);
> > +	ret = __mt9v111_write(c, reg, current_val);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return 0;
> > +}
> > +
> > +static int mt9v111_update_reglist(struct i2c_client *c,
> > +				  struct mt9v111_reg_list *reg_list,
> > +				  unsigned int n_regs)
> > +{
> > +	unsigned int i;
> > +	int ret;
> > +
> > +	for (i = 0; i < n_regs; i++) {
> > +		struct mt9v111_reg_list *reg = &reg_list[i];
> > +
> > +		ret = mt9v111_update(c, reg->space, reg->reg, reg->mask,
> > +				     reg->val);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/* --- Sensor HW operations --- */
> > +
> > +static int __mt9v111_power_on(struct v4l2_subdev *sd)
> > +{
> > +	struct mt9v111_dev *mt9v111 = sd_to_mt9v111(sd);
> > +	int ret;
> > +
> > +	ret = clk_prepare_enable(mt9v111->clk);
> > +	if (ret)
> > +		return ret;
> > +
> > +	clk_set_rate(mt9v111->clk, mt9v111->sysclk);
> > +
> > +	gpiod_set_value(mt9v111->standby, 0);
> > +	usleep_range(500, 1000);
> > +
> > +	gpiod_set_value(mt9v111->oe, 1);
> > +	usleep_range(500, 1000);
> > +
> > +	return 0;
> > +}
> > +
> > +static int __mt9v111_power_off(struct v4l2_subdev *sd)
> > +{
> > +	struct mt9v111_dev *mt9v111 = sd_to_mt9v111(sd);
> > +
> > +	gpiod_set_value(mt9v111->oe, 0);
> > +	usleep_range(500, 1000);
> > +
> > +	gpiod_set_value(mt9v111->standby, 1);
> > +	usleep_range(500, 1000);
> > +
> > +	clk_disable_unprepare(mt9v111->clk);
> > +
> > +	return 0;
> > +}
> > +
> > +static int __mt9v111_hw_reset(struct mt9v111_dev *mt9v111)
> > +{
> > +	if (!mt9v111->reset)
> > +		return -EINVAL;
> > +
> > +	gpiod_set_value(mt9v111->reset, 1);
> > +	usleep_range(500, 1000);
> > +
> > +	gpiod_set_value(mt9v111->reset, 0);
> > +	usleep_range(500, 1000);
> > +
> > +	return 0;
> > +}
> > +
> > +static int __mt9v111_sw_reset(struct mt9v111_dev *mt9v111)
> > +{
> > +	struct i2c_client *c = mt9v111->client;
> > +	unsigned int ret;
> > +
> > +	/* Software reset core and IFP blocks. */
> > +
> > +	ret = mt9v111_update(c, MT9V111_R01_CORE,
> > +			     MT9V111_CORE_R0D_CORE_RESET,
> > +			     MT9V111_CORE_R0D_CORE_RESET_MASK, 1);
> > +	if (ret)
> > +		return ret;
> > +	usleep_range(500, 1000);
> > +
> > +	ret = mt9v111_update(c, MT9V111_R01_CORE,
> > +			     MT9V111_CORE_R0D_CORE_RESET,
> > +			     MT9V111_CORE_R0D_CORE_RESET_MASK, 0);
> > +	if (ret)
> > +		return ret;
> > +	usleep_range(500, 1000);
> > +
> > +	ret = mt9v111_update(c, MT9V111_R01_IFP,
> > +			     MT9V111_IFP_R07_IFP_RESET,
> > +			     MT9V111_IFP_R07_IFP_RESET_MASK, 1);
> > +	if (ret)
> > +		return ret;
> > +	usleep_range(500, 1000);
> > +
> > +	ret = mt9v111_update(c, MT9V111_R01_IFP,
> > +			     MT9V111_IFP_R07_IFP_RESET,
> > +			     MT9V111_IFP_R07_IFP_RESET_MASK, 0);
> > +	if (ret)
> > +		return ret;
> > +	usleep_range(500, 1000);
> > +
> > +	return 0;
> > +}
> > +
> > +static int mt9v111_calc_frame_rate(struct mt9v111_dev *mt9v111,
> > +				   struct v4l2_fract *tpf)
> > +{
> > +	unsigned int fps = tpf->numerator ?
> > +			   tpf->denominator / tpf->numerator :
> > +			   tpf->denominator;
> > +	unsigned int best_diff;
> > +	unsigned int frm_cols;
> > +	unsigned int row_pclk;
> > +	unsigned int best_fps;
> > +	unsigned int pclk;
> > +	unsigned int diff;
> > +	unsigned int idx;
> > +	unsigned int hb;
> > +	unsigned int vb;
> > +	unsigned int i;
> > +	int ret;
> > +
> > +	/* Approximate to the closest supported frame interval. */
> > +	best_diff = ~0L;
> > +	for (i = 0, idx = 0; i < ARRAY_SIZE(mt9v111_frame_intervals); i++) {
> > +		diff = abs(fps - mt9v111_frame_intervals[i]);
> > +		if (diff < best_diff) {
> > +			idx = i;
> > +			best_diff = diff;
> > +		}
> > +	}
> > +	fps = mt9v111_frame_intervals[idx];
> > +
> > +	/*
> > +	 * The sensor does not provide a PLL circuitry and pixel clock is
> > +	 * generated dividing by two the master clock source.
> > +	 *
> > +	 * Trow = (W + Hblank + 114) * 2 * (1 / SYSCLK)
> > +	 * TFrame = Trow * (H + Vblank + 2)
> > +	 *
> > +	 * FPS = (SYSCLK / 2) / (Trow * (H + Vblank + 2))
> > +	 *
> > +	 * This boils down to tune H and V blanks to best approximate the
> > +	 * above equation.
> > +	 *
> > +	 * Test all available H/V blank values, until we reach the
> > +	 * desired frame rate.
> > +	 */
> > +	best_fps = vb = hb = 0;
> > +	pclk = DIV_ROUND_CLOSEST(mt9v111->sysclk, 2);
> > +	row_pclk = MT9V111_PIXEL_ARRAY_WIDTH + 7 + MT9V111_CORE_R04_WIN_H_OFFS;
> > +	frm_cols = MT9V111_PIXEL_ARRAY_HEIGHT + 7 + MT9V111_CORE_R03_WIN_V_OFFS;
> > +
> > +	best_diff = ~0L;
> > +	for (vb = MT9V111_CORE_R06_MIN_VBLANK;
> > +	     vb < MT9V111_CORE_R06_MAX_VBLANK; vb++) {
> > +		for (hb = MT9V111_CORE_R05_MIN_HBLANK;
> > +		     hb < MT9V111_CORE_R05_MAX_HBLANK; hb += 10) {
> > +			unsigned int t_frame = (row_pclk + hb) *
> > +					       (frm_cols + vb);
> > +			unsigned int t_fps = DIV_ROUND_CLOSEST(pclk, t_frame);
> > +
> > +			diff = abs(fps - t_fps);
> > +			if (diff < best_diff) {
> > +				best_diff = diff;
> > +				best_fps = t_fps;
> > +
> > +				if (diff == 0)
> > +					break;
> > +			}
> > +		}
> > +
> > +		if (diff == 0)
> > +			break;
> > +	}
> > +
> > +	dev_info(mt9v111->dev, "FPS: %u, hb = %u, vb = %u\n", fps, hb, vb);
> > +
> > +	ret = v4l2_ctrl_s_ctrl_int64(mt9v111->hblank, hb);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = v4l2_ctrl_s_ctrl_int64(mt9v111->vblank, vb);
> > +	if (ret)
> > +		return ret;
> > +
> > +	tpf->numerator = 1;
> > +	tpf->denominator = best_fps;
> > +
> > +	return 0;
> > +}
> > +
> > +static int mt9v111_hw_config(struct mt9v111_dev *mt9v111)
> > +{
> > +	struct i2c_client *c = mt9v111->client;
> > +	unsigned int ret;
> > +	u16 outfmtctrl2;
> > +
> > +	/* Force device reset. */
> > +	ret = __mt9v111_hw_reset(mt9v111);
> > +	if (ret == -EINVAL)
> > +		ret = __mt9v111_sw_reset(mt9v111);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/*
> > +	 * Disable AE, AWB and anti-flickering to allow manual frame rate
> > +	 * control.
> > +	 */
> > +	ret = mt9v111_update_reglist(c, mt9v111_init_config,
> > +				     ARRAY_SIZE(mt9v111_init_config));
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* Configure internal clock sample rate. */
> > +	ret = mt9v111->sysclk < DIV_ROUND_CLOSEST(MT9V111_MAX_CLKIN, 2) ?
> > +				mt9v111_update(c, MT9V111_R01_CORE,
> > +					MT9V111_CORE_R07_OUT_CTRL,
> > +					MT9V111_CORE_R07_OUT_CTRL_SAMPLE, 1) :
> > +				mt9v111_update(c, MT9V111_R01_CORE,
> > +					MT9V111_CORE_R07_OUT_CTRL,
> > +					MT9V111_CORE_R07_OUT_CTRL_SAMPLE, 0);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/*
> > +	 * Configure output image format components ordering.
> > +	 *
> > +	 * TODO: IFP block can also output several RGB permutations, we only
> > +	 *	 support YUYV permutations at the moment.
> > +	 */
> > +	switch (mt9v111->fmt.code) {
> > +	case MEDIA_BUS_FMT_YUYV8_2X8:
> > +			outfmtctrl2 = MT9V111_IFP_R3A_OUTFMT_CTRL2_SWAP_YC;
> > +			break;
> > +	case MEDIA_BUS_FMT_VYUY8_2X8:
> > +			outfmtctrl2 = MT9V111_IFP_R3A_OUTFMT_CTRL2_SWAP_CBCR;
> > +			break;
> > +	case MEDIA_BUS_FMT_YVYU8_2X8:
> > +			outfmtctrl2 = MT9V111_IFP_R3A_OUTFMT_CTRL2_SWAP_YC |
> > +				      MT9V111_IFP_R3A_OUTFMT_CTRL2_SWAP_CBCR;
> > +			break;
> > +	case MEDIA_BUS_FMT_UYVY8_2X8:
> > +	default:
> > +			outfmtctrl2 = 0;
> > +			break;
> > +	}
> > +
> > +	ret = mt9v111_update(c, MT9V111_R01_IFP, MT9V111_IFP_R3A_OUTFMT_CTRL2,
> > +			     MT9V111_IFP_R3A_OUTFMT_CTRL2_SWAP_MASK,
> > +			     outfmtctrl2);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/*
> > +	 * Do not change default sensor's core configuration:
> > +	 * output the whole 640x480 pixel array, skip 18 columns and 6 rows.
> > +	 *
> > +	 * Instead, control the output image size through IFP block.
> > +	 *
> > +	 * TODO: No zoom&pan support. Currently we control the output image
> > +	 *	 size only through decimation, with no zoom support.
> > +	 */
> > +	ret = mt9v111_write(c, MT9V111_R01_IFP, MT9V111_IFP_RA5_HPAN,
> > +			    MT9V111_IFP_DECIMATION_FREEZE);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = mt9v111_write(c, MT9V111_R01_IFP, MT9V111_IFP_RA8_VPAN,
> > +			    MT9V111_IFP_DECIMATION_FREEZE);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = mt9v111_write(c, MT9V111_R01_IFP, MT9V111_IFP_RA6_HZOOM,
> > +			    MT9V111_IFP_DECIMATION_FREEZE |
> > +			    MT9V111_PIXEL_ARRAY_WIDTH);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = mt9v111_write(c, MT9V111_R01_IFP, MT9V111_IFP_RA9_VZOOM,
> > +			    MT9V111_IFP_DECIMATION_FREEZE |
> > +			    MT9V111_PIXEL_ARRAY_HEIGHT);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = mt9v111_write(c, MT9V111_R01_IFP, MT9V111_IFP_RA7_HOUT,
> > +			    MT9V111_IFP_DECIMATION_FREEZE |
> > +			    mt9v111->fmt.width);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = mt9v111_write(c, MT9V111_R01_IFP, MT9V111_IFP_RAA_VOUT,
> > +			    mt9v111->fmt.height);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* Update blankings to match the programmed frame rate. */
> > +	ret = mt9v111_update(c, MT9V111_R01_CORE, MT9V111_CORE_R05_HBLANK,
> > +			     MT9V111_CORE_R05_MAX_HBLANK,
> > +			     mt9v111->hblank->val);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = mt9v111_update(c, MT9V111_R01_CORE, MT9V111_CORE_R06_VBLANK,
> > +			     MT9V111_CORE_R06_MAX_VBLANK,
> > +			     mt9v111->vblank->val);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/*
> > +	 * Set pixel integration time to the whole frame time.
> > +	 * This value controls the the shutter delay when running with AE
> > +	 * disabled. If longer than frame time, it affects the output
> > +	 * frame rate.
> > +	 */
> > +	ret = mt9v111_write(c, MT9V111_R01_CORE, MT9V111_CORE_R09_PIXEL_INT,
> > +			    MT9V111_PIXEL_ARRAY_HEIGHT);
>
> return mt9v111_write(...);
>
> > +	if (ret)
> > +		return ret;
> > +
> > +	return 0;
> > +}
> > +
> > +/* ---  V4L2 subdev operations --- */
> > +
> > +static int mt9v111_s_power(struct v4l2_subdev *sd, int on)
>
> Using runtime PM would be nicer. See e.g. the smiapp driver for an example.
>
> This could be done as a separate change later on as well.

I might post-pone this.

>
> > +{
> > +	struct mt9v111_dev *mt9v111 = sd_to_mt9v111(sd);
> > +	int pwr_count;
> > +	int ret = 0;
> > +
> > +	mutex_lock(&mt9v111->pwr_mutex);
> > +
> > +	/*
> > +	 * Make sure we're transitioning from 0 to 1, or viceversa, only
> > +	 * before actually changing the power state.
> > +	 */
> > +	pwr_count = mt9v111->pwr_count;
> > +	pwr_count += on ? 1 : -1;
> > +	if (pwr_count == !!on) {
> > +		ret = on ? __mt9v111_power_on(sd) :
> > +			   __mt9v111_power_off(sd);
> > +		if (!ret)
> > +			/* All went well, updated power counter. */
> > +			mt9v111->pwr_count = pwr_count;
> > +
> > +		mutex_unlock(&mt9v111->pwr_mutex);
> > +
> > +		return ret;
> > +	}
> > +
> > +	/*
> > +	 * Update power counter to keep track of how many nested calls we
> > +	 * received.
> > +	 */
> > +	WARN_ON(pwr_count < 0 || pwr_count > 1);
> > +	mt9v111->pwr_count = pwr_count;
> > +
> > +	mutex_unlock(&mt9v111->pwr_mutex);
> > +
> > +	return ret;
> > +}
> > +
> > +static int mt9v111_s_stream(struct v4l2_subdev *subdev, int enable)
> > +{
> > +	struct mt9v111_dev *mt9v111 = sd_to_mt9v111(subdev);
> > +	int ret;
> > +
> > +	mutex_lock(&mt9v111->stream_mutex);
> > +
> > +	if (mt9v111->streaming == enable) {
> > +		mutex_unlock(&mt9v111->stream_mutex);
> > +		return 0;
> > +	}
> > +
> > +	ret = mt9v111_s_power(subdev, enable);
> > +	if (ret)
> > +		goto error_unlock;
> > +
> > +	if (enable && mt9v111->pending) {
> > +		ret = mt9v111_hw_config(mt9v111);
> > +		if (ret)
> > +			goto error_unlock;
> > +
> > +		/*
> > +		 * No need to update control here as far as only H/VBLANK are
> > +		 * supported and immediately programmed to registers in .s_ctrl
> > +		 */
> > +
> > +		mt9v111->pending = false;
> > +	}
> > +
> > +	mt9v111->streaming = enable ? true : false;
> > +	mutex_unlock(&mt9v111->stream_mutex);
> > +
> > +	return 0;
> > +
> > +error_unlock:
> > +	mutex_unlock(&mt9v111->stream_mutex);
> > +
> > +	return ret;
> > +}
> > +
> > +static int mt9v111_s_frame_interval(struct v4l2_subdev *sd,
> > +				    struct v4l2_subdev_frame_interval *ival)
> > +{
> > +	struct mt9v111_dev *mt9v111 = sd_to_mt9v111(sd);
> > +	struct v4l2_fract *tpf = &ival->interval;
> > +	unsigned int fps = tpf->numerator ?
> > +			   tpf->denominator / tpf->numerator :
> > +			   tpf->denominator;
> > +	unsigned int max_fps;
> > +
> > +	mutex_lock(&mt9v111->stream_mutex);
> > +	if (mt9v111->streaming) {
> > +		mutex_unlock(&mt9v111->stream_mutex);
> > +		return -EBUSY;
> > +	}
> > +	mutex_unlock(&mt9v111->stream_mutex);
> > +
> > +	if (mt9v111->fps == fps)
> > +		return 0;
> > +
> > +	/* Make sure frame rate/image sizes constraints are respected. */
> > +	if (mt9v111->fmt.width < QVGA_WIDTH &&
> > +	    mt9v111->fmt.height < QVGA_HEIGHT)
> > +		max_fps = 90;
> > +	else if (mt9v111->fmt.width < CIF_WIDTH &&
> > +		 mt9v111->fmt.height < CIF_HEIGHT)
> > +		max_fps = 60;
> > +	else
> > +		max_fps = mt9v111->sysclk <
> > +				DIV_ROUND_CLOSEST(MT9V111_MAX_CLKIN, 2) ? 15 :
> > +									  30;
> > +
> > +	if (fps > max_fps)
> > +		return -EINVAL;
> > +
> > +	mt9v111_calc_frame_rate(mt9v111, tpf);
> > +
> > +	mt9v111->fps = fps;
> > +	mt9v111->pending = true;
>
> I think you'd need to keep the mutex until here.
>
> > +
> > +	return 0;
> > +}
> > +
> > +static int mt9v111_g_frame_interval(struct v4l2_subdev *sd,
> > +				    struct v4l2_subdev_frame_interval *ival)
> > +{
> > +	struct mt9v111_dev *mt9v111 = sd_to_mt9v111(sd);
> > +	struct v4l2_fract *tpf = &ival->interval;
> > +
> > +	tpf->numerator = 1;
> > +	tpf->denominator = mt9v111->fps;
>
> Same here --- access to fps is serialised by the mutex.
>
> > +
> > +	return 0;
> > +}
> > +
> > +static struct v4l2_mbus_framefmt *__mt9v111_get_pad_format(
> > +					struct mt9v111_dev *mt9v111,
> > +					struct v4l2_subdev_pad_config *cfg,
> > +					unsigned int pad,
> > +					enum v4l2_subdev_format_whence which)
> > +{
> > +	switch (which) {
> > +	case V4L2_SUBDEV_FORMAT_TRY:
> > +#ifdef CONFIG_MEDIA_CONTROLLER
> > +		return v4l2_subdev_get_try_format(&mt9v111->sd, cfg, pad);
> > +#else
> > +		return &cfg->try_fmt;
> > +#endif
> > +	case V4L2_SUBDEV_FORMAT_ACTIVE:
> > +		return &mt9v111->fmt;
> > +	default:
> > +		return NULL;
> > +	}
> > +}
> > +
> > +static int mt9v111_enum_mbus_code(struct v4l2_subdev *subdev,
> > +				  struct v4l2_subdev_pad_config *cfg,
> > +				  struct v4l2_subdev_mbus_code_enum *code)
> > +{
> > +	if (code->pad || code->index > ARRAY_SIZE(mt9v111_formats) - 1)
> > +		return -EINVAL;
> > +
> > +	code->code = mt9v111_formats[code->index].code;
> > +
> > +	return 0;
> > +}
> > +
> > +static int mt9v111_enum_frame_interval(struct v4l2_subdev *sd,
> > +				struct v4l2_subdev_pad_config *cfg,
> > +				struct v4l2_subdev_frame_interval_enum *fie)
> > +{
> > +	unsigned int i;
> > +
> > +	if (fie->pad || fie->index >= ARRAY_SIZE(mt9v111_frame_intervals))
> > +		return -EINVAL;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(mt9v111_frame_sizes); i++)
> > +		if (fie->width == mt9v111_frame_sizes[i].width &&
> > +		    fie->height == mt9v111_frame_sizes[i].height)
> > +			break;
> > +
> > +	if (i == ARRAY_SIZE(mt9v111_frame_sizes))
> > +		return -EINVAL;
> > +
> > +	fie->interval.numerator = 1;
> > +	fie->interval.denominator = mt9v111_frame_intervals[fie->index];
> > +
> > +	return 0;
> > +}
> > +
> > +static int mt9v111_enum_frame_size(struct v4l2_subdev *subdev,
> > +				   struct v4l2_subdev_pad_config *cfg,
> > +				   struct v4l2_subdev_frame_size_enum *fse)
> > +{
> > +	if (fse->pad || fse->index > ARRAY_SIZE(mt9v111_frame_sizes))
> > +		return -EINVAL;
> > +
> > +	fse->min_width = mt9v111_frame_sizes[fse->index].width;
> > +	fse->max_width = mt9v111_frame_sizes[fse->index].width;
> > +	fse->min_height = mt9v111_frame_sizes[fse->index].height;
> > +	fse->max_height = mt9v111_frame_sizes[fse->index].height;
> > +
> > +	return 0;
> > +}
> > +
> > +static int mt9v111_get_format(struct v4l2_subdev *subdev,
> > +			      struct v4l2_subdev_pad_config *cfg,
> > +			      struct v4l2_subdev_format *format)
> > +{
> > +	struct mt9v111_dev *mt9v111 = sd_to_mt9v111(subdev);
> > +
> > +	if (format->pad)
> > +		return -EINVAL;
> > +
> > +	format->format = *__mt9v111_get_pad_format(mt9v111, cfg, format->pad,
> > +						   format->which);
>
> Ditto.
>
> > +	return 0;
> > +}
> > +
> > +static int mt9v111_set_format(struct v4l2_subdev *subdev,
> > +			      struct v4l2_subdev_pad_config *cfg,
> > +			      struct v4l2_subdev_format *format)
> > +{
> > +	struct mt9v111_dev *mt9v111 = sd_to_mt9v111(subdev);
> > +	struct v4l2_mbus_framefmt new_fmt;
> > +	struct v4l2_mbus_framefmt *__fmt;
> > +	unsigned int best_fit = ~0L;
> > +	unsigned int idx;
> > +	unsigned int i;
> > +
> > +	mutex_lock(&mt9v111->stream_mutex);
> > +	if (mt9v111->streaming) {
> > +		mutex_unlock(&mt9v111->stream_mutex);
> > +		return -EBUSY;
> > +	}
> > +	mutex_unlock(&mt9v111->stream_mutex);
> > +
> > +	if (format->pad)
> > +		return -EINVAL;
> > +
> > +	/* Update mbus format code and sizes. */
> > +	for (i = 0; i < ARRAY_SIZE(mt9v111_formats); i++) {
> > +		if (format->format.code == mt9v111_formats[i].code) {
> > +			new_fmt.code = mt9v111_formats[i].code;
> > +			break;
> > +		}
> > +	}
> > +	if (i == ARRAY_SIZE(mt9v111_formats))
> > +		new_fmt.code = mt9v111_formats[0].code;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(mt9v111_frame_sizes); i++) {
> > +		unsigned int fit = abs(mt9v111_frame_sizes[i].width -
> > +				       format->format.width) +
> > +				   abs(mt9v111_frame_sizes[i].height -
> > +				       format->format.height);
> > +		if (fit < best_fit) {
> > +			best_fit = fit;
> > +			idx = i;
> > +
> > +			if (fit == 0)
> > +				break;
> > +		}
> > +	}
> > +	new_fmt.width = mt9v111_frame_sizes[idx].width;
> > +	new_fmt.height = mt9v111_frame_sizes[idx].height;
> > +
> > +	/* Update the device (or pad) format if it has changed. */
> > +	__fmt = __mt9v111_get_pad_format(mt9v111, cfg, format->pad,
> > +					 format->which);
> > +
> > +	/* Format hasn't changed, stop here. */
> > +	if (__fmt->code == new_fmt.code &&
> > +	    __fmt->width == new_fmt.width &&
> > +	    __fmt->height == new_fmt.height)
> > +		goto done;
> > +
> > +	/* Update the format and sizes, then  mark changes as pending. */
> > +	__fmt->code = new_fmt.code;
> > +	__fmt->width = new_fmt.width;
> > +	__fmt->height = new_fmt.height;
> > +
> > +	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> > +		mt9v111->pending = true;
> > +
> > +	dev_info(mt9v111->dev, "%s: mbus_code: %x - (%ux%u)\n",
> > +		 __func__, __fmt->code, __fmt->width, __fmt->height);
> > +
> > +done:
> > +	format->format = *__fmt;
>
> Same here.

Ok, I've protected with mutexes on the "is_streaming?" condition, not
the values the set/get functions are accessing (fps, formats and so
on).

I will extend the mutex coverage to the end of each function.

>
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct v4l2_subdev_core_ops mt9v111_core_ops = {
> > +	.s_power		= mt9v111_s_power,
> > +};
> > +
> > +static const struct v4l2_subdev_video_ops mt9v111_video_ops = {
> > +	.s_stream		= mt9v111_s_stream,
> > +	.s_frame_interval	= mt9v111_s_frame_interval,
> > +	.g_frame_interval	= mt9v111_g_frame_interval,
> > +};
> > +
> > +static const struct v4l2_subdev_pad_ops mt9v111_pad_ops = {
> > +	.enum_mbus_code		= mt9v111_enum_mbus_code,
> > +	.enum_frame_size	= mt9v111_enum_frame_size,
> > +	.enum_frame_interval	= mt9v111_enum_frame_interval,
> > +	.get_fmt		= mt9v111_get_format,
> > +	.set_fmt		= mt9v111_set_format,
> > +};
> > +
> > +static const struct v4l2_subdev_ops mt9v111_ops = {
> > +	.core	= &mt9v111_core_ops,
> > +	.video	= &mt9v111_video_ops,
> > +	.pad	= &mt9v111_pad_ops,
> > +};
> > +
> > +#ifdef CONFIG_MEDIA_CONTROLLER
> > +static const struct media_entity_operations mt9v111_subdev_entity_ops = {
> > +	.link_validate = v4l2_subdev_link_validate,
> > +};
> > +
> > +static int mt9v111_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> > +{
> > +	struct mt9v111_dev *mt9v111 = sd_to_mt9v111(sd);
> > +	struct v4l2_mbus_framefmt *__fmt =
> > +				v4l2_subdev_get_try_format(sd, fh->pad, 0);
> > +
> > +	/* Initialize try format: copy the device format. */
> > +	*__fmt = mt9v111->fmt;
>
> Please use default configuration, not the current configuration. If this is
> all you need in open, I'd suggest to implement the init_cfg pad op instead.
>

Didn't know about that. I'll look into it.

> > +
> > +	return 0;
> > +}
> > +
> > +static const struct v4l2_subdev_internal_ops mt9v111_internal_ops = {
> > +	.open = mt9v111_open,
> > +};
> > +#endif
> > +
> > +/* --- V4L2 ctrl --- */
> > +static int mt9v111_s_ctrl(struct v4l2_ctrl *ctrl)
> > +{
> > +	struct mt9v111_dev *mt9v111 = container_of(ctrl->handler,
> > +						   struct mt9v111_dev,
> > +						   ctrls);
> > +	int ret = 0;
>
> -EINVAL? That way any controls not handled by the function won't be missed.
>
> > +
> > +	mutex_lock(&mt9v111->pwr_mutex);
> > +	/*
> > +	 * If sensor is powered down, just cache new control values,
> > +	 * no actual register access.
> > +	 */
> > +	if (!mt9v111->pwr_count) {
> > +		mutex_unlock(&mt9v111->pwr_mutex);
> > +		return 0;
> > +	}
> > +	mutex_unlock(&mt9v111->pwr_mutex);
> > +
> > +	switch (ctrl->id) {
> > +	case V4L2_CID_HBLANK:
> > +		ret = mt9v111_update(mt9v111->client, MT9V111_R01_CORE,
> > +				     MT9V111_CORE_R05_HBLANK,
> > +				     MT9V111_CORE_R05_MAX_HBLANK,
> > +				     mt9v111->hblank->val);
> > +		break;
> > +	case V4L2_CID_VBLANK:
> > +		ret = mt9v111_update(mt9v111->client, MT9V111_R01_CORE,
> > +				     MT9V111_CORE_R06_VBLANK,
> > +				     MT9V111_CORE_R06_MAX_VBLANK,
> > +				     mt9v111->vblank->val);
> > +		break;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static const struct v4l2_ctrl_ops mt9v111_ctrl_ops = {
> > +	.s_ctrl = mt9v111_s_ctrl,
> > +};
> > +
> > +static int mt9v111_chip_probe(struct mt9v111_dev *mt9v111)
> > +{
> > +	int ret;
> > +	u16 val;
> > +
> > +	ret = __mt9v111_power_on(&mt9v111->sd);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = mt9v111_read(mt9v111->client, MT9V111_R01_CORE,
> > +			   MT9V111_CORE_RFF_CHIP_VER, &val);
> > +	if (ret)
> > +		return ret;
>
> Power off the device on failure? Same below.
>
> > +
> > +	if ((val >> 8) != MT9V111_CHIP_ID_HIGH &&
> > +	    (val & 0xff) != MT9V111_CHIP_ID_LOW) {
> > +		dev_err(mt9v111->dev,
> > +			"Unable to identify MT9V111 chip: 0x%2x%2x\n",
> > +			val >> 8, val & 0xff);
> > +		return ret;
> > +	}
> > +
> > +	ret = __mt9v111_power_off(&mt9v111->sd);
> > +	if (ret)
> > +		return ret;
> > +
> > +	dev_info(mt9v111->dev, "Chip identified: 0x%2x%2x\n",
> > +		 val >> 8, val & 0xff);
> > +
> > +	return 0;
> > +}
> > +
> > +static int mt9v111_probe(struct i2c_client *client)
> > +{
> > +	struct mt9v111_dev *mt9v111;
> > +	struct v4l2_fract tpf;
> > +	int ret;
> > +
> > +	mt9v111 = devm_kzalloc(&client->dev, sizeof(*mt9v111), GFP_KERNEL);
> > +	if (!mt9v111)
> > +		return -ENOMEM;
> > +
> > +	mt9v111->dev = &client->dev;
> > +	mt9v111->client = client;
> > +
> > +	mt9v111->clk = devm_clk_get(&client->dev, NULL);
> > +	if (IS_ERR(mt9v111->clk))
> > +		return PTR_ERR(mt9v111->clk);
> > +
> > +	mt9v111->sysclk = clk_get_rate(mt9v111->clk);
> > +	if (mt9v111->sysclk > MT9V111_MAX_CLKIN)
> > +		return -EINVAL;
> > +
> > +	mt9v111->oe = devm_gpiod_get_optional(&client->dev, "enable",
> > +					      GPIOD_OUT_LOW);
> > +	if (IS_ERR(mt9v111->oe)) {
> > +		dev_err(&client->dev, "Unable to get GPIO \"enable\": %ld\n",
> > +			PTR_ERR(mt9v111->oe));
> > +		return PTR_ERR(mt9v111->oe);
> > +	}
> > +
> > +	mt9v111->standby = devm_gpiod_get_optional(&client->dev, "standby",
> > +						   GPIOD_OUT_HIGH);
> > +	if (IS_ERR(mt9v111->standby)) {
> > +		dev_err(&client->dev, "Unable to get GPIO \"standby\": %ld\n",
> > +			PTR_ERR(mt9v111->standby));
> > +		return PTR_ERR(mt9v111->standby);
> > +	}
> > +
> > +	mt9v111->reset = devm_gpiod_get_optional(&client->dev, "reset",
> > +						 GPIOD_OUT_LOW);
> > +	if (IS_ERR(mt9v111->reset)) {
> > +		dev_err(&client->dev, "Unable to get GPIO \"reset\": %ld\n",
> > +			PTR_ERR(mt9v111->reset));
> > +		return PTR_ERR(mt9v111->reset);
> > +	}
> > +
> > +	mutex_init(&mt9v111->pwr_mutex);
> > +	mutex_init(&mt9v111->stream_mutex);
> > +	spin_lock_init(&mt9v111->addr_lock);
> > +
> > +	v4l2_ctrl_handler_init(&mt9v111->ctrls, 3);
> > +
> > +	mt9v111->hblank = v4l2_ctrl_new_std(&mt9v111->ctrls, &mt9v111_ctrl_ops,
> > +					    V4L2_CID_HBLANK,
> > +					    MT9V111_CORE_R05_MIN_HBLANK,
> > +					    MT9V111_CORE_R05_MAX_HBLANK, 1,
> > +					    MT9V111_CORE_R05_DEF_HBLANK);
> > +	if (IS_ERR_OR_NULL(mt9v111->hblank)) {
> > +		ret = PTR_ERR(mt9v111->hblank);
> > +		goto error_free_ctrls;
> > +	}
> > +
> > +	mt9v111->vblank = v4l2_ctrl_new_std(&mt9v111->ctrls, &mt9v111_ctrl_ops,
> > +					    V4L2_CID_VBLANK,
> > +					    MT9V111_CORE_R06_MIN_VBLANK,
> > +					    MT9V111_CORE_R06_MAX_VBLANK, 1,
> > +					    MT9V111_CORE_R06_DEF_VBLANK);
> > +	if (IS_ERR_OR_NULL(mt9v111->vblank)) {
> > +		ret = PTR_ERR(mt9v111->vblank);
> > +		goto error_free_ctrls;
> > +	}
> > +
> > +	/* PIXEL_RATE is fixed: just expose it to user space. */
> > +	v4l2_ctrl_new_std(&mt9v111->ctrls, &mt9v111_ctrl_ops,
> > +			  V4L2_CID_PIXEL_RATE, 0,
> > +			  DIV_ROUND_CLOSEST(mt9v111->sysclk, 2), 1,
> > +			  DIV_ROUND_CLOSEST(mt9v111->sysclk, 2));
> > +
> > +	mt9v111->sd.ctrl_handler = &mt9v111->ctrls;
> > +
> > +	/* Start with default configuration: 640x480 UYVY. */
> > +	mt9v111->fmt.width	= 640;
> > +	mt9v111->fmt.height	= 480;
> > +	mt9v111->fmt.code	= MEDIA_BUS_FMT_UYVY8_2X8;
> > +
> > +	/* These are fixed for all supported formats. */
> > +	mt9v111->fmt.field	= V4L2_FIELD_NONE;
> > +	mt9v111->fmt.colorspace	= V4L2_COLORSPACE_SRGB;
> > +	mt9v111->fmt.ycbcr_enc	= V4L2_YCBCR_ENC_601;
> > +	mt9v111->fmt.quantization = V4L2_QUANTIZATION_LIM_RANGE;
> > +	mt9v111->fmt.xfer_func	= V4L2_XFER_FUNC_SRGB;
> > +
> > +	/* Re-calculate blankings for 640x480@15fps. */
> > +	mt9v111->fps		= 15;
> > +	tpf.numerator		= 1;
> > +	tpf.denominator		= mt9v111->fps;
> > +	ret = mt9v111_calc_frame_rate(mt9v111, &tpf);
> > +	if (ret)
> > +		goto error_free_ctrls;
> > +
> > +	mt9v111->pwr_count	= 0;
> > +	mt9v111->addr_space	= MT9V111_R01_IFP;
> > +	mt9v111->pending	= true;
> > +
> > +	v4l2_i2c_subdev_init(&mt9v111->sd, client, &mt9v111_ops);
> > +
> > +#ifdef CONFIG_MEDIA_CONTROLLER
> > +	mt9v111->sd.internal_ops = &mt9v111_internal_ops;
> > +	mt9v111->sd.flags	|= V4L2_SUBDEV_FL_HAS_DEVNODE;
> > +	mt9v111->sd.entity.ops	= &mt9v111_subdev_entity_ops;
> > +	mt9v111->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
> > +
> > +	mt9v111->pad.flags	= MEDIA_PAD_FL_SOURCE;
> > +	ret = media_entity_pads_init(&mt9v111->sd.entity, 1, &mt9v111->pad);
> > +	if (ret)
> > +		goto error_free_ctrls;
> > +#endif
> > +
> > +	ret = mt9v111_chip_probe(mt9v111);
> > +	if (ret)
> > +		goto error_free_ctrls;
> > +
> > +	ret = v4l2_async_register_subdev(&mt9v111->sd);
> > +	if (ret)
> > +		goto error_free_ctrls;
> > +
> > +	return 0;
> > +
> > +error_free_ctrls:
> > +	v4l2_ctrl_handler_free(&mt9v111->ctrls);
> > +
> > +#ifdef CONFIG_MEDIA_CONTROLLER
> > +	media_entity_cleanup(&mt9v111->sd.entity);
> > +#endif
> > +
> > +	mutex_destroy(&mt9v111->pwr_mutex);
> > +	mutex_destroy(&mt9v111->stream_mutex);
> > +
> > +	return ret;
> > +}
> > +
> > +static int mt9v111_remove(struct i2c_client *client)
> > +{
> > +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> > +	struct mt9v111_dev *mt9v111 = sd_to_mt9v111(sd);
> > +
> > +	v4l2_async_unregister_subdev(sd);
> > +
> > +	v4l2_ctrl_handler_free(&mt9v111->ctrls);
> > +
> > +#ifdef CONFIG_MEDIA_CONTROLLER
> > +	media_entity_cleanup(&sd->entity);
> > +#endif
> > +
> > +	mutex_destroy(&mt9v111->pwr_mutex);
> > +	mutex_destroy(&mt9v111->stream_mutex);
> > +
> > +	devm_gpiod_put(mt9v111->dev, mt9v111->oe);
> > +	devm_gpiod_put(mt9v111->dev, mt9v111->standby);
> > +	devm_gpiod_put(mt9v111->dev, mt9v111->reset);
> > +
> > +	devm_clk_put(mt9v111->dev, mt9v111->clk);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct of_device_id mt9v111_of_match[] = {
> > +	{ .compatible = "aptina,mt9v111", },
> > +	{ /* sentinel */ },
> > +};
> > +
> > +static struct i2c_driver mt9v111_driver = {
> > +	.driver = {
> > +		.name = "mt9v111",
> > +		.of_match_table = of_match_ptr(mt9v111_of_match),
>
> Please assign this without of_match_ptr().
>

Ack to all the above comments.

I'll send v2 soon.

Thanks
   j

> > +	},
> > +	.probe_new	= mt9v111_probe,
> > +	.remove		= mt9v111_remove,
> > +};
> > +
> > +module_i2c_driver(mt9v111_driver);
> > +
> > +MODULE_DESCRIPTION("V4L2 sensor driver for Aptina MT9V111");
> > +MODULE_AUTHOR("Jacopo Mondi <jacopo@jmondi.org>");
> > +MODULE_LICENSE("GPL v2");
>
> --
> Kind regards,
>
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi

--bPrm2PuLP7ysUh6c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbVyTdAAoJEHI0Bo8WoVY86c4QAKUs9ascAPy3qQgWpauW1wKf
V+ytkYmcJlmv32kPOWOCiDwJMnKx3v5DrgSKnbeXRWliVwWk2T+UNu1Xx37vf7f8
HM+T4kN0rNvP6HM4Zw321O/zviJZQT/8T+a0ulVdFjA8r0eFfnxsOnMDnGADAtUe
skuonUv5Ub0FHYLBs4awux+76SRWCrG30D/3nId6pTb2gKrwkHukPZofgRAQ4ktj
42QLTRbBnV79kDEdn2YSIMVl5bLceSLzkkCJTNO8Q51jPDQClqTk8dYcWU6DBajt
pcB8GuUkmsNXTOmkQy68rcb7XqJs6UZHhLGihUK7Z7Ln+7upzMFneIGHwazJlB4K
ApWPeswrx4Eahc/UT8bguN3RaTDAd7vrkQF2QPBfcNlGLENuX8YwkQlXrcnpZDU8
7aFFAnweN53ffrQJ2W1PKdfuP8bZ9B4L7UEZ5ceyWc/q3ws0zn73EKTN6ZRzeA/r
6gFZ1c9Vmeyqs82oKHk4+pyVfW6bLTjbeOWXv3DmX88vT2uSIT2RPC9vdyp8+ZG7
zNBsFxM77fnMPsJCJKec28T8uO2euTnbPbkvxRf20UApYTsw3KA8JRRQudfGlN6I
oigfB413sZQMC57CoR0i5I5S4bsD5b++qp7MySi25+U2Q9g0yN256pbgVLZrnhgj
bmYqxNpCk7bNxtZ/vpbA
=h1u3
-----END PGP SIGNATURE-----

--bPrm2PuLP7ysUh6c--
