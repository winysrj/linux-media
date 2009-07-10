Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:58995 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755346AbZGJV2r (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2009 17:28:47 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "rmk@arm.linux.org.uk" <rmk@arm.linux.org.uk>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Fri, 10 Jul 2009 16:28:24 -0500
Subject: [PATCH 8/11 - v3] ARM: DM6446 platform changes for vpfe capture
 driver
Message-ID: <A69FA2915331DC488A831521EAE36FE40144D81EB1@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_A69FA2915331DC488A831521EAE36FE40144D81EB1dlee06enttico_"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--_002_A69FA2915331DC488A831521EAE36FE40144D81EB1dlee06enttico_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello Russell,

This patch is part of the vpfe capture driver (V4L) that adds platform code=
 for the driver on DM6446 which is an ARM based SoC. I have attached the or=
iginal pull request to this email. Please review this and Let us know your =
comments.

Thanks.

Murali Karicheri
m-karicheri2@ti.com

From: m-karicheri2@ti.com
To: hverkuil@xs4all.nl,
 mchehab@infradead.org
Cc: Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 8/11 - v3] DM6446 platform changes for vpfe capture driver
Date: Mon,  6 Jul 2009 13:32:37 -0400

From: Muralidharan Karicheri <m-karicheri2@ti.com>

DM644x platform and board setup

This adds plarform and board setup changes required to support
vpfe capture driver on DM644x

Reviewed by: Hans Verkuil <hverkuil@xs4all.nl>
Reviewed by: Laurent Pinchart <laurent.pinchart@skynet.be>
Reviewed by: Kevin Hilman <khilman@deeprootsystems.com>
Reviewed by: David Brownell <david-b@pacbell.net>

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to Linus' GIT Tree

 arch/arm/mach-davinci/board-dm644x-evm.c    |   72 +++++++++++++++++++++++=
+++-
 arch/arm/mach-davinci/dm644x.c              |   56 +++++++++++++++++++++
 arch/arm/mach-davinci/include/mach/dm644x.h |    2 +
 3 files changed, 128 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davin=
ci/board-dm644x-evm.c
index d9d4045..151a622 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -28,7 +28,8 @@
 #include <linux/io.h>
 #include <linux/phy.h>
 #include <linux/clk.h>
-
+#include <linux/videodev2.h>
+#include <media/tvp514x.h>
 #include <asm/setup.h>
 #include <asm/mach-types.h>
=20
@@ -195,6 +196,72 @@ static struct platform_device davinci_fb_device =3D {
 	.num_resources =3D 0,
 };
=20
+static struct tvp514x_platform_data tvp5146_pdata =3D {
+	.clk_polarity =3D 0,
+	.hs_polarity =3D 1,
+	.vs_polarity =3D 1
+};
+
+#define TVP514X_STD_ALL	(V4L2_STD_NTSC | V4L2_STD_PAL)
+/* Inputs available at the TVP5146 */
+static struct v4l2_input tvp5146_inputs[] =3D {
+	{
+		.index =3D 0,
+		.name =3D "Composite",
+		.type =3D V4L2_INPUT_TYPE_CAMERA,
+		.std =3D TVP514X_STD_ALL,
+	},
+	{
+		.index =3D 1,
+		.name =3D "S-Video",
+		.type =3D V4L2_INPUT_TYPE_CAMERA,
+		.std =3D TVP514X_STD_ALL,
+	},
+};
+
+/*
+ * this is the route info for connecting each input to decoder
+ * ouput that goes to vpfe. There is a one to one correspondence
+ * with tvp5146_inputs
+ */
+static struct vpfe_route tvp5146_routes[] =3D {
+	{
+		.input =3D INPUT_CVBS_VI2B,
+		.output =3D OUTPUT_10BIT_422_EMBEDDED_SYNC,
+	},
+	{
+		.input =3D INPUT_SVIDEO_VI2C_VI1C,
+		.output =3D OUTPUT_10BIT_422_EMBEDDED_SYNC,
+	},
+};
+
+static struct vpfe_subdev_info vpfe_sub_devs[] =3D {
+	{
+		.name =3D "tvp5146",
+		.grp_id =3D 0,
+		.num_inputs =3D ARRAY_SIZE(tvp5146_inputs),
+		.inputs =3D tvp5146_inputs,
+		.routes =3D tvp5146_routes,
+		.can_route =3D 1,
+		.ccdc_if_params =3D {
+			.if_type =3D VPFE_BT656,
+			.hdpol =3D VPFE_PINPOL_POSITIVE,
+			.vdpol =3D VPFE_PINPOL_POSITIVE,
+		},
+		.board_info =3D {
+			I2C_BOARD_INFO("tvp5146", 0x5d),
+			.platform_data =3D &tvp5146_pdata,
+		},
+	},
+};
+
+static struct vpfe_config vpfe_cfg =3D {
+	.num_subdevs =3D ARRAY_SIZE(vpfe_sub_devs),
+	.sub_devs =3D vpfe_sub_devs,
+	.card_name =3D "DM6446 EVM",
+	.ccdc =3D "DM6446 CCDC",
+};
+
 static struct platform_device rtc_dev =3D {
 	.name           =3D "rtc_davinci_evm",
 	.id             =3D -1,
@@ -560,7 +627,6 @@ static struct i2c_board_info __initdata i2c_info[] =3D =
 {
 	},
 	/* ALSO:
 	 * - tvl320aic33 audio codec (0x1b)
-	 * - tvp5146 video decoder (0x5d)
 	 */
 };
