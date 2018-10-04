Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:34478 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbeJEFUe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 01:20:34 -0400
Message-ID: <546235909ffa7b6ae48b29a8d532611850680d7d.camel@collabora.com>
Subject: Re: [PATCH v6 1/6] dt-bindings: Document the Rockchip VPU bindings
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-rockchip@lists.infradead.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Miouyouyou <myy@miouyouyou.fr>
Date: Thu, 04 Oct 2018 19:24:51 -0300
In-Reply-To: <2184b772-2b40-289f-5537-7ebb693479fd@xs4all.nl>
References: <20180917173022.9338-1-ezequiel@collabora.com>
         <20180917173022.9338-2-ezequiel@collabora.com>
         <2184b772-2b40-289f-5537-7ebb693479fd@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-09-28 at 13:53 +0200, Hans Verkuil wrote:
> On 09/17/2018 07:30 PM, Ezequiel Garcia wrote:
> > Add devicetree binding documentation for Rockchip Video Processing
> > Unit IP.
> > 
> > Reviewed-by: Rob Herring <robh@kernel.org>
> > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > ---
> >  .../bindings/media/rockchip-vpu.txt           | 30 +++++++++++++++++++
> >  1 file changed, 30 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/rockchip-vpu.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/media/rockchip-vpu.txt b/Documentation/devicetree/bindings/media/rockchip-vpu.txt
> > new file mode 100644
> > index 000000000000..5e0d421301ca
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/rockchip-vpu.txt
> > @@ -0,0 +1,30 @@
> > +device-tree bindings for rockchip VPU codec
> > +
> > +Rockchip (Video Processing Unit) present in various Rockchip platforms,
> > +such as RK3288 and RK3399.
> > +
> > +Required properties:
> > +- compatible: value should be one of the following
> > +		"rockchip,rk3288-vpu";
> > +		"rockchip,rk3399-vpu";
> > +- interrupts: encoding and decoding interrupt specifiers
> > +- interrupt-names: should be "vepu" and "vdpu"
> > +- clocks: phandle to VPU aclk, hclk clocks
> > +- clock-names: should be "aclk" and "hclk"
> > +- power-domains: phandle to power domain node
> > +- iommus: phandle to a iommu node
> > +
> > +Example:
> > +SoC-specific DT entry:
> > +	vpu: video-codec@ff9a0000 {
> > +		compatible = "rockchip,rk3288-vpu";
> > +		reg = <0x0 0xff9a0000 0x0 0x800>;
> > +		interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>,
> > +			     <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
> > +		interrupt-names = "vepu", "vdpu";
> > +		clocks = <&cru ACLK_VCODEC>, <&cru HCLK_VCODEC>;
> > +		clock-names = "aclk", "hclk";
> > +		power-domains = <&power RK3288_PD_VIDEO>;
> > +		iommus = <&vpu_mmu>;
> > +	};
> > +
> > 
> 
> Please remove this empty last line to avoid this warning:
> 
> .git/rebase-apply/patch:41: new blank line at EOF.
> 
> 

Will fix.

Thanks,
Eze
