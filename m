Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:42387 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753247AbcADKMp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jan 2016 05:12:45 -0500
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: <daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>
CC: Daniel Kurtz <djkurtz@chromium.org>, <eddie.huang@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>,
	Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [PATCH v3 8/8] arm64: dts: mediatek: Add Video Encoder for MT8173
Date: Mon, 4 Jan 2016 18:11:56 +0800
Message-ID: <1451902316-55931-9-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1451902316-55931-1-git-send-email-tiffany.lin@mediatek.com>
References: <1451902316-55931-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add video encoder node for MT8173

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 arch/arm64/boot/dts/mediatek/mt8173.dtsi |   37 ++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173.dtsi b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
index b3636cd..09f29c5 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
@@ -1138,6 +1138,43 @@
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
+			clocks = <&apmixedsys CLK_APMIXED_VENCPLL>,
+				 <&topckgen CLK_TOP_VENC_LT_SEL>,
+				 <&topckgen CLK_TOP_VCODECPLL_370P5>;
+			clock-names = "vencpll",
+				      "venc_lt_sel",
+				      "vcodecpll_370p5_ck";
+		};
+
 		vencltsys: clock-controller@19000000 {
 			compatible = "mediatek,mt8173-vencltsys", "syscon";
 			reg = <0 0x19000000 0 0x1000>;
-- 
1.7.9.5

