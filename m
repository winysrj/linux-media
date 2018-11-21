Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:41320 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbeKUU0j (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Nov 2018 15:26:39 -0500
Date: Wed, 21 Nov 2018 10:52:40 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Witos <kwitos@cadence.com>,
        Rafal Ciepiela <rafalc@cadence.com>
Subject: Re: [PATCH v2 3/9] phy: Add MIPI D-PHY configuration options
Message-ID: <20181121095240.peq5tpzokdakxvwc@flea>
References: <cover.c2c2ae47383b9dbbdee6b69cafdd7391c06dde4f.1541516029.git-series.maxime.ripard@bootlin.com>
 <b1f6e4c1c3487e1f048cce699a86bcf50f7fed69.1541516029.git-series.maxime.ripard@bootlin.com>
 <20181119135833.zvgxsl7kwmfewdoa@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vwkt7chllgo34h63"
Content-Disposition: inline
In-Reply-To: <20181119135833.zvgxsl7kwmfewdoa@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--vwkt7chllgo34h63
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

On Mon, Nov 19, 2018 at 03:58:34PM +0200, Sakari Ailus wrote:
> > +	/**
> > +	 * @clk_pre:
> > +	 *
> > +	 * Time, in nanoseconds, that the HS clock shall be driven by
> > +	 * the transmitter prior to any associated Data Lane beginning
> > +	 * the transition from LP to HS mode.
> > +	 */
> > +	unsigned int		clk_pre;
>=20
> Is the unit of clk_pre intended to be UI or ns?

You're right, it's in UI.

> How about adding information on the limits of these values as well?

I usually feel like the more you duplicate informations, the higher
the chances are to do a mistake and that becomes a burden to maintain
over time, but if you feel like it would be best, i'll do it.

> > +	/**
> > +	 * @lanes:
> > +	 *
> > +	 * Number of lanes used for the transmissions.
> > +	 */
> > +	unsigned char		lanes;
>=20
> This is related to the data_lanes DT property. I assume this is intended =
to
> be the number of active lanes. And presumably the first "lanes" number of
> lanes would be used in that case?

I'm not sure I got your question, sorry. But yes, this is the number
of active lanes. In the v4l2 world, chances are that this is going to
come from the data lanes property, in DRM this is coming from the
panel structure.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--vwkt7chllgo34h63
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCW/Uq6AAKCRDj7w1vZxhR
xVPxAP0aeJOfK2+BWeGCftr3BEqDDqZqB3A9bhjx1Yxrs963pAEAs422zVoXxqjD
126zBfFfjbcaQi+PPQhb528W62R8zAk=
=ffej
-----END PGP SIGNATURE-----

--vwkt7chllgo34h63--
