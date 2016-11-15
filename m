Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42570 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751359AbcKOTEd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 14:04:33 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCHv4] media: rcar-csi2: add Renesas R-Car MIPI CSI-2 driver
Date: Tue, 15 Nov 2016 21:04:39 +0200
Message-ID: <32874373.z2EyqD3k7H@avalon>
In-Reply-To: <20161112122911.19079-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161112122911.19079-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Saturday 12 Nov 2016 13:29:11 Niklas S=F6derlund wrote:
> A V4L2 driver for Renesas R-Car MIPI CSI-2 interface. The driver
> supports the rcar-vin driver on R-Car Gen3 SoCs where a separate driv=
er
> is needed to receive CSI-2.
>=20
> Driver is based on a prototype by Koji Matsuoka in the Renesas BSP.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
.se>
> ---
>=20
> Changes since v3:
> - Update DT binding documentation with input from Geert Uytterhoeven,=

>   thanks!
>=20
> Changes since v2:
> - Added media control pads as this is needed by the new rcar-vin driv=
er.
> - Update DT bindings after review comments and to add r8a7796 support=
.
> - Add get_fmt handler.
> - Fix media bus format error s/YUYV8/UYVY8/
>=20
> Changes since v1:
> - Drop dependency on a pad aware s_stream operation.
> - Use the DT bindings format "renesas,<soctype>-<device>", thanks Gee=
rt
>   for pointing this out.
>=20
>  .../devicetree/bindings/media/rcar-csi2.txt        | 116 ++++
>  drivers/media/platform/rcar-vin/Kconfig            |  11 +
>  drivers/media/platform/rcar-vin/Makefile           |   2 +
>  drivers/media/platform/rcar-vin/rcar-csi2.c        | 586 +++++++++++=
+++++++
>  4 files changed, 715 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/rcar-csi2=
.txt
>  create mode 100644 drivers/media/platform/rcar-vin/rcar-csi2.c
>=20
> diff --git a/Documentation/devicetree/bindings/media/rcar-csi2.txt
> b/Documentation/devicetree/bindings/media/rcar-csi2.txt new file mode=

> 100644
> index 0000000..a9788e3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/rcar-csi2.txt
> @@ -0,0 +1,116 @@
> +Renesas R-Car MIPI CSI-2
> +------------------------
> +
> +The rcar-csi2 device provides MIPI CSI-2 capabilities for the Renesa=
s R-Car
> +family of devices. It is to be used in conjunction with the R-Car VI=
N
> module, +which provides the video capture capabilities.
> +
> + - compatible: Must be one or more of the following
> +   - "renesas,r8a7795-csi2" for the R8A7795 device.
> +   - "renesas,r8a7796-csi2" for the R8A7796 device.
> +   - "renesas,rcar-gen3-csi2" for a generic R-Car Gen3 compatible de=
vice.
> +
> +   When compatible with a generic version nodes must list the
> +   SoC-specific version corresponding to the platform first
> +   followed by the generic version.
> +
> + - reg: the register base and size for the device registers
> + - interrupts: the interrupt for the device
> + - clocks: Reference to the parent clock
> +
> +The device node should contain two 'port' child nodes according to t=
he
> +bindings defined in Documentation/devicetree/bindings/media/
> +video-interfaces.txt. Port 0 should connect the node that is the vid=
eo
> +source for to the CSI-2. Port 1 should connect all the R-Car VIN
> +modules, which can make use of the CSI-2 module.
> +
> +- Port 0 - Video source
> +=09- Reg 0 - sub-node describing the endpoint that is the video sour=
ce
> +
> +- Port 1 - VIN instances
> +=09- Reg 0 - sub-node describing the endpoint that is VIN0
> +=09- Reg 1 - sub-node describing the endpoint that is VIN1
> +=09- Reg 2 - sub-node describing the endpoint that is VIN2
> +=09- Reg 3 - sub-node describing the endpoint that is VIN3
> +=09- Reg 4 - sub-node describing the endpoint that is VIN4
> +=09- Reg 5 - sub-node describing the endpoint that is VIN5
> +=09- Reg 6 - sub-node describing the endpoint that is VIN6
> +=09- Reg 7 - sub-node describing the endpoint that is VIN7
> +
> +Example:
> +
> +/* SoC properties */
> +
> +=09 csi20: csi2@fea80000 {
> +=09=09 compatible =3D "renesas,r8a7795-csi2";
> +=09=09 reg =3D <0 0xfea80000 0 0x10000>;
> +=09=09 interrupts =3D <0 184 IRQ_TYPE_LEVEL_HIGH>;
> +=09=09 clocks =3D <&cpg CPG_MOD 714>;
> +=09=09 power-domains =3D <&sysc R8A7796_PD_ALWAYS_ON>;
> +=09=09 status =3D "disabled";
> +
> +=09=09 ports {
> +=09=09=09 #address-cells =3D <1>;
> +=09=09=09 #size-cells =3D <0>;
> +
> +=09=09=09 port@1 {
> +=09=09=09=09 #address-cells =3D <1>;
> +=09=09=09=09 #size-cells =3D <0>;
> +
> +=09=09=09=09 reg =3D <1>;
> +
> +=09=09=09=09 csi20vin0: endpoint@0 {
> +=09=09=09=09=09 reg =3D <0>;
> +=09=09=09=09=09 remote-endpoint =3D <&vin0csi20>;
> +=09=09=09=09 };
> +=09=09=09=09 csi20vin1: endpoint@1 {
> +=09=09=09=09=09 reg =3D <1>;
> +=09=09=09=09=09 remote-endpoint =3D <&vin1csi20>;
> +=09=09=09=09 };
> +=09=09=09=09 csi20vin2: endpoint@2 {
> +=09=09=09=09=09 reg =3D <2>;
> +=09=09=09=09=09 remote-endpoint =3D <&vin2csi20>;
> +=09=09=09=09 };
> +=09=09=09=09 csi20vin3: endpoint@3 {
> +=09=09=09=09=09 reg =3D <3>;
> +=09=09=09=09=09 remote-endpoint =3D <&vin3csi20>;
> +=09=09=09=09 };
> +=09=09=09=09 csi20vin4: endpoint@4 {
> +=09=09=09=09=09 reg =3D <4>;
> +=09=09=09=09=09 remote-endpoint =3D <&vin4csi20>;
> +=09=09=09=09 };
> +=09=09=09=09 csi20vin5: endpoint@5 {
> +=09=09=09=09=09 reg =3D <5>;
> +=09=09=09=09=09 remote-endpoint =3D <&vin5csi20>;
> +=09=09=09=09 };
> +=09=09=09=09 csi20vin6: endpoint@6 {
> +=09=09=09=09=09 reg =3D <6>;
> +=09=09=09=09=09 remote-endpoint =3D <&vin6csi20>;
> +=09=09=09=09 };
> +=09=09=09=09 csi20vin7: endpoint@7 {
> +=09=09=09=09=09 reg =3D <7>;
> +=09=09=09=09=09 remote-endpoint =3D <&vin7csi20>;
> +=09=09=09=09 };
> +=09=09=09 };
> +=09=09 };
> +=09 };
> +
> +/* Board properties */
> +
> +=09&csi20 {
> +=09=09status =3D "okay";
> +
> +=09=09ports {
> +=09=09=09#address-cells =3D <1>;
> +=09=09=09#size-cells =3D <0>;
> +
> +=09=09=09port@0 {
> +=09=09=09=09reg =3D <0>;
> +=09=09=09=09csi20_in: endpoint@0 {
> +=09=09=09=09=09clock-lanes =3D <0>;
> +=09=09=09=09=09data-lanes =3D <1>;
> +=09=09=09=09=09remote-endpoint =3D <&adv7482_txb>;
> +=09=09=09=09};
> +=09=09=09};
> +=09=09};
> +=09};
> diff --git a/drivers/media/platform/rcar-vin/Kconfig
> b/drivers/media/platform/rcar-vin/Kconfig index 111d2a1..3606997 1006=
44
> --- a/drivers/media/platform/rcar-vin/Kconfig
> +++ b/drivers/media/platform/rcar-vin/Kconfig
> @@ -9,3 +9,14 @@ config VIDEO_RCAR_VIN
>=20
>  =09  To compile this driver as a module, choose M here: the
>  =09  module will be called rcar-vin.
> +
> +config VIDEO_RCAR_CSI2
> +=09tristate "R-Car MIPI CSI-2 Interface driver"

