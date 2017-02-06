Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:55957 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750956AbdBFKt0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Feb 2017 05:49:26 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        devicetree@vger.kernel.org
Subject: [PATCHv4 9/9] arm: sti: update sti-cec for HPD notifier support
Date: Mon,  6 Feb 2017 11:29:51 +0100
Message-Id: <20170206102951.12623-10-hverkuil@xs4all.nl>
In-Reply-To: <20170206102951.12623-1-hverkuil@xs4all.nl>
References: <20170206102951.12623-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Benjamin Gaignard <benjamin.gaignard@linaro.org>

To use HPD notifier sti CEC driver needs to get phandle
of the hdmi device.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
CC: devicetree@vger.kernel.org
---
 arch/arm/boot/dts/stih407-family.dtsi | 12 ------------
 arch/arm/boot/dts/stih410.dtsi        | 13 +++++++++++++
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/arm/boot/dts/stih407-family.dtsi b/arch/arm/boot/dts/stih407-family.dtsi
index c8b2944e304a..592d23538346 100644
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
index 281a12424cf6..e8c01f77be80 100644
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
2.11.0

