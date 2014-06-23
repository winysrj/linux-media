Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:50725 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751212AbaFWVKl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jun 2014 17:10:41 -0400
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Cc: magnus.damm@opensource.se, horms@verge.net.au,
	linux-kernel@lists.codethink.co.uk,
	Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH 1/2] r8a7790.dtsi: add vin[0-3] nodes
Date: Mon, 23 Jun 2014 22:10:31 +0100
Message-Id: <1403557832-32225-2-git-send-email-ben.dooks@codethink.co.uk>
In-Reply-To: <1403557832-32225-1-git-send-email-ben.dooks@codethink.co.uk>
References: <1403557832-32225-1-git-send-email-ben.dooks@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add nodes for the four video input channels on the R8A7790.

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 arch/arm/boot/dts/r8a7790.dtsi | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7790.dtsi b/arch/arm/boot/dts/r8a7790.dtsi
index 7ff2960..a6f083d 100644
--- a/arch/arm/boot/dts/r8a7790.dtsi
+++ b/arch/arm/boot/dts/r8a7790.dtsi
@@ -33,6 +33,10 @@
 		spi2 = &msiof1;
 		spi3 = &msiof2;
 		spi4 = &msiof3;
+		vin0 = &vin0;
+		vin1 = &vin1;
+		vin2 = &vin2;
+		vin3 = &vin3;
 	};
 
 	cpus {
@@ -462,6 +466,38 @@
 		status = "disabled";
 	};
 
+	vin0: vin@e6ef0000 {
+		compatible = "renesas,vin-r8a7790";
+		clocks = <&mstp8_clks R8A7790_CLK_VIN0>;
+		reg = <0 0xe6ef0000 0 0x1000>;
+		interrupts = <0 188 IRQ_TYPE_LEVEL_HIGH>;
+		status = "disabled";
+	};
+
+	vin1: vin@e6ef1000 {
+		compatible = "renesas,vin-r8a7790";
+		clocks = <&mstp8_clks R8A7790_CLK_VIN1>;
+		reg = <0 0xe6ef1000 0 0x1000>;
+		interrupts = <0 189 IRQ_TYPE_LEVEL_HIGH>;
+		status = "disabled";
+	};
+
+	vin2: vin@e6ef2000 {
+		compatible = "renesas,vin-r8a7790";
+		clocks = <&mstp8_clks R8A7790_CLK_VIN2>;
+		reg = <0 0xe6ef2000 0 0x1000>;
+		interrupts = <0 190 IRQ_TYPE_LEVEL_HIGH>;
+		status = "disabled";
+	};
+
+	vin3: vin@e6ef3000 {
+		compatible = "renesas,vin-r8a7790";
+		clocks = <&mstp8_clks R8A7790_CLK_VIN3>;
+		reg = <0 0xe6ef3000 0 0x1000>;
+		interrupts = <0 191 IRQ_TYPE_LEVEL_HIGH>;
+		status = "disabled";
+	};
+
 	clocks {
 		#address-cells = <2>;
 		#size-cells = <2>;
-- 
2.0.0