I would call this CSI-2 Receiver, as interface doesn't make it clear wh=
ether=20
we're talking about a receiver or a transmitter. A (supervised)=20
s/interface/receiver/ through the patch should do.

> +=09depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF
> +=09depends on ARCH_RENESAS || COMPILE_TEST
> +=09---help---
> +=09  Support for Renesas R-Car MIPI CSI-2 interface driver.
> +=09  Supports R-Car Gen3 SoCs.
> +
> +=09  To compile this driver as a module, choose M here: the
> +=09  module will be called rcar-csi2.
> diff --git a/drivers/media/platform/rcar-vin/Makefile
> b/drivers/media/platform/rcar-vin/Makefile index 48c5632..81a37f2 100=
644
> --- a/drivers/media/platform/rcar-vin/Makefile
> +++ b/drivers/media/platform/rcar-vin/Makefile
> @@ -1,3 +1,5 @@
>  rcar-vin-objs =3D rcar-core.o rcar-dma.o rcar-v4l2.o
>=20
>  obj-$(CONFIG_VIDEO_RCAR_VIN) +=3D rcar-vin.o
> +
> +obj-$(CONFIG_VIDEO_RCAR_CSI2) +=3D rcar-csi2.o

Nitpicking, I would keep these in alphabetical order (the same applies =
for=20
Kconfig actually). There's also no need for a blank line between the tw=
o.

> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c
> b/drivers/media/platform/rcar-vin/rcar-csi2.c new file mode 100644
> index 0000000..13eb78b
> --- /dev/null
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -0,0 +1,586 @@
> +/*
> + * Driver for Renesas R-Car MIPI CSI-2

CSI-2 Receiver

> + *
> + * Copyright (C) 2016 Renesas Electronics Corp.
> + *
> + * This program is free software; you can redistribute  it and/or mo=
dify it
> + * under  the terms of  the GNU General  Public License as published=
 by
> the
> + * Free Software Foundation;  either version 2 of the  License, or (=
at your
> + * option) any later version.
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +
> +#include <media/v4l2-of.h>
> +#include <media/v4l2-subdev.h>
> +
> +/* Register offsets */
> +#define TREF_REG=09=090x00 /* Control Timing Select */
> +#define SRST_REG=09=090x04 /* Software Reset */
> +#define PHYCNT_REG=09=090x08 /* PHY Operation Control */
> +#define CHKSUM_REG=09=090x0C /* Checksum Control */

