Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:4639 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S933854AbcKDFvd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2016 01:51:33 -0400
From: Rick Chang <rick.chang@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <srv_heupstream@mediatek.com>,
        <linux-mediatek@lists.infradead.org>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Rick Chang <rick.chang@mediatek.com>
Subject: [PATCH v3 1/3] dt-bindings: mediatek: Add a binding for Mediatek JPEG Decoder
Date: Fri, 4 Nov 2016 13:51:18 +0800
Message-ID: <1478238680-11310-2-git-send-email-rick.chang@mediatek.com>
In-Reply-To: <1478238680-11310-1-git-send-email-rick.chang@mediatek.com>
References: <1478238680-11310-1-git-send-email-rick.chang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a DT binding documentation for Mediatek JPEG Decoder of
MT2701 SoC.

Signed-off-by: Rick Chang <rick.chang@mediatek.com>
Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
---
 .../bindings/media/mediatek-jpeg-codec.txt         | 35 ++++++++++++++++++++++
 1 file changed, 35 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/mediatek-jpeg-codec.txt

diff --git a/Documentation/devicetree/bindings/media/mediatek-jpeg-codec.txt b/Documentation/devicetree/bindings/media/mediatek-jpeg-codec.txt
new file mode 100644
index 0000000..b2b19ed
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/mediatek-jpeg-codec.txt
@@ -0,0 +1,35 @@
+* Mediatek JPEG Decoder
+
+Mediatek JPEG Decoder is the JPEG decode hw present in Mediatek SoCs
+
+Required properties:
+- compatible : "mediatek,mt2701-jpgdec"
+- reg : physical base address of the jpeg decoder registers and length of
+  memory mapped region.
+- interrupts : interrupt number to the interrupt controller.
+- clocks: device clocks, see
+  Documentation/devicetree/bindings/clock/clock-bindings.txt for details.
+- clock-names: must contain "jpgdec-smi" and "jpgdec".
+- power-domains: a phandle to the power domain, see
+  Documentation/devicetree/bindings/power/power_domain.txt for details.
+- mediatek,larb: must contain the local arbiters in the current Socs, see
+  Documentation/devicetree/bindings/memory-controllers/mediatek,smi-larb.txt
+  for details.
+- iommus: should point to the respective IOMMU block with master port as
+  argument, see Documentation/devicetree/bindings/iommu/mediatek,iommu.txt
+  for details.
+
+Example:
+	jpegdec: jpegdec@15004000 {
+		compatible = "mediatek,mt2701-jpgdec";
+		reg = <0 0x15004000 0 0x1000>;
+		interrupts = <GIC_SPI 143 IRQ_TYPE_LEVEL_LOW>;
+		clocks =  <&imgsys CLK_IMG_JPGDEC_SMI>,
+			  <&imgsys CLK_IMG_JPGDEC>;
+		clock-names = "jpgdec-smi",
+			      "jpgdec";
+		power-domains = <&scpsys MT2701_POWER_DOMAIN_ISP>;
+		mediatek,larb = <&larb2>;
+		iommus = <&iommu MT2701_M4U_PORT_JPGDEC_WDMA>,
+			 <&iommu MT2701_M4U_PORT_JPGDEC_BSDMA>;
+	};
-- 
1.9.1

