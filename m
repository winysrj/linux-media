Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EFD5C43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 13:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07430206B6
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 13:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbfAGN3c (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 08:29:32 -0500
Received: from mail.bootlin.com ([62.4.15.54]:38998 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726886AbfAGN3c (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 08:29:32 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id BBC0620746; Mon,  7 Jan 2019 14:29:29 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-29-148.w90-88.abo.wanadoo.fr [90.88.149.148])
        by mail.bootlin.com (Postfix) with ESMTPSA id 8A1C420712;
        Mon,  7 Jan 2019 14:29:29 +0100 (CET)
Date:   Mon, 7 Jan 2019 14:29:29 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Jagan Teki <jagan@amarulasolutions.com>
Cc:     Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        linux-media <linux-media@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux-amarula@amarulasolutions.com,
        Michael Trimarchi <michael@amarulasolutions.com>
Subject: Re: [PATCH v5 2/6] media: sun6i: Add mod_rate quirk
Message-ID: <20190107132929.ksyajmzn2gzr6oep@flea>
References: <20181220125438.11700-1-jagan@amarulasolutions.com>
 <20181220125438.11700-3-jagan@amarulasolutions.com>
 <20181221130025.lbvw7yvy74brf3jn@flea>
 <CAMty3ZCG5cF3tP2mid5xyS=yhtxkY+TOcGkwRkv+vrZt1=0iQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5v667uexziqiuyca"
Content-Disposition: inline
In-Reply-To: <CAMty3ZCG5cF3tP2mid5xyS=yhtxkY+TOcGkwRkv+vrZt1=0iQg@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--5v667uexziqiuyca
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 24, 2018 at 08:57:48PM +0530, Jagan Teki wrote:
> On Fri, Dec 21, 2018 at 6:30 PM Maxime Ripard <maxime.ripard@bootlin.com>=
 wrote:
> >
> > On Thu, Dec 20, 2018 at 06:24:34PM +0530, Jagan Teki wrote:
> > > Unfortunately default CSI_SCLK rate cannot work properly to
> > > drive the connected sensor interface, particularly on few
> > > Allwinner SoC's like A64.
> > >
> > > So, add mod_rate quirk via driver data so-that the respective
> > > SoC's which require to alter the default mod clock rate can assign
> > > the operating clock rate.
> > >
> > > Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
> > > ---
> > >  .../platform/sunxi/sun6i-csi/sun6i_csi.c      | 34 +++++++++++++++--=
--
> > >  1 file changed, 28 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/dri=
vers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > > index ee882b66a5ea..fe002beae09c 100644
> > > --- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > > +++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > > @@ -15,6 +15,7 @@
> > >  #include <linux/ioctl.h>
> > >  #include <linux/module.h>
> > >  #include <linux/of.h>
> > > +#include <linux/of_device.h>
> > >  #include <linux/platform_device.h>
> > >  #include <linux/pm_runtime.h>
> > >  #include <linux/regmap.h>
> > > @@ -28,8 +29,13 @@
> > >
> > >  #define MODULE_NAME  "sun6i-csi"
> > >
> > > +struct sun6i_csi_variant {
> > > +     unsigned long                   mod_rate;
> > > +};
> > > +
> > >  struct sun6i_csi_dev {
> > >       struct sun6i_csi                csi;
> > > +     const struct sun6i_csi_variant  *variant;
> > >       struct device                   *dev;
> > >
> > >       struct regmap                   *regmap;
> > > @@ -822,33 +828,43 @@ static int sun6i_csi_resource_request(struct su=
n6i_csi_dev *sdev,
> > >               return PTR_ERR(sdev->clk_mod);
> > >       }
> > >
> > > +     if (sdev->variant->mod_rate)
> > > +             clk_set_rate_exclusive(sdev->clk_mod, sdev->variant->mo=
d_rate);
> > > +
> >
> > It still doesn't make any sense to do it in the probe function...
>=20
> I'm not sure we discussed about the context wrt probe, we discussed
> about exclusive put clock.

https://lkml.org/lkml/2018/12/18/584

"Doing it here is not really optimal either, since you'll put a
constraint on the system (maintaining that clock at 300MHz), while
it's not in use."

> Since clocks were enabling in set_power and clock rate can be set
> during probe in single time instead of setting it in set_power for
> every power enablement. anything wrong with that.

See above.

Plus, a clock running draws power. It doesn't really make sense to
draw power for something that is unused.

> > We discussed this in the previous iteration already.
> >
> > What we didn't discuss is the variant function that you introduce,
> > while the previous approach was enough.
>=20
> We discussed about clk_rate_exclusive_put, and that even handle it in
> .remove right? so I have variant to handle it in sun6i_csi_remove.

We indeed discussed the clk_rate_exclusive_put. However, you chose to
implement it using a variant structure which really isn't needed.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--5v667uexziqiuyca
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXDNUOQAKCRDj7w1vZxhR
xRZxAQD5/B5s/jOZrufS8W1yFw9lVX40DlhFzemEGBkDiUx8SQEAxgnPGYhbrw0Z
uyF5vffAm1ff/2MAcEH/OPMiJIPxFQ8=
=p7sH
-----END PGP SIGNATURE-----

--5v667uexziqiuyca--
