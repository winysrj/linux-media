Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34545 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932698AbcIPNJn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 09:09:43 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: horms@verge.net.au
Cc: geert@linux-m68k.org, hans.verkuil@cisco.com,
        niklas.soderlund@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com,
        ulrich.hecht+renesas@gmail.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH 2/3] ARM: dts: gose: add HDMI input
Date: Fri, 16 Sep 2016 15:09:34 +0200
Message-Id: <20160916130935.21292-3-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <20160916130935.21292-1-ulrich.hecht+renesas@gmail.com>
References: <20160916130935.21292-1-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Identical to the setup on Lager.

Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 arch/arm/boot/dts/r8a7793-gose.dts | 41 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7793-gose.dts b/arch/arm/boot/dts/r8a7793-gose.dts
index 90af186..e22d63c 100644
--- a/arch/arm/boot/dts/r8a7793-gose.dts
+++ b/arch/arm/boot/dts/r8a7793-gose.dts
@@ -374,6 +374,11 @@
 		groups = "audio_clk_a";
 		function = "audio_clk";
 	};
+
+	vin0_pins: vin0 {
+		groups = "vin0_data24", "vin0_sync", "vin0_clkenb", "vin0_clk";
+		function = "vin0";
+	};
 };
 
 &ether {
@@ -531,6 +536,21 @@
 		};
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
 	eeprom@50 {
 		compatible = "renesas,r1ex24002", "atmel,24c02";
 		reg = <0x50>;
@@ -558,3 +578,24 @@
 &ssi1 {
 	shared-pin;
 };
+
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
-- 
2.9.3

