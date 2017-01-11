Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41328 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751954AbdAKWHe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jan 2017 17:07:34 -0500
Date: Wed, 11 Jan 2017 23:06:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] dt: bindings: Add support for CSI1 bus
Message-ID: <20170111220648.GE29366@amd>
References: <20161228183036.GA13139@amd>
 <20170103203854.gyyfzxbnnxl3flov@rob-hp-laptop>
 <20170104085420.GN3958@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vmttodhTwj0NAgWp"
Content-Disposition: inline
In-Reply-To: <20170104085420.GN3958@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--vmttodhTwj0NAgWp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Thanks for the review.
>=20
> On Tue, Jan 03, 2017 at 02:38:54PM -0600, Rob Herring wrote:
> > On Wed, Dec 28, 2016 at 07:30:36PM +0100, Pavel Machek wrote:
> > > From: Sakari Ailus <sakari.ailus@iki.fi>
> > >=20
> > > In the vast majority of cases the bus type is known to the driver(s)
> > > since a receiver or transmitter can only support a single one. There
> > > are cases however where different options are possible.
> >=20
> > What cases specifically?
>=20
> The existing V4L2 OF support tries to figure out the bus type and parse t=
he
> bus parameters based on that. This does not scale too well as there are
> multiple serial busses that share common properties.
>=20
> Some hardware also supports multiple types of busses on the same interfac=
es.

Ok, I'll include that in the changelog.

> > As in MIPI CSI2?
>=20
> Yeah, I guess it'd make sense to make this explicit.

Ok.

> > >    should be the combined length of data-lanes and clock-lanes proper=
ties.
> > > -  If the lane-polarities property is omitted, the value must be inte=
rpreted
> > > -  as 0 (normal). This property is valid for serial busses only.
> >=20
> > Why is this removed?
>=20
> Must have been by mistake. :-)

Fixed.

> > > -
> > > +- clock-inv: Clock or strobe signal inversion.
> > > +  Possible values: 0 -- not inverted; 1 -- inverted
> >=20
> > "invert" assumes I know what is normal and I do not. Define what is=20
> > "normal" and name the property the opposite of that. If normal is data=
=20
> > shifted on clock rising edge, then call the the property=20
> > "clock-shift-falling-edge" for example..
>=20
> The hardware documentation says this is the "strobe/clock inversion contr=
ol
> signal". I'm not entirely sure whether this is just signal polarity (it's=
 a
> differential signal) or inversion of an internal signal of the CCP2 block.
>=20
> It might make sense to make this a private property for the OMAP 3 ISP
> instead. If it's seen elsewhere, then think about it again. I doubt it
> would, as CCP2 is an old bus that's used on Nokia N9, N950 and N900.
>=20
> As strobe is included, I'd add that to the name. Say,
> "ti,clock-strobe-inv".

Hmm. N900 does not use inversion. Would it make sense to simply
hardcode it to "not-inverted" for now?

Device tree changes are PITA :-(.
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--vmttodhTwj0NAgWp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlh2rHgACgkQMOfwapXb+vITxwCfSenSbDT7Dide4oxVGkZF+CKS
LysAn3XHfclzgaHCHaWe6s+2BxX2FQS0
=KR7I
-----END PGP SIGNATURE-----

--vmttodhTwj0NAgWp--
