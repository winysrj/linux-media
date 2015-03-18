Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49898 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753703AbbCRXvO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 19:51:14 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-omap@vger.kernel.org
Cc: tony@atomide.com, sre@kernel.org, pali.rohar@gmail.com,
	laurent.pinchart@ideasonboard.com, t-kristo@ti.com,
	linux-media@vger.kernel.org
Subject: [PATCH v2 2/3] arm: dts: omap3: Add DT entries for OMAP 3
Date: Thu, 19 Mar 2015 01:50:23 +0200
Message-Id: <1426722625-4132-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1426722625-4132-1-git-send-email-sakari.ailus@iki.fi>
References: <1426722625-4132-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The resources the ISP needs are slightly different on 3[45]xx and 3[67]xx.
Especially the phy-type property is different.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 arch/arm/boot/dts/omap34xx.dtsi |   17 +++++++++++++++++
 arch/arm/boot/dts/omap36xx.dtsi |   17 +++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/arch/arm/boot/dts/omap34xx.dtsi b/arch/arm/boot/dts/omap34xx.dtsi
index 3819c1e..4f6b2d5 100644
--- a/arch/arm/boot/dts/omap34xx.dtsi
+++ b/arch/arm/boot/dts/omap34xx.dtsi
@@ -8,6 +8,8 @@
  * kind, whether express or implied.
  */
 
+#include <dt-bindings/media/omap3-isp.h>
+
 #include "omap3.dtsi"
 
 / {
@@ -37,6 +39,21 @@
 			pinctrl-single,register-width = <16>;
 			pinctrl-single,function-mask = <0xff1f>;
 		};
+
+		isp: isp@480bc000 {
+			compatible = "ti,omap3-isp";
+			reg = <0x480bc000 0x12fc
+			       0x480bd800 0x017c>;
+			interrupts = <24>;
+			iommus = <&mmu_isp>;
+			syscon = <&scm_conf 0xdc>;
+			ti,phy-type = <OMAP3ISP_PHY_TYPE_COMPLEX_IO>;
+			#clock-cells = <1>;
+			ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+		};
 	};
 };
 
diff --git a/arch/arm/boot/dts/omap36xx.dtsi b/arch/arm/boot/dts/omap36xx.dtsi
index 541704a..86253de 100644
--- a/arch/arm/boot/dts/omap36xx.dtsi
+++ b/arch/arm/boot/dts/omap36xx.dtsi
@@ -8,6 +8,8 @@
  * kind, whether express or implied.
  */
 
+#include <dt-bindings/media/omap3-isp.h>
+
 #include "omap3.dtsi"
 
 / {
@@ -69,6 +71,21 @@
 			pinctrl-single,register-width = <16>;
 			pinctrl-single,function-mask = <0xff1f>;
 		};
+
+		isp: isp@480bc000 {
+			compatible = "ti,omap3-isp";
+			reg = <0x480bc000 0x12fc
+			       0x480bd800 0x0600>;
+			interrupts = <24>;
+			iommus = <&mmu_isp>;
+			syscon = <&scm_conf 0x2f0>;
+			ti,phy-type = <OMAP3ISP_PHY_TYPE_CSIPHY>;
+			#clock-cells = <1>;
+			ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+		};
 	};
 };
 
-- 
1.7.10.4

