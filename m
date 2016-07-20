Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:17654 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752395AbcGTMOt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 08:14:49 -0400
Message-ID: <1469016882.12306.3.camel@mtksdaap41>
Subject: Re: [PATCH 2/4] dt-bindings: Add a binding for Mediatek MDP
From: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
To: Rob Herring <robh@kernel.org>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>,
	"Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	<srv_heupstream@mediatek.com>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>, <linux-mediatek@lists.infradead.org>
Date: Wed, 20 Jul 2016 20:14:42 +0800
In-Reply-To: <20160716230113.GA31551@rob-hp-laptop>
References: <1468498681-19955-1-git-send-email-minghsiu.tsai@mediatek.com>
	 <1468498681-19955-3-git-send-email-minghsiu.tsai@mediatek.com>
	 <20160716230113.GA31551@rob-hp-laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2016-07-16 at 18:01 -0500, Rob Herring wrote:
> On Thu, Jul 14, 2016 at 08:17:59PM +0800, Minghsiu Tsai wrote:
> > Add a DT binding documentation of MDP for the MT8173 SoC
> > from Mediatek
> > 
> > Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> > ---
> >  .../devicetree/bindings/media/mediatek-mdp.txt     |   92 ++++++++++++++++++++
> >  1 file changed, 92 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/mediatek-mdp.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/media/mediatek-mdp.txt b/Documentation/devicetree/bindings/media/mediatek-mdp.txt
> > new file mode 100644
> > index 0000000..ef570c3
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/mediatek-mdp.txt
> > @@ -0,0 +1,92 @@
> > +* Mediatek Media Data Path
> > +
> > +Media Data Path is used for scaling and color space conversion.
> > +
> > +Required properties:
> > +  - compatible : should contain them as below:
> > +        "mediatek,mt8173-mdp"
> > +        "mediatek,mt8173-mdp-rdma"
> > +        "mediatek,mt8173-mdp-rsz"
> > +        "mediatek,mt8173-mdp-wdma"
> > +        "mediatek,mt8173-mdp-wrot"
> > +  - clocks : device clocks
> > +  - power-domains : a phandle to the power domain.
> > +  - mediatek,larb : should contain the larbes of current platform
> > +  - iommus : Mediatek IOMMU H/W has designed the fixed associations with
> > +        the multimedia H/W. and there is only one multimedia iommu domain.
> > +        "iommus = <&iommu portid>" the "portid" is from
> > +        dt-bindings\iommu\mt8173-iommu-port.h, it means that this portid will
> > +        enable iommu. The portid default is disable iommu if "<&iommu portid>"
> > +        don't be added.
> > +  - mediatek,vpu : the node of video processor unit
> 
> These properties don't apply to all the nodes. I think you need a 
> section for each IP block.


I will add description for those IP block, thanks.


