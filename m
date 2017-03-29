Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:37344 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755816AbdC2OPu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 10:15:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv5 07/11] s5p-cec: add cec-notifier support, move out of staging
Date: Wed, 29 Mar 2017 16:15:39 +0200
Message-Id: <20170329141543.32935-8-hverkuil@xs4all.nl>
In-Reply-To: <20170329141543.32935-1-hverkuil@xs4all.nl>
References: <20170329141543.32935-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

By using the CEC notifier framework there is no longer any reason
to manually set the physical address. This was the one blocking
issue that prevented this driver from going out of staging, so do
this move as well.

Update the bindings documenting the new hdmi phandle and
update exynos4.dtsi accordingly.

Tested with my Odroid U3.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
CC: linux-samsung-soc@vger.kernel.org
CC: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/media/platform/Kconfig                     | 18 +++++++++++
 drivers/media/platform/Makefile                    |  1 +
 .../media => media/platform}/s5p-cec/Makefile      |  0
 .../platform}/s5p-cec/exynos_hdmi_cec.h            |  0
 .../platform}/s5p-cec/exynos_hdmi_cecctrl.c        |  0
 .../media => media/platform}/s5p-cec/regs-cec.h    |  0
 .../media => media/platform}/s5p-cec/s5p_cec.c     | 35 ++++++++++++++++++----
 .../media => media/platform}/s5p-cec/s5p_cec.h     |  3 ++
 drivers/staging/media/Kconfig                      |  2 --
 drivers/staging/media/Makefile                     |  1 -
 drivers/staging/media/s5p-cec/Kconfig              |  9 ------
 drivers/staging/media/s5p-cec/TODO                 |  7 -----
 12 files changed, 52 insertions(+), 24 deletions(-)
 rename drivers/{staging/media => media/platform}/s5p-cec/Makefile (100%)
 rename drivers/{staging/media => media/platform}/s5p-cec/exynos_hdmi_cec.h (100%)
 rename drivers/{staging/media => media/platform}/s5p-cec/exynos_hdmi_cecctrl.c (100%)
 rename drivers/{staging/media => media/platform}/s5p-cec/regs-cec.h (100%)
 rename drivers/{staging/media => media/platform}/s5p-cec/s5p_cec.c (89%)
 rename drivers/{staging/media => media/platform}/s5p-cec/s5p_cec.h (97%)
 delete mode 100644 drivers/staging/media/s5p-cec/Kconfig
 delete mode 100644 drivers/staging/media/s5p-cec/TODO

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index ab0bb4879b54..2c449b88fc94 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -460,6 +460,24 @@ config VIDEO_TI_SC
 config VIDEO_TI_CSC
 	tristate
 
+menuconfig V4L_CEC_DRIVERS
+	bool "Platform HDMI CEC drivers"
+	depends on MEDIA_CEC_SUPPORT
+
+if V4L_CEC_DRIVERS
+
+config VIDEO_SAMSUNG_S5P_CEC
+       tristate "Samsung S5P CEC driver"
+       depends on VIDEO_DEV && MEDIA_CEC_SUPPORT && (PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST)
+       select MEDIA_CEC_NOTIFIER
+       ---help---
+         This is a driver for Samsung S5P HDMI CEC interface. It uses the
+         generic CEC framework interface.
+         CEC bus is present in the HDMI connector and enables communication
+         between compatible devices.
+
+endif #V4L_CEC_DRIVERS
+
 menuconfig V4L_TEST_DRIVERS
 	bool "Media test drivers"
 	depends on MEDIA_CAMERA_SUPPORT
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 8959f6e6692a..2f94d82afa4c 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG)	+= s5p-jpeg/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC)	+= s5p-mfc/
 
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_G2D)	+= s5p-g2d/
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_CEC)	+= s5p-cec/
 obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC)	+= exynos-gsc/
 
 obj-$(CONFIG_VIDEO_STI_BDISP)		+= sti/bdisp/
