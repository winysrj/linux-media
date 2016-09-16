Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36624 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765270AbcIPNJl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 09:09:41 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: horms@verge.net.au
Cc: geert@linux-m68k.org, hans.verkuil@cisco.com,
        niklas.soderlund@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com,
        ulrich.hecht+renesas@gmail.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH 1/3] ARM: dts: r8a7793: Enable VIN0, VIN1
Date: Fri, 16 Sep 2016 15:09:33 +0200
Message-Id: <20160916130935.21292-2-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <20160916130935.21292-1-ulrich.hecht+renesas@gmail.com>
References: <20160916130935.21292-1-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 arch/arm/boot/dts/r8a7793.dtsi | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7793.dtsi b/arch/arm/boot/dts/r8a7793.dtsi
index 8d02aac..0898668 100644
--- a/arch/arm/boot/dts/r8a7793.dtsi
+++ b/arch/arm/boot/dts/r8a7793.dtsi
@@ -30,6 +30,8 @@
 		i2c7 = &i2c7;
 		i2c8 = &i2c8;
 		spi0 = &qspi;
+		vin0 = &vin0;
+		vin1 = &vin1;
 	};
 
 	cpus {
@@ -852,6 +854,24 @@
 		status = "disabled";
 	};
 
+	vin0: video@e6ef0000 {
+		compatible = "renesas,vin-r8a7793";
+		reg = <0 0xe6ef0000 0 0x1000>;
+		interrupts = <GIC_SPI 188 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp8_clks R8A7793_CLK_VIN0>;
+		power-domains = <&sysc R8A7793_PD_ALWAYS_ON>;
+		status = "disabled";
+	};
+
+	vin1: video@e6ef1000 {
+		compatible = "renesas,vin-r8a7793";
+		reg = <0 0xe6ef1000 0 0x1000>;
+		interrupts = <GIC_SPI 189 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp8_clks R8A7793_CLK_VIN1>;
+		power-domains = <&sysc R8A7793_PD_ALWAYS_ON>;
+		status = "disabled";
+	};
+
 	qspi: spi@e6b10000 {
 		compatible = "renesas,qspi-r8a7793", "renesas,qspi";
 		reg = <0 0xe6b10000 0 0x2c>;
-- 
2.9.3

