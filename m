Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36047 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933967AbcIOHiF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 03:38:05 -0400
Received: by mail-wm0-f54.google.com with SMTP id b187so82366445wme.1
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2016 00:38:04 -0700 (PDT)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: hans.verkuil@cisco.com, linux-media@vger.kernel.org
Cc: kernel@stlinux.com, arnd@arndb.de, robh@kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v3 3/4] add stih-cec driver into DT
Date: Thu, 15 Sep 2016 09:37:45 +0200
Message-Id: <1473925066-8289-4-git-send-email-benjamin.gaignard@linaro.org>
In-Reply-To: <1473925066-8289-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1473925066-8289-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 arch/arm/boot/dts/stih407-family.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/stih407-family.dtsi b/arch/arm/boot/dts/stih407-family.dtsi
index d294e82..9f88086 100644
--- a/arch/arm/boot/dts/stih407-family.dtsi
+++ b/arch/arm/boot/dts/stih407-family.dtsi
@@ -734,6 +734,18 @@
 				 <&clk_s_c0_flexgen CLK_ETH_PHY>;
 		};
 
+		cec: sti-cec@094a087c {
+			compatible = "st,stih-cec";
+			reg = <0x94a087c 0x64>;
+			clocks = <&clk_sysin>;
+			clock-names = "cec-clk";
+			interrupts = <GIC_SPI 140 IRQ_TYPE_NONE>;
+			interrupt-names = "cec-irq";
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_cec0_default>;
+			resets = <&softreset STIH407_LPM_SOFTRESET>;
+		};
+
 		rng10: rng@08a89000 {
 			compatible      = "st,rng";
 			reg		= <0x08a89000 0x1000>;
-- 
1.9.1

