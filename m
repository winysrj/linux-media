Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:41420 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757046AbeD0DEh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 23:04:37 -0400
Date: Thu, 26 Apr 2018 22:04:36 -0500
From: Rob Herring <robh@kernel.org>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Tomasz Figa <tfiga@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>, wens@csie.org,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <acourbot@chromium.org>
Subject: Re: [PATCH v2 08/10] dt-bindings: media: Document bindings for the
 Sunxi-Cedrus VPU driver
Message-ID: <20180427030436.3ptrb2ldhtnssipj@rob-hp-laptop>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
 <20180419154536.17846-4-paul.kocialkowski@bootlin.com>
 <1524153860.3416.9.camel@pengutronix.de>
 <CAAFQd5DT_xjUbZzFOoKk7_duiSZ8Awb1J=0dPEhVTBk0P3gppA@mail.gmail.com>
 <5fa80b1e88ad2a215f51ea3a2b9b62274fa9b1ec.camel@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fa80b1e88ad2a215f51ea3a2b9b62274fa9b1ec.camel@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 20, 2018 at 09:22:20AM +0200, Paul Kocialkowski wrote:
> Hi and thanks for the review,
> 
> On Fri, 2018-04-20 at 01:31 +0000, Tomasz Figa wrote:
> > Hi Paul, Philipp,
> > 
> > On Fri, Apr 20, 2018 at 1:04 AM Philipp Zabel <p.zabel@pengutronix.de>
> > wrote:
> > 
> > > Hi Paul,
> > > On Thu, 2018-04-19 at 17:45 +0200, Paul Kocialkowski wrote:
> > > > This adds a device-tree binding document that specifies the
> > > > properties
> > > > used by the Sunxi-Cedurs VPU driver, as well as examples.
> > > > 
> > > > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > > > ---
> > > >  .../devicetree/bindings/media/sunxi-cedrus.txt     | 50
> > 
> > ++++++++++++++++++++++
> > > >  1 file changed, 50 insertions(+)
> > > >  create mode 100644
> > 
> > Documentation/devicetree/bindings/media/sunxi-cedrus.txt
> > > > 
> > > > diff --git a/Documentation/devicetree/bindings/media/sunxi-
> > > > cedrus.txt
> > 
> > b/Documentation/devicetree/bindings/media/sunxi-cedrus.txt
> > > > new file mode 100644
> > > > index 000000000000..71ad3f9c3352
> > > > --- /dev/null
> > > > +++ b/Documentation/devicetree/bindings/media/sunxi-cedrus.txt
> > > > @@ -0,0 +1,50 @@
> > > > +Device-tree bindings for the VPU found in Allwinner SoCs,
> > > > referred to
> > 
> > as the
> > > > +Video Engine (VE) in Allwinner literature.
> > > > +
> > > > +The VPU can only access the first 256 MiB of DRAM, that are DMA-
> > > > mapped
> > 
> > starting
> > > > +from the DRAM base. This requires specific memory allocation and
> > 
> > handling.
> > 
> > And no IOMMU? Brings back memories.
> 
> Exactly, no IOMMU so we don't have much choice but cope with that
> hardware limitation...
> 
> > > > +
> > > > +Required properties:
> > > > +- compatible         : "allwinner,sun4i-a10-video-engine";
> > > > +- memory-region         : DMA pool for buffers allocation;
> > > > +- clocks             : list of clock specifiers, corresponding to
> > 
> > entries in
> > > > +                          the clock-names property;
> > > > +- clock-names                : should contain "ahb", "mod" and
> > > > "ram"
> > 
> > entries;
> > > > +- assigned-clocks       : list of clocks assigned to the VE;
> > > > +- assigned-clocks-rates : list of clock rates for the clocks
> > > > assigned
> > 
> > to the VE;
> > > > +- resets             : phandle for reset;
> > > > +- interrupts         : should contain VE interrupt number;
> > > > +- reg                        : should contain register base and
> > > > length
> > 
> > of VE.
> > > > +
> > > > +Example:
> > > > +
> > > > +reserved-memory {
> > > > +     #address-cells = <1>;
> > > > +     #size-cells = <1>;
> > > > +     ranges;
> > > > +
> > > > +     /* Address must be kept in the lower 256 MiBs of DRAM for
> > > > VE. */
> > > > +     ve_memory: cma@4a000000 {
> > > > +             compatible = "shared-dma-pool";
> > > > +             reg = <0x4a000000 0x6000000>;
> > > > +             no-map;
> > > > +             linux,cma-default;
> > > > +     };
> > > > +};
> > > > +
> > > > +video-engine@1c0e000 {
> > > This is not really required by any specification, and not as common
> > > as
> > > gpu@..., but could this reasonably be called "vpu@1c0e000" to follow
> > > somewhat-common practice?
> > 
> > AFAIR the name is supposed to be somewhat readable for someone that
> > doesn't know the hardware. To me, "video-engine" sounds more obvious
> > than "vpu", but we actually use "codec" already, in case of MFC and
> > JPEG codec on Exynos. If encode/decode is the only functionality of
> > this block, I'd personally go with "codec". If it can do other things,
> > e.g. scaling/rotation without encode/decode, I'd probably call it
> > "video-processor".
> 
> I agree that the term VPU is more commonly associated with video
> decoding, while video engine could mean a number of things.
> 
> The reason I went with "video-engine" here (while still presenting the
> driver as a VPU driver) is that Video Engine is the term used in
> Allwinner's litterature. Other nodes in Allwinner device-trees generally
> stick to these terms (for instance, we have "display-engine" nodes).
> This also makes it easier to find the matching parts in the
> documentation.

'video-codec' is what is defined in the DT spec.

Rob
