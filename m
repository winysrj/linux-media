Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns1.tyldum.com ([91.189.178.231]:38764 "EHLO ns1.tyldum.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab0DREvL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Apr 2010 00:51:11 -0400
Received: from tyldum.com (unknown [192.168.168.50])
	by ns1.tyldum.com (Postfix) with ESMTP
	for <linux-media@vger.kernel.org>; Sun, 18 Apr 2010 06:51:08 +0200 (CEST)
Date: Sun, 18 Apr 2010 06:51:07 +0200
From: Vidar Tyldum Hansen <vidar@tyldum.com>
To: linux-media@vger.kernel.org
Subject: Re: mantis crashes
Message-ID: <20100418045106.GA7741@mail.tyldum.com>
References: <20100413150153.GB11631@mail.tyldum.com>
 <87ochne35i.fsf@nemi.mork.no>
 <20100413165616.GC11631@mail.tyldum.com>
 <loom.20100414T133315-652@post.gmane.org>
 <20100417054749.GA6067@mail.tyldum.com>
 <87aat1dc9r.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <87aat1dc9r.fsf@nemi.mork.no>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 17, 2010 at 11:01:20PM +0200, Bj=F8rn Mork wrote:
> Vidar Tyldum Hansen <vidar@tyldum.com> writes:
>=20
> > Things left to try hardware-wise is to switch to a different PCI slot,
> > but I guess I'll go down the new kernel route... I'll have to do some
> > research regarding v4l versions in .31, .32 and .33 to figure out to
> > which kernel I can 'backport' mantis without replacing v4l completely.
>=20
> I attached a patch for 2.6.32 to http://bugs.debian.org/577264
>=20
> This keeps most of the existing DVB subsystem intact, only adding new
> files with the exception of the necessary one-liner in tda10021.c to
> avoid unwanted binding to tda10023.
>=20
> I based the patch on the driver in 2.6.34-rc4, but updating it with
> newer versions should be trivial.

Great. I will give that a go.
Latest development:
 * Swapped cards with known working one: same instability.
 * PSU found to be faulty, replaced. Same instability.
 * Upgraded from 2.6.31 to 2.6.32 (Ubuntu Lucid). Same instability.

So now I will revert to stock Lucid kernel and give your patch a go. But
I have a feeling this has something might be some incompatibility or bug
between the card and the motherboard (Asus P5N7A-VM). This, though is
beyond me...

--=20
       Vidar Tyldum Hansen
                                 vidar@tyldum.com               PGP: 0x3110=
AA98

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvKj7oACgkQsJJnSzEQqpiibQCfeAKKkUV+6KCKKk0/ibmDk3mZ
4u8Anik6RTmjLKAb5SlhB9AwKJ8v4FYb
=5ArX
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
