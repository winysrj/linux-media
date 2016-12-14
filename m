Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f178.google.com ([209.85.210.178]:34783 "EHLO
        mail-wj0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755438AbcLNM67 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 07:58:59 -0500
Received: by mail-wj0-f178.google.com with SMTP id tg4so33171804wjb.1
        for <linux-media@vger.kernel.org>; Wed, 14 Dec 2016 04:57:21 -0800 (PST)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: linux@armlinux.org.uk, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, kernel@stlinux.com,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH 2/2] stih-cec: add hdmi-notifier support
Date: Wed, 14 Dec 2016 13:57:09 +0100
Message-Id: <1481720229-7587-3-git-send-email-benjamin.gaignard@linaro.org>
In-Reply-To: <1481720229-7587-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1481720229-7587-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

By using the HDMI notifier framework there is no longer any reason
to manually set the physical address. This was the one blocking
issue that prevented this driver from going out of staging, so do
this move as well.

Update the bindings documenting the new hdmi phandle and
update stih410.dtsi and stih407-family.dtsi accordingly.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 .../devicetree/bindings/media/stih-cec.txt         |  2 ++
 arch/arm/boot/dts/stih407-family.dtsi              | 12 ---------
 arch/arm/boot/dts/stih410.dtsi                     | 15 ++++++++++-
 drivers/staging/media/st-cec/Kconfig               |  1 +
 drivers/staging/media/st-cec/stih-cec.c            | 29 +++++++++++++++++++++-
 5 files changed, 45 insertions(+), 14 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/stih-cec.txt b/Documentation/devicetree/bindings/media/stih-cec.txt
index 71c4b2f..7d82121 100644
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
diff --git a/arch/arm/boot/dts/stih407-family.dtsi b/arch/arm/boot/dts/stih407-family.dtsi
index 8f79b41..ef7c79a 100644
--- a/arch/arm/boot/dts/stih407-family.dtsi
+++ b/arch/arm/boot/dts/stih407-family.dtsi
@@ -756,18 +756,6 @@
 				 <&clk_s_c0_flexgen CLK_ETH_PHY>;
 		};
 
-		cec: sti-cec@094a087c {
-			compatible = "st,stih-cec";
-			reg = <0x94a087c 0x64>;
-			clocks = <&clk_sysin>;
-			clock-names = "cec-clk";
-			interrupts = <GIC_SPI 140 IRQ_TYPE_NONE>;
-			interrupt-names = "cec-irq";
-			pinctrl-names = "default";
-			pinctrl-0 = <&pinctrl_cec0_default>;
-			resets = <&softreset STIH407_LPM_SOFTRESET>;
-		};
-
 		rng10: rng@08a89000 {
 			compatible      = "st,rng";
 			reg		= <0x08a89000 0x1000>;
diff --git a/arch/arm/boot/dts/stih410.dtsi b/arch/arm/boot/dts/stih410.dtsi
index a3ef734..c98d86e 100644
--- a/arch/arm/boot/dts/stih410.dtsi
+++ b/arch/arm/boot/dts/stih410.dtsi
@@ -193,7 +193,7 @@
 							 <&clk_s_d2_quadfs 0>;
 			};
 
-			sti-hdmi@8d04000 {
+			hdmi: sti-hdmi@8d04000 {
 				compatible = "st,stih407-hdmi";
 				reg = <0x8d04000 0x1000>;
 				reg-names = "hdmi-reg";
@@ -259,5 +259,18 @@
 			clocks = <&clk_sysin>;
 			interrupts = <GIC_SPI 205 IRQ_TYPE_EDGE_RISING>;
 		};
+
+		sti-cec@094a087c {
+			compatible = "st,stih-cec";
+			reg = <0x94a087c 0x64>;
+			clocks = <&clk_sysin>;
+			clock-names = "cec-clk";
+			interrupts = <GIC_SPI 140 IRQ_TYPE_NONE>;
+			interrupt-names = "cec-irq";
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_cec0_default>;
+			resets = <&softreset STIH407_LPM_SOFTRESET>;
+			st,hdmi-handle = <&hdmi>;
+		};
 	};
 };
diff --git a/drivers/staging/media/st-cec/Kconfig b/drivers/staging/media/st-cec/Kconfig
index 784d2c6..3072387 100644
--- a/drivers/staging/media/st-cec/Kconfig
+++ b/drivers/staging/media/st-cec/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_STI_HDMI_CEC
        tristate "STMicroelectronics STiH4xx HDMI CEC driver"
        depends on VIDEO_DEV && MEDIA_CEC && (ARCH_STI || COMPILE_TEST)
+       select HDMI_NOTIFIERS
        ---help---
          This is a driver for STIH4xx HDMI CEC interface. It uses the
          generic CEC framework interface.
diff --git a/drivers/staging/media/st-cec/stih-cec.c b/drivers/staging/media/st-cec/stih-cec.c
index 2143448..ce94097 100644
--- a/drivers/staging/media/st-cec/stih-cec.c
+++ b/drivers/staging/media/st-cec/stih-cec.c
@@ -10,11 +10,13 @@
  * (at your option) any later version.
  */
 #include <linux/clk.h>
+#include <linux/hdmi-notifier.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/mfd/syscon.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/version.h>
 
@@ -130,6 +132,7 @@ struct stih_cec {
 	void __iomem		*regs;
 	int			irq;
 	u32			irq_status;
+	struct hdmi_notifier    *notifier;
 };
 
 static int stih_cec_adap_enable(struct cec_adapter *adap, bool enable)
@@ -304,12 +307,29 @@ static int stih_cec_probe(struct platform_device *pdev)
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
+	cec->notifier = hdmi_notifier_get(&hdmi_dev->dev);
+	if (!cec->notifier)
+		return -ENOMEM;
+
 	cec->dev = dev;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -336,7 +356,7 @@ static int stih_cec_probe(struct platform_device *pdev)
 	cec->adap = cec_allocate_adapter(&sti_cec_adap_ops, cec,
 			CEC_NAME,
 			CEC_CAP_LOG_ADDRS | CEC_CAP_PASSTHROUGH |
-			CEC_CAP_PHYS_ADDR | CEC_CAP_TRANSMIT,
+			CEC_CAP_TRANSMIT,
 			1, &pdev->dev);
 	ret = PTR_ERR_OR_ZERO(cec->adap);
 	if (ret)
@@ -348,12 +368,19 @@ static int stih_cec_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	cec_register_hdmi_notifier(cec->adap, cec->notifier);
+
 	platform_set_drvdata(pdev, cec);
 	return 0;
 }
 
 static int stih_cec_remove(struct platform_device *pdev)
 {
+	struct stih_cec *cec = platform_get_drvdata(pdev);
+
+	cec_unregister_adapter(cec->adap);
+	hdmi_notifier_put(cec->notifier);
+
 	return 0;
 }
 
-- 
1.9.1