Hex constants are usually lower case in the kernel.

> +#define VCDT_REG=09=090x10 /* Channel Data Type Select */
> +#define VCDT2_REG=09=090x14 /* Channel Data Type Select 2 */
> +#define FRDT_REG=09=090x18 /* Frame Data Type Select */
> +#define FLD_REG=09=09=090x1C /* Field Detection Control */
> +#define ASTBY_REG=09=090x20 /* Automatic Standby Control */
> +#define LNGDT0_REG=09=090x28 /* Long Data Type Setting 0 */
> +#define LNGDT1_REG=09=090x2C /* Long Data Type Setting 1 */
> +#define INTEN_REG=09=090x30 /* Interrupt Enable */
> +#define INTCLOSE_REG=09=090x34 /* Interrupt Source Mask */
> +#define INTSTATE_REG=09=090x38 /* Interrupt Status Monitor */
> +#define INTERRSTATE_REG=09=090x3C /* Interrupt Error Status Monitor=20=

*/
> +#define SHPDAT_REG=09=090x40 /* Short Packet Data */
> +#define SHPCNT_REG=09=090x44 /* Short Packet Count */
> +#define LINKCNT_REG=09=090x48 /* LINK Operation Control */
> +#define LSWAP_REG=09=090x4C /* Lane Swap */
> +#define PHTC_REG=09=090x58 /* PHY Test Interface Clear */
> +#define PHYPLL_REG=09=090x68 /* PHY Frequency Control */
> +#define PHEERM_REG=09=090x74 /* PHY ESC Error Monitor */
> +#define PHCLM_REG=09=090x78 /* PHY Clock Lane Monitor */
> +#define PHDLM_REG=09=090x7C /* PHY Data Lane Monitor */

I would have prefixed the register names (and bits below) with CSI2_ or=
=20
RCAR_CSI2_ to avoid name space clashes, but that's up to you.

> +/* Control Timing Select bits */
> +#define TREF_TREF=09=09=09(1 << 0)