diff --git a/drivers/staging/media/s5p-cec/Makefile b/drivers/media/platform/s5p-cec/Makefile
similarity index 100%
rename from drivers/staging/media/s5p-cec/Makefile
rename to drivers/media/platform/s5p-cec/Makefile
diff --git a/drivers/staging/media/s5p-cec/exynos_hdmi_cec.h b/drivers/media/platform/s5p-cec/exynos_hdmi_cec.h
similarity index 100%
rename from drivers/staging/media/s5p-cec/exynos_hdmi_cec.h
rename to drivers/media/platform/s5p-cec/exynos_hdmi_cec.h
diff --git a/drivers/staging/media/s5p-cec/exynos_hdmi_cecctrl.c b/drivers/media/platform/s5p-cec/exynos_hdmi_cecctrl.c
similarity index 100%
rename from drivers/staging/media/s5p-cec/exynos_hdmi_cecctrl.c
rename to drivers/media/platform/s5p-cec/exynos_hdmi_cecctrl.c
diff --git a/drivers/staging/media/s5p-cec/regs-cec.h b/drivers/media/platform/s5p-cec/regs-cec.h
similarity index 100%
rename from drivers/staging/media/s5p-cec/regs-cec.h
rename to drivers/media/platform/s5p-cec/regs-cec.h
diff --git a/drivers/staging/media/s5p-cec/s5p_cec.c b/drivers/media/platform/s5p-cec/s5p_cec.c
similarity index 89%
rename from drivers/staging/media/s5p-cec/s5p_cec.c
rename to drivers/media/platform/s5p-cec/s5p_cec.c
index 2a07968b5ac6..f7adf61caaa8 100644
--- a/drivers/staging/media/s5p-cec/s5p_cec.c
+++ b/drivers/media/platform/s5p-cec/s5p_cec.c
@@ -19,11 +19,14 @@
 #include <linux/mfd/syscon.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
 #include <media/cec.h>
+#include <media/cec-edid.h>
+#include <media/cec-notifier.h>
 
 #include "exynos_hdmi_cec.h"
 #include "regs-cec.h"
@@ -167,10 +170,22 @@ static const struct cec_adap_ops s5p_cec_adap_ops = {
 static int s5p_cec_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
+	struct device_node *np;
+	struct platform_device *hdmi_dev;
 	struct resource *res;
 	struct s5p_cec_dev *cec;
 	int ret;
 
+	np = of_parse_phandle(pdev->dev.of_node, "hdmi-phandle", 0);
+
+	if (!np) {
+		dev_err(&pdev->dev, "Failed to find hdmi node in device tree\n");
+		return -ENODEV;
+	}
+	hdmi_dev = of_find_device_by_node(np);
+	if (hdmi_dev == NULL)
+		return -EPROBE_DEFER;
+
 	cec = devm_kzalloc(&pdev->dev, sizeof(*cec), GFP_KERNEL);
 	if (!cec)
 		return -ENOMEM;
@@ -200,24 +215,33 @@ static int s5p_cec_probe(struct platform_device *pdev)
 	if (IS_ERR(cec->reg))
 		return PTR_ERR(cec->reg);
 
+	cec->notifier = cec_notifier_get(&hdmi_dev->dev);
+	if (cec->notifier == NULL)
+		return -ENOMEM;
+
 	cec->adap = cec_allocate_adapter(&s5p_cec_adap_ops, cec,
 		CEC_NAME,
-		CEC_CAP_PHYS_ADDR | CEC_CAP_LOG_ADDRS | CEC_CAP_TRANSMIT |
+		CEC_CAP_LOG_ADDRS | CEC_CAP_TRANSMIT |
 		CEC_CAP_PASSTHROUGH | CEC_CAP_RC, 1);
 	ret = PTR_ERR_OR_ZERO(cec->adap);
 	if (ret)
 		return ret;
+
 	ret = cec_register_adapter(cec->adap, &pdev->dev);
-	if (ret) {
-		cec_delete_adapter(cec->adap);
-		return ret;
-	}
+	if (ret)
+		goto err_delete_adapter;
+
+	cec_register_cec_notifier(cec->adap, cec->notifier);
 
 	platform_set_drvdata(pdev, cec);
 	pm_runtime_enable(dev);
 
 	dev_dbg(dev, "successfuly probed\n");
 	return 0;
+
+err_delete_adapter:
+	cec_delete_adapter(cec->adap);
+	return ret;
 }
 
 static int s5p_cec_remove(struct platform_device *pdev)
