Return-path: <linux-media-owner@vger.kernel.org>
Received: from mslow2.mail.gandi.net ([217.70.178.242]:53446 "EHLO
        slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751647AbeDZTFQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 15:05:16 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: geert@linux-m68k.org, horms@verge.net.au, robh+dt@kernel.org,
        mark.rutland@arm.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] ARM: dts: r8a7740: Add CEU0
Date: Thu, 26 Apr 2018 20:24:43 +0200
Message-Id: <1524767083-19862-3-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1524767083-19862-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1524767083-19862-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Describe CEU0 peripheral for Renesas R-Mobile A1 R8A7740 Soc.

Reported-by: Geert Uytterhoeven <geert@glider.be>
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 arch/arm/boot/dts/r8a7740.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7740.dtsi b/arch/arm/boot/dts/r8a7740.dtsi
index afd3bc5..508d934 100644
--- a/arch/arm/boot/dts/r8a7740.dtsi
+++ b/arch/arm/boot/dts/r8a7740.dtsi
@@ -67,6 +67,16 @@
 		power-domains = <&pd_d4>;
 	};
 
+	ceu0: ceu@fe910000 {
+		reg = <0xfe910000 0x3000>;
+		compatible = "renesas,r8a7740-ceu";
+		interrupts = <GIC_SPI 160 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp1_clks R8A7740_CLK_CEU20>;
+		clock-names = "ceu20";
+		power-domains = <&pd_a4r>;
+		status = "disabled";
+	};
+
 	cmt1: timer@e6138000 {
 		compatible = "renesas,cmt-48-r8a7740", "renesas,cmt-48";
 		reg = <0xe6138000 0x170>;
-- 
2.7.4
