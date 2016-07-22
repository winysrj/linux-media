Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33937 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbcGVJJk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 05:09:40 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	william.towle@codethink.co.uk, geert@linux-m68k.org,
	Rob Taylor <rob.taylor@codethink.co.uk>,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v6 2/4] ARM: dts: lager: Add entries for VIN HDMI input support
Date: Fri, 22 Jul 2016 11:09:12 +0200
Message-Id: <1469178554-20719-3-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1469178554-20719-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1469178554-20719-1-git-send-email-ulrich.hecht+renesas@gmail.com>
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
index ffc2f4e..16e86d0 100644
--- a/arch/arm/boot/dts/r8a7790-lager.dts
+++ b/arch/arm/boot/dts/r8a7790-lager.dts
@@ -374,6 +374,21 @@
 				};
 			};
 		};
+
+		hdmi-in@4c {
+			compatible = "adi,adv7612";
+			reg = <0x4c>;
+			interrupt-parent = <&gpio1>;
+			interrupts = <20 IRQ_TYPE_LEVEL_LOW>;
+			remote = <&vin0>;
+			default-input = <0>;
+
+			port {
+				adv7612: endpoint {
+					remote-endpoint = <&vin0ep0>;
+				};
+			};
+		};
 	};
 
 	/*
@@ -587,6 +602,11 @@
 		function = "usb2";
 	};
 
+	vin0_pins: vin0 {
+		groups = "vin0_data24", "vin0_sync", "vin0_clkenb", "vin0_clk";
+		function = "vin0";
+	};
+
 	vin1_pins: vin1 {
 		groups = "vin1_data8", "vin1_clk";
 		function = "vin1";
@@ -818,6 +838,25 @@
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

