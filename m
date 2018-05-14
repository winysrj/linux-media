Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:41163 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932229AbeENNOz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 09:14:55 -0400
Date: Mon, 14 May 2018 15:14:48 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v15 2/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver
 driver
Message-ID: <20180514131448.GI5956@w540>
References: <20180513191917.20681-1-niklas.soderlund+renesas@ragnatech.se>
 <20180513191917.20681-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XigHxYirkHk2Kxsx"
Content-Disposition: inline
In-Reply-To: <20180513191917.20681-3-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--XigHxYirkHk2Kxsx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,
   thanks for the patch

On Sun, May 13, 2018 at 09:19:17PM +0200, Niklas S=C3=B6derlund wrote:
> A V4L2 driver for Renesas R-Car MIPI CSI-2 receiver. The driver
> supports the R-Car Gen3 SoCs where separate CSI-2 hardware blocks are
> connected between the video sources and the video grabbers (VIN).
>
> Driver is based on a prototype by Koji Matsuoka in the Renesas BSP.
>
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>
>
> ---
>
> * Changes since v14
> - Data sheet update changed init sequence for PHY forcing a restructure
>   of the driver. The restructure was so big I felt compel to drop all
>   review tags :-(
> - The change was that the Renesas H3 procedure was aligned with other
>   SoC in the Gen3 family procedure. I had kept the rework as separate
>   patches and was planing to post once original driver with H3 and M3-W
>   support where merged. As review tags are dropped I chosen to squash
>   those patches into 2/2.
> - Add support for Gen3 V3M.
> - Add support for Gen3 M3-N.
> - Set PHTC_TESTCLR when stopping the PHY.
> - Revert back to the v12 and earlier phypll calculation as it turns out
>   it was correct after all.
>
> * Changes since v13
> - Change return rcar_csi2_formats + i to return &rcar_csi2_formats[i].
> - Add define for PHCLM_STOPSTATECKL.
> - Update spelling in comments.
> - Update calculation in rcar_csi2_calc_phypll() according to
>   https://linuxtv.org/downloads/v4l-dvb-apis/kapi/csi2.html. The one
>   before v14 did not take into account that 2 bits per sample is
>   transmitted.
> - Use Geert's suggestion of (1 << priv->lanes) - 1 instead of switch
>   statement to set correct number of lanes to enable.
> - Change hex constants in hsfreqrange_m3w_h3es1[] to lower case to match
>   style of rest of file.
> - Switch to %u instead of 0x%x when printing bus type.
> - Switch to %u instead of %d for priv->lanes which is unsigned.
> - Add MEDIA_BUS_FMT_YUYV8_1X16 to the list of supported formats in
>   rcar_csi2_formats[].
> - Fixed bps for MEDIA_BUS_FMT_YUYV10_2X10 to 20 and not 16.
> - Set INTSTATE after PL-11 is confirmed to match flow chart in
>   datasheet.
> - Change priv->notifier.subdevs =3D=3D NULL to !priv->notifier.subdevs.
> - Add Maxime's and laurent's tags.
> ---
>  drivers/media/platform/rcar-vin/Kconfig     |   12 +
>  drivers/media/platform/rcar-vin/Makefile    |    1 +
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 1101 +++++++++++++++++++
>  3 files changed, 1114 insertions(+)
>  create mode 100644 drivers/media/platform/rcar-vin/rcar-csi2.c
>
> diff --git a/drivers/media/platform/rcar-vin/Kconfig b/drivers/media/plat=
form/rcar-vin/Kconfig
> index 8fa7ee468c63afb9..d5835da6d4100d87 100644
> --- a/drivers/media/platform/rcar-vin/Kconfig
> +++ b/drivers/media/platform/rcar-vin/Kconfig
> @@ -1,3 +1,15 @@
> +config VIDEO_RCAR_CSI2
> +	tristate "R-Car MIPI CSI-2 Receiver"
> +	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF
> +	depends on ARCH_RENESAS || COMPILE_TEST
> +	select V4L2_FWNODE
> +	help
> +	  Support for Renesas R-Car MIPI CSI-2 receiver.
> +	  Supports R-Car Gen3 SoCs.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called rcar-csi2.
> +
>  config VIDEO_RCAR_VIN
>  	tristate "R-Car Video Input (VIN) Driver"
>  	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF && HAS_DMA && MEDI=
A_CONTROLLER
> diff --git a/drivers/media/platform/rcar-vin/Makefile b/drivers/media/pla=
tform/rcar-vin/Makefile
> index 48c5632c21dc060b..5ab803d3e7c1aa57 100644
> --- a/drivers/media/platform/rcar-vin/Makefile
> +++ b/drivers/media/platform/rcar-vin/Makefile
> @@ -1,3 +1,4 @@
>  rcar-vin-objs =3D rcar-core.o rcar-dma.o rcar-v4l2.o
>
> +obj-$(CONFIG_VIDEO_RCAR_CSI2) +=3D rcar-csi2.o
>  obj-$(CONFIG_VIDEO_RCAR_VIN) +=3D rcar-vin.o
> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/=
platform/rcar-vin/rcar-csi2.c
> new file mode 100644
> index 0000000000000000..b19374f1516464dc
> --- /dev/null
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -0,0 +1,1101 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Driver for Renesas R-Car MIPI CSI-2 Receiver
> + *
> + * Copyright (C) 2018 Renesas Electronics Corp.
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/of_graph.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/sys_soc.h>
> +
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-fwnode.h>
> +#include <media/v4l2-mc.h>
> +#include <media/v4l2-subdev.h>
> +
> +struct rcar_csi2;
> +
> +/* Register offsets and bits */
> +
> +/* Control Timing Select */
> +#define TREF_REG			0x00
> +#define TREF_TREF			BIT(0)
> +
> +/* Software Reset */
> +#define SRST_REG			0x04
> +#define SRST_SRST			BIT(0)
> +
> +/* PHY Operation Control */
> +#define PHYCNT_REG			0x08
> +#define PHYCNT_SHUTDOWNZ		BIT(17)
> +#define PHYCNT_RSTZ			BIT(16)
> +#define PHYCNT_ENABLECLK		BIT(4)
> +#define PHYCNT_ENABLE_3			BIT(3)
> +#define PHYCNT_ENABLE_2			BIT(2)
> +#define PHYCNT_ENABLE_1			BIT(1)
> +#define PHYCNT_ENABLE_0			BIT(0)
> +
> +/* Checksum Control */
> +#define CHKSUM_REG			0x0c
> +#define CHKSUM_ECC_EN			BIT(1)
> +#define CHKSUM_CRC_EN			BIT(0)
> +
> +/*
> + * Channel Data Type Select
> + * VCDT[0-15]:  Channel 1 VCDT[16-31]:  Channel 2
> + * VCDT2[0-15]: Channel 3 VCDT2[16-31]: Channel 4
> + */
> +#define VCDT_REG			0x10
> +#define VCDT2_REG			0x14
> +#define VCDT_VCDTN_EN			BIT(15)
> +#define VCDT_SEL_VC(n)			(((n) & 0x3) << 8)
> +#define VCDT_SEL_DTN_ON			BIT(6)
> +#define VCDT_SEL_DT(n)			(((n) & 0x3f) << 0)
> +
> +/* Frame Data Type Select */
> +#define FRDT_REG			0x18
> +
> +/* Field Detection Control */
> +#define FLD_REG				0x1c
> +#define FLD_FLD_NUM(n)			(((n) & 0xff) << 16)
> +#define FLD_FLD_EN4			BIT(3)
> +#define FLD_FLD_EN3			BIT(2)
> +#define FLD_FLD_EN2			BIT(1)
> +#define FLD_FLD_EN			BIT(0)
> +
> +/* Automatic Standby Control */
> +#define ASTBY_REG			0x20
> +
> +/* Long Data Type Setting 0 */
> +#define LNGDT0_REG			0x28
> +
> +/* Long Data Type Setting 1 */
> +#define LNGDT1_REG			0x2c
> +
> +/* Interrupt Enable */
> +#define INTEN_REG			0x30
> +
> +/* Interrupt Source Mask */
> +#define INTCLOSE_REG			0x34
> +
> +/* Interrupt Status Monitor */
> +#define INTSTATE_REG			0x38
> +#define INTSTATE_INT_ULPS_START		BIT(7)
> +#define INTSTATE_INT_ULPS_END		BIT(6)
> +
> +/* Interrupt Error Status Monitor */
> +#define INTERRSTATE_REG			0x3c
> +
> +/* Short Packet Data */
> +#define SHPDAT_REG			0x40
> +
> +/* Short Packet Count */
> +#define SHPCNT_REG			0x44
> +
> +/* LINK Operation Control */
> +#define LINKCNT_REG			0x48
> +#define LINKCNT_MONITOR_EN		BIT(31)
> +#define LINKCNT_REG_MONI_PACT_EN	BIT(25)
> +#define LINKCNT_ICLK_NONSTOP		BIT(24)
> +
> +/* Lane Swap */
> +#define LSWAP_REG			0x4c
> +#define LSWAP_L3SEL(n)			(((n) & 0x3) << 6)
> +#define LSWAP_L2SEL(n)			(((n) & 0x3) << 4)
> +#define LSWAP_L1SEL(n)			(((n) & 0x3) << 2)
> +#define LSWAP_L0SEL(n)			(((n) & 0x3) << 0)
> +
> +/* PHY Test Interface Write Register */
> +#define PHTW_REG			0x50
> +#define PHTW_DWEN			BIT(24)
> +#define PHTW_TESTDIN_DATA(n)		(((n & 0xff)) << 16)
> +#define PHTW_CWEN			BIT(8)
> +#define PHTW_TESTDIN_CODE(n)		((n & 0xff))

[snip]

> +/* PHY Test Interface Clear */
> +#define PHTC_REG			0x58
> +#define PHTC_TESTCLR			BIT(0)
> +
> +/* PHY Frequency Control */
> +#define PHYPLL_REG			0x68
> +#define PHYPLL_HSFREQRANGE(n)		((n) << 16)
> +
> +struct phypll_hsfreqrange {
> +	u16 mbps;
> +	u16 reg;
> +};
> +

You'll be happy to know I see changes in these tables from datasheet
v.80 to datasheet v1.00 :(

> +static const struct phypll_hsfreqrange hsfreqrange_h3_v3h_m3n[] =3D {
> +	{ .mbps =3D   80, .reg =3D 0x00 },
> +	{ .mbps =3D   90, .reg =3D 0x10 },
> +	{ .mbps =3D  100, .reg =3D 0x20 },
> +	{ .mbps =3D  110, .reg =3D 0x30 },
> +	{ .mbps =3D  120, .reg =3D 0x01 },
> +	{ .mbps =3D  130, .reg =3D 0x11 },
> +	{ .mbps =3D  140, .reg =3D 0x21 },
> +	{ .mbps =3D  150, .reg =3D 0x31 },
> +	{ .mbps =3D  160, .reg =3D 0x02 },
> +	{ .mbps =3D  170, .reg =3D 0x12 },
> +	{ .mbps =3D  180, .reg =3D 0x22 },
> +	{ .mbps =3D  190, .reg =3D 0x32 },
> +	{ .mbps =3D  205, .reg =3D 0x03 },
> +	{ .mbps =3D  220, .reg =3D 0x13 },
> +	{ .mbps =3D  235, .reg =3D 0x23 },
> +	{ .mbps =3D  250, .reg =3D 0x33 },
> +	{ .mbps =3D  275, .reg =3D 0x04 },
> +	{ .mbps =3D  300, .reg =3D 0x14 },
> +	{ .mbps =3D  325, .reg =3D 0x25 },
> +	{ .mbps =3D  350, .reg =3D 0x35 },
> +	{ .mbps =3D  400, .reg =3D 0x05 },
> +	{ .mbps =3D  450, .reg =3D 0x26 },

Like here (reg =3D 0x16)

> +	{ .mbps =3D  500, .reg =3D 0x36 },
and here (reg =3D 0x26)

I'm sure there will be more, but I'm happy to leave the funny part of
finding that out to you.

> +	{ .mbps =3D  550, .reg =3D 0x37 },
> +	{ .mbps =3D  600, .reg =3D 0x07 },
> +	{ .mbps =3D  650, .reg =3D 0x18 },
> +	{ .mbps =3D  700, .reg =3D 0x28 },
> +	{ .mbps =3D  750, .reg =3D 0x39 },
> +	{ .mbps =3D  800, .reg =3D 0x09 },
> +	{ .mbps =3D  850, .reg =3D 0x19 },
> +	{ .mbps =3D  900, .reg =3D 0x29 },
> +	{ .mbps =3D  950, .reg =3D 0x3a },
> +	{ .mbps =3D 1000, .reg =3D 0x0a },
> +	{ .mbps =3D 1050, .reg =3D 0x1a },
> +	{ .mbps =3D 1100, .reg =3D 0x2a },
> +	{ .mbps =3D 1150, .reg =3D 0x3b },
> +	{ .mbps =3D 1200, .reg =3D 0x0b },
> +	{ .mbps =3D 1250, .reg =3D 0x1b },
> +	{ .mbps =3D 1300, .reg =3D 0x2b },
> +	{ .mbps =3D 1350, .reg =3D 0x3c },
> +	{ .mbps =3D 1400, .reg =3D 0x0c },
> +	{ .mbps =3D 1450, .reg =3D 0x1c },
> +	{ .mbps =3D 1500, .reg =3D 0x2c },
> +	{ /* sentinel */ },
> +};

It's very nice the reg values are nicely sorted and easily comparable.
Thanks hw manual -.-

So far they seems good, I'll let you compare them for m3w

> +
> +static const struct phypll_hsfreqrange hsfreqrange_m3w_h3es1[] =3D {
> +	{ .mbps =3D   80,	.reg =3D 0x00 },
> +	{ .mbps =3D   90,	.reg =3D 0x10 },
> +	{ .mbps =3D  100,	.reg =3D 0x20 },
> +	{ .mbps =3D  110,	.reg =3D 0x30 },
> +	{ .mbps =3D  120,	.reg =3D 0x01 },
> +	{ .mbps =3D  130,	.reg =3D 0x11 },
> +	{ .mbps =3D  140,	.reg =3D 0x21 },
> +	{ .mbps =3D  150,	.reg =3D 0x31 },
> +	{ .mbps =3D  160,	.reg =3D 0x02 },
> +	{ .mbps =3D  170,	.reg =3D 0x12 },
> +	{ .mbps =3D  180,	.reg =3D 0x22 },
> +	{ .mbps =3D  190,	.reg =3D 0x32 },
> +	{ .mbps =3D  205,	.reg =3D 0x03 },
> +	{ .mbps =3D  220,	.reg =3D 0x13 },
> +	{ .mbps =3D  235,	.reg =3D 0x23 },
> +	{ .mbps =3D  250,	.reg =3D 0x33 },
> +	{ .mbps =3D  275,	.reg =3D 0x04 },
> +	{ .mbps =3D  300,	.reg =3D 0x14 },
> +	{ .mbps =3D  325,	.reg =3D 0x05 },
> +	{ .mbps =3D  350,	.reg =3D 0x15 },
> +	{ .mbps =3D  400,	.reg =3D 0x25 },
> +	{ .mbps =3D  450,	.reg =3D 0x06 },
> +	{ .mbps =3D  500,	.reg =3D 0x16 },
> +	{ .mbps =3D  550,	.reg =3D 0x07 },
> +	{ .mbps =3D  600,	.reg =3D 0x17 },
> +	{ .mbps =3D  650,	.reg =3D 0x08 },
> +	{ .mbps =3D  700,	.reg =3D 0x18 },
> +	{ .mbps =3D  750,	.reg =3D 0x09 },
> +	{ .mbps =3D  800,	.reg =3D 0x19 },
> +	{ .mbps =3D  850,	.reg =3D 0x29 },
> +	{ .mbps =3D  900,	.reg =3D 0x39 },
> +	{ .mbps =3D  950,	.reg =3D 0x0a },
> +	{ .mbps =3D 1000,	.reg =3D 0x1a },
> +	{ .mbps =3D 1050,	.reg =3D 0x2a },
> +	{ .mbps =3D 1100,	.reg =3D 0x3a },
> +	{ .mbps =3D 1150,	.reg =3D 0x0b },
> +	{ .mbps =3D 1200,	.reg =3D 0x1b },
> +	{ .mbps =3D 1250,	.reg =3D 0x2b },
> +	{ .mbps =3D 1300,	.reg =3D 0x3b },
> +	{ .mbps =3D 1350,	.reg =3D 0x0c },
> +	{ .mbps =3D 1400,	.reg =3D 0x1c },
> +	{ .mbps =3D 1450,	.reg =3D 0x2c },
> +	{ .mbps =3D 1500,	.reg =3D 0x3c },
> +	{ /* sentinel */ },
> +};
> +
> +/* PHY ESC Error Monitor */
> +#define PHEERM_REG			0x74
> +
> +/* PHY Clock Lane Monitor */
> +#define PHCLM_REG			0x78
> +#define PHCLM_STOPSTATECKL		BIT(0)
> +
> +/* PHY Data Lane Monitor */
> +#define PHDLM_REG			0x7c
> +
> +/* CSI0CLK Frequency Configuration Preset Register */
> +#define CSI0CLKFCPR_REG			0x260
> +#define CSI0CLKFREQRANGE(n)		((n & 0x3f) << 16)
> +
> +struct rcar_csi2_format {
> +	u32 code;
> +	unsigned int datatype;
> +	unsigned int bpp;
> +};
> +
> +static const struct rcar_csi2_format rcar_csi2_formats[] =3D {
> +	{ .code =3D MEDIA_BUS_FMT_RGB888_1X24,	.datatype =3D 0x24, .bpp =3D 24 =
},
> +	{ .code =3D MEDIA_BUS_FMT_UYVY8_1X16,	.datatype =3D 0x1e, .bpp =3D 16 },
> +	{ .code =3D MEDIA_BUS_FMT_YUYV8_1X16,	.datatype =3D 0x1e, .bpp =3D 16 },
> +	{ .code =3D MEDIA_BUS_FMT_UYVY8_2X8,	.datatype =3D 0x1e, .bpp =3D 16 },
> +	{ .code =3D MEDIA_BUS_FMT_YUYV10_2X10,	.datatype =3D 0x1e, .bpp =3D 20 =
},
> +};
> +
> +static const struct rcar_csi2_format *rcsi2_code_to_fmt(unsigned int cod=
e)
> +{
> +	unsigned int i;
> +
> +	for (i =3D 0; i < ARRAY_SIZE(rcar_csi2_formats); i++)
> +		if (rcar_csi2_formats[i].code =3D=3D code)
> +			return &rcar_csi2_formats[i];
> +
> +	return NULL;
> +}
> +
> +enum rcar_csi2_pads {
> +	RCAR_CSI2_SINK,
> +	RCAR_CSI2_SOURCE_VC0,
> +	RCAR_CSI2_SOURCE_VC1,
> +	RCAR_CSI2_SOURCE_VC2,
> +	RCAR_CSI2_SOURCE_VC3,
> +	NR_OF_RCAR_CSI2_PAD,
> +};
> +
> +struct rcar_csi2_info {
> +	int (*init_phtw)(struct rcar_csi2 *priv, unsigned int mbps);
> +	const struct phypll_hsfreqrange *hsfreqrange;
> +	unsigned int csi0clkfreqrange;
> +	bool clear_ulps;
> +};
> +
> +struct rcar_csi2 {
> +	struct device *dev;
> +	void __iomem *base;
> +	const struct rcar_csi2_info *info;
> +
> +	struct v4l2_subdev subdev;
> +	struct media_pad pads[NR_OF_RCAR_CSI2_PAD];
> +
> +	struct v4l2_async_notifier notifier;
> +	struct v4l2_async_subdev asd;
> +	struct v4l2_subdev *remote;
> +
> +	struct v4l2_mbus_framefmt mf;
> +
> +	struct mutex lock;
> +	int stream_count;
> +
> +	unsigned short lanes;
> +	unsigned char lane_swap[4];
> +};
> +
> +static inline struct rcar_csi2 *sd_to_csi2(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct rcar_csi2, subdev);
> +}
> +
> +static inline struct rcar_csi2 *notifier_to_csi2(struct v4l2_async_notif=
ier *n)
> +{
> +	return container_of(n, struct rcar_csi2, notifier);
> +}
> +
> +static u32 rcsi2_read(struct rcar_csi2 *priv, unsigned int reg)
> +{
> +	return ioread32(priv->base + reg);
> +}
> +
> +static void rcsi2_write(struct rcar_csi2 *priv, unsigned int reg, u32 da=
ta)
> +{
> +	iowrite32(data, priv->base + reg);
> +}
> +
> +static void rcsi2_reset(struct rcar_csi2 *priv)
> +{
> +	rcsi2_write(priv, SRST_REG, SRST_SRST);
> +	usleep_range(100, 150);
> +	rcsi2_write(priv, SRST_REG, 0);
> +}
> +
> +static int rcsi2_wait_phy_start(struct rcar_csi2 *priv)
> +{
> +	int timeout;
> +
> +	/* Wait for the clock and data lanes to enter LP-11 state. */
> +	for (timeout =3D 100; timeout > 0; timeout--) {
> +		const u32 lane_mask =3D (1 << priv->lanes) - 1;
> +
> +		if ((rcsi2_read(priv, PHCLM_REG) & PHCLM_STOPSTATECKL)  &&
> +		    (rcsi2_read(priv, PHDLM_REG) & lane_mask) =3D=3D lane_mask)
> +			return 0;
> +
> +		msleep(20);
> +	}
> +
> +	dev_err(priv->dev, "Timeout waiting for LP-11 state\n");
> +
> +	return -ETIMEDOUT;
> +}
> +
> +static int rcsi2_set_phypll(struct rcar_csi2 *priv, unsigned int mbps)
> +{
> +	const struct phypll_hsfreqrange *hsfreq;
> +
> +	for (hsfreq =3D priv->info->hsfreqrange; hsfreq->mbps !=3D 0; hsfreq++)
> +		if (hsfreq->mbps >=3D mbps)
> +			break;
> +
> +	if (!hsfreq->mbps) {
> +		dev_err(priv->dev, "Unsupported PHY speed (%u Mbps)", mbps);
> +		return -ERANGE;
> +	}
> +
> +	dev_dbg(priv->dev, "PHY HSFREQRANGE requested %u got %u Mbps\n", mbps,
> +		hsfreq->mbps);
> +
> +	rcsi2_write(priv, PHYPLL_REG, PHYPLL_HSFREQRANGE(hsfreq->reg));
> +
> +	return 0;
> +}
> +
> +static int rcsi2_calc_mbps(struct rcar_csi2 *priv, unsigned int bpp)
> +{
> +	struct v4l2_subdev *source;
> +	struct v4l2_ctrl *ctrl;
> +	u64 mbps;
> +
> +	if (!priv->remote)
> +		return -ENODEV;
> +
> +	source =3D priv->remote;
> +
> +	/* Read the pixel rate control from remote. */
> +	ctrl =3D v4l2_ctrl_find(source->ctrl_handler, V4L2_CID_PIXEL_RATE);
> +	if (!ctrl) {
> +		dev_err(priv->dev, "no pixel rate control in subdev %s\n",
> +			source->name);
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Calculate the phypll in mbps (from v4l2 documentation).
> +	 * link_freq =3D (pixel_rate * bits_per_sample) / (2 * nr_of_lanes)
> +	 * bps =3D link_freq * 2
> +	 */
> +	mbps =3D v4l2_ctrl_g_ctrl_int64(ctrl) * bpp;
> +	do_div(mbps, priv->lanes * 1000000);
> +
> +	return mbps;
> +}
> +
> +static int rcsi2_start(struct rcar_csi2 *priv)
> +{
> +	const struct rcar_csi2_format *format;
> +	u32 phycnt, vcdt =3D 0, vcdt2 =3D 0;
> +	unsigned int i;
> +	int mbps, ret;
> +
> +	dev_dbg(priv->dev, "Input size (%ux%u%c)\n",
> +		priv->mf.width, priv->mf.height,
> +		priv->mf.field =3D=3D V4L2_FIELD_NONE ? 'p' : 'i');
> +
> +	/* Code is validated in set_fmt. */
> +	format =3D rcsi2_code_to_fmt(priv->mf.code);
> +
> +	/*
> +	 * Enable all Virtual Channels.
> +	 *
> +	 * NOTE: It's not possible to get individual datatype for each
> +	 *       source virtual channel. Once this is possible in V4L2
> +	 *       it should be used here.
> +	 */
> +	for (i =3D 0; i < 4; i++) {
> +		u32 vcdt_part;
> +
> +		vcdt_part =3D VCDT_SEL_VC(i) | VCDT_VCDTN_EN | VCDT_SEL_DTN_ON |
> +			VCDT_SEL_DT(format->datatype);
> +
> +		/* Store in correct reg and offset. */
> +		if (i < 2)
> +			vcdt |=3D vcdt_part << ((i % 2) * 16);
> +		else
> +			vcdt2 |=3D vcdt_part << ((i % 2) * 16);
> +	}
> +
> +	phycnt =3D PHYCNT_ENABLECLK;
> +	phycnt |=3D (1 << priv->lanes) - 1;
> +
> +	mbps =3D rcsi2_calc_mbps(priv, format->bpp);
> +	if (mbps < 0)
> +		return mbps;
> +
> +	/* Init */
> +	rcsi2_write(priv, TREF_REG, TREF_TREF);
> +	rcsi2_reset(priv);
> +	rcsi2_write(priv, PHTC_REG, 0);
> +
> +	/* Configure */
> +	rcsi2_write(priv, FLD_REG, FLD_FLD_NUM(2) | FLD_FLD_EN4 |
> +		    FLD_FLD_EN3 | FLD_FLD_EN2 | FLD_FLD_EN);

I see this has changed from datasheet v.80 to v1.00 and the FLD_ENn
bits have to be kept to 0 if capturing a pogressive image. This was
not clearly stated in previous datasheet version, and you are setting
those bits unconditionally here.

Thanks
   j

> +	rcsi2_write(priv, VCDT_REG, vcdt);
> +	rcsi2_write(priv, VCDT2_REG, vcdt2);
> +	/* Lanes are zero indexed. */
> +	rcsi2_write(priv, LSWAP_REG,
> +		    LSWAP_L0SEL(priv->lane_swap[0] - 1) |
> +		    LSWAP_L1SEL(priv->lane_swap[1] - 1) |
> +		    LSWAP_L2SEL(priv->lane_swap[2] - 1) |
> +		    LSWAP_L3SEL(priv->lane_swap[3] - 1));
> +
> +	/* Start */
> +	if (priv->info->init_phtw) {
> +		ret =3D priv->info->init_phtw(priv, mbps);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (priv->info->hsfreqrange) {
> +		ret =3D rcsi2_set_phypll(priv, mbps);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (priv->info->csi0clkfreqrange)
> +		rcsi2_write(priv, CSI0CLKFCPR_REG,
> +			    CSI0CLKFREQRANGE(priv->info->csi0clkfreqrange));
> +
> +	rcsi2_write(priv, PHYCNT_REG, phycnt);
> +	rcsi2_write(priv, LINKCNT_REG, LINKCNT_MONITOR_EN |
> +		    LINKCNT_REG_MONI_PACT_EN | LINKCNT_ICLK_NONSTOP);
> +	rcsi2_write(priv, PHYCNT_REG, phycnt | PHYCNT_SHUTDOWNZ);
> +	rcsi2_write(priv, PHYCNT_REG, phycnt | PHYCNT_SHUTDOWNZ | PHYCNT_RSTZ);
> +
> +	ret =3D rcsi2_wait_phy_start(priv);
> +	if (ret)
> +		return ret;
> +
> +	/* Clear Ultra Low Power interrupt. */
> +	if (priv->info->clear_ulps)
> +		rcsi2_write(priv, INTSTATE_REG,
> +			    INTSTATE_INT_ULPS_START |
> +			    INTSTATE_INT_ULPS_END);
> +	return 0;
> +}
> +
> +static void rcsi2_stop(struct rcar_csi2 *priv)
> +{
> +	rcsi2_write(priv, PHYCNT_REG, 0);
> +
> +	rcsi2_reset(priv);
> +
> +	rcsi2_write(priv, PHTC_REG, PHTC_TESTCLR);
> +}
> +
> +static int rcsi2_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct rcar_csi2 *priv =3D sd_to_csi2(sd);
> +	struct v4l2_subdev *nextsd;
> +	int ret =3D 0;
> +
> +	mutex_lock(&priv->lock);
> +
> +	if (!priv->remote) {
> +		ret =3D -ENODEV;
> +		goto out;
> +	}
> +
> +	nextsd =3D priv->remote;
> +
> +	if (enable && priv->stream_count =3D=3D 0) {
> +		pm_runtime_get_sync(priv->dev);
> +
> +		ret =3D rcsi2_start(priv);
> +		if (ret) {
> +			pm_runtime_put(priv->dev);
> +			goto out;
> +		}
> +
> +		ret =3D v4l2_subdev_call(nextsd, video, s_stream, 1);
> +		if (ret) {
> +			rcsi2_stop(priv);
> +			pm_runtime_put(priv->dev);
> +			goto out;
> +		}
> +	} else if (!enable && priv->stream_count =3D=3D 1) {
> +		rcsi2_stop(priv);
> +		v4l2_subdev_call(nextsd, video, s_stream, 0);
> +		pm_runtime_put(priv->dev);
> +	}
> +
> +	priv->stream_count +=3D enable ? 1 : -1;
> +out:
> +	mutex_unlock(&priv->lock);
> +
> +	return ret;
> +}
> +
> +static int rcsi2_set_pad_format(struct v4l2_subdev *sd,
> +				struct v4l2_subdev_pad_config *cfg,
> +				struct v4l2_subdev_format *format)
> +{
> +	struct rcar_csi2 *priv =3D sd_to_csi2(sd);
> +	struct v4l2_mbus_framefmt *framefmt;
> +
> +	if (!rcsi2_code_to_fmt(format->format.code))
> +		return -EINVAL;
> +
> +	if (format->which =3D=3D V4L2_SUBDEV_FORMAT_ACTIVE) {
> +		priv->mf =3D format->format;
> +	} else {
> +		framefmt =3D v4l2_subdev_get_try_format(sd, cfg, 0);
> +		*framefmt =3D format->format;
> +	}
> +
> +	return 0;
> +}
> +
> +static int rcsi2_get_pad_format(struct v4l2_subdev *sd,
> +				struct v4l2_subdev_pad_config *cfg,
> +				struct v4l2_subdev_format *format)
> +{
> +	struct rcar_csi2 *priv =3D sd_to_csi2(sd);
> +
> +	if (format->which =3D=3D V4L2_SUBDEV_FORMAT_ACTIVE)
> +		format->format =3D priv->mf;
> +	else
> +		format->format =3D *v4l2_subdev_get_try_format(sd, cfg, 0);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_video_ops rcar_csi2_video_ops =3D {
> +	.s_stream =3D rcsi2_s_stream,
> +};
> +
> +static const struct v4l2_subdev_pad_ops rcar_csi2_pad_ops =3D {
> +	.set_fmt =3D rcsi2_set_pad_format,
> +	.get_fmt =3D rcsi2_get_pad_format,
> +};
> +
> +static const struct v4l2_subdev_ops rcar_csi2_subdev_ops =3D {
> +	.video	=3D &rcar_csi2_video_ops,
> +	.pad	=3D &rcar_csi2_pad_ops,
> +};
> +
> +/* ---------------------------------------------------------------------=
--------
> + * Async handling and registration of subdevices and links.
> + */
> +
> +static int rcsi2_notify_bound(struct v4l2_async_notifier *notifier,
> +			      struct v4l2_subdev *subdev,
> +			      struct v4l2_async_subdev *asd)
> +{
> +	struct rcar_csi2 *priv =3D notifier_to_csi2(notifier);
> +	int pad;
> +
> +	pad =3D media_entity_get_fwnode_pad(&subdev->entity, asd->match.fwnode,
> +					  MEDIA_PAD_FL_SOURCE);
> +	if (pad < 0) {
> +		dev_err(priv->dev, "Failed to find pad for %s\n", subdev->name);
> +		return pad;
> +	}
> +
> +	priv->remote =3D subdev;
> +
> +	dev_dbg(priv->dev, "Bound %s pad: %d\n", subdev->name, pad);
> +
> +	return media_create_pad_link(&subdev->entity, pad,
> +				     &priv->subdev.entity, 0,
> +				     MEDIA_LNK_FL_ENABLED |
> +				     MEDIA_LNK_FL_IMMUTABLE);
> +}
> +
> +static void rcsi2_notify_unbind(struct v4l2_async_notifier *notifier,
> +				struct v4l2_subdev *subdev,
> +				struct v4l2_async_subdev *asd)
> +{
> +	struct rcar_csi2 *priv =3D notifier_to_csi2(notifier);
> +
> +	priv->remote =3D NULL;
> +
> +	dev_dbg(priv->dev, "Unbind %s\n", subdev->name);
> +}
> +
> +static const struct v4l2_async_notifier_operations rcar_csi2_notify_ops =
=3D {
> +	.bound =3D rcsi2_notify_bound,
> +	.unbind =3D rcsi2_notify_unbind,
> +};
> +
> +static int rcsi2_parse_v4l2(struct rcar_csi2 *priv,
> +			    struct v4l2_fwnode_endpoint *vep)
> +{
> +	unsigned int i;
> +
> +	/* Only port 0 endpoint 0 is valid. */
> +	if (vep->base.port || vep->base.id)
> +		return -ENOTCONN;
> +
> +	if (vep->bus_type !=3D V4L2_MBUS_CSI2) {
> +		dev_err(priv->dev, "Unsupported bus: %u\n", vep->bus_type);
> +		return -EINVAL;
> +	}
> +
> +	priv->lanes =3D vep->bus.mipi_csi2.num_data_lanes;
> +	if (priv->lanes !=3D 1 && priv->lanes !=3D 2 && priv->lanes !=3D 4) {
> +		dev_err(priv->dev, "Unsupported number of data-lanes: %u\n",
> +			priv->lanes);
> +		return -EINVAL;
> +	}
> +
> +	for (i =3D 0; i < ARRAY_SIZE(priv->lane_swap); i++) {
> +		priv->lane_swap[i] =3D i < priv->lanes ?
> +			vep->bus.mipi_csi2.data_lanes[i] : i;
> +
> +		/* Check for valid lane number. */
> +		if (priv->lane_swap[i] < 1 || priv->lane_swap[i] > 4) {
> +			dev_err(priv->dev, "data-lanes must be in 1-4 range\n");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int rcsi2_parse_dt(struct rcar_csi2 *priv)
> +{
> +	struct device_node *ep;
> +	struct v4l2_fwnode_endpoint v4l2_ep;
> +	int ret;
> +
> +	ep =3D of_graph_get_endpoint_by_regs(priv->dev->of_node, 0, 0);

> +	if (!ep) {
> +		dev_err(priv->dev, "Not connected to subdevice\n");
> +		return -EINVAL;
> +	}
> +
> +	ret =3D v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &v4l2_ep);
> +	if (ret) {
> +		dev_err(priv->dev, "Could not parse v4l2 endpoint\n");
> +		of_node_put(ep);
> +		return -EINVAL;
> +	}
> +
> +	ret =3D rcsi2_parse_v4l2(priv, &v4l2_ep);
> +	if (ret) {
> +		of_node_put(ep);
> +		return ret;
> +	}
> +
> +	priv->asd.match.fwnode =3D
> +		fwnode_graph_get_remote_endpoint(of_fwnode_handle(ep));
> +	priv->asd.match_type =3D V4L2_ASYNC_MATCH_FWNODE;
> +
> +	of_node_put(ep);
> +
> +	priv->notifier.subdevs =3D devm_kzalloc(priv->dev,
> +					      sizeof(*priv->notifier.subdevs),
> +					      GFP_KERNEL);
> +	if (!priv->notifier.subdevs)
> +		return -ENOMEM;
> +
> +	priv->notifier.num_subdevs =3D 1;
> +	priv->notifier.subdevs[0] =3D &priv->asd;
> +	priv->notifier.ops =3D &rcar_csi2_notify_ops;
> +
> +	dev_dbg(priv->dev, "Found '%pOF'\n",
> +		to_of_node(priv->asd.match.fwnode));
> +
> +	return v4l2_async_subdev_notifier_register(&priv->subdev,
> +						   &priv->notifier);
> +}
> +
> +/* ---------------------------------------------------------------------=
--------
> + * PHTW unitizing sequences.
> + *
> + * NOTE: Magic values are from the datasheet and lack documentation.
> + */
> +
> +static int rcsi2_phtw_write(struct rcar_csi2 *priv, u16 data, u16 code)
> +{
> +	unsigned int timeout;
> +
> +	rcsi2_write(priv, PHTW_REG,
> +		    PHTW_DWEN | PHTW_TESTDIN_DATA(data) |
> +		    PHTW_CWEN | PHTW_TESTDIN_CODE(code));
> +
> +	/* Wait for DWEN and CWEN to be cleared by hardware. */
> +	for (timeout =3D 100; timeout > 0; timeout--) {
> +		if (!(rcsi2_read(priv, PHTW_REG) & (PHTW_DWEN | PHTW_CWEN)))
> +			return 0;
> +		msleep(20);
> +	}
> +
> +	dev_err(priv->dev, "Timeout waiting for PHTW_DWEN and/or PHTW_CWEN\n");
> +
> +	return -ETIMEDOUT;
> +}
> +
> +static int rcsi2_phtw_write_array(struct rcar_csi2 *priv,
> +				  const struct phtw_value *values)
> +{
> +	const struct phtw_value *value;
> +	int ret;
> +
> +	for (value =3D values; (value->data || value->code); value++) {
> +		ret =3D rcsi2_phtw_write(priv, value->data, value->code);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int rcsi2_phtw_write_mbps(struct rcar_csi2 *priv, unsigned int mb=
ps,
> +				 const struct phtw_mbps *values, u16 code)
> +{
> +	const struct phtw_mbps *value;
> +
> +	for (value =3D values; value->mbps; value++)
> +		if (value->mbps >=3D mbps)
> +			break;
> +
> +	if (!value->mbps) {
> +		dev_err(priv->dev, "Unsupported PHY speed (%u Mbps)", mbps);
> +		return -ERANGE;
> +	}
> +
> +	dev_dbg(priv->dev, "PHTW requested %u got %u Mbps\n", mbps,
> +		value->mbps);
> +
> +	return rcsi2_phtw_write(priv, value->data, code);
> +}
> +
> +static int rcsi2_init_phtw_h3_v3h_m3n(struct rcar_csi2 *priv, unsigned i=
nt mbps)
> +{
> +	static const struct phtw_value step1[] =3D {
> +		{ .data =3D 0xcc, .code =3D 0xe2 },
> +		{ .data =3D 0x01, .code =3D 0xe3 },
> +		{ .data =3D 0x11, .code =3D 0xe4 },
> +		{ .data =3D 0x01, .code =3D 0xe5 },
> +		{ .data =3D 0x10, .code =3D 0x04 },
> +		{ /* sentinel */ },
> +	};
> +
> +	static const struct phtw_value step2[] =3D {
> +		{ .data =3D 0x38, .code =3D 0x08 },
> +		{ .data =3D 0x01, .code =3D 0x00 },
> +		{ .data =3D 0x4b, .code =3D 0xac },
> +		{ .data =3D 0x03, .code =3D 0x00 },
> +		{ .data =3D 0x80, .code =3D 0x07 },
> +		{ /* sentinel */ },
> +	};
> +
> +	int ret;
> +
> +	ret =3D rcsi2_phtw_write_array(priv, step1);
> +	if (ret)
> +		return ret;
> +
> +	if (mbps <=3D 250) {
> +		ret =3D rcsi2_phtw_write(priv, 0x39, 0x05);
> +		if (ret)
> +			return ret;
> +
> +		ret =3D rcsi2_phtw_write_mbps(priv, mbps, phtw_mbps_h3_v3h_m3n,
> +					    0xf1);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return rcsi2_phtw_write_array(priv, step2);
> +}
> +
> +static int rcsi2_init_phtw_v3m_e3(struct rcar_csi2 *priv, unsigned int m=
bps)
> +{
> +	static const struct phtw_value step1[] =3D {
> +		{ .data =3D 0xed, .code =3D 0x34 },
> +		{ .data =3D 0xed, .code =3D 0x44 },
> +		{ .data =3D 0xed, .code =3D 0x54 },
> +		{ .data =3D 0xed, .code =3D 0x84 },
> +		{ .data =3D 0xed, .code =3D 0x94 },
> +		{ /* sentinel */ },
> +	};
> +
> +	int ret;
> +
> +	ret =3D rcsi2_phtw_write_mbps(priv, mbps, phtw_mbps_v3m_e3, 0x44);
> +	if (ret)
> +		return ret;
> +
> +	return rcsi2_phtw_write_array(priv, step1);
> +}
> +
> +/* ---------------------------------------------------------------------=
--------
> + * Platform Device Driver.
> + */
> +
> +static const struct media_entity_operations rcar_csi2_entity_ops =3D {
> +	.link_validate =3D v4l2_subdev_link_validate,
> +};
> +
> +static int rcsi2_probe_resources(struct rcar_csi2 *priv,
> +				 struct platform_device *pdev)
> +{
> +	struct resource *res;
> +	int irq;
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	priv->base =3D devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(priv->base))
> +		return PTR_ERR(priv->base);
> +
> +	irq =3D platform_get_irq(pdev, 0);
> +	if (irq < 0)
> +		return irq;
> +
> +	return 0;
> +}
> +
> +static const struct rcar_csi2_info rcar_csi2_info_r8a7795 =3D {
> +	.init_phtw =3D rcsi2_init_phtw_h3_v3h_m3n,
> +	.hsfreqrange =3D hsfreqrange_h3_v3h_m3n,
> +	.csi0clkfreqrange =3D 0x20,
> +	.clear_ulps =3D true,
> +};
> +
> +static const struct rcar_csi2_info rcar_csi2_info_r8a7795es1 =3D {
> +	.hsfreqrange =3D hsfreqrange_m3w_h3es1,
> +};
> +
> +static const struct rcar_csi2_info rcar_csi2_info_r8a7796 =3D {
> +	.hsfreqrange =3D hsfreqrange_m3w_h3es1,
> +};
> +
> +static const struct rcar_csi2_info rcar_csi2_info_r8a77965 =3D {
> +	.init_phtw =3D rcsi2_init_phtw_h3_v3h_m3n,
> +	.hsfreqrange =3D hsfreqrange_h3_v3h_m3n,
> +	.csi0clkfreqrange =3D 0x20,
> +	.clear_ulps =3D true,
> +};
> +
> +static const struct rcar_csi2_info rcar_csi2_info_r8a77970 =3D {
> +	.init_phtw =3D rcsi2_init_phtw_v3m_e3,
> +};
> +
> +static const struct of_device_id rcar_csi2_of_table[] =3D {
> +	{
> +		.compatible =3D "renesas,r8a7795-csi2",
> +		.data =3D &rcar_csi2_info_r8a7795,
> +	},
> +	{
> +		.compatible =3D "renesas,r8a7796-csi2",
> +		.data =3D &rcar_csi2_info_r8a7796,
> +	},
> +	{
> +		.compatible =3D "renesas,r8a77965-csi2",
> +		.data =3D &rcar_csi2_info_r8a77965,
> +	},
> +	{
> +		.compatible =3D "renesas,r8a77970-csi2",
> +		.data =3D &rcar_csi2_info_r8a77970,
> +	},
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, rcar_csi2_of_table);
> +
> +static const struct soc_device_attribute r8a7795es1[] =3D {
> +	{
> +		.soc_id =3D "r8a7795", .revision =3D "ES1.*",
> +		.data =3D &rcar_csi2_info_r8a7795es1,
> +	},
> +	{ /* sentinel */ },
> +};
> +
> +static int rcsi2_probe(struct platform_device *pdev)
> +{
> +	const struct soc_device_attribute *attr;
> +	struct rcar_csi2 *priv;
> +	unsigned int i;
> +	int ret;
> +
> +	priv =3D devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	priv->info =3D of_device_get_match_data(&pdev->dev);
> +
> +	/*
> +	 * r8a7795 ES1.x behaves differently than the ES2.0+ but doesn't
> +	 * have it's own compatible string.
> +	 */
> +	attr =3D soc_device_match(r8a7795es1);
> +	if (attr)
> +		priv->info =3D attr->data;
> +
> +	priv->dev =3D &pdev->dev;
> +
> +	mutex_init(&priv->lock);
> +	priv->stream_count =3D 0;
> +
> +	ret =3D rcsi2_probe_resources(priv, pdev);
> +	if (ret) {
> +		dev_err(priv->dev, "Failed to get resources\n");
> +		return ret;
> +	}
> +
> +	platform_set_drvdata(pdev, priv);
> +
> +	ret =3D rcsi2_parse_dt(priv);
> +	if (ret)
> +		return ret;
> +
> +	priv->subdev.owner =3D THIS_MODULE;
> +	priv->subdev.dev =3D &pdev->dev;
> +	v4l2_subdev_init(&priv->subdev, &rcar_csi2_subdev_ops);
> +	v4l2_set_subdevdata(&priv->subdev, &pdev->dev);
> +	snprintf(priv->subdev.name, V4L2_SUBDEV_NAME_SIZE, "%s %s",
> +		 KBUILD_MODNAME, dev_name(&pdev->dev));
> +	priv->subdev.flags =3D V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +	priv->subdev.entity.function =3D MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER;
> +	priv->subdev.entity.ops =3D &rcar_csi2_entity_ops;
> +
> +	priv->pads[RCAR_CSI2_SINK].flags =3D MEDIA_PAD_FL_SINK;
> +	for (i =3D RCAR_CSI2_SOURCE_VC0; i < NR_OF_RCAR_CSI2_PAD; i++)
> +		priv->pads[i].flags =3D MEDIA_PAD_FL_SOURCE;
> +
> +	ret =3D media_entity_pads_init(&priv->subdev.entity, NR_OF_RCAR_CSI2_PA=
D,
> +				     priv->pads);
> +	if (ret)
> +		goto error;
> +
> +	pm_runtime_enable(&pdev->dev);
> +
> +	ret =3D v4l2_async_register_subdev(&priv->subdev);
> +	if (ret < 0)
> +		goto error;
> +
> +	dev_info(priv->dev, "%d lanes found\n", priv->lanes);
> +
> +	return 0;
> +
> +error:
> +	v4l2_async_notifier_unregister(&priv->notifier);
> +	v4l2_async_notifier_cleanup(&priv->notifier);
> +
> +	return ret;
> +}
> +
> +static int rcsi2_remove(struct platform_device *pdev)
> +{
> +	struct rcar_csi2 *priv =3D platform_get_drvdata(pdev);
> +
> +	v4l2_async_notifier_unregister(&priv->notifier);
> +	v4l2_async_notifier_cleanup(&priv->notifier);
> +	v4l2_async_unregister_subdev(&priv->subdev);
> +
> +	pm_runtime_disable(&pdev->dev);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver __refdata rcar_csi2_pdrv =3D {
> +	.remove	=3D rcsi2_remove,
> +	.probe	=3D rcsi2_probe,
> +	.driver	=3D {
> +		.name	=3D "rcar-csi2",
> +		.of_match_table	=3D rcar_csi2_of_table,
> +	},
> +};
> +
> +module_platform_driver(rcar_csi2_pdrv);
> +
> +MODULE_AUTHOR("Niklas S=C3=B6derlund <niklas.soderlund@ragnatech.se>");
> +MODULE_DESCRIPTION("Renesas R-Car MIPI CSI-2 receiver");
> +MODULE_LICENSE("GPL");
> --
> 2.17.0
>

--XigHxYirkHk2Kxsx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa+YvIAAoJEHI0Bo8WoVY8KlsP/RcPmWpaikrLhjOLMf8+WEbE
6ICpv9NGAy6C1mljlNEFKr2gaGueVGOUOsIaFfRvJ8G++mdsNKmH+82V20ghsA1P
Pyapmc0yR5WKvsZk9YRthwlOzp6Tjt45FoBP6zuXdX7WvacJLYKfiz+Ou+uzAsMv
MC59d24zcFXF7IXf/qj+03mED9Uvt/7I0rA24qoUsUXucXLKCTSvlGNNl0SdybSV
gy+OE4UyD3Nnd+QQf3lKmhpr4x0/Bl/UxXlUnV+1QGx1fVFC9zn91B5n5OA6NLrm
w3vS3powST6k0Xh4zDK1tFih3jqU69Fvj08YYfx8zH+JnSNUnI6EQ7BswWE+rde/
4KoJgUr1YXhxvZ3HGN3qrbu102rLCSn1Le7YVVNmlngLpi3BSIB6YpJO2xkmlfyR
dFzWWeRnHXzz0ElxhHApZ2b0McfJgm/mr3B8wraKMKVnnZ8jMx3xzwyaoy+x0QtZ
2sDWPN8xb1YoSuk+473buT3BlbVIk2YQJTsH1g81raqhfDpkoe+yk2GGtA0WwF3F
vPX+yGU1ht8eTTW0KrPU8BVfm3/AGsYla2yqyNRPgYKGqbvt+5FCbrlVuZw5RfDM
awyKmOPWKmOFrWlznH774obKM48s2Tyu+5YXYLVYQroOoF+BNX+wnYN8Dw859BSg
Yn+qnWlaO6FemCU7ke95
=Ung7
-----END PGP SIGNATURE-----

--XigHxYirkHk2Kxsx--
