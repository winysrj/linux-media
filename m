Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33165 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974AbcGFPkv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 11:40:51 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: hans.verkuil@cisco.com
Cc: niklas.soderlund@ragnatech.se, linux-media@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com,
	laurent.pinchart@ideasonboard.com, william.towle@codethink.co.uk,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v5 3/4] ARM: dts: koelsch: add HDMI input
Date: Wed,  6 Jul 2016 17:39:35 +0200
Message-Id: <1467819576-17743-4-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1467819576-17743-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1467819576-17743-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hverkuil@xs4all.nl>

Add support in the dts for the HDMI input. Based on the Lager dts
patch from Ultich Hecht.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
[uli: removed "renesas," prefixes from pfc nodes]
Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 arch/arm/boot/dts/r8a7791-koelsch.dts | 41 +++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7791-koelsch.dts b/arch/arm/boot/dts/r8a7791-koelsch.dts
index f8a7d09..097322a 100644
--- a/arch/arm/boot/dts/r8a7791-koelsch.dts
+++ b/arch/arm/boot/dts/r8a7791-koelsch.dts
@@ -393,6 +393,11 @@
 		function = "usb1";
 	};
 
+	vin0_pins: vin0 {
+		groups = "vin0_data24", "vin0_sync", "vin0_clkenb", "vin0_clk";
+		function = "vin0";
+	};
+
 	vin1_pins: vin1 {
 		groups = "vin1_data8", "vin1_clk";
 		function = "vin1";
@@ -551,6 +556,21 @@
 		reg = <0x12>;
 	};
 
+	hdmi-in@4c {
+		compatible = "adi,adv7612";
+		reg = <0x4c>;
+		interrupt-parent = <&gpio1>;
+		interrupts = <20 IRQ_TYPE_LEVEL_LOW>;
+		remote = <&vin0>;
+		default-input = <0>;
+
+		port {
+			adv7612: endpoint {
+				remote-endpoint = <&vin0ep>;
+			};
+		};
+	};
+
 	composite-in@20 {
 		compatible = "adi,adv7180";
 		reg = <0x20>;
@@ -672,6 +692,27 @@
 	cpu0-supply = <&vdd_dvfs>;
 };
 
+/* HDMI video input */
+&vin0 {
+	status = "okay";
+	pinctrl-0 = <&vin0_pins>;
+	pinctrl-names = "default";
+
+	port {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		vin0ep: endpoint {
+			remote-endpoint = <&adv7612>;
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
 	status = "okay";
-- 
2.7.4

