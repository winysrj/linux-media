Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17697 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509AbcEXNby (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 09:31:54 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Uli Middelberg <uli@middelberg.de>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v4 6/7] ARM: dts: exynos: convert MFC device to generic
 reserved memory bindings
Date: Tue, 24 May 2016 15:31:29 +0200
Message-id: <1464096690-23605-7-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1464096690-23605-1-git-send-email-m.szyprowski@samsung.com>
References: <1464096690-23605-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch replaces custom properties for defining reserved memory
regions with generic reserved memory bindings for MFC video codec
device.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/boot/dts/exynos-mfc-reserved-memory.dtsi  | 27 ++++++++++++++++++++++
 arch/arm/boot/dts/exynos4210-origen.dts            |  4 ++--
 arch/arm/boot/dts/exynos4210-smdkv310.dts          |  4 ++--
 arch/arm/boot/dts/exynos4412-origen.dts            |  4 ++--
 arch/arm/boot/dts/exynos4412-smdk4412.dts          |  4 ++--
 arch/arm/boot/dts/exynos5250-arndale.dts           |  4 ++--
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |  4 ++--
 arch/arm/boot/dts/exynos5250-spring.dts            |  4 ++--
 arch/arm/boot/dts/exynos5420-arndale-octa.dts      |  4 ++--
 arch/arm/boot/dts/exynos5420-peach-pit.dts         |  4 ++--
 arch/arm/boot/dts/exynos5420-smdk5420.dts          |  4 ++--
 arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi |  4 ++--
 arch/arm/boot/dts/exynos5800-peach-pi.dts          |  4 ++--
 13 files changed, 51 insertions(+), 24 deletions(-)
 create mode 100644 arch/arm/boot/dts/exynos-mfc-reserved-memory.dtsi

