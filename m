Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:9487 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751422AbdDUEGS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Apr 2017 00:06:18 -0400
Message-ID: <1492747570.25908.36.camel@mtksdaap41>
Subject: Re: [PATCH 1/3] dt-bindings: mt8173: Fix mdp device tree
From: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
To: Rob Herring <robh@kernel.org>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
        <daniel.thompson@linaro.org>,
        "Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        Houlong Wei <houlong.wei@mediatek.com>,
        <srv_heupstream@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Wu-Cheng Li <wuchengli@google.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>, <linux-mediatek@lists.infradead.org>
Date: Fri, 21 Apr 2017 12:06:10 +0800
In-Reply-To: <20170419213540.4vigeed3mx24ie4e@rob-hp-laptop>
References: <1492068787-17838-1-git-send-email-minghsiu.tsai@mediatek.com>
         <1492068787-17838-2-git-send-email-minghsiu.tsai@mediatek.com>
         <20170419213540.4vigeed3mx24ie4e@rob-hp-laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-04-19 at 16:35 -0500, Rob Herring wrote:
> On Thu, Apr 13, 2017 at 03:33:05PM +0800, Minghsiu Tsai wrote:
> > If the mdp_* nodes are under an mdp sub-node, their corresponding
> > platform device does not automatically get its iommu assigned properly.
> > 
> > Fix this by moving the mdp component nodes up a level such that they are
> > siblings of mdp and all other SoC subsystems.  This also simplifies the
> > device tree.
> 
> It may simplify the DT, but it also breaks compatibility with old DT. 
> Not sure if that's a problem on Mediatek platforms, but please be 
> explicit here that you are breaking compatibility and why that is okay.
> 

I will add the following description for more information.
"
Although it fixes iommu assignment issue, it also break compatibility
with old device tree, so driver patch[1] is needed to iterate over
sibling mdp device nodes, not child ones, to keep driver work properly.
In mtk_mdp_probe()
Old: for_each_child_of_node(dev->of_node, node)
New: for_each_child_of_node(dev->of_node->parent, node)

[1]https://patchwork.kernel.org/patch/9678833/
"

> > 
> > Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> > Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> 
> Should this have Daniel as the author?

This patch is provided by Daniel, so I keep he is the author.
I just split his patch into two parts. One is dts only, and the other is
for driver. I also provide another patch to modify dts bindings
according to this patch.


> 
> > 
> > ---
> >  Documentation/devicetree/bindings/media/mediatek-mdp.txt | 12 +++---------
> >  1 file changed, 3 insertions(+), 9 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/media/mediatek-mdp.txt b/Documentation/devicetree/bindings/media/mediatek-mdp.txt
> > index 4182063..0d03e3a 100644
> > --- a/Documentation/devicetree/bindings/media/mediatek-mdp.txt
> > +++ b/Documentation/devicetree/bindings/media/mediatek-mdp.txt
> > @@ -2,7 +2,7 @@
> >  
> >  Media Data Path is used for scaling and color space conversion.
> >  
> > -Required properties (controller (parent) node):
> > +Required properties (controller node):
> >  - compatible: "mediatek,mt8173-mdp"
> >  - mediatek,vpu: the node of video processor unit, see
> >    Documentation/devicetree/bindings/media/mediatek-vpu.txt for details.
> > @@ -32,21 +32,16 @@ Required properties (DMA function blocks, child node):
> >    for details.
> >  
> >  Example:
> > -mdp {
> > -	compatible = "mediatek,mt8173-mdp";
> > -	#address-cells = <2>;
> > -	#size-cells = <2>;
> > -	ranges;
> > -	mediatek,vpu = <&vpu>;
> > -
> >  	mdp_rdma0: rdma@14001000 {
> >  		compatible = "mediatek,mt8173-mdp-rdma";
> > +			     "mediatek,mt8173-mdp";
> >  		reg = <0 0x14001000 0 0x1000>;
> >  		clocks = <&mmsys CLK_MM_MDP_RDMA0>,
> >  			 <&mmsys CLK_MM_MUTEX_32K>;
> >  		power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
> >  		iommus = <&iommu M4U_PORT_MDP_RDMA0>;
> >  		mediatek,larb = <&larb0>;
> > +		mediatek,vpu = <&vpu>;
> >  	};
> >  
> >  	mdp_rdma1: rdma@14002000 {
> > @@ -106,4 +101,3 @@ mdp {
> >  		iommus = <&iommu M4U_PORT_MDP_WROT1>;
> >  		mediatek,larb = <&larb4>;
> >  	};
> > -};
> > -- 
> > 1.9.1
> > 
