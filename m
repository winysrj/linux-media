Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35649 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729089AbeI1Re3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Sep 2018 13:34:29 -0400
MIME-Version: 1.0
References: <1537951204-24672-1-git-send-email-yong.deng@magewell.com>
 <20180928093833.gwmskm2jvby6x4s6@paasikivi.fi.intel.com> <14114604.4rraf0qJLU@avalon>
 <20180928102345.r2g342tg5mgcwfw6@paasikivi.fi.intel.com>
In-Reply-To: <20180928102345.r2g342tg5mgcwfw6@paasikivi.fi.intel.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Fri, 28 Sep 2018 19:10:58 +0800
Message-ID: <CAGb2v65YpPRHb5YiGJhC8NX5F5i3+1rW5y6Dq5L+pNN3U_uLdQ@mail.gmail.com>
Subject: Re: [PATCH v11 1/2] dt-bindings: media: Add Allwinner V3s Camera
 Sensor Interface (CSI)
To: Sakari Ailus <sakari.ailus@linux.intel.com>
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 28, 2018 at 6:23 PM Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
>
> Hi Laurent,
>
> On Fri, Sep 28, 2018 at 12:45:12PM +0300, Laurent Pinchart wrote:
> > Hi Sakari,
> >
> > On Friday, 28 September 2018 12:38:33 EEST Sakari Ailus wrote:
> > > On Wed, Sep 26, 2018 at 04:40:04PM +0800, Yong Deng wrote:
> > > > Add binding documentation for Allwinner V3s CSI.
> > > >
> > > > Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > > > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > >
> > > I know... but I have a few more comments.
> > >
> > > > Reviewed-by: Rob Herring <robh@kernel.org>
> > > > Signed-off-by: Yong Deng <yong.deng@magewell.com>
> > > > ---
> > > >
> > > >  .../devicetree/bindings/media/sun6i-csi.txt        | 59 +++++++++++++++++
> > > >  1 file changed, 59 insertions(+)
> > > >  create mode 100644 Documentation/devicetree/bindings/media/sun6i-csi.txt
> > > >
> > > > diff --git a/Documentation/devicetree/bindings/media/sun6i-csi.txt
> > > > b/Documentation/devicetree/bindings/media/sun6i-csi.txt new file mode
> > > > 100644
> > > > index 000000000000..2ff47a9507a6
> > > > --- /dev/null
> > > > +++ b/Documentation/devicetree/bindings/media/sun6i-csi.txt
> > > > @@ -0,0 +1,59 @@
> > > > +Allwinner V3s Camera Sensor Interface
> > > > +-------------------------------------
> > > > +
> > > > +Allwinner V3s SoC features two CSI module. CSI0 is used for MIPI CSI-2
> > > > +interface and CSI1 is used for parallel interface.
> > > > +
> > > > +Required properties:
> > > > +  - compatible: value must be "allwinner,sun8i-v3s-csi"
> > > > +  - reg: base address and size of the memory-mapped region.
> > > > +  - interrupts: interrupt associated to this IP
> > > > +  - clocks: phandles to the clocks feeding the CSI
> > > > +    * bus: the CSI interface clock
> > > > +    * mod: the CSI module clock
> > > > +    * ram: the CSI DRAM clock
> > > > +  - clock-names: the clock names mentioned above
> > > > +  - resets: phandles to the reset line driving the CSI
> > > > +
> > > > +Each CSI node should contain one 'port' child node with one child
> > > > 'endpoint' +node, according to the bindings defined in
> > > > +Documentation/devicetree/bindings/media/video-interfaces.txt. As
> > > > mentioned
> > > > +above, the endpoint's bus type should be MIPI CSI-2 for CSI0 and parallel
> > > > or +Bt656 for CSI1.
> > >
> > > Which port represents CSI0 and which one is CSI1? That needs to be
> > > documented.
> >
> > There are two CSI devices, named CSI0 and CSI1, with one port each. The CSI0
> > device supports CSI-2 only, and the CSI1 device parallel (BT.601 or BT.656)
> > only.
> >
> > > > +
> > > > +Endpoint node properties for CSI1
> > >
> > > How about CSI0? I'd expect at least data-lanes, and clock-lanes as well if
> > > the hardware supports lane mapping.
> >
> > I enquired about that too. As far as I understand, CSI0 isn't supported yet in
> > the driver due to lack of documentation and lack of open-source vendor-
> > provided source code. While DT bindings are not tied to driver
> > implementations, it's not the best idea to design DT bindings without at least
> > one working implementation to test them. I thus proposed just listing CSI0 as
> > being unsupported for now.
>
> Ack.
>
> We should still define which receiver corresponds to a given port. Probably
> 1 for CSI1 would make sense, in order to avoid changing the order the
> hardware already uses. 0 doesn't need to be documented no IMO.
>
> What do you think?

AFAICT it would be a completely seperate node, since they have different address
spaces, clocks and reset controls. So there's no possibility of confusion.

According to Yong, CSI0 is tied internally to some unknown MIPI CSI2-receiver,
which is the undocumented part. CSI1 has its parallel data pins exposed to the
outside.

ChenYu

> >
> > > > +---------------------------------
> > > > +
> > > > +- remote-endpoint        : (required) a phandle to the bus receiver's endpoint
> > > > +                    node
> > > > +- bus-width:             : (required) must be 8, 10, 12 or 16
> > > > +- pclk-sample            : (optional) (default: sample on falling edge)
> > >
> > > Could you add that video-interfaces.txt contains documentation of these
> > > properties as well? There's a reference above but only discusses port and
> > > endpoint nodes.
> > >
> > > > +- hsync-active           : (only required for parallel)
> > > > +- vsync-active           : (only required for parallel)
> > >
> > > As you support both Bt656 and parallel (with sync signals), you can detect
> > > the interface type from the presence of these properties. I think you
> > > should also say that these properties are not allowed on Bt656. So I'd
> > > change this to e.g.
> > >
> > >     (required; parallel-only)
> > >
> > > > +
> > > > +Example:
> > > > +
> > > > +csi1: csi@1cb4000 {
> > > > + compatible = "allwinner,sun8i-v3s-csi";
> > > > + reg = <0x01cb4000 0x1000>;
> > > > + interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
> > > > + clocks = <&ccu CLK_BUS_CSI>,
> > > > +          <&ccu CLK_CSI1_SCLK>,
> > > > +          <&ccu CLK_DRAM_CSI>;
> > > > + clock-names = "bus", "mod", "ram";
> > > > + resets = <&ccu RST_BUS_CSI>;
> > > > +
> > > > + port {
> > > > +         /* Parallel bus endpoint */
> > > > +         csi1_ep: endpoint {
> > > > +                 remote-endpoint = <&adv7611_ep>;
> > > > +                 bus-width = <16>;
> > > > +
> > > > +                 /* If hsync-active/vsync-active are missing,
> > > > +                    embedded BT.656 sync is used */
> > > > +                 hsync-active = <0>; /* Active low */
> > > > +                 vsync-active = <0>; /* Active low */
> > > > +                 pclk-sample = <1>;  /* Rising */
> > > > +         };
> > > > + };
> > > > +};
>
> --
> Terveisin,
>
> Sakari Ailus
> sakari.ailus@linux.intel.com
