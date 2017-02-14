Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44770 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbdBNWhw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 17:37:52 -0500
Date: Tue, 14 Feb 2017 23:37:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: [RFC 03/13] v4l: split lane parsing code
Message-ID: <20170214223748.GD11317@amd>
References: <20170214133941.GA8469@amd>
 <20170214212927.GL16975@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OaZoDhBhXzo6bW1J"
Content-Disposition: inline
In-Reply-To: <20170214212927.GL16975@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--OaZoDhBhXzo6bW1J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> On Tue, Feb 14, 2017 at 02:39:41PM +0100, Pavel Machek wrote:
> > From: Sakari Ailus <sakari.ailus@iki.fi>
> >=20
> > The function to parse CSI2 bus parameters was called
> > v4l2_of_parse_csi_bus(), rename it as v4l2_of_parse_csi2_bus() in
> > anticipation of CSI1/CCP2 support.
> >=20
> > Obtain data bus type from bus-type property. Only try parsing bus
> > specific properties in this case.
> >=20
> > Separate lane parsing from CSI-2 bus parameter parsing. The CSI-1 will
> > need these as well, separate them into a different
> > function. have_clk_lane and num_data_lanes arguments may be NULL; the
> > CSI-1 bus will have no use for them.
> >=20
> > Add support for parsing of CSI-1 and CCP2 bus related properties
> > documented in video-interfaces.txt.
>=20
> One more thing: this conflicts badly with the V4L2 fwnode patchset.
>=20
> Assuming things go well and that can be merged somewhat soonish, can I ta=
ke
> this and rebase it on the fwnode set? The two first patches in the set lo=
ok
> pretty good to me.

Actually, I'd say that first four patches should be ready. Feel free
to take them/rebase them/etc. I can then continue working on the
rest....

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--OaZoDhBhXzo6bW1J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlijhrwACgkQMOfwapXb+vJDVACfTzTUGeibgRF+HtEIYIl7MkZL
fe4AoLUzo7taR/pySz+01ICR0zUgmFHt
=aeHL
-----END PGP SIGNATURE-----

--OaZoDhBhXzo6bW1J--
