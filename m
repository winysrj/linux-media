Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:6910 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752607AbdFVPNr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Jun 2017 11:13:47 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
CC: <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH v1 4/5] ARM: dts: stm32: Enable DCMI support on STM32F746 MCU
Date: Thu, 22 Jun 2017 17:12:50 +0200
Message-ID: <1498144371-13310-5-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1498144371-13310-1-git-send-email-hugues.fruchet@st.com>
References: <1498144371-13310-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable DCMI camera interface on STM32F746 MCU.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 arch/arm/boot/dts/stm32f746.dtsi | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm/boot/dts/stm32f746.dtsi b/arch/arm/boot/dts/stm32f746.dtsi
index c2765ce..4bdf37c 100644
--- a/arch/arm/boot/dts/stm32f746.dtsi
+++ b/arch/arm/boot/dts/stm32f746.dtsi
@@ -326,6 +326,23 @@
 					bias-disable;
 				};
 			};
+
+			dcmi_pins: dcmi_pins@0 {
+				pins {
+					pinmux = <STM32F746_PA4_FUNC_DCMI_HSYNC>,
+						 <STM32F746_PG9_FUNC_DCMI_VSYNC>,
+						 <STM32F746_PA6_FUNC_DCMI_PIXCLK>,
+						 <STM32F746_PH9_FUNC_DCMI_D0>,
+						 <STM32F746_PH10_FUNC_DCMI_D1>,
+						 <STM32F746_PH11_FUNC_DCMI_D2>,
+						 <STM32F746_PH12_FUNC_DCMI_D3>,
+						 <STM32F746_PH14_FUNC_DCMI_D4>,
+						 <STM32F746_PD3_FUNC_DCMI_D5>,
+						 <STM32F746_PE5_FUNC_DCMI_D6>,
+						 <STM32F746_PE6_FUNC_DCMI_D7>;
+					slew-rate = <3>;
+				};
+			};
 		};
 
 		crc: crc@40023000 {
@@ -344,6 +361,20 @@
 			assigned-clocks = <&rcc 1 CLK_HSE_RTC>;
 			assigned-clock-rates = <1000000>;
 		};
+
+		dcmi: dcmi@50050000 {
+			compatible = "st,stm32-dcmi";
+			reg = <0x50050000 0x400>;
+			interrupts = <78>;
+			resets = <&rcc STM32F7_AHB2_RESET(DCMI)>;
+			clocks = <&rcc 0 STM32F7_AHB2_CLOCK(DCMI)>;
+			clock-names = "mclk";
+			pinctrl-names = "default";
+			pinctrl-0 = <&dcmi_pins>;
+			dmas = <&dma2 1 1 0x414 0x3>;
+			dma-names = "tx";
+			status = "disabled";
+		};
 	};
 };
 
-- 
1.9.1
