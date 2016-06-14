Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35634 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbcFNWvV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2016 18:51:21 -0400
Received: by mail-pf0-f193.google.com with SMTP id t190so302155pfb.2
        for <linux-media@vger.kernel.org>; Tue, 14 Jun 2016 15:51:20 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 22/38] ARM: dts: imx6-sabreauto: add reset-gpios property for max7310
Date: Tue, 14 Jun 2016 15:49:18 -0700
Message-Id: <1465944574-15745-23-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The reset pin to the port expander chip (MAX7310) is controlled by a gpio,
so define a reset-gpios property to control it.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
index 13f50e8..81e3ab7 100644
--- a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
@@ -129,6 +129,9 @@
 				reg = <0x30>;
 				gpio-controller;
 				#gpio-cells = <2>;
+				pinctrl-names = "default";	
+				pinctrl-0 = <&pinctrl_max7310>;
+				reset-gpios = <&gpio1 15 1>;
 			};
 
 			max7310_b: gpio@32 {
@@ -136,6 +139,9 @@
 				reg = <0x32>;
 				gpio-controller;
 				#gpio-cells = <2>;
+				pinctrl-names = "default";	
+				pinctrl-0 = <&pinctrl_max7310>;
+				reset-gpios = <&gpio1 15 1>;
 			};
 
 			max7310_c: gpio@34 {
@@ -143,6 +149,9 @@
 				reg = <0x34>;
 				gpio-controller;
 				#gpio-cells = <2>;
+				pinctrl-names = "default";	
+				pinctrl-0 = <&pinctrl_max7310>;
+				reset-gpios = <&gpio1 15 1>;
 			};
 		};
 	};
@@ -441,6 +450,12 @@
 			>;
 		};
 
+		pinctrl_max7310: max7310grp {
+			fsl,pins = <
+				MX6QDL_PAD_SD2_DAT0__GPIO1_IO15 0x80000000
+			>;
+		};
+
 		pinctrl_pwm3: pwm1grp {
 			fsl,pins = <
 				MX6QDL_PAD_SD4_DAT1__PWM3_OUT		0x1b0b1
-- 
1.9.1

