Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:34277 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdE2IeZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 04:34:25 -0400
Received: by mail-wm0-f43.google.com with SMTP id 123so17616572wmg.1
        for <linux-media@vger.kernel.org>; Mon, 29 May 2017 01:34:24 -0700 (PDT)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: yannick.fertre@st.com, alexandre.torgue@st.com, hverkuil@xs4all.nl,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        robh@kernel.org, hans.verkuil@cisco.com
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v4 1/2] dt-bindings: media: stm32 cec driver
Date: Mon, 29 May 2017 10:34:14 +0200
Message-Id: <1496046855-5809-2-git-send-email-benjamin.gaignard@linaro.org>
In-Reply-To: <1496046855-5809-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1496046855-5809-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add bindings documentation for stm32 CEC driver.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
version 4:
- rework commit message
- add hdmi-phandle optional property

 .../devicetree/bindings/media/st,stm32-cec.txt     | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/st,stm32-cec.txt

diff --git a/Documentation/devicetree/bindings/media/st,stm32-cec.txt b/Documentation/devicetree/bindings/media/st,stm32-cec.txt
new file mode 100644
index 0000000..790d6d3
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/st,stm32-cec.txt
@@ -0,0 +1,22 @@
+STMicroelectronics STM32 CEC driver
+
+Required properties:
+ - compatible : value should be "st,stm32-cec"
+ - reg : Physical base address of the IP registers and length of memory
+	 mapped region.
+ - clocks : from common clock binding: handle to CEC clocks
+ - clock-names : from common clock binding: must be "cec" and "hdmi-cec".
+ - interrupts : CEC interrupt number to the CPU.
+
+Optional properties:
+ - hdmi-phandle: Phandle to the HDMI controller
+
+Example for stm32f746:
+
+cec: cec@40006c00 {
+	compatible = "st,stm32-cec";
+	reg = <0x40006C00 0x400>;
+	interrupts = <94>;
+	clocks = <&rcc 0 STM32F7_APB1_CLOCK(CEC)>, <&rcc 1 CLK_HDMI_CEC>;
+	clock-names = "cec", "hdmi-cec";
+};
-- 
1.9.1
