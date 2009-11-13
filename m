Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:64407 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438AbZKMU1q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 15:27:46 -0500
Received: by yxe17 with SMTP id 17so3268778yxe.33
        for <linux-media@vger.kernel.org>; Fri, 13 Nov 2009 12:27:52 -0800 (PST)
Date: Fri, 13 Nov 2009 18:27:46 -0200
From: Nicolau Werneck <nwerneck@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: new sensor for a t613 camera
Message-ID: <20091113202746.GA24318@pathfinder.pcs.usp.br>
References: <20091113193405.GA9499@pathfinder.pcs.usp.br> <62e5edd40911131204w2b8203eexc079ae46d88f1d0d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <62e5edd40911131204w2b8203eexc079ae46d88f1d0d@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 13, 2009 at 09:04:23PM +0100, Erik Andr=E9n wrote:
> 2009/11/13 Nicolau Werneck <nwerneck@gmail.com>:
> > Hello.
> >
> > I bought me a new webcam. lsusb said me it was a 17a1:0128 device, for
> > which the gspca_t613 module is available. But it did not recognize the
> > sensor number, 0x0802.
> >
> > I fiddled with the driver source code, and just made it recognize it
> > as a 0x0803 sensor, called "others" in the code, and I did get images
> > from the camera. But the colors are extremely wrong, like the contrast
> > was set to a very high number. It's probably some soft of color
> > encoding gone wrong...
> >
> > How can I start hacking this driver to try to make my camera work
> > under Linux?
> >
>=20
> If possible you could open the camera to investigate if there is
> anything printed on the sensor chip. This might give you a clue to
> what sensor it is.

Thanks for redirecting me.

I opened it (So much for the warranty seal...), but there is just=20
huge black blob of goo over the chip, as usual these days.

++nicolau

--=20
Nicolau Werneck <nwerneck@gmail.com>          1AAB 4050 1999 BDFF 4862
http://www.lti.pcs.usp.br/~nwerneck           4A33 D2B5 648B 4789 0327
Linux user #460716


--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr9wUIACgkQ0rVki0eJAycSegCfRQyYN54CNH2thIo/PHBnVaL9
avAAoMe6ihIbvX23kM1ir2sJK32q6jxm
=HI4V
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
