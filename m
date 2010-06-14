Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.tu-cottbus.de ([141.43.99.248]:55113 "EHLO
	smtp2.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab0FNDVN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jun 2010 23:21:13 -0400
Date: Mon, 14 Jun 2010 05:21:05 +0200
From: Eugeniy Meshcheryakov <eugen@debian.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Problem with em28xx card, PAL and teletext
Message-ID: <20100614032105.GA3456@localhost.localdomain>
References: <20100317145900.GA7875@localhost.localdomain>
 <829197381003170843u73743ccand32e7d0d2e6d3ca6@mail.gmail.com>
 <20100613150938.GA5483@localhost.localdomain>
 <AANLkTimgmQzy5sAh_lU_RHYj-ZD9XZavvLmgs7tSNNdZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <AANLkTimgmQzy5sAh_lU_RHYj-ZD9XZavvLmgs7tSNNdZ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

13 =D1=87=D0=B5=D1=80=D0=B2=D0=BD=D1=8F 2010 =D0=BE 15:46 -0400 Devin Heitm=
ueller =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=B2(-=D0=BB=D0=B0):
> I finally found a couple of hours to debug this issue.  Please try the
> attached patch and report back whether it addresses the problem you
> were seeing with the fields shifting left/right.
Thanks, that patch fixes the shifting problem, all the pixels are in the
right place.

> Regarding the green lines at the bottom, this is an artifact of the
> VBI changes, resulting from the fact that there is some important VBI
> content inside of the Active Video area (line 23 WSS in particular),
> and the chip cannot handle providing it both in YUYV format for the
> video area as well as in 8 bit greyscale for the VBI.  As a result, we
> had to drop the lines from the video area.
>=20
> What probably needs to happen is I will need to change the driver to
> inject black lines into each field to make up for the two lines per
> field we're not sending in the video area.
Anything that makes the picture centered will be great.

> In the meantime though,
> you can work around the issue by cropping out the lines with the
> following command:
>=20
> /usr/bin/mplayer -vo xv,x11 tv:// -tv
> driver=3Dv4l2:device=3D/dev/video0:norm=3DPAL:width=3D720:height=3D576:in=
put=3D1
> -vf crop=3D720:572:0:0
Thanks for the tip. It worked with 640x480. But when I tried to use
720x576 I got a picture with a lot of noise made of horizontal white
lines. However maybe it is because of damaged USB connector...

Also teletext is still unreadable (both with 640x480 and 720x576). Does
mplayer support teletext correctly? And can it work with resolution
640x480?

Regards,
Eugeniy Meshcheryakov

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwVoCEACgkQKaC6+zmozOKgGACeJ467nriD4ckC1OYLjpR1oaKr
0H0An2HuRkQmGGYwwMcOLNfsRhjx1Vb4
=BlAO
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
