Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:37785 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757888Ab1COOBa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2011 10:01:30 -0400
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	Sekhar Nori <nsekhar@ti.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v17 12/13] davinci: dm644x: add support for v4l2 video display
Date: Tue, 15 Mar 2011 19:29:40 +0530
Message-Id: <1300197580-5029-1-git-send-email-manjunath.hadli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Create platform devices for various video modules like venc,osd,
vpbe and v4l2 driver for dm644x.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 arch/arm/mach-davinci/dm644x.c              |  130 ++++++++++++++++++++++++++-
 arch/arm/mach-davinci/include/mach/dm644x.h |    4 +
 2 files changed, 131 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 41e8866..aaa8f4d 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -619,7 +619,7 @@ static struct resource dm644x_vpfe_resources[] = {
 	},
 };
 
-static u64 vpfe_capture_dma_mask = DMA_BIT_MASK(32);
+static u64 dm644x_video_dma_mask = DMA_BIT_MASK(32);
 static struct resource dm644x_ccdc_resource[] = {
 	/* CCDC Base address */
 	{
@@ -635,7 +635,7 @@ static struct platform_device dm644x_ccdc_dev = {
 	.num_resources  = ARRAY_SIZE(dm644x_ccdc_resource),
 	.resource       = dm644x_ccdc_resource,
 	.dev = {
-		.dma_mask               = &vpfe_capture_dma_mask,
+		.dma_mask               = &dm644x_video_dma_mask,
 		.coherent_dma_mask      = DMA_BIT_MASK(32),
 	},
 };
@@ -646,7 +646,127 @@ static struct platform_device dm644x_vpfe_dev = {
 	.num_resources	= ARRAY_SIZE(dm644x_vpfe_resources),
 	.resource	= dm644x_vpfe_resources,
 	.dev = {
-		.dma_mask		= &vpfe_capture_dma_mask,
+		.dma_mask		= &dm644x_video_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
+
+#define DM644X_OSD_REG_BASE		0x01C72600
+
+static struct resource dm644x_osd_resources[] = {
+	{
+		.start	= DM644X_OSD_REG_BASE,
+		.end	= DM644X_OSD_REG_BASE + 0x1ff,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct osd_platform_data dm644x_osd_data = {
+	.vpbe_type     = VPBE_VERSION_1,
+};
+
+static struct platform_device dm644x_osd_dev = {
+	.name		= VPBE_OSD_SUBDEV_NAME,
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(dm644x_osd_resources),
+	.resource	= dm644x_osd_resources,
+	.dev		= {
+		.dma_mask		= &dm644x_video_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+		.platform_data		= &dm644x_osd_data,
+	},
+};
+
+#define DM644X_VENC_REG_BASE		0x01C72400
+
+static struct resource dm644x_venc_resources[] = {
+	{
+		.start	= DM644X_VENC_REG_BASE,
+		.end	= DM644X_VENC_REG_BASE + 0x17f,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static int dm644x_venc_setup_clock(enum vpbe_enc_timings_type type,
+				   unsigned int mode)
+{
+	int ret = 0;
+	void __iomem *vpss_clkctl_reg;
+
+	vpss_clkctl_reg = DAVINCI_SYSMODULE_VIRT(0x44);
+
+	switch (type) {
+	case VPBE_ENC_STD:
+		writel(0x18, vpss_clkctl_reg);
+		break;
+	case VPBE_ENC_DV_PRESET:
+		switch ((unsigned int)mode) {
+		case V4L2_DV_480P59_94:
+		case V4L2_DV_576P50:
+			writel(0x19, vpss_clkctl_reg);
+			break;
+		case V4L2_DV_720P60:
+		case V4L2_DV_1080I60:
+		case V4L2_DV_1080P30:
+			/*
+			 * For HD, use external clock source since
+			 * HD requires higher clock rate
+			 */
+			writel(0xa, vpss_clkctl_reg);
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+		break;
+	default:
+		ret  = -EINVAL;
+	}
+
+	return ret;
+}
+
+static struct resource dm644x_v4l2_disp_resources[] = {
+	{
+		.start	= IRQ_VENCINT,
+		.end	= IRQ_VENCINT,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device dm644x_vpbe_display = {
+	.name		= "vpbe-v4l2",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(dm644x_v4l2_disp_resources),
+	.resource	= dm644x_v4l2_disp_resources,
+	.dev		= {
+		.dma_mask		= &dm644x_video_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
+
+struct venc_platform_data dm644x_venc_pdata = {
+	.venc_type	= VPBE_VERSION_1,
+	.setup_clock	= dm644x_venc_setup_clock,
+};
+
+static struct platform_device dm644x_venc_dev = {
+	.name		= VPBE_VENC_SUBDEV_NAME,
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(dm644x_venc_resources),
+	.resource	= dm644x_venc_resources,
+	.dev		= {
+		.dma_mask		= &dm644x_video_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+		.platform_data		= &dm644x_venc_pdata,
+	},
+};
+
+static struct platform_device dm644x_vpbe_dev = {
+	.name		= "vpbe_controller",
+	.id		= -1,
+	.dev		= {
+		.dma_mask		= &dm644x_video_dma_mask,
 		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 };
@@ -783,6 +903,10 @@ static struct platform_device *dm644x_video_devices[] __initdata = {
 	&dm644x_vpss_device,
 	&dm644x_ccdc_dev,
 	&dm644x_vpfe_dev,
+	&dm644x_osd_dev,
+	&dm644x_venc_dev,
+	&dm644x_vpbe_dev,
+	&dm644x_vpbe_display,
 };
 
 int __init dm644x_init_video(struct vpfe_config *vpfe_cfg)
diff --git a/arch/arm/mach-davinci/include/mach/dm644x.h b/arch/arm/mach-davinci/include/mach/dm644x.h
index 29a9e24..d18a2e5 100644
--- a/arch/arm/mach-davinci/include/mach/dm644x.h
+++ b/arch/arm/mach-davinci/include/mach/dm644x.h
@@ -26,6 +26,10 @@
 #include <mach/hardware.h>
 #include <mach/asp.h>
 #include <media/davinci/vpfe_capture.h>
+#include <media/davinci/vpbe_types.h>
+#include <media/davinci/vpbe.h>
+#include <media/davinci/vpss.h>
+#include <media/davinci/vpbe_osd.h>
 
 #define DM644X_EMAC_BASE		(0x01C80000)
 #define DM644X_EMAC_MDIO_BASE		(DM644X_EMAC_BASE + 0x4000)
-- 
1.6.2.4

