Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:54949 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751805AbdBFKaW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Feb 2017 05:30:22 -0500
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
        Hans Verkuil <hans.verkuil@cisco.com>,
        devicetree@vger.kernel.org
Subject: [PATCHv4 8/9] stih-cec: add HPD notifier support
Date: Mon,  6 Feb 2017 11:29:50 +0100
Message-Id: <20170206102951.12623-9-hverkuil@xs4all.nl>
In-Reply-To: <20170206102951.12623-1-hverkuil@xs4all.nl>
References: <20170206102951.12623-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Benjamin Gaignard <benjamin.gaignard@linaro.org>

By using the HPD notifier framework there is no longer any reason
to manually set the physical address. This was the one blocking
issue that prevented this driver from going out of staging, so do
this move as well.

Update the bindings documentation the new hdmi phandle.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
CC: devicetree@vger.kernel.org
---
 .../devicetree/bindings/media/stih-cec.txt         |  2 ++
 drivers/media/platform/Kconfig                     | 10 +++++++
 drivers/media/platform/Makefile                    |  1 +
 .../st-cec => media/platform/sti/cec}/Makefile     |  0
 .../st-cec => media/platform/sti/cec}/stih-cec.c   | 31 +++++++++++++++++++---
 drivers/staging/media/Kconfig                      |  2 --
 drivers/staging/media/Makefile                     |  1 -
 drivers/staging/media/st-cec/Kconfig               |  8 ------
 drivers/staging/media/st-cec/TODO                  |  7 -----
 9 files changed, 41 insertions(+), 21 deletions(-)
 rename drivers/{staging/media/st-cec => media/platform/sti/cec}/Makefile (100%)
 rename drivers/{staging/media/st-cec => media/platform/sti/cec}/stih-cec.c (93%)
 delete mode 100644 drivers/staging/media/st-cec/Kconfig
 delete mode 100644 drivers/staging/media/st-cec/TODO

diff --git a/Documentation/devicetree/bindings/media/stih-cec.txt b/Documentation/devicetree/bindings/media/stih-cec.txt
index 71c4b2f4bcef..7d82121d148a 100644
--- a/Documentation/devicetree/bindings/media/stih-cec.txt
+++ b/Documentation/devicetree/bindings/media/stih-cec.txt
@@ -9,6 +9,7 @@ Required properties:
  - pinctrl-names: Contains only one value - "default"
  - pinctrl-0: Specifies the pin control groups used for CEC hardware.
  - resets: Reference to a reset controller
+ - st,hdmi-handle: Phandle to the HMDI controller
 
 Example for STIH407:
 
@@ -22,4 +23,5 @@ sti-cec@094a087c {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_cec0_default>;
 	resets = <&softreset STIH407_LPM_SOFTRESET>;
+	st,hdmi-handle = <&hdmi>;
 };
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 9920726f14d2..46db8a32a931 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -422,6 +422,16 @@ config VIDEO_SAMSUNG_S5P_CEC
          CEC bus is present in the HDMI connector and enables communication
          between compatible devices.
 
+config VIDEO_STI_HDMI_CEC
+       tristate "STMicroelectronics STiH4xx HDMI CEC driver"
+       depends on VIDEO_DEV && MEDIA_CEC_SUPPORT && (ARCH_STI || COMPILE_TEST)
+       select HPD_NOTIFIER
+       ---help---
+         This is a driver for STIH4xx HDMI CEC interface. It uses the
+         generic CEC framework interface.
+         CEC bus is present in the HDMI connector and enables communication
+         between compatible devices.
+
 endif #V4L_CEC_DRIVERS
 
 menuconfig V4L_TEST_DRIVERS
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index ad3bf22bfeae..01b689c10f69 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -39,6 +39,7 @@ obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC)	+= exynos-gsc/
 obj-$(CONFIG_VIDEO_STI_BDISP)		+= sti/bdisp/
 obj-$(CONFIG_VIDEO_STI_HVA)		+= sti/hva/
 obj-$(CONFIG_DVB_C8SECTPFE)		+= sti/c8sectpfe/
+obj-$(CONFIG_VIDEO_STI_HDMI_CEC) 	+= sti/cec/
 
 obj-$(CONFIG_BLACKFIN)                  += blackfin/
 
diff --git a/drivers/staging/media/st-cec/Makefile b/drivers/media/platform/sti/cec/Makefile
similarity index 100%
rename from drivers/staging/media/st-cec/Makefile
rename to drivers/media/platform/sti/cec/Makefile
diff --git a/drivers/staging/media/st-cec/stih-cec.c b/drivers/media/platform/sti/cec/stih-cec.c
similarity index 93%
rename from drivers/staging/media/st-cec/stih-cec.c
rename to drivers/media/platform/sti/cec/stih-cec.c
index 3c25638a9610..e50e916837fd 100644
--- a/drivers/staging/media/st-cec/stih-cec.c
+++ b/drivers/media/platform/sti/cec/stih-cec.c
@@ -1,6 +1,4 @@
 /*
- * drivers/staging/media/st-cec/stih-cec.c
- *
  * STIH4xx CEC driver
  * Copyright (C) STMicroelectronic SA 2016
  *
@@ -10,11 +8,13 @@
  * (at your option) any later version.
  */
 #include <linux/clk.h>
