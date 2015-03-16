Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44814 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752519AbbCPACH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 20:02:07 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-omap@vger.kernel.org
Cc: tony@atomide.com, sre@kernel.org, pali.rohar@gmail.com,
	laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Subject: [PATCH 4/4] arm: dts: n950, n9: Add primary camera support
Date: Mon, 16 Mar 2015 02:01:20 +0200
Message-Id: <1426464080-29119-5-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1426464080-29119-1-git-send-email-sakari.ailus@iki.fi>
References: <1426464080-29119-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for the primary camera of the Nokia N950 and N9.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 arch/arm/boot/dts/omap3-n9.dts   |   37 +++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/omap3-n950.dts |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-n9.dts b/arch/arm/boot/dts/omap3-n9.dts
index 9938b5d..7711df1 100644
--- a/arch/arm/boot/dts/omap3-n9.dts
+++ b/arch/arm/boot/dts/omap3-n9.dts
@@ -16,3 +16,40 @@
 	model = "Nokia N9";
 	compatible = "nokia,omap3-n9", "ti,omap36xx", "ti,omap3";
 };
+
+&i2c2 {
+	smia_1: camera@10 {
+		compatible = "nokia,smia";
+		reg = <0x10>;
+		/* No reset gpio */
+		vana-supply = <&vaux3>;
+		clocks = <&isp 0>;
+		clock-frequency = <9600000>;
+		nokia,nvm-size = <(16 * 64)>;
+		port {
+			smia_1_1: endpoint {
+				link-frequencies = /bits/ 64 <199200000 210000000 499200000>;
+				clock-lanes = <0>;
+				data-lanes = <1 2>;
+				remote-endpoint = <&csi2a_ep>;
+			};
+		};
+	};
+};
+
+&isp {
+	vdd-csiphy1-supply = <&vaux2>;
+	vdd-csiphy2-supply = <&vaux2>;
+	ports {
+		port@2 {
+			reg = <2>;
+			csi2a_ep: endpoint {
+				remote-endpoint = <&smia_1_1>;
+				clock-lanes = <2>;
+				data-lanes = <1 3>;
+				crc = <1>;
+				lane-polarity = <1 1 1>;
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/omap3-n950.dts b/arch/arm/boot/dts/omap3-n950.dts
index 261c558..761f275 100644
--- a/arch/arm/boot/dts/omap3-n950.dts
+++ b/arch/arm/boot/dts/omap3-n950.dts
@@ -16,3 +16,40 @@
 	model = "Nokia N950";
 	compatible = "nokia,omap3-n950", "ti,omap36xx", "ti,omap3";
 };
+
+&i2c2 {
+	smia_1: camera@10 {
+		compatible = "nokia,smia";
+		reg = <0x10>;
+		/* No reset gpio */
+		vana-supply = <&vaux3>;
+		clocks = <&isp 0>;
+		clock-frequency = <9600000>;
+		nokia,nvm-size = <(16 * 64)>;
+		port {
+			smia_1_1: endpoint {
+				link-frequencies = /bits/ 64 <210000000 333600000 398400000>;
+				clock-lanes = <0>;
+				data-lanes = <1 2>;
+				remote-endpoint = <&csi2a_ep>;
+			};
+		};
+	};
+};
+
+&isp {
+	vdd-csiphy1-supply = <&vaux2>;
+	vdd-csiphy2-supply = <&vaux2>;
+	ports {
+		port@2 {
+			reg = <2>;
+			csi2a_ep: endpoint {
+				remote-endpoint = <&smia_1_1>;
+				clock-lanes = <2>;
+				data-lanes = <3 1>;
+				crc = <1>;
+				lane-polarity = <1 1 1>;
+			};
+		};
+	};
+};
-- 
1.7.10.4

