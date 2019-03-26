Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 109C3C4360F
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 11:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEA882075D
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 11:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729623AbfCZLdS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 07:33:18 -0400
Received: from mga06.intel.com ([134.134.136.31]:51944 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfCZLdR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 07:33:17 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Mar 2019 04:33:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,271,1549958400"; 
   d="scan'208";a="310504989"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga005.jf.intel.com with ESMTP; 26 Mar 2019 04:33:10 -0700
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 3C6AF207E2; Tue, 26 Mar 2019 13:33:09 +0200 (EET)
Date:   Tue, 26 Mar 2019 13:33:09 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Mickael Guene <mickael.guene@st.com>
Cc:     linux-media@vger.kernel.org, hugues.fruchet@st.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Petr Cvek <petrcvekcz@gmail.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Ben Kao <ben.kao@intel.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ricardo Ribalda Delgado <ricardo@ribalda.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Tianshu Qiu <tian.shu.qiu@intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>
Subject: Re: [PATCH v3 2/2] media:st-mipid02: MIPID02 CSI-2 to PARALLEL
 bridge driver
Message-ID: <20190326113308.mp5hqdw3ktbpcawu@paasikivi.fi.intel.com>
References: <1552373045-134493-1-git-send-email-mickael.guene@st.com>
 <1553594620-88280-1-git-send-email-mickael.guene@st.com>
 <1553594620-88280-3-git-send-email-mickael.guene@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1553594620-88280-3-git-send-email-mickael.guene@st.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mickael,

Thanks for the update.

On Tue, Mar 26, 2019 at 11:03:40AM +0100, Mickael Guene wrote:
> This V4L2 subdev driver enables STMicroelectronics MIPID02 device.
> 
> Signed-off-by: Mickael Guene <mickael.guene@st.com>
> ---
> 
> Changes in v3:
> - Fix potential wrong error code for mipid02_stream_disable and mipid02_stream_enable
> - Remove useless memset for ep in mipid02_parse_rx_ep and mipid02_parse_tx_ep
> - Add second CSI-2 input pad even if it's not yet supported
> - Add support of get_fmt, set_fmt and link_validate and only access subdev connected to mipid02
> 
> Changes in v2:
> - Merge MAINTAINERS patch 3 into patch 1 and 2
> - Fix line too long in Kconfig
> - Add missing delay after reset release
> - Various style fixes
> - Fix mipid02_stream_enable returning no error when mipid02_find_sensor failed
> 
>  MAINTAINERS                    |    1 +
>  drivers/media/i2c/Kconfig      |   14 +
>  drivers/media/i2c/Makefile     |    1 +
>  drivers/media/i2c/st-mipid02.c | 1012 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 1028 insertions(+)
>  create mode 100644 drivers/media/i2c/st-mipid02.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 74da99d..a14fe81 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14673,6 +14673,7 @@ M:	Mickael Guene <mickael.guene@st.com>
>  L:	linux-media@vger.kernel.org
>  T:	git git://linuxtv.org/media_tree.git
>  S:	Maintained
> +F:	drivers/media/i2c/st-mipid02.c
>  F:	Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt
>  
>  ST STM32 I2C/SMBUS DRIVER
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 1ef6335..be2470b 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -1135,6 +1135,20 @@ config VIDEO_I2C
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called video-i2c
>  
> +config VIDEO_ST_MIPID02
> +	tristate "STMicroelectronics MIPID02 CSI-2 to PARALLEL bridge"
> +	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> +	depends on MEDIA_CAMERA_SUPPORT
> +	depends on MEDIA_CONTROLLER
> +	select V4L2_FWNODE
> +	help
> +	  Support for STMicroelectronics MIPID02 CSI-2 to PARALLEL bridge.
> +	  It is used to allow usage of CSI-2 sensor with PARALLEL port
> +	  controller.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called st-mipid02.
> +
>  endmenu
>  
>  endif
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> index a64fca8..d8ad9da 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -113,5 +113,6 @@ obj-$(CONFIG_VIDEO_IMX258)	+= imx258.o
>  obj-$(CONFIG_VIDEO_IMX274)	+= imx274.o
>  obj-$(CONFIG_VIDEO_IMX319)	+= imx319.o
>  obj-$(CONFIG_VIDEO_IMX355)	+= imx355.o
> +obj-$(CONFIG_VIDEO_ST_MIPID02) += st-mipid02.o
>  
>  obj-$(CONFIG_SDR_MAX2175) += max2175.o
> diff --git a/drivers/media/i2c/st-mipid02.c b/drivers/media/i2c/st-mipid02.c
> new file mode 100644
> index 0000000..5bb9865
> --- /dev/null
> +++ b/drivers/media/i2c/st-mipid02.c
> @@ -0,0 +1,1012 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Driver for ST MIPID02 CSI-2 to PARALLEL bridge
> + *
> + * Copyright (C) STMicroelectronics SA 2019
> + * Authors: Mickael Guene <mickael.guene@st.com>
> + *          for STMicroelectronics.
> + *
> + *
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/gpio/consumer.h>
> +#include <linux/i2c.h>
> +#include <linux/module.h>
> +#include <linux/of_graph.h>
> +#include <linux/regulator/consumer.h>
> +#include <media/v4l2-async.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-fwnode.h>
> +#include <media/v4l2-subdev.h>
> +
> +#define MIPID02_CLK_LANE_WR_REG1			0x01
> +#define MIPID02_CLK_LANE_REG1				0x02
> +#define MIPID02_CLK_LANE_REG3				0x04
> +#define MIPID02_DATA_LANE0_REG1				0x05
> +#define MIPID02_DATA_LANE0_REG2				0x06
> +#define MIPID02_DATA_LANE1_REG1				0x09
> +#define MIPID02_DATA_LANE1_REG2				0x0a
> +#define MIPID02_MODE_REG1				0x14
> +#define MIPID02_MODE_REG2				0x15
> +#define MIPID02_DATA_ID_RREG				0x17
> +#define MIPID02_DATA_SELECTION_CTRL			0x19
> +#define MIPID02_PIX_WIDTH_CTRL				0x1e
> +#define MIPID02_PIX_WIDTH_CTRL_EMB			0x1f
> +
> +/* Bits definition for MIPID02_CLK_LANE_REG1 */
> +#define CLK_ENABLE					BIT(0)
> +/* Bits definition for MIPID02_CLK_LANE_REG3 */
> +#define CLK_MIPI_CSI					BIT(1)
> +/* Bits definition for MIPID02_DATA_LANE0_REG1 */
> +#define DATA_ENABLE					BIT(0)
> +/* Bits definition for MIPID02_DATA_LANEx_REG2 */
> +#define DATA_MIPI_CSI					BIT(0)
> +/* Bits definition for MIPID02_MODE_REG1 */
> +#define MODE_DATA_SWAP					BIT(2)
> +#define MODE_NO_BYPASS					BIT(6)
> +/* Bits definition for MIPID02_MODE_REG2 */
> +#define MODE_HSYNC_ACTIVE_HIGH				BIT(1)
> +#define MODE_VSYNC_ACTIVE_HIGH				BIT(2)
> +/* Bits definition for MIPID02_DATA_SELECTION_CTRL */
> +#define SELECTION_MANUAL_DATA				BIT(2)
> +#define SELECTION_MANUAL_WIDTH				BIT(3)
> +
> +static const u32 mipid02_supported_fmt_codes[] = {
> +	MEDIA_BUS_FMT_SBGGR8_1X8, MEDIA_BUS_FMT_SGBRG8_1X8,
> +	MEDIA_BUS_FMT_SGRBG8_1X8, MEDIA_BUS_FMT_SRGGB8_1X8,
> +	MEDIA_BUS_FMT_SBGGR10_1X10, MEDIA_BUS_FMT_SGBRG10_1X10,
> +	MEDIA_BUS_FMT_SGRBG10_1X10, MEDIA_BUS_FMT_SRGGB10_1X10,
> +	MEDIA_BUS_FMT_SBGGR12_1X12, MEDIA_BUS_FMT_SGBRG12_1X12,
> +	MEDIA_BUS_FMT_SGRBG12_1X12, MEDIA_BUS_FMT_SRGGB12_1X12,
> +	MEDIA_BUS_FMT_UYVY8_2X8, MEDIA_BUS_FMT_BGR888_1X24
> +};
> +
> +/* regulator supplies */
> +static const char * const mipid02_supply_name[] = {
> +	"VDDE", /* 1.8V digital I/O supply */
> +	"VDDIN", /* 1V8 voltage regulator supply */
> +};
> +
> +#define MIPID02_NUM_SUPPLIES		ARRAY_SIZE(mipid02_supply_name)
> +#define MIPID02_PAD_NB			3
> +
> +struct mipid02_dev {
> +	struct i2c_client *i2c_client;
> +	struct regulator_bulk_data supplies[MIPID02_NUM_SUPPLIES];
> +	struct v4l2_subdev sd;
> +	struct media_pad pad[MIPID02_PAD_NB];
> +	struct clk *xclk;
> +	struct gpio_desc *reset_gpio;
> +	/* endpoints info */
> +	struct v4l2_fwnode_endpoint rx;
> +	u64 link_frequency;
> +	struct v4l2_fwnode_endpoint tx;
> +	/* remote source */
> +	struct v4l2_async_subdev asd;
> +	struct v4l2_async_notifier notifier;
> +	struct v4l2_subdev *s_subdev;
> +	/* registers */
> +	struct {
> +		u8 clk_lane_reg1;
> +		u8 data_lane0_reg1;
> +		u8 data_lane1_reg1;
> +		u8 mode_reg1;
> +		u8 mode_reg2;
> +		u8 data_id_rreg;
> +		u8 pix_width_ctrl;
> +		u8 pix_width_ctrl_emb;
> +	} r;
> +	/* lock to protect all members below */
> +	struct mutex lock;
> +	bool streaming;
> +	struct v4l2_mbus_framefmt fmt;
> +};
> +
> +static int bpp_from_code(__u32 code)
> +{
> +	switch (code) {
> +	case MEDIA_BUS_FMT_SBGGR8_1X8:
> +	case MEDIA_BUS_FMT_SGBRG8_1X8:
> +	case MEDIA_BUS_FMT_SGRBG8_1X8:
> +	case MEDIA_BUS_FMT_SRGGB8_1X8:
> +		return 8;
> +	case MEDIA_BUS_FMT_SBGGR10_1X10:
> +	case MEDIA_BUS_FMT_SGBRG10_1X10:
> +	case MEDIA_BUS_FMT_SGRBG10_1X10:
> +	case MEDIA_BUS_FMT_SRGGB10_1X10:
> +		return 10;
> +	case MEDIA_BUS_FMT_SBGGR12_1X12:
> +	case MEDIA_BUS_FMT_SGBRG12_1X12:
> +	case MEDIA_BUS_FMT_SGRBG12_1X12:
> +	case MEDIA_BUS_FMT_SRGGB12_1X12:
> +		return 12;
> +	case MEDIA_BUS_FMT_UYVY8_2X8:

This is good for the parallel bus, but on CSI-2 side you should have
MEDIA_BUS_FMT_UYVY8_1X16 instead. This isn't technically correct for a
serial bus, but the custom is to use the one sample / pixel formats on the
serial busses.

> +		return 16;
> +	case MEDIA_BUS_FMT_BGR888_1X24:
> +		return 24;
> +	default:
> +		return 0;
> +	}
> +}
> +
> +static u8 data_type_from_code(__u32 code)
> +{
> +	switch (code) {
> +	case MEDIA_BUS_FMT_SBGGR8_1X8:
> +	case MEDIA_BUS_FMT_SGBRG8_1X8:
> +	case MEDIA_BUS_FMT_SGRBG8_1X8:
> +	case MEDIA_BUS_FMT_SRGGB8_1X8:
> +		return 0x2a;
> +	case MEDIA_BUS_FMT_SBGGR10_1X10:
> +	case MEDIA_BUS_FMT_SGBRG10_1X10:
> +	case MEDIA_BUS_FMT_SGRBG10_1X10:
> +	case MEDIA_BUS_FMT_SRGGB10_1X10:
> +		return 0x2b;
> +	case MEDIA_BUS_FMT_SBGGR12_1X12:
> +	case MEDIA_BUS_FMT_SGBRG12_1X12:
> +	case MEDIA_BUS_FMT_SGRBG12_1X12:
> +	case MEDIA_BUS_FMT_SRGGB12_1X12:
> +		return 0x2c;
> +	case MEDIA_BUS_FMT_UYVY8_2X8:
> +		return 0x1e;
> +	case MEDIA_BUS_FMT_BGR888_1X24:
> +		return 0x24;
> +	default:
> +		return 0;
> +	}
> +}
> +
> +static __u32 get_fmt_code(__u32 code)
> +{
> +	int i;

unsigned int

> +
> +	for (i = 0; i < ARRAY_SIZE(mipid02_supported_fmt_codes); i++) {
> +		if (code == mipid02_supported_fmt_codes[i])
> +			return code;
> +	}
> +
> +	return mipid02_supported_fmt_codes[0];
> +}
> +
> +static inline struct mipid02_dev *to_mipid02_dev(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct mipid02_dev, sd);
> +}
> +
> +static int mipid02_read_reg(struct mipid02_dev *bridge, u16 reg, u8 *val)
> +{
> +	struct i2c_client *client = bridge->i2c_client;
> +	struct i2c_msg msg[2];
> +	u8 buf[2];
> +	int ret;
> +
> +	buf[0] = reg >> 8;
> +	buf[1] = reg & 0xff;
> +
> +	msg[0].addr = client->addr;
> +	msg[0].flags = client->flags;
> +	msg[0].buf = buf;
> +	msg[0].len = sizeof(buf);
> +
> +	msg[1].addr = client->addr;
> +	msg[1].flags = client->flags | I2C_M_RD;
> +	msg[1].buf = val;
> +	msg[1].len = 1;
> +
> +	ret = i2c_transfer(client->adapter, msg, 2);
> +	if (ret < 0) {
> +		dev_dbg(&client->dev, "%s: %x i2c_transfer, reg: %x => %d\n",
> +			    __func__, client->addr, reg, ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int mipid02_write_reg(struct mipid02_dev *bridge, u16 reg, u8 val)
> +{
> +	struct i2c_client *client = bridge->i2c_client;
> +	struct i2c_msg msg;
> +	u8 buf[3];
> +	int ret;
> +
> +	buf[0] = reg >> 8;
> +	buf[1] = reg & 0xff;
> +	buf[2] = val;
> +
> +	msg.addr = client->addr;
> +	msg.flags = client->flags;
> +	msg.buf = buf;
> +	msg.len = sizeof(buf);
> +
> +	ret = i2c_transfer(client->adapter, &msg, 1);
> +	if (ret < 0) {
> +		dev_dbg(&client->dev, "%s: i2c_transfer, reg: %x => %d\n",
> +			    __func__, reg, ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int mipid02_get_regulators(struct mipid02_dev *bridge)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < MIPID02_NUM_SUPPLIES; i++)
> +		bridge->supplies[i].supply = mipid02_supply_name[i];
> +
> +	return devm_regulator_bulk_get(&bridge->i2c_client->dev,
> +				       MIPID02_NUM_SUPPLIES,
> +				       bridge->supplies);
> +}
> +
> +static void mipid02_apply_reset(struct mipid02_dev *bridge)
> +{
> +	gpiod_set_value_cansleep(bridge->reset_gpio, 0);
> +	usleep_range(5000, 10000);
> +	gpiod_set_value_cansleep(bridge->reset_gpio, 1);
> +	usleep_range(5000, 10000);
> +	gpiod_set_value_cansleep(bridge->reset_gpio, 0);
> +	usleep_range(5000, 10000);
> +}
> +
> +static int mipid02_set_power_on(struct mipid02_dev *bridge)
> +{
> +	struct i2c_client *client = bridge->i2c_client;
> +	int ret;
> +
> +	ret = clk_prepare_enable(bridge->xclk);
> +	if (ret) {
> +		dev_err(&client->dev, "%s: failed to enable clock\n", __func__);
> +		return ret;
> +	}
> +
> +	ret = regulator_bulk_enable(MIPID02_NUM_SUPPLIES,
> +				    bridge->supplies);
> +	if (ret) {
> +		dev_err(&client->dev, "%s: failed to enable regulators\n",
> +			    __func__);
> +		goto xclk_off;
> +	}
> +
> +	if (bridge->reset_gpio) {
> +		dev_dbg(&client->dev, "apply reset");
> +		mipid02_apply_reset(bridge);
> +	} else {
> +		dev_dbg(&client->dev, "dont apply reset");

"don't"

> +		usleep_range(5000, 10000);
> +	}
> +
> +	return 0;
> +
> +xclk_off:
> +	clk_disable_unprepare(bridge->xclk);
> +	return ret;
> +}
> +
> +static void mipid02_set_power_off(struct mipid02_dev *bridge)
> +{
> +	regulator_bulk_disable(MIPID02_NUM_SUPPLIES, bridge->supplies);
> +	clk_disable_unprepare(bridge->xclk);
> +}
> +
> +static int mipid02_detect(struct mipid02_dev *bridge)
> +{
> +	u8 reg;
> +
> +	/*
> +	 * There is no version registers. Just try to read register
> +	 * MIPID02_CLK_LANE_WR_REG1.
> +	 */
> +	return mipid02_read_reg(bridge, MIPID02_CLK_LANE_WR_REG1, &reg);
> +}
> +
> +static u32 mipid02_get_link_freq_from_rx_ep(struct mipid02_dev *bridge)
> +{
> +	struct v4l2_fwnode_endpoint *ep = &bridge->rx;
> +
> +	if (ep->nr_of_link_frequencies != 1)
> +		return 0;
> +
> +	return ep->link_frequencies[0];
> +}
> +
> +static u32 mipid02_get_link_freq_from_cid_link_freq(struct mipid02_dev *bridge,
> +						    struct v4l2_subdev *subdev)
> +{
> +	struct v4l2_ctrl *ctrl;
> +
> +	ctrl = v4l2_ctrl_find(subdev->ctrl_handler, V4L2_CID_LINK_FREQ);
> +	if (!ctrl)
> +		return 0;
> +
> +	return v4l2_ctrl_g_ctrl_int64(ctrl);

Note that the link frequency control is typically a menu. If you do this,
you get the number of the menu item which is likely not what you want.

> +}
> +
> +static u32 mipid02_get_link_freq_from_cid_pixel_rate(struct mipid02_dev *bridge,
> +						     struct v4l2_subdev *subdev)
> +{
> +	struct v4l2_fwnode_endpoint *ep = &bridge->rx;
> +	struct v4l2_ctrl *ctrl;
> +	u32 pixel_clock;
> +	u32 bpp = bpp_from_code(bridge->fmt.code);
> +
> +	ctrl = v4l2_ctrl_find(subdev->ctrl_handler, V4L2_CID_PIXEL_RATE);
> +	if (!ctrl)
> +		return 0;
> +	pixel_clock = v4l2_ctrl_g_ctrl_int64(ctrl);
> +
> +	return pixel_clock * bpp / (2 * ep->bus.mipi_csi2.num_data_lanes);
> +}
> +
> +/*
> + * We need to know link frequency to setup clk_lane_reg1 timings. So use
> + * following sequence, stop when we got a frequency.
> + *  - Get it from device tree. It allow to connect subdev without support of
> + *    V4L2_CID_LINK_FREQ or V4L2_CID_PIXEL_RATE or with a broken one. Drawback
> + *    is that is that link frequency must be constant.
> + *  - Get it from V4L2_CID_LINK_FREQ.
> + *  - Get it from V4L2_CID_PIXEL_RATE and use bit per pixel and number of lanes
> + *    to compute it.
> + */
> +static int mipid02_configure_from_rx_speed(struct mipid02_dev *bridge)
> +{
> +	struct i2c_client *client = bridge->i2c_client;
> +	struct v4l2_subdev *subdev = bridge->s_subdev;
> +	u32 link_freq;
> +
> +	link_freq = mipid02_get_link_freq_from_rx_ep(bridge);
> +	if (link_freq)
> +		goto success;
> +
> +	link_freq = mipid02_get_link_freq_from_cid_link_freq(bridge, subdev);
> +	if (link_freq)
> +		goto success;
> +
> +	link_freq = mipid02_get_link_freq_from_cid_pixel_rate(bridge, subdev);
> +	if (link_freq)
> +		goto success;
> +	dev_err(&client->dev, "Failed to detect link frequency");
> +
> +	return -EINVAL;
> +
> +success:
> +	dev_dbg(&client->dev, "detect link_freq = %d Hz", link_freq);
> +	bridge->r.clk_lane_reg1 |= (2000000000 / link_freq) << 2;
> +
> +	return 0;
> +}
> +
> +static int mipid02_configure_clk_lane(struct mipid02_dev *bridge)
> +{
> +	struct i2c_client *client = bridge->i2c_client;
> +	struct v4l2_fwnode_endpoint *ep = &bridge->rx;
> +	bool *polarities = ep->bus.mipi_csi2.lane_polarities;
> +
> +	/* midid02 doesn't support clock lane remapping */
> +	if (ep->bus.mipi_csi2.clock_lane != 0) {
> +		dev_err(&client->dev, "clk lane must be map to lane 0\n");
> +		return -EINVAL;
> +	}
> +	bridge->r.clk_lane_reg1 |= (polarities[0] << 1) | CLK_ENABLE;
> +
> +	return 0;
> +}
> +
> +static int mipid02_configure_data0_lane(struct mipid02_dev *bridge, int nb,
> +					bool are_lanes_swap, bool *polarities)
> +{
> +	bool are_pin_swap = are_lanes_swap ? polarities[2] : polarities[1];
> +
> +	if (nb == 1 && are_lanes_swap)
> +		return 0;
> +
> +	/*
> +	 * data lane 0 as pin swap polarity reversed compared to clock and
> +	 *data lane 1

s/\*/\* /

> +	 */
> +	if (!are_pin_swap)
> +		bridge->r.data_lane0_reg1 = 1 << 1;
> +	bridge->r.data_lane0_reg1 |= DATA_ENABLE;
> +
> +	return 0;
> +}
> +
> +static int mipid02_configure_data1_lane(struct mipid02_dev *bridge, int nb,
> +					bool are_lanes_swap, bool *polarities)
> +{
> +	bool are_pin_swap = are_lanes_swap ? polarities[1] : polarities[2];
> +
> +	if (nb == 1 && !are_lanes_swap)
> +		return 0;
> +
> +	if (are_pin_swap)
> +		bridge->r.data_lane1_reg1 = 1 << 1;
> +	bridge->r.data_lane1_reg1 |= DATA_ENABLE;
> +
> +	return 0;
> +}
> +
> +static int mipid02_configure_from_rx(struct mipid02_dev *bridge)
> +{
> +	struct v4l2_fwnode_endpoint *ep = &bridge->rx;
> +	bool are_lanes_swap = ep->bus.mipi_csi2.data_lanes[0] == 2;
> +	bool *polarities = ep->bus.mipi_csi2.lane_polarities;
> +	int nb = ep->bus.mipi_csi2.num_data_lanes;
> +	int ret;
> +
> +	ret = mipid02_configure_clk_lane(bridge);
> +	if (ret)
> +		return ret;
> +
> +	ret = mipid02_configure_data0_lane(bridge, nb, are_lanes_swap,
> +					   polarities);
> +	if (ret)
> +		return ret;
> +
> +	ret = mipid02_configure_data1_lane(bridge, nb, are_lanes_swap,
> +					   polarities);
> +	if (ret)
> +		return ret;
> +
> +	bridge->r.mode_reg1 |= are_lanes_swap ? MODE_DATA_SWAP : 0;
> +	bridge->r.mode_reg1 |= (nb - 1) << 1;
> +
> +	return mipid02_configure_from_rx_speed(bridge);
> +}
> +
> +static int mipid02_configure_from_tx(struct mipid02_dev *bridge)
> +{
> +	struct v4l2_fwnode_endpoint *ep = &bridge->tx;
> +
> +	bridge->r.pix_width_ctrl = ep->bus.parallel.bus_width;
> +	bridge->r.pix_width_ctrl_emb = ep->bus.parallel.bus_width;
> +	if (ep->bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
> +		bridge->r.mode_reg2 |= MODE_HSYNC_ACTIVE_HIGH;
> +	if (ep->bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
> +		bridge->r.mode_reg2 |= MODE_VSYNC_ACTIVE_HIGH;
> +
> +	return 0;
> +}
> +
> +static int mipid02_configure_from_code(struct mipid02_dev *bridge)
> +{
> +	u8 data_type;
> +
> +	bridge->r.data_id_rreg = 0;
> +	data_type = data_type_from_code(bridge->fmt.code);
> +	if (!data_type)
> +		return -EINVAL;
> +	bridge->r.data_id_rreg = data_type;
> +
> +	return 0;
> +}
> +
> +static int mipid02_stream_disable(struct mipid02_dev *bridge)
> +{
> +	struct i2c_client *client = bridge->i2c_client;
> +	int ret;
> +
> +	/* Disable all lanes */
> +	ret = mipid02_write_reg(bridge, MIPID02_CLK_LANE_REG1, 0);
> +	if (ret)
> +		goto error;
> +	ret = mipid02_write_reg(bridge, MIPID02_DATA_LANE0_REG1, 0);
> +	if (ret)
> +		goto error;
> +	ret = mipid02_write_reg(bridge, MIPID02_DATA_LANE1_REG1, 0);
> +	if (ret)
> +		goto error;
> +error:
> +	if (ret)
> +		dev_err(&client->dev, "failed to stream off %d", ret);
> +
> +	return ret;
> +}
> +
> +static int mipid02_stream_enable(struct mipid02_dev *bridge)
> +{
> +	struct i2c_client *client = bridge->i2c_client;
> +	int ret = -EINVAL;
> +
> +	if (!bridge->s_subdev)
> +		goto error;
> +
> +	memset(&bridge->r, 0, sizeof(bridge->r));
> +	/* build registers content */
> +	ret = mipid02_configure_from_rx(bridge);
> +	if (ret)
> +		goto error;
> +	ret = mipid02_configure_from_tx(bridge);
> +	if (ret)
> +		goto error;
> +	ret = mipid02_configure_from_code(bridge);
> +	if (ret)
> +		goto error;
> +
> +	/* write mipi registers */
> +	ret = mipid02_write_reg(bridge, MIPID02_CLK_LANE_REG1,
> +		bridge->r.clk_lane_reg1);
> +	if (ret)
> +		goto error;
> +	ret = mipid02_write_reg(bridge, MIPID02_CLK_LANE_REG3, CLK_MIPI_CSI);
> +	if (ret)
> +		goto error;
> +	ret = mipid02_write_reg(bridge, MIPID02_DATA_LANE0_REG1,
> +		bridge->r.data_lane0_reg1);
> +	if (ret)
> +		goto error;
> +	ret = mipid02_write_reg(bridge, MIPID02_DATA_LANE0_REG2,
> +		DATA_MIPI_CSI);
> +	if (ret)
> +		goto error;
> +	ret = mipid02_write_reg(bridge, MIPID02_DATA_LANE1_REG1,
> +		bridge->r.data_lane1_reg1);
> +	if (ret)
> +		goto error;
> +	ret = mipid02_write_reg(bridge, MIPID02_DATA_LANE1_REG2,
> +		DATA_MIPI_CSI);
> +	if (ret)
> +		goto error;
> +	ret = mipid02_write_reg(bridge, MIPID02_MODE_REG1,
> +		MODE_NO_BYPASS | bridge->r.mode_reg1);
> +	if (ret)
> +		goto error;
> +	ret = mipid02_write_reg(bridge, MIPID02_MODE_REG2,
> +		bridge->r.mode_reg2);
> +	if (ret)
> +		goto error;
> +	ret = mipid02_write_reg(bridge, MIPID02_DATA_ID_RREG,
> +		bridge->r.data_id_rreg);
> +	if (ret)
> +		goto error;
> +	ret = mipid02_write_reg(bridge, MIPID02_DATA_SELECTION_CTRL,
> +		SELECTION_MANUAL_DATA | SELECTION_MANUAL_WIDTH);
> +	if (ret)
> +		goto error;
> +	ret = mipid02_write_reg(bridge, MIPID02_PIX_WIDTH_CTRL,
> +		bridge->r.pix_width_ctrl);
> +	if (ret)
> +		goto error;
> +	ret = mipid02_write_reg(bridge, MIPID02_PIX_WIDTH_CTRL_EMB,
> +		bridge->r.pix_width_ctrl_emb);
> +	if (ret)
> +		goto error;
> +
> +	return 0;
> +
> +error:
> +	dev_err(&client->dev, "failed to stream on %d", ret);
> +	mipid02_stream_disable(bridge);
> +
> +	return ret;
> +}
> +
> +static int mipid02_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct mipid02_dev *bridge = to_mipid02_dev(sd);
> +	struct i2c_client *client = bridge->i2c_client;
> +	int ret = 0;
> +
> +	dev_dbg(&client->dev, "%s : requested %d / current = %d", __func__,
> +		    enable, bridge->streaming);
> +	mutex_lock(&bridge->lock);
> +
> +	if (bridge->streaming == enable)
> +		goto out;
> +
> +	ret = enable ? mipid02_stream_enable(bridge) :
> +		       mipid02_stream_disable(bridge);
> +	if (!ret)
> +		bridge->streaming = enable;
> +
> +out:
> +	dev_dbg(&client->dev, "%s current now = %d / %d", __func__,
> +		    bridge->streaming, ret);
> +	mutex_unlock(&bridge->lock);
> +
> +	return ret;
> +}
> +
> +static int mipid02_get_fmt(struct v4l2_subdev *sd,
> +			   struct v4l2_subdev_pad_config *cfg,
> +			   struct v4l2_subdev_format *format)
> +{
> +	struct mipid02_dev *bridge = to_mipid02_dev(sd);
> +	struct i2c_client *client = bridge->i2c_client;
> +	struct v4l2_mbus_framefmt *fmt;
> +
> +	dev_dbg(&client->dev, "%s probe %d", __func__, format->pad);
> +
> +	if (format->pad >= MIPID02_PAD_NB)
> +		return -EINVAL;
> +	/* second CSI-2 pad not yet supported */
> +	if (format->pad == 1)
> +		return -EINVAL;
> +
> +	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
> +		fmt = v4l2_subdev_get_try_format(&bridge->sd, cfg, format->pad);
> +	else
> +		fmt = &bridge->fmt;
> +
> +	mutex_lock(&bridge->lock);
> +
> +	format->format = *fmt;
> +
> +	mutex_unlock(&bridge->lock);
> +
> +	return 0;
> +}
> +
> +static int mipid02_set_fmt(struct v4l2_subdev *sd,
> +			   struct v4l2_subdev_pad_config *cfg,
> +			   struct v4l2_subdev_format *format)
> +{
> +	struct v4l2_mbus_framefmt *mbus_fmt = &format->format;
> +	struct mipid02_dev *bridge = to_mipid02_dev(sd);
> +	struct i2c_client *client = bridge->i2c_client;
> +	struct v4l2_mbus_framefmt *fmt;
> +	int ret;
> +
> +	dev_dbg(&client->dev, "%s for %d", __func__, format->pad);
> +
> +	if (format->pad >= MIPID02_PAD_NB)
> +		return -EINVAL;
> +	/* second CSI-2 pad not yet supported */
> +	if (format->pad == 1)
> +		return -EINVAL;
> +
> +	mutex_lock(&bridge->lock);
> +
> +	if (bridge->streaming) {
> +		ret = -EBUSY;
> +		goto error;
> +	}
> +
> +	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
> +		fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
> +	else
> +		fmt = &bridge->fmt;
> +
> +	*fmt = *mbus_fmt;

What are the limits of the hardware regarding the size of the image? Aren't
there any?

The format on the sink pad needs to be propagated to the source pad as
well. I presume there's nothing to set on the sink pad for this device, is
there?

Please see:

<URL:https://hverkuil.home.xs4all.nl/spec/uapi/v4l/dev-subdev.html#order-of-configuration-and-format-propagation>

> +	fmt->code = get_fmt_code(mbus_fmt->code);
> +	fmt->field = V4L2_FIELD_NONE;
> +	fmt->colorspace = V4L2_COLORSPACE_SRGB;
> +	fmt->ycbcr_enc = V4L2_MAP_YCBCR_ENC_DEFAULT(V4L2_COLORSPACE_SRGB);
> +	fmt->quantization = V4L2_QUANTIZATION_FULL_RANGE;
> +	fmt->xfer_func = V4L2_MAP_XFER_FUNC_DEFAULT(V4L2_COLORSPACE_SRGB);
> +
> +	ret = 0;
> +
> +error:
> +	mutex_unlock(&bridge->lock);
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_subdev_video_ops mipid02_video_ops = {
> +	.s_stream = mipid02_s_stream,
> +};
> +
> +static const struct v4l2_subdev_pad_ops mipid02_pad_ops = {
> +	.get_fmt = mipid02_get_fmt,
> +	.set_fmt = mipid02_set_fmt,
> +};
> +
> +static const struct v4l2_subdev_ops mipid02_subdev_ops = {
> +	.video = &mipid02_video_ops,
> +	.pad = &mipid02_pad_ops,
> +};
> +
> +static const struct media_entity_operations mipid02_subdev_entity_ops = {
> +	.link_validate = v4l2_subdev_link_validate,
> +};
> +
> +static int mipid02_async_bound(struct v4l2_async_notifier *notifier,
> +			       struct v4l2_subdev *s_subdev,
> +			       struct v4l2_async_subdev *asd)
> +{
> +	struct mipid02_dev *bridge = to_mipid02_dev(notifier->sd);
> +	struct i2c_client *client = bridge->i2c_client;
> +	int source_pad;
> +	int ret;
> +
> +	dev_dbg(&client->dev, "sensor_async_bound call %p", s_subdev);
> +
> +	source_pad = media_entity_get_fwnode_pad(&s_subdev->entity,
> +						 s_subdev->fwnode,
> +						 MEDIA_PAD_FL_SOURCE);
> +	if (source_pad < 0) {
> +		dev_err(&client->dev, "Couldn't find output pad for subdev %s\n",
> +			s_subdev->name);
> +		return source_pad;
> +	}
> +
> +	ret = media_create_pad_link(&s_subdev->entity, source_pad,
> +				    &bridge->sd.entity, 0,
> +				    MEDIA_LNK_FL_ENABLED |
> +				    MEDIA_LNK_FL_IMMUTABLE);
> +	if (ret) {
> +		dev_err(&client->dev, "Couldn't create media link %d", ret);
> +		return ret;
> +	}
> +
> +	bridge->s_subdev = s_subdev;
> +
> +	return 0;
> +}
> +
> +static void mipid02_async_unbind(struct v4l2_async_notifier *notifier,
> +				 struct v4l2_subdev *s_subdev,
> +				 struct v4l2_async_subdev *asd)
> +{
> +	struct mipid02_dev *bridge = to_mipid02_dev(notifier->sd);
> +
> +	bridge->s_subdev = NULL;
> +}
> +
> +static const struct v4l2_async_notifier_operations mipid02_notifier_ops = {
> +	.bound		= mipid02_async_bound,
> +	.unbind		= mipid02_async_unbind,
> +};
> +
> +static int mipid02_parse_rx_ep(struct mipid02_dev *bridge)
> +{
> +	struct v4l2_fwnode_endpoint ep = { .bus_type = V4L2_MBUS_CSI2_DPHY };
> +	struct i2c_client *client = bridge->i2c_client;
> +	struct device_node *ep_node;
> +	int ret;
> +
> +	/* parse rx (endpoint 0) */
> +	ep_node = of_graph_get_endpoint_by_regs(bridge->i2c_client->dev.of_node,
> +						0, 0);
> +	if (!ep_node) {
> +		dev_err(&client->dev, "unable to find port0 ep");
> +		ret = -EINVAL;
> +		goto error;
> +	}
> +
> +	ret = v4l2_fwnode_endpoint_alloc_parse(of_fwnode_handle(ep_node), &ep);
> +	if (ret) {
> +		dev_err(&client->dev, "Could not parse v4l2 endpoint %d\n",
> +			ret);
> +		goto error_of_node_put;
> +	}
> +
> +	/* do some sanity checks */
> +	if (ep.bus.mipi_csi2.num_data_lanes > 2) {
> +		dev_err(&client->dev, "max supported data lanes is 2 / got %d",
> +			ep.bus.mipi_csi2.num_data_lanes);
> +		ret = -EINVAL;
> +		goto error_v4l2_fwnode_endpoint_free;
> +	}
> +
> +	/* register it for later use */
> +	bridge->rx = ep;
> +	bridge->rx.link_frequencies = ep.nr_of_link_frequencies == 1 ?
> +		&bridge->link_frequency : NULL;
> +	v4l2_fwnode_endpoint_free(&ep);
> +
> +	/* register async notifier so we get noticed when sensor is connected */
> +	bridge->asd.match.fwnode =
> +		fwnode_graph_get_remote_port_parent(of_fwnode_handle(ep_node));
> +	bridge->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
> +	of_node_put(ep_node);
> +
> +	v4l2_async_notifier_init(&bridge->notifier);
> +	ret = v4l2_async_notifier_add_subdev(&bridge->notifier, &bridge->asd);
> +	if (ret) {
> +		dev_err(&client->dev, "fail to register asd to notifier %d",
> +			ret);
> +		goto error_fwnode_handle_put;
> +	}
> +	bridge->notifier.ops = &mipid02_notifier_ops;
> +
> +	ret = v4l2_async_subdev_notifier_register(&bridge->sd,
> +						  &bridge->notifier);
> +	if (ret)
> +		v4l2_async_notifier_cleanup(&bridge->notifier);
> +
> +	return ret;
> +
> +error_v4l2_fwnode_endpoint_free:
> +	v4l2_fwnode_endpoint_free(&ep);
> +error_of_node_put:
> +	of_node_put(ep_node);
> +error:
> +
> +	return ret;
> +
> +error_fwnode_handle_put:
> +	fwnode_handle_put(bridge->asd.match.fwnode);
> +
> +	return ret;
> +}
> +
> +static int mipid02_parse_tx_ep(struct mipid02_dev *bridge)
> +{
> +	struct v4l2_fwnode_endpoint ep = { .bus_type = V4L2_MBUS_PARALLEL };
> +	struct i2c_client *client = bridge->i2c_client;
> +	struct device_node *ep_node;
> +	int ret;
> +
> +	/* parse tx (endpoint 2) */
> +	ep_node = of_graph_get_endpoint_by_regs(bridge->i2c_client->dev.of_node,
> +						2, 0);
> +	if (!ep_node) {
> +		dev_err(&client->dev, "unable to find port1 ep");
> +		ret = -EINVAL;
> +		goto error;
> +	}
> +
> +	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep_node), &ep);
> +	if (ret) {
> +		dev_err(&client->dev, "Could not parse v4l2 endpoint\n");
> +		goto error_of_node_put;
> +	}
> +
> +	of_node_put(ep_node);
> +	bridge->tx = ep;
> +
> +	return 0;
> +
> +error_of_node_put:
> +	of_node_put(ep_node);
> +error:
> +
> +	return -EINVAL;
> +}
> +
> +static int mipid02_probe(struct i2c_client *client,
> +			 const struct i2c_device_id *id)
> +{
> +	struct device *dev = &client->dev;
> +	struct mipid02_dev *bridge;
> +	u32 clk_freq;
> +	int ret;
> +
> +	bridge = devm_kzalloc(dev, sizeof(*bridge), GFP_KERNEL);
> +	if (!bridge)
> +		return -ENOMEM;
> +
> +	bridge->fmt.code = MEDIA_BUS_FMT_SBGGR8_1X8;
> +	bridge->fmt.field = V4L2_FIELD_NONE;
> +	bridge->fmt.colorspace = V4L2_COLORSPACE_SRGB;
> +	bridge->fmt.ycbcr_enc =
> +		V4L2_MAP_YCBCR_ENC_DEFAULT(V4L2_COLORSPACE_SRGB);
> +	bridge->fmt.quantization = V4L2_QUANTIZATION_FULL_RANGE;
> +	bridge->fmt.xfer_func =
> +		V4L2_MAP_XFER_FUNC_DEFAULT(V4L2_COLORSPACE_SRGB);
> +	bridge->fmt.width = 640;
> +	bridge->fmt.height = 480;
> +
> +	bridge->i2c_client = client;
> +	v4l2_i2c_subdev_init(&bridge->sd, client, &mipid02_subdev_ops);
> +
> +	/* got and check clock */
> +	bridge->xclk = devm_clk_get(dev, "xclk");
> +	if (IS_ERR(bridge->xclk)) {
> +		dev_err(dev, "failed to get xclk\n");
> +		return PTR_ERR(bridge->xclk);
> +	}
> +
> +	clk_freq = clk_get_rate(bridge->xclk);
> +	if (clk_freq < 6000000 || clk_freq > 27000000) {
> +		dev_err(dev, "xclk freq must be in 6-27 Mhz range. got %d Hz\n",
> +			clk_freq);
> +		return -EINVAL;
> +	}
> +
> +	bridge->reset_gpio = devm_gpiod_get_optional(dev, "reset",
> +						     GPIOD_OUT_HIGH);
> +
> +	ret = mipid02_get_regulators(bridge);
> +	if (ret) {
> +		dev_err(dev, "failed to get regulators %d", ret);
> +		return ret;
> +	}
> +
> +	mutex_init(&bridge->lock);
> +	bridge->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	bridge->sd.entity.function = MEDIA_ENT_F_VID_IF_BRIDGE;
> +	bridge->sd.entity.ops = &mipid02_subdev_entity_ops;
> +	bridge->pad[0].flags = MEDIA_PAD_FL_SINK;
> +	bridge->pad[1].flags = MEDIA_PAD_FL_SINK;
> +	bridge->pad[2].flags = MEDIA_PAD_FL_SOURCE;
> +	ret = media_entity_pads_init(&bridge->sd.entity, MIPID02_PAD_NB,
> +				     bridge->pad);
> +	if (ret) {
> +		dev_err(&client->dev, "pads init failed %d", ret);
> +		return ret;
> +	}
> +
> +	/* enable clock, power and reset device if available */
> +	ret = mipid02_set_power_on(bridge);
> +	if (ret)
> +		goto entity_cleanup;
> +
> +	ret = mipid02_detect(bridge);
> +	if (ret) {
> +		dev_err(&client->dev, "failed to detect mipid02 %d", ret);
> +		goto power_off;
> +	}
> +
> +	ret = mipid02_parse_tx_ep(bridge);
> +	if (ret) {
> +		dev_err(&client->dev, "failed to parse tx %d", ret);
> +		goto power_off;
> +	}
> +
> +	ret = mipid02_parse_rx_ep(bridge);
> +	if (ret) {
> +		dev_err(&client->dev, "failed to parse rx %d", ret);
> +		goto power_off;
> +	}
> +
> +	ret = v4l2_async_register_subdev(&bridge->sd);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "v4l2_async_register_subdev failed %d",
> +			    ret);
> +		goto unregister_notifier;
> +	}
> +
> +	dev_info(&client->dev, "mipid02 device probe successfully");
> +
> +	return 0;
> +
> +unregister_notifier:
> +	v4l2_async_notifier_unregister(&bridge->notifier);
> +	v4l2_async_notifier_cleanup(&bridge->notifier);
> +power_off:
> +	mipid02_set_power_off(bridge);
> +entity_cleanup:
> +	media_entity_cleanup(&bridge->sd.entity);
> +
> +	return ret;
> +}
> +
> +static int mipid02_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct mipid02_dev *bridge = to_mipid02_dev(sd);
> +
> +	v4l2_async_notifier_unregister(&bridge->notifier);
> +	v4l2_async_notifier_cleanup(&bridge->notifier);
> +	v4l2_async_unregister_subdev(&bridge->sd);
> +	mipid02_set_power_off(bridge);
> +	media_entity_cleanup(&bridge->sd.entity);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id mipid02_id[] = {
> +	{ "st-mipid02", 0},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(i2c, mipid02_id);
> +
> +static const struct of_device_id mipid02_dt_ids[] = {
> +	{ .compatible = "st,st-mipid02" },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, mipid02_dt_ids);
> +
> +static struct i2c_driver mipid02_i2c_driver = {
> +	.driver = {
> +		.name  = "st-mipid02",
> +		.of_match_table = mipid02_dt_ids,
> +	},
> +	.id_table = mipid02_id,
> +	.probe    = mipid02_probe,
> +	.remove   = mipid02_remove,
> +};
> +
> +module_i2c_driver(mipid02_i2c_driver);
> +
> +MODULE_AUTHOR("Mickael Guene <mickael.guene@st.com>");
> +MODULE_DESCRIPTION("STMicroelectronics MIPID02 CSI-2 bridge driver");
> +MODULE_LICENSE("GPL v2");

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
