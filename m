Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:55517 "EHLO
	xk120" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753323AbbA2QTx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 11:19:53 -0500
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 8/8] WmT: dts/i vin0/adv7612 (HDMI)
Date: Thu, 29 Jan 2015 16:19:48 +0000
Message-Id: <1422548388-28861-9-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk>
References: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 arch/arm/boot/dts/r8a7790-lager.dts |   51 +++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 17 deletions(-)

diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8a7790-lager.dts
index be44493..c20b6cb 100644
--- a/arch/arm/boot/dts/r8a7790-lager.dts
+++ b/arch/arm/boot/dts/r8a7790-lager.dts
@@ -249,9 +249,9 @@
 		renesas,function = "usb2";
 	};
 
-	vin1_pins: vin {
-		renesas,groups = "vin1_data8", "vin1_clk";
-		renesas,function = "vin1";
+	vin0_pins: vin0 {
+		renesas,groups = "vin0_data24", "vin0_sync", "vin0_field", "vin0_clkenb", "vin0_clk";
+		renesas,function = "vin0";
 	};
 };
 
@@ -391,15 +391,15 @@
 	pinctrl-0 = <&iic2_pins>;
 	pinctrl-names = "default";
 
-	composite-in@20 {
-		compatible = "adi,adv7180";
-		reg = <0x20>;
-		remote = <&vin1>;
+	adv7612: adv7612@0x4c {
+		compatible = "adi,adv7612";
+		reg = <0x4c>;
+		remote = <&vin0>;
 
 		port {
-			adv7180: endpoint {
-				bus-width = <8>;
-				remote-endpoint = <&vin1ep0>;
+			adv7612_1: endpoint {
+				remote-endpoint = <&vin0ep0>;
+				default-input = <0>;
 			};
 		};
 	};
@@ -419,6 +419,19 @@
 		i2c-gpio,delay-us = <1>;	/* ~100 kHz */
 		#address-cells = <1>;
 		#size-cells = <0>;
+
+		adv7612: adv7612@0x4c {
+			compatible = "adi,adv7612";
+			reg = <0x4c>;
+			remote = <&vin0>;
+
+			port {
+				adv7612_1: endpoint {
+					remote-endpoint = <&vin0ep0>;
+					default-input = <0>;
+				};
+			};
+		};
 	};
 };
 #endif
@@ -457,9 +470,9 @@
 	pinctrl-names = "default";
 };
 
-/* composite video input */
-&vin1 {
-	pinctrl-0 = <&vin1_pins>;
+/* HDMI video input */
+&vin0 {
+	pinctrl-0 = <&vin0_pins>;
 	pinctrl-names = "default";
 
 	status = "ok";
@@ -468,9 +481,13 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 
-		vin1ep0: endpoint {
-			remote-endpoint = <&adv7180>;
-			bus-width = <8>;
+		vin0ep0: endpoint {
+			remote-endpoint = <&adv7612_1>;
+			bus-width = <24>;
+			hsync-active = <0>;
+			vsync-active = <0>;
+			pclk-sample = <1>;
+			data-active = <1>;
 		};
 	};
-};
+};
\ No newline at end of file
-- 
1.7.10.4

