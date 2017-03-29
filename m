Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:57244 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755045AbdC2N0Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 09:26:25 -0400
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
Subject: [PATCH v1 6/8] ARM: dts: stm32: Enable ov2640 camera support of STM32F429-EVAL board
Date: Wed, 29 Mar 2017 15:25:24 +0200
Message-ID: <1490793926-6477-7-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1490793926-6477-1-git-send-email-hugues.fruchet@st.com>
References: <1490793926-6477-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 arch/arm/boot/dts/stm32429i-eval.dts | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm/boot/dts/stm32429i-eval.dts b/arch/arm/boot/dts/stm32429i-eval.dts
index 7ffcf07..b7d127c 100644
--- a/arch/arm/boot/dts/stm32429i-eval.dts
+++ b/arch/arm/boot/dts/stm32429i-eval.dts
@@ -48,6 +48,7 @@
 /dts-v1/;
 #include "stm32f429.dtsi"
 #include <dt-bindings/input/input.h>
+#include <dt-bindings/gpio/gpio.h>
 
 / {
 	model = "STMicroelectronics STM32429i-EVAL board";
@@ -66,6 +67,14 @@
 		serial0 = &usart1;
 	};
 
+	clocks {
+		clk_ext_camera: clk-ext-camera {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <24000000>;
+		};
+	};
+
 	soc {
 		dma-ranges = <0xc0000000 0x0 0x10000000>;
 	};
@@ -146,6 +155,11 @@
 
 	port {
 		dcmi_0: endpoint@0 {
+			remote-endpoint = <&ov2640_0>;
+			bus-width = <8>;
+			hsync-active = <0>;
+			vsync-active = <0>;
+			pclk-sample = <1>;
 		};
 	};
 };
@@ -155,6 +169,22 @@
 	pinctrl-names = "default";
 	status = "okay";
 
+	ov2640: camera@30 {
+		compatible = "ovti,ov2640";
+		reg = <0x30>;
+		resetb-gpios = <&stmpegpio 2 GPIO_ACTIVE_HIGH>;
+		pwdn-gpios = <&stmpegpio 0 GPIO_ACTIVE_LOW>;
+		clocks = <&clk_ext_camera>;
+		clock-names = "xvclk";
+		status = "okay";
+
+		port {
+			ov2640_0: endpoint {
+				remote-endpoint = <&dcmi_0>;
+			};
+		};
+	};
+
 	stmpe1600: stmpe1600@42 {
 		compatible = "st,stmpe1600";
 		reg = <0x42>;
-- 
1.9.1
