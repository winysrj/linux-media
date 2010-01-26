Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f224.google.com ([209.85.217.224]:34153 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab0AZRA5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2010 12:00:57 -0500
Received: by gxk24 with SMTP id 24so5927486gxk.1
        for <linux-media@vger.kernel.org>; Tue, 26 Jan 2010 09:00:56 -0800 (PST)
Date: Tue, 26 Jan 2010 15:00:53 -0200
From: Nicolau Werneck <nwerneck@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Setting up the exposure time of a webcam
Message-ID: <20100126170053.GA5995@pathfinder.pcs.usp.br>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello. I have this very cheap webcam that I sent a patch to support on
gspca the other day. The specific driver is the t613.

I changed the lens of this camera, and now my images are all too
bright, what I believe is due to the much larger aperture of this new
lens. So I would like to try setting up a smaller exposure time on the
camera (I would like to do that for other reasons too).

The problem is there's no "exposure" option to be set when I call
programs such as v4lctl. Does that mean there is definitely no way for
me to control the exposure time? The hardware itself was not designed
to allow me do that? Or is there still a chance I can create some C
program that might do it, for example?

It looks like the camera has some kind of automatic exposure control. If
I cover the lens, and then uncover it quickly, the image is all white
at first, and then it gradually becomes darker. Should that give me
some hope of being able to control the exposure, or is it common for
cheaper cameras to have just an automatic exposure control that cannot
be overrun?

Thanks,
  ++nicolau





--=20
Nicolau Werneck <nwerneck@gmail.com>          1AAB 4050 1999 BDFF 4862
http://www.lti.pcs.usp.br/~nwerneck           4A33 D2B5 648B 4789 0327
Linux user #460716


--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAktfH8UACgkQ0rVki0eJAyd1CgCgzLmTVJTlTuZgGO1YL259GaGs
6KMAoM02WyxTQgO9Oo1eiLvVRK6U9Lcy
=VAZz
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