diff --git a/arch/arm/boot/dts/exynos-mfc-reserved-memory.dtsi b/arch/arm/boot/dts/exynos-mfc-reserved-memory.dtsi
new file mode 100644
index 0000000..e7445c9
--- /dev/null
+++ b/arch/arm/boot/dts/exynos-mfc-reserved-memory.dtsi
@@ -0,0 +1,27 @@
+/*
+ * Samsung's Exynos SoC MFC (Video Codec) reserved memory common definition.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/ {
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		mfc_left: region@51000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x51000000 0x800000>;
+		};
+
+		mfc_right: region@43000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x43000000 0x800000>;
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/exynos4210-origen.dts b/arch/arm/boot/dts/exynos4210-origen.dts
index ad7394c..f5e4eb2 100644
--- a/arch/arm/boot/dts/exynos4210-origen.dts
+++ b/arch/arm/boot/dts/exynos4210-origen.dts
@@ -18,6 +18,7 @@
 #include "exynos4210.dtsi"
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/input/input.h>
+#include "exynos-mfc-reserved-memory.dtsi"
 
 / {
 	model = "Insignal Origen evaluation board based on Exynos4210";
@@ -288,8 +289,7 @@
 };
 
 &mfc {
-	samsung,mfc-r = <0x43000000 0x800000>;
-	samsung,mfc-l = <0x51000000 0x800000>;
+	memory-region = <&mfc_left>, <&mfc_right>;
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/exynos4210-smdkv310.dts b/arch/arm/boot/dts/exynos4210-smdkv310.dts
index 94ca7d3..de917f0 100644
--- a/arch/arm/boot/dts/exynos4210-smdkv310.dts
+++ b/arch/arm/boot/dts/exynos4210-smdkv310.dts
@@ -17,6 +17,7 @@
 /dts-v1/;
 #include "exynos4210.dtsi"
 #include <dt-bindings/gpio/gpio.h>
+#include "exynos-mfc-reserved-memory.dtsi"
 
 / {
 	model = "Samsung smdkv310 evaluation board based on Exynos4210";
@@ -133,8 +134,7 @@
 };
 
 &mfc {
-	samsung,mfc-r = <0x43000000 0x800000>;
-	samsung,mfc-l = <0x51000000 0x800000>;
+	memory-region = <&mfc_left>, <&mfc_right>;
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/exynos4412-origen.dts b/arch/arm/boot/dts/exynos4412-origen.dts
index 8bca699..cd363d7 100644
--- a/arch/arm/boot/dts/exynos4412-origen.dts
+++ b/arch/arm/boot/dts/exynos4412-origen.dts
@@ -16,6 +16,7 @@
 #include "exynos4412.dtsi"
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/input/input.h>
+#include "exynos-mfc-reserved-memory.dtsi"
 
 / {
 	model = "Insignal Origen evaluation board based on Exynos4412";
@@ -466,8 +467,7 @@
 };
 
 &mfc {
-	samsung,mfc-r = <0x43000000 0x800000>;
-	samsung,mfc-l = <0x51000000 0x800000>;
+	memory-region = <&mfc_left>, <&mfc_right>;
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/exynos4412-smdk4412.dts b/arch/arm/boot/dts/exynos4412-smdk4412.dts
index a51069f..9b6d561 100644
--- a/arch/arm/boot/dts/exynos4412-smdk4412.dts
+++ b/arch/arm/boot/dts/exynos4412-smdk4412.dts
@@ -14,6 +14,7 @@
 
 /dts-v1/;
 #include "exynos4412.dtsi"
+#include "exynos-mfc-reserved-memory.dtsi"
 
 / {
 	model = "Samsung SMDK evaluation board based on Exynos4412";
@@ -112,8 +113,7 @@
 };
 
 &mfc {
-	samsung,mfc-r = <0x43000000 0x800000>;
-	samsung,mfc-l = <0x51000000 0x800000>;
+	memory-region = <&mfc_left>, <&mfc_right>;
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/exynos5250-arndale.dts b/arch/arm/boot/dts/exynos5250-arndale.dts
index 85dad29..39940f4 100644
--- a/arch/arm/boot/dts/exynos5250-arndale.dts
+++ b/arch/arm/boot/dts/exynos5250-arndale.dts
@@ -14,6 +14,7 @@
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/input/input.h>
 #include "exynos5250.dtsi"
+#include "exynos-mfc-reserved-memory.dtsi"
 
 / {
 	model = "Insignal Arndale evaluation board based on EXYNOS5250";
@@ -516,8 +517,7 @@
 };
 
 &mfc {
-	samsung,mfc-r = <0x43000000 0x800000>;
-	samsung,mfc-l = <0x51000000 0x800000>;
+	memory-region = <&mfc_left>, <&mfc_right>;
 };
 
 &mmc_0 {
diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index b7992b1..9fac874 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -13,6 +13,7 @@
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include "exynos5250.dtsi"
+#include "exynos-mfc-reserved-memory.dtsi"
 
 / {
 	model = "SAMSUNG SMDK5250 board based on EXYNOS5250";
@@ -344,8 +345,7 @@
 };
 
 &mfc {
-	samsung,mfc-r = <0x43000000 0x800000>;
-	samsung,mfc-l = <0x51000000 0x800000>;
+	memory-region = <&mfc_left>, <&mfc_right>;
 };
 
 &mmc_0 {
diff --git a/arch/arm/boot/dts/exynos5250-spring.dts b/arch/arm/boot/dts/exynos5250-spring.dts
index ac291f5..784130b 100644
--- a/arch/arm/boot/dts/exynos5250-spring.dts
+++ b/arch/arm/boot/dts/exynos5250-spring.dts
@@ -14,6 +14,7 @@
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/input/input.h>
 #include "exynos5250.dtsi"
+#include "exynos-mfc-reserved-memory.dtsi"
 
 / {
 	model = "Google Spring";
@@ -425,8 +426,7 @@
 };
 
 &mfc {
-	samsung,mfc-r = <0x43000000 0x800000>;
-	samsung,mfc-l = <0x51000000 0x800000>;
+	memory-region = <&mfc_left>, <&mfc_right>;
 };
 
 &mmc_0 {
diff --git a/arch/arm/boot/dts/exynos5420-arndale-octa.dts b/arch/arm/boot/dts/exynos5420-arndale-octa.dts
index 60bc861..b8b5f3a 100644
--- a/arch/arm/boot/dts/exynos5420-arndale-octa.dts
+++ b/arch/arm/boot/dts/exynos5420-arndale-octa.dts
@@ -16,6 +16,7 @@
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/input/input.h>
 #include <dt-bindings/clock/samsung,s2mps11.h>
+#include "exynos-mfc-reserved-memory.dtsi"
 
 / {
 	model = "Insignal Arndale Octa evaluation board based on EXYNOS5420";
@@ -347,8 +348,7 @@
 };
 
 &mfc {
-	samsung,mfc-r = <0x43000000 0x800000>;
-	samsung,mfc-l = <0x51000000 0x800000>;
+	memory-region = <&mfc_left>, <&mfc_right>;
 };
 
 &mmc_0 {
diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index f9d2e4f..d530b4f 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -16,6 +16,7 @@
 #include <dt-bindings/regulator/maxim,max77802.h>
 #include "exynos5420.dtsi"
 #include "exynos5420-cpus.dtsi"
+#include "exynos-mfc-reserved-memory.dtsi"
 
 / {
 	model = "Google Peach Pit Rev 6+";
@@ -695,8 +696,7 @@
 };
 
 &mfc {
-	samsung,mfc-r = <0x43000000 0x800000>;
-	samsung,mfc-l = <0x51000000 0x800000>;
+	memory-region = <&mfc_left>, <&mfc_right>;
 };
 
 &mmc_0 {
diff --git a/arch/arm/boot/dts/exynos5420-smdk5420.dts b/arch/arm/boot/dts/exynos5420-smdk5420.dts
index 2e748d1..5206f41 100644
--- a/arch/arm/boot/dts/exynos5420-smdk5420.dts
+++ b/arch/arm/boot/dts/exynos5420-smdk5420.dts
@@ -13,6 +13,7 @@
 #include "exynos5420.dtsi"
 #include "exynos5420-cpus.dtsi"
 #include <dt-bindings/gpio/gpio.h>
+#include "exynos-mfc-reserved-memory.dtsi"
 
 / {
 	model = "Samsung SMDK5420 board based on EXYNOS5420";
@@ -355,8 +356,7 @@
 };
 
 &mfc {
-	samsung,mfc-r = <0x43000000 0x800000>;
-	samsung,mfc-l = <0x51000000 0x800000>;
+	memory-region = <&mfc_left>, <&mfc_right>;
 };
 
 &mmc_0 {
diff --git a/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi b/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
index 2a4e10b..7c2335f 100644
--- a/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
+++ b/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
@@ -17,6 +17,7 @@
 #include "exynos5800.dtsi"
 #include "exynos5422-cpus.dtsi"
 #include "exynos5422-cpu-thermal.dtsi"
+#include "exynos-mfc-reserved-memory.dtsi"
 
 / {
 	memory {
@@ -406,8 +407,7 @@
 };
 
 &mfc {
-	samsung,mfc-r = <0x43000000 0x800000>;
-	samsung,mfc-l = <0x51000000 0x800000>;
+	memory-region = <&mfc_left>, <&mfc_right>;
 };
 
 &mmc_0 {
diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index 62ceb89..1f73596 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -16,6 +16,7 @@
 #include <dt-bindings/regulator/maxim,max77802.h>
 #include "exynos5800.dtsi"
 #include "exynos5420-cpus.dtsi"
+#include "exynos-mfc-reserved-memory.dtsi"
 
 / {
 	model = "Google Peach Pi Rev 10+";
@@ -670,8 +671,7 @@
 };
 
 &mfc {
-	samsung,mfc-r = <0x43000000 0x800000>;
-	samsung,mfc-l = <0x51000000 0x800000>;
+	memory-region = <&mfc_left>, <&mfc_right>;
 };
 
 &mmc_0 {
-- 
1.9.2

