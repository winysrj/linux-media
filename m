Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60168 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871AbbLWMct (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2015 07:32:49 -0500
Date: Wed, 23 Dec 2015 10:32:42 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, javier@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
	=?UTF-8?B?QmVu?= =?UTF-8?B?b8OudA==?= Cousson
	<bcousson@baylibre.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 00/23] Unrestricted media entity ID range support
Message-ID: <20151223103242.44deaea4@recife.lan>
In-Reply-To: <20151216140301.GO17128@valkosipuli.retiisi.org.uk>
References: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
	<20151216140301.GO17128@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 16 Dec 2015 16:03:01 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Javier,
> 
> On Wed, Dec 16, 2015 at 03:32:15PM +0200, Sakari Ailus wrote:
> > This is the third version of the unrestricted media entity ID range
> > support set. I've taken Mauro's comments into account and fixed a number
> > of bugs as well (omap3isp memory leak and omap4iss stream start).
> 
> Javier: Mauro told me you might have OMAP4 hardware. Would you be able to
> test the OMAP4 ISS with these patches?
> 
> Thanks.
> 

Sakari,

Testing with OMAP4 is not possible. The driver is broken: it doesn't
support DT, and the required pdata definition is missing.

Both Javier and I tried to fix it in the last couple days, in order to test
it with a PandaBoard. We came with the enclosed patch, but it is still 
incomplete. Based on what's written on this e-mail:
	 https://www.mail-archive.com/linux-media@vger.kernel.org/msg89247.html

It seems that this is an already known issue.

So, I'm considering this driver as BROKEN. Not much sense on doing any
tests on it, while this doesn't get fixed.

Regards,
Mauro

PS.: With the enclosed patch, I got this error:
	[    0.267639] platform omap4iss: failed to claim resource 2

But, even if I comment out the platform code that returns this error,
there are still other missing things:
	[    7.131622] omap4iss omap4iss: Unable to get iss_fck clock info
	[    7.137878] omap4iss omap4iss: Unable to get clocks

---

ARM: add a pdata quirks for OMAP4 panda camera
    
This is a hack to make it to believe that the pandaboard
has a camera.


diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 1dfe34654c43..998bb6936dc0 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -36,6 +36,8 @@
 #include "soc.h"
 #include "hsmmc.h"
 
+#include "../../../drivers/staging/media/omap4iss/iss.h"
+
 struct pdata_init {
 	const char *compatible;
 	void (*fn)(void);
@@ -408,6 +410,124 @@ static void __init t410_abort_init(void)
 }
 #endif
 
