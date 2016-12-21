Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42012 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933692AbcLUNUx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Dec 2016 08:20:53 -0500
Date: Wed, 21 Dec 2016 14:20:49 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Rob Herring <robh@kernel.org>, ivo.g.dimitrov.75@gmail.com,
        sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mchehab@osg.samsung.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] media: et8ek8: add device tree binding documentation
Message-ID: <20161221132049.GB13449@amd>
References: <20161023191706.GA25754@amd>
 <20161030204134.hpmfrnqhd4mg563o@rob-hp-laptop>
 <20161107104648.GB5326@amd>
 <20161114183040.GB28778@amd>
 <20161220130538.GD16630@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wq9mPyueHGvFACwf"
Content-Disposition: inline
In-Reply-To: <20161220130538.GD16630@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--wq9mPyueHGvFACwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2016-12-20 15:05:39, Sakari Ailus wrote:
> Hi Pavel,
>=20
> > +Endpoint node mandatory properties
> > +----------------------------------
> > +
> > +- remote-endpoint: A phandle to the bus receiver's endpoint node.
> > +
> > +Endpoint node optional properties
> > +----------------------------------
> > +
> > +- clock-lanes: <0>
> > +- data-lanes: <1..n>
>=20
> The driver makes no use of them and CCP2 only supports a single lane. I'll
> just remove these and apply it to my tree. Let's continue discussing the
> driver patch in the other thread.

Ok, thanks!

								Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--wq9mPyueHGvFACwf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlhagbEACgkQMOfwapXb+vKWTgCfRILgBRcYTm/bCz2FfQPJY8+X
/r4AnjDZM1xrC1opcDAxBDRfr9YtSQZD
=isP0
-----END PGP SIGNATURE-----

--wq9mPyueHGvFACwf--
