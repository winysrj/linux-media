Return-path: <linux-media-owner@vger.kernel.org>
Received: from xff.cz ([195.181.215.36]:44798 "EHLO megous.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752397AbdKMLuc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Nov 2017 06:50:32 -0500
Message-ID: <1510573442.459.59.camel@megous.com>
Subject: Re: [linux-sunxi] [PATCH v3 1/3] media: V3s: Add support for
 Allwinner CSI.
From: =?UTF-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To: yong.deng@magewell.com, maxime.ripard@free-electrons.com
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Benoit Parrot <bparrot@ti.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Rick Chang <rick.chang@mediatek.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Date: Mon, 13 Nov 2017 12:44:02 +0100
In-Reply-To: <1510558216-43800-1-git-send-email-yong.deng@magewell.com>
References: <1510558216-43800-1-git-send-email-yong.deng@magewell.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-inNlocy2VZP6alcr4Vz3"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-inNlocy2VZP6alcr4Vz3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Thanks for your patches. I've been working with CSI on A83T, so I have
a few notes. My review is below. :)

Yong Deng p=C3=AD=C5=A1e v Po 13. 11. 2017 v 15:30 +0800:
> Allwinner V3s SoC have two CSI module. CSI0 is used for MIPI interface
> and CSI1 is used for parallel interface. This is not documented in
> datasheet but by testing and guess.
>=20
> This patch implement a v4l2 framework driver for it.
>=20
> Currently, the driver only support the parallel interface. MIPI-CSI2,
> ISP's support are not included in this patch.
>=20
> Signed-off-by: Yong Deng <yong.deng@magewell.com>
> ---
>  drivers/media/platform/Kconfig                     |   1 +
>  drivers/media/platform/Makefile                    |   2 +
>  drivers/media/platform/sunxi/sun6i-csi/Kconfig     |   9 +
>  drivers/media/platform/sunxi/sun6i-csi/Makefile    |   3 +
>  drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 918 +++++++++++++++=
++++++
>  drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h | 146 ++++
>  .../media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h | 203 +++++
>  .../media/platform/sunxi/sun6i-csi/sun6i_video.c   | 722 +++++++++++++++=
+
>  .../media/platform/sunxi/sun6i-csi/sun6i_video.h   |  61 ++
>  9 files changed, 2065 insertions(+)
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/Kconfig
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/Makefile
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi_reg.=
h
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.h
>=20
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kcon=
fig
> index fd0c998..41017e3 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -150,6 +150,7 @@ source "drivers/media/platform/am437x/Kconfig"
>  source "drivers/media/platform/xilinx/Kconfig"
>  source "drivers/media/platform/rcar-vin/Kconfig"
>  source "drivers/media/platform/atmel/Kconfig"
> +source "drivers/media/platform/sunxi/sun6i-csi/Kconfig"
> =20
>  config VIDEO_TI_CAL
>  	tristate "TI CAL (Camera Adaptation Layer) driver"
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Mak=
efile
> index 012eb47..1cc806a 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -96,3 +96,5 @@ obj-$(CONFIG_VIDEO_QCOM_CAMSS)		+=3D qcom/camss-8x16/
>  obj-$(CONFIG_VIDEO_QCOM_VENUS)		+=3D qcom/venus/
> =20
>  obj-y					+=3D meson/
> +
> +obj-$(CONFIG_VIDEO_SUN6I_CSI)		+=3D sunxi/sun6i-csi/
> diff --git a/drivers/media/platform/sunxi/sun6i-csi/Kconfig b/drivers/med=
ia/platform/sunxi/sun6i-csi/Kconfig
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
> diff --git a/drivers/media/platform/sunxi/sun6i-csi/Makefile b/drivers/me=
dia/platform/sunxi/sun6i-csi/Makefile
> new file mode 100644
> index 0000000..213cb6b
> --- /dev/null
> +++ b/drivers/media/platform/sunxi/sun6i-csi/Makefile
> @@ -0,0 +1,3 @@
> +sun6i-csi-y +=3D sun6i_video.o sun6i_csi.o
> +
> +obj-$(CONFIG_VIDEO_SUN6I_CSI) +=3D sun6i-csi.o
> diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers=
/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> new file mode 100644
> index 0000000..3f4de09
> --- /dev/null
> +++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> @@ -0,0 +1,918 @@
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
> +static const u32 supported_pixformats[] =3D {
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
> +static inline struct sun6i_csi_dev *sun6i_csi_to_dev(struct sun6i_csi *c=
si)
> +{
> +	return container_of(csi, struct sun6i_csi_dev, csi);
> +}
> +
> +/* TODO add 10&12 bit YUV, RGB support */
> +static bool __is_format_support(struct sun6i_csi_dev *sdev,
> +			      u32 fourcc, u32 mbus_code)

The function name should be prefixed with sun6i_csi_* for easier to
read stack traces.

> +{
> +	/*
> +	 * Some video receiver have capability both 8bit and 16bit.
> +	 * Identify the media bus format from device tree.
> +	 */
> +	if ((sdev->csi.v4l2_ep.bus_type =3D=3D V4L2_MBUS_PARALLEL
> +	      || sdev->csi.v4l2_ep.bus_type =3D=3D V4L2_MBUS_BT656)
> +	     && sdev->csi.v4l2_ep.bus.parallel.bus_width =3D=3D 16) {
> +		switch (fourcc) {
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
> +		return false;
> +	}
> +
> +	switch (fourcc) {
> +	case V4L2_PIX_FMT_SBGGR8:
> +		if (mbus_code =3D=3D MEDIA_BUS_FMT_SBGGR8_1X8)
> +			return true;
> +		break;

Can be return mbus_code =3D=3D MEDIA_BUS_FMT_SBGGR8_1X8; to save three
linse. Ditto for similar cases below.

> +	case V4L2_PIX_FMT_SGBRG8:
> +		if (mbus_code =3D=3D MEDIA_BUS_FMT_SGBRG8_1X8)
> +			return true;
> +		break;
> +	case V4L2_PIX_FMT_SGRBG8:
> +		if (mbus_code =3D=3D MEDIA_BUS_FMT_SGRBG8_1X8)
> +			return true;
> +		break;
> +	case V4L2_PIX_FMT_SRGGB8:
> +		if (mbus_code =3D=3D MEDIA_BUS_FMT_SRGGB8_1X8)
> +			return true;
> +		break;
> +	case V4L2_PIX_FMT_SBGGR10:
> +		if (mbus_code =3D=3D MEDIA_BUS_FMT_SBGGR10_1X10)
> +			return true;
> +		break;
> +	case V4L2_PIX_FMT_SGBRG10:
> +		if (mbus_code =3D=3D MEDIA_BUS_FMT_SGBRG10_1X10)
> +			return true;
> +		break;
> +	case V4L2_PIX_FMT_SGRBG10:
> +		if (mbus_code =3D=3D MEDIA_BUS_FMT_SGRBG10_1X10)
> +			return true;
> +		break;
> +	case V4L2_PIX_FMT_SRGGB10:
> +		if (mbus_code =3D=3D MEDIA_BUS_FMT_SRGGB10_1X10)
> +			return true;
> +		break;
> +	case V4L2_PIX_FMT_SBGGR12:
> +		if (mbus_code =3D=3D MEDIA_BUS_FMT_SBGGR12_1X12)
> +			return true;
> +		break;
> +	case V4L2_PIX_FMT_SGBRG12:
> +		if (mbus_code =3D=3D MEDIA_BUS_FMT_SGBRG12_1X12)
> +			return true;
> +		break;
> +	case V4L2_PIX_FMT_SGRBG12:
> +		if (mbus_code =3D=3D MEDIA_BUS_FMT_SGRBG12_1X12)
> +			return true;
> +		break;
> +	case V4L2_PIX_FMT_SRGGB12:
> +		if (mbus_code =3D=3D MEDIA_BUS_FMT_SRGGB12_1X12)
> +			return true;
> +		break;
> +
> +	case V4L2_PIX_FMT_YUYV:
> +		if (mbus_code =3D=3D MEDIA_BUS_FMT_YUYV8_2X8)
> +			return true;
> +		break;
> +	case V4L2_PIX_FMT_YVYU:
> +		if (mbus_code =3D=3D MEDIA_BUS_FMT_YVYU8_2X8)
> +			return true;
> +		break;
> +	case V4L2_PIX_FMT_UYVY:
> +		if (mbus_code =3D=3D MEDIA_BUS_FMT_UYVY8_2X8)
> +			return true;
> +		break;
> +	case V4L2_PIX_FMT_VYUY:
> +		if (mbus_code =3D=3D MEDIA_BUS_FMT_VYUY8_2X8)
> +			return true;
> +		break;
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
> +	return false;
> +}
> +
> +static enum csi_input_fmt get_csi_input_format(u32 mbus_code, u32 pixfor=
mat)
> +{
> +	/* bayer */
> +	if ((mbus_code & 0xF000) =3D=3D 0x3000)
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
> +	return CSI_INPUT_FORMAT_YUV422;
> +}
> +
> +static enum csi_output_fmt get_csi_output_format(u32 pixformat, u32 fiel=
d)
> +{
> +	bool buf_interlaced =3D false;
> +
> +	if (field =3D=3D V4L2_FIELD_INTERLACED
> +	    || field =3D=3D V4L2_FIELD_INTERLACED_TB
> +	    || field =3D=3D V4L2_FIELD_INTERLACED_BT)
> +		buf_interlaced =3D true;
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
> +
> +	return 0;
> +}
> +
> +static enum csi_input_seq get_csi_input_seq(u32 mbus_code, u32 pixformat=
)
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
> +
> +	return CSI_INPUT_SEQ_YUYV;
> +}
> +
> +static void sun6i_csi_setup_bus(struct sun6i_csi_dev *sdev)
> +{
> +	struct v4l2_fwnode_endpoint *endpoint =3D &sdev->csi.v4l2_ep;
> +	unsigned char bus_width;
> +	u32 flags;
> +	u32 cfg;
> +
> +	bus_width =3D endpoint->bus.parallel.bus_width;
> +
> +	regmap_read(sdev->regmap, CSI_IF_CFG_REG, &cfg);
> +
> +	cfg &=3D ~(CSI_IF_CFG_CSI_IF_MASK | CSI_IF_CFG_MIPI_IF_MASK |
> +		 CSI_IF_CFG_IF_DATA_WIDTH_MASK |
> +		 CSI_IF_CFG_CLK_POL_MASK | CSI_IF_CFG_VREF_POL_MASK |
> +		 CSI_IF_CFG_HREF_POL_MASK | CSI_IF_CFG_FIELD_MASK);
> +
> +	switch (endpoint->bus_type) {
> +	case V4L2_MBUS_CSI2:
> +		cfg |=3D CSI_IF_CFG_MIPI_IF_MIPI;
> +		break;

You're not supporting CSI2, you can drop this code.

> +	case V4L2_MBUS_PARALLEL:
> +		cfg |=3D CSI_IF_CFG_MIPI_IF_CSI;
> +
> +		flags =3D endpoint->bus.parallel.flags;
> +
> +		cfg |=3D (bus_width =3D=3D 16) ? CSI_IF_CFG_CSI_IF_YUV422_16BIT :
> +					   CSI_IF_CFG_CSI_IF_YUV422_INTLV;
> +
> +		if (flags & V4L2_MBUS_FIELD_EVEN_LOW)
> +			cfg |=3D CSI_IF_CFG_FIELD_POSITIVE;
> +
> +		if (flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
> +			cfg |=3D CSI_IF_CFG_VREF_POL_POSITIVE;
> +		if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
> +			cfg |=3D CSI_IF_CFG_HREF_POL_POSITIVE;
> +
> +		if (flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
> +			cfg |=3D CSI_IF_CFG_CLK_POL_FALLING_EDGE;
> +		break;
> +	case V4L2_MBUS_BT656:
> +		cfg |=3D CSI_IF_CFG_MIPI_IF_CSI;
> +
> +		flags =3D endpoint->bus.parallel.flags;
> +
> +		cfg |=3D (bus_width =3D=3D 16) ? CSI_IF_CFG_CSI_IF_BT1120 :
> +					   CSI_IF_CFG_CSI_IF_BT656;
> +
> +		if (flags & V4L2_MBUS_FIELD_EVEN_LOW)
> +			cfg |=3D CSI_IF_CFG_FIELD_POSITIVE;
> +
> +		if (flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
> +			cfg |=3D CSI_IF_CFG_CLK_POL_FALLING_EDGE;
> +		break;
> +	default:
> +		WARN_ON(1);
> +		break;
> +	}
> +
> +	switch (bus_width) {
> +	case 8:
> +		cfg |=3D CSI_IF_CFG_IF_DATA_WIDTH_8BIT;
> +		break;
> +	case 10:
> +		cfg |=3D CSI_IF_CFG_IF_DATA_WIDTH_10BIT;
> +		break;
> +	case 12:
> +		cfg |=3D CSI_IF_CFG_IF_DATA_WIDTH_12BIT;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	regmap_write(sdev->regmap, CSI_IF_CFG_REG, cfg);
> +}
> +
> +static void sun6i_csi_set_format(struct sun6i_csi_dev *sdev)
> +{
> +	struct sun6i_csi *csi =3D &sdev->csi;
> +	u32 cfg;
> +	u32 val;
> +
> +	regmap_read(sdev->regmap, CSI_CH_CFG_REG, &cfg);
> +
> +	cfg &=3D ~(CSI_CH_CFG_INPUT_FMT_MASK |
> +		 CSI_CH_CFG_OUTPUT_FMT_MASK | CSI_CH_CFG_VFLIP_EN |
> +		 CSI_CH_CFG_HFLIP_EN | CSI_CH_CFG_FIELD_SEL_MASK |
> +		 CSI_CH_CFG_INPUT_SEQ_MASK);
> +
> +	val =3D get_csi_input_format(csi->config.code, csi->config.pixelformat)=
;
> +	cfg |=3D CSI_CH_CFG_INPUT_FMT(val);
> +
> +	val =3D get_csi_output_format(csi->config.pixelformat, csi->config.fiel=
d);
> +	cfg |=3D CSI_CH_CFG_OUTPUT_FMT(val);
> +
> +	val =3D get_csi_input_seq(csi->config.code, csi->config.pixelformat);
> +	cfg |=3D CSI_CH_CFG_INPUT_SEQ(val);
> +
> +	if (csi->config.field =3D=3D V4L2_FIELD_TOP)
> +		cfg |=3D CSI_CH_CFG_FIELD_SEL_FIELD0;
> +	else if (csi->config.field =3D=3D V4L2_FIELD_BOTTOM)
> +		cfg |=3D CSI_CH_CFG_FIELD_SEL_FIELD1;
> +	else
> +		cfg |=3D CSI_CH_CFG_FIELD_SEL_BOTH;
> +
> +	regmap_write(sdev->regmap, CSI_CH_CFG_REG, cfg);
> +}
> +
> +static void sun6i_csi_set_window(struct sun6i_csi_dev *sdev)
> +{
> +	struct sun6i_csi_config *config =3D &sdev->csi.config;
> +	u32 bytesperline_y;
> +	u32 bytesperline_c;
> +	int *planar_offset =3D sdev->planar_offset;
> +	u32 width =3D config->width;
> +	u32 height =3D config->height;
> +	u32 hor_len =3D width;
> +
> +	switch (config->pixelformat) {
> +	case V4L2_PIX_FMT_YUYV:
> +	case V4L2_PIX_FMT_YVYU:
> +	case V4L2_PIX_FMT_UYVY:
> +	case V4L2_PIX_FMT_VYUY:
> +		hor_len =3D width * 2;
> +		break;
> +	}
> +
> +	regmap_write(sdev->regmap, CSI_CH_HSIZE_REG,
> +		     CSI_CH_HSIZE_HOR_LEN(hor_len) |
> +		     CSI_CH_HSIZE_HOR_START(0));
> +	regmap_write(sdev->regmap, CSI_CH_VSIZE_REG,
> +		     CSI_CH_VSIZE_VER_LEN(height) |
> +		     CSI_CH_VSIZE_VER_START(0));
> +
> +	planar_offset[0] =3D 0;
> +	switch (config->pixelformat) {
> +	case V4L2_PIX_FMT_HM12:
> +	case V4L2_PIX_FMT_NV12:
> +	case V4L2_PIX_FMT_NV21:
> +	case V4L2_PIX_FMT_NV16:
> +	case V4L2_PIX_FMT_NV61:
> +		bytesperline_y =3D width;
> +		bytesperline_c =3D width;
> +		planar_offset[1] =3D bytesperline_y * height;
> +		planar_offset[2] =3D -1;
> +		break;
> +	case V4L2_PIX_FMT_YUV420:
> +	case V4L2_PIX_FMT_YVU420:
> +		bytesperline_y =3D width;
> +		bytesperline_c =3D width / 2;
> +		planar_offset[1] =3D bytesperline_y * height;
> +		planar_offset[2] =3D planar_offset[1] +
> +				bytesperline_c * height / 2;
> +		break;
> +	case V4L2_PIX_FMT_YUV422P:
> +		bytesperline_y =3D width;
> +		bytesperline_c =3D width / 2;
> +		planar_offset[1] =3D bytesperline_y * height;
> +		planar_offset[2] =3D planar_offset[1] +
> +				bytesperline_c * height;
> +		break;
> +	default: /* raw */
> +		bytesperline_y =3D (v4l2_pixformat_get_bpp(config->pixelformat) *
> +				  config->width) / 8;
> +		bytesperline_c =3D 0;
> +		planar_offset[1] =3D -1;
> +		planar_offset[2] =3D -1;
> +		break;
> +	}
> +
> +	regmap_write(sdev->regmap, CSI_CH_BUF_LEN_REG,
> +		     CSI_CH_BUF_LEN_BUF_LEN_C(bytesperline_c) |
> +		     CSI_CH_BUF_LEN_BUF_LEN_Y(bytesperline_y));
> +}
> +
> +int sun6i_csi_get_supported_pixformats(struct sun6i_csi *csi,
> +				    const u32 **pixformats)
> +{
> +	if (pixformats !=3D NULL)
> +		*pixformats =3D supported_pixformats;
> +
> +	return ARRAY_SIZE(supported_pixformats);
> +}
> +
> +bool sun6i_csi_is_format_support(struct sun6i_csi *csi, u32 pixformat,
> +			      u32 mbus_code)
> +{
> +	struct sun6i_csi_dev *sdev =3D sun6i_csi_to_dev(csi);
> +
> +	return __is_format_support(sdev, pixformat, mbus_code);
> +}
> +
> +int sun6i_csi_set_power(struct sun6i_csi *csi, bool enable)
> +{
> +	struct sun6i_csi_dev *sdev =3D sun6i_csi_to_dev(csi);
> +	struct regmap *regmap =3D sdev->regmap;
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
> +	ret =3D clk_prepare_enable(sdev->clk_mod);
> +	if (ret) {
> +		dev_err(sdev->dev, "Enable csi clk err %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret =3D clk_prepare_enable(sdev->clk_ram);
> +	if (ret) {
> +		dev_err(sdev->dev, "Enable clk_dram_csi clk err %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret =3D reset_control_deassert(sdev->rstc_bus);
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
> +int sun6i_csi_update_config(struct sun6i_csi *csi,
> +			 struct sun6i_csi_config *config)
> +{
> +	struct sun6i_csi_dev *sdev =3D sun6i_csi_to_dev(csi);
> +
> +	if (config =3D=3D NULL)
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
> +int sun6i_csi_update_buf_addr(struct sun6i_csi *csi, dma_addr_t addr)
> +{
> +	struct sun6i_csi_dev *sdev =3D sun6i_csi_to_dev(csi);
> +	/* transform physical address to bus address */
> +	dma_addr_t bus_addr =3D addr - PHYS_OFFSET;
> +
> +	regmap_write(sdev->regmap, CSI_CH_F0_BUFA_REG,
> +		     (bus_addr + sdev->planar_offset[0]) >> 2);
> +	if (sdev->planar_offset[1] !=3D -1)
> +		regmap_write(sdev->regmap, CSI_CH_F1_BUFA_REG,
> +			     (bus_addr + sdev->planar_offset[1]) >> 2);
> +	if (sdev->planar_offset[2] !=3D -1)
> +		regmap_write(sdev->regmap, CSI_CH_F2_BUFA_REG,
> +			     (bus_addr + sdev->planar_offset[2]) >> 2);
> +
> +	return 0;
> +}
> +
> +int sun6i_csi_set_stream(struct sun6i_csi *csi, bool enable)
> +{
> +	struct sun6i_csi_dev *sdev =3D sun6i_csi_to_dev(csi);
> +	struct regmap *regmap =3D sdev->regmap;
> +
> +	if (!enable) {
> +		regmap_update_bits(regmap, CSI_CAP_REG, CSI_CAP_CH0_VCAP_ON, 0);
> +		regmap_write(regmap, CSI_CH_INT_EN_REG, 0);
> +		return 0;
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
> +
> +	return 0;
> +}
> +
> +/* ---------------------------------------------------------------------=
--------
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
> +	for (i =3D 0; i < entity->num_pads; i++) {
> +		if (entity->pads[i].flags & MEDIA_PAD_FL_SOURCE)
> +			break;
> +	}
> +
> +	if (i =3D=3D entity->num_pads) {
> +		dev_err(csi->dev, "%s: no source pad in external entity %s\n",
> +			__func__, entity->name);
> +		return -EINVAL;
> +	}
> +
> +	sink =3D &csi->video.vdev.entity;
> +	sink_pad =3D &csi->video.pad;
> +
> +	dev_dbg(csi->dev, "creating %s:%u -> %s:%u link\n",
> +		entity->name, i, sink->name, sink_pad->index);
> +	ret =3D media_create_pad_link(entity, i, sink, sink_pad->index,
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
> +static int sun6i_subdev_notify_complete(struct v4l2_async_notifier *noti=
fier)
> +{
> +	struct sun6i_csi *csi =3D container_of(notifier, struct sun6i_csi,
> +					     notifier);
> +	struct v4l2_device *v4l2_dev =3D &csi->v4l2_dev;
> +	struct v4l2_subdev *sd;
> +	int ret;
> +
> +	dev_dbg(csi->dev, "notify complete, all subdevs registered\n");
> +
> +	if (notifier->num_subdevs !=3D 1)
> +		return -EINVAL;
> +
> +	sd =3D list_first_entry(&v4l2_dev->subdevs, struct v4l2_subdev, list);
> +	if (sd =3D=3D NULL)
> +		return -EINVAL;
> +
> +	ret =3D sun6i_csi_link_entity(csi, &sd->entity);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret =3D v4l2_device_register_subdev_nodes(&csi->v4l2_dev);
> +	if (ret < 0)
> +		return ret;
> +
> +	return media_device_register(&csi->media_dev);
> +}
> +
> +static const struct v4l2_async_notifier_operations sun6i_csi_async_ops =
=3D {
> +	.complete =3D sun6i_subdev_notify_complete,
> +};
> +
> +static int sun6i_csi_fwnode_parse(struct device *dev,
> +				   struct v4l2_fwnode_endpoint *vep,
> +				   struct v4l2_async_subdev *asd)
> +{
> +	struct sun6i_csi *csi =3D dev_get_drvdata(dev);
> +
> +	if (vep->base.port || vep->base.id) {
> +		dev_warn(dev, "Only support a single port with one endpoint\n");
> +		return -ENOTCONN;
> +	}
> +
> +	switch (vep->bus_type) {
> +	case V4L2_MBUS_PARALLEL:
> +	case V4L2_MBUS_BT656:
> +		csi->v4l2_ep =3D *vep;
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
> +	csi->media_dev.dev =3D csi->dev;
> +	strlcpy(csi->media_dev.model, "Allwinner Video Capture Device",
> +		sizeof(csi->media_dev.model));
> +	csi->media_dev.hw_revision =3D 0;
> +
> +	media_device_init(&csi->media_dev);
> +
> +	csi->v4l2_dev.mdev =3D &csi->media_dev;
> +	ret =3D v4l2_device_register(csi->dev, &csi->v4l2_dev);
> +	if (ret) {
> +		dev_err(csi->dev, "V4L2 device registration failed (%d)\n",
> +			ret);
> +		goto v4l2_reg_err;
> +	}
> +
> +	ret =3D sun6i_video_init(&csi->video, csi, "sun6i-csi");
> +	if (ret)
> +		goto video_init_err;
> +
> +	ret =3D v4l2_async_notifier_parse_fwnode_endpoints(
> +		csi->dev, &csi->notifier, sizeof(struct v4l2_async_subdev),
> +		sun6i_csi_fwnode_parse);
> +	if (ret)
> +		goto fwnode_parse_err;
> +
> +	csi->notifier.ops =3D &sun6i_csi_async_ops;
> +
> +	ret =3D v4l2_async_notifier_register(&csi->v4l2_dev, &csi->notifier);
> +	if (ret) {
> +		dev_err(csi->dev, "notifier registration failed\n");
> +		goto notifier_reg_err;
> +	}
> +
> +	return 0;
> +
> +notifier_reg_err:
> +	v4l2_async_notifier_cleanup(&csi->notifier);
> +fwnode_parse_err:
> +	sun6i_video_cleanup(&csi->video);
> +video_init_err:
> +	v4l2_device_unregister(&csi->v4l2_dev);
> +v4l2_reg_err:
> +	media_device_cleanup(&csi->media_dev);
> +
> +	return ret;
> +}
> +
> +/* ---------------------------------------------------------------------=
--------
> + * Resources and IRQ
> + */
> +static irqreturn_t sun6i_csi_isr(int irq, void *dev_id)
> +{
> +	struct sun6i_csi_dev *sdev =3D (struct sun6i_csi_dev *)dev_id;
> +	struct regmap *regmap =3D sdev->regmap;
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
> +static const struct regmap_config sun6i_csi_regmap_config =3D {
> +	.reg_bits       =3D 32,
> +	.reg_stride     =3D 4,
> +	.val_bits       =3D 32,
> +	.max_register	=3D 0x1000,
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
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	io_base =3D devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(io_base))
> +		return PTR_ERR(io_base);
> +
> +	sdev->regmap =3D devm_regmap_init_mmio_clk(&pdev->dev, "bus", io_base,
> +					    &sun6i_csi_regmap_config);
> +	if (IS_ERR(sdev->regmap)) {
> +		dev_err(&pdev->dev, "Failed to init register map\n");
> +		return PTR_ERR(sdev->regmap);
> +	}
> +
> +	sdev->clk_mod =3D devm_clk_get(&pdev->dev, "mod");
> +	if (IS_ERR(sdev->clk_mod)) {
> +		dev_err(&pdev->dev, "Unable to acquire csi clock\n");
> +		return PTR_ERR(sdev->clk_mod);
> +	}
> +
> +	sdev->clk_ram =3D devm_clk_get(&pdev->dev, "ram");
> +	if (IS_ERR(sdev->clk_ram)) {
> +		dev_err(&pdev->dev, "Unable to acquire dram-csi clock\n");
> +		return PTR_ERR(sdev->clk_ram);
> +	}
> +
> +	sdev->rstc_bus =3D devm_reset_control_get_shared(&pdev->dev, NULL);
> +	if (IS_ERR(sdev->rstc_bus)) {
> +		dev_err(&pdev->dev, "Cannot get reset controller\n");
> +		return PTR_ERR(sdev->rstc_bus);
> +	}
> +
> +	irq =3D platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		dev_err(&pdev->dev, "No csi IRQ specified\n");
> +		ret =3D -ENXIO;
> +		return ret;
> +	}
> +
> +	ret =3D devm_request_irq(&pdev->dev, irq, sun6i_csi_isr, 0, MODULE_NAME=
,
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
> +	sdev =3D devm_kzalloc(&pdev->dev, sizeof(*sdev), GFP_KERNEL);
> +	if (!sdev)
> +		return -ENOMEM;
> +
> +	sdev->dev =3D &pdev->dev;
> +
> +	ret =3D sun6i_csi_resource_request(sdev, pdev);
> +	if (ret)
> +		return ret;
> +
> +	platform_set_drvdata(pdev, sdev);
> +
> +	sdev->csi.dev =3D &pdev->dev;
> +	ret =3D sun6i_csi_v4l2_init(&sdev->csi);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int sun6i_csi_remove(struct platform_device *pdev)
> +{
> +	struct sun6i_csi_dev *sdev =3D platform_get_drvdata(pdev);
> +
> +	sun6i_csi_v4l2_cleanup(&sdev->csi);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id sun6i_csi_of_match[] =3D {
> +	{ .compatible =3D "allwinner,sun8i-v3s-csi", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, sun6i_csi_of_match);
> +
> +static struct platform_driver sun6i_csi_platform_driver =3D {
> +	.probe =3D sun6i_csi_probe,
> +	.remove =3D sun6i_csi_remove,
> +	.driver =3D {
> +		.name =3D MODULE_NAME,
> +		.of_match_table =3D of_match_ptr(sun6i_csi_of_match),
> +	},
> +};
> +module_platform_driver(sun6i_csi_platform_driver);
> +
> +MODULE_DESCRIPTION("Allwinner V3s Camera Sensor Interface driver");
> +MODULE_AUTHOR("Yong Deng <yong.deng@magewell.com>");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h b/drivers=
/media/platform/sunxi/sun6i-csi/sun6i_csi.h
> new file mode 100644
> index 0000000..12508ff
> --- /dev/null
> +++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h
> @@ -0,0 +1,146 @@
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
> +int sun6i_csi_update_buf_addr(struct sun6i_csi *csi, dma_addr_t addr);
> +
> +/**
> + * sun6i_csi_set_stream() - start/stop csi streaming
> + * @csi:	pointer to the csi
> + * @enable:	start/stop
> + */
> +int sun6i_csi_set_stream(struct sun6i_csi *csi, bool enable);
> +
> +static inline int v4l2_pixformat_get_bpp(unsigned int pixformat)

Probably not a good name. v4l2_ prefix is for V4L2 core API functions.

Rename it or you can move this into core, if you think that getting
bits per pixel for pixformats can help other drivers too.

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
> +	}
> +
> +	return 0;
> +}
> +
> +#endif /* __SUN6I_CSI_H__ */
> diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h b/dri=
vers/media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h
> new file mode 100644
> index 0000000..8e80467
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
> +#ifndef __SUN6I_CSI_V3S_H__
> +#define __SUN6I_CSI_V3S_H__

No longer V3S. __SUN6I_CSI_REG_H__

> +#include <linux/kernel.h>
> +
> +#define CSI_EN_REG			0x0
> +#define CSI_EN_VER_EN				BIT(30)
> +#define CSI_EN_CSI_EN				BIT(0)
> +
> +#define CSI_IF_CFG_REG			0x4
> +#define CSI_IF_CFG_SRC_TYPE_MASK		BIT(21)
> +#define CSI_IF_CFG_SRC_TYPE_PROGRESSED		((0 << 21) & CSI_IF_CFG_SRC_TYPE=
_MASK)
> +#define CSI_IF_CFG_SRC_TYPE_INTERLACED		((1 << 21) & CSI_IF_CFG_SRC_TYPE=
_MASK)
> +#define CSI_IF_CFG_FPS_DS_EN			BIT(20)
> +#define CSI_IF_CFG_FIELD_MASK			BIT(19)
> +#define CSI_IF_CFG_FIELD_NEGATIVE		((0 << 19) & CSI_IF_CFG_FIELD_MASK)
> +#define CSI_IF_CFG_FIELD_POSITIVE		((1 << 19) & CSI_IF_CFG_FIELD_MASK)
> +#define CSI_IF_CFG_VREF_POL_MASK		BIT(18)
> +#define CSI_IF_CFG_VREF_POL_NEGATIVE		((0 << 18) & CSI_IF_CFG_VREF_POL_M=
ASK)
> +#define CSI_IF_CFG_VREF_POL_POSITIVE		((1 << 18) & CSI_IF_CFG_VREF_POL_M=
ASK)
> +#define CSI_IF_CFG_HREF_POL_MASK		BIT(17)
> +#define CSI_IF_CFG_HREF_POL_NEGATIVE		((0 << 17) & CSI_IF_CFG_HREF_POL_M=
ASK)
> +#define CSI_IF_CFG_HREF_POL_POSITIVE		((1 << 17) & CSI_IF_CFG_HREF_POL_M=
ASK)
> +#define CSI_IF_CFG_CLK_POL_MASK			BIT(16)
> +#define CSI_IF_CFG_CLK_POL_RISING_EDGE		((0 << 16) & CSI_IF_CFG_CLK_POL_=
MASK)
> +#define CSI_IF_CFG_CLK_POL_FALLING_EDGE		((1 << 16) & CSI_IF_CFG_CLK_POL=
_MASK)
> +#define CSI_IF_CFG_IF_DATA_WIDTH_MASK		GENMASK(10, 8)
> +#define CSI_IF_CFG_IF_DATA_WIDTH_8BIT		((0 << 8) & CSI_IF_CFG_IF_DATA_WI=
DTH_MASK)
> +#define CSI_IF_CFG_IF_DATA_WIDTH_10BIT		((1 << 8) & CSI_IF_CFG_IF_DATA_W=
IDTH_MASK)
> +#define CSI_IF_CFG_IF_DATA_WIDTH_12BIT		((2 << 8) & CSI_IF_CFG_IF_DATA_W=
IDTH_MASK)
> +#define CSI_IF_CFG_MIPI_IF_MASK			BIT(7)
> +#define CSI_IF_CFG_MIPI_IF_CSI			(0 << 7)
> +#define CSI_IF_CFG_MIPI_IF_MIPI			(1 << 7)
> +#define CSI_IF_CFG_CSI_IF_MASK			GENMASK(4, 0)
> +#define CSI_IF_CFG_CSI_IF_YUV422_INTLV		((0 << 0) & CSI_IF_CFG_CSI_IF_MA=
SK)
> +#define CSI_IF_CFG_CSI_IF_YUV422_16BIT		((1 << 0) & CSI_IF_CFG_CSI_IF_MA=
SK)
> +#define CSI_IF_CFG_CSI_IF_BT656			((4 << 0) & CSI_IF_CFG_CSI_IF_MASK)
> +#define CSI_IF_CFG_CSI_IF_BT1120		((5 << 0) & CSI_IF_CFG_CSI_IF_MASK)
> +
> +#define CSI_CAP_REG			0x8
> +#define CSI_CAP_CH0_CAP_MASK_MASK		GENMASK(5, 2)
> +#define CSI_CAP_CH0_CAP_MASK(count)		((count << 2) & CSI_CAP_CH0_CAP_MAS=
K_MASK)
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
> +#define CSI_CH_CFG_INPUT_FMT(fmt)		((fmt << 20) & CSI_CH_CFG_INPUT_FMT_M=
ASK)
> +#define CSI_CH_CFG_OUTPUT_FMT_MASK		GENMASK(19, 16)
> +#define CSI_CH_CFG_OUTPUT_FMT(fmt)		((fmt << 16) & CSI_CH_CFG_OUTPUT_FMT=
_MASK)
> +#define CSI_CH_CFG_VFLIP_EN			BIT(13)
> +#define CSI_CH_CFG_HFLIP_EN			BIT(12)
> +#define CSI_CH_CFG_FIELD_SEL_MASK		GENMASK(11, 10)
> +#define CSI_CH_CFG_FIELD_SEL_FIELD0		((0 << 10) & CSI_CH_CFG_FIELD_SEL_M=
ASK)
> +#define CSI_CH_CFG_FIELD_SEL_FIELD1		((1 << 10) & CSI_CH_CFG_FIELD_SEL_M=
ASK)
> +#define CSI_CH_CFG_FIELD_SEL_BOTH		((2 << 10) & CSI_CH_CFG_FIELD_SEL_MAS=
K)
> +#define CSI_CH_CFG_INPUT_SEQ_MASK		GENMASK(9, 8)
> +#define CSI_CH_CFG_INPUT_SEQ(seq)		((seq << 8) & CSI_CH_CFG_INPUT_SEQ_MA=
SK)
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
> +#define CSI_CH_STA_FIELD_STA_FIELD0		((0 << 2) & CSI_CH_STA_FIELD_STA_MA=
SK)
> +#define CSI_CH_STA_FIELD_STA_FIELD1		((1 << 2) & CSI_CH_STA_FIELD_STA_MA=
SK)
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
> +#define CSI_CH_HSIZE_HOR_LEN(len)		((len << 16) & CSI_CH_HSIZE_HOR_LEN_M=
ASK)
> +#define CSI_CH_HSIZE_HOR_START_MASK		GENMASK(12, 0)
> +#define CSI_CH_HSIZE_HOR_START(start)		((start << 0) & CSI_CH_HSIZE_HOR_=
START_MASK)
> +
> +#define CSI_CH_VSIZE_REG		0x84
> +#define CSI_CH_VSIZE_VER_LEN_MASK		GENMASK(28, 16)
> +#define CSI_CH_VSIZE_VER_LEN(len)		((len << 16) & CSI_CH_VSIZE_VER_LEN_M=
ASK)
> +#define CSI_CH_VSIZE_VER_START_MASK		GENMASK(12, 0)
> +#define CSI_CH_VSIZE_VER_START(start)		((start << 0) & CSI_CH_VSIZE_VER_=
START_MASK)
> +
> +#define CSI_CH_BUF_LEN_REG		0x88
> +#define CSI_CH_BUF_LEN_BUF_LEN_C_MASK		GENMASK(29, 16)
> +#define CSI_CH_BUF_LEN_BUF_LEN_C(len)		((len << 16) & CSI_CH_BUF_LEN_BUF=
_LEN_C_MASK)
> +#define CSI_CH_BUF_LEN_BUF_LEN_Y_MASK		GENMASK(13, 0)
> +#define CSI_CH_BUF_LEN_BUF_LEN_Y(len)		((len << 0) & CSI_CH_BUF_LEN_BUF_=
LEN_Y_MASK)
> +
> +#define CSI_CH_FLIP_SIZE_REG		0x8c
> +#define CSI_CH_FLIP_SIZE_VER_LEN_MASK		GENMASK(28, 16)
> +#define CSI_CH_FLIP_SIZE_VER_LEN(len)		((len << 16) & CSI_CH_FLIP_SIZE_V=
ER_LEN_MASK)
> +#define CSI_CH_FLIP_SIZE_VALID_LEN_MASK		GENMASK(12, 0)
> +#define CSI_CH_FLIP_SIZE_VALID_LEN(len)		((len << 0) & CSI_CH_FLIP_SIZE_=
VALID_LEN_MASK)
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
> +	CSI_INPUT_FORMAT_RAW		=3D 0,
> +	CSI_INPUT_FORMAT_YUV422		=3D 3,
> +	CSI_INPUT_FORMAT_YUV420		=3D 4,
> +};
> +
> +/*
> + * csi output data format
> + */
> +enum csi_output_fmt {
> +	/* only when input format is RAW */
> +	CSI_FIELD_RAW_8			=3D 0,
> +	CSI_FIELD_RAW_10		=3D 1,
> +	CSI_FIELD_RAW_12		=3D 2,
> +	CSI_FIELD_RGB565		=3D 4,
> +	CSI_FIELD_RGB888		=3D 5,
> +	CSI_FIELD_PRGB888		=3D 6,
> +	CSI_FRAME_RAW_8			=3D 8,
> +	CSI_FRAME_RAW_10		=3D 9,
> +	CSI_FRAME_RAW_12		=3D 10,
> +	CSI_FRAME_RGB565		=3D 12,
> +	CSI_FRAME_RGB888		=3D 13,
> +	CSI_FRAME_PRGB888		=3D 14,
> +
> +	/* only when input format is YUV422 */
> +	CSI_FIELD_PLANAR_YUV422		=3D 0,
> +	CSI_FIELD_PLANAR_YUV420		=3D 1,
> +	CSI_FRAME_PLANAR_YUV420		=3D 2,
> +	CSI_FRAME_PLANAR_YUV422		=3D 3,
> +	CSI_FIELD_UV_CB_YUV422		=3D 4,
> +	CSI_FIELD_UV_CB_YUV420		=3D 5,
> +	CSI_FRAME_UV_CB_YUV420		=3D 6,
> +	CSI_FRAME_UV_CB_YUV422		=3D 7,
> +	CSI_FIELD_MB_YUV422		=3D 8,
> +	CSI_FIELD_MB_YUV420		=3D 9,
> +	CSI_FRAME_MB_YUV420		=3D 10,
> +	CSI_FRAME_MB_YUV422		=3D 11,
> +	CSI_FIELD_UV_CB_YUV422_10	=3D 12,
> +	CSI_FIELD_UV_CB_YUV420_10	=3D 13,
> +};
> +
> +/*
> + * csi YUV input data sequence
> + */
> +enum csi_input_seq {
> +	/* only when input format is YUV422 */
> +	CSI_INPUT_SEQ_YUYV =3D 0,
> +	CSI_INPUT_SEQ_YVYU,
> +	CSI_INPUT_SEQ_UYVY,
> +	CSI_INPUT_SEQ_VYUY,
> +};
> +
> +#endif /* __SUN6I_CSI_V3S_H__ */

