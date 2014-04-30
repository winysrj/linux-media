Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:49929 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaD3Dat (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Apr 2014 23:30:49 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N4T00KC7R3BVW70@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 29 Apr 2014 23:30:47 -0400 (EDT)
Date: Tue, 29 Apr 2014 20:30:44 -0700
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: =?UTF-8?B?0JDQu9C10LrRgdCw0L3QtNGAINCR0LXRgNGB0LXQvdC10LI=?=
	<bay@hackerdom.ru>, linux-sunxi@googlegroups.com,
	rdunlap@infradead.org, ijc+devicetree@hellion.org.uk,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v3] sunxi: Add support for consumer infrared devices
Message-id: <20140429203044.332f4e4c.m.chehab@samsung.com>
In-reply-to: <20140430011454.GB3000@lukather>
References: <64a9c1e2-4db7-4486-841f-11adde303e32@googlegroups.com>
 <20140430011454.GB3000@lukather>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/AM+il/D_DoGOPbfq8bQ30I="; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/AM+il/D_DoGOPbfq8bQ30I=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Em Tue, 29 Apr 2014 18:14:54 -0700
Maxime Ripard <maxime.ripard@free-electrons.com> escreveu:

> Hi,
>=20
> Thanks for contributing this patch.
>=20
> It seems like you're missing a few mailing lists / maintainers
> though. You should use the get_maintainer.pl script, and Cc every
> maintainer and mailing lists in there.
>=20
> On Tue, Apr 29, 2014 at 02:51:31PM -0700, =D0=90=D0=BB=D0=B5=D0=BA=D1=81=
=D0=B0=D0=BD=D0=B4=D1=80 =D0=91=D0=B5=D1=80=D1=81=D0=B5=D0=BD=D0=B5=D0=B2 w=
rote:
> > This patch introduces Consumer IR(CIR) support for sunxi boards.
> >=20
> > This is based on Alexsey Shestacov's work based on the original driver=
=20
> > supplied by Allwinner.=20
>=20
> Your Signed-off-by should be here so that it stays in the commit log,
> and not discarded.
>=20
> Note that you can use git commit -s to make sure it's at the right
> place.
>=20
> > ---=20
> >=20
> > Changes since version 1:=20
> >  - Fix timer memory leaks=20
> >  - Fix race condition when driver unloads while interrupt handler is ac=
tive
> >  - Support Cubieboard 2(need testing)
> >=20
> >  Changes since version 2:
> >  - More reliable keydown events
> >  - Documentation fixes
> >  - Rename registers accurding to A20 user manual
> >  - Remove some includes, order includes alphabetically
> >  - Use BIT macro
> >  - Typo fixes
> >=20
> > Signed-off-by: Alexander Bersenev <bay@hackerdom.ru>=20
> > Signed-off-by: Alexsey Shestacov <wingrime@linux-sunxi.org> =20
> >=20
> > diff --git a/Documentation/devicetree/bindings/media/sunxi-ir.txt=20
> > b/Documentation/devicetree/bindings/media/sunxi-ir.txt
> > new file mode 100644
> > index 0000000..0d416f4
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/sunxi-ir.txt
> > @@ -0,0 +1,21 @@
> > +Device-Tree bindings for SUNXI IR controller found in sunXi SoC family
> > +
> > +Required properties:
> > +       - compatible: Should be "allwinner,sunxi-ir".
>=20
> We prefer to use "allwinner,<family>-<soc>-<device>", with the soc and
> family being the one where it was first introduced. If this controller
> is the same in A10 and A20, it should be "allwinner,sun4i-a10-ir", if
> it is a new controller in the A20, "allwinner,sun7i-a20-ir".
>=20
> > +       - clocks: First clock should contain SoC gate for IR clock.
> > +                 Second should contain IR feed clock itself.
>=20
> Whenever there's several clocks, using clock-names is to be
> preferred. That way, you don't have to request any order, which is a
> lot less error prone.
>=20
> > +       - interrupts: Should contain IR IRQ number.
> > +       - reg: Should contain IO map address for IR.
> > +
> > +Optional properties:
> > +       - linux,rc-map-name: Remote control map name.
> > +
> > +Example:
> > +
> > +       ir0: ir@01c21800 {
> > +            compatible =3D "allwinner,sunxi-ir";
> > +            clocks =3D <&apb0_gates 6>, <&ir0_clk>;
> > +            interrupts =3D <0 5 1>;
> > +            reg =3D <0x01C21800 0x40>;
> > +            linux,rc-map-name =3D "rc-rc6-mce";
> > +       };
> > diff --git a/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts=20
> > b/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
> > index feeff64..01b519c 100644
> > --- a/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
> > +++ b/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
> > @@ -164,6 +164,13 @@
> >   reg =3D <1>;
> >   };
> >   };
> > +
> > + ir0: ir@01c21800 {
> > + pinctrl-names =3D "default";
> > + pinctrl-0 =3D <&ir0_pins_a>;
> > + gpios =3D <&pio 1 4 0>;
>=20
> You don't seem to be using that gpios property anywhere.
>=20
> Plus, your indentation seems completely wrong. Please run
> checkpatch.pl on your patches before running it, and make sure there's
> no errors or warning.
>=20
> > + status =3D "okay";
> > + };
> >   };
> > =20
> >   leds {
> > diff --git a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts=20
> > b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
> > index e288562..683090f 100644
> > --- a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
> > +++ b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
> > @@ -232,6 +232,13 @@
> >   reg =3D <1>;
> >   };
> >   };
> > +
> > + ir0: ir@01c21800 {
> > + pinctrl-names =3D "default";
> > + pinctrl-0 =3D <&ir0_pins_a>;
> > + gpios =3D <&pio 1 4 0>;
>=20
> Same here.
>=20
> > + status =3D "okay";
> > + };
> >   };
> > =20
> >   leds {
> > diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi=20
> > b/arch/arm/boot/dts/sun7i-a20.dtsi
> > index 0ae2b77..4597731 100644
> > --- a/arch/arm/boot/dts/sun7i-a20.dtsi
> > +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
> > @@ -724,6 +724,19 @@
> >   allwinner,drive =3D <2>;
> >   allwinner,pull =3D <0>;
> >   };
> > +
> > + ir0_pins_a: ir0@0 {
> > +    allwinner,pins =3D "PB3","PB4";
> > +    allwinner,function =3D "ir0";
> > +    allwinner,drive =3D <0>;
> > +    allwinner,pull =3D <0>;
> > + };
> > + ir1_pins_a: ir1@0 {
> > +    allwinner,pins =3D "PB22","PB23";
> > +    allwinner,function =3D "ir1";
> > +    allwinner,drive =3D <0>;
> > +    allwinner,pull =3D <0>;
> > + };
> >   };
> > =20
> >   timer@01c20c00 {
> > @@ -937,5 +950,21 @@
> >   #interrupt-cells =3D <3>;
> >   interrupts =3D <1 9 0xf04>;
> >   };
> > +
> > +       ir0: ir@01c21800 {
> > +     compatible =3D "allwinner,sunxi-ir";
> > + clocks =3D <&apb0_gates 6>, <&ir0_clk>;
> > + interrupts =3D <0 5 4>;
> > + reg =3D <0x01C21800 0x40>;
>=20
> Please use lower-case for the address here.
>=20
> > + status =3D "disabled";
> > + };
> > +
> > +       ir1: ir@01c21c00 {
> > +     compatible =3D "allwinner,sunxi-ir";
> > + clocks =3D <&apb0_gates 7>, <&ir1_clk>;
> > + interrupts =3D <0 6 4>;
> > + reg =3D <0x01C21c00 0x40>;
>=20
> ... or at least be consistent.
>=20
> > + status =3D "disabled";
> > + };
> >   };
> >  };

