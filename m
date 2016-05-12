Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:56110 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752695AbcELLYq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2016 07:24:46 -0400
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
Subject: [PATCH v2 4/9] dt-bindings: Add a binding for Mediatek Video Decoder
Date: Thu, 12 May 2016 19:24:05 +0800
Message-ID: <1463052250-38262-5-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1463052250-38262-4-git-send-email-tiffany.lin@mediatek.com>
References: <1463052250-38262-1-git-send-email-tiffany.lin@mediatek.com>
 <1463052250-38262-2-git-send-email-tiffany.lin@mediatek.com>
 <1463052250-38262-3-git-send-email-tiffany.lin@mediatek.com>
 <1463052250-38262-4-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a DT binding documentation of Video Decoder for the
MT8173 SoC from Mediatek.

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 .../devicetree/bindings/media/mediatek-vcodec.txt  |   50 ++++++++++++++++++--
 1 file changed, 46 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/mediatek-vcodec.txt b/Documentation/devicetree/bindings/media/mediatek-vcodec.txt
index 59a47a5..9aa8848 100644
--- a/Documentation/devicetree/bindings/media/mediatek-vcodec.txt
+++ b/Documentation/devicetree/bindings/media/mediatek-vcodec.txt
@@ -1,25 +1,67 @@
 Mediatek Video Codec
 
 Mediatek Video Codec is the video codec hw present in Mediatek SoCs which
-supports high resolution encoding functionalities.
+supports high resolution encoding and decoding functionalities.
 
 Required properties:
 - compatible : "mediatek,mt8173-vcodec-enc" for encoder
+  "mediatek,mt8173-vcodec-dec" for decoder.
 - reg : Physical base address of the video codec registers and length of
   memory mapped region.
 - interrupts : interrupt number to the cpu.
 - mediatek,larb : must contain the local arbiters in the current Socs.
 - clocks : list of clock specifiers, corresponding to entries in
   the clock-names property.
-- clock-names: encoder must contain "venc_sel_src", "venc_sel",
-- "venc_lt_sel_src", "venc_lt_sel".
+- clock-names: encoder must contain "venc_sel_src", "venc_sel",,
+  "venc_lt_sel_src", "venc_lt_sel", decoder must contain "vcodecpll",
+  "univpll_d2", "clk_cci400_sel", "vdec_sel", "vdecpll".
 - iommus : should point to the respective IOMMU block with master port as
   argument, see Documentation/devicetree/bindings/iommu/mediatek,iommu.txt
   for details.
 - mediatek,vpu : the node of video processor unit
 
+
 Example:
-vcodec_enc: vcodec@0x18002000 {
+
+vcodec_dec: vcodec@16000000 {
+    compatible = "mediatek,mt8173-vcodec-dec";
+    reg = <0 0x16000000 0 0x100>,   /*VDEC_SYS*/
+          <0 0x16020000 0 0x1000>,  /*VDEC_MISC*/
+          <0 0x16021000 0 0x800>,   /*VDEC_LD*/
+          <0 0x16021800 0 0x800>,   /*VDEC_TOP*/
+          <0 0x16022000 0 0x1000>,  /*VDEC_CM*/
+          <0 0x16023000 0 0x1000>,  /*VDEC_AD*/
+          <0 0x16024000 0 0x1000>,  /*VDEC_AV*/
+          <0 0x16025000 0 0x1000>,  /*VDEC_PP*/
+          <0 0x16026800 0 0x800>,   /*VP8_VD*/
+          <0 0x16027000 0 0x800>,   /*VP6_VD*/
+          <0 0x16027800 0 0x800>,   /*VP8_VL*/
+          <0 0x16028400 0 0x400>;   /*VP9_VD*/
+    interrupts = <GIC_SPI 204 IRQ_TYPE_LEVEL_LOW>;
+    mediatek,larb = <&larb1>;
+    iommus = <&iommu M4U_PORT_HW_VDEC_MC_EXT>,
+             <&iommu M4U_PORT_HW_VDEC_PP_EXT>,
+             <&iommu M4U_PORT_HW_VDEC_AVC_MV_EXT>,
+             <&iommu M4U_PORT_HW_VDEC_PRED_RD_EXT>,
+             <&iommu M4U_PORT_HW_VDEC_PRED_WR_EXT>,
+             <&iommu M4U_PORT_HW_VDEC_UFO_EXT>,
+             <&iommu M4U_PORT_HW_VDEC_VLD_EXT>,
+             <&iommu M4U_PORT_HW_VDEC_VLD2_EXT>;
+    mediatek,vpu = <&vpu>;
+    power-domains = <&scpsys MT8173_POWER_DOMAIN_VDEC>;
+    clocks = <&apmixedsys CLK_APMIXED_VCODECPLL>,
+             <&topckgen CLK_TOP_UNIVPLL_D2>,
+             <&topckgen CLK_TOP_CCI400_SEL>,  
+             <&topckgen CLK_TOP_VDEC_SEL>,
+             <&topckgen CLK_TOP_VCODECPLL>;
+    clock-names = "vcodecpll",
+                  "univpll_d2",
+                  "clk_cci400_sel",   
+                  "vdec_sel",  
+                  "vdecpll";
+  };
+
+  vcodec_enc: vcodec@0x18002000 {
     compatible = "mediatek,mt8173-vcodec-enc";
     reg = <0 0x18002000 0 0x1000>,    /*VENC_SYS*/
           <0 0x19002000 0 0x1000>;    /*VENC_LT_SYS*/
-- 
1.7.9.5

