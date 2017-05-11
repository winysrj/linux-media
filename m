Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933204AbdEKR1U (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 May 2017 13:27:20 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        sakari.ailus@iki.fi
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [RFC PATCH v2 2/4] arm64: dts: r8a7795: salvator-x: enable VIN, CSI and ADV7482
Date: Thu, 11 May 2017 18:21:21 +0100
Message-Id: <b7f89ec984dcb1cd14c61de72b43c6e55fd80b88.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.5d2526b759f71c06d51df279c3d5885aca476fb6.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.5d2526b759f71c06d51df279c3d5885aca476fb6.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.5d2526b759f71c06d51df279c3d5885aca476fb6.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.5d2526b759f71c06d51df279c3d5885aca476fb6.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Provide bindings between the VIN, CSI and the ADV7482 on the r8a7795.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 arch/arm64/boot/dts/renesas/r8a7795-salvator-x.dts | 147 ++++++++++++++-
 1 file changed, 147 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a7795-salvator-x.dts b/arch/arm64/boot/dts/renesas/r8a7795-salvator-x.dts
index 7a8986edcdc0..e295f041b36a 100644
--- a/arch/arm64/boot/dts/renesas/r8a7795-salvator-x.dts
+++ b/arch/arm64/boot/dts/renesas/r8a7795-salvator-x.dts
@@ -196,6 +196,22 @@
 			};
 		};
 	};
+
+	hdmi {
+		port {
+			hdmi_in: endpoint {
+				remote-endpoint = <&adv7482_hdmi>;
+			};
+		};
+	};
+
+	cvbs {
+		port {
+			cvbs_in: endpoint {
+				remote-endpoint = <&adv7482_ain8>;
+			};
+		};
+	};
 };
 
 &du {
@@ -387,6 +403,68 @@
 	};
 };
 
+&i2c4 {
+	status = "okay";
+
+	clock-frequency = <100000>;
+
+	video-receiver@70 {
+		compatible = "adi,adv7482";
+		reg = <0x70>;
+
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		port@0 {
+			reg = <0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			adv7482_hdmi: endpoint@1 {
+				reg = <1>;
+				remote-endpoint = <&hdmi_in>;
+			};
+		};
+
+		port@8 {
+			reg = <8>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			adv7482_ain8: endpoint@1 {
+				reg = <1>;
+				remote-endpoint = <&cvbs_in>;
+			};
+		};
+
+		port@10 {
+			reg = <10>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			adv7482_txa: endpoint@1 {
+				reg = <1>;
+				clock-lanes = <0>;
+				data-lanes = <1 2 3 4>;
+				remote-endpoint = <&csi40_in>;
+			};
+		};
+
+		port@11 {
+			reg = <11>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			adv7482_txb: endpoint@1 {
+				reg = <1>;
+				clock-lanes = <0>;
+				data-lanes = <1>;
+				remote-endpoint = <&csi20_in>;
+			};
+		};
+	};
+};
+
 &rcar_sound {
 	pinctrl-0 = <&sound_pins &sound_clk_pins>;
 	pinctrl-names = "default";
@@ -577,3 +655,72 @@
 &pciec1 {
 	status = "okay";
 };
+
+&vin0 {
+	status = "okay";
+};
+
+&vin1 {
+	status = "okay";
+};
+
+&vin2 {
+	status = "okay";
+};
+
+&vin3 {
+	status = "okay";
+};
+
+&vin4 {
+	status = "okay";
+};
+
+&vin5 {
+	status = "okay";
+};
+
+&vin6 {
+	status = "okay";
+};
+
+&vin7 {
+	status = "okay";
+};
+
+&csi20 {
+	status = "okay";
+
+	ports {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		port@0 {
+			reg = <0>;
+			csi20_in: endpoint@0 {
+				clock-lanes = <0>;
+				data-lanes = <1>;
+				remote-endpoint = <&adv7482_txb>;
+			};
+		};
+	};
+};
+
+&csi40 {
+	status = "okay";
+
+	ports {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		port@0 {
+			reg = <0>;
+
+			csi40_in: endpoint@0 {
+				clock-lanes = <0>;
+				data-lanes = <1 2 3 4>;
+				remote-endpoint = <&adv7482_txa>;
+			};
+		};
+	};
+};
-- 
git-series 0.9.1
