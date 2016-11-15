Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55236 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753133AbcKOKy2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 05:54:28 -0500
Date: Tue, 15 Nov 2016 11:54:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, ivo.g.dimitrov.75@gmail.com,
        pali.rohar@gmail.com, linux-media@vger.kernel.org,
        galak@codeaurora.org, mchehab@osg.samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161115105425.GA24212@amd>
References: <20161023200355.GA5391@amd>
 <20161023201954.GI9460@valkosipuli.retiisi.org.uk>
 <20161023203315.GC6391@amd>
 <20161031225408.GB3217@valkosipuli.retiisi.org.uk>
 <20161103224843.itxlvvotni6w6tmu@earth>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <20161103224843.itxlvvotni6w6tmu@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> On Tue, Nov 01, 2016 at 12:54:08AM +0200, Sakari Ailus wrote:
> > > > Thanks, this answered half of my questions already. ;-)
> > > :-).
> > >=20
> > > I'll have to go through the patches, et8ek8 driver is probably not
> > > enough to get useful video. platform/video-bus-switch.c is needed for
> > > camera switching, then some omap3isp patches to bind flash and
> > > autofocus into the subdevice.
> > >=20
> > > Then, device tree support on n900 can be added.
> >=20
> > I briefly discussed with with Sebastian.
> >=20
> > Do you think the elusive support for the secondary camera is worth keep=
ing
> > out the main camera from the DT in mainline? As long as there's a reaso=
nable
> > way to get it working, I'd just merge that. If someone ever gets the
> > secondary camera working properly and nicely with the video bus switch,
> > that's cool, we'll somehow deal with the problem then. But frankly I do=
n't
> > think it's very useful even if we get there: the quality is really bad.
>=20
> If we want to keep open the option to add proper support for the
> second camera, we could also add the bus switch and not add the
> front camera node in DT. Then adding the front camera does not

Now that we have ack on the device tree parts, could you merge the
et8ek8 driver (or provide review comments?)?

Yes, there are more parts missing for useful camera support on n900,
but the chip driver is neccessary part and it should be ready.

Thanks,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgq6WEACgkQMOfwapXb+vIdMACgvPUq16bHgW5kEk1lpovrgGXk
PeAAoMJCl22KEzJ/qk3WpX1qeyFHqxQp
=1lWT
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
