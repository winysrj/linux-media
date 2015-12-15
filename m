Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:39757 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932170AbbLOI0y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2015 03:26:54 -0500
Message-ID: <1450168009.31617.4.camel@mtksdaap41>
Subject: Re: [PATCH v2 4/8] dt-bindings: Add a binding for Mediatek Video
 Encoder
From: tiffany lin <tiffany.lin@mediatek.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
CC: Rob Herring <robh@kernel.org>, <daniel.thompson@linaro.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	"Catalin Marinas" <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	"Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Darren Etheridge <detheridge@ti.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	"Benoit Parrot" <bparrot@ti.com>,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	James Liao <jamesjj.liao@mediatek.com>,
	Hongzhou Yang <hongzhou.yang@mediatek.com>,
	Daniel Hsiao <daniel.hsiao@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>
Date: Tue, 15 Dec 2015 16:26:49 +0800
In-Reply-To: <566EA9B1.5000102@gmail.com>
References: <1449827743-22895-1-git-send-email-tiffany.lin@mediatek.com>
	 <1449827743-22895-5-git-send-email-tiffany.lin@mediatek.com>
	 <20151211172919.GA2896@rob-hp-laptop> <1450081618.5745.3.camel@mtksdaap41>
	 <566EA9B1.5000102@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matthias,


On Mon, 2015-12-14 at 12:36 +0100, Matthias Brugger wrote:
> 
> On 14/12/15 09:26, tiffany lin wrote:
> > On Fri, 2015-12-11 at 11:29 -0600, Rob Herring wrote:
> >> On Fri, Dec 11, 2015 at 05:55:39PM +0800, Tiffany Lin wrote:
> >>> Add a DT binding documentation of Video Encoder for the
> >>> MT8173 SoC from Mediatek.
> >>>
> >>> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> >>
> >> A question and minor issue below, otherwise:
> >>
> >> Acked-by: Rob Herring <robh@kernel.org>
> >>
> >>> ---
> >>>   .../devicetree/bindings/media/mediatek-vcodec.txt  |   58 ++++++++++++++++++++
> >>>   1 file changed, 58 insertions(+)
> >>>   create mode 100644 Documentation/devicetree/bindings/media/mediatek-vcodec.txt
> >>>
> >>> diff --git a/Documentation/devicetree/bindings/media/mediatek-vcodec.txt b/Documentation/devicetree/bindings/media/mediatek-vcodec.txt
> >>> new file mode 100644
> >>> index 0000000..510cd81
> >>> --- /dev/null
> >>> +++ b/Documentation/devicetree/bindings/media/mediatek-vcodec.txt
> >>> @@ -0,0 +1,58 @@
> >>> +Mediatek Video Codec
> >>> +
> >>> +Mediatek Video Codec is the video codec hw present in Mediatek SoCs which
> >>> +supports high resolution encoding functionalities.
> >>> +
> >>> +Required properties:
> >>> +- compatible : "mediatek,mt8173-vcodec-enc" for encoder
> >>> +- reg : Physical base address of the video codec registers and length of
> >>> +  memory mapped region.
> >>> +- interrupts : interrupt number to the cpu.
> >>> +- mediatek,larb : must contain the local arbiters in the current Socs.
> 
> This looks strange, shouldn't it be "larb" instead of "mediatek,larb".
> At least the example does not use the mediatek prefix.
> 
We plan to change larb and vpu to mediate,larb and mediatek,vpu.
We will fix this unmatch issue in next version.

best regards,
Tiffany

