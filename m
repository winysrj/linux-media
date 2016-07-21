Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:8266 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751718AbcGUHke (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 03:40:34 -0400
From: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Yannick Fertre <yannick.fertre@st.com>,
	Hugues Fruchet <hugues.fruchet@st.com>,
	Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v3 1/3] Documentation: DT: add bindings for STI HVA
Date: Thu, 21 Jul 2016 09:40:02 +0200
Message-ID: <1469086804-21652-2-git-send-email-jean-christophe.trotin@st.com>
In-Reply-To: <1469086804-21652-1-git-send-email-jean-christophe.trotin@st.com>
References: <1469086804-21652-1-git-send-email-jean-christophe.trotin@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds DT binding documentation for STMicroelectronics hva
driver.

Signed-off-by: Yannick Fertre <yannick.fertre@st.com>
Signed-off-by: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
---
 .../devicetree/bindings/media/st,sti-hva.txt       | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/st,sti-hva.txt

diff --git a/Documentation/devicetree/bindings/media/st,sti-hva.txt b/Documentation/devicetree/bindings/media/st,sti-hva.txt
new file mode 100644
index 0000000..d1030bb
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/st,sti-hva.txt
@@ -0,0 +1,24 @@
+hva: multi-format video encoder for STMicroelectronics SoC.
+
+Required properties:
+- compatible: should be "st,sti-hva".
+- reg: HVA physical address location and length, esram address location and
+  length.
+- reg-names: names of the registers listed in registers property in the same
+  order.
+- interrupts: HVA interrupt number.
+- clocks: from common clock binding: handle hardware IP needed clocks, the
+  number of clocks may depend on the SoC type.
+  See ../clock/clock-bindings.txt for details.
+- clock-names: names of the clocks listed in clocks property in the same order.
+
+Example:
+	hva@8c85000{
+		compatible = "st,sti-hva";
+		reg = <0x8c85000 0x400>, <0x6000000 0x40000>;
+		reg-names = "hva_registers", "hva_esram";
+		interrupts = <GIC_SPI 58 IRQ_TYPE_NONE>,
+			     <GIC_SPI 59 IRQ_TYPE_NONE>;
+		clock-names = "clk_hva";
+		clocks = <&clk_s_c0_flexgen CLK_HVA>;
+	};
-- 
1.9.1

