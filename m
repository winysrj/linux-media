Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:11823 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754309AbcKVDVz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Nov 2016 22:21:55 -0500
Message-ID: <1479784905.8964.15.camel@mtksdaap41>
Subject: Re: [PATCH v6 3/3] arm: dts: mt2701: Add node for Mediatek JPEG
 Decoder
From: Rick Chang <rick.chang@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Rob Herring" <robh+dt@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <srv_heupstream@mediatek.com>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>
Date: Tue, 22 Nov 2016 11:21:45 +0800
In-Reply-To: <d602365a-e87b-5bae-8698-bd43063ef079@xs4all.nl>
References: <1479353915-5043-1-git-send-email-rick.chang@mediatek.com>
         <1479353915-5043-4-git-send-email-rick.chang@mediatek.com>
         <d602365a-e87b-5bae-8698-bd43063ef079@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, 2016-11-21 at 15:51 +0100, Hans Verkuil wrote:
> On 17/11/16 04:38, Rick Chang wrote:
> > Signed-off-by: Rick Chang <rick.chang@mediatek.com>
> > Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> > ---
> > This patch depends on:
> >   CCF "Add clock support for Mediatek MT2701"[1]
> >   iommu and smi "Add the dtsi node of iommu and smi for mt2701"[2]
> >
> > [1] http://lists.infradead.org/pipermail/linux-mediatek/2016-October/007271.html
> > [2] https://patchwork.kernel.org/patch/9164013/
> 
> I assume that 1 & 2 will appear in 4.10? So this patch needs to go in 
> after the
> other two are merged in 4.10?
> 
> Regards,
> 
> 	Hans

[1] will appear in 4.10, but [2] will appear latter than 4.10.So this
patch needs to go in after [1] & [2] will be merged in 4.11.

> > ---
> >  arch/arm/boot/dts/mt2701.dtsi | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >
> > diff --git a/arch/arm/boot/dts/mt2701.dtsi b/arch/arm/boot/dts/mt2701.dtsi
> > index 8f13c70..4dd5048 100644
> > --- a/arch/arm/boot/dts/mt2701.dtsi
> > +++ b/arch/arm/boot/dts/mt2701.dtsi
> > @@ -298,6 +298,20 @@
> >  		power-domains = <&scpsys MT2701_POWER_DOMAIN_ISP>;
> >  	};
> >
> > +	jpegdec: jpegdec@15004000 {
> > +		compatible = "mediatek,mt2701-jpgdec";
> > +		reg = <0 0x15004000 0 0x1000>;
> > +		interrupts = <GIC_SPI 143 IRQ_TYPE_LEVEL_LOW>;
> > +		clocks =  <&imgsys CLK_IMG_JPGDEC_SMI>,
> > +			  <&imgsys CLK_IMG_JPGDEC>;
> > +		clock-names = "jpgdec-smi",
> > +			      "jpgdec";
> > +		power-domains = <&scpsys MT2701_POWER_DOMAIN_ISP>;
> > +		mediatek,larb = <&larb2>;
> > +		iommus = <&iommu MT2701_M4U_PORT_JPGDEC_WDMA>,
> > +			 <&iommu MT2701_M4U_PORT_JPGDEC_BSDMA>;
> > +	};
> > +
> >  	vdecsys: syscon@16000000 {
> >  		compatible = "mediatek,mt2701-vdecsys", "syscon";
> >  		reg = <0 0x16000000 0 0x1000>;
> >


