Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BE32C282CB
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 20:19:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64922218D2
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 20:19:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbfBHUTP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 15:19:15 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:35103 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbfBHUTO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 15:19:14 -0500
X-Originating-IP: 90.89.68.76
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 6C32CE0003;
        Fri,  8 Feb 2019 20:19:08 +0000 (UTC)
Date:   Fri, 8 Feb 2019 21:19:08 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media <linux-media@vger.kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Subject: Re: [PATCH v2 3/5] media: sunxi: Add A10 CSI driver
Message-ID: <20190208201908.t5easf5uurvax7re@flea>
References: <cover.ba7411f0c7155d0292b38d3dec698e26b5cc813b.1548687041.git-series.maxime.ripard@bootlin.com>
 <c1a7d46f8504decb58ff224b0b5f2f0733282cc6.1548687041.git-series.maxime.ripard@bootlin.com>
 <CAAEAJfAxWBvj6E1fJ8fy=F2xDXLHwRq7-2BT3tQqbPvbZxseyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hsnrvmpmpg5r7wb2"
Content-Disposition: inline
In-Reply-To: <CAAEAJfAxWBvj6E1fJ8fy=F2xDXLHwRq7-2BT3tQqbPvbZxseyg@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--hsnrvmpmpg5r7wb2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ezequiel,

On Wed, Feb 06, 2019 at 07:59:43PM -0300, Ezequiel Garcia wrote:
> > +       csi->isp_clk =3D devm_clk_get(&pdev->dev, "isp");
> > +       if (IS_ERR(csi->isp_clk)) {
> > +               dev_err(&pdev->dev, "Couldn't get our ISP clock\n");
> > +               return PTR_ERR(csi->isp_clk);
> > +       }
> > +
> > +       csi->mod_clk =3D devm_clk_get(&pdev->dev, "mod");
> > +       if (IS_ERR(csi->mod_clk)) {
> > +               dev_err(&pdev->dev, "Couldn't get our mod clock\n");
> > +               return PTR_ERR(csi->mod_clk);
> > +       }
> > +
> > +       csi->ram_clk =3D devm_clk_get(&pdev->dev, "ram");
> > +       if (IS_ERR(csi->ram_clk)) {
> > +               dev_err(&pdev->dev, "Couldn't get our ram clock\n");
> > +               return PTR_ERR(csi->ram_clk);
> > +       }
> > +
>=20
> Minor comment: perhaps you can take advantage
> of the clock bulk API and simplify the clock management.

Our clocks have usually very different usages for each IP (the RAM
controls the DMA side of the IP, the mod one controls the "logic" part
of it, the bus one the register, etc.) so they needed to be handled
quite differently. I'd rather stick with the current API.

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--hsnrvmpmpg5r7wb2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXF3kPAAKCRDj7w1vZxhR
xX7rAQDZ8SvZeMCDfXgbukEy4JMwmoZozb1nisAxIhaBIKTsAQD6A3Cj6WVtN5dP
uR0AiYb1Sg3joHZ9DfaysXHNhYUXvA8=
=uUw3
-----END PGP SIGNATURE-----

--hsnrvmpmpg5r7wb2--
