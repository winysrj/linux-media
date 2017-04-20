Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:35767 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S971017AbdDTQIY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Apr 2017 12:08:24 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
CC: <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH v4 3/8] ARM: dts: stm32: Enable DCMI support on STM32F429 MCU
Date: Thu, 20 Apr 2017 18:07:20 +0200
Message-ID: <1492704445-22186-4-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1492704445-22186-1-git-send-email-hugues.fruchet@st.com>
References: <1492704445-22186-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable DCMI camera interface on STM32F429 MCU.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 arch/arm/boot/dts/stm32f429.dtsi | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm/boot/dts/stm32f429.dtsi b/arch/arm/boot/dts/stm32f429.dtsi
index ee0da97..e1ff978 100644
--- a/arch/arm/boot/dts/stm32f429.dtsi
+++ b/arch/arm/boot/dts/stm32f429.dtsi
@@ -736,6 +736,29 @@
 					slew-rate = <3>;
 				};
 			};
+
+			dcmi_pins: dcmi_pins@0 {
+				pins {
+					pinmux = <STM32F429_PA4_FUNC_DCMI_HSYNC>,
+						 <STM32F429_PB7_FUNC_DCMI_VSYNC>,
+						 <STM32F429_PA6_FUNC_DCMI_PIXCLK>,
+						 <STM32F429_PC6_FUNC_DCMI_D0>,
+						 <STM32F429_PC7_FUNC_DCMI_D1>,
+						 <STM32F429_PC8_FUNC_DCMI_D2>,
+						 <STM32F429_PC9_FUNC_DCMI_D3>,
+						 <STM32F429_PC11_FUNC_DCMI_D4>,
+						 <STM32F429_PD3_FUNC_DCMI_D5>,
+						 <STM32F429_PB8_FUNC_DCMI_D6>,
+						 <STM32F429_PE6_FUNC_DCMI_D7>,
+						 <STM32F429_PC10_FUNC_DCMI_D8>,
+						 <STM32F429_PC12_FUNC_DCMI_D9>,
+						 <STM32F429_PD6_FUNC_DCMI_D10>,
+						 <STM32F429_PD2_FUNC_DCMI_D11>;
+					bias-disable;
+					drive-push-pull;
+					slew-rate = <3>;
+				};
+			};
 		};
 
 		rcc: rcc@40023810 {
@@ -805,6 +828,20 @@
 			status = "disabled";
 		};
 
+		dcmi: dcmi@50050000 {
+			compatible = "st,stm32-dcmi";
+			reg = <0x50050000 0x400>;
+			interrupts = <78>;
+			resets = <&rcc STM32F4_AHB2_RESET(DCMI)>;
+			clocks = <&rcc 0 STM32F4_AHB2_CLOCK(DCMI)>;
+			clock-names = "mclk";
+			pinctrl-names = "default";
+			pinctrl-0 = <&dcmi_pins>;
+			dmas = <&dma2 1 1 0x414 0x3>;
+			dma-names = "tx";
+			status = "disabled";
+		};
+
 		rng: rng@50060800 {
 			compatible = "st,stm32-rng";
 			reg = <0x50060800 0x400>;
-- 
1.9.1
