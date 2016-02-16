Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:1574 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752029AbcBPCJe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 21:09:34 -0500
Message-ID: <1455588568.19396.51.camel@mtksdaap41>
Subject: Re: [PATCH v4 4/8] dt-bindings: Add a binding for Mediatek Video
 Encoder
From: tiffany lin <tiffany.lin@mediatek.com>
To: Daniel Kurtz <djkurtz@chromium.org>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Rob Herring <robh+dt@kernel.org>,
	"Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	"open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	"moderated list:ARM/Mediatek SoC support"
	<linux-mediatek@lists.infradead.org>,
	Lin PoChun <PoChun.Lin@mediatek.com>,
	Tomasz Figa <tfiga@chromium.org>
Date: Tue, 16 Feb 2016 10:09:28 +0800
In-Reply-To: <CAGS+omAkM97TOnJX-ahEMeN8zO1R2RO43LWqeFFRDuj7gM5CzA@mail.gmail.com>
References: <1454585703-42428-1-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-2-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-3-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-4-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-5-git-send-email-tiffany.lin@mediatek.com>
	 <CAGS+omDQW+yqhixCWPfQb9eaHeufgiEDscrvXGwBTc05+eDGCQ@mail.gmail.com>
	 <CAGS+omAkM97TOnJX-ahEMeN8zO1R2RO43LWqeFFRDuj7gM5CzA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

On Mon, 2016-02-15 at 18:42 +0800, Daniel Kurtz wrote:
> On Tue, Feb 9, 2016 at 7:29 PM, Daniel Kurtz <djkurtz@chromium.org> wrote:
> > Hi Tiffany,
> >
> > On Thu, Feb 4, 2016 at 7:34 PM, Tiffany Lin <tiffany.lin@mediatek.com> wrote:
> >> Add a DT binding documentation of Video Encoder for the
> >> MT8173 SoC from Mediatek.
> >>
> >> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> >> ---
> >>  .../devicetree/bindings/media/mediatek-vcodec.txt  |   59 ++++++++++++++++++++
> >>  1 file changed, 59 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/media/mediatek-vcodec.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/media/mediatek-vcodec.txt b/Documentation/devicetree/bindings/media/mediatek-vcodec.txt
> >> new file mode 100644
> >> index 0000000..572bfdd
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/media/mediatek-vcodec.txt
> >> @@ -0,0 +1,59 @@
> >> +Mediatek Video Codec
> >> +
> >> +Mediatek Video Codec is the video codec hw present in Mediatek SoCs which
> >> +supports high resolution encoding functionalities.
> >> +
> >> +Required properties:
> >> +- compatible : "mediatek,mt8173-vcodec-enc" for encoder
> >> +- reg : Physical base address of the video codec registers and length of
> >> +  memory mapped region.
> >> +- interrupts : interrupt number to the cpu.
> >> +- mediatek,larb : must contain the local arbiters in the current Socs.
> >> +- clocks : list of clock specifiers, corresponding to entries in
> >> +  the clock-names property.
> >> +- clock-names: encoder must contain "vencpll_d2", "venc_sel", "univpll1_d2",
> >> +  "venc_lt_sel".
> >> +- iommus : should point to the respective IOMMU block with master port as
> >> +  argument, see Documentation/devicetree/bindings/iommu/mediatek,iommu.txt
> >> +  for details.
> >> +- mediatek,vpu : the node of video processor unit
> >> +
> >> +Example:
> >> +vcodec_enc: vcodec@0x18002000 {
> >> +    compatible = "mediatek,mt8173-vcodec-enc";
> >> +    reg = <0 0x18002000 0 0x1000>,    /*VENC_SYS*/
> >> +          <0 0x19002000 0 0x1000>;    /*VENC_LT_SYS*/
> >
> > This really looks like two encoder devices combined into a single
> > device tree node.
> > There are two register sets, two irqs, two sets of iommus, and two
> > sets of clocks.
> >
> > If possible, please split this node into two, one for each encoder.
> 
> I chatted offline with Mediatek.  They explained that there really is
> just one encoder hardware, that happens to support multiple formats.
> The encoder cannot encode with both formats at the same time.  The
> Mediatek HW designers added a new format to an existing encoder by
> adding a second interface (register set, irq, iommus, clocks) without
> modifying the original interface.  However in the hardware itself
> there is really just one encoder device.
> 
> So, although this node looks like it is for two encoder devices (one
> for each format), really there is just one device that supports each
> format through its large interface.
> 
> So, I'm fine with this being a single device node.
> 
> >> +    interrupts = <GIC_SPI 198 IRQ_TYPE_LEVEL_LOW>,
> >> +           <GIC_SPI 202 IRQ_TYPE_LEVEL_LOW>;
> >> +    mediatek,larb = <&larb3>,
> >> +                   <&larb5>;
> >> +    iommus = <&iommu M4U_PORT_VENC_RCPU>,
> >> +             <&iommu M4U_PORT_VENC_REC>,
> >> +             <&iommu M4U_PORT_VENC_BSDMA>,
> >> +             <&iommu M4U_PORT_VENC_SV_COMV>,
> >> +             <&iommu M4U_PORT_VENC_RD_COMV>,
> >> +             <&iommu M4U_PORT_VENC_CUR_LUMA>,
> >> +             <&iommu M4U_PORT_VENC_CUR_CHROMA>,
> >> +             <&iommu M4U_PORT_VENC_REF_LUMA>,
> >> +             <&iommu M4U_PORT_VENC_REF_CHROMA>,
> >> +             <&iommu M4U_PORT_VENC_NBM_RDMA>,
> >> +             <&iommu M4U_PORT_VENC_NBM_WDMA>,
> >> +             <&iommu M4U_PORT_VENC_RCPU_SET2>,
> >> +             <&iommu M4U_PORT_VENC_REC_FRM_SET2>,
> >> +             <&iommu M4U_PORT_VENC_BSDMA_SET2>,
> >> +             <&iommu M4U_PORT_VENC_SV_COMA_SET2>,
> >> +             <&iommu M4U_PORT_VENC_RD_COMA_SET2>,
> >> +             <&iommu M4U_PORT_VENC_CUR_LUMA_SET2>,
> >> +             <&iommu M4U_PORT_VENC_CUR_CHROMA_SET2>,
> >> +             <&iommu M4U_PORT_VENC_REF_LUMA_SET2>,
> >> +             <&iommu M4U_PORT_VENC_REC_CHROMA_SET2>;
> >> +    mediatek,vpu = <&vpu>;
> >> +    clocks = <&topckgen CLK_TOP_VENCPLL_D2>,
> >> +             <&topckgen CLK_TOP_VENC_SEL>,
> >> +             <&topckgen CLK_TOP_UNIVPLL1_D2>,
> >> +             <&topckgen CLK_TOP_VENC_LT_SEL>;
> >> +    clock-names = "vencpll_d2",
> >> +                  "venc_sel",
> >> +                  "univpll1_d2",
> >> +                  "venc_lt_sel";
> >
> > The names of these clocks should be from the perspective of the
> > encoder, not the clock provider.
> 
> I still think these clock names should be updated, however.
> 
Got it. We will fix this in next version.

> -Dan


