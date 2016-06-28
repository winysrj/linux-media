Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35396 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbcF1TTQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 15:19:16 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-amlogic@lists.infradead.org, linux-media@vger.kernel.org
Cc: robh+dt@kernel.org, mark.rutland@arm.com, carlo@caione.org,
	khilman@baylibre.com, mchehab@kernel.org,
	devicetree@vger.kernel.org, narmstrong@baylibre.com,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 4/4] ARM64: dts: meson-gxbb: Enable the the IR decoder on supported boards
Date: Tue, 28 Jun 2016 21:18:02 +0200
Message-Id: <20160628191802.21227-5-martin.blumenstingl@googlemail.com>
In-Reply-To: <20160628191802.21227-1-martin.blumenstingl@googlemail.com>
References: <20160626210622.5257-1-martin.blumenstingl@googlemail.com>
 <20160628191802.21227-1-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable the Infrared Remote Controller on boards which have an Infrared
receiver.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts  | 4 ++++
 arch/arm64/boot/dts/amlogic/meson-gxbb-p20x.dtsi     | 4 ++++
 arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi | 4 ++++
 3 files changed, 12 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts b/arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts
index b06bf8a..9a451ce 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts
@@ -120,3 +120,7 @@
 	vmmc-supply = <&mmc_iv>;
 	voltage-ranges = <1800 3300>;
 };
+
+&ir {
+	status = "okay";
+};
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-p20x.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb-p20x.dtsi
index 5dfd849..2650bb7 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb-p20x.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-p20x.dtsi
@@ -102,3 +102,7 @@
 	voltage-ranges = <1800 3300>;
 	vmmc-supply = <&mmc_iv>;
 };
+
+&ir {
+	status = "okay";
+};
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi
index 54bb7c7..934deb9 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi
@@ -60,3 +60,7 @@
 	pinctrl-names = "default";
 
 };
+
+&ir {
+	status = "okay";
+};
-- 
2.9.0

