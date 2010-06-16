Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.tu-cottbus.de ([141.43.99.248]:42787 "EHLO
	smtp2.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757431Ab0FPNkX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jun 2010 09:40:23 -0400
Date: Wed, 16 Jun 2010 15:40:14 +0200
From: Eugeniy Meshcheryakov <eugen@debian.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Problem with em28xx card, PAL and teletext
Message-ID: <20100616134014.GA4393@localhost.localdomain>
References: <20100317145900.GA7875@localhost.localdomain>
 <829197381003170843u73743ccand32e7d0d2e6d3ca6@mail.gmail.com>
 <20100613150938.GA5483@localhost.localdomain>
 <AANLkTimgmQzy5sAh_lU_RHYj-ZD9XZavvLmgs7tSNNdZ@mail.gmail.com>
 <20100614032105.GA3456@localhost.localdomain>
 <AANLkTikSa6M2wzPz9Ro4z-hHOQXBSFvpOapRpk4fKdzX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <AANLkTikSa6M2wzPz9Ro4z-hHOQXBSFvpOapRpk4fKdzX@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Devin,

14 =D1=87=D0=B5=D1=80=D0=B2=D0=BD=D1=8F 2010 =D0=BE 10:19 -0400 Devin Heitm=
ueller =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=B2(-=D0=BB=D0=B0):
> > Thanks for the tip. It worked with 640x480. But when I tried to use
> > 720x576 I got a picture with a lot of noise made of horizontal white
> > lines. However maybe it is because of damaged USB connector...
>=20
> If you email me a screenshot (preferably off list due to the size), I
> can probably provide some additional advice.  Also please provide the
> exact mplayer command you used so I can try to reproduce it here.
The lines do not look white for me now, it is probably depends on
picture. You can see screenshots here:
http://people.debian.org/~eugen/em28xx/

I had the following in mplayer config file:
ao=3Dalsa
vo=3Dxv
framedrop=3D1
panscan=3D0
tv=3Dwidth=3D640:height=3D480:norm=3Dpal-bg:device=3D/dev/video1:tdevice=3D=
/dev/vbi0:alsa=3Dyes:adevice=3Dhw.2,0:amode=3D1:immediatemode=3D0:audiorate=
=3D48000:chanlist=3Deurope-west:channels=3D<long list of channels>
lavdopts=3Dthreads=3D2
vf=3Dyadif=3D0,screenshot=3D1

Regards,
Eugeniy Meshcheryakov

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwY1D4ACgkQKaC6+zmozOJTzQCdFfDDmskIurAsA4F9zlufYsnS
5UQAoIVHPw9pDa9YbTx5m83ngAqzL5g/
=qKg/
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
