Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35409 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753793AbdHWLei (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 07:34:38 -0400
Date: Wed, 23 Aug 2017 13:34:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
Subject: Re: [RFC 00/19] Async sub-notifiers and how to use them
Message-ID: <20170823113436.GA1767@amd>
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
 <eb0ff309-bdf5-30f9-06da-2fc6c35fbf6a@xs4all.nl>
 <20170720161400.ijud3kppizb44acw@valkosipuli.retiisi.org.uk>
 <20170721065754.GC20077@bigcity.dyn.berto.se>
 <4fa22637-c58e-79e3-be22-575b0a4ff3f9@iki.fi>
 <ea92d79c-bba0-ca22-c0a7-0535d635729c@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
In-Reply-To: <ea92d79c-bba0-ca22-c0a7-0535d635729c@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >> Is this always the case? In the R-Car VIN driver I register the video=
=20
> >> devices using video_register_device() in the complete handler. Am I=20
> >> doing things wrong in that driver? I had a patch where I moved the=20
> >> video_register_device() call to probe time but it got shoot down in=20
> >> review and was dropped.
> >=20
> > I don't think the current implementation is wrong, it's just different
> > from other drivers; there's really no requirement regarding this AFAIU.
> > It's one of the things where no attention has been paid I presume.
>=20
> It actually is a requirement: when a device node appears applications can
> reasonably expect to have a fully functioning device. True for any device
> node. You don't want to have to wait until some unspecified time before
> the full functionality is there.

Well... /dev/sdb appears, but you still get -ENOMEDIA before user
presses "Turn on USB storage" button on android phone.

So I agree it is not desirable, but it sometimes happens.

									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmdaEwACgkQMOfwapXb+vLmwACeNFx5FLufGMxi2BjokC2ydAtq
4EIAoJV7A/VCpJ6Ba2WG6s5qSC5AvxCe
=eyQc
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
