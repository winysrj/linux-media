Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:47175 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750986AbbLRKpl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 05:45:41 -0500
From: Yannick Fertre <yannick.fertre@st.com>
To: <linux-media@vger.kernel.org>
CC: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	<hugues.fruchet@st.com>, <kernel@stlinux.com>
Subject: [PATCH 1/3] Documentation: devicetree: add STI HVA binding
Date: Fri, 18 Dec 2015 11:45:31 +0100
Message-ID: <1450435533-15974-2-git-send-email-yannick.fertre@st.com>
In-Reply-To: <1450435533-15974-1-git-send-email-yannick.fertre@st.com>
References: <1450435533-15974-1-git-send-email-yannick.fertre@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch documents DT compatible string "st,st-hva".

Signed-off-by: Yannick Fertre <yannick.fertre@st.com>
---
 .../devicetree/bindings/media/st,sti-hva.txt       | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/st,sti-hva.txt

diff --git a/Documentation/devicetree/bindings/media/st,sti-hva.txt b/Documentation/devicetree/bindings/media/st,sti-hva.txt
new file mode 100644
index 0000000..3dc431d
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/st,sti-hva.txt
@@ -0,0 +1,26 @@
+==============================================================================
+        hva: hardware video encoder accelerator
+==============================================================================
+
+Required properties:
+- compatible: should be "st,stih407-hva".
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
+
+hva@8c85000{
+	compatible = "st,stih407-hva";
+	reg= <0x8c85000 0x400>, <0x6000000 0x40000>;
+	reg-names = "hva_registers", "hva_esram";
+	interrupts = <0 58 0>, <0 59 0>;
+	clock-names = "clk_hva";
+	clocks = <&CLK_S_C0_FLEXGEN 3>;
+};
-- 
1.9.1

