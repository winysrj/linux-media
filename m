Return-path: <linux-media-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:35853 "EHLO
        slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757768AbdKOLPE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 06:15:04 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, hverkuil@xs4all.nl
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 04/10] ARM: dts: r7s72100: Add Capture Engine Unit (CEU)
Date: Wed, 15 Nov 2017 11:55:57 +0100
Message-Id: <1510743363-25798-5-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add Capture Engine Unit (CEU) node to device tree.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 arch/arm/boot/dts/r7s72100.dtsi | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/r7s72100.dtsi b/arch/arm/boot/dts/r7s72100.dtsi
index 4ed12a4..683d459 100644
--- a/arch/arm/boot/dts/r7s72100.dtsi
+++ b/arch/arm/boot/dts/r7s72100.dtsi
@@ -136,8 +136,8 @@
 			compatible = "renesas,r7s72100-mstp-clocks", "renesas,cpg-mstp-clocks";
 			reg = <0xfcfe042c 4>;
 			clocks = <&p0_clk>;
-			clock-indices = <R7S72100_CLK_RTC>;
-			clock-output-names = "rtc";
+			clock-indices = <R7S72100_CLK_RTC R7S72100_CLK_CEU>;
+			clock-output-names = "rtc", "ceu";
 		};
 
 		mstp7_clks: mstp7_clks@fcfe0430 {
@@ -666,4 +666,12 @@
 		power-domains = <&cpg_clocks>;
 		status = "disabled";
 	};
+
+	ceu: ceu@e8210000 {
+		reg = <0xe8210000 0x209c>;
+		compatible = "renesas,renesas-ceu";
+		interrupts = <GIC_SPI 332 IRQ_TYPE_LEVEL_HIGH>;
+		power-domains = <&cpg_clocks>;
+		status = "disabled";
+	};
 };
-- 
2.7.4