Another matter of personal taste, I like having bits definitions right =
after=20
the register they're related to, it improves readability in my opinion =
(and=20
you won't need the comments before the bits).

> +
> +/* Software Reset bits */
> +#define SRST_SRST=09=09=09(1 << 0)
> +
> +/* PHY Operation Control bits */
> +#define PHYCNT_SHUTDOWNZ=09=09(1 << 17)
> +#define PHYCNT_RSTZ=09=09=09(1 << 16)
> +#define PHYCNT_ENABLECLK=09=09(1 << 4)
> +#define PHYCNT_ENABLE_3=09=09=09(1 << 3)
> +#define PHYCNT_ENABLE_2=09=09=09(1 << 2)
> +#define PHYCNT_ENABLE_1=09=09=09(1 << 1)
> +#define PHYCNT_ENABLE_0=09=09=09(1 << 0)
> +
> +/* Checksum Control bits */
> +#define CHKSUM_ECC_EN=09=09=09(1 << 1)
> +#define CHKSUM_CRC_EN=09=09=09(1 << 0)
> +
> +/*
> + * Channel Data Type Select bits
> + * VCDT[0-15]:  Channel 1 VCDT[16-31]:  Channel 2
> + * VCDT2[0-15]: Channel 3 VCDT2[16-31]: Channel 4
> + */
> +#define VCDT_VCDTN_EN=09=09=09(1 << 15)
> +#define VCDT_SEL_VC(n)=09=09=09((n & 0x3) << 8)

You should use (n) in case n is an expression, otherwise subtle macro s=
ide=20
effects can occur, which can be difficult to debug.

> +#define VCDT_SEL_DTN_ON=09=09=09(1 << 6)
> +#define VCDT_SEL_DT(n)=09=09=09((n & 0x1f) << 0)
> +
> +/* Field Detection Control bits */
> +#define FLD_FLD_NUM(n)=09=09=09((n & 0xff) << 16)
> +#define FLD_FLD_EN4=09=09=09(1 << 3)
> +#define FLD_FLD_EN3=09=09=09(1 << 2)
> +#define FLD_FLD_EN2=09=09=09(1 << 1)
> +#define FLD_FLD_EN=09=09=09(1 << 0)
> +
> +/* LINK Operation Control bits */
> +#define LINKCNT_MONITOR_EN=09=09(1 << 31)
> +#define LINKCNT_REG_MONI_PACT_EN=09(1 << 25)
> +#define LINKCNT_ICLK_NONSTOP=09=09(1 << 24)
> +
> +/* Lane Swap bits */
> +#define LSWAP_L3SEL(n)=09=09=09((n & 0x3) << 6)
> +#define LSWAP_L2SEL(n)=09=09=09((n & 0x3) << 4)
> +#define LSWAP_L1SEL(n)=09=09=09((n & 0x3) << 2)
> +#define LSWAP_L0SEL(n)=09=09=09((n & 0x3) << 0)
> +
> +/* PHY Test Interface Clear bits */
> +#define PHTC_TESTCLR=09=09=09(1 << 0)
> +
> +/* PHY Frequency Control bits */

I wonder who came up with those strange frequencies to register values=20=

mappings...

> +#define PHYPLL_HSFREQRANGE_80MBPS=09(0x00 << 16)
> +#define PHYPLL_HSFREQRANGE_90MBPS=09(0x10 << 16)
> +#define PHYPLL_HSFREQRANGE_100MBPS=09(0x20 << 16)
> +#define PHYPLL_HSFREQRANGE_110MBPS=09(0x30 << 16)
> +#define PHYPLL_HSFREQRANGE_120MBPS=09(0x01 << 16)
> +#define PHYPLL_HSFREQRANGE_130MBPS=09(0x11 << 16)
> +#define PHYPLL_HSFREQRANGE_140MBPS=09(0x21 << 16)
> +#define PHYPLL_HSFREQRANGE_150MBPS=09(0x31 << 16)
> +#define PHYPLL_HSFREQRANGE_160MBPS=09(0x02 << 16)
> +#define PHYPLL_HSFREQRANGE_170MBPS=09(0x12 << 16)
> +#define PHYPLL_HSFREQRANGE_180MBPS=09(0x22 << 16)
> +#define PHYPLL_HSFREQRANGE_190MBPS=09(0x32 << 16)
> +#define PHYPLL_HSFREQRANGE_205MBPS=09(0x03 << 16)
> +#define PHYPLL_HSFREQRANGE_220MBPS=09(0x13 << 16)
> +#define PHYPLL_HSFREQRANGE_235MBPS=09(0x23 << 16)
> +#define PHYPLL_HSFREQRANGE_250MBPS=09(0x33 << 16)
> +#define PHYPLL_HSFREQRANGE_275MBPS=09(0x04 << 16)
> +#define PHYPLL_HSFREQRANGE_300MBPS=09(0x14 << 16)
> +#define PHYPLL_HSFREQRANGE_325MBPS=09(0x05 << 16)
> +#define PHYPLL_HSFREQRANGE_350MBPS=09(0x15 << 16)
> +#define PHYPLL_HSFREQRANGE_400MBPS=09(0x25 << 16)
> +#define PHYPLL_HSFREQRANGE_450MBPS=09(0x06 << 16)
> +#define PHYPLL_HSFREQRANGE_500MBPS=09(0x16 << 16)
> +#define PHYPLL_HSFREQRANGE_550MBPS=09(0x07 << 16)
> +#define PHYPLL_HSFREQRANGE_600MBPS=09(0x17 << 16)
> +#define PHYPLL_HSFREQRANGE_650MBPS=09(0x08 << 16)
> +#define PHYPLL_HSFREQRANGE_700MBPS=09(0x18 << 16)
> +#define PHYPLL_HSFREQRANGE_750MBPS=09(0x09 << 16)
> +#define PHYPLL_HSFREQRANGE_800MBPS=09(0x19 << 16)
> +#define PHYPLL_HSFREQRANGE_850MBPS=09(0x29 << 16)
> +#define PHYPLL_HSFREQRANGE_900MBPS=09(0x39 << 16)
> +#define PHYPLL_HSFREQRANGE_950MBPS=09(0x0A << 16)
> +#define PHYPLL_HSFREQRANGE_1000MBPS=09(0x1A << 16)
> +#define PHYPLL_HSFREQRANGE_1050MBPS=09(0x2A << 16)
> +#define PHYPLL_HSFREQRANGE_1100MBPS=09(0x3A << 16)
> +#define PHYPLL_HSFREQRANGE_1150MBPS=09(0x0B << 16)
> +#define PHYPLL_HSFREQRANGE_1200MBPS=09(0x1B << 16)
> +#define PHYPLL_HSFREQRANGE_1250MBPS=09(0x2B << 16)
> +#define PHYPLL_HSFREQRANGE_1300MBPS=09(0x3B << 16)
> +#define PHYPLL_HSFREQRANGE_1350MBPS=09(0x0C << 16)
> +#define PHYPLL_HSFREQRANGE_1400MBPS=09(0x1C << 16)
> +#define PHYPLL_HSFREQRANGE_1450MBPS=09(0x2C << 16)
> +#define PHYPLL_HSFREQRANGE_1500MBPS=09(0x3C << 16)
> +
> +enum rcar_csi2_pads {
> +=09RCAR_CSI2_SINK,
> +=09RCAR_CSI2_SOURCE_VC0,
> +=09RCAR_CSI2_SOURCE_VC1,
> +=09RCAR_CSI2_SOURCE_VC2,
> +=09RCAR_CSI2_SOURCE_VC3,
> +=09RCAR_CSI2_PAD_MAX,
> +};
> +
> +struct rcar_csi2 {
> +=09struct device *dev;
> +=09void __iomem *base;
> +=09spinlock_t lock;

All locks should have a comment describing what they protect.

> +
> +=09unsigned short lanes;
> +=09unsigned char swap[4];

Maybe lane_swap ?

> +
> +=09struct v4l2_subdev subdev;
> +=09struct media_pad pads[RCAR_CSI2_PAD_MAX];
> +=09struct v4l2_mbus_framefmt mf;
> +};
> +
> +#define csi_dbg(p, fmt, arg...)=09=09dev_dbg(p->dev, fmt, ##arg)
> +#define csi_info(p, fmt, arg...)=09dev_info(p->dev, fmt, ##arg)
> +#define csi_warn(p, fmt, arg...)=09dev_warn(p->dev, fmt, ##arg)
> +#define csi_err(p, fmt, arg...)=09=09dev_err(p->dev, fmt, ##arg)

I wonder if these macros are really worth it, they only shorten lines b=
y 4=20
characters, but hide the fact that we use dev_*.

> +static irqreturn_t rcar_csi2_irq(int irq, void *data)
> +{
> +=09struct rcar_csi2 *priv =3D data;
> +=09u32 int_status;
> +=09unsigned int handled =3D 0;
> +
> +=09spin_lock(&priv->lock);
> +
> +=09int_status =3D ioread32(priv->base + INTSTATE_REG);

I'd create two functions to access registers:

static u32 rcar_csi2_read(struct rcar_csi2 *priv, unsigned int reg)
{
=09return ioread32(priv->base + reg);
}

static void rcar_csi2_write(struct rcar_csi2 *priv, unsigned int reg, u=
32=20
data)
{
=09iowrite32(data, priv->base + reg);
}

It would in my opinion improve readability and make it easy to log read=
 and=20
writes for debug purpose should the need arise.

> +=09if (!int_status)
> +=09=09goto done;
> +
> +=09/* ack interrupts */
> +=09iowrite32(int_status, priv->base + INTSTATE_REG);
> +=09handled =3D 1;

If you don't need to handle interrupts, how about not enabling them in =
the=20
first place ? :-) Keep it in the DT bindings though, and check in the p=
robe=20
function that it has been specified, in order to ensure that we'll be a=
ble to=20
use it later if needed.

> +done:
> +=09spin_unlock(&priv->lock);
> +
> +=09return IRQ_RETVAL(handled);
> +
> +}
> +
> +static void rcar_csi2_reset(struct rcar_csi2 *priv)
> +{
> +=09iowrite32(SRST_SRST, priv->base + SRST_REG);
> +=09udelay(5);

Is the delay really needed ? I see no mention of it in section 25.3.12 =
of the=20
datasheet.

> +=09iowrite32(0, priv->base + SRST_REG);
> +}
> +
> +static void rcar_csi2_wait_phy_start(struct rcar_csi2 *priv)
> +{
> +=09int timeout;
> +
> +=09/* Read the PHY clock lane monitor register (PHCLM). */
> +=09for (timeout =3D 100; timeout >=3D 0; timeout--) {
> +=09=09if (ioread32(priv->base + PHCLM_REG) & 0x01) {
> +=09=09=09csi_dbg(priv, "Detected the PHY clock lane\n");
> +=09=09=09break;
> +=09=09}
> +=09=09msleep(20);
> +=09}
> +=09if (!timeout)
> +=09=09csi_err(priv, "Timeout of reading the PHY clock lane\n");

Shouldn't this be a fatal error ?

> +
> +

Extra blank line.

> +=09/* Read the PHY data lane monitor register (PHDLM). */
> +=09for (timeout =3D 100; timeout >=3D 0; timeout--) {
> +=09=09if (ioread32(priv->base + PHDLM_REG) & 0x01) {

Shouldn't you take all used data lanes into account, not just lane 0 ?

> +=09=09=09csi_dbg(priv, "Detected the PHY data lane\n");
> +=09=09=09break;
> +=09=09}
> +=09=09msleep(20);
> +=09}
> +=09if (!timeout)
> +=09=09csi_err(priv, "Timeout of reading the PHY data lane\n");

And this too ?

> +

Extra blank line.

So this code waits for all data and clock lanes to enter LP-11 state. I=
'd=20
update the comments to make that clear. I would also possibly combine t=
he two=20
loops, as there's no real need to wait for the clock and data lanes=20
separately. Maybe something like

=09/* Wait for the clock and data lanes to enter LP-11 state. */
=09for (timeout =3D 100; timeout >=3D 0; timeout--) {
=09=09const u32 lane_mask =3D (1 << priv->lanes) - 1;

=09=09if ((rcar_csi2_read(priv, PHDLM_REG) & 1) =3D=3D 1 &&
=09=09    (rcar_csi2_read(priv, PHDLM_REG) & lane_mask) =3D=3D=20
lane_mask)
=09=09=09return 0;

=09=09msleep(20);
=09}

=09dev_err(priv->dev, "Timeout waiting for LP-11 state\n");
=09return -ETIMEDOUT;

Although if you prefer keeping them separate that's fine too, but the c=
omment=20
and error messages should be updated (you could also print which data l=
ane(s)=20
didn't switch to LP-11, that could be useful for debugging).

> +}
> +
> +static int rcar_csi2_start(struct rcar_csi2 *priv)
> +{
> +=09u32 fld, phycnt, phypll, vcdt, vcdt2, tmp, pixels;
> +=09int i;

unsigned int.

> +
> +=09csi_dbg(priv, "Input size (%dx%d%c)\n", priv->mf.width, priv-
>mf.height,
> +=09=09priv->mf.field =3D=3D V4L2_FIELD_NONE ? 'p' : 'i');
> +
> +=09vcdt =3D vcdt2 =3D 0;

You can initialize the variables when declaring them.

> +=09for (i =3D 0; i < priv->lanes; i++) {
> +=09=09tmp =3D VCDT_SEL_VC(i) | VCDT_VCDTN_EN | VCDT_SEL_DTN_ON;
> +
> +=09=09switch (priv->mf.code) {
> +=09=09case MEDIA_BUS_FMT_RGB888_1X24:
> +=09=09=09/* 24 =3D=3D RGB888 */
> +=09=09=09tmp |=3D 0x24;
> +=09=09=09break;
> +=09=09case MEDIA_BUS_FMT_UYVY8_1X16:
> +=09=09case MEDIA_BUS_FMT_UYVY8_2X8:
> +=09=09case MEDIA_BUS_FMT_YUYV10_2X10:
> +=09=09=09/* 1E =3D=3D YUV422 8-bit */
> +=09=09=09tmp |=3D 0x1e;
> +=09=09=09break;
> +=09=09default:
> +=09=09=09csi_warn(priv,
> +=09=09=09=09 "Unknown media bus format, try it anyway\n");
> +=09=09=09break;
> +=09=09}
> +
> +=09=09/* Store in correct reg and offset */
> +=09=09if (i < 2)
> +=09=09=09vcdt |=3D tmp << ((i % 2) * 16);
> +=09=09else
> +=09=09=09vcdt2 |=3D tmp << ((i % 2) * 16);

These settings are per channel (which I expect map to source pads), not=
 per=20
lane.

> +=09}
> +
> +=09switch (priv->lanes) {
> +=09case 1:
> +=09=09fld =3D FLD_FLD_NUM(1) | FLD_FLD_EN;

This has nothing to do with lanes either :-)

> +=09=09phycnt =3D PHYCNT_ENABLECLK | PHYCNT_ENABLE_0;
> +=09=09phypll =3D PHYPLL_HSFREQRANGE_400MBPS;
> +=09=09break;
> +=09case 4:
> +=09=09fld =3D FLD_FLD_NUM(2) | FLD_FLD_EN4 | FLD_FLD_EN3 |
> +=09=09=09FLD_FLD_EN2 | FLD_FLD_EN;
> +=09=09phycnt =3D PHYCNT_ENABLECLK | PHYCNT_ENABLE_3 |
> +=09=09=09PHYCNT_ENABLE_2 | PHYCNT_ENABLE_1 | PHYCNT_ENABLE_0;
> +
> +=09=09/* Calculate MBPS per lane, assume 32 bits per pixel at 60Hz=20=

*/
> +=09=09pixels =3D (priv->mf.width * priv->mf.height) /
> +=09=09=09(priv->mf.field =3D=3D V4L2_FIELD_NONE ? 1 : 2);
> +=09=09if (pixels <=3D 640 * 480)
> +=09=09=09phypll =3D PHYPLL_HSFREQRANGE_100MBPS;
> +=09=09else if (pixels <=3D 720 * 576)
> +=09=09=09phypll =3D PHYPLL_HSFREQRANGE_190MBPS;
> +=09=09else if (pixels <=3D 1280 * 720)
> +=09=09=09phypll =3D PHYPLL_HSFREQRANGE_450MBPS;
> +=09=09else if (pixels <=3D 1920 * 1080)
> +=09=09=09phypll =3D PHYPLL_HSFREQRANGE_900MBPS;
> +=09=09else
> +=09=09=09goto error;

That's a pretty bad heuristics as the bit rate doesn't depend on the im=
age=20
size only. You should instead query the information from the connected =
subdev=20
using the V4L2_CID_LINK_FREQ control (you will obviously have to implem=
ent the=20
control in the ADV7482 driver). See isp_video_check_external_subdevs() =
for an=20
example of how this is done with the V4L2_CID_PIXEL_RATE control. Note =
that=20
CSI-2 is a DDR bus, so the data rate per lane is twice the frequency.

You might want to tabulate the PLL register value for the input frequen=
cy=20
ranges instead of using a bit if ... else ..., especially given that th=
e=20
datasheet contains a table much larger than the above 4 values.

> +
> +=09=09break;
> +=09default:
> +=09=09goto error;
> +=09}
> +
> +=09/* Init */
> +=09iowrite32(TREF_TREF, priv->base + TREF_REG);
> +=09rcar_csi2_reset(priv);
> +=09iowrite32(0, priv->base + PHTC_REG);
> +
> +=09/* Configure */
> +=09iowrite32(fld, priv->base + FLD_REG);
> +=09iowrite32(vcdt, priv->base + VCDT_REG);
> +=09iowrite32(vcdt2, priv->base + VCDT2_REG);
> +=09iowrite32(LSWAP_L0SEL(priv->swap[0]) | LSWAP_L1SEL(priv->swap[1])=
 |
> +=09=09  LSWAP_L2SEL(priv->swap[2]) | LSWAP_L3SEL(priv->swap[3]),
> +=09=09  priv->base + LSWAP_REG);
> +
> +=09/* Start */
> +=09iowrite32(phypll, priv->base + PHYPLL_REG);
> +=09iowrite32(phycnt, priv->base + PHYCNT_REG);
> +=09iowrite32(LINKCNT_MONITOR_EN | LINKCNT_REG_MONI_PACT_EN |
> +=09=09  LINKCNT_ICLK_NONSTOP, priv->base + LINKCNT_REG);
> +=09iowrite32(phycnt | PHYCNT_SHUTDOWNZ, priv->base + PHYCNT_REG);
> +=09iowrite32(phycnt | PHYCNT_SHUTDOWNZ | PHYCNT_RSTZ,
> +=09=09  priv->base + PHYCNT_REG);
> +
> +=09rcar_csi2_wait_phy_start(priv);
> +
> +=09return 0;
> +error:
> +=09csi_err(priv, "Unsupported resolution (%dx%d%c)\n",
> +=09=09priv->mf.width, priv->mf.height,
> +=09=09priv->mf.field =3D=3D V4L2_FIELD_NONE ? 'p' : 'i');
> +
> +=09return -EINVAL;
> +}
> +
> +static void rcar_csi2_stop(struct rcar_csi2 *priv)
> +{
> +=09iowrite32(0, priv->base + PHYCNT_REG);
> +
> +=09rcar_csi2_reset(priv);
> +}
> +
> +static int rcar_csi2_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +=09struct rcar_csi2 *priv =3D container_of(sd, struct rcar_csi2, sub=
dev);

