Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51614 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756463Ab3E0Vxl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 May 2013 17:53:41 -0400
Message-ID: <1369691595.3469.404.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [GIT PULL] go7007 firmware updates
From: Ben Hutchings <ben@decadent.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-media <linux-media@vger.kernel.org>,
	Pete Eberlein <pete@sensoray.com>
Date: Mon, 27 May 2013 22:53:15 +0100
In-Reply-To: <201305272156.18975.hverkuil@xs4all.nl>
References: <201305231025.31812.hverkuil@xs4all.nl>
	 <1369671872.3469.383.camel@deadeye.wl.decadent.org.uk>
	 <201305272156.18975.hverkuil@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ftiRingPo2iouuWWAyR3"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-ftiRingPo2iouuWWAyR3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-05-27 at 21:56 +0200, Hans Verkuil wrote:
> On Mon May 27 2013 18:24:32 Ben Hutchings wrote:
> > On Thu, 2013-05-23 at 10:25 +0200, Hans Verkuil wrote:
> > > Hi Ben, David,
> > >=20
> > > The go7007 staging driver has been substantially overhauled for kerne=
l 3.10.
> > > As part of that process the firmware situation has been improved as w=
ell.
> > >=20
> > > While Micronas allowed the firmware to be redistributed, it was never=
 made
> > > part of linux-firmware. Only the firmwares for the Sensoray S2250 wer=
e added
> > > in the past, but those need the go7007*.bin firmwares as well to work=
.
> > >=20
> > > This pull request collects all the firmwares necessary to support all=
 the
> > > go7007 devices into the go7007 directory. With this change the go7007=
 driver
> > > will work out-of-the-box starting with kernel 3.10.
> > [...]
> >=20
> > You should not rename files like this.  linux-firmware is not versioned
> > and needs to be compatible with old and new kernel versions, so far as
> > possible.
>=20
> I understand, and I wouldn't have renamed these two firmware files if it
> wasn't for the fact that 1) it concerns a staging driver, so in my view
> backwards compatibility is not a requirement,

This driver (or set of drivers) has been requesting go7007fw.bin,
go7007tv.bin, s2250.fw and s2250_loader.fw for nearly 5 years.  It's a
bit late to say those were just temporary filenames.

> and 2) the firmware files
> currently in linux-firmware were never enough to make the Sensoray S2250
> work, you always needed additional external firmwares as well.
>=20
> > So the filenames in linux-firmware should match whatever the driver has
> > used up to now.  If the driver has been changed in 3.10-rc to use
> > different filenames, it's not too late to revert this mistake in the
> > driver.  But if such a change was made earlier, we'll need to add
> > symlinks.
>=20
> I can revert the rename action, but I would rather not do it. I believe
> there are good reasons for doing this, especially since the current
> situation is effectively broken anyway due to the missing firmware files.

Were the 'new' files unavailable to the public, or only available from a
manufacturer web site?

Ben.

> If you really don't want to rename the two S2250 files, then I'll make
> a patch reverting those to the original filename.
>=20
> Pete, if you have an opinion regarding this, please let us know. After al=
l,
> it concerns a Sensoray device.

--=20
Ben Hutchings
Experience is what causes a person to make new mistakes instead of old ones=
.

--=-ftiRingPo2iouuWWAyR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUaPVy+e/yOyVhhEJAQpONw/9FFQU83uvHQI6T5jsoWgITLLlUoEEzuKD
SJv7Y7zC7mQYAqd5q8jMhHw9rALMfr8yf8Gp7WZ2p4PnsmsBuQe9L0EZx5R7bEGL
oOM3h2Haywu0OBdcyUYmmVKCSbWwfQ70FHwB1tjfbJLkLfMzd0jVSQJlkvnmWGOl
u5s2toRiECZO8I0r4WmzM3vcPA7MrBiqsDr+LEjdlWLGgeLuetpYkpmNQ/EyKhT7
xdRBnx2TzL6d6hPBq1SctCus3UTNDVjh8sdA2m4dNlHZiIIfzxLXt7O58fG6hVQT
h6TLb2US9YccoAzrXHTWA0SpXgobruyE4m7sszodQQGfCORmjYGh+whPgfZI7qqD
CswJegchjcywK+pRsPDYA4GzDKDsV0Mruj2I3hgtZ8d2TZNN1tIIMNh2RnUeZCyb
DgSkN72t7I9MkfLBiUFcyQxFLngHlE3tiKGgiUFU5/IebNwUCHi8L2MOYVSeEa/P
vvordSSPQ9yDx2EcLblQdptgA5a8sKk1PjethQlnBo5kJ+nuMUOUfdWgPDAviD3R
tIt7FuDoC3jr7vTf2eaNcAOWHNIdntk0R65nPUnotX5ammZmDRl24tViAWcJsWaL
b5S53V7kGtT/D1DWExtgJxjslI+Nwglot9KXap0D+lxZaiU0Pi2S0duzq6XKmAHO
YoMvHnA7iW4=
=FpRo
-----END PGP SIGNATURE-----

--=-ftiRingPo2iouuWWAyR3--
