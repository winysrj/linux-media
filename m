Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36658 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755217AbdESNHT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 May 2017 09:07:19 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-renesas-soc@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org, geert@linux-m68k.org,
        magnus.damm@gmail.com, hans.verkuil@cisco.com,
        niklas.soderlund@ragnatech.se, sergei.shtylyov@cogentembedded.com,
        horms@verge.net.au, devicetree@vger.kernel.org,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v3 4/4] ARM: dts: gose: add composite video input
Date: Fri, 19 May 2017 15:07:04 +0200
Message-Id: <1495199224-16337-5-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1495199224-16337-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1495199224-16337-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds VIN, decoder and connector.

Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 arch/arm/boot/dts/r8a7793-gose.dts | 59 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7793-gose.dts b/arch/arm/boot/dts/r8a7793-gose.dts
index 30f0835..76e3aca 100644
--- a/arch/arm/boot/dts/r8a7793-gose.dts
+++ b/arch/arm/boot/dts/r8a7793-gose.dts
@@ -275,6 +275,16 @@
 		};
 	};
 
+	composite-in {
+		compatible = "composite-video-connector";
+
+		port {
+			composite_con_in: endpoint {
+				remote-endpoint = <&adv7180_in>;
+			};
+		};
+	};
+
 	x2_clk: x2-clock {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
@@ -411,6 +421,11 @@
 		groups = "vin0_data24", "vin0_sync", "vin0_clkenb", "vin0_clk";
 		function = "vin0";
 	};
+
+	vin1_pins: vin1 {
+		groups = "vin1_data8", "vin1_clk";
+		function = "vin1";
+	};
 };
 
 &ether {
@@ -542,6 +557,32 @@
 		reg = <0x12>;
 	};
 
+	composite-in@20 {
+		compatible = "adi,adv7180cp";
+		reg = <0x20>;
+		remote = <&vin1>;
+
+		port {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@0 {
+				reg = <0>;
+				adv7180_in: endpoint {
+					remote-endpoint = <&composite_con_in>;
+				};
+			};
+
+			port@3 {
+				reg = <3>;
+				adv7180_out: endpoint {
+					bus-width = <8>;
+					remote-endpoint = <&vin1ep>;
+				};
+			};
+		};
+	};
+
 	hdmi@39 {
 		compatible = "adi,adv7511w";
 		reg = <0x39>;
@@ -670,3 +711,21 @@
 		};
 	};
 };
+
+/* composite video input */
+&vin1 {
+	pinctrl-0 = <&vin1_pins>;
+	pinctrl-names = "default";
+
+	status = "okay";
+
+	port {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		vin1ep: endpoint {
+			remote-endpoint = <&adv7180_out>;
+			bus-width = <8>;
+		};
+	};
+};
-- 
2.7.4
