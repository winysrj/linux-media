Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:31462 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754292AbdDDPp3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Apr 2017 11:45:29 -0400
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
Subject: [PATCH v3 1/8] dt-bindings: Document STM32 DCMI bindings
Date: Tue, 4 Apr 2017 17:44:31 +0200
Message-ID: <1491320678-17246-2-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1491320678-17246-1-git-send-email-hugues.fruchet@st.com>
References: <1491320678-17246-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds documentation of device tree bindings for the STM32 DCMI
(Digital Camera Memory Interface).

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 .../devicetree/bindings/media/st,stm32-dcmi.txt    | 46 ++++++++++++++++++++++
 1 file changed, 46 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/st,stm32-dcmi.txt

diff --git a/Documentation/devicetree/bindings/media/st,stm32-dcmi.txt b/Documentation/devicetree/bindings/media/st,stm32-dcmi.txt
new file mode 100644
index 0000000..c0f6f4b
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/st,stm32-dcmi.txt
@@ -0,0 +1,46 @@
+STMicroelectronics STM32 Digital Camera Memory Interface (DCMI)
+
+Required properties:
+- compatible: "st,stm32-dcmi"
+- reg: physical base address and length of the registers set for the device
+- interrupts: should contain IRQ line for the DCMI
+- resets: reference to a reset controller,
+          see Documentation/devicetree/bindings/reset/st,stm32-rcc.txt
+- clocks: list of clock specifiers, corresponding to entries in
+          the clock-names property
+- clock-names: must contain "mclk", which is the DCMI peripherial clock
+- pinctrl: the pincontrol settings to configure muxing properly
+           for pins that connect to DCMI device.
+           See Documentation/devicetree/bindings/pinctrl/st,stm32-pinctrl.txt.
+- dmas: phandle to DMA controller node,
+        see Documentation/devicetree/bindings/dma/stm32-dma.txt
+- dma-names: must contain "tx", which is the transmit channel from DCMI to DMA
+
+DCMI supports a single port node with parallel bus. It should contain one
+'port' child node with child 'endpoint' node. Please refer to the bindings
+defined in Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Example:
+
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
+		port {
+			dcmi_0: endpoint@0 {
+				remote-endpoint = <...>;
+				bus-width = <8>;
+				hsync-active = <0>;
+				vsync-active = <0>;
+				pclk-sample = <1>;
+			};
+		};
+	};
+
-- 
1.9.1
