Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:21111 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752338AbcDZI6q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Apr 2016 04:58:46 -0400
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
	<Tiffany.lin@mediatek.com>, Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [PATCH v9 8/8] arm64: dts: mediatek: Add Video Encoder for MT8173
Date: Tue, 26 Apr 2016 16:58:37 +0800
Message-ID: <1461661117-4657-9-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1461661117-4657-8-git-send-email-tiffany.lin@mediatek.com>
References: <1461661117-4657-1-git-send-email-tiffany.lin@mediatek.com>
 <1461661117-4657-2-git-send-email-tiffany.lin@mediatek.com>
 <1461661117-4657-3-git-send-email-tiffany.lin@mediatek.com>
 <1461661117-4657-4-git-send-email-tiffany.lin@mediatek.com>
 <1461661117-4657-5-git-send-email-tiffany.lin@mediatek.com>
 <1461661117-4657-6-git-send-email-tiffany.lin@mediatek.com>
 <1461661117-4657-7-git-send-email-tiffany.lin@mediatek.com>
 <1461661117-4657-8-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add video encoder node for MT8173

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>

---
 arch/arm64/boot/dts/mediatek/mt8173.dtsi |   39 ++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173.dtsi b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
index ae147bb..348ce0e 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
@@ -717,6 +717,45 @@
 			clock-names = "apb", "smi";
 		};
 
+		vcodec_enc: vcodec@18002000 {
+			compatible = "mediatek,mt8173-vcodec-enc";
+			reg = <0 0x18002000 0 0x1000>,	/* VENC_SYS */
+			      <0 0x19002000 0 0x1000>;	/* VENC_LT_SYS */
+			interrupts = <GIC_SPI 198 IRQ_TYPE_LEVEL_LOW>,
+				     <GIC_SPI 202 IRQ_TYPE_LEVEL_LOW>;
+			mediatek,larb = <&larb3>,
+					<&larb5>;
+			iommus = <&iommu M4U_PORT_VENC_RCPU>,
+				 <&iommu M4U_PORT_VENC_REC>,
+				 <&iommu M4U_PORT_VENC_BSDMA>,
+				 <&iommu M4U_PORT_VENC_SV_COMV>,
+				 <&iommu M4U_PORT_VENC_RD_COMV>,
+				 <&iommu M4U_PORT_VENC_CUR_LUMA>,
+				 <&iommu M4U_PORT_VENC_CUR_CHROMA>,
+				 <&iommu M4U_PORT_VENC_REF_LUMA>,
+				 <&iommu M4U_PORT_VENC_REF_CHROMA>,
+				 <&iommu M4U_PORT_VENC_NBM_RDMA>,
+				 <&iommu M4U_PORT_VENC_NBM_WDMA>,
+				 <&iommu M4U_PORT_VENC_RCPU_SET2>,
+				 <&iommu M4U_PORT_VENC_REC_FRM_SET2>,
+				 <&iommu M4U_PORT_VENC_BSDMA_SET2>,
+				 <&iommu M4U_PORT_VENC_SV_COMA_SET2>,
+				 <&iommu M4U_PORT_VENC_RD_COMA_SET2>,
+				 <&iommu M4U_PORT_VENC_CUR_LUMA_SET2>,
+				 <&iommu M4U_PORT_VENC_CUR_CHROMA_SET2>,
+				 <&iommu M4U_PORT_VENC_REF_LUMA_SET2>,
+				 <&iommu M4U_PORT_VENC_REC_CHROMA_SET2>;
+			mediatek,vpu = <&vpu>;
+			clocks = <&topckgen CLK_TOP_VENCPLL_D2>,
+				 <&topckgen CLK_TOP_VENC_SEL>,
+				 <&topckgen CLK_TOP_UNIVPLL1_D2>,
+				 <&topckgen CLK_TOP_VENC_LT_SEL>;
+			clock-names = "venc_sel_src",
+				      "venc_sel",
+				      "venc_lt_sel_src",
+				      "venc_lt_sel";
+		};
+
 		vencltsys: clock-controller@19000000 {
 			compatible = "mediatek,mt8173-vencltsys", "syscon";
 			reg = <0 0x19000000 0 0x1000>;
-- 
1.7.9.5

