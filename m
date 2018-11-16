Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:54117 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390028AbeKQCwx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Nov 2018 21:52:53 -0500
Date: Fri, 16 Nov 2018 17:39:35 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-sunxi@googlegroups.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH 08/15] ARM/arm64: sunxi: Move H3/H5 syscon label over to
 soc-specific nodes
Message-ID: <20181116163935.b4wsf3sfi4arwrtz@flea>
References: <20181115145013.3378-1-paul.kocialkowski@bootlin.com>
 <20181115145013.3378-9-paul.kocialkowski@bootlin.com>
 <20181116093904.4ikn7ldksrm3mp5d@flea>
 <CAGb2v65EckX0CDbZ5K9VmmayOe3eisOYgUxmPomPgp2_jE5Vww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGb2v65EckX0CDbZ5K9VmmayOe3eisOYgUxmPomPgp2_jE5Vww@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Fri, Nov 16, 2018 at 05:47:50PM +0800, Chen-Yu Tsai wrote:
> On Fri, Nov 16, 2018 at 5:39 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> >
> > On Thu, Nov 15, 2018 at 03:50:06PM +0100, Paul Kocialkowski wrote:
> > > Now that we have specific nodes for the H3 and H5 system-controller
> > > that allow proper access to the EMAC clock configuration register,
> > > we no longer need a common dummy syscon node.
> > >
> > > Switch the syscon label over to each platform's dtsi file.
> > >
> > > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > > ---
> > >  arch/arm/boot/dts/sun8i-h3.dtsi              | 2 +-
> > >  arch/arm/boot/dts/sunxi-h3-h5.dtsi           | 6 ------
> > >  arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi | 2 +-
> > >  3 files changed, 2 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/arch/arm/boot/dts/sun8i-h3.dtsi b/arch/arm/boot/dts/sun8i-h3.dtsi
> > > index 7157d954fb8c..b337a9282783 100644
> > > --- a/arch/arm/boot/dts/sun8i-h3.dtsi
> > > +++ b/arch/arm/boot/dts/sun8i-h3.dtsi
> > > @@ -134,7 +134,7 @@
> > >       };
> > >
> > >       soc {
> > > -             system-control@1c00000 {
> > > +             syscon: system-control@1c00000 {
> > >                       compatible = "allwinner,sun8i-h3-system-control";
> > >                       reg = <0x01c00000 0x1000>;
> > >                       #address-cells = <1>;
> > > diff --git a/arch/arm/boot/dts/sunxi-h3-h5.dtsi b/arch/arm/boot/dts/sunxi-h3-h5.dtsi
> > > index 4b1530ebe427..9175ff0fb59a 100644
> > > --- a/arch/arm/boot/dts/sunxi-h3-h5.dtsi
> > > +++ b/arch/arm/boot/dts/sunxi-h3-h5.dtsi
> > > @@ -152,12 +152,6 @@
> > >                       };
> > >               };
> > >
> > > -             syscon: syscon@1c00000 {
> > > -                     compatible = "allwinner,sun8i-h3-system-controller",
> > > -                             "syscon";
> > > -                     reg = <0x01c00000 0x1000>;
> > > -             };
> > > -
> >
> > You're also dropping the syscon compatible there. But I'm not sure how
> > it could work with the H3 EMAC driver that would overwrite the
> > compatible already.
> 
> I assume you are referring to the previous patch? The node names are not
> the same, hence the previous patch is adding another node for the system
> controller, and this patch removes the old one with the "syscon" compatible.
> 
> We already patched the EMAC driver to support the new SRAM controller based
> regmap, so other than making people unhappy about having to update their
> DT, I don't think there would be any problems. This also means H3 in -next
> currently has _two_ syscon nodes.

Ah, indeed, I missed that. Pointing that out in the commit log could
be nice though.

Thanks!
Maxime

-- 
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
