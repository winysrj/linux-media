Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:50993 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752539AbeCEKEz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Mar 2018 05:04:55 -0500
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Yong Deng <yong.deng@magewell.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 4/4] [DO NOT MERGE] ARM: dts: sun8i: Add CAM500B camera module to the Nano Pi M1+
Date: Mon,  5 Mar 2018 11:04:32 +0100
Message-Id: <20180305100432.15009-5-maxime.ripard@bootlin.com>
In-Reply-To: <20180305100432.15009-1-maxime.ripard@bootlin.com>
References: <20180305100432.15009-1-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mylène Josserand <mylene.josserand@bootlin.com>

The Nano Pi M1+ comes with an optional sensor based on the ov5640 from
Omnivision. Enable the support for it in the DT.

Signed-off-by: Mylène Josserand <mylene.josserand@bootlin.com>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 arch/arm/boot/dts/sun8i-h3-nanopi-m1-plus.dts | 85 +++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-h3-nanopi-m1-plus.dts b/arch/arm/boot/dts/sun8i-h3-nanopi-m1-plus.dts
index d7b6e1ac541a..a2d1c6bb8406 100644
--- a/arch/arm/boot/dts/sun8i-h3-nanopi-m1-plus.dts
+++ b/arch/arm/boot/dts/sun8i-h3-nanopi-m1-plus.dts
@@ -52,6 +52,37 @@
 		ethernet1 = &sdio_wifi;
 	};
 
+	cam_xclk: cam-xclk {
+                #clock-cells = <0>;
+                compatible = "fixed-clock";
+                clock-frequency = <24000000>;
+                clock-output-names = "cam-xclk";
+        };
+
+        reg_cam_avdd: cam-avdd {
+                compatible = "regulator-fixed";
+                regulator-name = "cam500b-avdd";
+                regulator-min-microvolt = <2800000>;
+                regulator-max-microvolt = <2800000>;
+                vin-supply = <&reg_vcc3v3>;
+        };
+
+        reg_cam_dovdd: cam-dovdd {
+                compatible = "regulator-fixed";
+                regulator-name = "cam500b-dovdd";
+                regulator-min-microvolt = <1800000>;
+                regulator-max-microvolt = <1800000>;
+                vin-supply = <&reg_vcc3v3>;
+        };
+
+        reg_cam_dvdd: cam-dvdd {
+                compatible = "regulator-fixed";
+                regulator-name = "cam500b-dvdd";
+                regulator-min-microvolt = <1500000>;
+                regulator-max-microvolt = <1500000>;
+                vin-supply = <&reg_vcc3v3>;
+        };
+
 	reg_gmac_3v3: gmac-3v3 {
 		compatible = "regulator-fixed";
 		regulator-name = "gmac-3v3";
@@ -69,6 +100,26 @@
 	};
 };
 
+&csi {
+        status = "okay";
+
+        port {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                /* Parallel bus endpoint */
+                csi_from_ov5640: endpoint {
+                        remote-endpoint = <&ov5640_to_csi>;
+                        bus-width = <8>;
+                        data-shift = <2>;
+                        hsync-active = <1>; /* Active high */
+                        vsync-active = <0>; /* Active low */
+                        data-active = <1>;  /* Active high */
+                        pclk-sample = <1>;  /* Rising */
+                };
+        };
+};
+
 &ehci1 {
 	status = "okay";
 };
@@ -94,6 +145,40 @@
 	};
 };
 
+&i2c2 {
+	status = "okay";
+
+	ov5640: camera@3c {
+                compatible = "ovti,ov5640";
+                reg = <0x3c>;
+                clocks = <&cam_xclk>;
+                clock-names = "xclk";
+
+                reset-gpios = <&pio 4 14 GPIO_ACTIVE_LOW>;
+                powerdown-gpios = <&pio 4 15 GPIO_ACTIVE_HIGH>;
+                AVDD-supply = <&reg_cam_avdd>;
+                DOVDD-supply = <&reg_cam_dovdd>;
+                DVDD-supply = <&reg_cam_dvdd>;
+
+                port {
+                        ov5640_to_csi: endpoint {
+                                remote-endpoint = <&csi_from_ov5640>;
+                                bus-width = <8>;
+                                data-shift = <2>;
+                                hsync-active = <1>; /* Active high */
+                                vsync-active = <0>; /* Active low */
+                                data-active = <1>;  /* Active high */
+                                pclk-sample = <1>;  /* Rising */
+                        };
+                };
+        };
+
+};
+
+&i2c2_pins {
+	bias-pull-up;
+};
+
 &ir {
 	pinctrl-names = "default";
 	pinctrl-0 = <&ir_pins_a>;
-- 
2.14.3
