Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:46870 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S933145AbcIGG45 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 02:56:57 -0400
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>
CC: Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <Tiffany.lin@mediatek.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [PATCH 4/4] arm64: dts: mediatek: Add Video Decoder for MT8173
Date: Wed, 7 Sep 2016 14:56:43 +0800
Message-ID: <1473231403-14900-5-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1473231403-14900-4-git-send-email-tiffany.lin@mediatek.com>
References: <1473231403-14900-1-git-send-email-tiffany.lin@mediatek.com>
 <1473231403-14900-2-git-send-email-tiffany.lin@mediatek.com>
 <1473231403-14900-3-git-send-email-tiffany.lin@mediatek.com>
 <1473231403-14900-4-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add video decoder node for MT8173

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 arch/arm64/boot/dts/mediatek/mt8173.dtsi |   44 ++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173.dtsi b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
index 10f638f..2872cd7 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
@@ -974,6 +974,50 @@
 			#clock-cells = <1>;
 		};
 
+		vcodec_dec: vcodec@16000000 {
+			compatible = "mediatek,mt8173-vcodec-dec";
+			reg = <0 0x16000000 0 0x100>,	/* VDEC_SYS */
+			      <0 0x16020000 0 0x1000>,	/* VDEC_MISC */
+			      <0 0x16021000 0 0x800>,	/* VDEC_LD */
+			      <0 0x16021800 0 0x800>,	/* VDEC_TOP */
+			      <0 0x16022000 0 0x1000>,	/* VDEC_CM */
+			      <0 0x16023000 0 0x1000>,	/* VDEC_AD */
+			      <0 0x16024000 0 0x1000>,	/* VDEC_AV */
+			      <0 0x16025000 0 0x1000>,	/* VDEC_PP */
+			      <0 0x16026800 0 0x800>,	/* VDEC_HWD */
+			      <0 0x16027000 0 0x800>,	/* VDEC_HWQ */
+			      <0 0x16027800 0 0x800>,	/* VDEC_HWB */
+			      <0 0x16028400 0 0x400>;	/* VDEC_HWG */
+			interrupts = <GIC_SPI 204 IRQ_TYPE_LEVEL_LOW>;
+			mediatek,larb = <&larb1>;
+			iommus = <&iommu M4U_PORT_HW_VDEC_MC_EXT>,
+				 <&iommu M4U_PORT_HW_VDEC_PP_EXT>,
+				 <&iommu M4U_PORT_HW_VDEC_AVC_MV_EXT>,
+				 <&iommu M4U_PORT_HW_VDEC_PRED_RD_EXT>,
+				 <&iommu M4U_PORT_HW_VDEC_PRED_WR_EXT>,
+				 <&iommu M4U_PORT_HW_VDEC_UFO_EXT>,
+				 <&iommu M4U_PORT_HW_VDEC_VLD_EXT>,
+				 <&iommu M4U_PORT_HW_VDEC_VLD2_EXT>;
+			mediatek,vpu = <&vpu>;
+			power-domains = <&scpsys MT8173_POWER_DOMAIN_VDEC>;
+			clocks = <&apmixedsys CLK_APMIXED_VCODECPLL>,
+				 <&topckgen CLK_TOP_UNIVPLL_D2>,
+				 <&topckgen CLK_TOP_CCI400_SEL>,
+				 <&topckgen CLK_TOP_VDEC_SEL>,
+				 <&topckgen CLK_TOP_VCODECPLL>,
+				 <&apmixedsys CLK_APMIXED_VENCPLL>,
+				 <&topckgen CLK_TOP_VENC_LT_SEL>,
+				 <&topckgen CLK_TOP_VCODECPLL_370P5>;
+			clock-names = "vcodecpll",
+				      "univpll_d2",
+				      "clk_cci400_sel",
+				      "vdec_sel",
+				      "vdecpll",
+				      "vencpll",
+				      "venc_lt_sel",
+				      "vdec_bus_clk_src";
+		};
+
 		larb1: larb@16010000 {
 			compatible = "mediatek,mt8173-smi-larb";
 			reg = <0 0x16010000 0 0x1000>;
-- 
1.7.9.5

