Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40615 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754806AbdAKVjC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jan 2017 16:39:02 -0500
Date: Wed, 11 Jan 2017 22:38:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: robh+dt@kernel.org, devicetree@vger.kernel.org,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] dt: bindings: Add support for CSI1 bus
Message-ID: <20170111213858.GD29366@amd>
References: <20161228183036.GA13139@amd>
 <20170102070010.GD3958@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="g7w8+K/95kPelPD2"
Content-Disposition: inline
In-Reply-To: <20170102070010.GD3958@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--g7w8+K/95kPelPD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2017-01-02 09:00:10, Sakari Ailus wrote:
> Hi Pavel,
>=20
> On Wed, Dec 28, 2016 at 07:30:36PM +0100, Pavel Machek wrote:
> > From: Sakari Ailus <sakari.ailus@iki.fi>
> >=20
> > In the vast majority of cases the bus type is known to the driver(s)
> > since a receiver or transmitter can only support a single one. There
> > are cases however where different options are possible.
> >=20
> > Document the CSI1/CCP2 properties strobe_clk_inv and strobe_clock
> > properties. The former tells whether the strobe/clock signal is
> > inverted, while the latter signifies the clock or strobe mode.
> >=20
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> >=20
> > diff --git a/Documentation/devicetree/bindings/media/video-interfaces.t=
xt b/Documentation/devicetree/bindings/media/video-interfaces.txt
> > index 9cd2a36..f0523f7 100644
> > --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> > +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> > @@ -76,6 +76,10 @@ Optional endpoint properties
> >    mode horizontal and vertical synchronization signals are provided to=
 the
> >    slave device (data source) by the master device (data sink). In the =
master
> >    mode the data source device is also the source of the synchronizatio=
n signals.
> > +- bus-type: data bus type. Possible values are:
> > +  0 - CSI2
> > +  1 - parallel / Bt656
> > +  2 - CCP2
>=20
> I wonder if we should make a difference between CCP2 and CSI-1 here, as it
> may make a difference in hardware configuration. The next patch does
> recognise that difference, so it should be present here as well.
>=20
> Perhaps 2 - CSI1; 3 - CCP2. What do you think?

Me, think..? Nah. :-).

Well, you have way more experience here, and yes, based on future
patches, this makes sense.

Thanks,								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--g7w8+K/95kPelPD2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlh2pfIACgkQMOfwapXb+vIclQCfU5jBTPstk0WSe44OL+H9vTnV
J6IAn2sIDRE1as3/Mgz+Xa1gNOK7uLh7
=QBIu
-----END PGP SIGNATURE-----

--g7w8+K/95kPelPD2--
