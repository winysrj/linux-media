Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47825 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab2ITGro (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 02:47:44 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr13so4370308pbb.19
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2012 23:47:44 -0700 (PDT)
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Shawn Guo <shawn.guo@linaro.org>, linux-media@vger.kernel.org
Subject: [PATCH v2 27/34] media: mx2_camera: remove cpu_is_xxx by using platform_device_id
Date: Thu, 20 Sep 2012 14:45:40 +0800
Message-Id: <1348123547-31082-28-git-send-email-shawn.guo@linaro.org>
In-Reply-To: <1348123547-31082-1-git-send-email-shawn.guo@linaro.org>
References: <1348123547-31082-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It changes the driver to use platform_device_id rather than cpu_is_xxx
to determine the controller type, and updates the platform code
accordingly.

As the result, mach/hardware.h inclusion gets removed from the driver.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Tested-by: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org
---
 arch/arm/mach-imx/clk-imx25.c                   |    6 +-
 arch/arm/mach-imx/clk-imx27.c                   |    6 +-
 arch/arm/mach-imx/devices/devices-common.h      |    1 +
 arch/arm/mach-imx/devices/platform-mx2-camera.c |   12 +--
 drivers/media/video/mx2_camera.c                |   95 +++++++++++++++++------
 5 files changed, 85 insertions(+), 35 deletions(-)

diff --git a/arch/arm/mach-imx/clk-imx25.c b/arch/arm/mach-imx/clk-imx25.c
index 1aea073..71fe521 100644
--- a/arch/arm/mach-imx/clk-imx25.c
+++ b/arch/arm/mach-imx/clk-imx25.c
@@ -231,9 +231,9 @@ int __init mx25_clocks_init(void)
 	clk_register_clkdev(clk[esdhc2_ipg_per], "per", "sdhci-esdhc-imx25.1");
 	clk_register_clkdev(clk[esdhc2_ipg], "ipg", "sdhci-esdhc-imx25.1");
 	clk_register_clkdev(clk[esdhc2_ahb], "ahb", "sdhci-esdhc-imx25.1");
-	clk_register_clkdev(clk[csi_ipg_per], "per", "mx2-camera.0");
-	clk_register_clkdev(clk[csi_ipg], "ipg", "mx2-camera.0");
-	clk_register_clkdev(clk[csi_ahb], "ahb", "mx2-camera.0");
+	clk_register_clkdev(clk[csi_ipg_per], "per", "imx25-camera.0");
+	clk_register_clkdev(clk[csi_ipg], "ipg", "imx25-camera.0");
+	clk_register_clkdev(clk[csi_ahb], "ahb", "imx25-camera.0");
 	clk_register_clkdev(clk[dummy], "audmux", NULL);
 	clk_register_clkdev(clk[can1_ipg], NULL, "flexcan.0");
 	clk_register_clkdev(clk[can2_ipg], NULL, "flexcan.1");
diff --git a/arch/arm/mach-imx/clk-imx27.c b/arch/arm/mach-imx/clk-imx27.c
index 82cb785..f4ec05e 100644
--- a/arch/arm/mach-imx/clk-imx27.c
+++ b/arch/arm/mach-imx/clk-imx27.c
@@ -224,7 +224,7 @@ int __init mx27_clocks_init(unsigned long fref)
 	clk_register_clkdev(clk[per3_gate], "per", "imx-fb.0");
 	clk_register_clkdev(clk[lcdc_ipg_gate], "ipg", "imx-fb.0");
 	clk_register_clkdev(clk[lcdc_ahb_gate], "ahb", "imx-fb.0");
-	clk_register_clkdev(clk[csi_ahb_gate], "ahb", "mx2-camera.0");
+	clk_register_clkdev(clk[csi_ahb_gate], "ahb", "imx27-camera.0");
 	clk_register_clkdev(clk[usb_div], "per", "fsl-usb2-udc");
 	clk_register_clkdev(clk[usb_ipg_gate], "ipg", "fsl-usb2-udc");
 	clk_register_clkdev(clk[usb_ahb_gate], "ahb", "fsl-usb2-udc");
@@ -251,8 +251,8 @@ int __init mx27_clocks_init(unsigned long fref)
 	clk_register_clkdev(clk[i2c2_ipg_gate], NULL, "imx21-i2c.1");
 	clk_register_clkdev(clk[owire_ipg_gate], NULL, "mxc_w1.0");
 	clk_register_clkdev(clk[kpp_ipg_gate], NULL, "imx-keypad");
-	clk_register_clkdev(clk[emma_ahb_gate], "emma-ahb", "mx2-camera.0");
-	clk_register_clkdev(clk[emma_ipg_gate], "emma-ipg", "mx2-camera.0");
+	clk_register_clkdev(clk[emma_ahb_gate], "emma-ahb", "imx27-camera.0");
+	clk_register_clkdev(clk[emma_ipg_gate], "emma-ipg", "imx27-camera.0");
 	clk_register_clkdev(clk[emma_ahb_gate], "ahb", "m2m-emmaprp.0");
 	clk_register_clkdev(clk[emma_ipg_gate], "ipg", "m2m-emmaprp.0");
 	clk_register_clkdev(clk[iim_ipg_gate], "iim", NULL);
diff --git a/arch/arm/mach-imx/devices/devices-common.h b/arch/arm/mach-imx/devices/devices-common.h
index 7f2698c..8112a1a 100644
--- a/arch/arm/mach-imx/devices/devices-common.h
+++ b/arch/arm/mach-imx/devices/devices-common.h
@@ -202,6 +202,7 @@ struct platform_device *__init imx_add_mx3_sdc_fb(
 
 #include <linux/platform_data/camera-mx2.h>
 struct imx_mx2_camera_data {
+	const char *devid;
 	resource_size_t iobasecsi;
 	resource_size_t iosizecsi;
 	resource_size_t irqcsi;
diff --git a/arch/arm/mach-imx/devices/platform-mx2-camera.c b/arch/arm/mach-imx/devices/platform-mx2-camera.c
index 9ad5b2d..b88877d 100644
--- a/arch/arm/mach-imx/devices/platform-mx2-camera.c
+++ b/arch/arm/mach-imx/devices/platform-mx2-camera.c
@@ -9,14 +9,16 @@
 #include <mach/hardware.h>
 #include "devices-common.h"
 
-#define imx_mx2_camera_data_entry_single(soc)				\
+#define imx_mx2_camera_data_entry_single(soc, _devid)			\
 	{								\
+		.devid = _devid,					\
 		.iobasecsi = soc ## _CSI_BASE_ADDR,			\
 		.iosizecsi = SZ_4K,					\
 		.irqcsi = soc ## _INT_CSI,				\
 	}
-#define imx_mx2_camera_data_entry_single_emma(soc)			\
+#define imx_mx2_camera_data_entry_single_emma(soc, _devid)		\
 	{								\
+		.devid = _devid,					\
 		.iobasecsi = soc ## _CSI_BASE_ADDR,			\
 		.iosizecsi = SZ_32,					\
 		.irqcsi = soc ## _INT_CSI,				\
@@ -27,12 +29,12 @@
 
 #ifdef CONFIG_SOC_IMX25
 const struct imx_mx2_camera_data imx25_mx2_camera_data __initconst =
-	imx_mx2_camera_data_entry_single(MX25);
+	imx_mx2_camera_data_entry_single(MX25, "imx25-camera");
 #endif /* ifdef CONFIG_SOC_IMX25 */
 
 #ifdef CONFIG_SOC_IMX27
 const struct imx_mx2_camera_data imx27_mx2_camera_data __initconst =
-	imx_mx2_camera_data_entry_single_emma(MX27);
+	imx_mx2_camera_data_entry_single_emma(MX27, "imx27-camera");
 #endif /* ifdef CONFIG_SOC_IMX27 */
 
 struct platform_device *__init imx_add_mx2_camera(
@@ -58,7 +60,7 @@ struct platform_device *__init imx_add_mx2_camera(
 			.flags = IORESOURCE_IRQ,
 		},
 	};
-	return imx_add_platform_device_dmamask("mx2-camera", 0,
+	return imx_add_platform_device_dmamask(data->devid, 0,
 			res, data->iobaseemmaprp ? 4 : 2,
 			pdata, sizeof(*pdata), DMA_BIT_MASK(32));
 }
diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 9bb9e8c..64c52dc 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -41,7 +41,6 @@
 #include <linux/videodev2.h>
 
 #include <linux/platform_data/camera-mx2.h>
-#include <mach/hardware.h>
 
 #include <asm/dma.h>
 
@@ -121,11 +120,13 @@
 
 #define CSICR1			0x00
 #define CSICR2			0x04
-#define CSISR			(cpu_is_mx27() ? 0x08 : 0x18)
+#define CSISR_IMX25		0x18
+#define CSISR_IMX27		0x08
 #define CSISTATFIFO		0x0c
 #define CSIRFIFO		0x10
 #define CSIRXCNT		0x14
-#define CSICR3			(cpu_is_mx27() ? 0x1C : 0x08)
+#define CSICR3_IMX25		0x08
+#define CSICR3_IMX27		0x1c
 #define CSIDMASA_STATFIFO	0x20
 #define CSIDMATA_STATFIFO	0x24
 #define CSIDMASA_FB1		0x28
@@ -268,6 +269,11 @@ struct mx2_buffer {
 	struct mx2_buf_internal		internal;
 };
 
+enum mx2_camera_type {
+	IMX25_CAMERA,
+	IMX27_CAMERA,
+};
+
 struct mx2_camera_dev {
 	struct device		*dev;
 	struct soc_camera_host	soc_host;
@@ -291,6 +297,9 @@ struct mx2_camera_dev {
 	struct mx2_buffer	*fb2_active;
 
 	u32			csicr1;
+	u32			reg_csisr;
+	u32			reg_csicr3;
+	enum mx2_camera_type	devtype;
 
 	struct mx2_buf_internal buf_discard[2];
 	void			*discard_buffer;
@@ -303,6 +312,29 @@ struct mx2_camera_dev {
 	struct vb2_alloc_ctx	*alloc_ctx;
 };
 
+static struct platform_device_id mx2_camera_devtype[] = {
+	{
+		.name = "imx25-camera",
+		.driver_data = IMX25_CAMERA,
+	}, {
+		.name = "imx27-camera",
+		.driver_data = IMX27_CAMERA,
+	}, {
+		/* sentinel */
+	}
+};
+MODULE_DEVICE_TABLE(platform, mx2_camera_devtype);
+
+static inline int is_imx25_camera(struct mx2_camera_dev *pcdev)
+{
+	return pcdev->devtype == IMX25_CAMERA;
+}
+
+static inline int is_imx27_camera(struct mx2_camera_dev *pcdev)
+{
+	return pcdev->devtype == IMX27_CAMERA;
+}
+
 static struct mx2_buffer *mx2_ibuf_to_buf(struct mx2_buf_internal *int_buf)
 {
 	return container_of(int_buf, struct mx2_buffer, internal);
@@ -406,9 +438,9 @@ static void mx2_camera_deactivate(struct mx2_camera_dev *pcdev)
 
 	clk_disable_unprepare(pcdev->clk_csi);
 	writel(0, pcdev->base_csi + CSICR1);
-	if (cpu_is_mx27()) {
+	if (is_imx27_camera(pcdev)) {
 		writel(0, pcdev->base_emma + PRP_CNTL);
-	} else if (cpu_is_mx25()) {
+	} else if (is_imx25_camera(pcdev)) {
 		spin_lock_irqsave(&pcdev->lock, flags);
 		pcdev->fb1_active = NULL;
 		pcdev->fb2_active = NULL;
@@ -438,7 +470,7 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
 
 	csicr1 = CSICR1_MCLKEN;
 
-	if (cpu_is_mx27())
+	if (is_imx27_camera(pcdev))
 		csicr1 |= CSICR1_PRP_IF_EN | CSICR1_FCC |
 			CSICR1_RXFF_LEVEL(0);
 
@@ -514,7 +546,7 @@ out:
 static irqreturn_t mx25_camera_irq(int irq_csi, void *data)
 {
 	struct mx2_camera_dev *pcdev = data;
-	u32 status = readl(pcdev->base_csi + CSISR);
+	u32 status = readl(pcdev->base_csi + pcdev->reg_csisr);
 
 	if (status & CSISR_DMA_TSF_FB1_INT)
 		mx25_camera_frame_done(pcdev, 1, MX2_STATE_DONE);
@@ -523,7 +555,7 @@ static irqreturn_t mx25_camera_irq(int irq_csi, void *data)
 
 	/* FIXME: handle CSISR_RFF_OR_INT */
 
-	writel(status, pcdev->base_csi + CSISR);
+	writel(status, pcdev->base_csi + pcdev->reg_csisr);
 
 	return IRQ_HANDLED;
 }
@@ -608,7 +640,7 @@ static void mx2_videobuf_queue(struct vb2_buffer *vb)
 	buf->state = MX2_STATE_QUEUED;
 	list_add_tail(&buf->internal.queue, &pcdev->capture);
 
-	if (cpu_is_mx25()) {
+	if (is_imx25_camera(pcdev)) {
 		u32 csicr3, dma_inten = 0;
 
 		if (pcdev->fb1_active == NULL) {
@@ -627,20 +659,20 @@ static void mx2_videobuf_queue(struct vb2_buffer *vb)
 			list_del(&buf->internal.queue);
 			buf->state = MX2_STATE_ACTIVE;
 
-			csicr3 = readl(pcdev->base_csi + CSICR3);
+			csicr3 = readl(pcdev->base_csi + pcdev->reg_csicr3);
 
 			/* Reflash DMA */
 			writel(csicr3 | CSICR3_DMA_REFLASH_RFF,
-					pcdev->base_csi + CSICR3);
+					pcdev->base_csi + pcdev->reg_csicr3);
 
 			/* clear & enable interrupts */
-			writel(dma_inten, pcdev->base_csi + CSISR);
+			writel(dma_inten, pcdev->base_csi + pcdev->reg_csisr);
 			pcdev->csicr1 |= dma_inten;
 			writel(pcdev->csicr1, pcdev->base_csi + CSICR1);
 
 			/* enable DMA */
 			csicr3 |= CSICR3_DMA_REQ_EN_RFF | CSICR3_RXFF_LEVEL(1);
-			writel(csicr3, pcdev->base_csi + CSICR3);
+			writel(csicr3, pcdev->base_csi + pcdev->reg_csicr3);
 		}
 	}
 
@@ -684,7 +716,7 @@ static void mx2_videobuf_release(struct vb2_buffer *vb)
 	 */
 
 	spin_lock_irqsave(&pcdev->lock, flags);
-	if (cpu_is_mx25() && buf->state == MX2_STATE_ACTIVE) {
+	if (is_imx25_camera(pcdev) && buf->state == MX2_STATE_ACTIVE) {
 		if (pcdev->fb1_active == buf) {
 			pcdev->csicr1 &= ~CSICR1_FB1_DMA_INTEN;
 			writel(0, pcdev->base_csi + CSIDMASA_FB1);
@@ -807,7 +839,7 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
 	unsigned long phys;
 	int bytesperline;
 
-	if (cpu_is_mx27()) {
+	if (is_imx27_camera(pcdev)) {
 		unsigned long flags;
 		if (count < 2)
 			return -EINVAL;
@@ -902,7 +934,7 @@ static int mx2_stop_streaming(struct vb2_queue *q)
 	void *b;
 	u32 cntl;
 
-	if (cpu_is_mx27()) {
+	if (is_imx27_camera(pcdev)) {
 		spin_lock_irqsave(&pcdev->lock, flags);
 
 		cntl = readl(pcdev->base_emma + PRP_CNTL);
@@ -1054,11 +1086,11 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd)
 	if (bytesperline < 0)
 		return bytesperline;
 
-	if (cpu_is_mx27()) {
+	if (is_imx27_camera(pcdev)) {
 		ret = mx27_camera_emma_prp_reset(pcdev);
 		if (ret)
 			return ret;
-	} else if (cpu_is_mx25()) {
+	} else if (is_imx25_camera(pcdev)) {
 		writel((bytesperline * icd->user_height) >> 2,
 				pcdev->base_csi + CSIRXCNT);
 		writel((bytesperline << 16) | icd->user_height,
@@ -1351,7 +1383,7 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
 	/* FIXME: implement MX27 limits */
 
 	/* limit to MX25 hardware capabilities */
-	if (cpu_is_mx25()) {
+	if (is_imx25_camera(pcdev)) {
 		if (xlate->host_fmt->bits_per_sample <= 8)
 			width_limit = 0xffff * 4;
 		else
@@ -1685,6 +1717,20 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 		goto exit;
 	}
 
+	pcdev->devtype = pdev->id_entry->driver_data;
+	switch (pcdev->devtype) {
+	case IMX25_CAMERA:
+		pcdev->reg_csisr = CSISR_IMX25;
+		pcdev->reg_csicr3 = CSICR3_IMX25;
+		break;
+	case IMX27_CAMERA:
+		pcdev->reg_csisr = CSISR_IMX27;
+		pcdev->reg_csicr3 = CSICR3_IMX27;
+		break;
+	default:
+		break;
+	}
+
 	pcdev->clk_csi = devm_clk_get(&pdev->dev, "ahb");
 	if (IS_ERR(pcdev->clk_csi)) {
 		dev_err(&pdev->dev, "Could not get csi clock\n");
@@ -1722,7 +1768,7 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 	pcdev->dev = &pdev->dev;
 	platform_set_drvdata(pdev, pcdev);
 
-	if (cpu_is_mx25()) {
+	if (is_imx25_camera(pcdev)) {
 		err = devm_request_irq(&pdev->dev, irq_csi, mx25_camera_irq, 0,
 				       MX2_CAM_DRV_NAME, pcdev);
 		if (err) {
@@ -1731,7 +1777,7 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (cpu_is_mx27()) {
+	if (is_imx27_camera(pcdev)) {
 		err = mx27_camera_emma_init(pdev);
 		if (err)
 			goto exit;
@@ -1748,7 +1794,7 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 	pcdev->soc_host.priv		= pcdev;
 	pcdev->soc_host.v4l2_dev.dev	= &pdev->dev;
 	pcdev->soc_host.nr		= pdev->id;
-	if (cpu_is_mx25())
+	if (is_imx25_camera(pcdev))
 		pcdev->soc_host.capabilities = SOCAM_HOST_CAP_STRIDE;
 
 	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
@@ -1768,7 +1814,7 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 exit_free_emma:
 	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 eallocctx:
-	if (cpu_is_mx27()) {
+	if (is_imx27_camera(pcdev)) {
 		clk_disable_unprepare(pcdev->clk_emma_ipg);
 		clk_disable_unprepare(pcdev->clk_emma_ahb);
 	}
@@ -1786,7 +1832,7 @@ static int __devexit mx2_camera_remove(struct platform_device *pdev)
 
 	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 
-	if (cpu_is_mx27()) {
+	if (is_imx27_camera(pcdev)) {
 		clk_disable_unprepare(pcdev->clk_emma_ipg);
 		clk_disable_unprepare(pcdev->clk_emma_ahb);
 	}
@@ -1800,6 +1846,7 @@ static struct platform_driver mx2_camera_driver = {
 	.driver 	= {
 		.name	= MX2_CAM_DRV_NAME,
 	},
+	.id_table	= mx2_camera_devtype,
 	.remove		= __devexit_p(mx2_camera_remove),
 };
 
-- 
1.7.9.5

