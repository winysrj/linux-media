Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:40318 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S938663AbcISDHD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Sep 2016 23:07:03 -0400
From: Rick Chang <rick.chang@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Rick Chang <rick.chang@mediatek.com>
Subject: [RESEND PATCH 3/3] arm: dts: mt2701: Add node for Mediatek JPEG Decoder
Date: Mon, 19 Sep 2016 11:05:41 +0800
Message-ID: <1474254341-23715-4-git-send-email-rick.chang@mediatek.com>
In-Reply-To: <1474254341-23715-1-git-send-email-rick.chang@mediatek.com>
References: <1474254341-23715-1-git-send-email-rick.chang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Rick Chang <rick.chang@mediatek.com>
Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
---
This patch depends on: 
  CCF "arm: dts: mt2701: Add clock controller device nodes"[1]
  power domain patch "Mediatek MT2701 SCPSYS power domain support v7"[2]
  iommu and smi "Add the dtsi node of iommu and smi for mt2701"[3]

[1] https://patchwork.kernel.org/patch/9109081
[2] http://lists.infradead.org/pipermail/linux-mediatek/2016-May/005429.html
[3] https://patchwork.kernel.org/patch/9164013/
---
 arch/arm/boot/dts/mt2701.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/mt2701.dtsi b/arch/arm/boot/dts/mt2701.dtsi
index d550d36..a9838bd 100644
--- a/arch/arm/boot/dts/mt2701.dtsi
+++ b/arch/arm/boot/dts/mt2701.dtsi
@@ -284,6 +284,20 @@
 		power-domains = <&scpsys MT2701_POWER_DOMAIN_ISP>;
 	};
 
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
+
 	vdecsys: syscon@16000000 {
 		compatible = "mediatek,mt2701-vdecsys", "syscon";
 		reg = <0 0x16000000 0 0x1000>;
-- 
1.9.1

