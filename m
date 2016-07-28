Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40976 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbcG1Pza (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2016 11:55:30 -0400
MIME-Version: 1.0
In-Reply-To: <1469583886.27630.18.camel@mtksdaap41>
References: <1469176383-35210-1-git-send-email-minghsiu.tsai@mediatek.com>
 <1469176383-35210-3-git-send-email-minghsiu.tsai@mediatek.com>
 <20160726185433.GA14609@rob-hp-laptop> <1469583886.27630.18.camel@mtksdaap41>
From: Rob Herring <robh@kernel.org>
Date: Thu, 28 Jul 2016 10:55:05 -0500
Message-ID: <CAL_JsqK4Lz9mSJ+EXAY1g9L-CzBmbsed+MfCjkf_545y1Ov0iw@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] dt-bindings: Add a binding for Mediatek MDP
To: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	srv_heupstream@mediatek.com,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 26, 2016 at 8:44 PM, Minghsiu Tsai
<minghsiu.tsai@mediatek.com> wrote:
> On Tue, 2016-07-26 at 13:54 -0500, Rob Herring wrote:
>> On Fri, Jul 22, 2016 at 04:33:01PM +0800, Minghsiu Tsai wrote:
>> > Add a DT binding documentation of MDP for the MT8173 SoC
>> > from Mediatek
>> >
>> > Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
>> > ---
>> >  .../devicetree/bindings/media/mediatek-mdp.txt     |   96 ++++++++++++++++++++
>> >  1 file changed, 96 insertions(+)
>> >  create mode 100644 Documentation/devicetree/bindings/media/mediatek-mdp.txt
>> >
>> > diff --git a/Documentation/devicetree/bindings/media/mediatek-mdp.txt b/Documentation/devicetree/bindings/media/mediatek-mdp.txt
>> > new file mode 100644
>> > index 0000000..2dad031
>> > --- /dev/null
>> > +++ b/Documentation/devicetree/bindings/media/mediatek-mdp.txt
>> > @@ -0,0 +1,96 @@
>> > +* Mediatek Media Data Path
>> > +
>> > +Media Data Path is used for scaling and color space conversion.
>> > +
>> > +Required properties (all function blocks):
>> > +- compatible: "mediatek,<chip>-mdp"
>>
>> What is this, ...
>>
>
> It is used to match platform driver.

Would structuring things like this work instead:

{
  compatible = "mediatek,<chip>-mdp";
  ranges = ...;
  {
    compatible = "mediatek,<chip>-mdp-rdma";
    ...
  };
  {
    compatible = "mediatek,<chip>-mdp-wdma";
    ...
  };
  ...
};

>
>
>> > +        "mediatek,<chip>-mdp-<function>", one of
>>
>> and this?
>>
>
> It is string format of HW block. <chip> could be "mt8173", and
> <function> are "rdma", "rsz", "wdma", and "wrot".
>
>
>> > +        "mediatek,<chip>-mdp-rdma"  - read DMA
>> > +        "mediatek,<chip>-mdp-rsz"   - resizer
>> > +        "mediatek,<chip>-mdp-wdma"  - write DMA
>> > +        "mediatek,<chip>-mdp-wrot"  - write DMA with rotation
>>
>> List what are valid values of <chip>.
>>
>
> <chip> - mt8173. There should be other chip added in future.
> I will change the property as blow:
>
> - compatible: "mediatek,<chip>-mdp"
>         Should be one of
>         "mediatek,<chip>-mdp-rdma"  - read DMA
>         "mediatek,<chip>-mdp-rsz"   - resizer
>         "mediatek,<chip>-mdp-wdma"  - write DMA
>         "mediatek,<chip>-mdp-wrot"  - write DMA with rotation
>         <chip> - could be 8173
>
>
> If don't need <chip>, I also can change it as below. It is more clear.

Up to you. Depends on how many different chips you will have.

> - compatible: "mediatek,mt8173-mdp"
>         Should be one of
>         "mediatek,mt8173-mdp-rdma"  - read DMA
>         "mediatek,mt8173-mdp-rsz"   - resizer
>         "mediatek,mt8173-mdp-wdma"  - write DMA
>         "mediatek,mt8173-mdp-wrot"  - write DMA with rotation
>
>
>> > +- reg: Physical base address and length of the function block register space
>> > +- clocks: device clocks
>> > +- power-domains: a phandle to the power domain.
>> > +- mediatek,vpu: the node of video processor unit
>> > +
>> > +Required properties (DMA function blocks):
>> > +- compatible: Should be one of
>> > +        "mediatek,<chip>-mdp-rdma"
>> > +        "mediatek,<chip>-mdp-wdma"
>> > +        "mediatek,<chip>-mdp-wrot"
>> > +- iommus: should point to the respective IOMMU block with master port as
>> > +  argument, see Documentation/devicetree/bindings/iommu/mediatek,iommu.txt
>> > +  for details.
>> > +- mediatek,larb: must contain the local arbiters in the current Socs.
>>
>> It is still not clear which properties apply to which compatible
>> strings.
>>
>
> I found out the document for larb.
> I will change the property as below:
>
> - mediatek,larb: must contain the local arbiters in the current Socs,
> see
> Documentation/devicetree/bindings/memory-controllers/mediatek,smi-larb.txt
>   for details.

That's good, but not what I meant. You still have properties which
only apply to certain blocks, but are listed for all blocks like
mediatek,vpu for example.

Rob
