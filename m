Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:50005 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486AbcDRJiT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2016 05:38:19 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Ulrich Hecht <ulrich.hecht@gmail.com>,
	=?UTF-8?Q?Niklas_S=c3=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	Magnus Damm <magnus.damm@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] r8a7791-koelsch.dts: add HDMI input
Message-ID: <5714AAFF.9050908@xs4all.nl>
Date: Mon, 18 Apr 2016 11:38:07 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support in the dts for the HDMI input. Based on the Lager dts
patch from Ultich Hecht.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Ulrich, can you add this patch to your r-car HDMI patch series?

Thanks!

	Hans
---
 arch/arm/boot/dts/r8a7791-koelsch.dts | 41 +++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7791-koelsch.dts b/arch/arm/boot/dts/r8a7791-koelsch.dts
index 0ad71b8..e4c2ec83 100644
--- a/arch/arm/boot/dts/r8a7791-koelsch.dts
+++ b/arch/arm/boot/dts/r8a7791-koelsch.dts
@@ -394,6 +394,11 @@
 		renesas,function = "usb1";
 	};

+	vin0_pins: vin0 {
+		renesas,groups = "vin0_data24", "vin0_sync", "vin0_clkenb", "vin0_clk";
+		renesas,function = "vin0";
+	};
+
 	vin1_pins: vin1 {
 		renesas,groups = "vin1_data8", "vin1_clk";
 		renesas,function = "vin1";
@@ -552,6 +557,21 @@
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
2.8.0.rc3

