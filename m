Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34808 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753088AbdBPCUP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 21:20:15 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v4 08/36] ARM: dts: imx6-sabreauto: create i2cmux for i2c3
Date: Wed, 15 Feb 2017 18:19:10 -0800
Message-Id: <1487211578-11360-9-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sabreauto uses a steering pin to select between the SDA signal on
i2c3 bus, and a data-in pin for an SPI NOR chip. Use i2cmux to control
this steering pin. Idle state of the i2cmux selects SPI NOR. This is not
a classic way to use i2cmux, since one side of the mux selects something
other than an i2c bus, but it works and is probably the cleanest
solution. Note that if one thread is attempting to access SPI NOR while
another thread is accessing i2c3, the SPI NOR access will fail since the
i2cmux has selected the SDA pin rather than SPI NOR data-in. This couldn't
be avoided in any case, the board is not designed to allow concurrent
i2c3 and SPI NOR functions (and the default device-tree does not enable
SPI NOR anyway).

Devices hanging off i2c3 should now be defined under i2cmux, so
that the steering pin can be properly controlled to access those
devices. The port expanders (MAX7310) are thus moved into i2cmux.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi | 65 +++++++++++++++++++++-----------
 1 file changed, 44 insertions(+), 21 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
index 52390ba..cace88c 100644
--- a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
@@ -108,6 +108,44 @@
 		default-brightness-level = <7>;
 		status = "okay";
 	};
+
+	i2cmux {
+		compatible = "i2c-mux-gpio";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_i2c3mux>;
+		mux-gpios = <&gpio5 4 0>;
+		i2c-parent = <&i2c3>;
+		idle-state = <0>;
+
+		i2c@1 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <1>;
+
+			max7310_a: gpio@30 {
+				compatible = "maxim,max7310";
+				reg = <0x30>;
+				gpio-controller;
+				#gpio-cells = <2>;
+			};
+
+			max7310_b: gpio@32 {
+				compatible = "maxim,max7310";
+				reg = <0x32>;
+				gpio-controller;
+				#gpio-cells = <2>;
+			};
+
+			max7310_c: gpio@34 {
+				compatible = "maxim,max7310";
+				reg = <0x34>;
+				gpio-controller;
+				#gpio-cells = <2>;
+			};
+		};
+	};
 };
 
 &clks {
@@ -291,27 +329,6 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c3>;
 	status = "okay";
-
-	max7310_a: gpio@30 {
-		compatible = "maxim,max7310";
-		reg = <0x30>;
-		gpio-controller;
-		#gpio-cells = <2>;
-	};
-
-	max7310_b: gpio@32 {
-		compatible = "maxim,max7310";
-		reg = <0x32>;
-		gpio-controller;
-		#gpio-cells = <2>;
-	};
-
-	max7310_c: gpio@34 {
-		compatible = "maxim,max7310";
-		reg = <0x34>;
-		gpio-controller;
-		#gpio-cells = <2>;
-	};
 };
 
 &iomuxc {
@@ -419,6 +436,12 @@
 			>;
 		};
 
+		pinctrl_i2c3mux: i2c3muxgrp {
+			fsl,pins = <
+				MX6QDL_PAD_EIM_A24__GPIO5_IO04 0x0b0b1
+			>;
+		};
+
 		pinctrl_pwm3: pwm1grp {
 			fsl,pins = <
 				MX6QDL_PAD_SD4_DAT1__PWM3_OUT		0x1b0b1
-- 
2.7.4
