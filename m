Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:57226 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754666AbdC2N0Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 09:26:24 -0400
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
Subject: [PATCH v1 1/8] dt-bindings: Document STM32 DCMI bindings
Date: Wed, 29 Mar 2017 15:25:19 +0200
Message-ID: <1490793926-6477-2-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1490793926-6477-1-git-send-email-hugues.fruchet@st.com>
References: <1490793926-6477-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds documentation of device tree bindings for the STM32 DCMI
(Digital Camera Memory Interface).

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 .../devicetree/bindings/media/st,stm32-dcmi.txt    | 77 ++++++++++++++++++++++
 1 file changed, 77 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/st,stm32-dcmi.txt

diff --git a/Documentation/devicetree/bindings/media/st,stm32-dcmi.txt b/Documentation/devicetree/bindings/media/st,stm32-dcmi.txt
new file mode 100644
index 0000000..f0dc709
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/st,stm32-dcmi.txt
@@ -0,0 +1,77 @@
+STMicroelectronics STM32 Digital Camera Memory Interface (DCMI)
+
+Required properties:
+- compatible: "st,stm32-dcmi"
+- reg: physical base address and length of the registers set for the device;
+- interrupts: should contain IRQ line for the DCMI;
+- clocks: list of clock specifiers, corresponding to entries in
+          the clock-names property;
+- clock-names: must contain "mclk", which is the DCMI peripherial clock.
+- resets: Reference to a reset controller
+- reset-names: see Documentation/devicetree/bindings/reset/st,stm32-rcc.txt
+
+DCMI supports a single port node with parallel bus. It should contain one
+'port' child node with child 'endpoint' node. Please refer to the bindings
+defined in Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Example:
+
+Device node example
+-------------------
+	dcmi: dcmi@50050000 {
+		compatible = "st,stm32-dcmi";
+		reg = <0x50050000 0x400>;
+		interrupts = <78>;
+		resets = <&rcc STM32F4_AHB2_RESET(DCMI)>;
+		clocks = <&rcc 0 STM32F4_AHB2_CLOCK(DCMI)>;
+		clock-names = "mclk";
+		pinctrl-names = "default";
+		pinctrl-0 = <&dcmi_pins>;
+		dmas = <&dma2 1 1 0x414 0x3>;
+		dma-names = "tx";
+		status = "disabled";
+	};
+
+Board setup example
+-------------------
+
+&dcmi {
+	status = "okay";
+
+	port {
+		dcmi_0: endpoint@0 {
+			remote-endpoint = <&ov2640_0>;
+			bus-width = <8>;
+			hsync-active = <0>;
+			vsync-active = <0>;
+			pclk-sample = <1>;
+		};
+	};
+};
+
+{
+	[...]
+	i2c@0 {
+		ov2640: camera@30 {
+			compatible = "ovti,ov2640";
+			reg = <0x30>;
+			resetb-gpios = <&stmpegpio 2 GPIO_ACTIVE_HIGH>;
+			pwdn-gpios = <&stmpegpio 0 GPIO_ACTIVE_LOW>;
+			clocks = <&clk_ext_camera>;
+			clock-names = "xvclk";
+			status = "okay";
+
+			port {
+				ov2640_0: endpoint {
+					remote-endpoint = <&dcmi_0>;
+				};
+			};
+		};
+	};
+
+	clk_ext_camera: clk-ext-camera {
+		#clock-cells = <0>;
+		compatible = "fixed-clock";
+		clock-frequency = <24000000>;
+	};
+}
-- 
1.9.1
