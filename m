Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33314 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752883AbbCGVmS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2015 16:42:18 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, pali.rohar@gmail.com
Subject: [RFC 16/18] arm: dts: omap3: Add DT entries for OMAP 3
Date: Sat,  7 Mar 2015 23:41:13 +0200
Message-Id: <1425764475-27691-17-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The resources the ISP needs are slightly different on 3[45]xx and 3[67]xx.
Especially the phy-type property is different.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 arch/arm/boot/dts/omap34xx.dtsi |   15 +++++++++++++++
 arch/arm/boot/dts/omap36xx.dtsi |   15 +++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/arch/arm/boot/dts/omap34xx.dtsi b/arch/arm/boot/dts/omap34xx.dtsi
index 3819c1e..4c034d0 100644
--- a/arch/arm/boot/dts/omap34xx.dtsi
+++ b/arch/arm/boot/dts/omap34xx.dtsi
@@ -37,6 +37,21 @@
 			pinctrl-single,register-width = <16>;
 			pinctrl-single,function-mask = <0xff1f>;
 		};
+
+		omap3_isp: omap3_isp@480bc000 {
+			compatible = "ti,omap3-isp";
+			reg = <0x480bc000 0x12fc
+			       0x480bd800 0x017c>;
+			interrupts = <24>;
+			iommus = <&mmu_isp>;
+			syscon = <&omap3_scm_general 0xdc>;
+			ti,phy-type = <0>;
+			#clock-cells = <1>;
+			ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+		};
 	};
 };
 
diff --git a/arch/arm/boot/dts/omap36xx.dtsi b/arch/arm/boot/dts/omap36xx.dtsi
index 541704a..31ac41c 100644
--- a/arch/arm/boot/dts/omap36xx.dtsi
+++ b/arch/arm/boot/dts/omap36xx.dtsi
@@ -69,6 +69,21 @@
 			pinctrl-single,register-width = <16>;
 			pinctrl-single,function-mask = <0xff1f>;
 		};
+
+		omap3_isp: omap3_isp@480bc000 {
+			compatible = "ti,omap3-isp";
+			reg = <0x480bc000 0x12fc
+			       0x480bd800 0x0600>;
+			interrupts = <24>;
+			iommus = <&mmu_isp>;
+			syscon = <&omap3_scm_general 0x2f0>;
+			ti,phy-type = <1>;
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

