Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:52351 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755508AbcECKLg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2016 06:11:36 -0400
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>
CC: Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>,
	<Tiffany.lin@mediatek.com>,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
	Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [PATCH v10 1/8] dt-bindings: Add a binding for Mediatek Video Processor
Date: Tue, 3 May 2016 18:11:20 +0800
Message-ID: <1462270287-11374-2-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1462270287-11374-1-git-send-email-tiffany.lin@mediatek.com>
References: <1462270287-11374-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andrew-CT Chen <andrew-ct.chen@mediatek.com>

Add a DT binding documentation of Video Processor Unit for the
MT8173 SoC from Mediatek.

Signed-off-by: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
Acked-by: Rob Herring <robh@kernel.org>

---
 .../devicetree/bindings/media/mediatek-vpu.txt     |   31 ++++++++++++++++++++
 1 file changed, 31 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/mediatek-vpu.txt

diff --git a/Documentation/devicetree/bindings/media/mediatek-vpu.txt b/Documentation/devicetree/bindings/media/mediatek-vpu.txt
new file mode 100644
index 0000000..2a5bac3
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/mediatek-vpu.txt
@@ -0,0 +1,31 @@
+* Mediatek Video Processor Unit
+
+Video Processor Unit is a HW video controller. It controls HW Codec including
+H.264/VP8/VP9 Decode, H.264/VP8 Encode and Image Processor (scale/rotate/color convert).
+
+Required properties:
+  - compatible: "mediatek,mt8173-vpu"
+  - reg: Must contain an entry for each entry in reg-names.
+  - reg-names: Must include the following entries:
+    "tcm": tcm base
+    "cfg_reg": Main configuration registers base
+  - interrupts: interrupt number to the cpu.
+  - clocks : clock name from clock manager
+  - clock-names: must be main. It is the main clock of VPU
+
+Optional properties:
+  - memory-region: phandle to a node describing memory (see
+    Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt)
+    to be used for VPU extended memory; if not present, VPU may be located
+    anywhere in the memory
+
+Example:
+	vpu: vpu@10020000 {
+		compatible = "mediatek,mt8173-vpu";
+		reg = <0 0x10020000 0 0x30000>,
+		      <0 0x10050000 0 0x100>;
+		reg-names = "tcm", "cfg_reg";
+		interrupts = <GIC_SPI 166 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&topckgen TOP_SCP_SEL>;
+		clock-names = "main";
+	};
-- 
1.7.9.5