@@ -225,6 +249,7 @@ static int s5p_cec_remove(struct platform_device *pdev)
 	struct s5p_cec_dev *cec = platform_get_drvdata(pdev);
 
 	cec_unregister_adapter(cec->adap);
+	cec_notifier_put(cec->notifier);
 	pm_runtime_disable(&pdev->dev);
 	return 0;
 }
diff --git a/drivers/staging/media/s5p-cec/s5p_cec.h b/drivers/media/platform/s5p-cec/s5p_cec.h
similarity index 97%
rename from drivers/staging/media/s5p-cec/s5p_cec.h
rename to drivers/media/platform/s5p-cec/s5p_cec.h
index 03732c13d19f..7015845c1caa 100644
--- a/drivers/staging/media/s5p-cec/s5p_cec.h
+++ b/drivers/media/platform/s5p-cec/s5p_cec.h
@@ -59,12 +59,15 @@ enum cec_state {
 	STATE_ERROR
 };
 
+struct cec_notifier;
+
 struct s5p_cec_dev {
 	struct cec_adapter	*adap;
 	struct clk		*clk;
 	struct device		*dev;
 	struct mutex		lock;
 	struct regmap           *pmu;
+	struct cec_notifier	*notifier;
 	int			irq;
 	void __iomem		*reg;
 
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index abd0e2d57c20..c0d83cecf528 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -29,8 +29,6 @@ source "drivers/staging/media/omap4iss/Kconfig"
 
 source "drivers/staging/media/platform/bcm2835/Kconfig"
 
-source "drivers/staging/media/s5p-cec/Kconfig"
-
 # Keep LIRC at the end, as it has sub-menus
 source "drivers/staging/media/lirc/Kconfig"
 
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index dc89325c463d..97b29ece9a2c 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -1,5 +1,4 @@
 obj-$(CONFIG_I2C_BCM2048)	+= bcm2048/
-obj-$(CONFIG_VIDEO_SAMSUNG_S5P_CEC) += s5p-cec/
 obj-$(CONFIG_DVB_CXD2099)	+= cxd2099/
 obj-$(CONFIG_LIRC_STAGING)	+= lirc/
 obj-$(CONFIG_VIDEO_BCM2835)	+= platform/bcm2835/
diff --git a/drivers/staging/media/s5p-cec/Kconfig b/drivers/staging/media/s5p-cec/Kconfig
deleted file mode 100644
index 7a3489df3e70..000000000000
--- a/drivers/staging/media/s5p-cec/Kconfig
+++ /dev/null
@@ -1,9 +0,0 @@
-config VIDEO_SAMSUNG_S5P_CEC
-       tristate "Samsung S5P CEC driver"
-       depends on VIDEO_DEV && MEDIA_CEC_SUPPORT && (ARCH_EXYNOS || COMPILE_TEST)
-       ---help---
-         This is a driver for Samsung S5P HDMI CEC interface. It uses the
-         generic CEC framework interface.
-         CEC bus is present in the HDMI connector and enables communication
-         between compatible devices.
-
diff --git a/drivers/staging/media/s5p-cec/TODO b/drivers/staging/media/s5p-cec/TODO
deleted file mode 100644
index 64f21bab38f5..000000000000
--- a/drivers/staging/media/s5p-cec/TODO
+++ /dev/null
@@ -1,7 +0,0 @@
-This driver requires that userspace sets the physical address.
-However, this should be passed on from the corresponding
-Samsung HDMI driver.
-
-We have to wait until the HDMI notifier framework has been merged
-in order to handle this gracefully, until that time this driver
-has to remain in staging.
-- 
2.11.0
