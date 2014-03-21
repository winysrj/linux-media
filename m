Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:60641 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964951AbaCULCw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Mar 2014 07:02:52 -0400
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id 791C777D4AC
	for <linux-media@vger.kernel.org>; Fri, 21 Mar 2014 12:02:49 +0100 (CET)
Message-Id: <911da5ce15cdb37cf899e629b0edc31f44ce5205.1395397665.git.moinejf@free.fr>
In-Reply-To: <cover.1395397665.git.moinejf@free.fr>
References: <cover.1395397665.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Fri, 21 Mar 2014 09:52:29 +0100
Subject: [PATCH RFC v2 6/6] ARM: AM33XX: dts: Change the tda998x description
To: Russell King <rmk+kernel@arm.linux.org.uk>,
	Rob Clark <robdclark@gmail.com>,
	dri-devel@lists.freedesktop.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The tda998x being moved from a 'slave encoder' to a normal DRM
encoder/connector and the tilcdc_slave glue being removed, the
declaration of the HDMI transmitter description must be changed in
the associated DTs.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 arch/arm/boot/dts/am335x-base0033.dts  | 28 +++++++++++++++++++---------
 arch/arm/boot/dts/am335x-boneblack.dts | 21 ++++++++++++++++-----
 2 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/arch/arm/boot/dts/am335x-base0033.dts b/arch/arm/boot/dts/am335x-base0033.dts
index 72a9b3f..05f2b8f 100644
--- a/arch/arm/boot/dts/am335x-base0033.dts
+++ b/arch/arm/boot/dts/am335x-base0033.dts
@@ -14,15 +14,6 @@
 	model = "IGEP COM AM335x on AQUILA Expansion";
 	compatible = "isee,am335x-base0033", "isee,am335x-igep0033", "ti,am33xx";
 
-	hdmi {
-		compatible = "ti,tilcdc,slave";
-		i2c = <&i2c0>;
-		pinctrl-names = "default", "off";
-		pinctrl-0 = <&nxp_hdmi_pins>;
-		pinctrl-1 = <&nxp_hdmi_off_pins>;
-		status = "okay";
-	};
-
 	leds_base {
 		pinctrl-names = "default";
 		pinctrl-0 = <&leds_base_pins>;
@@ -85,6 +76,11 @@
 
 &lcdc {
 	status = "okay";
+	port {
+		lcd_0: endpoint@0 {
+			remote-endpoint = <&hdmi_0>;
+		};
+	};
 };
 
 &i2c0 {
@@ -92,4 +88,18 @@
 		compatible = "at,24c256";
 		reg = <0x50>;
 	};
+	hdmi: hdmi-encoder {
+		compatible = "nxp,tda19988";
+		reg = <0x70>;
+
+		pinctrl-names = "default", "off";
+		pinctrl-0 = <&nxp_hdmi_pins>;
+		pinctrl-1 = <&nxp_hdmi_off_pins>;
+
+		port {
+			hdmi_0: endpoint@0 {
+				remote-endpoint = <&lcd_0>;
+			};
+		};
+	};
 };
diff --git a/arch/arm/boot/dts/am335x-boneblack.dts b/arch/arm/boot/dts/am335x-boneblack.dts
index 6b71ad9..b94d8bd 100644
--- a/arch/arm/boot/dts/am335x-boneblack.dts
+++ b/arch/arm/boot/dts/am335x-boneblack.dts
@@ -64,15 +64,26 @@
 
 &lcdc {
 	status = "okay";
+	port {
+		lcd_0: endpoint@0 {
+			remote-endpoint = <&hdmi_0>;
+		};
+	};
 };
 
-/ {
-	hdmi {
-		compatible = "ti,tilcdc,slave";
-		i2c = <&i2c0>;
+&i2c0 {
+	hdmi: hdmi-encoder {
+		compatible = "nxp,tda19988";
+		reg = <0x70>;
+
 		pinctrl-names = "default", "off";
 		pinctrl-0 = <&nxp_hdmi_bonelt_pins>;
 		pinctrl-1 = <&nxp_hdmi_bonelt_off_pins>;
-		status = "okay";
+
+		port {
+			hdmi_0: endpoint@0 {
+				remote-endpoint = <&lcd_0>;
+			};
+		};
 	};
 };
-- 
1.9.1

