Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34187 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932186AbcJRPBq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 11:01:46 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: horms@verge.net.au
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, william.towle@codethink.co.uk,
        niklas.soderlund@ragnatech.se, geert@linux-m68k.org,
        sergei.shtylyov@cogentembedded.com,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v2 2/2] ARM: dts: koelsch: add HDMI input
Date: Tue, 18 Oct 2016 17:01:34 +0200
Message-Id: <1476802894-5105-3-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1476802894-5105-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1476802894-5105-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hverkuil@xs4all.nl>

Add support in the dts for the HDMI input. Based on the Lager dts
patch from Ultich Hecht.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
[uli: removed "renesas," prefixes from pfc nodes]
Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 arch/arm/boot/dts/r8a7791-koelsch.dts | 68 +++++++++++++++++++++++++++++++++--
 1 file changed, 66 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/r8a7791-koelsch.dts b/arch/arm/boot/dts/r8a7791-koelsch.dts
index f17bfa0..c457b43 100644
--- a/arch/arm/boot/dts/r8a7791-koelsch.dts
+++ b/arch/arm/boot/dts/r8a7791-koelsch.dts
@@ -265,12 +265,23 @@
 		};
 	};
 
+	hdmi-in {
+		compatible = "hdmi-connector";
+		type = "a";
+
+		port {
+			hdmi_con_in: endpoint {
+				remote-endpoint = <&adv7612_in>;
+			};
+		};
+	};
+
 	hdmi-out {
 		compatible = "hdmi-connector";
 		type = "a";
 
 		port {
-			hdmi_con: endpoint {
+			hdmi_con_out: endpoint {
 				remote-endpoint = <&adv7511_out>;
 			};
 		};
@@ -414,6 +425,11 @@
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
@@ -617,7 +633,34 @@
 			port@1 {
 				reg = <1>;
 				adv7511_out: endpoint {
-					remote-endpoint = <&hdmi_con>;
+					remote-endpoint = <&hdmi_con_out>;
+				};
+			};
+		};
+	};
+
+	hdmi-in@4c {
+		compatible = "adi,adv7612";
+		reg = <0x4c>;
+		interrupt-parent = <&gpio4>;
+		interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
+		default-input = <0>;
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@0 {
+				reg = <0>;
+				adv7612_in: endpoint {
+					remote-endpoint = <&hdmi_con_in>;
+				};
+			};
+
+			port@2 {
+				reg = <2>;
+				adv7612_out: endpoint {
+					remote-endpoint = <&vin0ep2>;
 				};
 			};
 		};
@@ -699,6 +742,27 @@
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
+		vin0ep2: endpoint {
+			remote-endpoint = <&adv7612_out>;
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

