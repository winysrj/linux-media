Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33947 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932896AbcEKODh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2016 10:03:37 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	william.towle@codethink.co.uk,
	Rob Taylor <rob.taylor@codethink.co.uk>,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v4 7/8] ARM: dts: lager: Add entries for VIN HDMI input support
Date: Wed, 11 May 2016 16:02:55 +0200
Message-Id: <1462975376-491-8-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1462975376-491-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1462975376-491-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: William Towle <william.towle@codethink.co.uk>

Add DT entries for vin0, vin0_pins, and adv7612.

Sets the 'default-input' property for ADV7612, enabling image and video
capture without the need to have userspace specifying routing.

Signed-off-by: William Towle <william.towle@codethink.co.uk>
Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
[uli: added interrupt, renamed endpoint, merged default-input]
Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 arch/arm/boot/dts/r8a7790-lager.dts | 39 +++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8a7790-lager.dts
index 749ba02..7e53f5c 100644
--- a/arch/arm/boot/dts/r8a7790-lager.dts
+++ b/arch/arm/boot/dts/r8a7790-lager.dts
@@ -427,6 +427,11 @@
 		function = "usb2";
 	};
 
+	vin0_pins: vin0 {
+		groups = "vin0_data24", "vin0_sync", "vin0_clkenb", "vin0_clk";
+		function = "vin0";
+	};
+
 	vin1_pins: vin {
 		groups = "vin1_data8", "vin1_clk";
 		function = "vin1";
@@ -607,6 +612,21 @@
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
+				remote-endpoint = <&vin0ep0>;
+			};
+		};
+	};
+
 	composite-in@20 {
 		compatible = "adi,adv7180";
 		reg = <0x20>;
@@ -722,6 +742,25 @@
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
+		vin0ep0: endpoint {
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
 	pinctrl-0 = <&vin1_pins>;
-- 
2.7.4