+#include <linux/hpd-notifier.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/mfd/syscon.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_platform.h>
 #include <linux/platform_device.h>
 
 #include <media/cec.h>
@@ -129,6 +129,7 @@ struct stih_cec {
 	void __iomem		*regs;
 	int			irq;
 	u32			irq_status;
+	struct hpd_notifier	*notifier;
 };
 
 static int stih_cec_adap_enable(struct cec_adapter *adap, bool enable)
@@ -303,12 +304,29 @@ static int stih_cec_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct resource *res;
 	struct stih_cec *cec;
+	struct device_node *np;
+	struct platform_device *hdmi_dev;
 	int ret;
 
 	cec = devm_kzalloc(dev, sizeof(*cec), GFP_KERNEL);
 	if (!cec)
 		return -ENOMEM;
 
+	np = of_parse_phandle(pdev->dev.of_node, "st,hdmi-handle", 0);
+
+	if (!np) {
+		dev_err(&pdev->dev, "Failed to find hdmi node in device tree\n");
+		return -ENODEV;
+	}
+
+	hdmi_dev = of_find_device_by_node(np);
+	if (!hdmi_dev)
+		return -EPROBE_DEFER;
+
+	cec->notifier = hpd_notifier_get(&hdmi_dev->dev);
+	if (!cec->notifier)
+		return -ENOMEM;
+
 	cec->dev = dev;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -335,7 +353,7 @@ static int stih_cec_probe(struct platform_device *pdev)
 	cec->adap = cec_allocate_adapter(&sti_cec_adap_ops, cec,
 			CEC_NAME,
 			CEC_CAP_LOG_ADDRS | CEC_CAP_PASSTHROUGH |
-			CEC_CAP_PHYS_ADDR | CEC_CAP_TRANSMIT, 1);
+			CEC_CAP_TRANSMIT, 1);
 	ret = PTR_ERR_OR_ZERO(cec->adap);
 	if (ret)
 		return ret;
@@ -346,12 +364,19 @@ static int stih_cec_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	cec_register_hpd_notifier(cec->adap, cec->notifier);
+
 	platform_set_drvdata(pdev, cec);
 	return 0;
 }
 
 static int stih_cec_remove(struct platform_device *pdev)
 {
+	struct stih_cec *cec = platform_get_drvdata(pdev);
+
+	cec_unregister_adapter(cec->adap);
+	hpd_notifier_put(cec->notifier);
+
 	return 0;
 }
 
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 1b7804cf4c51..d4f50f02c76e 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -30,6 +30,4 @@ source "drivers/staging/media/omap4iss/Kconfig"
 # Keep LIRC at the end, as it has sub-menus
 source "drivers/staging/media/lirc/Kconfig"
 
-source "drivers/staging/media/st-cec/Kconfig"
-
 endif
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index e11afbf99452..4c9bb23c9628 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -3,4 +3,3 @@ obj-$(CONFIG_DVB_CXD2099)	+= cxd2099/
 obj-$(CONFIG_LIRC_STAGING)	+= lirc/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
-obj-$(CONFIG_VIDEO_STI_HDMI_CEC) += st-cec/
diff --git a/drivers/staging/media/st-cec/Kconfig b/drivers/staging/media/st-cec/Kconfig
deleted file mode 100644
index c04283db58d6..000000000000
--- a/drivers/staging/media/st-cec/Kconfig
+++ /dev/null
@@ -1,8 +0,0 @@
-config VIDEO_STI_HDMI_CEC
-       tristate "STMicroelectronics STiH4xx HDMI CEC driver"
-       depends on VIDEO_DEV && MEDIA_CEC_SUPPORT && (ARCH_STI || COMPILE_TEST)
-       ---help---
-         This is a driver for STIH4xx HDMI CEC interface. It uses the
-         generic CEC framework interface.
-         CEC bus is present in the HDMI connector and enables communication
-         between compatible devices.
diff --git a/drivers/staging/media/st-cec/TODO b/drivers/staging/media/st-cec/TODO
deleted file mode 100644
index c61289742c5c..000000000000
--- a/drivers/staging/media/st-cec/TODO
+++ /dev/null
@@ -1,7 +0,0 @@
-This driver requires that userspace sets the physical address.
-However, this should be passed on from the corresponding
-ST HDMI driver.
-
-We have to wait until the HDMI notifier framework has been merged
-in order to handle this gracefully, until that time this driver
-has to remain in staging.
-- 
2.11.0

