Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:60917 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932071AbdL1OBu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 09:01:50 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, hverkuil@xs4all.nl,
        robh+dt@kernel.org, mark.rutland@arm.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/9] ARM: dts: r7s72100: Add Capture Engine Unit (CEU)
Date: Thu, 28 Dec 2017 15:01:16 +0100
Message-Id: <1514469681-15602-5-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1514469681-15602-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1514469681-15602-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add Capture Engine Unit (CEU) node to device tree.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 arch/arm/boot/dts/r7s72100.dtsi | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/r7s72100.dtsi b/arch/arm/boot/dts/r7s72100.dtsi
index ab9645a..b09b032 100644
--- a/arch/arm/boot/dts/r7s72100.dtsi
+++ b/arch/arm/boot/dts/r7s72100.dtsi
@@ -135,9 +135,9 @@
 			#clock-cells = <1>;
 			compatible = "renesas,r7s72100-mstp-clocks", "renesas,cpg-mstp-clocks";
 			reg = <0xfcfe042c 4>;
-			clocks = <&p0_clk>;
-			clock-indices = <R7S72100_CLK_RTC>;
-			clock-output-names = "rtc";
+			clocks = <&b_clk>, <&p0_clk>;
+			clock-indices = <R7S72100_CLK_CEU R7S72100_CLK_RTC>;
+			clock-output-names = "ceu", "rtc";
 		};
 
 		mstp7_clks: mstp7_clks@fcfe0430 {
@@ -667,4 +667,13 @@
 		power-domains = <&cpg_clocks>;
 		status = "disabled";
 	};
+
+	ceu: ceu@e8210000 {
+		reg = <0xe8210000 0x209c>;
+		compatible = "renesas,r7s72100-ceu";
+		interrupts = <GIC_SPI 332 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp6_clks R7S72100_CLK_CEU>;
+		power-domains = <&cpg_clocks>;
+		status = "disabled";
+	};
 };
-- 
2.7.4