Please split the DT stuff on separate patches. DT stuff require a DT
maintainer SOB or ack, while the media stuff are reviewed by V4L2 people,
and finally reviewed by me and merged via my tree.

> > diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> > index 8fbd377..9427fad 100644
> > --- a/drivers/media/rc/Kconfig
> > +++ b/drivers/media/rc/Kconfig
> > @@ -343,4 +343,14 @@ config RC_ST
> > =20
> >   If you're not sure, select N here.
> > =20
> > +config IR_SUNXI
> > +    tristate "SUNXI IR remote control"
> > +    depends on RC_CORE
> > +    depends on ARCH_SUNXI
> > +    ---help---
> > +      Say Y if you want to use sunXi internal IR Controller
> > +
> > +      To compile this driver as a module, choose M here: the module wi=
ll
> > +      be called sunxi-ir.
> > +
> >  endif #RC_DEVICES
> > diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
> > index f8b54ff..93cdbe9 100644
> > --- a/drivers/media/rc/Makefile
> > +++ b/drivers/media/rc/Makefile
> > @@ -32,4 +32,5 @@ obj-$(CONFIG_IR_GPIO_CIR) +=3D gpio-ir-recv.o
> >  obj-$(CONFIG_IR_IGUANA) +=3D iguanair.o
> >  obj-$(CONFIG_IR_TTUSBIR) +=3D ttusbir.o
> >  obj-$(CONFIG_RC_ST) +=3D st_rc.o
> > +obj-$(CONFIG_IR_SUNXI) +=3D sunxi-ir.o
> >  obj-$(CONFIG_IR_IMG) +=3D img-ir/
> > diff --git a/drivers/media/rc/sunxi-ir.c b/drivers/media/rc/sunxi-ir.c
> > new file mode 100644
> > index 0000000..9b5639e
> > --- /dev/null
> > +++ b/drivers/media/rc/sunxi-ir.c
> > @@ -0,0 +1,314 @@
> > +/*
> > + * Driver for Allwinner sunXi IR controller
> > + *
> > + * Copyright (C) 2014 Alexsey Shestacov <wingrime@linux-sunxi.org>
> > + *
> > + * Based on sun5i-ir.c:
> > + * Copyright (C) 2007-2012 Daniel Wang
> > + * Allwinner Technology Co., Ltd. <www.allwinnertech.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License as
> > + * published by the Free Software Foundation; either version 2 of
> > + * the License, or (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/clk.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/module.h>
> > +#include <linux/of_platform.h>
> > +#include <media/rc-core.h>
> > +
> > +#define SUNXI_IR_DEV "sunxi-ir"
> > +
> > +/* Registers */
> > +/* IR Control */
> > +#define SUNXI_IR_CTL_REG      0x00
> > +/* Rx Config */
> > +#define SUNXI_IR_RXCTL_REG    0x10
> > +/* Rx Data */
> > +#define SUNXI_IR_RXFIFO_REG   0x20
> > +/* Rx Interrupt Enable */
> > +#define SUNXI_IR_RXINT_REG    0x2C
> > +/* Rx Interrupt Status */
> > +#define SUNXI_IR_RXSTA_REG    0x30
> > +/* IR Sample Config */
> > +#define SUNXI_IR_CIR_REG      0x34
> > +
> > +/* Bit Definition of IR_RXINTS_REG Register */
> > +#define SUNXI_IR_RXINTS_RXOF   BIT(0) /* Rx FIFO Overflow */
> > +#define SUNXI_IR_RXINTS_RXPE   BIT(1) /* Rx Packet End */
> > +#define SUNXI_IR_RXINTS_RXDA   BIT(4) /* Rx FIFO Data Available */
> > +/* Hardware supported fifo size */
> > +#define SUNXI_IR_FIFO_SIZE 16
> > +/* How much messages in fifo triggers IRQ */
> > +#define SUNXI_IR_FIFO_TRIG 8
> > +/* Required frequency for IR0 or IR1 clock in CIR mode */
> > +#define SUNXI_IR_BASE_CLK 8000000
>=20
> Would it make sense to have different clock frequencies? If so, that
> should probably be in the DT.
>=20
> > +/* Frequency after IR internal divider  */
> > +#define SUNXI_IR_CLK  (SUNXI_IR_BASE_CLK / 64)
> > +/* Sample period in ns */
> > +#define SUNXI_IR_SAMPLE (1000000000ul / SUNXI_IR_CLK)
> > +/* Filter threshold in samples  */
> > +#define SUNXI_IR_RXFILT                1
> > +/* Idle Threshold in samples */
> > +#define SUNXI_IR_RXIDLE                20
> > +/* Time after which device stops sending data in ms */
> > +#define SUNXI_IR_TIMEOUT               120
> > +
> > +struct sunxi_ir {
> > + spinlock_t      ir_lock;
> > + struct rc_dev   *rc;
> > + void __iomem    *base;
> > + int             irq;
> > + struct clk      *clk;
> > + struct clk      *apb_clk;
> > + const char      *map_name;
> > +};
> > +
> > +static irqreturn_t sunxi_ir_irq(int irqno, void *dev_id)
> > +{
> > + unsigned long status;
> > + unsigned long flags;
> > + unsigned char dt;
> > + unsigned int cnt, rc;
> > + struct sunxi_ir *ir =3D dev_id;
> > + DEFINE_IR_RAW_EVENT(rawir);
> > +
> > + spin_lock_irqsave(&ir->ir_lock, flags);
>=20
> You don't need to use irqsave, you're already running with interrupts
> disabled.
>=20
> > +
> > + status =3D readl(ir->base + SUNXI_IR_RXSTA_REG);
> > +
> > + /* clean all pending statuses */
> > + writel(status | 0xff, ir->base + SUNXI_IR_RXSTA_REG);
> > +
> > + if (status & SUNXI_IR_RXINTS_RXDA) {
> > + /* How much messages in fifo */
> > + rc  =3D ((status>>8) & 0x3f);

On most places, you're using spaces for the >> operator. You should be
consistent about that here too: please add spaces before/after >>.

> > + /* Sanity check */
> > + rc =3D rc > SUNXI_IR_FIFO_SIZE ? SUNXI_IR_FIFO_SIZE : rc;
> > + /* if we have data */
> > + for (cnt =3D 0; cnt < rc; cnt++) {
> > + /* for each bit in fifo */
> > + dt =3D (unsigned char)readl(ir->base +
> > +  SUNXI_IR_RXFIFO_REG);
>=20
> You can use readb then.
>=20
> > + rawir.pulse =3D (dt & 0x80) !=3D 0;
> > + rawir.duration =3D (dt & 0x7f)*SUNXI_IR_SAMPLE;
> > + ir_raw_event_store_with_filter(ir->rc, &rawir);
> > + }
> > + }

What happened with indentation? It is hard to analyze a badly
indented patch like that...

> > +
> > + if (status & SUNXI_IR_RXINTS_RXOF)
> > + ir_raw_event_reset(ir->rc);
> > + else if (status & SUNXI_IR_RXINTS_RXPE) {
> > + ir_raw_event_set_idle(ir->rc, true);
> > + ir_raw_event_handle(ir->rc);
> > + }
> > +
> > + spin_unlock_irqrestore(&ir->ir_lock, flags);
> > +
> > + return IRQ_HANDLED;
> > +}
> > +
> > +
> > +static int sunxi_ir_probe(struct platform_device *pdev)
> > +{
> > + int ret =3D 0;
> > +
> > + unsigned long tmp =3D 0;
> > +
> > + struct device *dev =3D &pdev->dev;
> > + struct device_node *dn =3D dev->of_node;
> > + struct resource *res;
> > + struct sunxi_ir *ir;
> > +
> > + ir =3D devm_kzalloc(dev, sizeof(struct sunxi_ir), GFP_KERNEL);
> > + if (!ir)
> > + return -ENOMEM;
> > +
> > + /* Clock */
> > + ir->apb_clk =3D of_clk_get(dn, 0);
> > + if (IS_ERR(ir->apb_clk)) {
> > + dev_err(dev, "failed to get a apb clock.\n");
> > + return PTR_ERR(ir->apb_clk);
> > + }
> > + ir->clk =3D of_clk_get(dn, 1);
> > + if (IS_ERR(ir->clk)) {
> > + dev_err(dev, "failed to get a ir clock.\n");
> > + ret =3D PTR_ERR(ir->clk);
> > + goto exit_clkput_apb_clk;
> > + }
>=20
> You can use devm_clk_get.
>=20
> > + ret =3D clk_set_rate(ir->clk, SUNXI_IR_BASE_CLK);
> > + if (ret) {
> > + dev_err(dev, "set ir base clock failed!\n");
> > + goto exit_clkput_clk;
> > + }
> > +
> > + if (clk_prepare_enable(ir->apb_clk)) {
> > + dev_err(dev, "try to enable apb_ir_clk failed\n");
> > + ret =3D -EINVAL;
> > + goto exit_clkput_clk;
> > + }
> > +
> > + if (clk_prepare_enable(ir->clk)) {
> > + dev_err(dev, "try to enable ir_clk failed\n");
> > + ret =3D -EINVAL;
> > + goto exit_clkdisable_apb_clk;
> > + }
> > +
> > + /* IO */
> > + res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +
> > + ir->base =3D devm_ioremap_resource(dev, res);
> > + if (IS_ERR(ir->base)) {
> > + dev_err(dev, "failed to map registers\n");
> > + ret =3D -ENOMEM;
> > + goto exit_clkdisable_clk;
> > + }
> > +
> > + /* IRQ */
> > + ir->irq =3D platform_get_irq(pdev, 0);
> > + if (ir->irq < 0) {
> > + dev_err(dev, "no irq resource\n");
> > + ret =3D -EINVAL;
> > + goto exit_clkdisable_clk;
> > + }
> > +
> > + ret =3D devm_request_irq(dev, ir->irq, sunxi_ir_irq, 0, SUNXI_IR_DEV,=
 ir);
> > + if (ret) {
> > + dev_err(dev, "failed request irq\n");
> > + ret =3D -EINVAL;
> > + goto exit_clkdisable_clk;
> > + }
> > +
> > + ir->rc =3D rc_allocate_device();
> > +
> > + if (!ir->rc) {
> > + ret =3D -ENOMEM;
> > + goto exit_clkdisable_clk;
> > + }
> > +
> > + ir->rc->priv =3D ir;
> > + ir->rc->input_name =3D SUNXI_IR_DEV;
> > + ir->rc->input_phys =3D "sunxi-ir/input0";
> > + ir->rc->input_id.bustype =3D BUS_HOST;
> > + ir->rc->input_id.vendor =3D 0x0001;
> > + ir->rc->input_id.product =3D 0x0001;
> > + ir->rc->input_id.version =3D 0x0100;
> > + ir->map_name =3D of_get_property(dn, "linux,rc-map-name", NULL);
> > + ir->rc->map_name =3D ir->map_name ?: RC_MAP_EMPTY;
> > + ir->rc->dev.parent =3D dev;
> > + ir->rc->driver_type =3D RC_DRIVER_IR_RAW;
> > + rc_set_allowed_protocols(ir->rc, RC_BIT_ALL);
> > + ir->rc->rx_resolution =3D SUNXI_IR_SAMPLE;
> > + ir->rc->timeout =3D MS_TO_NS(SUNXI_IR_TIMEOUT);
> > + ir->rc->driver_name =3D SUNXI_IR_DEV;
> > +
> > + ret =3D rc_register_device(ir->rc);
> > + if (ret) {
> > + dev_err(dev, "can't register rc device\n");
> > + ret =3D -EINVAL;
> > + goto exit_free_dev;
> > + }
> > +
> > + platform_set_drvdata(pdev, ir);
> > +
> > + /* Enable CIR Mode */
> > + writel(0x3<<4, ir->base+SUNXI_IR_CTL_REG);

Code Style: please add the needed whitespaces before/after operators.

> > +
> > + /* Config IR Sample Register */
> > + /* Fsample =3D clk */
> > + tmp =3D 0;
> > + /* Set Filter Threshold */
> > + tmp |=3D (SUNXI_IR_RXFILT & 0x3f) << 2;
> > + /* Set Idle Threshold */
> > + tmp |=3D (SUNXI_IR_RXIDLE & 0xff) << 8;
> > + writel(tmp, ir->base + SUNXI_IR_CIR_REG);
> > +
> > + /* Invert Input Signal */
> > + writel(0x1<<2, ir->base + SUNXI_IR_RXCTL_REG);

Coding style: Please use space to separate the operators.

> > +
> > + /* Clear All Rx Interrupt Status */
> > + writel(0xff, ir->base + SUNXI_IR_RXSTA_REG);
> > +
> > + /* Enable IRQ on data, overflow, packed end */
> > + tmp =3D (0x1<<4)|0x3;

Coding style: Please use space to separate the operators.

> > +
> > + /* Rx FIFO Threshold =3D 4 */
> > + tmp |=3D (SUNXI_IR_FIFO_TRIG - 1) << 8;
> > +
> > + writel(tmp, ir->base + SUNXI_IR_RXINT_REG);
> > +
> > + /* Enable IR Module */
> > + tmp =3D readl(ir->base + SUNXI_IR_CTL_REG);
> > +
> > + writel(tmp|0x3, ir->base + SUNXI_IR_CTL_REG);
> > +
> > + dev_info(dev, "initialized sunXi IR driver\n");
> > + return 0;
> > +
> > +exit_free_dev:
> > + rc_free_device(ir->rc);
> > +exit_clkdisable_clk:
> > + clk_disable_unprepare(ir->clk);
> > +exit_clkdisable_apb_clk:
> > + clk_disable_unprepare(ir->apb_clk);
> > +exit_clkput_clk:
> > + clk_put(ir->clk);
> > +exit_clkput_apb_clk:
> > + clk_put(ir->apb_clk);
> > +
> > + return ret;
> > +}
> > +
> > +static int sunxi_ir_remove(struct platform_device *pdev)
> > +{
> > + unsigned long flags;
> > + struct sunxi_ir *ir =3D platform_get_drvdata(pdev);
> > +
> > + clk_disable_unprepare(ir->clk);
> > + clk_disable_unprepare(ir->apb_clk);
> > +
> > + clk_put(ir->clk);
> > + clk_put(ir->apb_clk);
> > +
> > + spin_lock_irqsave(&ir->ir_lock, flags);
> > + /* disable IR IRQ */
> > + writel(0, ir->base + SUNXI_IR_RXINT_REG);
> > + /* clear All Rx Interrupt Status */
> > + writel(0xff, ir->base + SUNXI_IR_RXSTA_REG);
> > + /* disable IR */
> > + writel(0, ir->base + SUNXI_IR_CTL_REG);
> > + spin_unlock_irqrestore(&ir->ir_lock, flags);
> > +
> > + rc_unregister_device(ir->rc);
> > + return 0;
> > +}
> > +
> > +static const struct of_device_id sunxi_ir_match[] =3D {
> > + { .compatible =3D "allwinner,sunxi-ir", },
> > + {},
> > +};
> > +
> > +static struct platform_driver sunxi_ir_driver =3D {
> > + .probe          =3D sunxi_ir_probe,
> > + .remove         =3D sunxi_ir_remove,
> > + .driver =3D {
> > + .name =3D SUNXI_IR_DEV,
> > + .owner =3D THIS_MODULE,
> > + .of_match_table =3D sunxi_ir_match,
> > + },
> > +};
> > +
> > +module_platform_driver(sunxi_ir_driver);
> > +
> > +
> > +MODULE_DESCRIPTION("Allwinner sunXi IR controller driver");
> > +MODULE_AUTHOR("Alexsey Shestacov <wingrime@linux-sunxi.org>");
> > +MODULE_LICENSE("GPL");
> >=20
>=20
> Overall, I'd like this to be split into several patches:
>   - One for the bindings documentation
>   - One for the driver
>   - One that adds the controller to the DT
>   - One that adds the pin muxing options
>   - and finally one that enables the IR receiver on the boards.
>=20
> Thanks!
> Maxime
>=20


