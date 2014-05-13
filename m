Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:35004 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbaEMSkY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 May 2014 14:40:24 -0400
Received: by mail-la0-f50.google.com with SMTP id b8so615956lan.9
        for <linux-media@vger.kernel.org>; Tue, 13 May 2014 11:40:23 -0700 (PDT)
From: Alexander Bersenev <bay@hackerdom.ru>
To: linux-sunxi@googlegroups.com, david@hardeman.nu,
	devicetree@vger.kernel.org, galak@codeaurora.org,
	grant.likely@linaro.org, ijc+devicetree@hellion.org.uk,
	james.hogan@imgtec.com, linux-arm-kernel@lists.infradead.org,
	linux@arm.linux.org.uk, m.chehab@samsung.com, mark.rutland@arm.com,
	maxime.ripard@free-electrons.com, pawel.moll@arm.com,
	rdunlap@infradead.org, robh+dt@kernel.org, sean@mess.org,
	srinivas.kandagatla@st.com, wingrime@linux-sunxi.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: Alexander Bersenev <bay@hackerdom.ru>
Subject: [PATCH v6 3/3] ARM: sunxi: Add IR controller support in DT on A20
Date: Wed, 14 May 2014 00:39:02 +0600
Message-Id: <1400006342-2968-4-git-send-email-bay@hackerdom.ru>
In-Reply-To: <1400006342-2968-1-git-send-email-bay@hackerdom.ru>
References: <1400006342-2968-1-git-send-email-bay@hackerdom.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds IR controller in A20 Device-Tree:
- Two IR devices found in A20 user manual
- Pins for two devices
- One IR device physically found on Cubieboard 2
- One IR device physically found on Cubietruck

Signed-off-by: Alexander Bersenev <bay@hackerdom.ru>
Signed-off-by: Alexsey Shestacov <wingrime@linux-sunxi.org>
---
 arch/arm/boot/dts/sun7i-a20-cubieboard2.dts |  6 ++++++
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts  |  6 ++++++
 arch/arm/boot/dts/sun7i-a20.dtsi            | 31 +++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts b/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
index feeff64..2564e8c 100644
--- a/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
+++ b/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
@@ -164,6 +164,12 @@
 				reg = <1>;
 			};
 		};
+
+		ir0: ir@01c21800 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&ir0_pins_a>;
+			status = "okay";
+		};
 	};
 
 	leds {
diff --git a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
index e288562..e375e89 100644
--- a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
+++ b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
@@ -232,6 +232,12 @@
 				reg = <1>;
 			};
 		};
+
+		ir0: ir@01c21800 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&ir0_pins_a>;
+			status = "okay";
+		};
 	};
 
 	leds {
diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 0ae2b77..40ded74 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -724,6 +724,19 @@
 				allwinner,drive = <2>;
 				allwinner,pull = <0>;
 			};
+
+			ir0_pins_a: ir0@0 {
+				    allwinner,pins = "PB3","PB4";
+				    allwinner,function = "ir0";
+				    allwinner,drive = <0>;
+				    allwinner,pull = <0>;
+			};
+			ir1_pins_a: ir1@0 {
+				    allwinner,pins = "PB22","PB23";
+				    allwinner,function = "ir1";
+				    allwinner,drive = <0>;
+				    allwinner,pull = <0>;
+			};
 		};
 
 		timer@01c20c00 {
@@ -937,5 +950,23 @@
 			#interrupt-cells = <3>;
 			interrupts = <1 9 0xf04>;
 		};
+
+		ir0: ir@01c21800 {
+			compatible = "allwinner,sun7i-a20-ir";
+			clocks = <&apb0_gates 6>, <&ir0_clk>;
+			clock-names = "apb", "ir";
+			interrupts = <0 5 4>;
+			reg = <0x01c21800 0x40>;
+			status = "disabled";
+		};
+
+		ir1: ir@01c21c00 {
+			compatible = "allwinner,sun7i-a20-ir";
+			clocks = <&apb0_gates 7>, <&ir1_clk>;
+			clock-names = "apb", "ir";
+			interrupts = <0 6 4>;
+			reg = <0x01C21c00 0x40>;
+			status = "disabled";
+		};
 	};
 };
-- 
1.9.3

