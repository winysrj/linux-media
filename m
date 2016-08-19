Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34663 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755137AbcHSV5c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 17:57:32 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        narmstrong@baylibre.com, khilman@baylibre.com, carlo@caione.org
Cc: linux-arm-kernel@lists.infradead.org, linus.walleij@linaro.org,
        mchehab@kernel.org, will.deacon@arm.com, catalin.marinas@arm.com,
        mark.rutland@arm.com, robh+dt@kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v4 6/6] ARM64: dts: meson-gxbb: Enable the the IR decoder on supported boards
Date: Fri, 19 Aug 2016 23:55:47 +0200
Message-Id: <20160819215547.20063-7-martin.blumenstingl@googlemail.com>
In-Reply-To: <20160819215547.20063-1-martin.blumenstingl@googlemail.com>
References: <20160628191802.21227-1-martin.blumenstingl@googlemail.com>
 <20160819215547.20063-1-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable the Infrared Remote Controller on boards which have an Infrared
receiver.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts  | 6 ++++++
 arch/arm64/boot/dts/amlogic/meson-gxbb-p20x.dtsi     | 6 ++++++
 arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi | 6 ++++++
 3 files changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts b/arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts
index cba3ea1..9900b87 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts
@@ -161,3 +161,9 @@
 	vmmc-supply = <&vcc3v3>;
 	vmmcq-sumpply = <&vcc1v8>;
 };
+
+&ir {
+	status = "okay";
+	pinctrl-0 = <&ir_in_ao_pins>;
+	pinctrl-names = "default";
+};
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-p20x.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb-p20x.dtsi
index e118754..dc007fe 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb-p20x.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-p20x.dtsi
@@ -143,3 +143,9 @@
 	vmmc-supply = <&vcc_3v3>;
 	vmmcq-sumpply = <&vddio_boot>;
 };
+
+&ir {
+	status = "okay";
+	pinctrl-0 = <&ir_in_ao_pins>;
+	pinctrl-names = "default";
+};
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi
index 54bb7c7..45cd3ae 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi
@@ -60,3 +60,9 @@
 	pinctrl-names = "default";
 
 };
+
+&ir {
+	status = "okay";
+	pinctrl-0 = <&ir_in_ao_pins>;
+	pinctrl-names = "default";
+};
-- 
2.9.3

