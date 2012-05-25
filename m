Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46844 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932867Ab2EYTxN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 15:53:13 -0400
Date: Fri, 25 May 2012 21:52:49 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC/PATCH 10/13] ARM: dts: Add camera devices to exynos4210-nuri.dts
In-reply-to: <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Message-id: <1337975573-27117-10-git-send-email-s.nawrocki@samsung.com>
Content-transfer-encoding: 7BIT
References: <4FBFE1EC.9060209@samsung.com>
 <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos4210-nuri.dts |   54 +++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4210-nuri.dts b/arch/arm/boot/dts/exynos4210-nuri.dts
index 103092c..d04f596 100644
--- a/arch/arm/boot/dts/exynos4210-nuri.dts
+++ b/arch/arm/boot/dts/exynos4210-nuri.dts
@@ -444,6 +444,21 @@
 
 		gpios = <&gpc1 3 4 3 0>,
 			<&gpc1 4 4 3 0>;
+
+		s5k6aafx: s5k6aafx@3c {
+			compatible = "samsung,s5k6aafx";
+			reg = <0x3c>;
+			clock-frequency = <24000000>;
+			gpio-rst = <&gpl2 1 2 0 3>;
+			samsung,s5k6aa-inv-rst;
+			gpio-stby = <&gpl2 0 2 0 3>;
+			samsung,s5k6aa-inv-stby;
+			video-bus-type = "itu-601";
+			vdd_core-supply = <&camv1_5_reg>;
+			vdda-supply = <&camvdda_reg>;
+			vdd_reg-supply = <&vpda_reg>;
+			vddio-supply = <&vtcam_reg>;
+		};
 	};
 
 	i2c7: i2c@138D0000 {
@@ -493,6 +508,7 @@
 			gpio-reset = <&gpf3 4 0 0 0>;
 			hdmi-en-supply = <&hdmi_reg>;
 		};
+
 	};
 
 	g2d: gpu@12800000 {
@@ -564,4 +580,42 @@
 	       reg = <0xf8183c80 0x20>;
 	};
 
+	csis0: csis@11880000 {
+		vddcore-supply = <&vusb_reg>;
+		vddio-supply = <&vmipi_reg>;
+	};
+
+	csis1: csis@11890000 {
+		status = "disabled";
+	};
+
+	camera {
+		compatible = "samsung,fimc";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		fimc-controllers = <&fimc0 &fimc1>;
+		csi-rx-controllers = <&csis0>;
+		samsung,camport-a-gpios = <&gpj0 0 2 0 0>,
+					  <&gpj0 1 2 0 0>,
+					  <&gpj0 2 2 0 0>,
+					  <&gpj0 3 2 0 0>,
+					  <&gpj0 4 2 0 0>,
+					  <&gpj0 5 2 0 0>,
+					  <&gpj0 6 2 0 0>,
+					  <&gpj0 7 2 0 0>,
+					  <&gpj1 0 2 0 0>,
+					  <&gpj1 1 2 0 0>,
+					  <&gpj1 2 2 0 0>,
+					  <&gpj1 3 2 0 3>,
+					  <&gpj1 4 2 0 0>;
+		sensor@0 {
+			 i2c-client = <&s5k6aafx>;
+			 samsung,camif-mux-id = <0>;
+			 samsung,fimc-clk-id = <0>;
+			 video-bus-type = "itu-601";
+		};
+	};
+
 };
-- 
1.7.10