Name. See above.

> diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c b/drive=
rs/media/platform/sunxi/sun6i-csi/sun6i_video.c
> new file mode 100644
> index 0000000..0cebcbd
> --- /dev/null
> +++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
> @@ -0,0 +1,722 @@
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
> +};
> +
> +static struct sun6i_csi_format *
> +find_format_by_fourcc(struct sun6i_video *video, unsigned int fourcc)
> +{
> +	unsigned int num_formats =3D video->num_formats;
> +	struct sun6i_csi_format *fmt;
> +	unsigned int i;
> +
> +	for (i =3D 0; i < num_formats; i++) {
> +		fmt =3D &video->formats[i];
> +		if (fmt->fourcc =3D=3D fourcc)
> +			return fmt;
> +	}
> +
> +	return NULL;
> +}

Perhaps keep the naming consistent and use pixformat everywhere,
instead of fourcc once and pixformat elsewhere?

> +static struct v4l2_subdev *
> +sun6i_video_remote_subdev(struct sun6i_video *video, u32 *pad)
> +{
> +	struct media_pad *remote;
> +
> +	remote =3D media_entity_remote_pad(&video->pad);
> +
> +	if (!remote || !is_media_entity_v4l2_subdev(remote->entity))
> +		return NULL;
> +
> +	if (pad)
> +		*pad =3D remote->index;
> +
> +	return media_entity_to_v4l2_subdev(remote->entity);
> +}
> +
> +static int sun6i_video_queue_setup(struct vb2_queue *vq,
> +				 unsigned int *nbuffers, unsigned int *nplanes,
> +				 unsigned int sizes[],
> +				 struct device *alloc_devs[])
> +{
> +	struct sun6i_video *video =3D vb2_get_drv_priv(vq);
> +	unsigned int size =3D video->fmt.fmt.pix.sizeimage;
> +
> +	if (*nplanes)
> +		return sizes[0] < size ? -EINVAL : 0;
> +
> +	*nplanes =3D 1;
> +	sizes[0] =3D size;
> +
> +	return 0;
> +}
> +
> +static int sun6i_video_buffer_prepare(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vbuf =3D to_vb2_v4l2_buffer(vb);
> +	struct sun6i_csi_buffer *buf =3D
> +			container_of(vbuf, struct sun6i_csi_buffer, vb);
> +	struct sun6i_video *video =3D vb2_get_drv_priv(vb->vb2_queue);
> +	unsigned long size =3D video->fmt.fmt.pix.sizeimage;
> +
> +	if (vb2_plane_size(vb, 0) < size) {
> +		v4l2_err(video->vdev.v4l2_dev, "buffer too small (%lu < %lu)\n",
> +			 vb2_plane_size(vb, 0), size);
> +		return -EINVAL;
> +	}
> +
> +	vb2_set_plane_payload(vb, 0, size);
> +
> +	buf->dma_addr =3D vb2_dma_contig_plane_dma_addr(vb, 0);
> +
> +	vbuf->field =3D video->fmt.fmt.pix.field;
> +
> +	return 0;
> +}
> +
> +static int sun6i_pipeline_set_stream(struct sun6i_video *video, bool ena=
ble)
> +{
> +	struct media_entity *entity;
> +	struct media_pad *pad;
> +	struct v4l2_subdev *subdev;
> +	int ret;
> +
> +	entity =3D &video->vdev.entity;
> +	while (1) {
> +		pad =3D &entity->pads[0];
> +		if (!(pad->flags & MEDIA_PAD_FL_SINK))
> +			break;
> +
> +		pad =3D media_entity_remote_pad(pad);
> +		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
> +			break;
> +
> +		entity =3D pad->entity;
> +		subdev =3D media_entity_to_v4l2_subdev(entity);
> +
> +		ret =3D v4l2_subdev_call(subdev, video, s_stream, enable);
> +		if (enable && ret < 0 && ret !=3D -ENOIOCTLCMD)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int sun6i_video_start_streaming(struct vb2_queue *vq, unsigned in=
t count)
> +{
> +	struct sun6i_video *video =3D vb2_get_drv_priv(vq);
> +	struct sun6i_csi_buffer *buf;
> +	struct sun6i_csi_config config;
> +	unsigned long flags;
> +	int ret;
> +
> +	video->sequence =3D 0;
> +
> +	ret =3D media_pipeline_start(&video->vdev.entity, &video->vdev.pipe);
> +	if (ret < 0)
> +		goto err_start_pipeline;
> +
> +	ret =3D sun6i_pipeline_set_stream(video, true);
> +	if (ret < 0)
> +		goto err_start_stream;

You're starting the stream from camera before enabling the capture on
the CSI, you may lose initial frame(s), which can add significant
latency if the sensor is set to 1fps for example.

> +	config.pixelformat =3D video->fmt.fmt.pix.pixelformat;
> +	config.code =3D video->current_fmt->mbus_code;
> +	config.field =3D video->fmt.fmt.pix.field;
> +	config.width =3D video->fmt.fmt.pix.width;
> +	config.height =3D video->fmt.fmt.pix.height;
> +
> +	ret =3D sun6i_csi_update_config(video->csi, &config);
> +	if (ret < 0)
> +		goto err_update_config;
> +
> +	spin_lock_irqsave(&video->dma_queue_lock, flags);
> +	video->cur_frm =3D list_first_entry(&video->dma_queue,
> +					  struct sun6i_csi_buffer, list);
> +	list_del(&video->cur_frm->list);
> +	spin_unlock_irqrestore(&video->dma_queue_lock, flags);
> +
> +	ret =3D sun6i_csi_update_buf_addr(video->csi, video->cur_frm->dma_addr)=
;
> +	if (ret < 0)
> +		goto err_update_addr;

Note, that CSI has an internal queue for the registers you're changing
in sun6i_csi_update_buf_addr. This means that for updates like this:

A1 A2 A3 A4 A5....

you'll actually get writes like this in your ISR:

A1 A1 A2 A3 A4 A5 ...

A# being buffer addresses. You need to take this into account.

> +	ret =3D sun6i_csi_set_stream(video->csi, true);
> +	if (ret < 0)
> +		goto err_csi_stream;
> +
> +	return 0;
> +
> +err_csi_stream:
> +err_update_addr:
> +err_update_config:

One label can do it.

> +	sun6i_pipeline_set_stream(video, false);
> +err_start_stream:
> +	media_pipeline_stop(&video->vdev.entity);
> +err_start_pipeline:

^^^ Please name the labels by what the release code does, not by what
part of code it was jumped from. So it would be:

err_stop_stream:
  ...
err_stop_pipeline:
  ...
etc.

Also do this elsewhere in the code where there are multiple error path
labels.

> +	spin_lock_irqsave(&video->dma_queue_lock, flags);
> +	list_for_each_entry(buf, &video->dma_queue, list)
> +		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);

You're leaking ->cur_frm. Perhaps don't save ->cur_frm separately and
peek into the queue when necessary. It will simplify other functions
too.

> +	INIT_LIST_HEAD(&video->dma_queue);
> +	spin_unlock_irqrestore(&video->dma_queue_lock, flags);
> +
> +	return ret;
> +}
> +
> +static void sun6i_video_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct sun6i_video *video =3D vb2_get_drv_priv(vq);
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
> +	if (unlikely(video->cur_frm)) {
> +		vb2_buffer_done(&video->cur_frm->vb.vb2_buf,
> +				VB2_BUF_STATE_ERROR);
> +		video->cur_frm =3D NULL;
> +	}
> +	list_for_each_entry(buf, &video->dma_queue, list)
> +		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> +	INIT_LIST_HEAD(&video->dma_queue);
> +	spin_unlock_irqrestore(&video->dma_queue_lock, flags);
> +}
> +
> +static void sun6i_video_buffer_queue(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vbuf =3D to_vb2_v4l2_buffer(vb);
> +	struct sun6i_csi_buffer *buf =3D
> +			container_of(vbuf, struct sun6i_csi_buffer, vb);
> +	struct sun6i_video *video =3D vb2_get_drv_priv(vb->vb2_queue);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&video->dma_queue_lock, flags);
> +	if (!video->cur_frm && list_empty(&video->dma_queue) &&
> +		vb2_is_streaming(vb->vb2_queue)) {
> +		video->cur_frm =3D buf;
> +		sun6i_csi_update_buf_addr(video->csi, video->cur_frm->dma_addr);
> +		sun6i_csi_set_stream(video->csi, 1);
> +	} else
> +		list_add_tail(&buf->list, &video->dma_queue);

