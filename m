Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:42829 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753232AbbELQCS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2015 12:02:18 -0400
From: Fabien Dessenne <fabien.dessenne@st.com>
To: <linux-media@vger.kernel.org>
CC: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	<hugues.fruchet@st.com>
Subject: [PATCH v3 1/3] [media] bdisp: add DT bindings documentation
Date: Tue, 12 May 2015 18:02:09 +0200
Message-ID: <1431446531-11492-2-git-send-email-fabien.dessenne@st.com>
In-Reply-To: <1431446531-11492-1-git-send-email-fabien.dessenne@st.com>
References: <1431446531-11492-1-git-send-email-fabien.dessenne@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds DT binding documentation for STMicroelectronics bdisp driver.

Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
---
 .../devicetree/bindings/media/st,stih4xx.txt       | 32 ++++++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/st,stih4xx.txt

diff --git a/Documentation/devicetree/bindings/media/st,stih4xx.txt b/Documentation/devicetree/bindings/media/st,stih4xx.txt
new file mode 100644
index 0000000..df655cd
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/st,stih4xx.txt
@@ -0,0 +1,32 @@
+STMicroelectronics stih4xx platforms
+
+bdisp: 2D blitter for STMicroelectronics SoC.
+
+Required properties:
+- compatible: should be "st,stih407-bdisp".
+- reg: BDISP physical address location and length.
+- interrupts: BDISP interrupt number.
+- clocks: from common clock binding: handle hardware IP needed clocks, the
+  number of clocks may depend on the SoC type.
+  See ../clocks/clock-bindings.txt for details.
+- clock-names: names of the clocks listed in clocks property in the same order.
+
+Example:
+
+	bdisp0:bdisp@9f10000 {
+		compatible = "st,stih407-bdisp";
+		reg = <0x9f10000 0x1000>;
+		interrupts = <GIC_SPI 38 IRQ_TYPE_NONE>;
+		clock-names = "bdisp";
+		clocks = <&clk_s_c0_flexgen CLK_IC_BDISP_0>;
+	};
+
+Aliases:
+Each BDISP should have a numbered alias in the aliases node, in the form of
+bdispN, N = 0 or 1.
+
+Example:
+
+	aliases {
+		bdisp0 = &bdisp0;
+	};
-- 
1.9.1

