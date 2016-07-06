Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:33965 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878AbcGFXh1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 19:37:27 -0400
Received: by mail-pa0-f67.google.com with SMTP id us13so152217pab.1
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 16:37:03 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 4/6] ARM: dts: imx6-sabreauto: add reset-gpios property for max7310_b
Date: Wed,  6 Jul 2016 16:36:41 -0700
Message-Id: <1467848203-14007-5-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1467848203-14007-1-git-send-email-steve_longerbeam@mentor.com>
References: <1467848203-14007-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The reset pin to the port expander chip (MAX7310) is controlled by a gpio,
so define a reset-gpios property to control it. There are three MAX7310's
on the SabreAuto CPU card (max7310_[abc]), but all use the same pin for
their reset. Since all can't acquire the same pin, assign it to max7310_b,
that chip is needed by more functions (usb and adv7180).

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
index 13f50e8..3f12d74 100644
--- a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
@@ -136,6 +136,9 @@
 				reg = <0x32>;
 				gpio-controller;
 				#gpio-cells = <2>;
+				pinctrl-names = "default";	
+				pinctrl-0 = <&pinctrl_max7310>;
+				reset-gpios = <&gpio1 15 GPIO_ACTIVE_LOW>;
 			};
 
 			max7310_c: gpio@34 {
@@ -441,6 +444,12 @@
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

