Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51075 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751290Ab3E0QY6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 May 2013 12:24:58 -0400
Message-ID: <1369671872.3469.383.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [GIT PULL] go7007 firmware updates
From: Ben Hutchings <ben@decadent.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-media <linux-media@vger.kernel.org>,
	Pete Eberlein <pete@sensoray.com>
Date: Mon, 27 May 2013 17:24:32 +0100
In-Reply-To: <201305231025.31812.hverkuil@xs4all.nl>
References: <201305231025.31812.hverkuil@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-F5uJdJTpI3LrHDYl44r2"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-F5uJdJTpI3LrHDYl44r2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-05-23 at 10:25 +0200, Hans Verkuil wrote:
> Hi Ben, David,
>=20
> The go7007 staging driver has been substantially overhauled for kernel 3.=
10.
> As part of that process the firmware situation has been improved as well.
>=20
> While Micronas allowed the firmware to be redistributed, it was never mad=
e
> part of linux-firmware. Only the firmwares for the Sensoray S2250 were ad=
ded
> in the past, but those need the go7007*.bin firmwares as well to work.
>=20
> This pull request collects all the firmwares necessary to support all the
> go7007 devices into the go7007 directory. With this change the go7007 dri=
ver
> will work out-of-the-box starting with kernel 3.10.
[...]

You should not rename files like this.  linux-firmware is not versioned
and needs to be compatible with old and new kernel versions, so far as
possible.

So the filenames in linux-firmware should match whatever the driver has
used up to now.  If the driver has been changed in 3.10-rc to use
different filenames, it's not too late to revert this mistake in the
driver.  But if such a change was made earlier, we'll need to add
symlinks.

Ben.

--=20
Ben Hutchings
Experience is what causes a person to make new mistakes instead of old ones=
.

--=-F5uJdJTpI3LrHDYl44r2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUaOIwOe/yOyVhhEJAQp30RAAgXFjQ2FyPdi3Zf5Psy55FIPf2otIgeXh
roEwCbvfL6IEWtKzT85zVJcEsCFg4OXgK57PpMmupGcgatExPahZIY0tNQPVDRI5
ZZhQv2kebYOY7lRd1TT2jTcS8rsCNHHz0lXrK4Pem2jAyIBIm25Bho6XzBVSTQAz
SUisobIwUVt9lmEZt8cDbaFE8kS2LOH+UDixDhI+T5LB0SkgHEs9QIUZuR7MlTNn
pBSeKcC6lJrUaCwoXPm8snkjwSylVTTAM7F86thbJNzbw3+5vJvLMjr4PpAt0+Di
5CxnnDseOMYUXheXZ9CKXF5D2J3fpbrp2n+S2EsYyj6W7UnSA4XjfWh9D0StGpZq
PMdvF4A8Dl9b+2aq9hMX5eqwhrKP3ah1gv8DTUPRElKclDdZN+PEKdXU4zqNlF82
0qPbbA/6qYP8z9fg6Qt4yjtcEpIbxdSMA2cnqwOqL0o74yJdTtaCY1tIrnxG6gmK
x3XFd/BCua42m5vJPzhr0LkAa6vqMIdEzw+ztPJa7+3llU/r/I3OTsAmifAlSwKY
hqacMoaCGpLyxCpvVYBSNhOTatZpUXwOo91c5/HrAgtk65G0WW/XmXMw1C1sjTyQ
cWzP0pKYxX4vPqhdH8qF5huHZrRiHpgENWSYpe5YkRsCeCDbiy00d8BVG9AR4L+Q
L0l5UzpCfPQ=
=2b6p
-----END PGP SIGNATURE-----

--=-F5uJdJTpI3LrHDYl44r2--
