Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34594 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933300AbcIPNJp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 09:09:45 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: horms@verge.net.au
Cc: geert@linux-m68k.org, hans.verkuil@cisco.com,
        niklas.soderlund@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com,
        ulrich.hecht+renesas@gmail.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH 3/3] ARM: dts: gose: add composite video input
Date: Fri, 16 Sep 2016 15:09:35 +0200
Message-Id: <20160916130935.21292-4-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <20160916130935.21292-1-ulrich.hecht+renesas@gmail.com>
References: <20160916130935.21292-1-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 arch/arm/boot/dts/r8a7793-gose.dts | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7793-gose.dts b/arch/arm/boot/dts/r8a7793-gose.dts
index e22d63c..981f0fe 100644
--- a/arch/arm/boot/dts/r8a7793-gose.dts
+++ b/arch/arm/boot/dts/r8a7793-gose.dts
@@ -379,6 +379,11 @@
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
@@ -504,6 +509,19 @@
 		reg = <0x12>;
 	};
 
+	composite-in@20 {
+		compatible = "adi,adv7180";
+		reg = <0x20>;
+		remote = <&vin1>;
+
+		port {
+			adv7180: endpoint {
+				bus-width = <8>;
+				remote-endpoint = <&vin1ep>;
+			};
+		};
+	};
+
 	hdmi@39 {
 		compatible = "adi,adv7511w";
 		reg = <0x39>;
@@ -599,3 +617,21 @@
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
+			remote-endpoint = <&adv7180>;
+			bus-width = <8>;
+		};
+	};
+};
-- 
2.9.3

