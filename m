Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:45379 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757916Ab3CFLy7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 06:54:59 -0500
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, shaik.samsung@gmail.com
Subject: [RFC 09/12] ARM: dts: Adding pinctrl support to Exynos5250 i2c nodes
Date: Wed,  6 Mar 2013 17:23:55 +0530
Message-Id: <1362570838-4737-10-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com>
References: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the default pinctrl functionality to the
i2c device nodes on exynos5250-smdk5250.dts file

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 arch/arm/boot/dts/exynos5250-smdk5250.dts |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index 942d576..4b10744 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -30,8 +30,8 @@
 	i2c@12C60000 {
 		samsung,i2c-sda-delay = <100>;
 		samsung,i2c-max-bus-freq = <20000>;
-		gpios = <&gpb3 0 2 3 0>,
-			<&gpb3 1 2 3 0>;
+		pinctrl-0 = <&i2c0_bus>;
+		pinctrl-names = "default";
 
 		eeprom@50 {
 			compatible = "samsung,s524ad0xd1";
@@ -42,8 +42,8 @@
 	i2c@12C70000 {
 		samsung,i2c-sda-delay = <100>;
 		samsung,i2c-max-bus-freq = <20000>;
-		gpios = <&gpb3 2 2 3 0>,
-			<&gpb3 3 2 3 0>;
+		pinctrl-0 = <&i2c1_bus>;
+		pinctrl-names = "default";
 
 		eeprom@51 {
 			compatible = "samsung,s524ad0xd1";
@@ -69,8 +69,8 @@
 	i2c@12C80000 {
 		samsung,i2c-sda-delay = <100>;
 		samsung,i2c-max-bus-freq = <66000>;
-		gpios = <&gpa0 6 3 3 0>,
-			<&gpa0 7 3 3 0>;
+		pinctrl-0 = <&i2c2_bus>;
+		pinctrl-names = "default";
 
 		hdmiddc@50 {
 			compatible = "samsung,exynos5-hdmiddc";
@@ -80,22 +80,32 @@
 
 	i2c@12C90000 {
 		status = "disabled";
+		pinctrl-0 = <&i2c3_bus>;
+		pinctrl-names = "default";
 	};
 
 	i2c@12CA0000 {
 		status = "disabled";
+		pinctrl-0 = <&i2c4_bus>;
+		pinctrl-names = "default";
 	};
 
 	i2c@12CB0000 {
 		status = "disabled";
+		pinctrl-0 = <&i2c5_bus>;
+		pinctrl-names = "default";
 	};
 
 	i2c@12CC0000 {
 		status = "disabled";
+		pinctrl-0 = <&i2c6_bus>;
+		pinctrl-names = "default";
 	};
 
 	i2c@12CD0000 {
 		status = "disabled";
+		pinctrl-0 = <&i2c7_bus>;
+		pinctrl-names = "default";
 	};
 
 	i2c@12CE0000 {
-- 
1.7.9.5