You can simplify this by not keeping ->cur_frm off the queue.

> +	spin_unlock_irqrestore(&video->dma_queue_lock, flags);
> +}
> +
> +void sun6i_video_frame_done(struct sun6i_video *video)
> +{
> +	spin_lock(&video->dma_queue_lock);
> +
> +	if (video->cur_frm) {
> +		struct vb2_v4l2_buffer *vbuf =3D &video->cur_frm->vb;
> +		struct vb2_buffer *vb =3D &vbuf->vb2_buf;
> +
> +		vb->timestamp =3D ktime_get_ns();
> +		vbuf->sequence =3D video->sequence++;
> +		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
> +		video->cur_frm =3D NULL;
> +	}

This will not work for the reasons above.

> +	if (!list_empty(&video->dma_queue)
> +	    && vb2_is_streaming(&video->vb2_vidq)) {
> +		video->cur_frm =3D list_first_entry(&video->dma_queue,
> +				struct sun6i_csi_buffer, list);
> +		list_del(&video->cur_frm->list);
> +		sun6i_csi_update_buf_addr(video->csi, video->cur_frm->dma_addr);
> +	} else
> +		sun6i_csi_set_stream(video->csi, 0);

Starting and stopping streaming like this on this CSI controller, will
need to account for the behavior of the hardware's internal queue of
buffer addresses. It will also add latency.

I have a working version of buffer handling for A83T CSI here:

https://github.com/megous/linux/blob/tbs-csi-hm5065/drivers/media/platf
orm/sun6i-csi/sun6i_csi.c#L230

It works around this by not stopping the stream when there are not
enough buffers and by making sure that HW and kernel aggree on where
the data is actually written to, which is not really obvious.

If you're testing with unchanging frames you may not see that the HW is
actually writing data to a stale address. It's painfully obvious with
real camera.

> +	spin_unlock(&video->dma_queue_lock);
> +}
> +
> +static struct vb2_ops sun6i_csi_vb2_ops =3D {
> +	.queue_setup		=3D sun6i_video_queue_setup,
> +	.wait_prepare		=3D vb2_ops_wait_prepare,
> +	.wait_finish		=3D vb2_ops_wait_finish,
> +	.buf_prepare		=3D sun6i_video_buffer_prepare,
> +	.start_streaming	=3D sun6i_video_start_streaming,
> +	.stop_streaming		=3D sun6i_video_stop_streaming,
> +	.buf_queue		=3D sun6i_video_buffer_queue,
> +};
> +
> +static int vidioc_querycap(struct file *file, void *priv,
> +				struct v4l2_capability *cap)
> +{

sun6i_csi_*

> +	struct sun6i_video *video =3D video_drvdata(file);
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

sun6i_csi_*

> +{
> +	struct sun6i_video *video =3D video_drvdata(file);
> +	u32 index =3D f->index;
> +
> +	if (index >=3D video->num_formats)
> +		return -EINVAL;
> +
> +	f->pixelformat =3D video->formats[index].fourcc;
> +
> +	return 0;
> +}
> +
> +static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *fmt)
> +{

sun6i_csi_*

It's the same with many functions below.

> +	struct sun6i_video *video =3D video_drvdata(file);
> +
> +	*fmt =3D video->fmt;
> +
> +	return 0;
> +}
> +
> +static int sun6i_video_try_fmt(struct sun6i_video *video, struct v4l2_fo=
rmat *f,
> +			       struct sun6i_csi_format **current_fmt)
> +{
> +	struct sun6i_csi_format *csi_fmt;
> +	struct v4l2_pix_format *pixfmt =3D &f->fmt.pix;
> +	struct v4l2_subdev_format format;
> +	struct v4l2_subdev *subdev;
> +	u32 pad;
> +	int ret;
> +
> +	subdev =3D sun6i_video_remote_subdev(video, &pad);
> +	if (subdev =3D=3D NULL)
> +		return -ENXIO;
> +
> +	csi_fmt =3D find_format_by_fourcc(video, pixfmt->pixelformat);
> +	if (csi_fmt =3D=3D NULL) {
> +		if (video->num_formats > 0) {
> +			csi_fmt =3D &video->formats[0];
> +			pixfmt->pixelformat =3D csi_fmt->fourcc;
> +		} else
> +			return -EINVAL;
> +	}
> +
> +	format.pad =3D pad;
> +	format.which =3D V4L2_SUBDEV_FORMAT_TRY;
> +	v4l2_fill_mbus_format(&format.format, pixfmt, csi_fmt->mbus_code);
> +	ret =3D v4l2_subdev_call(subdev, pad, get_fmt, NULL, &format);
> +	if (ret)
> +		return ret;

> +	v4l2_fill_pix_format(pixfmt, &format.format);
> +
> +	pixfmt->bytesperline =3D (pixfmt->width * csi_fmt->bpp) >> 3;
> +	pixfmt->sizeimage =3D (pixfmt->width * csi_fmt->bpp * pixfmt->height) /=
 8;
> +
> +	if (current_fmt)
> +		*current_fmt =3D csi_fmt;
> +
> +	return 0;
> +}
> +
> +static int sun6i_video_set_fmt(struct sun6i_video *video, struct v4l2_fo=
rmat *f)
> +{
> +	struct v4l2_subdev_format format;
> +	struct sun6i_csi_format *current_fmt;
> +	struct v4l2_subdev *subdev;
> +	u32 pad;
> +	int ret;
> +
> +	subdev =3D sun6i_video_remote_subdev(video, &pad);
> +	if (subdev =3D=3D NULL)
> +		return -ENXIO;
> +
> +	ret =3D sun6i_video_try_fmt(video, f, &current_fmt);
> +	if (ret)
> +		return ret;
> +
> +	format.which =3D V4L2_SUBDEV_FORMAT_ACTIVE;
> +	v4l2_fill_mbus_format(&format.format, &f->fmt.pix,
> +			      current_fmt->mbus_code);
> +	ret =3D v4l2_subdev_call(subdev, pad, set_fmt, NULL, &format);
> +	if (ret < 0)
> +		return ret;

Subdev may alter anything in the format to what it supports. You
probably need to check that it still matches your driver expectatations
about width/height/mbus_code, etc.

thanks and regards,
  Ondrej Jirman

> +	video->fmt =3D *f;
> +	video->current_fmt =3D current_fmt;
> +
> +	return 0;
> +}
> +
> +static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	struct sun6i_video *video =3D video_drvdata(file);
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
> +	struct sun6i_video *video =3D video_drvdata(file);
> +
> +	return sun6i_video_try_fmt(video, f, NULL);
> +}
> +
> +static int vidioc_enum_input(struct file *file, void *fh,
> +			 struct v4l2_input *inp)
> +{
> +	struct sun6i_video *video =3D video_drvdata(file);
> +	struct v4l2_subdev *subdev;
> +	u32 pad;
> +	int ret;
> +
> +	if (inp->index !=3D 0)
> +		return -EINVAL;
> +
> +	subdev =3D sun6i_video_remote_subdev(video, &pad);
> +	if (subdev =3D=3D NULL)
> +		return -ENXIO;
> +
> +	ret =3D v4l2_subdev_call(subdev, video, g_input_status, &inp->status);
> +	if (ret < 0 && ret !=3D -ENOIOCTLCMD && ret !=3D -ENODEV)
> +		return ret;
> +
> +	inp->type =3D V4L2_INPUT_TYPE_CAMERA;
> +
> +	if (v4l2_subdev_has_op(subdev, pad, dv_timings_cap)) {
> +		inp->capabilities =3D V4L2_IN_CAP_DV_TIMINGS;
> +		inp->std =3D 0;
> +	} else {
> +		inp->capabilities =3D 0;
> +		inp->std =3D 0;
> +	}
> +
> +	strlcpy(inp->name, subdev->name, sizeof(inp->name));
> +
> +	return 0;
> +}
> +
> +static int vidioc_g_input(struct file *file, void *fh, unsigned int *i)
> +{
> +	*i =3D 0;
> +
> +	return 0;
> +}
> +
> +static int vidioc_s_input(struct file *file, void *fh, unsigned int i)
> +{
> +	if (i !=3D 0)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ioctl_ops sun6i_video_ioctl_ops =3D {
> +	.vidioc_querycap		=3D vidioc_querycap,
> +	.vidioc_enum_fmt_vid_cap	=3D vidioc_enum_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_cap		=3D vidioc_g_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap		=3D vidioc_s_fmt_vid_cap,
> +	.vidioc_try_fmt_vid_cap		=3D vidioc_try_fmt_vid_cap,
> +
> +	.vidioc_enum_input		=3D vidioc_enum_input,
> +	.vidioc_s_input			=3D vidioc_s_input,
> +	.vidioc_g_input			=3D vidioc_g_input,
> +
> +	.vidioc_reqbufs			=3D vb2_ioctl_reqbufs,
> +	.vidioc_querybuf		=3D vb2_ioctl_querybuf,
> +	.vidioc_qbuf			=3D vb2_ioctl_qbuf,
> +	.vidioc_expbuf			=3D vb2_ioctl_expbuf,
> +	.vidioc_dqbuf			=3D vb2_ioctl_dqbuf,
> +	.vidioc_create_bufs		=3D vb2_ioctl_create_bufs,
> +	.vidioc_prepare_buf		=3D vb2_ioctl_prepare_buf,
> +	.vidioc_streamon		=3D vb2_ioctl_streamon,
> +	.vidioc_streamoff		=3D vb2_ioctl_streamoff,
> +};
> +
> +/* ---------------------------------------------------------------------=
--------
> + * V4L2 file operations
> + */
> +static int sun6i_video_open(struct file *file)
> +{
> +	struct sun6i_video *video =3D video_drvdata(file);
> +	int ret;
> +
> +	if (mutex_lock_interruptible(&video->lock))
> +		return -ERESTARTSYS;
> +
> +	ret =3D v4l2_fh_open(file);
> +	if (ret < 0)
> +		goto unlock;
> +
> +	ret =3D v4l2_pipeline_pm_use(&video->vdev.entity, 1);
> +	if (ret < 0)
> +		goto fh_release;
> +
> +	if (!v4l2_fh_is_singular_file(file))
> +		goto unlock;
> +
> +	ret =3D sun6i_csi_set_power(video->csi, true);
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
> +	struct sun6i_video *video =3D video_drvdata(file);
> +	bool last_fh;
> +
> +	mutex_lock(&video->lock);
> +
> +	last_fh =3D v4l2_fh_is_singular_file(file);
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
> +static const struct v4l2_file_operations sun6i_video_fops =3D {
> +	.owner		=3D THIS_MODULE,
> +	.open		=3D sun6i_video_open,
> +	.release	=3D sun6i_video_close,
> +	.unlocked_ioctl	=3D video_ioctl2,
> +	.mmap		=3D vb2_fop_mmap,
> +	.poll		=3D vb2_fop_poll
> +};
> +
> +/* ---------------------------------------------------------------------=
--------
> + * Media Operations
> + */
> +static int sun6i_video_formats_init(struct sun6i_video *video)
> +{
> +	struct v4l2_subdev_mbus_code_enum mbus_code =3D { 0 };
> +	struct sun6i_csi *csi =3D video->csi;
> +	struct v4l2_format format;
> +	struct v4l2_subdev *subdev;
> +	u32 pad;
> +	const u32 *pixformats;
> +	int pixformat_count =3D 0;
> +	u32 subdev_codes[32]; /* subdev format codes, 32 should be enough */
> +	int codes_count =3D 0;
> +	int num_fmts =3D 0;
> +	int i, j;
> +
> +	subdev =3D sun6i_video_remote_subdev(video, &pad);
> +	if (subdev =3D=3D NULL)
> +		return -ENXIO;
> +
> +	/* Get supported pixformats of CSI */
> +	pixformat_count =3D sun6i_csi_get_supported_pixformats(csi, &pixformats=
);
> +	if (pixformat_count <=3D 0)
> +		return -ENXIO;
> +
> +	/* Get subdev formats codes */
> +	mbus_code.pad =3D pad;
> +	mbus_code.which =3D V4L2_SUBDEV_FORMAT_ACTIVE;
> +	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code, NULL,
> +				 &mbus_code)) {
> +		if (codes_count >=3D ARRAY_SIZE(subdev_codes)) {
> +			dev_warn(video->csi->dev,
> +				 "subdev_codes array is full!\n");
> +			break;
> +		}
> +		subdev_codes[codes_count] =3D mbus_code.code;
> +		codes_count++;
> +		mbus_code.index++;
> +	}
> +
> +	if (!codes_count)
> +		return -ENXIO;
> +
> +	/* Get supported formats count */
> +	for (i =3D 0; i < codes_count; i++) {
> +		for (j =3D 0; j < pixformat_count; j++) {
> +			if (!sun6i_csi_is_format_support(csi, pixformats[j],
> +					mbus_code.code)) {
> +				continue;
> +			}
> +			num_fmts++;
> +		}
> +	}
> +
> +	if (!num_fmts)
> +		return -ENXIO;
> +
> +	video->num_formats =3D num_fmts;
> +	video->formats =3D devm_kcalloc(video->csi->dev, num_fmts,
> +			sizeof(struct sun6i_csi_format), GFP_KERNEL);
> +	if (!video->formats)
> +		return -ENOMEM;
> +
> +	/* Get supported formats */
> +	num_fmts =3D 0;
> +	for (i =3D 0; i < codes_count; i++) {
> +		for (j =3D 0; j < pixformat_count; j++) {
> +			if (!sun6i_csi_is_format_support(csi, pixformats[j],
> +					mbus_code.code)) {
> +				continue;
> +			}
> +
> +			video->formats[num_fmts].fourcc =3D pixformats[j];
> +			video->formats[num_fmts].mbus_code =3D
> +					mbus_code.code;
> +			video->formats[num_fmts].bpp =3D
> +					v4l2_pixformat_get_bpp(pixformats[j]);
> +			num_fmts++;
> +		}
> +	}
> +
> +	/* setup default format */
> +	format.type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	format.fmt.pix.width =3D 1280;
> +	format.fmt.pix.height =3D 720;
> +	format.fmt.pix.pixelformat =3D video->formats[0].fourcc;
> +	sun6i_video_set_fmt(video, &format);
> +
> +	return 0;
> +}
> +
> +static int sun6i_video_link_setup(struct media_entity *entity,
> +				  const struct media_pad *local,
> +				  const struct media_pad *remote, u32 flags)
> +{
> +	struct video_device *vdev =3D media_entity_to_video_device(entity);
> +	struct sun6i_video *video =3D video_get_drvdata(vdev);
> +
> +	if (WARN_ON(video =3D=3D NULL))
> +		return 0;
> +
> +	return sun6i_video_formats_init(video);
> +}
> +
> +static const struct media_entity_operations sun6i_video_media_ops =3D {
> +	.link_setup =3D sun6i_video_link_setup,
> +};
> +
> +int sun6i_video_init(struct sun6i_video *video, struct sun6i_csi *csi,
> +		     const char *name)
> +{
> +	struct video_device *vdev =3D &video->vdev;
> +	struct vb2_queue *vidq =3D &video->vb2_vidq;
> +	int ret;
> +
> +	video->csi =3D csi;
> +
> +	/* Initialize the media entity... */
> +	video->pad.flags =3D MEDIA_PAD_FL_SINK | MEDIA_PAD_FL_MUST_CONNECT;
> +	vdev->entity.ops =3D &sun6i_video_media_ops;
> +	ret =3D media_entity_pads_init(&vdev->entity, 1, &video->pad);
> +	if (ret < 0)
> +		return ret;
> +
> +	mutex_init(&video->lock);
> +
> +	INIT_LIST_HEAD(&video->dma_queue);
> +	spin_lock_init(&video->dma_queue_lock);
> +
> +	video->cur_frm =3D NULL;
> +	video->sequence =3D 0;
> +	video->num_formats =3D 0;
> +
> +	/* Initialize videobuf2 queue */
> +	vidq->type			=3D V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	vidq->io_modes			=3D VB2_MMAP | VB2_DMABUF;
> +	vidq->drv_priv			=3D video;
> +	vidq->buf_struct_size		=3D sizeof(struct sun6i_csi_buffer);
> +	vidq->ops			=3D &sun6i_csi_vb2_ops;
> +	vidq->mem_ops			=3D &vb2_dma_contig_memops;
> +	vidq->timestamp_flags		=3D V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	vidq->lock			=3D &video->lock;
> +	vidq->min_buffers_needed	=3D 1;
> +	vidq->dev			=3D csi->dev;
> +
> +	ret =3D vb2_queue_init(vidq);
> +	if (ret) {
> +		v4l2_err(&csi->v4l2_dev, "vb2_queue_init failed: %d\n", ret);
> +		goto error;
> +	}
> +
> +	/* Register video device */
> +	strlcpy(vdev->name, name, sizeof(vdev->name));
> +	vdev->release		=3D video_device_release_empty;
> +	vdev->fops		=3D &sun6i_video_fops;
> +	vdev->ioctl_ops		=3D &sun6i_video_ioctl_ops;
> +	vdev->vfl_type		=3D VFL_TYPE_GRABBER;
> +	vdev->vfl_dir		=3D VFL_DIR_RX;
> +	vdev->v4l2_dev		=3D &csi->v4l2_dev;
> +	vdev->queue		=3D vidq;
> +	vdev->lock		=3D &video->lock;
> +	vdev->device_caps	=3D V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE;
> +	video_set_drvdata(vdev, video);
> +
> +	ret =3D video_register_device(vdev, VFL_TYPE_GRABBER, -1);
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
> diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.h b/drive=
rs/media/platform/sunxi/sun6i-csi/sun6i_video.h
> new file mode 100644
> index 0000000..14eac6e
> --- /dev/null
> +++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.h
> @@ -0,0 +1,61 @@
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
> + * @fourcc: Fourcc code for this format
> + * @mbus_code: V4L2 media bus format code.
> + * @bpp: Bytes per pixel (when stored in memory)
> + */
> +struct sun6i_csi_format {
> +	u32				fourcc;
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
> +	struct sun6i_csi_buffer		*cur_frm;
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
> --=20
> 1.8.3.1
>=20
--=-inNlocy2VZP6alcr4Vz3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEmrE4sgaRYhzUz5ICbmQmxnfP7/EFAloJhYIACgkQbmQmxnfP
7/ENuw//R3pAcqamx7rL9LaupTYS1ylNg/e+C+O+Bs+W9yC30GGnjbCrayBhoEtr
0yN8clYXgaNE10ExbXiD/Donq3vhYuXYTGhI03k3ezJkXTvJX4+hXlhuDQf8e5KT
ZP+RBSW0XoLWLamOpl01jhQXvvdBKuOQZrZe8j42xflbjOk7Tmr68fTV76tQKCAb
Iy7tqQxcddRDR5o7QitHjqBVTxdSTMW/3U9XlCDis4NIxti+XHq4NR9TOMjJgpAn
zFof3g9YvxCOikN/SlapgCy33NlqcTXfCFFE8VjEpH2kDQQSneGWfldlrhYm9L8F
2Cb9Dhs58EkKD16HpHJbwZ+lLj5wwozk/0G/24vJu+mZu3nROAZOzuAQSLuDDKUN
q0oA366F2COUNMt1mR9M5MN4Ye/J6VTpclEmKuYTpiYKIEouGs7ZMdCTeuT7rVLG
QxsYI8vJImwg9bLB2bWblncXZbS9EJ94K8rSARi+CM/CsUO9Slcqaw6t4WqGkfI7
A7CFz838OBTNjLRHt/DtZu3qV7aglyaScs8iDlf6UKMZOPphb82cBayOdOp19iMJ
dF3rDu0NCyApMPGVqBfEBW7UdihM3QiIji2h/tK0iCeQBFh/DiS+BGXeCaQzhHJD
MBV02bSm1kGxA8A103iE5H0XEYHFRMNjkHXYyORzBW8RBbm5hOo=
=ZQqV
-----END PGP SIGNATURE-----

--=-inNlocy2VZP6alcr4Vz3--