+#ifdef CONFIG_ARCH_OMAP4
+
+static struct resource panda_iss_resource[] = {
+	{
+		.start = 0x52000000,
+		.end = 0x52000000 + 0x100,
+		.name = "top",
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = 0x52001000,
+		.end = 0x52001000 + 0x170,
+		.name = "csi2_a_regs1",
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = 0x52001170,
+		.end = 0x52001170 + 0x020,
+		.name = "camerarx_core1",
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = 0x52001400,
+		.end = 0x52001400 + 0x170,
+		.name = "csi2_b_regs1",
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = 0x52001570,
+		.end = 0x52001570 + 0x020,
+		.name = "camerarx_core2",
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = 0x52002000,
+		.end = 0x52002000 + 0x200,
+		.name = "bte",
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = 0x52010000,
+		.end = 0x52010000 + 0x0a0,
+		.name = "isp_sys1",
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = 0x52010400,
+		.end = 0x52010400 + 0x400,
+		.name = "isp_resizer",
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = 0x52010800,
+		.end = 0x52010800 + 0x800,
+		.name = "isp_ipipe",
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = 0x52011000,
+		.end = 0x52011000 + 0x200,
+		.name = "isp_isif",
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = 0x52011200,
+		.end = 0x52011200 + 0x080,
+		.name = "isp_ipipeif",
+		.flags = IORESOURCE_MEM,
+	}
+};
+
+static struct i2c_board_info panda_camera_i2c_device = {
+	I2C_BOARD_INFO("smia", 0x10),
+};
+
+static struct iss_subdev_i2c_board_info panda_camera_subdevs[] = {
+	{
+		.board_info = &panda_camera_i2c_device,
+		.i2c_adapter_id = 3,
+	},
+};
+
+static struct iss_v4l2_subdevs_group iss_subdevs[] = {
+	{
+		.subdevs = panda_camera_subdevs,
+		.interface = ISS_INTERFACE_CSI2A_PHY1,
+		.bus = {
+			.csi2 = {
+				.lanecfg = {
+					.clk = {
+						.pol = 0,
+						.pos = 2,
+					},
+					.data[0] = {
+						.pol = 0,
+						.pos = 1,
+					},
+					.data[1] = {
+						.pol = 0,
+						.pos = 3,
+					},
+				},
+			} },
+	},
+	{ /* sentinel */ },
+};
+
+static struct iss_platform_data iss_pdata = {
+	.subdevs = iss_subdevs,
+};
+
+static struct platform_device omap4iss_device = {
+	.name           = "omap4iss",
+	.id             = -1,
+	.dev = {
+		.platform_data = &iss_pdata,
+	},
+	.num_resources  = ARRAY_SIZE(panda_iss_resource),
+	.resource       = panda_iss_resource,
+};
+
+static void __init omap4_panda_legacy_init(void)
+{
+	platform_device_register(&omap4iss_device);
+}
+
+#endif /* CONFIG_ARCH_OMAP4 */
+
 #if defined(CONFIG_ARCH_OMAP4) || defined(CONFIG_SOC_OMAP5)
 static struct iommu_platform_data omap4_iommu_pdata = {
 	.reset_name = "mmu_cache",
@@ -539,6 +659,9 @@ static struct pdata_init pdata_quirks[] __initdata = {
 #ifdef CONFIG_SOC_TI81XX
 	{ "hp,t410", t410_abort_init, },
 #endif
+#ifdef CONFIG_ARCH_OMAP4
+	{ "ti,omap4-panda", omap4_panda_legacy_init, },
+#endif
 #ifdef CONFIG_SOC_OMAP5
 	{ "ti,omap5-uevm", omap5_uevm_legacy_init, },
 #endif

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 30b473cfb020..b528cacda17b 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -1412,6 +1412,9 @@ static int iss_probe(struct platform_device *pdev)
 	unsigned int i;
 	int ret;
 
+
+printk("%s: pdata=%p\n", __func__, pdata);
+
 	if (!pdata)
 		return -EINVAL;
 
@@ -1437,24 +1440,33 @@ static int iss_probe(struct platform_device *pdev)
 	iss->syscon = syscon_regmap_lookup_by_compatible("syscon");
 	if (IS_ERR(iss->syscon)) {
 		ret = PTR_ERR(iss->syscon);
+		dev_err(iss->dev, "Unable to find syscon");
 		goto error;
 	}
 
 	/* Clocks */
 	ret = iss_map_mem_resource(pdev, iss, OMAP4_ISS_MEM_TOP);
-	if (ret < 0)
+	if (ret < 0) {
+		dev_err(iss->dev, "Unable to map memory resource\n");
 		goto error;
+	}
 
 	ret = iss_get_clocks(iss);
-	if (ret < 0)
+	if (ret < 0) {
+		dev_err(iss->dev, "Unable to get clocks\n");
 		goto error;
+	}
 
-	if (!omap4iss_get(iss))
+	if (!omap4iss_get(iss)) {
+		dev_err(iss->dev, "Failed to acquire ISS resource\n");
 		goto error;
+	}
 
 	ret = iss_reset(iss);
-	if (ret < 0)
+	if (ret < 0) {
+		dev_err(iss->dev, "Unable to reset ISS\n");
 		goto error_iss;
+	}
 
 	iss->revision = iss_reg_read(iss, OMAP4_ISS_MEM_TOP, ISS_HL_REVISION);
 	dev_info(iss->dev, "Revision %08x found\n", iss->revision);
