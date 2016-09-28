Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:50203 "EHLO comal.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754292AbcI1VXs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 17:23:48 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [Patch 33/35] media: ti-vpe: Make colorspace converter library into its own module
Date: Wed, 28 Sep 2016 16:23:46 -0500
Message-ID: <20160928212346.27805-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation to add colorspace conversion support to VIP,
we need to turn csc.c into its own kernel module.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/Kconfig         |  4 ++++
 drivers/media/platform/ti-vpe/Makefile |  4 +++-
 drivers/media/platform/ti-vpe/csc.c    | 16 +++++++++++++---
 drivers/media/platform/ti-vpe/csc.h    |  2 +-
 drivers/media/platform/ti-vpe/vpe.c    |  2 +-
 5 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 169626371a89..5334caba86d4 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -336,6 +336,7 @@ config VIDEO_TI_VPE
 	select V4L2_MEM2MEM_DEV
 	select VIDEO_TI_VPDMA
 	select VIDEO_TI_SC
+	select VIDEO_TI_CSC
 	default n
 	---help---
 	  Support for the TI VPE(Video Processing Engine) block
@@ -357,6 +358,9 @@ config VIDEO_TI_VPDMA
 config VIDEO_TI_SC
 	tristate
 
+config VIDEO_TI_CSC
+	tristate
+
 menuconfig V4L_TEST_DRIVERS
 	bool "Media test drivers"
 	depends on MEDIA_CAMERA_SUPPORT
diff --git a/drivers/media/platform/ti-vpe/Makefile b/drivers/media/platform/ti-vpe/Makefile
index 736558d309ad..32504b724b5d 100644
--- a/drivers/media/platform/ti-vpe/Makefile
+++ b/drivers/media/platform/ti-vpe/Makefile
@@ -1,10 +1,12 @@
 obj-$(CONFIG_VIDEO_TI_VPE) += ti-vpe.o
 obj-$(CONFIG_VIDEO_TI_VPDMA) += ti-vpdma.o
 obj-$(CONFIG_VIDEO_TI_SC) += ti-sc.o
+obj-$(CONFIG_VIDEO_TI_CSC) += ti-csc.o
 
-ti-vpe-y := vpe.o csc.o
+ti-vpe-y := vpe.o
 ti-vpdma-y := vpdma.o
 ti-sc-y := sc.o
+ti-csc-y := csc.o
 
 ccflags-$(CONFIG_VIDEO_TI_VPE_DEBUG) += -DDEBUG
 
diff --git a/drivers/media/platform/ti-vpe/csc.c b/drivers/media/platform/ti-vpe/csc.c
index bec674994752..9fc6f70adeeb 100644
--- a/drivers/media/platform/ti-vpe/csc.c
+++ b/drivers/media/platform/ti-vpe/csc.c
@@ -14,6 +14,7 @@
 
 #include <linux/err.h>
 #include <linux/io.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
@@ -105,11 +106,13 @@ void csc_dump_regs(struct csc_data *csc)
 
 #undef DUMPREG
 }
+EXPORT_SYMBOL(csc_dump_regs);
 
 void csc_set_coeff_bypass(struct csc_data *csc, u32 *csc_reg5)
 {
 	*csc_reg5 |= CSC_BYPASS;
 }
+EXPORT_SYMBOL(csc_set_coeff_bypass);
 
 /*
  * set the color space converter coefficient shadow register values
@@ -160,8 +163,9 @@ void csc_set_coeff(struct csc_data *csc, u32 *csc_reg0,
 	for (; coeff < end_coeff; coeff += 2)
 		*shadow_csc++ = (*(coeff + 1) << 16) | *coeff;
 }
+EXPORT_SYMBOL(csc_set_coeff);
 
-struct csc_data *csc_create(struct platform_device *pdev)
+struct csc_data *csc_create(struct platform_device *pdev, const char *res_name)
 {
 	struct csc_data *csc;
 
@@ -176,9 +180,10 @@ struct csc_data *csc_create(struct platform_device *pdev)
 	csc->pdev = pdev;
 
 	csc->res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
-			"csc");
+						res_name);
 	if (csc->res == NULL) {
-		dev_err(&pdev->dev, "missing platform resources data\n");
+		dev_err(&pdev->dev, "missing '%s' platform resources data\n",
+			res_name);
 		return ERR_PTR(-ENODEV);
 	}
 
@@ -190,3 +195,8 @@ struct csc_data *csc_create(struct platform_device *pdev)
 
 	return csc;
 }
+EXPORT_SYMBOL(csc_create);
+
+MODULE_DESCRIPTION("TI VIP/VPE Color Space Converter");
+MODULE_AUTHOR("Texas Instruments Inc.");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/platform/ti-vpe/csc.h b/drivers/media/platform/ti-vpe/csc.h
index 1ad2b6dad561..024700b15152 100644
--- a/drivers/media/platform/ti-vpe/csc.h
+++ b/drivers/media/platform/ti-vpe/csc.h
@@ -63,6 +63,6 @@ void csc_set_coeff_bypass(struct csc_data *csc, u32 *csc_reg5);
 void csc_set_coeff(struct csc_data *csc, u32 *csc_reg0,
 		enum v4l2_colorspace src_colorspace,
 		enum v4l2_colorspace dst_colorspace);
-struct csc_data *csc_create(struct platform_device *pdev);
+struct csc_data *csc_create(struct platform_device *pdev, const char *res_name);
 
 #endif
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 2b661163d695..ae5acb5f42b8 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -2497,7 +2497,7 @@ static int vpe_probe(struct platform_device *pdev)
 		goto runtime_put;
 	}
 
-	dev->csc = csc_create(pdev);
+	dev->csc = csc_create(pdev, "csc");
 	if (IS_ERR(dev->csc)) {
 		ret = PTR_ERR(dev->csc);
 		goto runtime_put;
-- 
2.9.0

