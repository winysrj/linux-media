Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:36360 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751787AbdIKM36 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 08:29:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, thierry.reding@gmail.com,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv4 2/4] ARM: tegra: add CEC support to tegra124.dtsi
Date: Mon, 11 Sep 2017 14:29:50 +0200
Message-Id: <20170911122952.33980-3-hverkuil@xs4all.nl>
In-Reply-To: <20170911122952.33980-1-hverkuil@xs4all.nl>
References: <20170911122952.33980-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for the Tegra CEC IP to tegra124.dtsi and enable it on the
Jetson TK1.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 arch/arm/boot/dts/tegra124-jetson-tk1.dts |  4 ++++
 arch/arm/boot/dts/tegra124.dtsi           | 12 +++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
index 7bacb2954f58..7f56de6890c3 100644
--- a/arch/arm/boot/dts/tegra124-jetson-tk1.dts
+++ b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
@@ -67,6 +67,10 @@
 		};
 	};
 
+	cec@70015000 {
+		status = "okay";
+	};
+
 	gpu@0,57000000 {
 		/*
 		 * Node left disabled on purpose - the bootloader will enable
diff --git a/arch/arm/boot/dts/tegra124.dtsi b/arch/arm/boot/dts/tegra124.dtsi
index 1b10b14a6abd..1a21e527fb6e 100644
--- a/arch/arm/boot/dts/tegra124.dtsi
+++ b/arch/arm/boot/dts/tegra124.dtsi
@@ -123,7 +123,7 @@
 			nvidia,head = <1>;
 		};
 
-		hdmi@54280000 {
+		hdmi: hdmi@54280000 {
 			compatible = "nvidia,tegra124-hdmi";
 			reg = <0x0 0x54280000 0x0 0x00040000>;
 			interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;
@@ -851,6 +851,16 @@
 		status = "disabled";
 	};
 
+	cec@70015000 {
+		compatible = "nvidia,tegra124-cec";
+		reg = <0x0 0x70015000 0x0 0x00001000>;
+		interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&tegra_car TEGRA124_CLK_CEC>;
+		clock-names = "cec";
+		hdmi-phandle = <&hdmi>;
+		status = "disabled";
+	};
+
 	soctherm: thermal-sensor@700e2000 {
 		compatible = "nvidia,tegra124-soctherm";
 		reg = <0x0 0x700e2000 0x0 0x600 /* SOC_THERM reg_base */
-- 
2.14.1
