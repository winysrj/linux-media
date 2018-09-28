Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:52765 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726934AbeI1VLZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Sep 2018 17:11:25 -0400
Date: Fri, 28 Sep 2018 17:47:11 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Yong Deng <yong.deng@magewell.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Thierry Reding <treding@nvidia.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Todor Tomov <todor.tomov@linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH v11 1/2] dt-bindings: media: Add Allwinner V3s Camera
 Sensor Interface (CSI)
Message-ID: <20180928144710.55rroseaqteklp3o@paasikivi.fi.intel.com>
References: <1537951204-24672-1-git-send-email-yong.deng@magewell.com>
 <20180928093833.gwmskm2jvby6x4s6@paasikivi.fi.intel.com>
 <14114604.4rraf0qJLU@avalon>
 <20180928102345.r2g342tg5mgcwfw6@paasikivi.fi.intel.com>
 <CAGb2v65YpPRHb5YiGJhC8NX5F5i3+1rW5y6Dq5L+pNN3U_uLdQ@mail.gmail.com>
 <20180928125601.6ye5tvrmh57amvh5@paasikivi.fi.intel.com>
 <CAGb2v67v0No0=JSt4HQCWeKKTz4gSHUfdyv16T-=4dxGB=JCow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGb2v67v0No0=JSt4HQCWeKKTz4gSHUfdyv16T-=4dxGB=JCow@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 28, 2018 at 09:42:50PM +0800, Chen-Yu Tsai wrote:
> Hi,
> 
> On Fri, Sep 28, 2018 at 8:56 PM Sakari Ailus
> <sakari.ailus@linux.intel.com> wrote:
> >
> > Hi Chen-Yu,
> >
> > On Fri, Sep 28, 2018 at 07:10:58PM +0800, Chen-Yu Tsai wrote:
> > > On Fri, Sep 28, 2018 at 6:23 PM Sakari Ailus
> > > <sakari.ailus@linux.intel.com> wrote:
> > > >
> > > > Hi Laurent,
> > > >
> > > > On Fri, Sep 28, 2018 at 12:45:12PM +0300, Laurent Pinchart wrote:
> > > > > Hi Sakari,
> > > > >
> > > > > On Friday, 28 September 2018 12:38:33 EEST Sakari Ailus wrote:
> > > > > > On Wed, Sep 26, 2018 at 04:40:04PM +0800, Yong Deng wrote:
> > > > > > > Add binding documentation for Allwinner V3s CSI.
> > > > > > >
> > > > > > > Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > > > > > > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > > > >
> > > > > > I know... but I have a few more comments.
> > > > > >
> > > > > > > Reviewed-by: Rob Herring <robh@kernel.org>
> > > > > > > Signed-off-by: Yong Deng <yong.deng@magewell.com>
> > > > > > > ---
> > > > > > >
> > > > > > >  .../devicetree/bindings/media/sun6i-csi.txt        | 59 +++++++++++++++++
> > > > > > >  1 file changed, 59 insertions(+)
> > > > > > >  create mode 100644 Documentation/devicetree/bindings/media/sun6i-csi.txt
> > > > > > >
> > > > > > > diff --git a/Documentation/devicetree/bindings/media/sun6i-csi.txt
> > > > > > > b/Documentation/devicetree/bindings/media/sun6i-csi.txt new file mode
> > > > > > > 100644
> > > > > > > index 000000000000..2ff47a9507a6
> > > > > > > --- /dev/null
> > > > > > > +++ b/Documentation/devicetree/bindings/media/sun6i-csi.txt
> > > > > > > @@ -0,0 +1,59 @@
> > > > > > > +Allwinner V3s Camera Sensor Interface
> > > > > > > +-------------------------------------
> > > > > > > +
> > > > > > > +Allwinner V3s SoC features two CSI module. CSI0 is used for MIPI CSI-2
> > > > > > > +interface and CSI1 is used for parallel interface.
> > > > > > > +
> > > > > > > +Required properties:
> > > > > > > +  - compatible: value must be "allwinner,sun8i-v3s-csi"
> > > > > > > +  - reg: base address and size of the memory-mapped region.
> > > > > > > +  - interrupts: interrupt associated to this IP
> > > > > > > +  - clocks: phandles to the clocks feeding the CSI
> > > > > > > +    * bus: the CSI interface clock
> > > > > > > +    * mod: the CSI module clock
> > > > > > > +    * ram: the CSI DRAM clock
> > > > > > > +  - clock-names: the clock names mentioned above
> > > > > > > +  - resets: phandles to the reset line driving the CSI
> > > > > > > +
> > > > > > > +Each CSI node should contain one 'port' child node with one child
> > > > > > > 'endpoint' +node, according to the bindings defined in
> > > > > > > +Documentation/devicetree/bindings/media/video-interfaces.txt. As
> > > > > > > mentioned
> > > > > > > +above, the endpoint's bus type should be MIPI CSI-2 for CSI0 and parallel
> > > > > > > or +Bt656 for CSI1.
> > > > > >
> > > > > > Which port represents CSI0 and which one is CSI1? That needs to be
> > > > > > documented.
> > > > >
> > > > > There are two CSI devices, named CSI0 and CSI1, with one port each. The CSI0
> > > > > device supports CSI-2 only, and the CSI1 device parallel (BT.601 or BT.656)
> > > > > only.
> > > > >
> > > > > > > +
> > > > > > > +Endpoint node properties for CSI1
> > > > > >
> > > > > > How about CSI0? I'd expect at least data-lanes, and clock-lanes as well if
> > > > > > the hardware supports lane mapping.
> > > > >
> > > > > I enquired about that too. As far as I understand, CSI0 isn't supported yet in
> > > > > the driver due to lack of documentation and lack of open-source vendor-
> > > > > provided source code. While DT bindings are not tied to driver
> > > > > implementations, it's not the best idea to design DT bindings without at least
> > > > > one working implementation to test them. I thus proposed just listing CSI0 as
> > > > > being unsupported for now.
> > > >
> > > > Ack.
> > > >
> > > > We should still define which receiver corresponds to a given port. Probably
> > > > 1 for CSI1 would make sense, in order to avoid changing the order the
> > > > hardware already uses. 0 doesn't need to be documented no IMO.
> > > >
> > > > What do you think?
> > >
> > > AFAICT it would be a completely seperate node, since they have different address
> > > spaces, clocks and reset controls. So there's no possibility of confusion.
> > >
> > > According to Yong, CSI0 is tied internally to some unknown MIPI CSI2-receiver,
> > > which is the undocumented part. CSI1 has its parallel data pins exposed to the
> > > outside.
> >
> > Thanks for clearing up the confusion. If these are truly different kinds of
> > devices, then don't they also deserve different compatible strings? And
> > possibly also different DT binding documentation in a separate file.
> 
> Allwinner's documents aren't particularly clear about this. AFAICT it does not
> say anything about them being different. The CSI section gives a register table
> with two base addresses. The V3S SDK listed on linux-sunxi wiki also doesn't
> differentiate between the two. What's more is there's actually code and register
> addresses for the MIPI stuff [1], though the license is questionable,
> as with most
> BSPs. It indeed seems like a CSI controller, which basically just takes whatever
> input it is configured for and sends it to either a downstream ISP or DRAM.
> There are MIPI-CSI receiver and DPHY blocks in addresses following CSI0, but we
> can treat them as separate hardware blocks.

What you could still do is to change the DT binding documentation to only
apply to the parallel receiver, not the CSI-2 receiver. That'd give you
more freedom going forward in case you'd later implement support for the
CSI-2 receiver, too. Up to you.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
