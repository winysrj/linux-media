Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:56591 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753370AbbEUJDR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 05:03:17 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sergei.shtylyov@cogentembedded.com,
	hverkuil@xs4all.nl, rob.taylor@codethink.co.uk
Subject: [PATCH 01/20] ARM: shmobile: lager dts: Add entries for VIN HDMI input support
Date: Wed, 20 May 2015 17:39:21 +0100
Message-Id: <1432139980-12619-2-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds DT entries for vin0_pins, adv7612 and vin0

Signed-off-by: William Towle <william.towle@codethink.co.uk>
Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
---
 arch/arm/boot/dts/r8a7790-lager.dts |   41 ++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8a7790-lager.dts
index aaa4f25..90c4531 100644
--- a/arch/arm/boot/dts/r8a7790-lager.dts
+++ b/arch/arm/boot/dts/r8a7790-lager.dts
@@ -370,7 +370,12 @@
 		renesas,function = "usb2";
 	};
 
-	vin1_pins: vin {
+	vin0_pins: vin0 {
+		renesas,groups = "vin0_data24", "vin0_sync", "vin0_field", "vin0_clkenb", "vin0_clk";
+		renesas,function = "vin0";
+	};
+
+	vin1_pins: vin1 {
 		renesas,groups = "vin1_data8", "vin1_clk";
 		renesas,function = "vin1";
 	};
@@ -531,6 +536,18 @@
 		reg = <0x12>;
 	};
 
+	hdmi-in@4c {
+		compatible = "adi,adv7612";
+		reg = <0x4c>;
+		remote = <&vin0>;
+
+		port {
+			hdmi_in_ep: endpoint {
+				remote-endpoint = <&vin0ep0>;
+			};
+		};
+	};
+
 	composite-in@20 {
 		compatible = "adi,adv7180";
 		reg = <0x20>;
@@ -646,6 +663,28 @@
 	status = "okay";
 };
 
+/* HDMI video input */
+&vin0 {
+	pinctrl-0 = <&vin0_pins>;
+	pinctrl-names = "default";
+
+	status = "ok";
+
+	port {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		vin0ep0: endpoint {
+			remote-endpoint = <&hdmi_in_ep>;
+			bus-width = <24>;
+			hsync-active = <0>;
+			vsync-active = <0>;
+			pclk-sample = <1>;
+			data-active = <1>;
+		};
+	};
+};
+
 /* composite video input */
 &vin1 {
 	pinctrl-0 = <&vin1_pins>;
-- 
1.7.10.4

