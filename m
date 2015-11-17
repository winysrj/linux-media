Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:53435 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752895AbbKQMzS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 07:55:18 -0500
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Hongzhou Yang <hongzhou.yang@mediatek.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Darren Etheridge <detheridge@ti.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Benoit Parrot <bparrot@ti.com>
CC: Tiffany Lin <tiffany.lin@mediatek.com>,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	James Liao <jamesjj.liao@mediatek.com>,
	Daniel Hsiao <daniel.hsiao@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>, <linux-mediatek@lists.infradead.org>
Subject: [RESEND RFC/PATCH 5/8] arm64: dts: mediatek: Add Video Encoder for MT8173
Date: Tue, 17 Nov 2015 20:54:42 +0800
Message-ID: <1447764885-23100-6-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1447764885-23100-1-git-send-email-tiffany.lin@mediatek.com>
References: <1447764885-23100-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add video encoder driver for MT8173

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 arch/arm64/boot/dts/mediatek/mt8173.dtsi |   47 ++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173.dtsi b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
index 098c15e..85ba167 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
@@ -545,6 +545,53 @@
 			#clock-cells = <1>;
 		};
 
+		larb3: larb@18001000 {
+			compatible = "mediatek,mt8173-smi-larb";
+			reg = <0 0x18001000 0 0x1000>;
+			mediatek,smi = <&smi_common>;
+			power-domains = <&scpsys MT8173_POWER_DOMAIN_VENC>;
+			clocks = <&vencsys CLK_VENC_CKE1>,
+				 <&vencsys CLK_VENC_CKE0>;
+			clock-names = "apb", "smi";
+		};
+
+		vcodec_enc: vcodec@18002000 {
+			compatible = "mediatek,mt8173-vcodec-enc";
+			reg = <0 0x18002000 0 0x1000>,	/* VENC_SYS */
+			      <0 0x19002000 0 0x1000>;	/* VENC_LT_SYS */
+			interrupts = <GIC_SPI 198 IRQ_TYPE_LEVEL_LOW>,
+				     <GIC_SPI 202 IRQ_TYPE_LEVEL_LOW>;
+			larb = <&larb3>,
+			       <&larb5>;
+			iommus = <&iommu M4U_LARB3_ID M4U_PORT_VENC_RCPU>,
+				 <&iommu M4U_LARB3_ID M4U_PORT_VENC_REC>,
+				 <&iommu M4U_LARB3_ID M4U_PORT_VENC_BSDMA>,
+				 <&iommu M4U_LARB3_ID M4U_PORT_VENC_SV_COMV>,
+				 <&iommu M4U_LARB3_ID M4U_PORT_VENC_RD_COMV>,
+				 <&iommu M4U_LARB3_ID M4U_PORT_VENC_CUR_LUMA>,
+				 <&iommu M4U_LARB3_ID M4U_PORT_VENC_CUR_CHROMA>,
+				 <&iommu M4U_LARB3_ID M4U_PORT_VENC_REF_LUMA>,
+				 <&iommu M4U_LARB3_ID M4U_PORT_VENC_REF_CHROMA>,
+				 <&iommu M4U_LARB3_ID M4U_PORT_VENC_NBM_RDMA>,
+				 <&iommu M4U_LARB3_ID M4U_PORT_VENC_NBM_WDMA>,
+				 <&iommu M4U_LARB5_ID M4U_PORT_VENC_RCPU_SET2>,
+				 <&iommu M4U_LARB5_ID M4U_PORT_VENC_REC_FRM_SET2>,
+				 <&iommu M4U_LARB5_ID M4U_PORT_VENC_BSDMA_SET2>,
+				 <&iommu M4U_LARB5_ID M4U_PORT_VENC_SV_COMA_SET2>,
+				 <&iommu M4U_LARB5_ID M4U_PORT_VENC_RD_COMA_SET2>,
+				 <&iommu M4U_LARB5_ID M4U_PORT_VENC_CUR_LUMA_SET2>,
+				 <&iommu M4U_LARB5_ID M4U_PORT_VENC_CUR_CHROMA_SET2>,
+				 <&iommu M4U_LARB5_ID M4U_PORT_VENC_REF_LUMA_SET2>,
+				 <&iommu M4U_LARB5_ID M4U_PORT_VENC_REC_CHROMA_SET2>;
+			vpu = <&vpu>;
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