--=20

Cheers,
Mauro

--Sig_/AM+il/D_DoGOPbfq8bQ30I=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYG5kAAoJEAhfPr2O5OEVj0kP/ikoc6KSoTyPIq4J387Bpx1j
aLLmbm6Y3nphBajtugP7cAbriJXe87mIIxUXLfBUQ/bmkvA/1wiq1kVDY6u5yH40
MJkOPvSxaAzeMbrmJMRDXSxC6yntW3nijjiq2pYkWVf495Fcj3+KMS0ON51jlK3L
kJDaRN0Ta6c+N7Yn7VmxV0h08HEBTsn09bMq4khlSqvy2NnyFT2Vu0LVI0CH0tSr
+TqhwJ2B83JUDgd1vSDuWc1LhRCPaZ48pc/0/kGY0Yzy1PvCxexbgt2bWavmIrTF
7EewYGoBfRTu+KLn4slB5uszyr8p8tNvfVYKVNGjcNgNf9t1aI1IkNiAIFrbkKFB
XrpLrLG9JQsbuRa5kOBZmn+wuk30zw+bGp/Bh/iFM/eBYURhScte56ONAC2otD21
VTjBdEJ22SApr4CM/g52Ogi50x+YeCB9jqGfvjsWVLBdfZDHgYKkkL2Hu37s+fGp
62LEby3sGlI3AfDIZiAs7iz6/XqDNFOw1NmLeMYp8IATl6Ngc4hH8jdy0R0qIgLK
VqEQ0oDKzESkg/sqyQKkP4CGWTfyCjjyIiHTasY1uJc3zGPtvXgNIk3nLwDM+tSb
wtMpE2hiTslwwyXbDa31sbNJXofKHaIEW1CV4AquQL46U12osouPNeFYWoMJ0NHA
j7KTuuOcRPz0IvlEuAja
=/oLr
-----END PGP SIGNATURE-----

--Sig_/AM+il/D_DoGOPbfq8bQ30I=--
