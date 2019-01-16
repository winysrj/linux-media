Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=DATE_IN_PAST_06_12,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B11CC43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 19:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55F0320866
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 19:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730648AbfAPTSM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 14:18:12 -0500
Received: from mail.bootlin.com ([62.4.15.54]:43668 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730600AbfAPTSL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 14:18:11 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 69B98209BC; Wed, 16 Jan 2019 20:18:08 +0100 (CET)
Received: from localhost (unknown [212.81.177.10])
        by mail.bootlin.com (Postfix) with ESMTPSA id 072E6207B0;
        Wed, 16 Jan 2019 20:17:57 +0100 (CET)
Date:   Wed, 16 Jan 2019 12:11:09 +0100
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
Message-ID: <20190116111109.dkc4zgsz6lcjlzs5@flea>
References: <20181220125438.11700-1-jagan@amarulasolutions.com>
 <20181220125438.11700-3-jagan@amarulasolutions.com>
 <20181221130025.lbvw7yvy74brf3jn@flea>
 <CAMty3ZCG5cF3tP2mid5xyS=yhtxkY+TOcGkwRkv+vrZt1=0iQg@mail.gmail.com>
 <20190107132929.ksyajmzn2gzr6oep@flea>
 <CAMty3ZAx9MthB0M-eFmsZv9CxF3Z1BkFTU6Hw=ZT5wu6aJwjGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tme5liorzp5mnfdf"
Content-Disposition: inline
In-Reply-To: <CAMty3ZAx9MthB0M-eFmsZv9CxF3Z1BkFTU6Hw=ZT5wu6aJwjGQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--tme5liorzp5mnfdf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 11, 2019 at 11:54:12AM +0530, Jagan Teki wrote:
> On Mon, Jan 7, 2019 at 6:59 PM Maxime Ripard <maxime.ripard@bootlin.com> =
wrote:
> > On Mon, Dec 24, 2018 at 08:57:48PM +0530, Jagan Teki wrote:
> > > On Fri, Dec 21, 2018 at 6:30 PM Maxime Ripard <maxime.ripard@bootlin.=
com> wrote:
> > > >
> > > > On Thu, Dec 20, 2018 at 06:24:34PM +0530, Jagan Teki wrote:
> > > > > Unfortunately default CSI_SCLK rate cannot work properly to
> > > > > drive the connected sensor interface, particularly on few
> > > > > Allwinner SoC's like A64.
> > > > >
> > > > > So, add mod_rate quirk via driver data so-that the respective
> > > > > SoC's which require to alter the default mod clock rate can assign
> > > > > the operating clock rate.
> > > > >
> > > > > Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
> > > > > ---
> > > > >  .../platform/sunxi/sun6i-csi/sun6i_csi.c      | 34 +++++++++++++=
++----
> > > > >  1 file changed, 28 insertions(+), 6 deletions(-)
> > > > >
> > > > > diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b=
/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > > > > index ee882b66a5ea..fe002beae09c 100644
> > > > > --- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > > > > +++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > > > > @@ -15,6 +15,7 @@
> > > > >  #include <linux/ioctl.h>
> > > > >  #include <linux/module.h>
> > > > >  #include <linux/of.h>
> > > > > +#include <linux/of_device.h>
> > > > >  #include <linux/platform_device.h>
> > > > >  #include <linux/pm_runtime.h>
> > > > >  #include <linux/regmap.h>
> > > > > @@ -28,8 +29,13 @@
> > > > >
> > > > >  #define MODULE_NAME  "sun6i-csi"
> > > > >
> > > > > +struct sun6i_csi_variant {
> > > > > +     unsigned long                   mod_rate;
> > > > > +};
> > > > > +
> > > > >  struct sun6i_csi_dev {
> > > > >       struct sun6i_csi                csi;
> > > > > +     const struct sun6i_csi_variant  *variant;
> > > > >       struct device                   *dev;
> > > > >
> > > > >       struct regmap                   *regmap;
> > > > > @@ -822,33 +828,43 @@ static int sun6i_csi_resource_request(struc=
t sun6i_csi_dev *sdev,
> > > > >               return PTR_ERR(sdev->clk_mod);
> > > > >       }
> > > > >
> > > > > +     if (sdev->variant->mod_rate)
> > > > > +             clk_set_rate_exclusive(sdev->clk_mod, sdev->variant=
->mod_rate);
> > > > > +
> > > >
> > > > It still doesn't make any sense to do it in the probe function...
> > >
> > > I'm not sure we discussed about the context wrt probe, we discussed
> > > about exclusive put clock.
> >
> > https://lkml.org/lkml/2018/12/18/584
> >
> > "Doing it here is not really optimal either, since you'll put a
> > constraint on the system (maintaining that clock at 300MHz), while
> > it's not in use."
>=20
> But this constraint is only set, for SoC's who need mod_rate change
> not for whole SoCs.

Still, that constraint is there for the whole system on affected
SoCs. Whether it applies to one SoC or not is not really relevant.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--tme5liorzp5mnfdf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXD8RTQAKCRDj7w1vZxhR
xT6tAP9ZNf6d/5D7t2bcICJ3jps6qwA+vv4bM33AM2BI06aZLAD+KZ2PMgd+ZQfT
8/d8btb5HBoo3QhQK+Rj9Zp4LlU5fQc=
=xBGo
-----END PGP SIGNATURE-----

--tme5liorzp5mnfdf--
