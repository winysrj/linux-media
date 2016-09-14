Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:35492 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755452AbcINJXS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Sep 2016 05:23:18 -0400
Received: by mail-wm0-f45.google.com with SMTP id i130so37615539wmf.0
        for <linux-media@vger.kernel.org>; Wed, 14 Sep 2016 02:23:18 -0700 (PDT)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: hans.verkuil@cisco.com, linux-media@vger.kernel.org
Cc: kernel@stlinux.com, arnd@arndb.de, robh@kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH 3/4] add stih-cec driver into DT
Date: Wed, 14 Sep 2016 11:22:03 +0200
Message-Id: <1473844924-13895-4-git-send-email-benjamin.gaignard@linaro.org>
In-Reply-To: <1473844924-13895-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1473844924-13895-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 arch/arm/boot/dts/stih410.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/stih410.dtsi b/arch/arm/boot/dts/stih410.dtsi
index 18ed1ad..440c4bd 100644
--- a/arch/arm/boot/dts/stih410.dtsi
+++ b/arch/arm/boot/dts/stih410.dtsi
@@ -227,5 +227,17 @@
 			clock-names = "bdisp";
 			clocks = <&clk_s_c0_flexgen CLK_IC_BDISP_0>;
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
+		};
 	};
 };
-- 
1.9.1

