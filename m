Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:38753 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752073AbaFOT5H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jun 2014 15:57:07 -0400
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-sh@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: robert.jarzmik@free.fr, g.liakhovetski@gmx.de,
	magnus.damm@opensource.se, horms@verge.net.au,
	ian.molton@codethink.co.uk, william.towle@codethink.co.uk,
	Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH 8/9] r8a7790.dtsi: add vin[0-3] nodes
Date: Sun, 15 Jun 2014 20:56:33 +0100
Message-Id: <1402862194-17743-9-git-send-email-ben.dooks@codethink.co.uk>
In-Reply-To: <1402862194-17743-1-git-send-email-ben.dooks@codethink.co.uk>
References: <1402862194-17743-1-git-send-email-ben.dooks@codethink.co.uk>
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

