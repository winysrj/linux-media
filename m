Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38865 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab2CZKKQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 06:10:16 -0400
Received: by eaaq12 with SMTP id q12so1467282eaa.19
        for <linux-media@vger.kernel.org>; Mon, 26 Mar 2012 03:10:15 -0700 (PDT)
Message-ID: <1332756606.14977.3.camel@cyclops.marienz.net>
Subject: Re: libv4l: add Lenovo Thinkpad Edge E325 to upside down devices
 table
From: Marien Zwart <marien.zwart@gmail.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Mon, 26 Mar 2012 12:10:06 +0200
In-Reply-To: <4F6F9407.5020602@googlemail.com>
References: <1332616469.3755.9.camel@cyclops.marienz.net>
	 <4F6F9407.5020602@googlemail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-PpyrIrz8BCOAZOPC5eeq"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-PpyrIrz8BCOAZOPC5eeq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On zo, 2012-03-25 at 23:54 +0200, Gregor Jasny wrote:
> I assume you're a Debian user: libv4l-0.8.6-2 got just uploaded to
> Debian Sid. In case you're on Ubuntu, the libv4l/stable PPA will pick
> up the patch with the next nightly build.
>=20
> It would be great if you could test the updated package.

I can confirm libv4l-0 and libv4lconvert0 from Debian testing (0.8.6-1)
give me an upside-down image in cheese, which is fixed by installing
libv4l-0 and libv4lconvert0 from unstable (0.8.6-2) on my testing
system.

Thanks for fixing this so quickly!

--=20
Marien.

--=-PpyrIrz8BCOAZOPC5eeq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk9wQIQACgkQUElL7eJpfESB1wCffjO1yfhIVoedl7+IpLcxa8nl
jwUAnjEtb8AxIT/yBRIrNrkL3G7i5V+F
=br65
-----END PGP SIGNATURE-----

--=-PpyrIrz8BCOAZOPC5eeq--

