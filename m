Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([198.47.19.12]:48750 "EHLO arroyo.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933875AbcI1VXY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 17:23:24 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [Patch 29/35] media: ti-vpe: Make scaler library into its own module
Date: Wed, 28 Sep 2016 16:23:17 -0500
Message-ID: <20160928212317.27625-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation to add scaler support into VIP we need to
turn sc.c into its own kernel module.

Add support for multiple SC memory block as VIP contains
2 scaler instances.
This is done by passing the resource name to sc_create() and
modify the vpe invocation accordingly.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/Kconfig         |  4 ++++
 drivers/media/platform/ti-vpe/Makefile |  4 +++-
 drivers/media/platform/ti-vpe/sc.c     | 17 ++++++++++++++---
 drivers/media/platform/ti-vpe/sc.h     |  2 +-
 drivers/media/platform/ti-vpe/vpe.c    |  2 +-
 5 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 3c15c5a53bd5..169626371a89 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -335,6 +335,7 @@ config VIDEO_TI_VPE
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	select VIDEO_TI_VPDMA
+	select VIDEO_TI_SC
 	default n
 	---help---
 	  Support for the TI VPE(Video Processing Engine) block
@@ -353,6 +354,9 @@ endif # V4L_MEM2MEM_DRIVERS
 config VIDEO_TI_VPDMA
 	tristate
 
+config VIDEO_TI_SC
+	tristate
+
 menuconfig V4L_TEST_DRIVERS
 	bool "Media test drivers"
 	depends on MEDIA_CAMERA_SUPPORT
diff --git a/drivers/media/platform/ti-vpe/Makefile b/drivers/media/platform/ti-vpe/Makefile
index faca5e115c1d..736558d309ad 100644
--- a/drivers/media/platform/ti-vpe/Makefile
+++ b/drivers/media/platform/ti-vpe/Makefile
@@ -1,8 +1,10 @@
 obj-$(CONFIG_VIDEO_TI_VPE) += ti-vpe.o
 obj-$(CONFIG_VIDEO_TI_VPDMA) += ti-vpdma.o
+obj-$(CONFIG_VIDEO_TI_SC) += ti-sc.o
 
-ti-vpe-y := vpe.o sc.o csc.o
+ti-vpe-y := vpe.o csc.o
 ti-vpdma-y := vpdma.o
+ti-sc-y := sc.o
 
 ccflags-$(CONFIG_VIDEO_TI_VPE_DEBUG) += -DDEBUG
 
diff --git a/drivers/media/platform/ti-vpe/sc.c b/drivers/media/platform/ti-vpe/sc.c
index 02f3dae8ae42..52ce1450362f 100644
--- a/drivers/media/platform/ti-vpe/sc.c
+++ b/drivers/media/platform/ti-vpe/sc.c
@@ -14,6 +14,7 @@
 
 #include <linux/err.h>
 #include <linux/io.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
@@ -52,6 +53,7 @@ void sc_dump_regs(struct sc_data *sc)
 
 #undef DUMPREG
 }
+EXPORT_SYMBOL(sc_dump_regs);
 
 /*
  * set the horizontal scaler coefficients according to the ratio of output to
@@ -100,6 +102,7 @@ void sc_set_hs_coeffs(struct sc_data *sc, void *addr, unsigned int src_w,
 
 	sc->load_coeff_h = true;
 }
+EXPORT_SYMBOL(sc_set_hs_coeffs);
 
 /*
  * set the vertical scaler coefficients according to the ratio of output to
@@ -140,6 +143,7 @@ void sc_set_vs_coeffs(struct sc_data *sc, void *addr, unsigned int src_h,
 
 	sc->load_coeff_v = true;
 }
+EXPORT_SYMBOL(sc_set_vs_coeffs);
 
 void sc_config_scaler(struct sc_data *sc, u32 *sc_reg0, u32 *sc_reg8,
 		u32 *sc_reg17, unsigned int src_w, unsigned int src_h,
@@ -267,8 +271,9 @@ void sc_config_scaler(struct sc_data *sc, u32 *sc_reg0, u32 *sc_reg8,
 
 	*sc_reg24 = (src_w << CFG_ORG_W_SHIFT) | (src_h << CFG_ORG_H_SHIFT);
 }
+EXPORT_SYMBOL(sc_config_scaler);
 
-struct sc_data *sc_create(struct platform_device *pdev)
+struct sc_data *sc_create(struct platform_device *pdev, const char *res_name)
 {
 	struct sc_data *sc;
 
@@ -282,9 +287,10 @@ struct sc_data *sc_create(struct platform_device *pdev)
 
 	sc->pdev = pdev;
 
-	sc->res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "sc");
+	sc->res = platform_get_resource_byname(pdev, IORESOURCE_MEM, res_name);
 	if (!sc->res) {
-		dev_err(&pdev->dev, "missing platform resources data\n");
+		dev_err(&pdev->dev, "missing '%s' platform resources data\n",
+			res_name);
 		return ERR_PTR(-ENODEV);
 	}
 
@@ -296,3 +302,8 @@ struct sc_data *sc_create(struct platform_device *pdev)
 
 	return sc;
 }
+EXPORT_SYMBOL(sc_create);
+
+MODULE_DESCRIPTION("TI VIP/VPE Scaler");
+MODULE_AUTHOR("Texas Instruments Inc.");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/platform/ti-vpe/sc.h b/drivers/media/platform/ti-vpe/sc.h
index de947db98990..d0aab5ef0eca 100644
--- a/drivers/media/platform/ti-vpe/sc.h
+++ b/drivers/media/platform/ti-vpe/sc.h
@@ -200,6 +200,6 @@ void sc_set_vs_coeffs(struct sc_data *sc, void *addr, unsigned int src_h,
 void sc_config_scaler(struct sc_data *sc, u32 *sc_reg0, u32 *sc_reg8,
 		u32 *sc_reg17, unsigned int src_w, unsigned int src_h,
 		unsigned int dst_w, unsigned int dst_h);
-struct sc_data *sc_create(struct platform_device *pdev);
+struct sc_data *sc_create(struct platform_device *pdev, const char *res_name);
 
 #endif
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 875da06acd67..d0d222b3a173 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -2454,7 +2454,7 @@ static int vpe_probe(struct platform_device *pdev)
 
 	vpe_top_vpdma_reset(dev);
 
-	dev->sc = sc_create(pdev);
+	dev->sc = sc_create(pdev, "sc");
 	if (IS_ERR(dev->sc)) {
 		ret = PTR_ERR(dev->sc);
 		goto runtime_put;
-- 
2.9.0

