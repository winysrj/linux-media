Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37308 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761208AbcINLe6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Sep 2016 07:34:58 -0400
Received: by mail-wm0-f49.google.com with SMTP id k186so957390wmd.0
        for <linux-media@vger.kernel.org>; Wed, 14 Sep 2016 04:34:57 -0700 (PDT)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: hans.verkuil@cisco.com, linux-media@vger.kernel.org
Cc: kernel@stlinux.com, arnd@arndb.de, robh@kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v2 3/4] add stih-cec driver into DT
Date: Wed, 14 Sep 2016 13:34:28 +0200
Message-Id: <1473852869-17236-4-git-send-email-benjamin.gaignard@linaro.org>
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

