Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:38130 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754083AbcKDEvG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2016 00:51:06 -0400
Message-ID: <1478235060.23008.35.camel@mtksdaap41>
Subject: Re: [PATCH v2 1/3] dt-bindings: mediatek: Add a binding for
 Mediatek JPEG Decoder
From: Rick Chang <rick.chang@mediatek.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <srv_heupstream@mediatek.com>,
        <linux-mediatek@lists.infradead.org>,
        "Minghsiu Tsai" <minghsiu.tsai@mediatek.com>
Date: Fri, 4 Nov 2016 12:51:00 +0800
In-Reply-To: <1838616.gXE7Zi2nyC@avalon>
References: <1477898217-19250-1-git-send-email-rick.chang@mediatek.com>
         <1477898217-19250-2-git-send-email-rick.chang@mediatek.com>
         <5665939.z4I9T3nobc@avalon> <1838616.gXE7Zi2nyC@avalon>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thank you for the comments.I will fix them in the next patch (v3).

On Thu, 2016-11-03 at 20:34 +0200, Laurent Pinchart wrote:
> Hi Rick,
> 
> A few more comments.
> 
> On Thursday 03 Nov 2016 20:33:12 Laurent Pinchart wrote:
> > On Monday 31 Oct 2016 15:16:55 Rick Chang wrote:
> > > Add a DT binding documentation for Mediatek JPEG Decoder of
> > > MT2701 SoC.
> > > 
> > > Signed-off-by: Rick Chang <rick.chang@mediatek.com>
> > > Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> > > ---
> > > 
> > >  .../bindings/media/mediatek-jpeg-codec.txt         | 35 ++++++++++++++++
> > >  1 file changed, 35 insertions(+)
> > >  create mode 100644
> > > Documentation/devicetree/bindings/media/mediatek-jpeg-codec.txt
> > > 
> > > diff --git
> > > a/Documentation/devicetree/bindings/media/mediatek-jpeg-codec.txt
> > > b/Documentation/devicetree/bindings/media/mediatek-jpeg-codec.txt new
> > > file mode 100644
> > > index 0000000..514e656
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/media/mediatek-jpeg-codec.txt
> > > @@ -0,0 +1,35 @@
> > > +* Mediatek JPEG Codec
> > 
> > Is it a codec or a decoder only ?
> > 
> > > +Mediatek JPEG Codec device driver is a v4l2 driver which can decode
> > > +JPEG-encoded video frames.
> > 
> > DT bindings should not reference drivers, they are OS-agnostic.
> > 
> > > +Required properties:
> > > +  - compatible : "mediatek,mt2701-jpgdec"
> 
> Is the JPEG decoder found in MT2701 only, or in other Mediatek SoCs as well ?

Yes, the JPEG decoder is found in other Mediatek SoCs. However, the JPEG
decoder HW in different SoCs have different register base, interrupt,
power-domain and iommu setting. This patch series is only applicable in
MT2701.

> > > +  - reg : Physical base address of the jpeg codec registers and length of
> > > +        memory mapped region.
> > > +  - interrupts : interrupt number to the cpu.
> > 
> > That's actually not correct, the interrupt number is local to the interrupt
> > controller, not to the CPU.
> > 
> > > +  - clocks : clock name from clock manager
> > 
> > The clocks property doesn't contain a name.
> 
> Furthermore you should document which clocks need to be specified here. There 
> are two of them in the example below, the documentation should explain this 
> clearly.

OK.

> > Until we provide standardized descriptions for those properties, I recommend
> > copying the compatible, reg, interrupts, clocks, clock-names, power-domains
> > and iommus properties descriptions from good DT bindings. Which DT bindings
> > are good source of inspiration here is left as an exercise for the reader
> > I'm afraid :-(
> > 
> > > +  - clock-names: the clocks of the jpeg codec H/W
> > > +  - power-domains : a phandle to the power domain.
> > > +  - larb : must contain the larbes of current platform
> > 
> > Shouldn't this be mediatek,larb ? And what is a larb ?
> > 
> > > +  - iommus : Mediatek IOMMU H/W has designed the fixed associations with
> > > +        the multimedia H/W. and there is only one multimedia iommu
> > > domain.
> > > +        "iommus = <&iommu portid>" the "portid" is from
> > > +        dt-bindings\iommu\mt2701-iommu-port.h, it means that this portid
> > > will
> > > +        enable iommu. The portid default is disable iommu if "<&iommu>
> > 
> > portid>"
> > 
> > > +        don't be added.
> > 
> > There are two iommus instances in your example below, this should be
> > documented. This description is not very clear I'm afraid.
> > 
> > > +
> > > +Example:
> > > +	jpegdec: jpegdec@15004000 {
> > > +		compatible = "mediatek,mt2701-jpgdec";
> > > +		reg = <0 0x15004000 0 0x1000>;
> > > +		interrupts = <GIC_SPI 143 IRQ_TYPE_LEVEL_LOW>;
> > > +		clocks =  <&imgsys CLK_IMG_JPGDEC_SMI>,
> > > +			  <&imgsys CLK_IMG_JPGDEC>;
> > > +		clock-names = "jpgdec-smi",
> > > +			      "jpgdec";
> > > +		power-domains = <&scpsys MT2701_POWER_DOMAIN_ISP>;
> > > +		mediatek,larb = <&larb2>;
> > > +		iommus = <&iommu MT2701_M4U_PORT_JPGDEC_WDMA>,
> > > +			 <&iommu MT2701_M4U_PORT_JPGDEC_BSDMA>;
> > > +	};
> 


