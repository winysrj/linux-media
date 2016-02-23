Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:9087 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756930AbcBWIL3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2016 03:11:29 -0500
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
Subject: [PATCH v5 8/8] arm64: dts: mediatek: Add Video Encoder for MT8173
Date: Tue, 23 Feb 2016 16:11:21 +0800
Message-ID: <1456215081-16858-9-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1456215081-16858-8-git-send-email-tiffany.lin@mediatek.com>
References: <1456215081-16858-1-git-send-email-tiffany.lin@mediatek.com>
 <1456215081-16858-2-git-send-email-tiffany.lin@mediatek.com>
 <1456215081-16858-3-git-send-email-tiffany.lin@mediatek.com>
 <1456215081-16858-4-git-send-email-tiffany.lin@mediatek.com>
 <1456215081-16858-5-git-send-email-tiffany.lin@mediatek.com>
 <1456215081-16858-6-git-send-email-tiffany.lin@mediatek.com>
 <1456215081-16858-7-git-send-email-tiffany.lin@mediatek.com>
 <1456215081-16858-8-git-send-email-tiffany.lin@mediatek.com>
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
index 5b0b38a..26aeffe 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
@@ -1150,6 +1150,45 @@
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