=20
@@ -591,6 +657,8 @@ static struct davinci_uart_config uart_config __initdat=
a =3D {
 static void __init
 davinci_evm_map_io(void)
 {
+	/* setup input configuration for VPFE input devices */
+	dm644x_set_vpfe_config(&vpfe_cfg);
 	dm644x_init();
 }
=20
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.=
c
index fb5449b..cc8fc78 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -530,6 +530,59 @@ static struct platform_device dm644x_edma_device =3D {
 	.resource		=3D edma_resources,
 };
=20
+static struct resource dm644x_vpss_resources[] =3D {
+	{
+		/* VPSS Base address */
+		.name		=3D "vpss",
+		.start          =3D 0x01c73400,
+		.end            =3D 0x01c73400 + 0xff,
+		.flags          =3D IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device dm644x_vpss_device =3D {
+	.name			=3D "vpss",
+	.id			=3D -1,
+	.dev.platform_data	=3D "dm644x_vpss",
+	.num_resources		=3D ARRAY_SIZE(dm644x_vpss_resources),
+	.resource		=3D dm644x_vpss_resources,
+};
+
+static struct resource vpfe_resources[] =3D {
+	{
+		.start          =3D IRQ_VDINT0,
+		.end            =3D IRQ_VDINT0,
+		.flags          =3D IORESOURCE_IRQ,
+	},
+	{
+		.start          =3D IRQ_VDINT1,
+		.end            =3D IRQ_VDINT1,
+		.flags          =3D IORESOURCE_IRQ,
+	},
+	{
+		.start          =3D 0x01c70400,
+		.end            =3D 0x01c70400 + 0xff,
+		.flags          =3D IORESOURCE_MEM,
+	},
+};
+
+static u64 vpfe_capture_dma_mask =3D DMA_BIT_MASK(32);
+static struct platform_device vpfe_capture_dev =3D {
+	.name		=3D CAPTURE_DRV_NAME,
+	.id		=3D -1,
+	.num_resources	=3D ARRAY_SIZE(vpfe_resources),
+	.resource	=3D vpfe_resources,
+	.dev =3D {
+		.dma_mask		=3D &vpfe_capture_dma_mask,
+		.coherent_dma_mask	=3D DMA_BIT_MASK(32),
+	},
+};
+
+void dm644x_set_vpfe_config(struct vpfe_config *cfg)
+{
+	vpfe_capture_dev.dev.platform_data =3D cfg;
+}
+
 /*----------------------------------------------------------------------*/
=20
 static struct map_desc dm644x_io_desc[] =3D {
@@ -652,6 +705,9 @@ static int __init dm644x_init_devices(void)
=20
 	platform_device_register(&dm644x_edma_device);
 	platform_device_register(&dm644x_emac_device);
+	platform_device_register(&dm644x_vpss_device);
+	platform_device_register(&vpfe_capture_dev);
+
 	return 0;
 }
 postcore_initcall(dm644x_init_devices);
diff --git a/arch/arm/mach-davinci/include/mach/dm644x.h b/arch/arm/mach-da=
vinci/include/mach/dm644x.h
index 15d42b9..0066db3 100644
--- a/arch/arm/mach-davinci/include/mach/dm644x.h
+++ b/arch/arm/mach-davinci/include/mach/dm644x.h
@@ -25,6 +25,7 @@
 #include <linux/platform_device.h>
 #include <mach/hardware.h>
 #include <mach/emac.h>
+#include <media/davinci/vpfe_capture.h>
=20
 #define DM644X_EMAC_BASE		(0x01C80000)
 #define DM644X_EMAC_CNTRL_OFFSET	(0x0000)
@@ -34,5 +35,6 @@
 #define DM644X_EMAC_CNTRL_RAM_SIZE	(0x2000)
=20
 void __init dm644x_init(void);
+void dm644x_set_vpfe_config(struct vpfe_config *cfg);
=20
 #endif /* __ASM_ARCH_DM644X_H */
--=20
1.6.0.4

--_002_A69FA2915331DC488A831521EAE36FE40144D81EB1dlee06enttico_
Content-Type: message/rfc822

Received: from dflp51.itg.ti.com (128.247.22.94) by dlee74.ent.ti.com
 (157.170.170.8) with Microsoft SMTP Server id 8.1.358.0; Sun, 5 Jul 2009
 07:52:20 -0500
Received: from red.ext.ti.com (localhost [127.0.0.1])	by dflp51.itg.ti.com
 (8.13.7/8.13.7) with ESMTP id n65CqJqp017586;	Sun, 5 Jul 2009 07:52:19 -0500
 (CDT)
Received: from mail135-tx2-R.bigfish.com (mail-tx2.bigfish.com [65.55.88.113])
	by red.ext.ti.com (8.13.7/8.13.7) with ESMTP id n65CqE2o030545;	Sun, 5 Jul
 2009 07:52:19 -0500
Received: from mail135-tx2 (localhost.localdomain [127.0.0.1])	by
 mail135-tx2-R.bigfish.com (Postfix) with ESMTP id 6C9F11CA037F;	Sun,  5 Jul
 2009 12:52:14 +0000 (UTC)
Received: by mail135-tx2 (MessageSwitch) id 1246798331629479_25346; Sun,  5
 Jul 2009 12:52:11 +0000 (UCT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))	(No client
 certificate requested)	by mail135-tx2.bigfish.com (Postfix) with ESMTP id
 53E3331004B;	Sun,  5 Jul 2009 12:52:11 +0000 (UTC)
Received: from 200-153-220-101.dsl.telesp.net.br ([200.153.220.101]
 helo=pedra.chehab.org)	by bombadil.infradead.org with esmtpsa (Exim 4.69 #1
 (Red Hat Linux))	id 1MNRCL-00016U-2w; Sun, 05 Jul 2009 12:52:06 +0000
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>, Russell King <rmk@arm.linux.org.uk>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Subrahmanya, Chaithrika" <chaithrika@ti.com>, "Karicheri, Muralidharan"
	<m-karicheri2@ti.com>, Kevin Hilman <khilman@deeprootsystems.com>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Date: Sun, 5 Jul 2009 07:51:55 -0500
Subject: Re: [PULL] http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-dm646x
Thread-Topic: [PULL] http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-dm646x
Thread-Index: Acn9b27/rz3XQZqRRhSurdvtaY8xvQ==
Message-ID: <20090705095155.22b28559@pedra.chehab.org>
References: <200906262101.51422.hverkuil@xs4all.nl>
In-Reply-To: <200906262101.51422.hverkuil@xs4all.nl>
X-MS-Exchange-Organization-AuthAs: Internal
X-MS-Exchange-Organization-AuthMechanism: 10
X-MS-Exchange-Organization-AuthSource: dlee74.ent.ti.com
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-bigfish: 
 vps-11(z2005n3fb8mz1432R936eM1805M179dN19c2k873fizz1202hzzz2dh6bh62h)
x-spam-tcs-scl: 1:0
x-spamscore: -11
x-fb-ss: 5,
x-srs-rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by
 bombadil.infradead.org	See http://www.infradead.org/rpr.html
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0

Em Fri, 26 Jun 2009 21:01:50 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Mauro,
>=20
> Please pull from http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-dm646x for t=
he following:
>=20
> - ARM: DaVinci: DM646x Video: VPIF driver
> - ARM: DaVinci: DM646x Video: Add VPIF display driver
> - ARM: DaVinci: DM646x Video: Makefile and config files modifications for=
 Display
> - ARM: DaVinci: DM646x Video: Fix compile time warnings for mutex locking
>=20
> Note that these four patches depend on the attached platform patch that
> should be applied to the git tree first.
>=20
> If possible, it would be great if this (like the vpfe capture driver) can=
 be
> merged for 2.6.31.

Hmm... I'm not seeing Russel ack on the arch/arm patch. Russel, could you
please review the enclosed patch? Would this be ok for 2.6.31?

Cheers,
Mauro.

---

[PATCH] ARM: DaVinci: DM646x Video: Platform and board specific setup
From: Chaithrika U S <chaithrika@ti.com>

Platform specific display device setup for DM646x EVM

Add platform device and resource structures. Also define a platform specifi=
c
clock setup function that can be accessed by the driver to configure the cl=
ock
and CPLD.

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
Signed-off-by: Manjunath Hadli <mrh@ti.com>
Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>

 arch/arm/mach-davinci/board-dm646x-evm.c    |  122 +++++++++++++++++++++++=
++++
 arch/arm/mach-davinci/dm646x.c              |   62 ++++++++++++++
 arch/arm/mach-davinci/include/mach/dm646x.h |   24 +++++
 3 files changed, 208 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davin=
ci/board-dm646x-evm.c
index e17de63..eb4bd01 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -52,6 +52,19 @@
 #define DM646X_EVM_PHY_MASK		(0x2)
 #define DM646X_EVM_MDIO_FREQUENCY	(2200000) /* PHY bus frequency */
=20
+#define VIDCLKCTL_OFFSET	(0x38)
+#define VSCLKDIS_OFFSET		(0x6c)
+
+#define VCH2CLK_MASK		(BIT_MASK(10) | BIT_MASK(9) | BIT_MASK(8))
+#define VCH2CLK_SYSCLK8		(BIT(9))
+#define VCH2CLK_AUXCLK		(BIT(9) | BIT(8))
+#define VCH3CLK_MASK		(BIT_MASK(14) | BIT_MASK(13) | BIT_MASK(12))
+#define VCH3CLK_SYSCLK8		(BIT(13))
+#define VCH3CLK_AUXCLK		(BIT(14) | BIT(13))
+
+#define VIDCH2CLK		(BIT(10))
+#define VIDCH3CLK		(BIT(11))
+
 static struct davinci_uart_config uart_config __initdata =3D {
 	.enabled_uarts =3D (1 << 0),
 };
@@ -207,6 +220,40 @@ static struct at24_platform_data eeprom_info =3D {
 	.context	=3D (void *)0x7f00,
 };
=20
+static struct i2c_client *cpld_client;
+
+static int cpld_video_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	cpld_client =3D client;
+	return 0;
+}
+
+static int __devexit cpld_video_remove(struct i2c_client *client)
+{
+	cpld_client =3D NULL;
+	return 0;
+}
+
+static const struct i2c_device_id cpld_video_id[] =3D {
+	{ "cpld_video", 0 },
+	{ }
+};
+
+static struct i2c_driver cpld_video_driver =3D {
+	.driver =3D {
+		.name	=3D "cpld_video",
+	},
+	.probe		=3D cpld_video_probe,
+	.remove		=3D cpld_video_remove,
+	.id_table	=3D cpld_video_id,
+};
+
+static void evm_init_cpld(void)
+{
+	i2c_add_driver(&cpld_video_driver);
+}
+
 static struct i2c_board_info __initdata i2c_info[] =3D  {
 	{
 		I2C_BOARD_INFO("24c256", 0x50),
@@ -216,6 +263,9 @@ static struct i2c_board_info __initdata i2c_info[] =3D =
 {
 		I2C_BOARD_INFO("pcf8574a", 0x38),
 		.platform_data	=3D &pcf_data,
 	},
+	{
+		I2C_BOARD_INFO("cpld_video", 0x3B),
+	},
 };
=20
 static struct davinci_i2c_platform_data i2c_pdata =3D {
@@ -223,10 +273,81 @@ static struct davinci_i2c_platform_data i2c_pdata =3D=
 {
 	.bus_delay      =3D 0 /* usec */,
 };
=20
+static int set_vpif_clock(int mux_mode, int hd)
+{
+	int val =3D 0;
+	int err =3D 0;
+	unsigned int value;
+	void __iomem *base =3D IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE);
+
+	/* disable the clock */
+	value =3D __raw_readl(base + VSCLKDIS_OFFSET);
+	value |=3D (VIDCH3CLK | VIDCH2CLK);
+	__raw_writel(value, base + VSCLKDIS_OFFSET);
+
+	val =3D i2c_smbus_read_byte(cpld_client);
+	if (val < 0)
+		return val;
+
+	if (mux_mode =3D=3D 1)
+		val &=3D ~0x40;
+	else
+		val |=3D 0x40;
+
+	err =3D i2c_smbus_write_byte(cpld_client, val);
+	if (err)
+		return err;
+
+	value =3D __raw_readl(base + VIDCLKCTL_OFFSET);
+	value &=3D ~(VCH2CLK_MASK);
+	value &=3D ~(VCH3CLK_MASK);
+
+	if (hd >=3D 1)
+		value |=3D (VCH2CLK_SYSCLK8 | VCH3CLK_SYSCLK8);
+	else
+		value |=3D (VCH2CLK_AUXCLK | VCH3CLK_AUXCLK);
+
+	__raw_writel(value, base + VIDCLKCTL_OFFSET);
+
+	/* enable the clock */
+	value =3D __raw_readl(base + VSCLKDIS_OFFSET);
+	value &=3D ~(VIDCH3CLK | VIDCH2CLK);
+	__raw_writel(value, base + VSCLKDIS_OFFSET);
+
+	return 0;
+}
+
+static const struct subdev_info dm646x_vpif_subdev[] =3D {
+	{
+		.addr	=3D 0x2A,
+		.name	=3D "adv7343",
+	},
+	{
+		.addr	=3D 0x2C,
+		.name	=3D "ths7303",
+	},
+};
+
+static const char *output[] =3D {
+	"Composite",
+	"Component",
+	"S-Video",
+};
+
+static struct vpif_config dm646x_vpif_config =3D {
+	.set_clock	=3D set_vpif_clock,
+	.subdevinfo	=3D dm646x_vpif_subdev,
+	.subdev_count	=3D ARRAY_SIZE(dm646x_vpif_subdev),
+	.output		=3D output,
+	.output_count	=3D ARRAY_SIZE(output),
+	.card_name	=3D "DM646x EVM",
+};
+
 static void __init evm_init_i2c(void)
 {
 	davinci_init_i2c(&i2c_pdata);
 	i2c_register_board_info(1, i2c_info, ARRAY_SIZE(i2c_info));
+	evm_init_cpld();
 }
=20
 static void __init davinci_map_io(void)
@@ -243,6 +364,7 @@ static __init void evm_init(void)
=20
 	soc_info->emac_pdata->phy_mask =3D DM646X_EVM_PHY_MASK;
 	soc_info->emac_pdata->mdio_max_freq =3D DM646X_EVM_MDIO_FREQUENCY;
+	dm646x_setup_vpif(&dm646x_vpif_config);
 }
=20
 static __init void davinci_dm646x_evm_irq_init(void)
diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.=
c
index 64a291f..50dba53 100644
--- a/arch/arm/mach-davinci/dm646x.c
+++ b/arch/arm/mach-davinci/dm646x.c
@@ -31,6 +31,15 @@
 #include "clock.h"
 #include "mux.h"
=20
+#define DAVINCI_VPIF_BASE       (0x01C12000)
+#define VDD3P3V_PWDN_OFFSET	(0x48)
+#define VSCLKDIS_OFFSET		(0x6C)
+
+#define VDD3P3V_VID_MASK	(BIT_MASK(7) | BIT_MASK(6) | BIT_MASK(5) |\
+					BIT_MASK(4))
+#define VSCLKDIS_MASK		(BIT_MASK(11) | BIT_MASK(10) | BIT_MASK(9) |\
+					BIT_MASK(8))
+
 /*
  * Device specific clocks
  */
