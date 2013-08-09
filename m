Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54864 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031466Ab3HIXCd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 19:02:33 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: [PATCH/RFC v3 18/19] ARM: shmobile: lager-reference: Add display device nodes to device tree
Date: Sat, 10 Aug 2013 01:03:17 +0200
Message-Id: <1376089398-13322-19-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 arch/arm/boot/dts/r8a7790-lager-reference.dts | 92 +++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7790-lager-reference.dts b/arch/arm/boot/dts/r8a7790-lager-reference.dts
index d9a25d5..ba2469b 100644
--- a/arch/arm/boot/dts/r8a7790-lager-reference.dts
+++ b/arch/arm/boot/dts/r8a7790-lager-reference.dts
@@ -42,6 +42,98 @@
 			gpios = <&gpio5 17 GPIO_ACTIVE_HIGH>;
 		};
 	};
+
+	adv7123 {
+		compatible = "adi,adv7123";
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@0 {
+				reg = <0>;
+				adv7123_in: endpoint {
+					remote-endpoint = <&du_out_rgb>;
+				};
+			};
+			port@1 {
+				reg = <1>;
+				adv7123_out: endpoint {
+					remote-endpoint = <&con_vga_in>;
+				};
+			};
+		};
+	};
+
+	con-vga {
+		compatible = "con-vga";
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@0 {
+				reg = <0>;
+				con_vga_in: endpoint {
+					remote-endpoint = <&adv7123_out>;
+				};
+			};
+		};
+	};
+
+	panel-dpi {
+		compatible = "panel-dpi";
+
+		width-mm = <210>;
+		height-mm = <158>;
+
+		display-timings {
+			timing {
+				/* 1024x768 @65Hz */
+				clock-frequency = <65000000>;
+				hactive = <1024>;
+				vactive = <768>;
+				hsync-len = <136>;
+				hfront-porch = <20>;
+				hback-porch = <160>;
+				vfront-porch = <3>;
+				vback-porch = <29>;
+				vsync-len = <6>;
+			};
+		};
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@0 {
+				reg = <0>;
+				panel_in: endpoint {
+					remote-endpoint = <&du_out_lvds1>;
+				};
+			};
+		};
+	};
+};
+
+&du {
+	pinctrl-0 = <&du_pins>;
+	pinctrl-names = "default";
+};
+
+&du_out_rgb {
+	remote-endpoint = <&adv7123_in>;
+};
+
+&du_out_lvds1 {
+	remote-endpoint = <&panel_in>;
+};
+
+&pfc {
+	du_pins: du {
+		renesas,groups = "du_rgb666", "du_sync_1", "du_clk_out_0";
+		renesas,function = "du";
+	};
 };
 
 &pfc {
-- 
1.8.1.5

