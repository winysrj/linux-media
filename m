Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:62502 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368Ab1LEPiH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2011 10:38:07 -0500
Date: Mon, 5 Dec 2011 16:38:00 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linuxtv@stefanringel.de, linux-media@vger.kernel.org,
	d.belimov@gmail.com
Subject: Re: [PATCH 3/5] tm6000: bugfix interrupt reset
Message-ID: <20111205153800.GA32512@avionic-0098.mockup.avionic-design.de>
References: <1322509580-14460-1-git-send-email-linuxtv@stefanringel.de>
 <1322509580-14460-3-git-send-email-linuxtv@stefanringel.de>
 <20111205072131.GB7341@avionic-0098.mockup.avionic-design.de>
 <4EDCB33E.8090100@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <4EDCB33E.8090100@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Mauro Carvalho Chehab wrote:
> On 05-12-2011 05:21, Thierry Reding wrote:
> >* linuxtv@stefanringel.de wrote:
> >>From: Stefan Ringel<linuxtv@stefanringel.de>
> >>
> >>Signed-off-by: Stefan Ringel<linuxtv@stefanringel.de>
> >
> >Your commit message needs more details. Why do you think this is a bugfi=
x?
> >Also this commit seems to effectively revert (and then partially reimple=
ment)
> >a patch that I posted some months ago.
>=20
> Thierry,
>=20
> I noticed this. I tested tm6000 with those changes with both the first gen
> tm5600 devices I have and HVR900H and I didn't notice any bad thing with =
this
> approach, and changing from one standard to another is now faster.
>=20
> So, I decided to apply it (with the remaining patches I've made to
> fix audio for PAL/M and NTSC/M).
>=20
> I also noticed that TM6000_QUIRK_NO_USB_DELAY is not needed anymore
> (still, Stefan's patches didn't remove it completely).
>=20
> Could you please test if the problems you've solved with your approach
> are still occurring?

Unfortunately I don't have any hardware available anymore. I will see if I
can get my hands on some of the devices, but that may take a while. I guess
you'll just have to apply without me testing them first. My comments should
be addressed anyway, though.

Thierry

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7c5VgACgkQZ+BJyKLjJp9lXQCgqGWAF0siOl4HVlU60V8bWMxT
km4AoJoX6aZ01ogEYGf8w/ogf/65DQZR
=iho8
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
