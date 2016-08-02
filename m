Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:5335 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752037AbcHBGKG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2016 02:10:06 -0400
Message-ID: <1470116986.16982.5.camel@mtksdaap41>
Subject: Re: [PATCH v2 2/4] dt-bindings: Add a binding for Mediatek MDP
From: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
To: Rob Herring <robh@kernel.org>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	<srv_heupstream@mediatek.com>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>
Date: Tue, 2 Aug 2016 13:49:46 +0800
In-Reply-To: <CAL_JsqK4Lz9mSJ+EXAY1g9L-CzBmbsed+MfCjkf_545y1Ov0iw@mail.gmail.com>
References: <1469176383-35210-1-git-send-email-minghsiu.tsai@mediatek.com>
	 <1469176383-35210-3-git-send-email-minghsiu.tsai@mediatek.com>
	 <20160726185433.GA14609@rob-hp-laptop>
	 <1469583886.27630.18.camel@mtksdaap41>
	 <CAL_JsqK4Lz9mSJ+EXAY1g9L-CzBmbsed+MfCjkf_545y1Ov0iw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2016-07-28 at 10:55 -0500, Rob Herring wrote:
> On Tue, Jul 26, 2016 at 8:44 PM, Minghsiu Tsai
> <minghsiu.tsai@mediatek.com> wrote:
> > On Tue, 2016-07-26 at 13:54 -0500, Rob Herring wrote:
> >> On Fri, Jul 22, 2016 at 04:33:01PM +0800, Minghsiu Tsai wrote:
> >> > Add a DT binding documentation of MDP for the MT8173 SoC
> >> > from Mediatek
> >> >
> >> > Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> >> > ---
> >> >  .../devicetree/bindings/media/mediatek-mdp.txt     |   96 ++++++++++++++++++++
> >> >  1 file changed, 96 insertions(+)
> >> >  create mode 100644 Documentation/devicetree/bindings/media/mediatek-mdp.txt
> >> >
> >> > diff --git a/Documentation/devicetree/bindings/media/mediatek-mdp.txt b/Documentation/devicetree/bindings/media/mediatek-mdp.txt
> >> > new file mode 100644
> >> > index 0000000..2dad031
> >> > --- /dev/null
> >> > +++ b/Documentation/devicetree/bindings/media/mediatek-mdp.txt
> >> > @@ -0,0 +1,96 @@
> >> > +* Mediatek Media Data Path
> >> > +
> >> > +Media Data Path is used for scaling and color space conversion.
> >> > +
> >> > +Required properties (all function blocks):
> >> > +- compatible: "mediatek,<chip>-mdp"
> >>
> >> What is this, ...
> >>
> >
> > It is used to match platform driver.
> 
> Would structuring things like this work instead:
> 
> {
>   compatible = "mediatek,<chip>-mdp";
>   ranges = ...;
>   {
>     compatible = "mediatek,<chip>-mdp-rdma";
>     ...
>   };
>   {
>     compatible = "mediatek,<chip>-mdp-wdma";
>     ...
>   };
>   ...
> };
> 

I am trying to modify it as structured node. But mdp failed to convert
image. Under debugging.


> >
> >
> >> > +        "mediatek,<chip>-mdp-<function>", one of
> >>
> >> and this?
> >>
> >
> > It is string format of HW block. <chip> could be "mt8173", and
> > <function> are "rdma", "rsz", "wdma", and "wrot".
> >
> >
> >> > +        "mediatek,<chip>-mdp-rdma"  - read DMA
> >> > +        "mediatek,<chip>-mdp-rsz"   - resizer
> >> > +        "mediatek,<chip>-mdp-wdma"  - write DMA
> >> > +        "mediatek,<chip>-mdp-wrot"  - write DMA with rotation
> >>
> >> List what are valid values of <chip>.
> >>
> >
> > <chip> - mt8173. There should be other chip added in future.
> > I will change the property as blow:
> >
> > - compatible: "mediatek,<chip>-mdp"
> >         Should be one of
> >         "mediatek,<chip>-mdp-rdma"  - read DMA
> >         "mediatek,<chip>-mdp-rsz"   - resizer
> >         "mediatek,<chip>-mdp-wdma"  - write DMA
> >         "mediatek,<chip>-mdp-wrot"  - write DMA with rotation
> >         <chip> - could be 8173
> >
> >
> > If don't need <chip>, I also can change it as below. It is more clear.
> 
> Up to you. Depends on how many different chips you will have.
> 

I will replace "<chip>" with "mt8173"


> > - compatible: "mediatek,mt8173-mdp"
> >         Should be one of
> >         "mediatek,mt8173-mdp-rdma"  - read DMA
> >         "mediatek,mt8173-mdp-rsz"   - resizer
> >         "mediatek,mt8173-mdp-wdma"  - write DMA
> >         "mediatek,mt8173-mdp-wrot"  - write DMA with rotation
> >
> >
> >> > +- reg: Physical base address and length of the function block register space
> >> > +- clocks: device clocks
> >> > +- power-domains: a phandle to the power domain.
> >> > +- mediatek,vpu: the node of video processor unit
> >> > +
> >> > +Required properties (DMA function blocks):
> >> > +- compatible: Should be one of
> >> > +        "mediatek,<chip>-mdp-rdma"
> >> > +        "mediatek,<chip>-mdp-wdma"
> >> > +        "mediatek,<chip>-mdp-wrot"
> >> > +- iommus: should point to the respective IOMMU block with master port as
> >> > +  argument, see Documentation/devicetree/bindings/iommu/mediatek,iommu.txt
> >> > +  for details.
> >> > +- mediatek,larb: must contain the local arbiters in the current Socs.
> >>
> >> It is still not clear which properties apply to which compatible
> >> strings.
> >>
> >
> > I found out the document for larb.
> > I will change the property as below:
> >
> > - mediatek,larb: must contain the local arbiters in the current Socs,
> > see
> > Documentation/devicetree/bindings/memory-controllers/mediatek,smi-larb.txt
> >   for details.
> 
> That's good, but not what I meant. You still have properties which
> only apply to certain blocks, but are listed for all blocks like
> mediatek,vpu for example.
> 
> Rob


I find out other properties' document. 

- clocks: device clocks, see
  Documentation/devicetree/bindings/clock/clock-bindings.txt for
details.
- power-domains: a phandle to the power domain, see
  Documentation/devicetree/bindings/power/power_domain.txt for details.
- mediatek,vpu: the node of video processor unit, see
  Documentation/devicetree/bindings/media/mediatek-vpu.txt for details.