It's quite customary to create an inline function to do the conversion:=


static inline struct rcar_csi2 *to_csi2(struct v4l2_subdev *sd)
{
=09return container_of(sd, struct rcar_csi2, subdev);
}

and place it right after the structure definition.

> +
> +=09if (enable)
> +=09=09return rcar_csi2_start(priv);
> +
> +=09rcar_csi2_stop(priv);
> +
> +=09return 0;
> +}
> +
> +static int rcar_csi2_set_pad_format(struct v4l2_subdev *sd,
> +=09=09=09=09    struct v4l2_subdev_pad_config *cfg,
> +=09=09=09=09    struct v4l2_subdev_format *format)
> +{
> +=09struct rcar_csi2 *priv =3D container_of(sd, struct rcar_csi2, sub=
dev);
> +
> +=09if (format->pad !=3D RCAR_CSI2_SINK)
> +=09=09return -EINVAL;

Why is that ? The format on the sink pad should be configurable.

> +=09if (format->which =3D=3D V4L2_SUBDEV_FORMAT_ACTIVE)
> +=09=09priv->mf =3D format->format;

How about the V4L2_SUBDEV_FORMAT_ACTIVE formats ? You also need to vali=
date=20
the format here.

> +=09return 0;
> +}
> +
> +static int rcar_csi2_get_pad_format(struct v4l2_subdev *sd,
> +=09=09=09=09    struct v4l2_subdev_pad_config *cfg,
> +=09=09=09=09    struct v4l2_subdev_format *format)
> +{
> +=09struct rcar_csi2 *priv =3D container_of(sd, struct rcar_csi2, sub=
dev);
> +
> +=09if (format->pad !=3D RCAR_CSI2_SINK)
> +=09=09return -EINVAL;
> +
> +=09format->format =3D priv->mf;

Similar comments here as for the set format implementation.

> +=09return 0;
> +}
> +
> +static int rcar_csi2_s_power(struct v4l2_subdev *sd, int on)
> +{
> +=09struct rcar_csi2 *priv =3D container_of(sd, struct rcar_csi2, sub=
dev);
> +
> +=09if (on)
> +=09=09pm_runtime_get_sync(priv->dev);
> +=09else
> +=09=09pm_runtime_put_sync(priv->dev);

You can probably use pm_runtime_put().

> +=09return 0;
> +}
> +
> +static const struct v4l2_subdev_video_ops rcar_csi2_video_ops =3D {
> +=09.s_stream =3D rcar_csi2_s_stream,
> +};
> +
> +static struct v4l2_subdev_core_ops rcar_csi2_subdev_core_ops =3D {
> +=09.s_power =3D rcar_csi2_s_power,
> +};
> +
> +static const struct v4l2_subdev_pad_ops rcar_csi2_pad_ops =3D {
> +=09.set_fmt =3D rcar_csi2_set_pad_format,
> +=09.get_fmt =3D rcar_csi2_get_pad_format,
> +};
> +
> +static struct v4l2_subdev_ops rcar_csi2_subdev_ops =3D {
> +=09.video=09=3D &rcar_csi2_video_ops,
> +=09.core=09=3D &rcar_csi2_subdev_core_ops,
> +=09.pad=09=3D &rcar_csi2_pad_ops,
> +};
> +
> +/* -----------------------------------------------------------------=
-------
> + * Platform Device Driver
> + */
> +
> +static const struct of_device_id rcar_csi2_of_table[] =3D {
> +=09{ .compatible =3D "renesas,r8a7795-csi2" },
> +=09{ .compatible =3D "renesas,r8a7796-csi2" },

You don't need to list those two compatible strings explicitly, the gen=
eric=20
one will be enough.

> +=09{ .compatible =3D "renesas,rcar-gen3-csi2" },
> +=09{ },
> +};
> +MODULE_DEVICE_TABLE(of, rcar_csi2_of_table);
> +
> +static int rcar_csi2_parse_dt(struct rcar_csi2 *priv)
> +{
> +=09struct v4l2_of_endpoint v4l2_ep;
> +=09struct device_node *ep;
> +=09int i, n, ret;

i can be an unsigned int.

> +
> +=09ep =3D of_graph_get_endpoint_by_regs(priv->dev->of_node, 0, 0);
> +=09if (!ep)
> +=09=09return -EINVAL;
> +
> +=09ret =3D v4l2_of_parse_endpoint(ep, &v4l2_ep);
> +=09of_node_put(ep);
> +=09if (ret) {
> +=09=09csi_err(priv, "Could not parse v4l2 endpoint\n");
> +=09=09return -EINVAL;
> +=09}
> +
> +=09if (v4l2_ep.bus_type !=3D V4L2_MBUS_CSI2) {
> +=09=09csi_err(priv, "Unsupported media bus type for %s\n",
> +=09=09=09of_node_full_name(ep));
> +=09=09return -EINVAL;
> +=09}
> +
> +=09switch (v4l2_ep.bus.mipi_csi2.num_data_lanes) {
> +=09case 1:
> +=09case 4:
> +=09=09priv->lanes =3D v4l2_ep.bus.mipi_csi2.num_data_lanes;
> +=09=09break;
> +=09default:
> +=09=09csi_err(priv, "Unsupported number of lanes\n");

Shouldn't we also support the 2 lanes case ?

> +=09=09return -EINVAL;
> +=09}
> +
> +=09for (i =3D 0; i < 4; i++)
> +=09=09priv->swap[i] =3D i;

Is this needed given that your overwrite swap right below ?
> +
> +=09for (i =3D 0; i < priv->lanes; i++) {
> +=09=09/* Check for valid lane number */
> +=09=09if (v4l2_ep.bus.mipi_csi2.data_lanes[i] < 1 ||
> +=09=09    v4l2_ep.bus.mipi_csi2.data_lanes[i] > 4) {
> +=09=09=09csi_err(priv, "data lanes must be in 1-4 range\n");
> +=09=09=09return -EINVAL;
> +=09=09}
> +
> +=09=09/* Use lane numbers 0-3 internally */
> +=09=09priv->swap[i] =3D v4l2_ep.bus.mipi_csi2.data_lanes[i] - 1;
> +
> +

Extra blank lines.

> +=09}
> +
> +=09/* Make sure there are no duplicates */
> +=09for (i =3D 0; i < priv->lanes; i++) {
> +=09=09for (n =3D i + 1; n < priv->lanes; n++) {
> +=09=09=09if (priv->swap[i] =3D=3D priv->swap[n]) {
> +=09=09=09=09csi_err(priv,
> +=09=09=09=09=09"Requested swapping not possible\n");
> +=09=09=09=09return -EINVAL;
> +=09=09=09}
> +=09=09}
> +=09}

I believe it would make sense to move this code to v4l2_of_parse_endpoi=
nt().

> +
> +=09return 0;
> +}
> +
> +static int rcar_csi2_probe_resources(struct rcar_csi2 *priv,
> +=09=09=09=09     struct platform_device *pdev)
> +{
> +=09struct resource *mem;
> +=09int irq;
> +
> +=09mem =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +=09if (!mem)
> +=09=09return -ENODEV;
> +
> +=09priv->base =3D devm_ioremap_resource(&pdev->dev, mem);
> +=09if (IS_ERR(priv->base))
> +=09=09return PTR_ERR(priv->base);
> +
> +=09irq =3D platform_get_irq(pdev, 0);
> +=09if (!irq)
> +=09=09return -ENODEV;
> +
> +=09return devm_request_irq(&pdev->dev, irq, rcar_csi2_irq, IRQF_SHAR=
ED,
> +=09=09=09=09dev_name(&pdev->dev), priv);
> +}
> +
> +static int rcar_csi2_probe(struct platform_device *pdev)
> +{
> +=09struct rcar_csi2 *priv;
> +=09unsigned int i;
> +=09int ret;
> +
> +=09priv =3D devm_kzalloc(&pdev->dev, sizeof(struct rcar_csi2), GFP_K=
ERNEL);

sizeof(*priv)

> +=09if (!priv)
> +=09=09return -ENOMEM;
> +
> +

Extra blank line.

> +=09priv->dev =3D &pdev->dev;
> +=09spin_lock_init(&priv->lock);
> +
> +=09ret =3D rcar_csi2_parse_dt(priv);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09ret =3D rcar_csi2_probe_resources(priv, pdev);
> +=09if (ret) {
> +=09=09csi_err(priv, "Failed to get resources\n");
> +=09=09return ret;
> +=09}
> +
> +=09platform_set_drvdata(pdev, priv);
> +
> +=09priv->subdev.owner =3D THIS_MODULE;
> +=09priv->subdev.dev =3D &pdev->dev;
> +=09v4l2_subdev_init(&priv->subdev, &rcar_csi2_subdev_ops);
> +=09v4l2_set_subdevdata(&priv->subdev, &pdev->dev);
> +=09snprintf(priv->subdev.name, V4L2_SUBDEV_NAME_SIZE, "%s.%s",
> +=09=09 KBUILD_MODNAME, dev_name(&pdev->dev));
> +
> +=09priv->subdev.flags =3D V4L2_SUBDEV_FL_HAS_DEVNODE;
> +=09priv->subdev.entity.flags |=3D MEDIA_ENT_F_ATV_DECODER;

You probably need a new function, this isn't an analog TV decoder. Besi=
de=20
that, the field you want to initialize is priv->subdev.entity.function.=


> +=09priv->pads[RCAR_CSI2_SINK].flags =3D MEDIA_PAD_FL_SINK;
> +=09for (i =3D RCAR_CSI2_SOURCE_VC0; i < RCAR_CSI2_PAD_MAX; i++)
> +=09=09priv->pads[i].flags =3D MEDIA_PAD_FL_SOURCE;
> +
> +=09ret =3D media_entity_pads_init(&priv->subdev.entity, RCAR_CSI2_PA=
D_MAX,
> +=09=09=09=09     priv->pads);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09ret =3D v4l2_async_register_subdev(&priv->subdev);
> +=09if (ret < 0)
> +=09=09return ret;
> +
> +=09pm_runtime_enable(&pdev->dev);
> +
> +=09csi_info(priv, "%d lanes found\n", priv->lanes);
> +
> +=09return 0;
> +}

--=20
Regards,

Laurent Pinchart

