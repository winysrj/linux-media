Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE12BC43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 10:07:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99081218A6
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 10:07:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbeLSKHv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 19 Dec 2018 05:07:51 -0500
Received: from mail.bootlin.com ([62.4.15.54]:55495 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728883AbeLSKHv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Dec 2018 05:07:51 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 3FACE207D9; Wed, 19 Dec 2018 11:07:48 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-38-38.w90-88.abo.wanadoo.fr [90.88.157.38])
        by mail.bootlin.com (Postfix) with ESMTPSA id 0D3FF20510;
        Wed, 19 Dec 2018 11:07:38 +0100 (CET)
Date:   Wed, 19 Dec 2018 11:07:38 +0100
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
Subject: Re: [PATCH v4 3/6] media: sun6i: Update default CSI_SCLK for A64
Message-ID: <20181219100738.iakvqigi7z3k2coa@flea>
References: <20181218113320.4856-1-jagan@amarulasolutions.com>
 <20181218113320.4856-4-jagan@amarulasolutions.com>
 <20181218152318.duynff7f5m2gxtv4@flea>
 <CAMty3ZCS+QT_YqbJueR-qeityaDxNbQ7p_d3D6bNATSJLQpRnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="msm72pnkaxdbd2lg"
Content-Disposition: inline
In-Reply-To: <CAMty3ZCS+QT_YqbJueR-qeityaDxNbQ7p_d3D6bNATSJLQpRnQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--msm72pnkaxdbd2lg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 18, 2018 at 09:08:17PM +0530, Jagan Teki wrote:
> On Tue, Dec 18, 2018 at 8:53 PM Maxime Ripard <maxime.ripard@bootlin.com>=
 wrote:
> >
> > On Tue, Dec 18, 2018 at 05:03:17PM +0530, Jagan Teki wrote:
> > > Unfortunately A64 CSI cannot work with default CSI_SCLK rate.
> > >
> > > A64 BSP is using 300MHz clock rate as default csi clock,
> > > so sun6i_csi require explicit change to update CSI_SCLK
> > > rate to 300MHZ for A64 SoC's.
> > >
> > > So, set the clk_mod to 300MHz only for A64.
> > >
> > > Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
> > > ---
> > >  drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/dri=
vers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > > index 9ff61896e4bb..91470edf7581 100644
> > > --- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > > +++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > > @@ -822,6 +822,11 @@ static int sun6i_csi_resource_request(struct sun=
6i_csi_dev *sdev,
> > >               return PTR_ERR(sdev->clk_mod);
> > >       }
> > >
> > > +     /* A64 require 300MHz mod clock to operate properly */
> > > +     if (of_device_is_compatible(pdev->dev.of_node,
> > > +                                 "allwinner,sun50i-a64-csi"))
> > > +             clk_set_rate_exclusive(sdev->clk_mod, 300000000);
> > > +
> >
> > If you're using clk_set_rate_exclusive, you need to put back the
> > "exclusive" reference once you're not using the clock.
> >
> > Doing it here is not really optimal either, since you'll put a
> > constraint on the system (maintaining that clock at 300MHz), while
> > it's not in use.
>=20
> I think we can handle via clk_rate_exclusive_put for those errors
> cases? If I'm not wrong

Yes, but it's not only for the error case, it's also for the inactive
case.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--msm72pnkaxdbd2lg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXBoYagAKCRDj7w1vZxhR
xVfKAP9iSZZbgJrWye5Bii8r/tVflHRJHx/oFYmX4GBqrOtZEQD/ZENWjKmxacFq
8zKvqZ2UxIsP6e4Qd/a+g58rUoTD+Ac=
=bQYa
-----END PGP SIGNATURE-----

--msm72pnkaxdbd2lg--
