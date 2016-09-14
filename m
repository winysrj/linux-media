Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37762 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756146AbcINLYY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Sep 2016 07:24:24 -0400
Received: by mail-wm0-f50.google.com with SMTP id k186so416706wmd.0
        for <linux-media@vger.kernel.org>; Wed, 14 Sep 2016 04:24:23 -0700 (PDT)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: hans.verkuil@cisco.com, linux-media@vger.kernel.org
Cc: kernel@stlinux.com, arnd@arndb.de, robh@kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v2 1/4] bindings for stih-cec driver
Date: Wed, 14 Sep 2016 13:24:06 +0200
Message-Id: <1473852249-15960-2-git-send-email-benjamin.gaignard@linaro.org>
In-Reply-To: <1473852249-15960-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1473852249-15960-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add bindings documentation for stih-cec driver.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 .../devicetree/bindings/media/stih-cec.txt         | 25 ++++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/stih-cec.txt

diff --git a/Documentation/devicetree/bindings/media/stih-cec.txt b/Documentation/devicetree/bindings/media/stih-cec.txt
new file mode 100644
index 0000000..71c4b2f
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/stih-cec.txt
@@ -0,0 +1,25 @@
+STMicroelectronics STIH4xx HDMI CEC driver
+
+Required properties:
+ - compatible : value should be "st,stih-cec"
+ - reg : Physical base address of the IP registers and length of memory
+	 mapped region.
+ - clocks : from common clock binding: handle to HDMI CEC clock
+ - interrupts : HDMI CEC interrupt number to the CPU.
+ - pinctrl-names: Contains only one value - "default"
+ - pinctrl-0: Specifies the pin control groups used for CEC hardware.
+ - resets: Reference to a reset controller
+
+Example for STIH407:
+
+sti-cec@094a087c {
+	compatible = "st,stih-cec";
+	reg = <0x94a087c 0x64>;
+	clocks = <&clk_sysin>;
+	clock-names = "cec-clk";
+	interrupts = <GIC_SPI 140 IRQ_TYPE_NONE>;
+	interrupt-names = "cec-irq";
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_cec0_default>;
+	resets = <&softreset STIH407_LPM_SOFTRESET>;
+};
-- 
1.9.1

