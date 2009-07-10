Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:56907 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbZGJVce (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2009 17:32:34 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "rmk@arm.linux.org.uk" <rmk@arm.linux.org.uk>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 10 Jul 2009 16:32:07 -0500
Subject: [PATCH 7/11 - v3] ARM: DM355 platform changes for vpfe capture
 driver
Message-ID: <A69FA2915331DC488A831521EAE36FE40144D81EB5@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_A69FA2915331DC488A831521EAE36FE40144D81EB5dlee06enttico_"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--_002_A69FA2915331DC488A831521EAE36FE40144D81EB5dlee06enttico_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello Russell,

This patch is part of the vpfe capture driver (V4L) that adds platform code=
 for the driver on DM355 which is an ARM based SoC. I have attached the ori=
ginal pull request to this email. Please review this and Let us know your c=
omments.

Thanks.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
Phone : 301-515-3736
email: m-karicheri2@ti.com


From: m-karicheri2@ti.com
To: hverkuil@xs4all.nl,
 mchehab@infradead.org
Cc: Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 7/11 - v3] DM355 platform changes for vpfe capture driver
Date: Mon,  6 Jul 2009 13:32:45 -0400

From: Muralidharan Karicheri <m-karicheri2@ti.com>

DM355 platform and board setup

This has platform and board setup changes to support vpfe capture
driver for DM355 EVMs.

Reviewed by: Hans Verkuil <hverkuil@xs4all.nl>
Reviewed by: Laurent Pinchart <laurent.pinchart@skynet.be>
Reviewed by: Kevin Hilman <khilman@deeprootsystems.com>
Reviewed by: David Brownell <david-b@pacbell.net>

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to Linus' GIT Tree

 arch/arm/mach-davinci/board-dm355-evm.c    |   76 ++++++++++++++++++++++++=
-
 arch/arm/mach-davinci/dm355.c              |   83 ++++++++++++++++++++++++=
++++
 arch/arm/mach-davinci/include/mach/dm355.h |    2 +
 arch/arm/mach-davinci/include/mach/mux.h   |    9 +++
 4 files changed, 167 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinc=
i/board-dm355-evm.c
index 5ac2f56..605bf03 100644
--- a/arch/arm/mach-davinci/board-dm355-evm.c
+++ b/arch/arm/mach-davinci/board-dm355-evm.c
@@ -20,6 +20,8 @@
 #include <linux/io.h>
 #include <linux/gpio.h>
 #include <linux/clk.h>
+#include <linux/videodev2.h>
+#include <media/tvp514x.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/eeprom.h>
=20
@@ -135,11 +137,11 @@ static void dm355evm_mmcsd_gpios(unsigned gpio)
 }
=20
 static struct i2c_board_info dm355evm_i2c_info[] =3D {
-	{ I2C_BOARD_INFO("dm355evm_msp", 0x25),
+	{	I2C_BOARD_INFO("dm355evm_msp", 0x25),
 		.platform_data =3D dm355evm_mmcsd_gpios,
-		/* plus irq */ },
+	},
+	/* { plus irq  }, */
 	/* { I2C_BOARD_INFO("tlv320aic3x", 0x1b), }, */
-	/* { I2C_BOARD_INFO("tvp5146", 0x5d), }, */
 };
=20
 static void __init evm_init_i2c(void)
