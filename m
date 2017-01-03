Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f170.google.com ([209.85.210.170]:33217 "EHLO
        mail-wj0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964971AbdACOzR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2017 09:55:17 -0500
Received: by mail-wj0-f170.google.com with SMTP id tq7so209771828wjb.0
        for <linux-media@vger.kernel.org>; Tue, 03 Jan 2017 06:55:17 -0800 (PST)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: linux@armlinux.org.uk, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v2 3/3] arm: sti: update sti-cec for HPD notifier support
Date: Tue,  3 Jan 2017 15:54:57 +0100
Message-Id: <1483455297-2286-4-git-send-email-benjamin.gaignard@linaro.org>
In-Reply-To: <1483455297-2286-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1483455297-2286-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To use HPD notifier sti CEC driver needs to get phandle
of the hdmi device.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 arch/arm/boot/dts/stih407-family.dtsi | 12 ------------
 arch/arm/boot/dts/stih410.dtsi        | 13 +++++++++++++
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/arm/boot/dts/stih407-family.dtsi b/arch/arm/boot/dts/stih407-family.dtsi
index c8b2944..592d235 100644
--- a/arch/arm/boot/dts/stih407-family.dtsi
+++ b/arch/arm/boot/dts/stih407-family.dtsi
@@ -756,18 +756,6 @@
 				 <&clk_s_c0_flexgen CLK_ETH_PHY>;
 		};
 
-		cec: sti-cec@094a087c {
-			compatible = "st,stih-cec";
-			reg = <0x94a087c 0x64>;
-			clocks = <&clk_sysin>;
-			clock-names = "cec-clk";
-			interrupts = <GIC_SPI 140 IRQ_TYPE_NONE>;
-			interrupt-names = "cec-irq";
-			pinctrl-names = "default";
-			pinctrl-0 = <&pinctrl_cec0_default>;
-			resets = <&softreset STIH407_LPM_SOFTRESET>;
-		};
-
 		rng10: rng@08a89000 {
 			compatible      = "st,rng";
 			reg		= <0x08a89000 0x1000>;
diff --git a/arch/arm/boot/dts/stih410.dtsi b/arch/arm/boot/dts/stih410.dtsi
index 281a124..e8c01f7 100644
--- a/arch/arm/boot/dts/stih410.dtsi
+++ b/arch/arm/boot/dts/stih410.dtsi
@@ -259,5 +259,18 @@
 			clocks = <&clk_sysin>;
 			interrupts = <GIC_SPI 205 IRQ_TYPE_EDGE_RISING>;
 		};
+
+		sti-cec@094a087c {
+			compatible = "st,stih-cec";
+			reg = <0x94a087c 0x64>;
+			clocks = <&clk_sysin>;
+			clock-names = "cec-clk";
+			interrupts = <GIC_SPI 140 IRQ_TYPE_NONE>;
+			interrupt-names = "cec-irq";
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_cec0_default>;
+			resets = <&softreset STIH407_LPM_SOFTRESET>;
+			st,hdmi-handle = <&sti_hdmi>;
+		};
 	};
 };
-- 
1.9.1

