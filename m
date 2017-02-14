Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39062 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751887AbdBNHw0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 02:52:26 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCH 15/15] ARM: dts: exynos: Remove MFC reserved buffers
Date: Tue, 14 Feb 2017 08:52:08 +0100
Message-id: <1487058728-16501-16-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
References: <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170214075221eucas1p18648b047f71e9dd95626e5766c74601b@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

During my research I found that some of the requirements for the memory
buffers for MFC v6+ devices were blindly copied from the previous (v5)
version and simply turned out to be excessive. The relaxed requirements
are applied by the recent patches to the MFC driver and the driver is
now fully functional even without the reserved memory blocks for all
v6+ variants. This patch removes those reserved memory nodes from all
boards having MFC v6+ hardware block.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/boot/dts/exynos5250-arndale.dts           | 1 -
 arch/arm/boot/dts/exynos5250-smdk5250.dts          | 1 -
 arch/arm/boot/dts/exynos5250-spring.dts            | 1 -
 arch/arm/boot/dts/exynos5420-arndale-octa.dts      | 1 -
 arch/arm/boot/dts/exynos5420-peach-pit.dts         | 1 -
 arch/arm/boot/dts/exynos5420-smdk5420.dts          | 1 -
 arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi | 1 -
 arch/arm/boot/dts/exynos5800-peach-pi.dts          | 1 -
 8 files changed, 8 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250-arndale.dts b/arch/arm/boot/dts/exynos5250-arndale.dts
index 6098dacd09f1..6a432460eb77 100644
--- a/arch/arm/boot/dts/exynos5250-arndale.dts
+++ b/arch/arm/boot/dts/exynos5250-arndale.dts
@@ -14,7 +14,6 @@
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/input/input.h>
 #include "exynos5250.dtsi"
-#include "exynos-mfc-reserved-memory.dtsi"
 
 / {
 	model = "Insignal Arndale evaluation board based on EXYNOS5250";
diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index a97a785ccc6b..6632f657394e 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -13,7 +13,6 @@
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include "exynos5250.dtsi"
-#include "exynos-mfc-reserved-memory.dtsi"
 
 / {
 	model = "SAMSUNG SMDK5250 board based on EXYNOS5250";
diff --git a/arch/arm/boot/dts/exynos5250-spring.dts b/arch/arm/boot/dts/exynos5250-spring.dts
index 4d7bdb735ed3..95c3bcace9dc 100644
--- a/arch/arm/boot/dts/exynos5250-spring.dts
+++ b/arch/arm/boot/dts/exynos5250-spring.dts
@@ -14,7 +14,6 @@
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/input/input.h>
 #include "exynos5250.dtsi"
-#include "exynos-mfc-reserved-memory.dtsi"
 
 / {
 	model = "Google Spring";
diff --git a/arch/arm/boot/dts/exynos5420-arndale-octa.dts b/arch/arm/boot/dts/exynos5420-arndale-octa.dts
index 9cc83c51c925..ee1bb9b8b366 100644
--- a/arch/arm/boot/dts/exynos5420-arndale-octa.dts
+++ b/arch/arm/boot/dts/exynos5420-arndale-octa.dts
@@ -16,7 +16,6 @@
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/input/input.h>
 #include <dt-bindings/clock/samsung,s2mps11.h>
-#include "exynos-mfc-reserved-memory.dtsi"
 
 / {
 	model = "Insignal Arndale Octa evaluation board based on EXYNOS5420";
diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index 1f964ec35c5e..2cd65699a29c 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -16,7 +16,6 @@
 #include <dt-bindings/regulator/maxim,max77802.h>
 #include "exynos5420.dtsi"
 #include "exynos5420-cpus.dtsi"
-#include "exynos-mfc-reserved-memory.dtsi"
 
 / {
 	model = "Google Peach Pit Rev 6+";
diff --git a/arch/arm/boot/dts/exynos5420-smdk5420.dts b/arch/arm/boot/dts/exynos5420-smdk5420.dts
index aaccd0da41e5..08c8ab173e87 100644
--- a/arch/arm/boot/dts/exynos5420-smdk5420.dts
+++ b/arch/arm/boot/dts/exynos5420-smdk5420.dts
@@ -13,7 +13,6 @@
 #include "exynos5420.dtsi"
 #include "exynos5420-cpus.dtsi"
 #include <dt-bindings/gpio/gpio.h>
-#include "exynos-mfc-reserved-memory.dtsi"
 
 / {
 	model = "Samsung SMDK5420 board based on EXYNOS5420";
diff --git a/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi b/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
index 05b9afdd6757..657535e2e3cc 100644
--- a/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
+++ b/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
@@ -18,7 +18,6 @@
 #include <dt-bindings/sound/samsung-i2s.h>
 #include "exynos5800.dtsi"
 #include "exynos5422-cpus.dtsi"
-#include "exynos-mfc-reserved-memory.dtsi"
 
 / {
 	memory@40000000 {
diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index f9ff7f07ae0c..ecf1c916e8fc 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -16,7 +16,6 @@
 #include <dt-bindings/regulator/maxim,max77802.h>
 #include "exynos5800.dtsi"
 #include "exynos5420-cpus.dtsi"
-#include "exynos-mfc-reserved-memory.dtsi"
 
 / {
 	model = "Google Peach Pi Rev 10+";
-- 
1.9.1