@@ -178,6 +180,72 @@ static struct platform_device dm355evm_dm9000 =3D {
 	.num_resources	=3D ARRAY_SIZE(dm355evm_dm9000_rsrc),
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
+	}
+};
+
+static struct vpfe_config vpfe_cfg =3D {
+	.num_subdevs =3D ARRAY_SIZE(vpfe_sub_devs),
+	.sub_devs =3D vpfe_sub_devs,
+	.card_name =3D "DM355 EVM",
+	.ccdc =3D "DM355 CCDC",
+};
+
 static struct platform_device *davinci_evm_devices[] __initdata =3D {
 	&dm355evm_dm9000,
 	&davinci_nand_device,
@@ -189,6 +257,8 @@ static struct davinci_uart_config uart_config __initdat=
a =3D {
=20
 static void __init dm355_evm_map_io(void)
 {
+	/* setup input configuration for VPFE input devices */
+	dm355_set_vpfe_config(&vpfe_cfg);
 	dm355_init();
 }
=20
diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index baaaf32..2696df1 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -481,6 +481,14 @@ INT_CFG(DM355,  INT_EDMA_TC1_ERR,     4,    1,    1,  =
   false)
 EVT_CFG(DM355,  EVT8_ASP1_TX,	      0,    1,    0,     false)
 EVT_CFG(DM355,  EVT9_ASP1_RX,	      1,    1,    0,     false)
 EVT_CFG(DM355,  EVT26_MMC0_RX,	      2,    1,    0,     false)
+
+MUX_CFG(DM355,	VIN_PCLK,	0,   14,    1,    1,	 false)
+MUX_CFG(DM355,	VIN_CAM_WEN,	0,   13,    1,    1,	 false)
+MUX_CFG(DM355,	VIN_CAM_VD,	0,   12,    1,    1,	 false)
+MUX_CFG(DM355,	VIN_CAM_HD,	0,   11,    1,    1,	 false)
+MUX_CFG(DM355,	VIN_YIN_EN,	0,   10,    1,    1,	 false)
+MUX_CFG(DM355,	VIN_CINL_EN,	0,   0,   0xff, 0x55,	 false)
+MUX_CFG(DM355,	VIN_CINH_EN,	0,   8,     3,    3,	 false)
 #endif
 };
=20
@@ -604,6 +612,67 @@ static struct platform_device dm355_edma_device =3D {
 	.resource		=3D edma_resources,
 };
=20
+static struct resource dm355_vpss_resources[] =3D {
+	{
+		/* VPSS BL Base address */
+		.name		=3D "vpss",
+		.start          =3D 0x01c70800,
+		.end            =3D 0x01c70800 + 0xff,
+		.flags          =3D IORESOURCE_MEM,
+	},
+	{
+		/* VPSS CLK Base address */
+		.name		=3D "vpss",
+		.start          =3D 0x01c70000,
+		.end            =3D 0x01c70000 + 0xf,
+		.flags          =3D IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device dm355_vpss_device =3D {
+	.name			=3D "vpss",
+	.id			=3D -1,
+	.dev.platform_data	=3D "dm355_vpss",
+	.num_resources		=3D ARRAY_SIZE(dm355_vpss_resources),
+	.resource		=3D dm355_vpss_resources,
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
+	/* CCDC Base address */
+	{
+		.flags          =3D IORESOURCE_MEM,
+		.start          =3D 0x01c70600,
+		.end            =3D 0x01c70600 + 0x1ff,
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
+void dm355_set_vpfe_config(struct vpfe_config *cfg)
+{
+	vpfe_capture_dev.dev.platform_data =3D cfg;
+}
+
 /*----------------------------------------------------------------------*/
=20
 static struct map_desc dm355_io_desc[] =3D {
@@ -725,6 +794,20 @@ static int __init dm355_init_devices(void)
=20
 	davinci_cfg_reg(DM355_INT_EDMA_CC);
 	platform_device_register(&dm355_edma_device);
+	platform_device_register(&dm355_vpss_device);
+	/*
+	 * setup Mux configuration for vpfe input and register
+	 * vpfe capture platform device
+	 */
+	davinci_cfg_reg(DM355_VIN_PCLK);
+	davinci_cfg_reg(DM355_VIN_CAM_WEN);
+	davinci_cfg_reg(DM355_VIN_CAM_VD);
+	davinci_cfg_reg(DM355_VIN_CAM_HD);
+	davinci_cfg_reg(DM355_VIN_YIN_EN);
+	davinci_cfg_reg(DM355_VIN_CINL_EN);
+	davinci_cfg_reg(DM355_VIN_CINH_EN);
+	platform_device_register(&vpfe_capture_dev);
+
 	return 0;
 }
 postcore_initcall(dm355_init_devices);
diff --git a/arch/arm/mach-davinci/include/mach/dm355.h b/arch/arm/mach-dav=
inci/include/mach/dm355.h
index 54903b7..e28713c 100644
--- a/arch/arm/mach-davinci/include/mach/dm355.h
+++ b/arch/arm/mach-davinci/include/mach/dm355.h
@@ -12,11 +12,13 @@
 #define __ASM_ARCH_DM355_H
=20
 #include <mach/hardware.h>
+#include <media/davinci/vpfe_capture.h>
=20
 struct spi_board_info;
=20
 void __init dm355_init(void);
 void dm355_init_spi0(unsigned chipselect_mask,
 		struct spi_board_info *info, unsigned len);
+void dm355_set_vpfe_config(struct vpfe_config *cfg);
=20
 #endif /* __ASM_ARCH_DM355_H */
diff --git a/arch/arm/mach-davinci/include/mach/mux.h b/arch/arm/mach-davin=
ci/include/mach/mux.h
index 2737845..f288063 100644
--- a/arch/arm/mach-davinci/include/mach/mux.h
+++ b/arch/arm/mach-davinci/include/mach/mux.h
@@ -154,6 +154,15 @@ enum davinci_dm355_index {
 	DM355_EVT8_ASP1_TX,
 	DM355_EVT9_ASP1_RX,
 	DM355_EVT26_MMC0_RX,
+
+	/* Video In Pin Mux */
+	DM355_VIN_PCLK,
+	DM355_VIN_CAM_WEN,
+	DM355_VIN_CAM_VD,
+	DM355_VIN_CAM_HD,
+	DM355_VIN_YIN_EN,
+	DM355_VIN_CINL_EN,
+	DM355_VIN_CINH_EN,
 };
=20
 #ifdef CONFIG_DAVINCI_MUX
--=20
1.6.0.4

--_002_A69FA2915331DC488A831521EAE36FE40144D81EB5dlee06enttico_
Content-Type: message/rfc822

Received: from dflp53.itg.ti.com (128.247.5.6) by dlee74.ent.ti.com
 (157.170.170.8) with Microsoft SMTP Server (TLS) id 8.1.358.0; Mon, 6 Jul
 2009 13:24:57 -0500
Received: from white.ext.ti.com (localhost [127.0.0.1])	by dflp53.itg.ti.com
 (8.13.8/8.13.8) with ESMTP id n66IOupO007698	for <m-karicheri2@ti.com>; Mon,
 6 Jul 2009 13:24:56 -0500 (CDT)
Received: from mail58-dub-R.bigfish.com (mail-dub.bigfish.com
 [213.199.154.10])	by white.ext.ti.com (8.13.7/8.13.7) with ESMTP id
 n66IOoAa030087	for <m-karicheri2@ti.com>; Mon, 6 Jul 2009 13:24:55 -0500
Received: from mail58-dub (localhost.localdomain [127.0.0.1])	by
 mail58-dub-R.bigfish.com (Postfix) with ESMTP id 990F22F8108	for
 <m-karicheri2@ti.com>; Mon,  6 Jul 2009 18:24:49 +0000 (UTC)
Received: by mail58-dub (MessageSwitch) id 1246904688612392_29013; Mon,  6 Jul
 2009 18:24:48 +0000 (UCT)
Received: from smtp-cloud1.xs4all.nl (smtp-cloud1.xs4all.nl [194.109.24.61])
	by mail58-dub.bigfish.com (Postfix) with ESMTP id BD14F19C0056	for
 <m-karicheri2@ti.com>; Mon,  6 Jul 2009 18:24:47 +0000 (UTC)
Received: from [84.208.85.194] ([84.208.85.194:52866] helo=tschai.lan)	by
 smtp-cloud1.xs4all.nl (envelope-from <hverkuil@xs4all.nl>)	(ecelerity
 2.2.2.41 r(31179/31189)) with ESMTPSA (cipher=AES256-SHA) 	id
 96/63-08282-E61425A4; Mon, 06 Jul 2009 20:24:47 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Karicheri, Muralidharan" <m-karicheri2@ti.com>, Mauro Carvalho Chehab
	<mchehab@infradead.org>
Date: Mon, 6 Jul 2009 13:24:44 -0500
Subject: [PULL] http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-vpfe-cap
Thread-Topic: [PULL] http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-vpfe-cap
Thread-Index: Acn+ZxCHhsLJyVj3RtW6NoJHsDJ6SA==
Message-ID: <200907062024.44703.hverkuil@xs4all.nl>
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-AuthSource: dlee74.ent.ti.com
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
user-agent: KMail/1.9.9
authentication-results: smtp-cloud1.xs4all.nl smtp.user=hverkuil; auth=pass
 (PLAIN)
x-bigfish: vps-5(z2005n3fb8mf2bjz552II4015L19c2kzz1202hzzz2dh17dh6bh34h61h)
x-spam-tcs-scl: 0:0
x-spamscore: -5
Content-Type: multipart/mixed;
	boundary="_003_20090706202444703hverkuilxs4allnl_"
MIME-Version: 1.0

--_003_20090706202444703hverkuilxs4allnl_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGkgTWF1cm8sDQoNClBsZWFzZSBwdWxsIGZyb20gaHR0cDovL3d3dy5saW51eHR2Lm9yZy9oZy9+
aHZlcmt1aWwvdjRsLWR2Yi12cGZlLWNhcCBmb3IgdGhlIGZvbGxvd2luZzoNCg0KLSB0dnA1MTR4
OiBNaWdyYXRpb24gdG8gc3ViLWRldmljZSBmcmFtZXdvcmsNCi0gdHZwNTE0eDogZm9ybWF0dGlu
ZyBjb21tZW50cyBhcyBwZXIga2VybmVsIGRvY3VtZW50YXRpb24NCi0gdjRsOiB2cGZlIGNhcHR1
cmUgYnJpZGdlIGRyaXZlciBmb3IgRE0zNTUgYW5kIERNNjQ0Ng0KLSB2NGw6IGNjZGMgaHcgZGV2
aWNlIGhlYWRlciBmaWxlIGZvciB2cGZlIGNhcHR1cmUNCi0gdjRsOiBkbTM1NSBjY2RjIG1vZHVs
ZSBmb3IgdnBmZSBjYXB0dXJlIGRyaXZlcg0KLSB2NGw6IGRtNjQ0eCBjY2RjIG1vZHVsZSBmb3Ig
dnBmZSBjYXB0dXJlIGRyaXZlcg0KLSB2NGw6IGNjZGMgdHlwZXMgdXNlZCBhY3Jvc3MgY2NkYyBt
b2R1bGVzIGZvciB2cGZlIGNhcHR1cmUgZHJpdmVyDQotIHY0bDogY29tbW9uIHZwc3MgbW9kdWxl
IGZvciB2aWRlbyBkcml2ZXJzDQotIHY0bDogTWFrZWZpbGUgYW5kIGNvbmZpZyBmaWxlcyBmb3Ig
dnBmZSBjYXB0dXJlIGRyaXZlcg0KLSB2NGw6IGRhdmluY2kgZHJpdmVycyBzaG91bGQgb25seSBi
ZSBjb21waWxlZCBmb3Iga2VybmVscyA+PSAyLjYuMzEuDQoNCkhvcGVmdWxseSB0aGVzZSBjaGFu
Z2VzIGNhbiBiZSBtZXJnZWQgaW50byAyLjYuMzEuDQoNCkkgaGF2ZSBhdHRhY2hlZCB0d28gYXJj
aC9hcm0gcGF0Y2hlcyB0aGF0IG5lZWQgdG8gYmUgYXBwbGllZCB0byB0aGUgZ2l0IHRyZWUuIA0K
VGhlc2UgcGF0Y2hlcyBzaG91bGQgYmUgYXBwbGllZCBhZnRlciBtZXJnaW5nIHRoaXMgdHJlZS4N
Cg0KSSd2ZSBjb21waWxlZCB0aGlzIGRyaXZlciBhZ2FpbnN0IHRoZSBsYXRlc3QgTGludXMnIGdp
dCB0cmVlLg0KDQpUaGFua3MsDQoNCiAgICAgICAgSGFucw0KDQpkaWZmc3RhdDoNCiBiL2xpbnV4
L2RyaXZlcnMvbWVkaWEvdmlkZW8vZGF2aW5jaS9jY2RjX2h3X2RldmljZS5oICAgfCAgMTEwDQog
Yi9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2RhdmluY2kvZG0zNTVfY2NkYy5jICAgICAgIHwg
IDk3OCArKysrKysrDQogYi9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2RhdmluY2kvZG0zNTVf
Y2NkY19yZWdzLmggIHwgIDMxMCArKw0KIGIvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9kYXZp
bmNpL2RtNjQ0eF9jY2RjLmMgICAgICB8ICA4NzggKysrKysrKw0KIGIvbGludXgvZHJpdmVycy9t
ZWRpYS92aWRlby9kYXZpbmNpL2RtNjQ0eF9jY2RjX3JlZ3MuaCB8ICAxNDUgKw0KIGIvbGludXgv
ZHJpdmVycy9tZWRpYS92aWRlby9kYXZpbmNpL3ZwZmVfY2FwdHVyZS5jICAgICB8IDIxMjQgKysr
KysrKysrKysrKysrKysNCiBiL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vZGF2aW5jaS92cHNz
LmMgICAgICAgICAgICAgfCAgMzAxICsrDQogYi9saW51eC9pbmNsdWRlL21lZGlhL2RhdmluY2kv
Y2NkY190eXBlcy5oICAgICAgICAgICAgIHwgICA0Mw0KIGIvbGludXgvaW5jbHVkZS9tZWRpYS9k
YXZpbmNpL2RtMzU1X2NjZGMuaCAgICAgICAgICAgICB8ICAzMjEgKysNCiBiL2xpbnV4L2luY2x1
ZGUvbWVkaWEvZGF2aW5jaS9kbTY0NHhfY2NkYy5oICAgICAgICAgICAgfCAgMTg0ICsNCiBiL2xp
bnV4L2luY2x1ZGUvbWVkaWEvZGF2aW5jaS92cGZlX2NhcHR1cmUuaCAgICAgICAgICAgfCAgMTk4
ICsNCiBiL2xpbnV4L2luY2x1ZGUvbWVkaWEvZGF2aW5jaS92cGZlX3R5cGVzLmggICAgICAgICAg
ICAgfCAgIDUxDQogYi9saW51eC9pbmNsdWRlL21lZGlhL2RhdmluY2kvdnBzcy5oICAgICAgICAg
ICAgICAgICAgIHwgICA2OQ0KIGxpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vS2NvbmZpZyAgICAg
ICAgICAgICAgICAgICAgICB8ICAgNDkNCiBsaW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL01ha2Vm
aWxlICAgICAgICAgICAgICAgICAgICAgfCAgICAyDQogbGludXgvZHJpdmVycy9tZWRpYS92aWRl
by9kYXZpbmNpL01ha2VmaWxlICAgICAgICAgICAgIHwgICAgNg0KIGxpbnV4L2RyaXZlcnMvbWVk
aWEvdmlkZW8vdHZwNTE0eC5jICAgICAgICAgICAgICAgICAgICB8IDExNTQgKysrKy0tLS0tDQog
bGludXgvZHJpdmVycy9tZWRpYS92aWRlby90dnA1MTR4X3JlZ3MuaCAgICAgICAgICAgICAgIHwg
ICAxMA0KIGxpbnV4L2luY2x1ZGUvbWVkaWEvdHZwNTE0eC5oICAgICAgICAgICAgICAgICAgICAg
ICAgICB8ICAgIDQNCiB2NGwvdmVyc2lvbnMudHh0ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgfCAgICA3DQogMjAgZmlsZXMgY2hhbmdlZCwgNjI4NCBpbnNlcnRpb25zKCsp
LCA2NjAgZGVsZXRpb25zKC0pDQoNCi0tIA0KSGFucyBWZXJrdWlsIC0gdmlkZW80bGludXggZGV2
ZWxvcGVyIC0gc3BvbnNvcmVkIGJ5IFRBTkRCRVJHIFRlbGVjb20NCg==

--_003_20090706202444703hverkuilxs4allnl_
Content-Type: text/x-diff; name="dm6446.diff"
Content-Description: dm6446.diff
Content-Disposition: attachment; filename="dm6446.diff"; size=6445;
	creation-date="Mon, 06 Jul 2009 13:24:56 GMT";
	modification-date="Mon, 06 Jul 2009 13:24:56 GMT"
Content-Transfer-Encoding: base64

RnJvbTogbS1rYXJpY2hlcmkyQHRpLmNvbQ0KVG86IGh2ZXJrdWlsQHhzNGFsbC5ubCwNCiBtY2hl
aGFiQGluZnJhZGVhZC5vcmcNCkNjOiBNdXJhbGlkaGFyYW4gS2FyaWNoZXJpIDxtLWthcmljaGVy
aTJAdGkuY29tPg0KU3ViamVjdDogW1BBVENIIDgvMTEgLSB2M10gRE02NDQ2IHBsYXRmb3JtIGNo
YW5nZXMgZm9yIHZwZmUgY2FwdHVyZSBkcml2ZXINCkRhdGU6IE1vbiwgIDYgSnVsIDIwMDkgMTM6
MzI6MzcgLTA0MDANCg0KRnJvbTogTXVyYWxpZGhhcmFuIEthcmljaGVyaSA8bS1rYXJpY2hlcmky
QHRpLmNvbT4NCg0KRE02NDR4IHBsYXRmb3JtIGFuZCBib2FyZCBzZXR1cA0KDQpUaGlzIGFkZHMg
cGxhcmZvcm0gYW5kIGJvYXJkIHNldHVwIGNoYW5nZXMgcmVxdWlyZWQgdG8gc3VwcG9ydA0KdnBm
ZSBjYXB0dXJlIGRyaXZlciBvbiBETTY0NHgNCg0KUmV2aWV3ZWQgYnk6IEhhbnMgVmVya3VpbCA8
aHZlcmt1aWxAeHM0YWxsLm5sPg0KUmV2aWV3ZWQgYnk6IExhdXJlbnQgUGluY2hhcnQgPGxhdXJl
bnQucGluY2hhcnRAc2t5bmV0LmJlPg0KUmV2aWV3ZWQgYnk6IEtldmluIEhpbG1hbiA8a2hpbG1h
bkBkZWVwcm9vdHN5c3RlbXMuY29tPg0KUmV2aWV3ZWQgYnk6IERhdmlkIEJyb3duZWxsIDxkYXZp
ZC1iQHBhY2JlbGwubmV0Pg0KDQpTaWduZWQtb2ZmLWJ5OiBNdXJhbGlkaGFyYW4gS2FyaWNoZXJp
IDxtLWthcmljaGVyaTJAdGkuY29tPg0KLS0tDQpBcHBsaWVzIHRvIExpbnVzJyBHSVQgVHJlZQ0K
DQogYXJjaC9hcm0vbWFjaC1kYXZpbmNpL2JvYXJkLWRtNjQ0eC1ldm0uYyAgICB8ICAgNzIgKysr
KysrKysrKysrKysrKysrKysrKysrKystDQogYXJjaC9hcm0vbWFjaC1kYXZpbmNpL2RtNjQ0eC5j
ICAgICAgICAgICAgICB8ICAgNTYgKysrKysrKysrKysrKysrKysrKysrDQogYXJjaC9hcm0vbWFj
aC1kYXZpbmNpL2luY2x1ZGUvbWFjaC9kbTY0NHguaCB8ICAgIDIgKw0KIDMgZmlsZXMgY2hhbmdl
ZCwgMTI4IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9hcmNo
L2FybS9tYWNoLWRhdmluY2kvYm9hcmQtZG02NDR4LWV2bS5jIGIvYXJjaC9hcm0vbWFjaC1kYXZp
bmNpL2JvYXJkLWRtNjQ0eC1ldm0uYw0KaW5kZXggZDlkNDA0NS4uMTUxYTYyMiAxMDA2NDQNCi0t
LSBhL2FyY2gvYXJtL21hY2gtZGF2aW5jaS9ib2FyZC1kbTY0NHgtZXZtLmMNCisrKyBiL2FyY2gv
YXJtL21hY2gtZGF2aW5jaS9ib2FyZC1kbTY0NHgtZXZtLmMNCkBAIC0yOCw3ICsyOCw4IEBADQog
I2luY2x1ZGUgPGxpbnV4L2lvLmg+DQogI2luY2x1ZGUgPGxpbnV4L3BoeS5oPg0KICNpbmNsdWRl
IDxsaW51eC9jbGsuaD4NCi0NCisjaW5jbHVkZSA8bGludXgvdmlkZW9kZXYyLmg+DQorI2luY2x1
ZGUgPG1lZGlhL3R2cDUxNHguaD4NCiAjaW5jbHVkZSA8YXNtL3NldHVwLmg+DQogI2luY2x1ZGUg
PGFzbS9tYWNoLXR5cGVzLmg+DQogDQpAQCAtMTk1LDYgKzE5Niw3MiBAQCBzdGF0aWMgc3RydWN0
IHBsYXRmb3JtX2RldmljZSBkYXZpbmNpX2ZiX2RldmljZSA9IHsNCiAJLm51bV9yZXNvdXJjZXMg
PSAwLA0KIH07DQogDQorc3RhdGljIHN0cnVjdCB0dnA1MTR4X3BsYXRmb3JtX2RhdGEgdHZwNTE0
Nl9wZGF0YSA9IHsNCisJLmNsa19wb2xhcml0eSA9IDAsDQorCS5oc19wb2xhcml0eSA9IDEsDQor
CS52c19wb2xhcml0eSA9IDENCit9Ow0KKw0KKyNkZWZpbmUgVFZQNTE0WF9TVERfQUxMCShWNEwy
X1NURF9OVFNDIHwgVjRMMl9TVERfUEFMKQ0KKy8qIElucHV0cyBhdmFpbGFibGUgYXQgdGhlIFRW
UDUxNDYgKi8NCitzdGF0aWMgc3RydWN0IHY0bDJfaW5wdXQgdHZwNTE0Nl9pbnB1dHNbXSA9IHsN
CisJew0KKwkJLmluZGV4ID0gMCwNCisJCS5uYW1lID0gIkNvbXBvc2l0ZSIsDQorCQkudHlwZSA9
IFY0TDJfSU5QVVRfVFlQRV9DQU1FUkEsDQorCQkuc3RkID0gVFZQNTE0WF9TVERfQUxMLA0KKwl9
LA0KKwl7DQorCQkuaW5kZXggPSAxLA0KKwkJLm5hbWUgPSAiUy1WaWRlbyIsDQorCQkudHlwZSA9
IFY0TDJfSU5QVVRfVFlQRV9DQU1FUkEsDQorCQkuc3RkID0gVFZQNTE0WF9TVERfQUxMLA0KKwl9
LA0KK307DQorDQorLyoNCisgKiB0aGlzIGlzIHRoZSByb3V0ZSBpbmZvIGZvciBjb25uZWN0aW5n
IGVhY2ggaW5wdXQgdG8gZGVjb2Rlcg0KKyAqIG91cHV0IHRoYXQgZ29lcyB0byB2cGZlLiBUaGVy
ZSBpcyBhIG9uZSB0byBvbmUgY29ycmVzcG9uZGVuY2UNCisgKiB3aXRoIHR2cDUxNDZfaW5wdXRz
DQorICovDQorc3RhdGljIHN0cnVjdCB2cGZlX3JvdXRlIHR2cDUxNDZfcm91dGVzW10gPSB7DQor
CXsNCisJCS5pbnB1dCA9IElOUFVUX0NWQlNfVkkyQiwNCisJCS5vdXRwdXQgPSBPVVRQVVRfMTBC
SVRfNDIyX0VNQkVEREVEX1NZTkMsDQorCX0sDQorCXsNCisJCS5pbnB1dCA9IElOUFVUX1NWSURF
T19WSTJDX1ZJMUMsDQorCQkub3V0cHV0ID0gT1VUUFVUXzEwQklUXzQyMl9FTUJFRERFRF9TWU5D
LA0KKwl9LA0KK307DQorDQorc3RhdGljIHN0cnVjdCB2cGZlX3N1YmRldl9pbmZvIHZwZmVfc3Vi
X2RldnNbXSA9IHsNCisJew0KKwkJLm5hbWUgPSAidHZwNTE0NiIsDQorCQkuZ3JwX2lkID0gMCwN
CisJCS5udW1faW5wdXRzID0gQVJSQVlfU0laRSh0dnA1MTQ2X2lucHV0cyksDQorCQkuaW5wdXRz
ID0gdHZwNTE0Nl9pbnB1dHMsDQorCQkucm91dGVzID0gdHZwNTE0Nl9yb3V0ZXMsDQorCQkuY2Fu
X3JvdXRlID0gMSwNCisJCS5jY2RjX2lmX3BhcmFtcyA9IHsNCisJCQkuaWZfdHlwZSA9IFZQRkVf
QlQ2NTYsDQorCQkJLmhkcG9sID0gVlBGRV9QSU5QT0xfUE9TSVRJVkUsDQorCQkJLnZkcG9sID0g
VlBGRV9QSU5QT0xfUE9TSVRJVkUsDQorCQl9LA0KKwkJLmJvYXJkX2luZm8gPSB7DQorCQkJSTJD
X0JPQVJEX0lORk8oInR2cDUxNDYiLCAweDVkKSwNCisJCQkucGxhdGZvcm1fZGF0YSA9ICZ0dnA1
MTQ2X3BkYXRhLA0KKwkJfSwNCisJfSwNCit9Ow0KKw0KK3N0YXRpYyBzdHJ1Y3QgdnBmZV9jb25m
aWcgdnBmZV9jZmcgPSB7DQorCS5udW1fc3ViZGV2cyA9IEFSUkFZX1NJWkUodnBmZV9zdWJfZGV2
cyksDQorCS5zdWJfZGV2cyA9IHZwZmVfc3ViX2RldnMsDQorCS5jYXJkX25hbWUgPSAiRE02NDQ2
IEVWTSIsDQorCS5jY2RjID0gIkRNNjQ0NiBDQ0RDIiwNCit9Ow0KKw0KIHN0YXRpYyBzdHJ1Y3Qg
cGxhdGZvcm1fZGV2aWNlIHJ0Y19kZXYgPSB7DQogCS5uYW1lICAgICAgICAgICA9ICJydGNfZGF2
aW5jaV9ldm0iLA0KIAkuaWQgICAgICAgICAgICAgPSAtMSwNCkBAIC01NjAsNyArNjI3LDYgQEAg
c3RhdGljIHN0cnVjdCBpMmNfYm9hcmRfaW5mbyBfX2luaXRkYXRhIGkyY19pbmZvW10gPSAgew0K
IAl9LA0KIAkvKiBBTFNPOg0KIAkgKiAtIHR2bDMyMGFpYzMzIGF1ZGlvIGNvZGVjICgweDFiKQ0K
LQkgKiAtIHR2cDUxNDYgdmlkZW8gZGVjb2RlciAoMHg1ZCkNCiAJICovDQogfTsNCiANCkBAIC01
OTEsNiArNjU3LDggQEAgc3RhdGljIHN0cnVjdCBkYXZpbmNpX3VhcnRfY29uZmlnIHVhcnRfY29u
ZmlnIF9faW5pdGRhdGEgPSB7DQogc3RhdGljIHZvaWQgX19pbml0DQogZGF2aW5jaV9ldm1fbWFw
X2lvKHZvaWQpDQogew0KKwkvKiBzZXR1cCBpbnB1dCBjb25maWd1cmF0aW9uIGZvciBWUEZFIGlu
cHV0IGRldmljZXMgKi8NCisJZG02NDR4X3NldF92cGZlX2NvbmZpZygmdnBmZV9jZmcpOw0KIAlk
bTY0NHhfaW5pdCgpOw0KIH0NCiANCmRpZmYgLS1naXQgYS9hcmNoL2FybS9tYWNoLWRhdmluY2kv
ZG02NDR4LmMgYi9hcmNoL2FybS9tYWNoLWRhdmluY2kvZG02NDR4LmMNCmluZGV4IGZiNTQ0OWIu
LmNjOGZjNzggMTAwNjQ0DQotLS0gYS9hcmNoL2FybS9tYWNoLWRhdmluY2kvZG02NDR4LmMNCisr
KyBiL2FyY2gvYXJtL21hY2gtZGF2aW5jaS9kbTY0NHguYw0KQEAgLTUzMCw2ICs1MzAsNTkgQEAg
c3RhdGljIHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgZG02NDR4X2VkbWFfZGV2aWNlID0gew0KIAku
cmVzb3VyY2UJCT0gZWRtYV9yZXNvdXJjZXMsDQogfTsNCiANCitzdGF0aWMgc3RydWN0IHJlc291
cmNlIGRtNjQ0eF92cHNzX3Jlc291cmNlc1tdID0gew0KKwl7DQorCQkvKiBWUFNTIEJhc2UgYWRk
cmVzcyAqLw0KKwkJLm5hbWUJCT0gInZwc3MiLA0KKwkJLnN0YXJ0ICAgICAgICAgID0gMHgwMWM3
MzQwMCwNCisJCS5lbmQgICAgICAgICAgICA9IDB4MDFjNzM0MDAgKyAweGZmLA0KKwkJLmZsYWdz
ICAgICAgICAgID0gSU9SRVNPVVJDRV9NRU0sDQorCX0sDQorfTsNCisNCitzdGF0aWMgc3RydWN0
IHBsYXRmb3JtX2RldmljZSBkbTY0NHhfdnBzc19kZXZpY2UgPSB7DQorCS5uYW1lCQkJPSAidnBz
cyIsDQorCS5pZAkJCT0gLTEsDQorCS5kZXYucGxhdGZvcm1fZGF0YQk9ICJkbTY0NHhfdnBzcyIs
DQorCS5udW1fcmVzb3VyY2VzCQk9IEFSUkFZX1NJWkUoZG02NDR4X3Zwc3NfcmVzb3VyY2VzKSwN
CisJLnJlc291cmNlCQk9IGRtNjQ0eF92cHNzX3Jlc291cmNlcywNCit9Ow0KKw0KK3N0YXRpYyBz
dHJ1Y3QgcmVzb3VyY2UgdnBmZV9yZXNvdXJjZXNbXSA9IHsNCisJew0KKwkJLnN0YXJ0ICAgICAg
ICAgID0gSVJRX1ZESU5UMCwNCisJCS5lbmQgICAgICAgICAgICA9IElSUV9WRElOVDAsDQorCQku
ZmxhZ3MgICAgICAgICAgPSBJT1JFU09VUkNFX0lSUSwNCisJfSwNCisJew0KKwkJLnN0YXJ0ICAg
ICAgICAgID0gSVJRX1ZESU5UMSwNCisJCS5lbmQgICAgICAgICAgICA9IElSUV9WRElOVDEsDQor
CQkuZmxhZ3MgICAgICAgICAgPSBJT1JFU09VUkNFX0lSUSwNCisJfSwNCisJew0KKwkJLnN0YXJ0
ICAgICAgICAgID0gMHgwMWM3MDQwMCwNCisJCS5lbmQgICAgICAgICAgICA9IDB4MDFjNzA0MDAg
KyAweGZmLA0KKwkJLmZsYWdzICAgICAgICAgID0gSU9SRVNPVVJDRV9NRU0sDQorCX0sDQorfTsN
CisNCitzdGF0aWMgdTY0IHZwZmVfY2FwdHVyZV9kbWFfbWFzayA9IERNQV9CSVRfTUFTSygzMik7
DQorc3RhdGljIHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgdnBmZV9jYXB0dXJlX2RldiA9IHsNCisJ
Lm5hbWUJCT0gQ0FQVFVSRV9EUlZfTkFNRSwNCisJLmlkCQk9IC0xLA0KKwkubnVtX3Jlc291cmNl
cwk9IEFSUkFZX1NJWkUodnBmZV9yZXNvdXJjZXMpLA0KKwkucmVzb3VyY2UJPSB2cGZlX3Jlc291
cmNlcywNCisJLmRldiA9IHsNCisJCS5kbWFfbWFzawkJPSAmdnBmZV9jYXB0dXJlX2RtYV9tYXNr
LA0KKwkJLmNvaGVyZW50X2RtYV9tYXNrCT0gRE1BX0JJVF9NQVNLKDMyKSwNCisJfSwNCit9Ow0K
Kw0KK3ZvaWQgZG02NDR4X3NldF92cGZlX2NvbmZpZyhzdHJ1Y3QgdnBmZV9jb25maWcgKmNmZykN
Cit7DQorCXZwZmVfY2FwdHVyZV9kZXYuZGV2LnBsYXRmb3JtX2RhdGEgPSBjZmc7DQorfQ0KKw0K
IC8qLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLSovDQogDQogc3RhdGljIHN0cnVjdCBtYXBfZGVzYyBkbTY0NHhfaW9f
ZGVzY1tdID0gew0KQEAgLTY1Miw2ICs3MDUsOSBAQCBzdGF0aWMgaW50IF9faW5pdCBkbTY0NHhf
aW5pdF9kZXZpY2VzKHZvaWQpDQogDQogCXBsYXRmb3JtX2RldmljZV9yZWdpc3RlcigmZG02NDR4
X2VkbWFfZGV2aWNlKTsNCiAJcGxhdGZvcm1fZGV2aWNlX3JlZ2lzdGVyKCZkbTY0NHhfZW1hY19k
ZXZpY2UpOw0KKwlwbGF0Zm9ybV9kZXZpY2VfcmVnaXN0ZXIoJmRtNjQ0eF92cHNzX2RldmljZSk7
DQorCXBsYXRmb3JtX2RldmljZV9yZWdpc3RlcigmdnBmZV9jYXB0dXJlX2Rldik7DQorDQogCXJl
dHVybiAwOw0KIH0NCiBwb3N0Y29yZV9pbml0Y2FsbChkbTY0NHhfaW5pdF9kZXZpY2VzKTsNCmRp
ZmYgLS1naXQgYS9hcmNoL2FybS9tYWNoLWRhdmluY2kvaW5jbHVkZS9tYWNoL2RtNjQ0eC5oIGIv
YXJjaC9hcm0vbWFjaC1kYXZpbmNpL2luY2x1ZGUvbWFjaC9kbTY0NHguaA0KaW5kZXggMTVkNDJi
OS4uMDA2NmRiMyAxMDA2NDQNCi0tLSBhL2FyY2gvYXJtL21hY2gtZGF2aW5jaS9pbmNsdWRlL21h
Y2gvZG02NDR4LmgNCisrKyBiL2FyY2gvYXJtL21hY2gtZGF2aW5jaS9pbmNsdWRlL21hY2gvZG02
NDR4LmgNCkBAIC0yNSw2ICsyNSw3IEBADQogI2luY2x1ZGUgPGxpbnV4L3BsYXRmb3JtX2Rldmlj
ZS5oPg0KICNpbmNsdWRlIDxtYWNoL2hhcmR3YXJlLmg+DQogI2luY2x1ZGUgPG1hY2gvZW1hYy5o
Pg0KKyNpbmNsdWRlIDxtZWRpYS9kYXZpbmNpL3ZwZmVfY2FwdHVyZS5oPg0KIA0KICNkZWZpbmUg
RE02NDRYX0VNQUNfQkFTRQkJKDB4MDFDODAwMDApDQogI2RlZmluZSBETTY0NFhfRU1BQ19DTlRS
TF9PRkZTRVQJKDB4MDAwMCkNCkBAIC0zNCw1ICszNSw2IEBADQogI2RlZmluZSBETTY0NFhfRU1B
Q19DTlRSTF9SQU1fU0laRQkoMHgyMDAwKQ0KIA0KIHZvaWQgX19pbml0IGRtNjQ0eF9pbml0KHZv
aWQpOw0KK3ZvaWQgZG02NDR4X3NldF92cGZlX2NvbmZpZyhzdHJ1Y3QgdnBmZV9jb25maWcgKmNm
Zyk7DQogDQogI2VuZGlmIC8qIF9fQVNNX0FSQ0hfRE02NDRYX0ggKi8NCi0tIA0KMS42LjAuNA0K
DQoNCg==

--_003_20090706202444703hverkuilxs4allnl_
Content-Type: text/x-diff; name="dm355.diff"
Content-Description: dm355.diff
Content-Disposition: attachment; filename="dm355.diff"; size=8556;
	creation-date="Mon, 06 Jul 2009 13:24:56 GMT";
	modification-date="Mon, 06 Jul 2009 13:24:56 GMT"
Content-Transfer-Encoding: base64

RnJvbTogbS1rYXJpY2hlcmkyQHRpLmNvbQ0KVG86IGh2ZXJrdWlsQHhzNGFsbC5ubCwNCiBtY2hl
aGFiQGluZnJhZGVhZC5vcmcNCkNjOiBNdXJhbGlkaGFyYW4gS2FyaWNoZXJpIDxtLWthcmljaGVy
aTJAdGkuY29tPg0KU3ViamVjdDogW1BBVENIIDcvMTEgLSB2M10gRE0zNTUgcGxhdGZvcm0gY2hh
bmdlcyBmb3IgdnBmZSBjYXB0dXJlIGRyaXZlcg0KRGF0ZTogTW9uLCAgNiBKdWwgMjAwOSAxMzoz
Mjo0NSAtMDQwMA0KDQpGcm9tOiBNdXJhbGlkaGFyYW4gS2FyaWNoZXJpIDxtLWthcmljaGVyaTJA
dGkuY29tPg0KDQpETTM1NSBwbGF0Zm9ybSBhbmQgYm9hcmQgc2V0dXANCg0KVGhpcyBoYXMgcGxh
dGZvcm0gYW5kIGJvYXJkIHNldHVwIGNoYW5nZXMgdG8gc3VwcG9ydCB2cGZlIGNhcHR1cmUNCmRy
aXZlciBmb3IgRE0zNTUgRVZNcy4NCg0KUmV2aWV3ZWQgYnk6IEhhbnMgVmVya3VpbCA8aHZlcmt1
aWxAeHM0YWxsLm5sPg0KUmV2aWV3ZWQgYnk6IExhdXJlbnQgUGluY2hhcnQgPGxhdXJlbnQucGlu
Y2hhcnRAc2t5bmV0LmJlPg0KUmV2aWV3ZWQgYnk6IEtldmluIEhpbG1hbiA8a2hpbG1hbkBkZWVw
cm9vdHN5c3RlbXMuY29tPg0KUmV2aWV3ZWQgYnk6IERhdmlkIEJyb3duZWxsIDxkYXZpZC1iQHBh
Y2JlbGwubmV0Pg0KDQpTaWduZWQtb2ZmLWJ5OiBNdXJhbGlkaGFyYW4gS2FyaWNoZXJpIDxtLWth
cmljaGVyaTJAdGkuY29tPg0KLS0tDQpBcHBsaWVzIHRvIExpbnVzJyBHSVQgVHJlZQ0KDQogYXJj
aC9hcm0vbWFjaC1kYXZpbmNpL2JvYXJkLWRtMzU1LWV2bS5jICAgIHwgICA3NiArKysrKysrKysr
KysrKysrKysrKysrKystDQogYXJjaC9hcm0vbWFjaC1kYXZpbmNpL2RtMzU1LmMgICAgICAgICAg
ICAgIHwgICA4MyArKysrKysrKysrKysrKysrKysrKysrKysrKysrDQogYXJjaC9hcm0vbWFjaC1k
YXZpbmNpL2luY2x1ZGUvbWFjaC9kbTM1NS5oIHwgICAgMiArDQogYXJjaC9hcm0vbWFjaC1kYXZp
bmNpL2luY2x1ZGUvbWFjaC9tdXguaCAgIHwgICAgOSArKysNCiA0IGZpbGVzIGNoYW5nZWQsIDE2
NyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvYXJjaC9hcm0v
bWFjaC1kYXZpbmNpL2JvYXJkLWRtMzU1LWV2bS5jIGIvYXJjaC9hcm0vbWFjaC1kYXZpbmNpL2Jv
YXJkLWRtMzU1LWV2bS5jDQppbmRleCA1YWMyZjU2Li42MDViZjAzIDEwMDY0NA0KLS0tIGEvYXJj
aC9hcm0vbWFjaC1kYXZpbmNpL2JvYXJkLWRtMzU1LWV2bS5jDQorKysgYi9hcmNoL2FybS9tYWNo
LWRhdmluY2kvYm9hcmQtZG0zNTUtZXZtLmMNCkBAIC0yMCw2ICsyMCw4IEBADQogI2luY2x1ZGUg
PGxpbnV4L2lvLmg+DQogI2luY2x1ZGUgPGxpbnV4L2dwaW8uaD4NCiAjaW5jbHVkZSA8bGludXgv
Y2xrLmg+DQorI2luY2x1ZGUgPGxpbnV4L3ZpZGVvZGV2Mi5oPg0KKyNpbmNsdWRlIDxtZWRpYS90
dnA1MTR4Lmg+DQogI2luY2x1ZGUgPGxpbnV4L3NwaS9zcGkuaD4NCiAjaW5jbHVkZSA8bGludXgv
c3BpL2VlcHJvbS5oPg0KIA0KQEAgLTEzNSwxMSArMTM3LDExIEBAIHN0YXRpYyB2b2lkIGRtMzU1
ZXZtX21tY3NkX2dwaW9zKHVuc2lnbmVkIGdwaW8pDQogfQ0KIA0KIHN0YXRpYyBzdHJ1Y3QgaTJj
X2JvYXJkX2luZm8gZG0zNTVldm1faTJjX2luZm9bXSA9IHsNCi0JeyBJMkNfQk9BUkRfSU5GTygi
ZG0zNTVldm1fbXNwIiwgMHgyNSksDQorCXsJSTJDX0JPQVJEX0lORk8oImRtMzU1ZXZtX21zcCIs
IDB4MjUpLA0KIAkJLnBsYXRmb3JtX2RhdGEgPSBkbTM1NWV2bV9tbWNzZF9ncGlvcywNCi0JCS8q
IHBsdXMgaXJxICovIH0sDQorCX0sDQorCS8qIHsgcGx1cyBpcnEgIH0sICovDQogCS8qIHsgSTJD
X0JPQVJEX0lORk8oInRsdjMyMGFpYzN4IiwgMHgxYiksIH0sICovDQotCS8qIHsgSTJDX0JPQVJE
X0lORk8oInR2cDUxNDYiLCAweDVkKSwgfSwgKi8NCiB9Ow0KIA0KIHN0YXRpYyB2b2lkIF9faW5p
dCBldm1faW5pdF9pMmModm9pZCkNCkBAIC0xNzgsNiArMTgwLDcyIEBAIHN0YXRpYyBzdHJ1Y3Qg
cGxhdGZvcm1fZGV2aWNlIGRtMzU1ZXZtX2RtOTAwMCA9IHsNCiAJLm51bV9yZXNvdXJjZXMJPSBB
UlJBWV9TSVpFKGRtMzU1ZXZtX2RtOTAwMF9yc3JjKSwNCiB9Ow0KIA0KK3N0YXRpYyBzdHJ1Y3Qg
dHZwNTE0eF9wbGF0Zm9ybV9kYXRhIHR2cDUxNDZfcGRhdGEgPSB7DQorCS5jbGtfcG9sYXJpdHkg
PSAwLA0KKwkuaHNfcG9sYXJpdHkgPSAxLA0KKwkudnNfcG9sYXJpdHkgPSAxDQorfTsNCisNCisj
ZGVmaW5lIFRWUDUxNFhfU1REX0FMTAkoVjRMMl9TVERfTlRTQyB8IFY0TDJfU1REX1BBTCkNCisv
KiBJbnB1dHMgYXZhaWxhYmxlIGF0IHRoZSBUVlA1MTQ2ICovDQorc3RhdGljIHN0cnVjdCB2NGwy
X2lucHV0IHR2cDUxNDZfaW5wdXRzW10gPSB7DQorCXsNCisJCS5pbmRleCA9IDAsDQorCQkubmFt
ZSA9ICJDb21wb3NpdGUiLA0KKwkJLnR5cGUgPSBWNEwyX0lOUFVUX1RZUEVfQ0FNRVJBLA0KKwkJ
LnN0ZCA9IFRWUDUxNFhfU1REX0FMTCwNCisJfSwNCisJew0KKwkJLmluZGV4ID0gMSwNCisJCS5u
YW1lID0gIlMtVmlkZW8iLA0KKwkJLnR5cGUgPSBWNEwyX0lOUFVUX1RZUEVfQ0FNRVJBLA0KKwkJ
LnN0ZCA9IFRWUDUxNFhfU1REX0FMTCwNCisJfSwNCit9Ow0KKw0KKy8qDQorICogdGhpcyBpcyB0
aGUgcm91dGUgaW5mbyBmb3IgY29ubmVjdGluZyBlYWNoIGlucHV0IHRvIGRlY29kZXINCisgKiBv
dXB1dCB0aGF0IGdvZXMgdG8gdnBmZS4gVGhlcmUgaXMgYSBvbmUgdG8gb25lIGNvcnJlc3BvbmRl
bmNlDQorICogd2l0aCB0dnA1MTQ2X2lucHV0cw0KKyAqLw0KK3N0YXRpYyBzdHJ1Y3QgdnBmZV9y
b3V0ZSB0dnA1MTQ2X3JvdXRlc1tdID0gew0KKwl7DQorCQkuaW5wdXQgPSBJTlBVVF9DVkJTX1ZJ
MkIsDQorCQkub3V0cHV0ID0gT1VUUFVUXzEwQklUXzQyMl9FTUJFRERFRF9TWU5DLA0KKwl9LA0K
Kwl7DQorCQkuaW5wdXQgPSBJTlBVVF9TVklERU9fVkkyQ19WSTFDLA0KKwkJLm91dHB1dCA9IE9V
VFBVVF8xMEJJVF80MjJfRU1CRURERURfU1lOQywNCisJfSwNCit9Ow0KKw0KK3N0YXRpYyBzdHJ1
Y3QgdnBmZV9zdWJkZXZfaW5mbyB2cGZlX3N1Yl9kZXZzW10gPSB7DQorCXsNCisJCS5uYW1lID0g
InR2cDUxNDYiLA0KKwkJLmdycF9pZCA9IDAsDQorCQkubnVtX2lucHV0cyA9IEFSUkFZX1NJWkUo
dHZwNTE0Nl9pbnB1dHMpLA0KKwkJLmlucHV0cyA9IHR2cDUxNDZfaW5wdXRzLA0KKwkJLnJvdXRl
cyA9IHR2cDUxNDZfcm91dGVzLA0KKwkJLmNhbl9yb3V0ZSA9IDEsDQorCQkuY2NkY19pZl9wYXJh
bXMgPSB7DQorCQkJLmlmX3R5cGUgPSBWUEZFX0JUNjU2LA0KKwkJCS5oZHBvbCA9IFZQRkVfUElO
UE9MX1BPU0lUSVZFLA0KKwkJCS52ZHBvbCA9IFZQRkVfUElOUE9MX1BPU0lUSVZFLA0KKwkJfSwN
CisJCS5ib2FyZF9pbmZvID0gew0KKwkJCUkyQ19CT0FSRF9JTkZPKCJ0dnA1MTQ2IiwgMHg1ZCks
DQorCQkJLnBsYXRmb3JtX2RhdGEgPSAmdHZwNTE0Nl9wZGF0YSwNCisJCX0sDQorCX0NCit9Ow0K
Kw0KK3N0YXRpYyBzdHJ1Y3QgdnBmZV9jb25maWcgdnBmZV9jZmcgPSB7DQorCS5udW1fc3ViZGV2
cyA9IEFSUkFZX1NJWkUodnBmZV9zdWJfZGV2cyksDQorCS5zdWJfZGV2cyA9IHZwZmVfc3ViX2Rl
dnMsDQorCS5jYXJkX25hbWUgPSAiRE0zNTUgRVZNIiwNCisJLmNjZGMgPSAiRE0zNTUgQ0NEQyIs
DQorfTsNCisNCiBzdGF0aWMgc3RydWN0IHBsYXRmb3JtX2RldmljZSAqZGF2aW5jaV9ldm1fZGV2
aWNlc1tdIF9faW5pdGRhdGEgPSB7DQogCSZkbTM1NWV2bV9kbTkwMDAsDQogCSZkYXZpbmNpX25h
bmRfZGV2aWNlLA0KQEAgLTE4OSw2ICsyNTcsOCBAQCBzdGF0aWMgc3RydWN0IGRhdmluY2lfdWFy
dF9jb25maWcgdWFydF9jb25maWcgX19pbml0ZGF0YSA9IHsNCiANCiBzdGF0aWMgdm9pZCBfX2lu
aXQgZG0zNTVfZXZtX21hcF9pbyh2b2lkKQ0KIHsNCisJLyogc2V0dXAgaW5wdXQgY29uZmlndXJh
dGlvbiBmb3IgVlBGRSBpbnB1dCBkZXZpY2VzICovDQorCWRtMzU1X3NldF92cGZlX2NvbmZpZygm
dnBmZV9jZmcpOw0KIAlkbTM1NV9pbml0KCk7DQogfQ0KIA0KZGlmZiAtLWdpdCBhL2FyY2gvYXJt
L21hY2gtZGF2aW5jaS9kbTM1NS5jIGIvYXJjaC9hcm0vbWFjaC1kYXZpbmNpL2RtMzU1LmMNCmlu
ZGV4IGJhYWFmMzIuLjI2OTZkZjEgMTAwNjQ0DQotLS0gYS9hcmNoL2FybS9tYWNoLWRhdmluY2kv
ZG0zNTUuYw0KKysrIGIvYXJjaC9hcm0vbWFjaC1kYXZpbmNpL2RtMzU1LmMNCkBAIC00ODEsNiAr
NDgxLDE0IEBAIElOVF9DRkcoRE0zNTUsICBJTlRfRURNQV9UQzFfRVJSLCAgICAgNCwgICAgMSwg
ICAgMSwgICAgIGZhbHNlKQ0KIEVWVF9DRkcoRE0zNTUsICBFVlQ4X0FTUDFfVFgsCSAgICAgIDAs
ICAgIDEsICAgIDAsICAgICBmYWxzZSkNCiBFVlRfQ0ZHKERNMzU1LCAgRVZUOV9BU1AxX1JYLAkg
ICAgICAxLCAgICAxLCAgICAwLCAgICAgZmFsc2UpDQogRVZUX0NGRyhETTM1NSwgIEVWVDI2X01N
QzBfUlgsCSAgICAgIDIsICAgIDEsICAgIDAsICAgICBmYWxzZSkNCisNCitNVVhfQ0ZHKERNMzU1
LAlWSU5fUENMSywJMCwgICAxNCwgICAgMSwgICAgMSwJIGZhbHNlKQ0KK01VWF9DRkcoRE0zNTUs
CVZJTl9DQU1fV0VOLAkwLCAgIDEzLCAgICAxLCAgICAxLAkgZmFsc2UpDQorTVVYX0NGRyhETTM1
NSwJVklOX0NBTV9WRCwJMCwgICAxMiwgICAgMSwgICAgMSwJIGZhbHNlKQ0KK01VWF9DRkcoRE0z
NTUsCVZJTl9DQU1fSEQsCTAsICAgMTEsICAgIDEsICAgIDEsCSBmYWxzZSkNCitNVVhfQ0ZHKERN
MzU1LAlWSU5fWUlOX0VOLAkwLCAgIDEwLCAgICAxLCAgICAxLAkgZmFsc2UpDQorTVVYX0NGRyhE
TTM1NSwJVklOX0NJTkxfRU4sCTAsICAgMCwgICAweGZmLCAweDU1LAkgZmFsc2UpDQorTVVYX0NG
RyhETTM1NSwJVklOX0NJTkhfRU4sCTAsICAgOCwgICAgIDMsICAgIDMsCSBmYWxzZSkNCiAjZW5k
aWYNCiB9Ow0KIA0KQEAgLTYwNCw2ICs2MTIsNjcgQEAgc3RhdGljIHN0cnVjdCBwbGF0Zm9ybV9k
ZXZpY2UgZG0zNTVfZWRtYV9kZXZpY2UgPSB7DQogCS5yZXNvdXJjZQkJPSBlZG1hX3Jlc291cmNl
cywNCiB9Ow0KIA0KK3N0YXRpYyBzdHJ1Y3QgcmVzb3VyY2UgZG0zNTVfdnBzc19yZXNvdXJjZXNb
XSA9IHsNCisJew0KKwkJLyogVlBTUyBCTCBCYXNlIGFkZHJlc3MgKi8NCisJCS5uYW1lCQk9ICJ2
cHNzIiwNCisJCS5zdGFydCAgICAgICAgICA9IDB4MDFjNzA4MDAsDQorCQkuZW5kICAgICAgICAg
ICAgPSAweDAxYzcwODAwICsgMHhmZiwNCisJCS5mbGFncyAgICAgICAgICA9IElPUkVTT1VSQ0Vf
TUVNLA0KKwl9LA0KKwl7DQorCQkvKiBWUFNTIENMSyBCYXNlIGFkZHJlc3MgKi8NCisJCS5uYW1l
CQk9ICJ2cHNzIiwNCisJCS5zdGFydCAgICAgICAgICA9IDB4MDFjNzAwMDAsDQorCQkuZW5kICAg
ICAgICAgICAgPSAweDAxYzcwMDAwICsgMHhmLA0KKwkJLmZsYWdzICAgICAgICAgID0gSU9SRVNP
VVJDRV9NRU0sDQorCX0sDQorfTsNCisNCitzdGF0aWMgc3RydWN0IHBsYXRmb3JtX2RldmljZSBk
bTM1NV92cHNzX2RldmljZSA9IHsNCisJLm5hbWUJCQk9ICJ2cHNzIiwNCisJLmlkCQkJPSAtMSwN
CisJLmRldi5wbGF0Zm9ybV9kYXRhCT0gImRtMzU1X3Zwc3MiLA0KKwkubnVtX3Jlc291cmNlcwkJ
PSBBUlJBWV9TSVpFKGRtMzU1X3Zwc3NfcmVzb3VyY2VzKSwNCisJLnJlc291cmNlCQk9IGRtMzU1
X3Zwc3NfcmVzb3VyY2VzLA0KK307DQorDQorc3RhdGljIHN0cnVjdCByZXNvdXJjZSB2cGZlX3Jl
c291cmNlc1tdID0gew0KKwl7DQorCQkuc3RhcnQgICAgICAgICAgPSBJUlFfVkRJTlQwLA0KKwkJ
LmVuZCAgICAgICAgICAgID0gSVJRX1ZESU5UMCwNCisJCS5mbGFncyAgICAgICAgICA9IElPUkVT
T1VSQ0VfSVJRLA0KKwl9LA0KKwl7DQorCQkuc3RhcnQgICAgICAgICAgPSBJUlFfVkRJTlQxLA0K
KwkJLmVuZCAgICAgICAgICAgID0gSVJRX1ZESU5UMSwNCisJCS5mbGFncyAgICAgICAgICA9IElP
UkVTT1VSQ0VfSVJRLA0KKwl9LA0KKwkvKiBDQ0RDIEJhc2UgYWRkcmVzcyAqLw0KKwl7DQorCQku
ZmxhZ3MgICAgICAgICAgPSBJT1JFU09VUkNFX01FTSwNCisJCS5zdGFydCAgICAgICAgICA9IDB4
MDFjNzA2MDAsDQorCQkuZW5kICAgICAgICAgICAgPSAweDAxYzcwNjAwICsgMHgxZmYsDQorCX0s
DQorfTsNCisNCitzdGF0aWMgdTY0IHZwZmVfY2FwdHVyZV9kbWFfbWFzayA9IERNQV9CSVRfTUFT
SygzMik7DQorc3RhdGljIHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgdnBmZV9jYXB0dXJlX2RldiA9
IHsNCisJLm5hbWUJCT0gQ0FQVFVSRV9EUlZfTkFNRSwNCisJLmlkCQk9IC0xLA0KKwkubnVtX3Jl
c291cmNlcwk9IEFSUkFZX1NJWkUodnBmZV9yZXNvdXJjZXMpLA0KKwkucmVzb3VyY2UJPSB2cGZl
X3Jlc291cmNlcywNCisJLmRldiA9IHsNCisJCS5kbWFfbWFzawkJPSAmdnBmZV9jYXB0dXJlX2Rt
YV9tYXNrLA0KKwkJLmNvaGVyZW50X2RtYV9tYXNrCT0gRE1BX0JJVF9NQVNLKDMyKSwNCisJfSwN
Cit9Ow0KKw0KK3ZvaWQgZG0zNTVfc2V0X3ZwZmVfY29uZmlnKHN0cnVjdCB2cGZlX2NvbmZpZyAq
Y2ZnKQ0KK3sNCisJdnBmZV9jYXB0dXJlX2Rldi5kZXYucGxhdGZvcm1fZGF0YSA9IGNmZzsNCit9
DQorDQogLyotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tKi8NCiANCiBzdGF0aWMgc3RydWN0IG1hcF9kZXNjIGRtMzU1
X2lvX2Rlc2NbXSA9IHsNCkBAIC03MjUsNiArNzk0LDIwIEBAIHN0YXRpYyBpbnQgX19pbml0IGRt
MzU1X2luaXRfZGV2aWNlcyh2b2lkKQ0KIA0KIAlkYXZpbmNpX2NmZ19yZWcoRE0zNTVfSU5UX0VE
TUFfQ0MpOw0KIAlwbGF0Zm9ybV9kZXZpY2VfcmVnaXN0ZXIoJmRtMzU1X2VkbWFfZGV2aWNlKTsN
CisJcGxhdGZvcm1fZGV2aWNlX3JlZ2lzdGVyKCZkbTM1NV92cHNzX2RldmljZSk7DQorCS8qDQor
CSAqIHNldHVwIE11eCBjb25maWd1cmF0aW9uIGZvciB2cGZlIGlucHV0IGFuZCByZWdpc3Rlcg0K
KwkgKiB2cGZlIGNhcHR1cmUgcGxhdGZvcm0gZGV2aWNlDQorCSAqLw0KKwlkYXZpbmNpX2NmZ19y
ZWcoRE0zNTVfVklOX1BDTEspOw0KKwlkYXZpbmNpX2NmZ19yZWcoRE0zNTVfVklOX0NBTV9XRU4p
Ow0KKwlkYXZpbmNpX2NmZ19yZWcoRE0zNTVfVklOX0NBTV9WRCk7DQorCWRhdmluY2lfY2ZnX3Jl
ZyhETTM1NV9WSU5fQ0FNX0hEKTsNCisJZGF2aW5jaV9jZmdfcmVnKERNMzU1X1ZJTl9ZSU5fRU4p
Ow0KKwlkYXZpbmNpX2NmZ19yZWcoRE0zNTVfVklOX0NJTkxfRU4pOw0KKwlkYXZpbmNpX2NmZ19y
ZWcoRE0zNTVfVklOX0NJTkhfRU4pOw0KKwlwbGF0Zm9ybV9kZXZpY2VfcmVnaXN0ZXIoJnZwZmVf
Y2FwdHVyZV9kZXYpOw0KKw0KIAlyZXR1cm4gMDsNCiB9DQogcG9zdGNvcmVfaW5pdGNhbGwoZG0z
NTVfaW5pdF9kZXZpY2VzKTsNCmRpZmYgLS1naXQgYS9hcmNoL2FybS9tYWNoLWRhdmluY2kvaW5j
bHVkZS9tYWNoL2RtMzU1LmggYi9hcmNoL2FybS9tYWNoLWRhdmluY2kvaW5jbHVkZS9tYWNoL2Rt
MzU1LmgNCmluZGV4IDU0OTAzYjcuLmUyODcxM2MgMTAwNjQ0DQotLS0gYS9hcmNoL2FybS9tYWNo
LWRhdmluY2kvaW5jbHVkZS9tYWNoL2RtMzU1LmgNCisrKyBiL2FyY2gvYXJtL21hY2gtZGF2aW5j
aS9pbmNsdWRlL21hY2gvZG0zNTUuaA0KQEAgLTEyLDExICsxMiwxMyBAQA0KICNkZWZpbmUgX19B
U01fQVJDSF9ETTM1NV9IDQogDQogI2luY2x1ZGUgPG1hY2gvaGFyZHdhcmUuaD4NCisjaW5jbHVk
ZSA8bWVkaWEvZGF2aW5jaS92cGZlX2NhcHR1cmUuaD4NCiANCiBzdHJ1Y3Qgc3BpX2JvYXJkX2lu
Zm87DQogDQogdm9pZCBfX2luaXQgZG0zNTVfaW5pdCh2b2lkKTsNCiB2b2lkIGRtMzU1X2luaXRf
c3BpMCh1bnNpZ25lZCBjaGlwc2VsZWN0X21hc2ssDQogCQlzdHJ1Y3Qgc3BpX2JvYXJkX2luZm8g
KmluZm8sIHVuc2lnbmVkIGxlbik7DQordm9pZCBkbTM1NV9zZXRfdnBmZV9jb25maWcoc3RydWN0
IHZwZmVfY29uZmlnICpjZmcpOw0KIA0KICNlbmRpZiAvKiBfX0FTTV9BUkNIX0RNMzU1X0ggKi8N
CmRpZmYgLS1naXQgYS9hcmNoL2FybS9tYWNoLWRhdmluY2kvaW5jbHVkZS9tYWNoL211eC5oIGIv
YXJjaC9hcm0vbWFjaC1kYXZpbmNpL2luY2x1ZGUvbWFjaC9tdXguaA0KaW5kZXggMjczNzg0NS4u
ZjI4ODA2MyAxMDA2NDQNCi0tLSBhL2FyY2gvYXJtL21hY2gtZGF2aW5jaS9pbmNsdWRlL21hY2gv
bXV4LmgNCisrKyBiL2FyY2gvYXJtL21hY2gtZGF2aW5jaS9pbmNsdWRlL21hY2gvbXV4LmgNCkBA
IC0xNTQsNiArMTU0LDE1IEBAIGVudW0gZGF2aW5jaV9kbTM1NV9pbmRleCB7DQogCURNMzU1X0VW
VDhfQVNQMV9UWCwNCiAJRE0zNTVfRVZUOV9BU1AxX1JYLA0KIAlETTM1NV9FVlQyNl9NTUMwX1JY
LA0KKw0KKwkvKiBWaWRlbyBJbiBQaW4gTXV4ICovDQorCURNMzU1X1ZJTl9QQ0xLLA0KKwlETTM1
NV9WSU5fQ0FNX1dFTiwNCisJRE0zNTVfVklOX0NBTV9WRCwNCisJRE0zNTVfVklOX0NBTV9IRCwN
CisJRE0zNTVfVklOX1lJTl9FTiwNCisJRE0zNTVfVklOX0NJTkxfRU4sDQorCURNMzU1X1ZJTl9D
SU5IX0VOLA0KIH07DQogDQogI2lmZGVmIENPTkZJR19EQVZJTkNJX01VWA0KLS0gDQoxLjYuMC40
DQoNCg0K

--_003_20090706202444703hverkuilxs4allnl_--

--_002_A69FA2915331DC488A831521EAE36FE40144D81EB5dlee06enttico_--