> >>> +- clocks : list of clock specifiers, corresponding to entries in
> >>> +  the clock-names property;
> >>> +- clock-names: must contain "vencpll", "venc_lt_sel", "vcodecpll_370p5_ck"
> >>> +- iommus : list of iommus specifiers should be enabled for hw encode.
> >>> +  There are 2 cells needed to enable/disable iommu.
> >>> +  The first one is local arbiter index(larbid), and the other is port
> >>> +  index(portid) within local arbiter. Specifies the larbid and portid
> >>> +  as defined in dt-binding/memory/mt8173-larb-port.h.
> >>> +- mediatek,vpu : the node of video processor unit
> 
> Same here.
> 
> Regards,
> Matthias
> 
> >>> +
> >>> +Example:
> >>> +vcodec_enc: vcodec@0x18002000 {
> >>> +    compatible = "mediatek,mt8173-vcodec-enc";
> >>> +    reg = <0 0x18002000 0 0x1000>,    /*VENC_SYS*/
> >>> +          <0 0x19002000 0 0x1000>;    /*VENC_LT_SYS*/
> >>> +    interrupts = <GIC_SPI 198 IRQ_TYPE_LEVEL_LOW>,
> >>> +           <GIC_SPI 202 IRQ_TYPE_LEVEL_LOW>;
> >>> +    larb = <&larb3>,
> >>> +           <&larb5>;
> >>> +    iommus = <&iommu M4U_LARB3_ID M4U_PORT_VENC_RCPU>,
> >>
> >> Is this the same iommu as the VPU? If so, you can't have a mixed number
> >> of cells.
> > Yes, its same iommus as the VPU.
> > Now we use two parameters for iommus.
> > We will fix this in next version.
> >
> >>> +             <&iommu M4U_LARB3_ID M4U_PORT_VENC_REC>,
> >>> +             <&iommu M4U_LARB3_ID M4U_PORT_VENC_BSDMA>,
> >>> +             <&iommu M4U_LARB3_ID M4U_PORT_VENC_SV_COMV>,
> >>> +             <&iommu M4U_LARB3_ID M4U_PORT_VENC_RD_COMV>,
> >>> +             <&iommu M4U_LARB3_ID M4U_PORT_VENC_CUR_LUMA>,
> >>> +             <&iommu M4U_LARB3_ID M4U_PORT_VENC_CUR_CHROMA>,
> >>> +             <&iommu M4U_LARB3_ID M4U_PORT_VENC_REF_LUMA>,
> >>> +             <&iommu M4U_LARB3_ID M4U_PORT_VENC_REF_CHROMA>,
> >>> +             <&iommu M4U_LARB3_ID M4U_PORT_VENC_NBM_RDMA>,
> >>> +             <&iommu M4U_LARB3_ID M4U_PORT_VENC_NBM_WDMA>,
> >>> +             <&iommu M4U_LARB5_ID M4U_PORT_VENC_RCPU_SET2>,
> >>> +             <&iommu M4U_LARB5_ID M4U_PORT_VENC_REC_FRM_SET2>,
> >>> +             <&iommu M4U_LARB5_ID M4U_PORT_VENC_BSDMA_SET2>,
> >>> +             <&iommu M4U_LARB5_ID M4U_PORT_VENC_SV_COMA_SET2>,
> >>> +             <&iommu M4U_LARB5_ID M4U_PORT_VENC_RD_COMA_SET2>,
> >>> +             <&iommu M4U_LARB5_ID M4U_PORT_VENC_CUR_LUMA_SET2>,
> >>> +             <&iommu M4U_LARB5_ID M4U_PORT_VENC_CUR_CHROMA_SET2>,
> >>> +             <&iommu M4U_LARB5_ID M4U_PORT_VENC_REF_LUMA_SET2>,
> >>> +             <&iommu M4U_LARB5_ID M4U_PORT_VENC_REC_CHROMA_SET2>;
> >>> +    vpu = <&vpu>;
> >>
> >> Need to update the example.
> > Sorry, I didn't get it.
> > Do you means update VPU binding document "media/mediatek-vpu.txt"?
> >
> >>
> >>> +    clocks = <&apmixedsys CLK_APMIXED_VENCPLL>,
> >>> +             <&topckgen CLK_TOP_VENC_LT_SEL>,
> >>> +             <&topckgen CLK_TOP_VCODECPLL_370P5>;
> >>> +    clock-names = "vencpll",
> >>> +                  "venc_lt_sel",
> >>> +                  "vcodecpll_370p5_ck";
> >>> +  };
> >>> --
> >>> 1.7.9.5
> >>>
> >
> >