@@ -587,6 +596,37 @@ static struct platform_device dm646x_edma_device =3D {
 	.resource		=3D edma_resources,
 };
=20
+static u64 vpif_dma_mask =3D DMA_BIT_MASK(32);
+
+static struct resource vpif_resource[] =3D {
+	{
+		.start	=3D DAVINCI_VPIF_BASE,
+		.end	=3D DAVINCI_VPIF_BASE + 0x03fff,
+		.flags	=3D IORESOURCE_MEM,
+	},
+	{
+		.start =3D IRQ_DM646X_VP_VERTINT2,
+		.end   =3D IRQ_DM646X_VP_VERTINT2,
+		.flags =3D IORESOURCE_IRQ,
+	},
+	{
+		.start =3D IRQ_DM646X_VP_VERTINT3,
+		.end   =3D IRQ_DM646X_VP_VERTINT3,
+		.flags =3D IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device vpif_display_dev =3D {
+	.name		=3D "vpif_display",
+	.id		=3D -1,
+	.dev		=3D {
+			.dma_mask 		=3D &vpif_dma_mask,
+			.coherent_dma_mask	=3D DMA_32BIT_MASK,
+	},
+	.resource	=3D vpif_resource,
+	.num_resources	=3D ARRAY_SIZE(vpif_resource),
+};
+
 /*----------------------------------------------------------------------*/
=20
 static struct map_desc dm646x_io_desc[] =3D {
@@ -696,6 +736,28 @@ static struct davinci_soc_info davinci_soc_info_dm646x=
 =3D {
 	.sram_len		=3D SZ_32K,
 };
=20
+void dm646x_setup_vpif(struct vpif_config *config)
+{
+	unsigned int value;
+	void __iomem *base =3D IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE);
+
+	value =3D __raw_readl(base + VSCLKDIS_OFFSET);
+	value &=3D ~VSCLKDIS_MASK;
+	__raw_writel(value, base + VSCLKDIS_OFFSET);
+
+	value =3D __raw_readl(base + VDD3P3V_PWDN_OFFSET);
+	value &=3D ~VDD3P3V_VID_MASK;
+	__raw_writel(value, base + VDD3P3V_PWDN_OFFSET);
+
+	davinci_cfg_reg(DM646X_STSOMUX_DISABLE);
+	davinci_cfg_reg(DM646X_STSIMUX_DISABLE);
+	davinci_cfg_reg(DM646X_PTSOMUX_DISABLE);
+	davinci_cfg_reg(DM646X_PTSIMUX_DISABLE);
+
+	vpif_display_dev.dev.platform_data =3D config;
+	platform_device_register(&vpif_display_dev);
+}
+
 void __init dm646x_init(void)
 {
 	davinci_common_init(&davinci_soc_info_dm646x);
diff --git a/arch/arm/mach-davinci/include/mach/dm646x.h b/arch/arm/mach-da=
vinci/include/mach/dm646x.h
index 1fc764c..7409b6d 100644
--- a/arch/arm/mach-davinci/include/mach/dm646x.h
+++ b/arch/arm/mach-davinci/include/mach/dm646x.h
@@ -23,4 +23,28 @@
=20
 void __init dm646x_init(void);
=20
+void dm646x_video_init(void);
+
+struct vpif_output {
+	u16 id;
+	const char *name;
+};
+
+struct subdev_info {
+	unsigned short addr;
+	const char *name;
+};
+
+struct vpif_config {
+	int (*set_clock)(int, int);
+	const struct subdev_info *subdevinfo;
+	int subdev_count;
+	const char **output;
+	int output_count;
+	const char *card_name;
+};
+
+
+void dm646x_setup_vpif(struct vpif_config *config);
+
 #endif /* __ASM_ARCH_DM646X_H */




Cheers,
Mauro


--_002_A69FA2915331DC488A831521EAE36FE40144D81EB1dlee06enttico_--
