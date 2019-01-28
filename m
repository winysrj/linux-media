Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1F46C282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 14:53:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F12420844
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 14:53:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbfA1OxF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 09:53:05 -0500
Received: from mail.bootlin.com ([62.4.15.54]:53150 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726774AbfA1Owm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 09:52:42 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 63C5A209BF; Mon, 28 Jan 2019 15:52:39 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-87-206.w90-88.abo.wanadoo.fr [90.88.29.206])
        by mail.bootlin.com (Postfix) with ESMTPSA id 353DC20714;
        Mon, 28 Jan 2019 15:52:39 +0100 (CET)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v2 5/5] DO NOT MERGE: ARM: dts: bananapi: Add Camera support
Date:   Mon, 28 Jan 2019 15:52:36 +0100
Message-Id: <b1279df2faefbb50120270417c3f5d66bb52df18.1548687041.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.ba7411f0c7155d0292b38d3dec698e26b5cc813b.1548687041.git-series.maxime.ripard@bootlin.com>
References: <cover.ba7411f0c7155d0292b38d3dec698e26b5cc813b.1548687041.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 arch/arm/boot/dts/sun7i-a20-bananapi.dts | 94 +++++++++++++++++++++++++-
 1 file changed, 94 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20-bananapi.dts b/arch/arm/boot/dts/sun7i-a20-bananapi.dts
index 556b1b591c5d..f5fee1f95900 100644
--- a/arch/arm/boot/dts/sun7i-a20-bananapi.dts
+++ b/arch/arm/boot/dts/sun7i-a20-bananapi.dts
@@ -54,6 +54,9 @@
 	compatible = "lemaker,bananapi", "allwinner,sun7i-a20";
 
 	aliases {
+		i2c0 = &i2c0;
+		i2c1 = &i2c1;
+		i2c2 = &i2c2;
 		serial0 = &uart0;
 		serial1 = &uart3;
 		serial2 = &uart7;
@@ -63,6 +66,41 @@
 		stdout-path = "serial0:115200n8";
 	};
 
+	reg_cam: cam {
+		compatible = "regulator-fixed";
+		regulator-name = "cam";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		vin-supply = <&reg_vcc5v0>;
+		gpio = <&pio 7 16 GPIO_ACTIVE_HIGH>;
+		enable-active-high;
+		regulator-always-on;
+	};
+
+        reg_cam_avdd: cam-avdd {
+                compatible = "regulator-fixed";
+                regulator-name = "cam500b-avdd";
+                regulator-min-microvolt = <2800000>;
+                regulator-max-microvolt = <2800000>;
+                vin-supply = <&reg_cam>;
+        };
+
+        reg_cam_dovdd: cam-dovdd {
+                compatible = "regulator-fixed";
+                regulator-name = "cam500b-dovdd";
+                regulator-min-microvolt = <1800000>;
+                regulator-max-microvolt = <1800000>;
+                vin-supply = <&reg_cam>;
+        };
+
+        reg_cam_dvdd: cam-dvdd {
+                compatible = "regulator-fixed";
+                regulator-name = "cam500b-dvdd";
+                regulator-min-microvolt = <1500000>;
+                regulator-max-microvolt = <1500000>;
+                vin-supply = <&reg_cam>;
+        };
+
 	hdmi-connector {
 		compatible = "hdmi-connector";
 		type = "a";
@@ -116,6 +154,26 @@
 		>;
 };
 
+&csi0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&csi0_pins_a>;
+	status = "okay";
+
+	port {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		csi_from_ov5640: endpoint {
+                        remote-endpoint = <&ov5640_to_csi>;
+                        bus-width = <8>;
+                        hsync-active = <1>; /* Active high */
+                        vsync-active = <0>; /* Active low */
+                        data-active = <1>;  /* Active high */
+                        pclk-sample = <1>;  /* Rising */
+                };
+	};
+};
+
 &de {
 	status = "okay";
 };
@@ -161,6 +219,36 @@
 	};
 };
 
+&i2c1 {
+	status = "okay";
+
+	camera: camera@21 {
+		compatible = "ovti,ov5640";
+		reg = <0x21>;
+                clocks = <&ccu CLK_CSI0>;
+                clock-names = "xclk";
+		assigned-clocks = <&ccu CLK_CSI0>;
+		assigned-clock-rates = <24000000>;
+
+                reset-gpios = <&pio 7 14 GPIO_ACTIVE_LOW>;
+                powerdown-gpios = <&pio 7 19 GPIO_ACTIVE_HIGH>;
+                AVDD-supply = <&reg_cam_avdd>;
+                DOVDD-supply = <&reg_cam_dovdd>;
+                DVDD-supply = <&reg_cam_dvdd>;
+
+                port {
+                        ov5640_to_csi: endpoint {
+                                remote-endpoint = <&csi_from_ov5640>;
+                                bus-width = <8>;
+                                hsync-active = <1>; /* Active high */
+                                vsync-active = <0>; /* Active low */
+                                data-active = <1>;  /* Active high */
+                                pclk-sample = <1>;  /* Rising */
+                        };
+                };
+	};
+};
+
 &i2c2 {
 	status = "okay";
 };
@@ -242,6 +330,12 @@
 		"IO-6", "IO-3", "IO-2", "IO-0", "", "", "", "",
 		"", "", "", "", "", "", "", "";
 
+	csi0_pins_a: csi_pins_a@0 {
+		pins = "PE0", "PE1", "PE2", "PE3", "PE4", "PE5",
+		       "PE6", "PE7", "PE8", "PE9", "PE10", "PE11";
+		function = "csi0";
+	};
+
 	usb0_id_detect_pin: usb0-id-detect-pin {
 		pins = "PH4";
 		function = "gpio_in";
-- 
git-series 0.9.1
