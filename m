Return-path: <linux-media-owner@vger.kernel.org>
Received: from plaes.org ([188.166.43.21]:44730 "EHLO plaes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758566AbdLVKV7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Dec 2017 05:21:59 -0500
Date: Fri, 22 Dec 2017 10:21:56 +0000
From: Priit Laes <plaes@plaes.org>
To: Yong Deng <yong.deng@magewell.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Rick Chang <rick.chang@mediatek.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [linux-sunxi] [PATCH v4 2/2] media: V3s: Add support for
 Allwinner CSI.
Message-ID: <20171222102156.cfemen6ouxxxbrem@plaes.org>
References: <1513936020-35569-1-git-send-email-yong.deng@magewell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1513936020-35569-1-git-send-email-yong.deng@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 22, 2017 at 05:47:00PM +0800, Yong Deng wrote:
> Allwinner V3s SoC have two CSI module. CSI0 is used for MIPI interface
> and CSI1 is used for parallel interface. This is not documented in
> datasheet but by testing and guess.
> 
> This patch implement a v4l2 framework driver for it.
> 
> Currently, the driver only support the parallel interface. MIPI-CSI2,
> ISP's support are not included in this patch.
> 
> Signed-off-by: Yong Deng <yong.deng@magewell.com>
> ---
>  MAINTAINERS                                        |   8 +
>  drivers/media/platform/Kconfig                     |   1 +
>  drivers/media/platform/Makefile                    |   2 +
>  drivers/media/platform/sunxi/sun6i-csi/Kconfig     |   9 +
>  drivers/media/platform/sunxi/sun6i-csi/Makefile    |   3 +
>  drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 878 +++++++++++++++++++++
>  drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h | 147 ++++
>  .../media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h | 203 +++++
>  .../media/platform/sunxi/sun6i-csi/sun6i_video.c   | 752 ++++++++++++++++++
>  .../media/platform/sunxi/sun6i-csi/sun6i_video.h   |  60 ++
>  10 files changed, 2063 insertions(+)
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/Kconfig
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/Makefile
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9501403..b792fe5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3783,6 +3783,14 @@ M:	Jaya Kumar <jayakumar.alsa@gmail.com>
>  S:	Maintained
>  F:	sound/pci/cs5535audio/
>  
> +CSI DRIVERS FOR ALLWINNER V3s
> +M:	Yong Deng <yong.deng@magewell.com>
> +L:	linux-media@vger.kernel.org
> +T:	git git://linuxtv.org/media_tree.git
> +S:	Maintained
> +F:	drivers/media/platform/sunxi/sun6i-csi/
> +F:	Documentation/devicetree/bindings/media/sun6i-csi.txt
> +
>  CW1200 WLAN driver
>  M:	Solomon Peachy <pizza@shaftnet.org>
>  S:	Maintained
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index fd0c998..41017e3 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -150,6 +150,7 @@ source "drivers/media/platform/am437x/Kconfig"
>  source "drivers/media/platform/xilinx/Kconfig"
>  source "drivers/media/platform/rcar-vin/Kconfig"
>  source "drivers/media/platform/atmel/Kconfig"
> +source "drivers/media/platform/sunxi/sun6i-csi/Kconfig"
>  
>  config VIDEO_TI_CAL
>  	tristate "TI CAL (Camera Adaptation Layer) driver"
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index 003b0bb..e6e9ce7 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -97,3 +97,5 @@ obj-$(CONFIG_VIDEO_QCOM_CAMSS)		+= qcom/camss-8x16/
>  obj-$(CONFIG_VIDEO_QCOM_VENUS)		+= qcom/venus/
>  
>  obj-y					+= meson/
> +
> +obj-$(CONFIG_VIDEO_SUN6I_CSI)		+= sunxi/sun6i-csi/
> diff --git a/drivers/media/platform/sunxi/sun6i-csi/Kconfig b/drivers/media/platform/sunxi/sun6i-csi/Kconfig
> new file mode 100644
> index 0000000..314188a
> --- /dev/null
> +++ b/drivers/media/platform/sunxi/sun6i-csi/Kconfig
> @@ -0,0 +1,9 @@
> +config VIDEO_SUN6I_CSI
> +	tristate "Allwinner V3s Camera Sensor Interface driver"
> +	depends on VIDEO_V4L2 && COMMON_CLK && VIDEO_V4L2_SUBDEV_API && HAS_DMA
> +	depends on ARCH_SUNXI || COMPILE_TEST
> +	select VIDEOBUF2_DMA_CONTIG
> +	select REGMAP_MMIO
> +	select V4L2_FWNODE
> +	---help---
> +	   Support for the Allwinner Camera Sensor Interface Controller on V3s.
> diff --git a/drivers/media/platform/sunxi/sun6i-csi/Makefile b/drivers/media/platform/sunxi/sun6i-csi/Makefile
> new file mode 100644
> index 0000000..213cb6b
> --- /dev/null
> +++ b/drivers/media/platform/sunxi/sun6i-csi/Makefile
> @@ -0,0 +1,3 @@
> +sun6i-csi-y += sun6i_video.o sun6i_csi.o
> +
> +obj-$(CONFIG_VIDEO_SUN6I_CSI) += sun6i-csi.o
> diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> new file mode 100644
> index 0000000..8f3f2d6
> --- /dev/null
> +++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> @@ -0,0 +1,878 @@
> +/*
> + * Copyright (c) 2017 Magewell Electronics Co., Ltd. (Nanjing).
> + * All rights reserved.
> + * Author: Yong Deng <yong.deng@magewell.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/err.h>
> +#include <linux/fs.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/ioctl.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/regmap.h>
> +#include <linux/reset.h>
> +#include <linux/sched.h>
> +#include <linux/sizes.h>
> +#include <linux/slab.h>
> +
> +#include "sun6i_csi.h"
> +#include "sun6i_csi_reg.h"
> +
> +#define MODULE_NAME	"sun6i-csi"
> +
> +struct sun6i_csi_dev {
> +	struct sun6i_csi		csi;
> +	struct device			*dev;
> +
> +	struct regmap			*regmap;
> +	struct clk			*clk_mod;
> +	struct clk			*clk_ram;
> +	struct reset_control		*rstc_bus;
> +
> +	int				planar_offset[3];
> +};
> +
> +static const u32 supported_pixformats[] = {
> +	V4L2_PIX_FMT_SBGGR8,
> +	V4L2_PIX_FMT_SGBRG8,
> +	V4L2_PIX_FMT_SGRBG8,
> +	V4L2_PIX_FMT_SRGGB8,
> +	V4L2_PIX_FMT_SBGGR10,
> +	V4L2_PIX_FMT_SGBRG10,
> +	V4L2_PIX_FMT_SGRBG10,
> +	V4L2_PIX_FMT_SRGGB10,
> +	V4L2_PIX_FMT_SBGGR12,
> +	V4L2_PIX_FMT_SGBRG12,
> +	V4L2_PIX_FMT_SGRBG12,
> +	V4L2_PIX_FMT_SRGGB12,
> +	V4L2_PIX_FMT_YUYV,
> +	V4L2_PIX_FMT_YVYU,
> +	V4L2_PIX_FMT_UYVY,
> +	V4L2_PIX_FMT_VYUY,
> +	V4L2_PIX_FMT_HM12,
> +	V4L2_PIX_FMT_NV12,
> +	V4L2_PIX_FMT_NV21,
> +	V4L2_PIX_FMT_YUV420,
> +	V4L2_PIX_FMT_YVU420,
> +	V4L2_PIX_FMT_NV16,
> +	V4L2_PIX_FMT_NV61,
> +	V4L2_PIX_FMT_YUV422P,
> +};
> +
> +static inline struct sun6i_csi_dev *sun6i_csi_to_dev(struct sun6i_csi *csi)
> +{
> +	return container_of(csi, struct sun6i_csi_dev, csi);
> +}
> +
> +int sun6i_csi_get_supported_pixformats(struct sun6i_csi *csi,
> +				       const u32 **pixformats)
> +{
> +	if (pixformats != NULL)
> +		*pixformats = supported_pixformats;
> +
> +	return ARRAY_SIZE(supported_pixformats);
> +}
> +
> +/* TODO add 10&12 bit YUV, RGB support */
> +bool sun6i_csi_is_format_support(struct sun6i_csi *csi,
> +				 u32 pixformat, u32 mbus_code)
> +{
> +	struct sun6i_csi_dev *sdev = sun6i_csi_to_dev(csi);
> +
> +	/*
> +	 * Some video receivers have the ability to be compatible with
> +	 * 8bit and 16bit bus width.
> +	 * Identify the media bus format from device tree.
> +	 */
> +	if ((sdev->csi.v4l2_ep.bus_type == V4L2_MBUS_PARALLEL
> +	      || sdev->csi.v4l2_ep.bus_type == V4L2_MBUS_BT656)
> +	     && sdev->csi.v4l2_ep.bus.parallel.bus_width == 16) {
> +		switch (pixformat) {
> +		case V4L2_PIX_FMT_HM12:
> +		case V4L2_PIX_FMT_NV12:
> +		case V4L2_PIX_FMT_NV21:
> +		case V4L2_PIX_FMT_NV16:
> +		case V4L2_PIX_FMT_NV61:
> +		case V4L2_PIX_FMT_YUV420:
> +		case V4L2_PIX_FMT_YVU420:
> +		case V4L2_PIX_FMT_YUV422P:
> +			switch (mbus_code) {
> +			case MEDIA_BUS_FMT_UYVY8_1X16:
> +			case MEDIA_BUS_FMT_VYUY8_1X16:
> +			case MEDIA_BUS_FMT_YUYV8_1X16:
> +			case MEDIA_BUS_FMT_YVYU8_1X16:
> +				return true;
> +			}
> +			break;
> +		}
Should we add default cases and warning messages here for debug purposes?
> +		return false;
> +	}
> +
> +	switch (pixformat) {
> +	case V4L2_PIX_FMT_SBGGR8:
> +		return (mbus_code == MEDIA_BUS_FMT_SBGGR8_1X8);
> +	case V4L2_PIX_FMT_SGBRG8:
> +		return (mbus_code == MEDIA_BUS_FMT_SGBRG8_1X8);
> +	case V4L2_PIX_FMT_SGRBG8:
> +		return (mbus_code == MEDIA_BUS_FMT_SGRBG8_1X8);
> +	case V4L2_PIX_FMT_SRGGB8:
> +		return (mbus_code == MEDIA_BUS_FMT_SRGGB8_1X8);
> +	case V4L2_PIX_FMT_SBGGR10:
> +		return (mbus_code == MEDIA_BUS_FMT_SBGGR10_1X10);
> +	case V4L2_PIX_FMT_SGBRG10:
> +		return (mbus_code == MEDIA_BUS_FMT_SGBRG10_1X10);
> +	case V4L2_PIX_FMT_SGRBG10:
> +		return (mbus_code == MEDIA_BUS_FMT_SGRBG10_1X10);
> +	case V4L2_PIX_FMT_SRGGB10:
> +		return (mbus_code == MEDIA_BUS_FMT_SRGGB10_1X10);
> +	case V4L2_PIX_FMT_SBGGR12:
> +		return (mbus_code == MEDIA_BUS_FMT_SBGGR12_1X12);
> +	case V4L2_PIX_FMT_SGBRG12:
> +		return (mbus_code == MEDIA_BUS_FMT_SGBRG12_1X12);
> +	case V4L2_PIX_FMT_SGRBG12:
> +		return (mbus_code == MEDIA_BUS_FMT_SGRBG12_1X12);
> +	case V4L2_PIX_FMT_SRGGB12:
> +		return (mbus_code == MEDIA_BUS_FMT_SRGGB12_1X12);
> +
> +	case V4L2_PIX_FMT_YUYV:
> +		return (mbus_code == MEDIA_BUS_FMT_YUYV8_2X8);
> +	case V4L2_PIX_FMT_YVYU:
> +		return (mbus_code == MEDIA_BUS_FMT_YVYU8_2X8);
> +	case V4L2_PIX_FMT_UYVY:
> +		return (mbus_code == MEDIA_BUS_FMT_UYVY8_2X8);
> +	case V4L2_PIX_FMT_VYUY:
> +		return (mbus_code == MEDIA_BUS_FMT_VYUY8_2X8);
> +
> +	case V4L2_PIX_FMT_HM12:
> +	case V4L2_PIX_FMT_NV12:
> +	case V4L2_PIX_FMT_NV21:
> +	case V4L2_PIX_FMT_NV16:
> +	case V4L2_PIX_FMT_NV61:
> +	case V4L2_PIX_FMT_YUV420:
> +	case V4L2_PIX_FMT_YVU420:
> +	case V4L2_PIX_FMT_YUV422P:
> +		switch (mbus_code) {
> +		case MEDIA_BUS_FMT_UYVY8_2X8:
> +		case MEDIA_BUS_FMT_VYUY8_2X8:
> +		case MEDIA_BUS_FMT_YUYV8_2X8:
> +		case MEDIA_BUS_FMT_YVYU8_2X8:
> +			return true;
> +		}
> +		break;
> +	}
> +
Should we add default cases and warning messages here for debug purposes?

> +	return false;
> +}
> +
> +int sun6i_csi_set_power(struct sun6i_csi *csi, bool enable)
> +{
> +	struct sun6i_csi_dev *sdev = sun6i_csi_to_dev(csi);
> +	struct regmap *regmap = sdev->regmap;
> +	int ret;
> +
> +	if (!enable) {
> +		regmap_update_bits(regmap, CSI_EN_REG, CSI_EN_CSI_EN, 0);
> +
> +		clk_disable_unprepare(sdev->clk_ram);
> +		clk_disable_unprepare(sdev->clk_mod);
> +		reset_control_assert(sdev->rstc_bus);
> +		return 0;
> +	}
> +
> +	ret = clk_prepare_enable(sdev->clk_mod);
> +	if (ret) {
> +		dev_err(sdev->dev, "Enable csi clk err %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = clk_prepare_enable(sdev->clk_ram);
> +	if (ret) {
> +		dev_err(sdev->dev, "Enable clk_dram_csi clk err %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = reset_control_deassert(sdev->rstc_bus);
> +	if (ret) {
> +		dev_err(sdev->dev, "reset err %d\n", ret);
> +		return ret;
> +	}
> +
> +	regmap_update_bits(regmap, CSI_EN_REG, CSI_EN_CSI_EN, CSI_EN_CSI_EN);
> +
> +	return 0;
> +}
> +
> +static enum csi_input_fmt get_csi_input_format(u32 mbus_code, u32 pixformat)
> +{
> +	/* bayer */
> +	if ((mbus_code & 0xF000) == 0x3000)
> +		return CSI_INPUT_FORMAT_RAW;
> +
> +	switch (pixformat) {
> +	case V4L2_PIX_FMT_YUYV:
> +	case V4L2_PIX_FMT_YVYU:
> +	case V4L2_PIX_FMT_UYVY:
> +	case V4L2_PIX_FMT_VYUY:
> +		return CSI_INPUT_FORMAT_RAW;
> +	}
> +
> +	/* not support YUV420 input format yet */
Please add message here for debug purposes.
> +	return CSI_INPUT_FORMAT_YUV422;
> +}
> +
> +static enum csi_output_fmt get_csi_output_format(u32 pixformat, u32 field)
> +{
> +	bool buf_interlaced = false;
> +
> +	if (field == V4L2_FIELD_INTERLACED
> +	    || field == V4L2_FIELD_INTERLACED_TB
> +	    || field == V4L2_FIELD_INTERLACED_BT)
> +		buf_interlaced = true;
> +
> +	switch (pixformat) {
> +	case V4L2_PIX_FMT_SBGGR8:
> +	case V4L2_PIX_FMT_SGBRG8:
> +	case V4L2_PIX_FMT_SGRBG8:
> +	case V4L2_PIX_FMT_SRGGB8:
> +		return buf_interlaced ? CSI_FRAME_RAW_8 : CSI_FIELD_RAW_8;
> +	case V4L2_PIX_FMT_SBGGR10:
> +	case V4L2_PIX_FMT_SGBRG10:
> +	case V4L2_PIX_FMT_SGRBG10:
> +	case V4L2_PIX_FMT_SRGGB10:
> +		return buf_interlaced ? CSI_FRAME_RAW_10 : CSI_FIELD_RAW_10;
> +	case V4L2_PIX_FMT_SBGGR12:
> +	case V4L2_PIX_FMT_SGBRG12:
> +	case V4L2_PIX_FMT_SGRBG12:
> +	case V4L2_PIX_FMT_SRGGB12:
> +		return buf_interlaced ? CSI_FRAME_RAW_12 : CSI_FIELD_RAW_12;
> +
> +	case V4L2_PIX_FMT_YUYV:
> +	case V4L2_PIX_FMT_YVYU:
> +	case V4L2_PIX_FMT_UYVY:
> +	case V4L2_PIX_FMT_VYUY:
> +		return buf_interlaced ? CSI_FRAME_RAW_8 : CSI_FIELD_RAW_8;
> +
> +	case V4L2_PIX_FMT_HM12:
> +		return buf_interlaced ? CSI_FRAME_MB_YUV420 :
> +					CSI_FIELD_MB_YUV420;
> +	case V4L2_PIX_FMT_NV12:
> +	case V4L2_PIX_FMT_NV21:
> +		return buf_interlaced ? CSI_FRAME_UV_CB_YUV420 :
> +					CSI_FIELD_UV_CB_YUV420;
> +	case V4L2_PIX_FMT_YUV420:
> +	case V4L2_PIX_FMT_YVU420:
> +		return buf_interlaced ? CSI_FRAME_PLANAR_YUV420 :
> +					CSI_FIELD_PLANAR_YUV420;
> +	case V4L2_PIX_FMT_NV16:
> +	case V4L2_PIX_FMT_NV61:
> +		return buf_interlaced ? CSI_FRAME_UV_CB_YUV422 :
> +					CSI_FIELD_UV_CB_YUV422;
> +	case V4L2_PIX_FMT_YUV422P:
> +		return buf_interlaced ? CSI_FRAME_PLANAR_YUV422 :
> +					CSI_FIELD_PLANAR_YUV422;
> +	}
Missing default case (gcc might complain).
And also would be nice to have message here for debug purposes.
> +
> +	return 0;
> +}
> +
> +static enum csi_input_seq get_csi_input_seq(u32 mbus_code, u32 pixformat)
> +{
> +
> +	switch (pixformat) {
> +	case V4L2_PIX_FMT_HM12:
> +	case V4L2_PIX_FMT_NV12:
> +	case V4L2_PIX_FMT_NV16:
> +	case V4L2_PIX_FMT_YUV420:
> +	case V4L2_PIX_FMT_YUV422P:
> +		switch (mbus_code) {
> +		case MEDIA_BUS_FMT_UYVY8_2X8:
> +		case MEDIA_BUS_FMT_UYVY8_1X16:
> +			return CSI_INPUT_SEQ_UYVY;
> +		case MEDIA_BUS_FMT_VYUY8_2X8:
> +		case MEDIA_BUS_FMT_VYUY8_1X16:
> +			return CSI_INPUT_SEQ_VYUY;
> +		case MEDIA_BUS_FMT_YUYV8_2X8:
> +		case MEDIA_BUS_FMT_YUYV8_1X16:
> +			return CSI_INPUT_SEQ_YUYV;
> +		case MEDIA_BUS_FMT_YVYU8_1X16:
> +		case MEDIA_BUS_FMT_YVYU8_2X8:
> +			return CSI_INPUT_SEQ_YVYU;
> +		}
> +		break;
> +	case V4L2_PIX_FMT_NV21:
> +	case V4L2_PIX_FMT_NV61:
> +	case V4L2_PIX_FMT_YVU420:
> +		switch (mbus_code) {
> +		case MEDIA_BUS_FMT_UYVY8_2X8:
> +		case MEDIA_BUS_FMT_UYVY8_1X16:
> +			return CSI_INPUT_SEQ_VYUY;
> +		case MEDIA_BUS_FMT_VYUY8_2X8:
> +		case MEDIA_BUS_FMT_VYUY8_1X16:
> +			return CSI_INPUT_SEQ_UYVY;
> +		case MEDIA_BUS_FMT_YUYV8_2X8:
> +		case MEDIA_BUS_FMT_YUYV8_1X16:
> +			return CSI_INPUT_SEQ_YVYU;
> +		case MEDIA_BUS_FMT_YVYU8_1X16:
> +		case MEDIA_BUS_FMT_YVYU8_2X8:
> +			return CSI_INPUT_SEQ_YUYV;
> +		}
> +		break;
> +	}
Missing default case (gcc might complain).
And also would be nice to have message here for debug purposes.
> +
> +	return CSI_INPUT_SEQ_YUYV;
> +}
> +
> +static void sun6i_csi_setup_bus(struct sun6i_csi_dev *sdev)
> +{
> +	struct v4l2_fwnode_endpoint *endpoint = &sdev->csi.v4l2_ep;
> +	unsigned char bus_width;
> +	u32 flags;
> +	u32 cfg;
> +
> +	bus_width = endpoint->bus.parallel.bus_width;
> +
> +	regmap_read(sdev->regmap, CSI_IF_CFG_REG, &cfg);
> +
> +	cfg &= ~(CSI_IF_CFG_CSI_IF_MASK | CSI_IF_CFG_MIPI_IF_MASK |
> +		 CSI_IF_CFG_IF_DATA_WIDTH_MASK |
> +		 CSI_IF_CFG_CLK_POL_MASK | CSI_IF_CFG_VREF_POL_MASK |
> +		 CSI_IF_CFG_HREF_POL_MASK | CSI_IF_CFG_FIELD_MASK);
> +
> +	switch (endpoint->bus_type) {
> +	case V4L2_MBUS_PARALLEL:
> +		cfg |= CSI_IF_CFG_MIPI_IF_CSI;
> +
> +		flags = endpoint->bus.parallel.flags;
> +
> +		cfg |= (bus_width == 16) ? CSI_IF_CFG_CSI_IF_YUV422_16BIT :
> +					   CSI_IF_CFG_CSI_IF_YUV422_INTLV;
> +
> +		if (flags & V4L2_MBUS_FIELD_EVEN_LOW)
> +			cfg |= CSI_IF_CFG_FIELD_POSITIVE;
> +
> +		if (flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
> +			cfg |= CSI_IF_CFG_VREF_POL_POSITIVE;
> +		if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
> +			cfg |= CSI_IF_CFG_HREF_POL_POSITIVE;
> +
> +		if (flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
> +			cfg |= CSI_IF_CFG_CLK_POL_FALLING_EDGE;
> +		break;
> +	case V4L2_MBUS_BT656:
> +		cfg |= CSI_IF_CFG_MIPI_IF_CSI;
> +
> +		flags = endpoint->bus.parallel.flags;
> +
> +		cfg |= (bus_width == 16) ? CSI_IF_CFG_CSI_IF_BT1120 :
> +					   CSI_IF_CFG_CSI_IF_BT656;
> +
> +		if (flags & V4L2_MBUS_FIELD_EVEN_LOW)
> +			cfg |= CSI_IF_CFG_FIELD_POSITIVE;
> +
> +		if (flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
> +			cfg |= CSI_IF_CFG_CLK_POL_FALLING_EDGE;
> +		break;
> +	default:
> +		dev_warn(sdev->dev, "Unsupported bus type: %d\n",
> +			 endpoint->bus_type);
> +		break;
> +	}
> +
> +	switch (bus_width) {
> +	case 8:
> +		cfg |= CSI_IF_CFG_IF_DATA_WIDTH_8BIT;
> +		break;
> +	case 10:
> +		cfg |= CSI_IF_CFG_IF_DATA_WIDTH_10BIT;
> +		break;
> +	case 12:
> +		cfg |= CSI_IF_CFG_IF_DATA_WIDTH_12BIT;
> +		break;
> +	case 16: /* No need to configure DATA_WIDTH for 16bit */
> +		break;
> +	default:
> +		dev_warn(sdev->dev, "Unsupported bus width: %d\n", bus_width);
> +		break;
> +	}
> +
> +	regmap_write(sdev->regmap, CSI_IF_CFG_REG, cfg);
> +}
> +
> +static void sun6i_csi_set_format(struct sun6i_csi_dev *sdev)
> +{
> +	struct sun6i_csi *csi = &sdev->csi;
> +	u32 cfg;
> +	u32 val;
> +
> +	regmap_read(sdev->regmap, CSI_CH_CFG_REG, &cfg);
> +
> +	cfg &= ~(CSI_CH_CFG_INPUT_FMT_MASK |
> +		 CSI_CH_CFG_OUTPUT_FMT_MASK | CSI_CH_CFG_VFLIP_EN |
> +		 CSI_CH_CFG_HFLIP_EN | CSI_CH_CFG_FIELD_SEL_MASK |
> +		 CSI_CH_CFG_INPUT_SEQ_MASK);
> +
> +	val = get_csi_input_format(csi->config.code, csi->config.pixelformat);
> +	cfg |= CSI_CH_CFG_INPUT_FMT(val);
> +
> +	val = get_csi_output_format(csi->config.pixelformat, csi->config.field);
> +	cfg |= CSI_CH_CFG_OUTPUT_FMT(val);
> +
> +	val = get_csi_input_seq(csi->config.code, csi->config.pixelformat);
> +	cfg |= CSI_CH_CFG_INPUT_SEQ(val);
> +
> +	if (csi->config.field == V4L2_FIELD_TOP)
> +		cfg |= CSI_CH_CFG_FIELD_SEL_FIELD0;
> +	else if (csi->config.field == V4L2_FIELD_BOTTOM)
> +		cfg |= CSI_CH_CFG_FIELD_SEL_FIELD1;
> +	else
> +		cfg |= CSI_CH_CFG_FIELD_SEL_BOTH;
> +
> +	regmap_write(sdev->regmap, CSI_CH_CFG_REG, cfg);
> +}
> +
> +static void sun6i_csi_set_window(struct sun6i_csi_dev *sdev)
> +{
> +	struct sun6i_csi_config *config = &sdev->csi.config;
> +	u32 bytesperline_y;
> +	u32 bytesperline_c;
> +	int *planar_offset = sdev->planar_offset;
> +	u32 width = config->width;
> +	u32 height = config->height;
> +	u32 hor_len = width;
> +
> +	switch (config->pixelformat) {
> +	case V4L2_PIX_FMT_YUYV:
> +	case V4L2_PIX_FMT_YVYU:
> +	case V4L2_PIX_FMT_UYVY:
> +	case V4L2_PIX_FMT_VYUY:
> +		hor_len = width * 2;
> +		break;
Missing default case. And also would be nice to have message
here for debug purposes.
> +	}
> +
> +	regmap_write(sdev->regmap, CSI_CH_HSIZE_REG,
> +		     CSI_CH_HSIZE_HOR_LEN(hor_len) |
> +		     CSI_CH_HSIZE_HOR_START(0));
> +	regmap_write(sdev->regmap, CSI_CH_VSIZE_REG,
> +		     CSI_CH_VSIZE_VER_LEN(height) |
> +		     CSI_CH_VSIZE_VER_START(0));
> +
> +	planar_offset[0] = 0;
> +	switch (config->pixelformat) {
> +	case V4L2_PIX_FMT_HM12:
> +	case V4L2_PIX_FMT_NV12:
> +	case V4L2_PIX_FMT_NV21:
> +	case V4L2_PIX_FMT_NV16:
> +	case V4L2_PIX_FMT_NV61:
> +		bytesperline_y = width;
> +		bytesperline_c = width;
> +		planar_offset[1] = bytesperline_y * height;
> +		planar_offset[2] = -1;
> +		break;
> +	case V4L2_PIX_FMT_YUV420:
> +	case V4L2_PIX_FMT_YVU420:
> +		bytesperline_y = width;
> +		bytesperline_c = width / 2;
> +		planar_offset[1] = bytesperline_y * height;
> +		planar_offset[2] = planar_offset[1] +
> +				bytesperline_c * height / 2;
> +		break;
> +	case V4L2_PIX_FMT_YUV422P:
> +		bytesperline_y = width;
> +		bytesperline_c = width / 2;
> +		planar_offset[1] = bytesperline_y * height;
> +		planar_offset[2] = planar_offset[1] +
> +				bytesperline_c * height;
> +		break;
> +	default: /* raw */

And would be nice to have message here for debug purposes.

> +		bytesperline_y = (sun6i_csi_get_bpp(config->pixelformat) *
> +				  config->width) / 8;
> +		bytesperline_c = 0;
> +		planar_offset[1] = -1;
> +		planar_offset[2] = -1;
> +		break;
> +	}
> +
> +	regmap_write(sdev->regmap, CSI_CH_BUF_LEN_REG,
> +		     CSI_CH_BUF_LEN_BUF_LEN_C(bytesperline_c) |
> +		     CSI_CH_BUF_LEN_BUF_LEN_Y(bytesperline_y));
> +}
> +
> +int sun6i_csi_update_config(struct sun6i_csi *csi,
> +			    struct sun6i_csi_config *config)
> +{
> +	struct sun6i_csi_dev *sdev = sun6i_csi_to_dev(csi);
> +
> +	if (config == NULL)
> +		return -EINVAL;
> +
> +	memcpy(&csi->config, config, sizeof(csi->config));
> +
> +	sun6i_csi_setup_bus(sdev);
> +	sun6i_csi_set_format(sdev);
> +	sun6i_csi_set_window(sdev);
> +
> +	return 0;
> +}
> +
> +void sun6i_csi_update_buf_addr(struct sun6i_csi *csi, dma_addr_t addr)
> +{
> +	struct sun6i_csi_dev *sdev = sun6i_csi_to_dev(csi);
> +	/* transform physical address to bus address */
> +	dma_addr_t bus_addr = addr - PHYS_OFFSET;
> +
> +	regmap_write(sdev->regmap, CSI_CH_F0_BUFA_REG,
> +		     (bus_addr + sdev->planar_offset[0]) >> 2);
> +	if (sdev->planar_offset[1] != -1)
> +		regmap_write(sdev->regmap, CSI_CH_F1_BUFA_REG,
> +			     (bus_addr + sdev->planar_offset[1]) >> 2);
> +	if (sdev->planar_offset[2] != -1)
> +		regmap_write(sdev->regmap, CSI_CH_F2_BUFA_REG,
> +			     (bus_addr + sdev->planar_offset[2]) >> 2);
> +}
> +
> +void sun6i_csi_set_stream(struct sun6i_csi *csi, bool enable)
> +{
> +	struct sun6i_csi_dev *sdev = sun6i_csi_to_dev(csi);
> +	struct regmap *regmap = sdev->regmap;
> +
> +	if (!enable) {
> +		regmap_update_bits(regmap, CSI_CAP_REG, CSI_CAP_CH0_VCAP_ON, 0);
> +		regmap_write(regmap, CSI_CH_INT_EN_REG, 0);
> +		return;
> +	}
> +
> +	regmap_write(regmap, CSI_CH_INT_STA_REG, 0xFF);
> +	regmap_write(regmap, CSI_CH_INT_EN_REG,
> +		     CSI_CH_INT_EN_HB_OF_INT_EN |
> +		     CSI_CH_INT_EN_FIFO2_OF_INT_EN |
> +		     CSI_CH_INT_EN_FIFO1_OF_INT_EN |
> +		     CSI_CH_INT_EN_FIFO0_OF_INT_EN |
> +		     CSI_CH_INT_EN_FD_INT_EN |
> +		     CSI_CH_INT_EN_CD_INT_EN);
> +
> +	regmap_update_bits(regmap, CSI_CAP_REG, CSI_CAP_CH0_VCAP_ON,
> +			   CSI_CAP_CH0_VCAP_ON);
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * Media Controller and V4L2
> + */
> +static int sun6i_csi_link_entity(struct sun6i_csi *csi,
> +				 struct media_entity *entity)
> +{
> +	struct media_entity *sink;
> +	struct media_pad *sink_pad;
> +	int ret;
> +	int i;
> +
> +	if (!entity->num_pads) {
> +		dev_err(csi->dev, "%s: invalid entity\n", entity->name);
> +		return -EINVAL;
> +	}
> +
> +	for (i = 0; i < entity->num_pads; i++) {
> +		if (entity->pads[i].flags & MEDIA_PAD_FL_SOURCE)
> +			break;
> +	}
> +
> +	if (i == entity->num_pads) {
> +		dev_err(csi->dev, "%s: no source pad in external entity %s\n",
> +			__func__, entity->name);
> +		return -EINVAL;
> +	}
> +
> +	sink = &csi->video.vdev.entity;
> +	sink_pad = &csi->video.pad;
> +
> +	dev_dbg(csi->dev, "creating %s:%u -> %s:%u link\n",
> +		entity->name, i, sink->name, sink_pad->index);
> +	ret = media_create_pad_link(entity, i, sink, sink_pad->index,
> +				    MEDIA_LNK_FL_ENABLED);
> +	if (ret < 0) {
> +		dev_err(csi->dev, "failed to create %s:%u -> %s:%u link\n",
> +			entity->name, i, sink->name, sink_pad->index);
> +		return ret;
> +	}
> +
> +	return media_entity_call(sink, link_setup, sink_pad, &entity->pads[i],
> +				 MEDIA_LNK_FL_ENABLED);
> +}
> +
> +static int sun6i_subdev_notify_complete(struct v4l2_async_notifier *notifier)
> +{
> +	struct sun6i_csi *csi = container_of(notifier, struct sun6i_csi,
> +					     notifier);
> +	struct v4l2_device *v4l2_dev = &csi->v4l2_dev;
> +	struct v4l2_subdev *sd;
> +	int ret;
> +
> +	dev_dbg(csi->dev, "notify complete, all subdevs registered\n");
> +
> +	if (notifier->num_subdevs != 1)
> +		return -EINVAL;
> +
> +	sd = list_first_entry(&v4l2_dev->subdevs, struct v4l2_subdev, list);
> +	if (sd == NULL)
> +		return -EINVAL;
> +
> +	ret = sun6i_csi_link_entity(csi, &sd->entity);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = v4l2_device_register_subdev_nodes(&csi->v4l2_dev);
> +	if (ret < 0)
> +		return ret;
> +
> +	return media_device_register(&csi->media_dev);
> +}
> +
> +static const struct v4l2_async_notifier_operations sun6i_csi_async_ops = {
> +	.complete = sun6i_subdev_notify_complete,
> +};
> +
> +static int sun6i_csi_fwnode_parse(struct device *dev,
> +				  struct v4l2_fwnode_endpoint *vep,
> +				  struct v4l2_async_subdev *asd)
> +{
> +	struct sun6i_csi *csi = dev_get_drvdata(dev);
> +
> +	if (vep->base.port || vep->base.id) {
> +		dev_warn(dev, "Only support a single port with one endpoint\n");
> +		return -ENOTCONN;
> +	}
> +
> +	switch (vep->bus_type) {
> +	case V4L2_MBUS_PARALLEL:
> +	case V4L2_MBUS_BT656:
> +		csi->v4l2_ep = *vep;
> +		return 0;
> +	default:
> +		dev_err(dev, "Unsupported media bus type\n");
> +		return -ENOTCONN;
> +	}
> +}
> +
> +static void sun6i_csi_v4l2_cleanup(struct sun6i_csi *csi)
> +{
> +	v4l2_async_notifier_cleanup(&csi->notifier);
> +	v4l2_async_notifier_unregister(&csi->notifier);
> +	sun6i_video_cleanup(&csi->video);
> +	v4l2_device_unregister(&csi->v4l2_dev);
> +	media_device_unregister(&csi->media_dev);
> +	media_device_cleanup(&csi->media_dev);
> +}
> +
> +static int sun6i_csi_v4l2_init(struct sun6i_csi *csi)
> +{
> +	int ret;
> +
> +	csi->media_dev.dev = csi->dev;
> +	strlcpy(csi->media_dev.model, "Allwinner Video Capture Device",
> +		sizeof(csi->media_dev.model));
> +	csi->media_dev.hw_revision = 0;
> +
> +	media_device_init(&csi->media_dev);
> +
> +	csi->v4l2_dev.mdev = &csi->media_dev;
> +	ret = v4l2_device_register(csi->dev, &csi->v4l2_dev);
> +	if (ret) {
> +		dev_err(csi->dev, "V4L2 device registration failed (%d)\n",
> +			ret);
> +		goto clean_media;
> +	}
> +
> +	ret = sun6i_video_init(&csi->video, csi, "sun6i-csi");
> +	if (ret)
> +		goto unreg_v4l2;
> +
> +	ret = v4l2_async_notifier_parse_fwnode_endpoints(
> +		csi->dev, &csi->notifier, sizeof(struct v4l2_async_subdev),
> +		sun6i_csi_fwnode_parse);
> +	if (ret)
> +		goto clean_video;
> +
> +	csi->notifier.ops = &sun6i_csi_async_ops;
> +
> +	ret = v4l2_async_notifier_register(&csi->v4l2_dev, &csi->notifier);
> +	if (ret) {
> +		dev_err(csi->dev, "notifier registration failed\n");
> +		goto clean_notifier;
> +	}
> +
> +	return 0;
> +
> +clean_notifier:
> +	v4l2_async_notifier_cleanup(&csi->notifier);
> +clean_video:
> +	sun6i_video_cleanup(&csi->video);
> +unreg_v4l2:
> +	v4l2_device_unregister(&csi->v4l2_dev);
> +clean_media:
> +	media_device_cleanup(&csi->media_dev);
> +
> +	return ret;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * Resources and IRQ
> + */
> +static irqreturn_t sun6i_csi_isr(int irq, void *dev_id)
> +{
> +	struct sun6i_csi_dev *sdev = (struct sun6i_csi_dev *)dev_id;
> +	struct regmap *regmap = sdev->regmap;
> +	u32 status;
> +
> +	regmap_read(regmap, CSI_CH_INT_STA_REG, &status);
> +
> +	if (!(status & 0xFF))
> +		return IRQ_NONE;
> +
> +	if ((status & CSI_CH_INT_STA_FIFO0_OF_PD) ||
> +	    (status & CSI_CH_INT_STA_FIFO1_OF_PD) ||
> +	    (status & CSI_CH_INT_STA_FIFO2_OF_PD) ||
> +	    (status & CSI_CH_INT_STA_HB_OF_PD)) {
> +		regmap_write(regmap, CSI_CH_INT_STA_REG, status);
> +		regmap_update_bits(regmap, CSI_EN_REG, CSI_EN_CSI_EN, 0);
> +		regmap_update_bits(regmap, CSI_EN_REG, CSI_EN_CSI_EN,
> +				   CSI_EN_CSI_EN);
> +		return IRQ_HANDLED;
> +	}
> +
> +	if (status & CSI_CH_INT_STA_FD_PD)
> +		sun6i_video_frame_done(&sdev->csi.video);
> +
> +	regmap_write(regmap, CSI_CH_INT_STA_REG, status);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static const struct regmap_config sun6i_csi_regmap_config = {
> +	.reg_bits       = 32,
> +	.reg_stride     = 4,
> +	.val_bits       = 32,
> +	.max_register	= 0x1000,
> +};
> +
> +static int sun6i_csi_resource_request(struct sun6i_csi_dev *sdev,
> +				      struct platform_device *pdev)
> +{
> +	struct resource *res;
> +	void __iomem *io_base;
> +	int ret;
> +	int irq;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	io_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(io_base))
> +		return PTR_ERR(io_base);
> +
> +	sdev->regmap = devm_regmap_init_mmio_clk(&pdev->dev, "bus", io_base,
> +					    &sun6i_csi_regmap_config);
> +	if (IS_ERR(sdev->regmap)) {
> +		dev_err(&pdev->dev, "Failed to init register map\n");
> +		return PTR_ERR(sdev->regmap);
> +	}
> +
> +	sdev->clk_mod = devm_clk_get(&pdev->dev, "mod");
> +	if (IS_ERR(sdev->clk_mod)) {
> +		dev_err(&pdev->dev, "Unable to acquire csi clock\n");
> +		return PTR_ERR(sdev->clk_mod);
> +	}
> +
> +	sdev->clk_ram = devm_clk_get(&pdev->dev, "ram");
> +	if (IS_ERR(sdev->clk_ram)) {
> +		dev_err(&pdev->dev, "Unable to acquire dram-csi clock\n");
> +		return PTR_ERR(sdev->clk_ram);
> +	}
> +
> +	sdev->rstc_bus = devm_reset_control_get_shared(&pdev->dev, NULL);
> +	if (IS_ERR(sdev->rstc_bus)) {
> +		dev_err(&pdev->dev, "Cannot get reset controller\n");
> +		return PTR_ERR(sdev->rstc_bus);
> +	}
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		dev_err(&pdev->dev, "No csi IRQ specified\n");
> +		ret = -ENXIO;
> +		return ret;
> +	}
> +
> +	ret = devm_request_irq(&pdev->dev, irq, sun6i_csi_isr, 0, MODULE_NAME,
> +			       sdev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Cannot request csi IRQ\n");
> +		return ret;
> +	}
> +	return 0;
> +}
> +
> +static int sun6i_csi_probe(struct platform_device *pdev)
> +{
> +	struct sun6i_csi_dev *sdev;
> +	int ret;
> +
> +	sdev = devm_kzalloc(&pdev->dev, sizeof(*sdev), GFP_KERNEL);
> +	if (!sdev)
> +		return -ENOMEM;
> +
> +	sdev->dev = &pdev->dev;
> +
> +	ret = sun6i_csi_resource_request(sdev, pdev);
> +	if (ret)
> +		return ret;
> +
> +	platform_set_drvdata(pdev, sdev);
> +
> +	sdev->csi.dev = &pdev->dev;
> +	ret = sun6i_csi_v4l2_init(&sdev->csi);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int sun6i_csi_remove(struct platform_device *pdev)
> +{
> +	struct sun6i_csi_dev *sdev = platform_get_drvdata(pdev);
> +
> +	sun6i_csi_v4l2_cleanup(&sdev->csi);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id sun6i_csi_of_match[] = {
> +	{ .compatible = "allwinner,sun8i-v3s-csi", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, sun6i_csi_of_match);
> +
> +static struct platform_driver sun6i_csi_platform_driver = {
> +	.probe = sun6i_csi_probe,
> +	.remove = sun6i_csi_remove,
> +	.driver = {
> +		.name = MODULE_NAME,
> +		.of_match_table = of_match_ptr(sun6i_csi_of_match),
> +	},
> +};
> +module_platform_driver(sun6i_csi_platform_driver);
> +
> +MODULE_DESCRIPTION("Allwinner V3s Camera Sensor Interface driver");
> +MODULE_AUTHOR("Yong Deng <yong.deng@magewell.com>");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h
> new file mode 100644
> index 0000000..6733a1e
> --- /dev/null
> +++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h
> @@ -0,0 +1,147 @@
> +/*
> + * Copyright (c) 2017 Yong Deng <yong.deng@magewell.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __SUN6I_CSI_H__
> +#define __SUN6I_CSI_H__
> +
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-fwnode.h>
> +
> +#include "sun6i_video.h"
> +
> +struct sun6i_csi;
> +
> +/**
> + * struct sun6i_csi_config - configs for sun6i csi
> + * @pixelformat: v4l2 pixel format (V4L2_PIX_FMT_*)
> + * @code:	media bus format code (MEDIA_BUS_FMT_*)
> + * @field:	used interlacing type (enum v4l2_field)
> + * @width:	frame width
> + * @height:	frame height
> + */
> +struct sun6i_csi_config {
> +	u32		pixelformat;
> +	u32		code;
> +	u32		field;
> +	u32		width;
> +	u32		height;
> +};
> +
> +struct sun6i_csi {
> +	struct device			*dev;
> +	struct v4l2_device		v4l2_dev;
> +	struct media_device		media_dev;
> +
> +	struct v4l2_async_notifier	notifier;
> +
> +	/* video port settings */
> +	struct v4l2_fwnode_endpoint	v4l2_ep;
> +
> +	struct sun6i_csi_config		config;
> +
> +	struct sun6i_video		video;
> +};
> +
> +/**
> + * sun6i_csi_get_supported_pixformats() - get csi supported pixformats
> + * @csi:	pointer to the csi
> + * @pixformats:	supported pixformats return from csi
> + *
> + * @return the count of pixformats or error(< 0)
> + */
> +int sun6i_csi_get_supported_pixformats(struct sun6i_csi *csi,
> +				       const u32 **pixformats);
> +
> +/**
> + * sun6i_csi_is_format_support() - check if the format supported by csi
> + * @csi:	pointer to the csi
> + * @pixformat:	v4l2 pixel format (V4L2_PIX_FMT_*)
> + * @mbus_code:	media bus format code (MEDIA_BUS_FMT_*)
> + */
> +bool sun6i_csi_is_format_support(struct sun6i_csi *csi, u32 pixformat,
> +				 u32 mbus_code);
> +
> +/**
> + * sun6i_csi_set_power() - power on/off the csi
> + * @csi:	pointer to the csi
> + * @enable:	on/off
> + */
> +int sun6i_csi_set_power(struct sun6i_csi *csi, bool enable);
> +
> +/**
> + * sun6i_csi_update_config() - update the csi register setttings
> + * @csi:	pointer to the csi
> + * @config:	see struct sun6i_csi_config
> + */
> +int sun6i_csi_update_config(struct sun6i_csi *csi,
> +			    struct sun6i_csi_config *config);
> +
> +/**
> + * sun6i_csi_update_buf_addr() - update the csi frame buffer address
> + * @csi:	pointer to the csi
> + * @addr:	frame buffer's physical address
> + */
> +void sun6i_csi_update_buf_addr(struct sun6i_csi *csi, dma_addr_t addr);
> +
> +/**
> + * sun6i_csi_set_stream() - start/stop csi streaming
> + * @csi:	pointer to the csi
> + * @enable:	start/stop
> + */
> +void sun6i_csi_set_stream(struct sun6i_csi *csi, bool enable);
> +
> +/* get bpp form v4l2 pixformat */
> +static inline int sun6i_csi_get_bpp(unsigned int pixformat)
> +{
> +	switch (pixformat) {
> +	case V4L2_PIX_FMT_SBGGR8:
> +	case V4L2_PIX_FMT_SGBRG8:
> +	case V4L2_PIX_FMT_SGRBG8:
> +	case V4L2_PIX_FMT_SRGGB8:
> +		return 8;
> +	case V4L2_PIX_FMT_SBGGR10:
> +	case V4L2_PIX_FMT_SGBRG10:
> +	case V4L2_PIX_FMT_SGRBG10:
> +	case V4L2_PIX_FMT_SRGGB10:
> +		return 10;
> +	case V4L2_PIX_FMT_SBGGR12:
> +	case V4L2_PIX_FMT_SGBRG12:
> +	case V4L2_PIX_FMT_SGRBG12:
> +	case V4L2_PIX_FMT_SRGGB12:
> +	case V4L2_PIX_FMT_HM12:
> +	case V4L2_PIX_FMT_NV12:
> +	case V4L2_PIX_FMT_NV21:
> +	case V4L2_PIX_FMT_YUV420:
> +	case V4L2_PIX_FMT_YVU420:
> +		return 12;
> +	case V4L2_PIX_FMT_YUYV:
> +	case V4L2_PIX_FMT_YVYU:
> +	case V4L2_PIX_FMT_UYVY:
> +	case V4L2_PIX_FMT_VYUY:
> +	case V4L2_PIX_FMT_NV16:
> +	case V4L2_PIX_FMT_NV61:
> +	case V4L2_PIX_FMT_YUV422P:
> +		return 16;
> +	case V4L2_PIX_FMT_RGB24:
> +	case V4L2_PIX_FMT_BGR24:
> +		return 24;
> +	case V4L2_PIX_FMT_RGB32:
> +	case V4L2_PIX_FMT_BGR32:
> +		return 32;
Please add default case with warning.
> +	}
> +
> +	return 0;
> +}
> +
> +#endif /* __SUN6I_CSI_H__ */
> diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h
> new file mode 100644
> index 0000000..aad674a
> --- /dev/null
> +++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h
> @@ -0,0 +1,203 @@
> +/*
> + * Copyright (c) 2017 Yong Deng <yong.deng@magewell.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __SUN6I_CSI_REG_H__
> +#define __SUN6I_CSI_REG_H__
> +
> +#include <linux/kernel.h>
> +
> +#define CSI_EN_REG			0x0
> +#define CSI_EN_VER_EN				BIT(30)
> +#define CSI_EN_CSI_EN				BIT(0)
> +
> +#define CSI_IF_CFG_REG			0x4
> +#define CSI_IF_CFG_SRC_TYPE_MASK		BIT(21)
> +#define CSI_IF_CFG_SRC_TYPE_PROGRESSED		((0 << 21) & CSI_IF_CFG_SRC_TYPE_MASK)
> +#define CSI_IF_CFG_SRC_TYPE_INTERLACED		((1 << 21) & CSI_IF_CFG_SRC_TYPE_MASK)
> +#define CSI_IF_CFG_FPS_DS_EN			BIT(20)
> +#define CSI_IF_CFG_FIELD_MASK			BIT(19)
> +#define CSI_IF_CFG_FIELD_NEGATIVE		((0 << 19) & CSI_IF_CFG_FIELD_MASK)
> +#define CSI_IF_CFG_FIELD_POSITIVE		((1 << 19) & CSI_IF_CFG_FIELD_MASK)
> +#define CSI_IF_CFG_VREF_POL_MASK		BIT(18)
> +#define CSI_IF_CFG_VREF_POL_NEGATIVE		((0 << 18) & CSI_IF_CFG_VREF_POL_MASK)
> +#define CSI_IF_CFG_VREF_POL_POSITIVE		((1 << 18) & CSI_IF_CFG_VREF_POL_MASK)
> +#define CSI_IF_CFG_HREF_POL_MASK		BIT(17)
> +#define CSI_IF_CFG_HREF_POL_NEGATIVE		((0 << 17) & CSI_IF_CFG_HREF_POL_MASK)
> +#define CSI_IF_CFG_HREF_POL_POSITIVE		((1 << 17) & CSI_IF_CFG_HREF_POL_MASK)
> +#define CSI_IF_CFG_CLK_POL_MASK			BIT(16)
> +#define CSI_IF_CFG_CLK_POL_RISING_EDGE		((0 << 16) & CSI_IF_CFG_CLK_POL_MASK)
> +#define CSI_IF_CFG_CLK_POL_FALLING_EDGE		((1 << 16) & CSI_IF_CFG_CLK_POL_MASK)
> +#define CSI_IF_CFG_IF_DATA_WIDTH_MASK		GENMASK(10, 8)
> +#define CSI_IF_CFG_IF_DATA_WIDTH_8BIT		((0 << 8) & CSI_IF_CFG_IF_DATA_WIDTH_MASK)
> +#define CSI_IF_CFG_IF_DATA_WIDTH_10BIT		((1 << 8) & CSI_IF_CFG_IF_DATA_WIDTH_MASK)
> +#define CSI_IF_CFG_IF_DATA_WIDTH_12BIT		((2 << 8) & CSI_IF_CFG_IF_DATA_WIDTH_MASK)
> +#define CSI_IF_CFG_MIPI_IF_MASK			BIT(7)
> +#define CSI_IF_CFG_MIPI_IF_CSI			(0 << 7)
> +#define CSI_IF_CFG_MIPI_IF_MIPI			(1 << 7)
> +#define CSI_IF_CFG_CSI_IF_MASK			GENMASK(4, 0)
> +#define CSI_IF_CFG_CSI_IF_YUV422_INTLV		((0 << 0) & CSI_IF_CFG_CSI_IF_MASK)
> +#define CSI_IF_CFG_CSI_IF_YUV422_16BIT		((1 << 0) & CSI_IF_CFG_CSI_IF_MASK)
> +#define CSI_IF_CFG_CSI_IF_BT656			((4 << 0) & CSI_IF_CFG_CSI_IF_MASK)
> +#define CSI_IF_CFG_CSI_IF_BT1120		((5 << 0) & CSI_IF_CFG_CSI_IF_MASK)
> +
> +#define CSI_CAP_REG			0x8
> +#define CSI_CAP_CH0_CAP_MASK_MASK		GENMASK(5, 2)
> +#define CSI_CAP_CH0_CAP_MASK(count)		((count << 2) & CSI_CAP_CH0_CAP_MASK_MASK)
> +#define CSI_CAP_CH0_VCAP_ON			BIT(1)
> +#define CSI_CAP_CH0_SCAP_ON			BIT(0)
> +
> +#define CSI_SYNC_CNT_REG		0xc
> +#define CSI_FIFO_THRS_REG		0x10
> +#define CSI_BT656_HEAD_CFG_REG		0x14
> +#define CSI_PTN_LEN_REG			0x30
> +#define CSI_PTN_ADDR_REG		0x34
> +#define CSI_VER_REG			0x3c
> +
> +#define CSI_CH_CFG_REG			0x44
> +#define CSI_CH_CFG_INPUT_FMT_MASK		GENMASK(23, 20)
> +#define CSI_CH_CFG_INPUT_FMT(fmt)		((fmt << 20) & CSI_CH_CFG_INPUT_FMT_MASK)
> +#define CSI_CH_CFG_OUTPUT_FMT_MASK		GENMASK(19, 16)
> +#define CSI_CH_CFG_OUTPUT_FMT(fmt)		((fmt << 16) & CSI_CH_CFG_OUTPUT_FMT_MASK)
> +#define CSI_CH_CFG_VFLIP_EN			BIT(13)
> +#define CSI_CH_CFG_HFLIP_EN			BIT(12)
> +#define CSI_CH_CFG_FIELD_SEL_MASK		GENMASK(11, 10)
> +#define CSI_CH_CFG_FIELD_SEL_FIELD0		((0 << 10) & CSI_CH_CFG_FIELD_SEL_MASK)
> +#define CSI_CH_CFG_FIELD_SEL_FIELD1		((1 << 10) & CSI_CH_CFG_FIELD_SEL_MASK)
> +#define CSI_CH_CFG_FIELD_SEL_BOTH		((2 << 10) & CSI_CH_CFG_FIELD_SEL_MASK)
> +#define CSI_CH_CFG_INPUT_SEQ_MASK		GENMASK(9, 8)
> +#define CSI_CH_CFG_INPUT_SEQ(seq)		((seq << 8) & CSI_CH_CFG_INPUT_SEQ_MASK)
> +
> +#define CSI_CH_SCALE_REG		0x4c
> +#define CSI_CH_SCALE_QUART_EN			BIT(0)
> +
> +#define CSI_CH_F0_BUFA_REG		0x50
> +
> +#define CSI_CH_F1_BUFA_REG		0x58
> +
> +#define CSI_CH_F2_BUFA_REG		0x60
> +
> +#define CSI_CH_STA_REG			0x6c
> +#define CSI_CH_STA_FIELD_STA_MASK		BIT(2)
> +#define CSI_CH_STA_FIELD_STA_FIELD0		((0 << 2) & CSI_CH_STA_FIELD_STA_MASK)
> +#define CSI_CH_STA_FIELD_STA_FIELD1		((1 << 2) & CSI_CH_STA_FIELD_STA_MASK)
> +#define CSI_CH_STA_VCAP_STA			BIT(1)
> +#define CSI_CH_STA_SCAP_STA			BIT(0)
> +
> +#define CSI_CH_INT_EN_REG		0x70
> +#define CSI_CH_INT_EN_VS_INT_EN			BIT(7)
> +#define CSI_CH_INT_EN_HB_OF_INT_EN		BIT(6)
> +#define CSI_CH_INT_EN_MUL_ERR_INT_EN		BIT(5)
> +#define CSI_CH_INT_EN_FIFO2_OF_INT_EN		BIT(4)
> +#define CSI_CH_INT_EN_FIFO1_OF_INT_EN		BIT(3)
> +#define CSI_CH_INT_EN_FIFO0_OF_INT_EN		BIT(2)
> +#define CSI_CH_INT_EN_FD_INT_EN			BIT(1)
> +#define CSI_CH_INT_EN_CD_INT_EN			BIT(0)
> +
> +#define CSI_CH_INT_STA_REG		0x74
> +#define CSI_CH_INT_STA_VS_PD			BIT(7)
> +#define CSI_CH_INT_STA_HB_OF_PD			BIT(6)
> +#define CSI_CH_INT_STA_MUL_ERR_PD		BIT(5)
> +#define CSI_CH_INT_STA_FIFO2_OF_PD		BIT(4)
> +#define CSI_CH_INT_STA_FIFO1_OF_PD		BIT(3)
> +#define CSI_CH_INT_STA_FIFO0_OF_PD		BIT(2)
> +#define CSI_CH_INT_STA_FD_PD			BIT(1)
> +#define CSI_CH_INT_STA_CD_PD			BIT(0)
> +
> +#define CSI_CH_FLD1_VSIZE_REG		0x78
> +
> +#define CSI_CH_HSIZE_REG		0x80
> +#define CSI_CH_HSIZE_HOR_LEN_MASK		GENMASK(28, 16)
> +#define CSI_CH_HSIZE_HOR_LEN(len)		((len << 16) & CSI_CH_HSIZE_HOR_LEN_MASK)
> +#define CSI_CH_HSIZE_HOR_START_MASK		GENMASK(12, 0)
> +#define CSI_CH_HSIZE_HOR_START(start)		((start << 0) & CSI_CH_HSIZE_HOR_START_MASK)
> +
> +#define CSI_CH_VSIZE_REG		0x84
> +#define CSI_CH_VSIZE_VER_LEN_MASK		GENMASK(28, 16)
> +#define CSI_CH_VSIZE_VER_LEN(len)		((len << 16) & CSI_CH_VSIZE_VER_LEN_MASK)
> +#define CSI_CH_VSIZE_VER_START_MASK		GENMASK(12, 0)
> +#define CSI_CH_VSIZE_VER_START(start)		((start << 0) & CSI_CH_VSIZE_VER_START_MASK)
> +
> +#define CSI_CH_BUF_LEN_REG		0x88
> +#define CSI_CH_BUF_LEN_BUF_LEN_C_MASK		GENMASK(29, 16)
> +#define CSI_CH_BUF_LEN_BUF_LEN_C(len)		((len << 16) & CSI_CH_BUF_LEN_BUF_LEN_C_MASK)
> +#define CSI_CH_BUF_LEN_BUF_LEN_Y_MASK		GENMASK(13, 0)
> +#define CSI_CH_BUF_LEN_BUF_LEN_Y(len)		((len << 0) & CSI_CH_BUF_LEN_BUF_LEN_Y_MASK)
> +
> +#define CSI_CH_FLIP_SIZE_REG		0x8c
> +#define CSI_CH_FLIP_SIZE_VER_LEN_MASK		GENMASK(28, 16)
> +#define CSI_CH_FLIP_SIZE_VER_LEN(len)		((len << 16) & CSI_CH_FLIP_SIZE_VER_LEN_MASK)
> +#define CSI_CH_FLIP_SIZE_VALID_LEN_MASK		GENMASK(12, 0)
> +#define CSI_CH_FLIP_SIZE_VALID_LEN(len)		((len << 0) & CSI_CH_FLIP_SIZE_VALID_LEN_MASK)
> +
> +#define CSI_CH_FRM_CLK_CNT_REG		0x90
> +#define CSI_CH_ACC_ITNL_CLK_CNT_REG	0x94
> +#define CSI_CH_FIFO_STAT_REG		0x98
> +#define CSI_CH_PCLK_STAT_REG		0x9c
> +
> +/*
> + * csi input data format
> + */
> +enum csi_input_fmt {
> +	CSI_INPUT_FORMAT_RAW		= 0,
> +	CSI_INPUT_FORMAT_YUV422		= 3,
> +	CSI_INPUT_FORMAT_YUV420		= 4,
> +};
> +
> +/*
> + * csi output data format
> + */
> +enum csi_output_fmt {
> +	/* only when input format is RAW */
> +	CSI_FIELD_RAW_8			= 0,
> +	CSI_FIELD_RAW_10		= 1,
> +	CSI_FIELD_RAW_12		= 2,
> +	CSI_FIELD_RGB565		= 4,
> +	CSI_FIELD_RGB888		= 5,
> +	CSI_FIELD_PRGB888		= 6,
> +	CSI_FRAME_RAW_8			= 8,
> +	CSI_FRAME_RAW_10		= 9,
> +	CSI_FRAME_RAW_12		= 10,
> +	CSI_FRAME_RGB565		= 12,
> +	CSI_FRAME_RGB888		= 13,
> +	CSI_FRAME_PRGB888		= 14,
> +
> +	/* only when input format is YUV422 */
> +	CSI_FIELD_PLANAR_YUV422		= 0,
> +	CSI_FIELD_PLANAR_YUV420		= 1,
> +	CSI_FRAME_PLANAR_YUV420		= 2,
> +	CSI_FRAME_PLANAR_YUV422		= 3,
> +	CSI_FIELD_UV_CB_YUV422		= 4,
> +	CSI_FIELD_UV_CB_YUV420		= 5,
> +	CSI_FRAME_UV_CB_YUV420		= 6,
> +	CSI_FRAME_UV_CB_YUV422		= 7,
> +	CSI_FIELD_MB_YUV422		= 8,
> +	CSI_FIELD_MB_YUV420		= 9,
> +	CSI_FRAME_MB_YUV420		= 10,
> +	CSI_FRAME_MB_YUV422		= 11,
> +	CSI_FIELD_UV_CB_YUV422_10	= 12,
> +	CSI_FIELD_UV_CB_YUV420_10	= 13,
> +};
> +
> +/*
> + * csi YUV input data sequence
> + */
> +enum csi_input_seq {
> +	/* only when input format is YUV422 */
> +	CSI_INPUT_SEQ_YUYV = 0,
> +	CSI_INPUT_SEQ_YVYU,
> +	CSI_INPUT_SEQ_UYVY,
> +	CSI_INPUT_SEQ_VYUY,
> +};
> +
> +#endif /* __SUN6I_CSI_REG_H__ */
> diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
> new file mode 100644
> index 0000000..2b683ac
> --- /dev/null
> +++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
> @@ -0,0 +1,752 @@
> +/*
> + * Copyright (c) 2017 Magewell Electronics Co., Ltd. (Nanjing).
> + * All rights reserved.
> + * Author: Yong Deng <yong.deng@magewell.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/of.h>
> +
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-mc.h>
> +#include <media/videobuf2-dma-contig.h>
> +#include <media/videobuf2-v4l2.h>
> +
> +#include "sun6i_csi.h"
> +#include "sun6i_video.h"
> +
> +struct sun6i_csi_buffer {
> +	struct vb2_v4l2_buffer		vb;
> +	struct list_head		list;
> +
> +	dma_addr_t			dma_addr;
> +	bool				queued_to_csi;
> +};
> +
> +static struct sun6i_csi_format *
> +find_format_by_pixformat(struct sun6i_video *video, unsigned int pixformat)
> +{
> +	unsigned int num_formats = video->num_formats;
> +	struct sun6i_csi_format *fmt;
> +	unsigned int i;
> +
> +	for (i = 0; i < num_formats; i++) {
> +		fmt = &video->formats[i];
> +		if (fmt->pixformat == pixformat)
> +			return fmt;
> +	}
> +
> +	return NULL;
> +}
> +
> +static struct v4l2_subdev *
> +sun6i_video_remote_subdev(struct sun6i_video *video, u32 *pad)
> +{
> +	struct media_pad *remote;
> +
> +	remote = media_entity_remote_pad(&video->pad);
> +
> +	if (!remote || !is_media_entity_v4l2_subdev(remote->entity))
> +		return NULL;
> +
> +	if (pad)
> +		*pad = remote->index;
> +
> +	return media_entity_to_v4l2_subdev(remote->entity);
> +}
> +
> +static int sun6i_video_queue_setup(struct vb2_queue *vq,
> +				 unsigned int *nbuffers, unsigned int *nplanes,
> +				 unsigned int sizes[],
> +				 struct device *alloc_devs[])
> +{
> +	struct sun6i_video *video = vb2_get_drv_priv(vq);
> +	unsigned int size = video->fmt.fmt.pix.sizeimage;
> +
> +	if (*nplanes)
> +		return sizes[0] < size ? -EINVAL : 0;
> +
> +	*nplanes = 1;
> +	sizes[0] = size;
> +
> +	return 0;
> +}
> +
> +static int sun6i_video_buffer_prepare(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct sun6i_csi_buffer *buf =
> +			container_of(vbuf, struct sun6i_csi_buffer, vb);
> +	struct sun6i_video *video = vb2_get_drv_priv(vb->vb2_queue);
> +	unsigned long size = video->fmt.fmt.pix.sizeimage;
> +
> +	if (vb2_plane_size(vb, 0) < size) {
> +		v4l2_err(video->vdev.v4l2_dev, "buffer too small (%lu < %lu)\n",
> +			 vb2_plane_size(vb, 0), size);
> +		return -EINVAL;
> +	}
> +
> +	vb2_set_plane_payload(vb, 0, size);
> +
> +	buf->dma_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
> +
> +	vbuf->field = video->fmt.fmt.pix.field;
> +
> +	return 0;
> +}
> +
> +static int sun6i_pipeline_set_stream(struct sun6i_video *video, bool enable)
> +{
> +	struct media_entity *entity;
> +	struct media_pad *pad;
> +	struct v4l2_subdev *subdev;
> +	int ret;
> +
> +	entity = &video->vdev.entity;
> +	while (1) {
> +		pad = &entity->pads[0];
> +		if (!(pad->flags & MEDIA_PAD_FL_SINK))
> +			break;
> +
> +		pad = media_entity_remote_pad(pad);
> +		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
> +			break;
> +
> +		entity = pad->entity;
> +		subdev = media_entity_to_v4l2_subdev(entity);
> +
> +		ret = v4l2_subdev_call(subdev, video, s_stream, enable);
> +		if (enable && ret < 0 && ret != -ENOIOCTLCMD)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int sun6i_video_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct sun6i_video *video = vb2_get_drv_priv(vq);
> +	struct sun6i_csi_buffer *buf;
> +	struct sun6i_csi_buffer *next_buf;
> +	struct sun6i_csi_config config;
> +	unsigned long flags;
> +	int ret;
> +
> +	video->sequence = 0;
> +
> +	ret = media_pipeline_start(&video->vdev.entity, &video->vdev.pipe);
> +	if (ret < 0)
> +		goto clear_dma_queue;
> +
> +	config.pixelformat = video->fmt.fmt.pix.pixelformat;
> +	config.code = video->current_fmt->mbus_code;
> +	config.field = video->fmt.fmt.pix.field;
> +	config.width = video->fmt.fmt.pix.width;
> +	config.height = video->fmt.fmt.pix.height;
> +
> +	ret = sun6i_csi_update_config(video->csi, &config);
> +	if (ret < 0)
> +		goto stop_media_pipeline;
> +
> +	spin_lock_irqsave(&video->dma_queue_lock, flags);
> +
> +	buf = list_first_entry(&video->dma_queue,
> +			       struct sun6i_csi_buffer, list);
> +	buf->queued_to_csi = true;
> +	sun6i_csi_update_buf_addr(video->csi, buf->dma_addr);
> +
> +	sun6i_csi_set_stream(video->csi, true);
> +
> +	/*
> +	 * CSI will lookup the next dma buffer for next frame before the
> +	 * the current frame done IRQ triggered. This is not documented
> +	 * but reported by Ondřej Jirman.
> +	 * The BSP code has workaround for this too. It skip to mark the
> +	 * first buffer as frame done for VB2 and pass the second buffer
> +	 * to CSI in the first frame done ISR call. Then in second frame
> +	 * done ISR call, it mark the first buffer as frame done for VB2
> +	 * and pass the third buffer to CSI. And so on. The bad thing is
> +	 * that the first buffer will be written twice and the first frame
> +	 * is dropped even the queued buffer is sufficient.
> +	 * So, I make some improvement here. Pass the next buffer to CSI
> +	 * just follow starting the CSI. In this case, the first frame
> +	 * will be stored in first buffer, second frame in second buffer.
> +	 * This mothed is used to avoid dropping the first frame, it
/s/mothed/method
> +	 * would also drop frame when lacking of queued buffer.
> +	 */
> +	next_buf = list_next_entry(buf, list);
> +	next_buf->queued_to_csi = true;
> +	sun6i_csi_update_buf_addr(video->csi, next_buf->dma_addr);
> +
> +	spin_unlock_irqrestore(&video->dma_queue_lock, flags);
> +
> +	ret = sun6i_pipeline_set_stream(video, true);
> +	if (ret < 0)
> +		goto stop_csi_stream;
> +
> +	return 0;
> +
> +stop_csi_stream:
> +	sun6i_csi_set_stream(video->csi, false);
> +stop_media_pipeline:
> +	media_pipeline_stop(&video->vdev.entity);
> +clear_dma_queue:
> +	spin_lock_irqsave(&video->dma_queue_lock, flags);
> +	list_for_each_entry(buf, &video->dma_queue, list)
> +		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
> +	INIT_LIST_HEAD(&video->dma_queue);
> +	spin_unlock_irqrestore(&video->dma_queue_lock, flags);
> +
> +	return ret;
> +}
> +
> +static void sun6i_video_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct sun6i_video *video = vb2_get_drv_priv(vq);
> +	unsigned long flags;
> +	struct sun6i_csi_buffer *buf;
> +
> +	sun6i_pipeline_set_stream(video, false);
> +
> +	sun6i_csi_set_stream(video->csi, false);
> +
> +	media_pipeline_stop(&video->vdev.entity);
> +
> +	/* Release all active buffers */
> +	spin_lock_irqsave(&video->dma_queue_lock, flags);
> +	list_for_each_entry(buf, &video->dma_queue, list)
> +		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> +	INIT_LIST_HEAD(&video->dma_queue);
> +	spin_unlock_irqrestore(&video->dma_queue_lock, flags);
> +}
> +
> +static void sun6i_video_buffer_queue(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct sun6i_csi_buffer *buf =
> +			container_of(vbuf, struct sun6i_csi_buffer, vb);
> +	struct sun6i_video *video = vb2_get_drv_priv(vb->vb2_queue);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&video->dma_queue_lock, flags);
> +	buf->queued_to_csi = false;
> +	list_add_tail(&buf->list, &video->dma_queue);
> +	spin_unlock_irqrestore(&video->dma_queue_lock, flags);
> +}
> +
> +void sun6i_video_frame_done(struct sun6i_video *video)
> +{
> +	struct sun6i_csi_buffer *buf;
> +	struct sun6i_csi_buffer *next_buf;
> +	struct vb2_v4l2_buffer *vbuf;
> +
> +	spin_lock(&video->dma_queue_lock);
> +
> +	buf = list_first_entry(&video->dma_queue,
> +			       struct sun6i_csi_buffer, list);
> +	if (list_is_last(&buf->list, &video->dma_queue)) {
> +		dev_dbg(video->csi->dev, "Frame droped!\n");
> +		goto unlock;
> +	}
> +
> +	next_buf = list_next_entry(buf, list);
> +	/* If a new buffer (#next_buf) had not been queued to CSI, the old
> +	 * buffer (#buf) is still holding by CSI for storing the next
> +	 * frame. So, we queue a new buffer (#next_buf) to CSI then wait
> +	 * for next ISR call.
> +	 */
> +	if (!next_buf->queued_to_csi) {
> +		next_buf->queued_to_csi = true;
> +		sun6i_csi_update_buf_addr(video->csi, next_buf->dma_addr);
> +		dev_dbg(video->csi->dev, "Frame droped!\n");
> +		goto unlock;
> +	}
> +
> +	list_del(&buf->list);
> +	vbuf = &buf->vb;
> +	vbuf->vb2_buf.timestamp = ktime_get_ns();
> +	vbuf->sequence = video->sequence;
> +	vb2_buffer_done(&vbuf->vb2_buf, VB2_BUF_STATE_DONE);
> +
> +	/* Prepare buffer for next frame but one.  */
> +	if (!list_is_last(&next_buf->list, &video->dma_queue)) {
> +		next_buf = list_next_entry(next_buf, list);
> +		next_buf->queued_to_csi = true;
> +		sun6i_csi_update_buf_addr(video->csi, next_buf->dma_addr);
> +	} else {
> +		dev_dbg(video->csi->dev, "Next frame will be droped!\n");

s/droped/dropped
> +	}
> +
> +unlock:
> +	video->sequence++;
> +	spin_unlock(&video->dma_queue_lock);
> +}
> +
> +static struct vb2_ops sun6i_csi_vb2_ops = {
> +	.queue_setup		= sun6i_video_queue_setup,
> +	.wait_prepare		= vb2_ops_wait_prepare,
> +	.wait_finish		= vb2_ops_wait_finish,
> +	.buf_prepare		= sun6i_video_buffer_prepare,
> +	.start_streaming	= sun6i_video_start_streaming,
> +	.stop_streaming		= sun6i_video_stop_streaming,
> +	.buf_queue		= sun6i_video_buffer_queue,
> +};
> +
> +static int vidioc_querycap(struct file *file, void *priv,
> +				struct v4l2_capability *cap)
> +{
> +	struct sun6i_video *video = video_drvdata(file);
> +
> +	strlcpy(cap->driver, "sun6i-video", sizeof(cap->driver));
> +	strlcpy(cap->card, video->vdev.name, sizeof(cap->card));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
> +		 video->csi->dev->of_node->name);
> +
> +	return 0;
> +}
> +
> +static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
> +				   struct v4l2_fmtdesc *f)
> +{
> +	struct sun6i_video *video = video_drvdata(file);
> +	u32 index = f->index;
> +
> +	if (index >= video->num_formats)
> +		return -EINVAL;
> +
> +	f->pixelformat = video->formats[index].pixformat;
> +
> +	return 0;
> +}
> +
> +static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *fmt)
> +{
> +	struct sun6i_video *video = video_drvdata(file);
> +
> +	*fmt = video->fmt;
> +
> +	return 0;
> +}
> +
> +static int sun6i_video_try_fmt(struct sun6i_video *video, struct v4l2_format *f,
> +			       struct sun6i_csi_format **current_fmt)
> +{
> +	struct sun6i_csi_format *csi_fmt;
> +	struct v4l2_pix_format *pixfmt = &f->fmt.pix;
> +	struct v4l2_subdev_format format;
> +	struct v4l2_subdev *subdev;
> +	u32 pad;
> +	int ret;
> +
> +	subdev = sun6i_video_remote_subdev(video, &pad);
> +	if (subdev == NULL)
> +		return -ENXIO;
> +
> +	csi_fmt = find_format_by_pixformat(video, pixfmt->pixelformat);
> +	if (csi_fmt == NULL) {
> +		if (video->num_formats > 0) {
> +			csi_fmt = &video->formats[0];
> +			pixfmt->pixelformat = csi_fmt->pixformat;
> +		} else
> +			return -EINVAL;
> +	}
> +
> +	format.pad = pad;
> +	format.which = V4L2_SUBDEV_FORMAT_TRY;
> +	v4l2_fill_mbus_format(&format.format, pixfmt, csi_fmt->mbus_code);
> +	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &format);
> +	if (ret)
> +		return ret;
> +
> +	v4l2_fill_pix_format(pixfmt, &format.format);
> +
> +	pixfmt->bytesperline = (pixfmt->width * csi_fmt->bpp) >> 3;
> +	pixfmt->sizeimage = (pixfmt->width * csi_fmt->bpp * pixfmt->height) / 8;
> +
> +	if (current_fmt)
> +		*current_fmt = csi_fmt;
> +
> +	return 0;
> +}
> +
> +static int sun6i_video_set_fmt(struct sun6i_video *video, struct v4l2_format *f)
> +{
> +	struct v4l2_subdev_format format;
> +	struct sun6i_csi_format *current_fmt;
> +	struct v4l2_subdev *subdev;
> +	u32 pad;
> +	int ret;
> +
> +	subdev = sun6i_video_remote_subdev(video, &pad);
> +	if (subdev == NULL)
> +		return -ENXIO;
> +
> +	ret = sun6i_video_try_fmt(video, f, &current_fmt);
> +	if (ret)
> +		return ret;
> +
> +	format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +	v4l2_fill_mbus_format(&format.format, &f->fmt.pix,
> +			      current_fmt->mbus_code);
> +	ret = v4l2_subdev_call(subdev, pad, set_fmt, NULL, &format);
> +	if (ret < 0)
> +		return ret;
> +
> +	video->fmt = *f;
> +	video->current_fmt = current_fmt;
> +
> +	return 0;
> +}
> +
> +static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	struct sun6i_video *video = video_drvdata(file);
> +
> +	if (vb2_is_busy(&video->vb2_vidq))
> +		return -EBUSY;
> +
> +	return sun6i_video_set_fmt(video, f);
> +}
> +
> +static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
> +				  struct v4l2_format *f)
> +{
> +	struct sun6i_video *video = video_drvdata(file);
> +
> +	return sun6i_video_try_fmt(video, f, NULL);
> +}
> +
> +static int vidioc_enum_input(struct file *file, void *fh,
> +			 struct v4l2_input *inp)
> +{
> +	struct sun6i_video *video = video_drvdata(file);
> +	struct v4l2_subdev *subdev;
> +	u32 pad;
> +	int ret;
> +
> +	if (inp->index != 0)
> +		return -EINVAL;
> +
> +	subdev = sun6i_video_remote_subdev(video, &pad);
> +	if (subdev == NULL)
> +		return -ENXIO;
> +
> +	ret = v4l2_subdev_call(subdev, video, g_input_status, &inp->status);
> +	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
> +		return ret;
> +
> +	inp->type = V4L2_INPUT_TYPE_CAMERA;
> +
> +	if (v4l2_subdev_has_op(subdev, pad, dv_timings_cap)) {
> +		inp->capabilities = V4L2_IN_CAP_DV_TIMINGS;
> +		inp->std = 0;
> +	} else {
> +		inp->capabilities = 0;
> +		inp->std = 0;
> +	}

You can set std and capabilities initially to 0 and get rid of else.
> +
> +	strlcpy(inp->name, subdev->name, sizeof(inp->name));
> +
> +	return 0;
> +}
> +
> +static int vidioc_g_input(struct file *file, void *fh, unsigned int *i)
> +{
> +	*i = 0;
> +
> +	return 0;
> +}
> +
> +static int vidioc_s_input(struct file *file, void *fh, unsigned int i)
> +{
> +	if (i != 0)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ioctl_ops sun6i_video_ioctl_ops = {
> +	.vidioc_querycap		= vidioc_querycap,
> +	.vidioc_enum_fmt_vid_cap	= vidioc_enum_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_cap		= vidioc_g_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap		= vidioc_s_fmt_vid_cap,
> +	.vidioc_try_fmt_vid_cap		= vidioc_try_fmt_vid_cap,
> +
> +	.vidioc_enum_input		= vidioc_enum_input,
> +	.vidioc_s_input			= vidioc_s_input,
> +	.vidioc_g_input			= vidioc_g_input,
> +
> +	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
> +	.vidioc_querybuf		= vb2_ioctl_querybuf,
> +	.vidioc_qbuf			= vb2_ioctl_qbuf,
> +	.vidioc_expbuf			= vb2_ioctl_expbuf,
> +	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
> +	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
> +	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
> +	.vidioc_streamon		= vb2_ioctl_streamon,
> +	.vidioc_streamoff		= vb2_ioctl_streamoff,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * V4L2 file operations
> + */
> +static int sun6i_video_open(struct file *file)
> +{
> +	struct sun6i_video *video = video_drvdata(file);
> +	int ret;
> +
> +	if (mutex_lock_interruptible(&video->lock))
> +		return -ERESTARTSYS;
> +
> +	ret = v4l2_fh_open(file);
> +	if (ret < 0)
> +		goto unlock;
> +
> +	ret = v4l2_pipeline_pm_use(&video->vdev.entity, 1);
> +	if (ret < 0)
> +		goto fh_release;
> +
> +	/* check if already powered */
> +	if (!v4l2_fh_is_singular_file(file))
> +		goto unlock;
> +
> +	ret = sun6i_csi_set_power(video->csi, true);
> +	if (ret < 0)
> +		goto fh_release;
> +
> +	mutex_unlock(&video->lock);
> +	return 0;
> +
> +fh_release:
> +	v4l2_fh_release(file);
> +unlock:
> +	mutex_unlock(&video->lock);
> +	return ret;
> +}
> +
> +static int sun6i_video_close(struct file *file)
> +{
> +	struct sun6i_video *video = video_drvdata(file);
> +	bool last_fh;
> +
> +	mutex_lock(&video->lock);
> +
> +	last_fh = v4l2_fh_is_singular_file(file);
> +
> +	_vb2_fop_release(file, NULL);
> +
> +	v4l2_pipeline_pm_use(&video->vdev.entity, 0);
> +
> +	if (last_fh)
> +		sun6i_csi_set_power(video->csi, false);
> +
> +	mutex_unlock(&video->lock);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_file_operations sun6i_video_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= sun6i_video_open,
> +	.release	= sun6i_video_close,
> +	.unlocked_ioctl	= video_ioctl2,
> +	.mmap		= vb2_fop_mmap,
> +	.poll		= vb2_fop_poll
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * Media Operations
> + */
> +static int sun6i_video_formats_init(struct sun6i_video *video)
> +{
> +	struct v4l2_subdev_mbus_code_enum mbus_code = { 0 };
> +	struct sun6i_csi *csi = video->csi;
> +	struct v4l2_format format;
> +	struct v4l2_subdev *subdev;
> +	u32 pad;
> +	const u32 *pixformats;
> +	int pixformat_count = 0;
> +	u32 subdev_codes[32]; /* subdev format codes, 32 should be enough */
> +	int codes_count = 0;
> +	int num_fmts = 0;
> +	int i, j;
> +
> +	subdev = sun6i_video_remote_subdev(video, &pad);
> +	if (subdev == NULL)
> +		return -ENXIO;
> +
> +	/* Get supported pixformats of CSI */
> +	pixformat_count = sun6i_csi_get_supported_pixformats(csi, &pixformats);
> +	if (pixformat_count <= 0)
> +		return -ENXIO;
> +
> +	/* Get subdev formats codes */
> +	mbus_code.pad = pad;
> +	mbus_code.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code, NULL,
> +				 &mbus_code)) {
> +		if (codes_count >= ARRAY_SIZE(subdev_codes)) {
> +			dev_warn(video->csi->dev,
> +				 "subdev_codes array is full!\n");
> +			break;
> +		}
> +		subdev_codes[codes_count] = mbus_code.code;
> +		codes_count++;
> +		mbus_code.index++;
> +	}
> +
> +	if (!codes_count)
> +		return -ENXIO;
> +
> +	/* Get supported formats count */
> +	for (i = 0; i < codes_count; i++) {
> +		for (j = 0; j < pixformat_count; j++) {
> +			if (!sun6i_csi_is_format_support(csi, pixformats[j],
> +					subdev_codes[i])) {
> +				continue;
> +			}
> +			num_fmts++;
> +		}
> +	}
> +
> +	if (!num_fmts)
> +		return -ENXIO;
> +
> +	video->num_formats = num_fmts;
> +	video->formats = devm_kcalloc(video->csi->dev, num_fmts,
> +			sizeof(struct sun6i_csi_format), GFP_KERNEL);
> +	if (!video->formats)
> +		return -ENOMEM;
> +
> +	/* Get supported formats */
> +	num_fmts = 0;
> +	for (i = 0; i < codes_count; i++) {
> +		for (j = 0; j < pixformat_count; j++) {
> +			if (!sun6i_csi_is_format_support(csi, pixformats[j],
> +					subdev_codes[i])) {
> +				continue;
> +			}
> +
> +			video->formats[num_fmts].pixformat = pixformats[j];
> +			video->formats[num_fmts].mbus_code = subdev_codes[i];
> +			video->formats[num_fmts].bpp =
> +					sun6i_csi_get_bpp(pixformats[j]);
> +			num_fmts++;
> +		}
> +	}
> +
> +	/* setup default format */
> +	format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	format.fmt.pix.width = 1280;
> +	format.fmt.pix.height = 720;
> +	format.fmt.pix.pixelformat = video->formats[0].pixformat;
> +	sun6i_video_set_fmt(video, &format);
> +
> +	return 0;
> +}
> +
> +static int sun6i_video_link_setup(struct media_entity *entity,
> +				  const struct media_pad *local,
> +				  const struct media_pad *remote, u32 flags)
> +{
> +	struct video_device *vdev = media_entity_to_video_device(entity);
> +	struct sun6i_video *video = video_get_drvdata(vdev);
> +
> +	if (WARN_ON(video == NULL))
> +		return 0;
> +
> +	return sun6i_video_formats_init(video);
> +}
> +
> +static const struct media_entity_operations sun6i_video_media_ops = {
> +	.link_setup = sun6i_video_link_setup,
> +};
> +
> +int sun6i_video_init(struct sun6i_video *video, struct sun6i_csi *csi,
> +		     const char *name)
> +{
> +	struct video_device *vdev = &video->vdev;
> +	struct vb2_queue *vidq = &video->vb2_vidq;
> +	int ret;
> +
> +	video->csi = csi;
> +
> +	/* Initialize the media entity... */
> +	video->pad.flags = MEDIA_PAD_FL_SINK | MEDIA_PAD_FL_MUST_CONNECT;
> +	vdev->entity.ops = &sun6i_video_media_ops;
> +	ret = media_entity_pads_init(&vdev->entity, 1, &video->pad);
> +	if (ret < 0)
> +		return ret;
> +
> +	mutex_init(&video->lock);
> +
> +	INIT_LIST_HEAD(&video->dma_queue);
> +	spin_lock_init(&video->dma_queue_lock);
> +
> +	video->sequence = 0;
> +	video->num_formats = 0;
> +
> +	/* Initialize videobuf2 queue */
> +	vidq->type			= V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	vidq->io_modes			= VB2_MMAP | VB2_DMABUF;
> +	vidq->drv_priv			= video;
> +	vidq->buf_struct_size		= sizeof(struct sun6i_csi_buffer);
> +	vidq->ops			= &sun6i_csi_vb2_ops;
> +	vidq->mem_ops			= &vb2_dma_contig_memops;
> +	vidq->timestamp_flags		= V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	vidq->lock			= &video->lock;
> +	/* Make sure non-dropped frame */
> +	vidq->min_buffers_needed	= 3;
> +	vidq->dev			= csi->dev;
> +
> +	ret = vb2_queue_init(vidq);
> +	if (ret) {
> +		v4l2_err(&csi->v4l2_dev, "vb2_queue_init failed: %d\n", ret);
> +		goto error;
> +	}
> +
> +	/* Register video device */
> +	strlcpy(vdev->name, name, sizeof(vdev->name));
> +	vdev->release		= video_device_release_empty;
> +	vdev->fops		= &sun6i_video_fops;
> +	vdev->ioctl_ops		= &sun6i_video_ioctl_ops;
> +	vdev->vfl_type		= VFL_TYPE_GRABBER;
> +	vdev->vfl_dir		= VFL_DIR_RX;
> +	vdev->v4l2_dev		= &csi->v4l2_dev;
> +	vdev->queue		= vidq;
> +	vdev->lock		= &video->lock;
> +	vdev->device_caps	= V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE;
> +	video_set_drvdata(vdev, video);
> +
> +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret < 0) {
> +		v4l2_err(&csi->v4l2_dev,
> +			 "video_register_device failed: %d\n", ret);
> +		goto error;
> +	}
> +
> +	return 0;
> +
> +error:
> +	sun6i_video_cleanup(video);
> +	return ret;
> +}
> +
> +void sun6i_video_cleanup(struct sun6i_video *video)
> +{
> +	if (video_is_registered(&video->vdev))
> +		video_unregister_device(&video->vdev);
> +
> +	media_entity_cleanup(&video->vdev.entity);
> +}
> diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.h b/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.h
> new file mode 100644
> index 0000000..f20928a
> --- /dev/null
> +++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.h
> @@ -0,0 +1,60 @@
> +/*
> + * Copyright (c) 2017 Yong Deng <yong.deng@magewell.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __SUN6I_VIDEO_H__
> +#define __SUN6I_VIDEO_H__
> +
> +#include <media/v4l2-dev.h>
> +#include <media/videobuf2-core.h>
> +
> +/*
> + * struct sun6i_csi_format - CSI media bus format information
> + * @pixformat: V4l2 pixformat for this format
> + * @mbus_code: V4L2 media bus format code.
> + * @bpp: Bytes per pixel (when stored in memory)
> + */
> +struct sun6i_csi_format {
> +	u32				pixformat;
> +	u32				mbus_code;
> +	u8				bpp;
> +};
> +
> +struct sun6i_csi;
> +
> +struct sun6i_video {
> +	struct video_device		vdev;
> +	struct media_pad		pad;
> +	struct sun6i_csi		*csi;
> +
> +	struct mutex			lock;
> +
> +	struct vb2_queue		vb2_vidq;
> +	spinlock_t			dma_queue_lock;
> +	struct list_head		dma_queue;
> +
> +	unsigned int			sequence;
> +
> +	struct sun6i_csi_format		*formats;
> +	unsigned int			num_formats;
> +	struct sun6i_csi_format		*current_fmt;
> +	struct v4l2_format		fmt;
> +};
> +
> +int sun6i_video_init(struct sun6i_video *video, struct sun6i_csi *csi,
> +		     const char *name);
> +void sun6i_video_cleanup(struct sun6i_video *video);
> +
> +void sun6i_video_frame_done(struct sun6i_video *video);
> +
> +#endif /* __SUN6I_VIDEO_H__ */
> -- 
> 1.8.3.1
> 
> -- 
> You received this message because you are subscribed to the Google Groups "linux-sunxi" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to linux-sunxi+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/d/optout.
