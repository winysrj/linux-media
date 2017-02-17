Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:35137 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755649AbdBQKrH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 05:47:07 -0500
Received: by mail-wm0-f50.google.com with SMTP id v186so11136581wmd.0
        for <linux-media@vger.kernel.org>; Fri, 17 Feb 2017 02:47:07 -0800 (PST)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: hverkuil@xs4all.nl
Cc: devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux@armlinux.org.uk, krzk@kernel.org, javier@osg.samsung.com,
        hans.verkuil@cisco.com, dri-devel@lists.freedesktop.org,
        daniel.vetter@intel.com, m.szyprowski@samsung.com,
        linux-media@vger.kernel.org, robh@kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v3 3/3] arm: sti: update sti-cec for HPD notifier support
Date: Fri, 17 Feb 2017 11:46:52 +0100
Message-Id: <1487328412-8305-4-git-send-email-benjamin.gaignard@linaro.org>
In-Reply-To: <1487328412-8305-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1487328412-8305-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To use HPD notifier sti CEC driver needs to get phandle
of the hdmi device.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
CC: devicetree@vger.kernel.org

version 3:
- change hdmi phandle from "st,hdmi-handle" to "hdmi-handle"
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
index 281a124..71deb02 100644
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
+			hdmi-handle = <&sti_hdmi>;
+		};
 	};
 };
-- 
1.9.1
