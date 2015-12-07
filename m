Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45471 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754574AbbLGCS6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Dec 2015 21:18:58 -0500
Message-ID: <1449454726.2824.64.camel@decadent.org.uk>
Subject: Re: [PATCH 2/4] WHENCE: use https://linuxtv.org for LinuxTV URLs
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	David Woodhouse <dwmw2@infradead.org>
Date: Mon, 07 Dec 2015 02:18:46 +0000
In-Reply-To: <e9a73f67222e49579154d3b8cb3ae71aa7898d94.1449232861.git.mchehab@osg.samsung.com>
References: <a825eaec8d62f2679880fc1679622da9d77820a9.1449232861.git.mchehab@osg.samsung.com>
	 <e9a73f67222e49579154d3b8cb3ae71aa7898d94.1449232861.git.mchehab@osg.samsung.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-HHEbzAYwl/n0HrEXisct"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-HHEbzAYwl/n0HrEXisct
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-12-04 at 10:46 -0200, Mauro Carvalho Chehab wrote:
> While https was always supported on linuxtv.org, only in
> Dec 3 2015 the website is using valid certificates.
>=20
> As we're planning to drop pure http support on some
> future, change the http://linuxtv.org references at firmware/WHENCE
> file to point to https://linuxtv.org instead.

I've made the corresponding change in the linux-firmware.git
repository. =C2=A0I don't know who, if anyone, maintains the firmware
subdirectory now.

Ben.

> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
> =C2=A0firmware/WHENCE | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/firmware/WHENCE b/firmware/WHENCE
> index 0c4d96dee9b6..de6f22e008f1 100644
> --- a/firmware/WHENCE
> +++ b/firmware/WHENCE
> @@ -677,7 +677,7 @@ File: av7110/bootcode.bin
> =C2=A0
> =C2=A0Licence: GPLv2 or later
> =C2=A0
> -ARM assembly source code available at http://www.linuxtv.org/downloads/f=
irmware/Boot.S
> +ARM assembly source code available at https://linuxtv.org/downloads/firm=
ware/Boot.S
> =C2=A0
> =C2=A0-------------------------------------------------------------------=
-------
> =C2=A0
--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers
--=-HHEbzAYwl/n0HrEXisct
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAVmTshue/yOyVhhEJAQqIRA/+KsKtJiBYOEvQeK0xStND/EdR3oYDqfJw
crePOAo5lVYUDF4IlmnkVl3u0/ApzhKOiGTjQgDW/iljNQHPMJoYL5ee7LYuUFF5
5bchcki27tMicn/ZgJjTXSBks3HUVuJ8/n0wNWJu6/hLu/OYvolxBFVB0f2yrthq
Jf1/UFfq/hACmXhsPaHQYXXadhiDvSC8bXdB9CPlfzlsN7wuL0asJpl84YEJLOKF
O7iZ2AdlWvx71y/413wlK79Ne74Z22TtNL8p8i5BVlotX3CXUctn+PzXapo5TAwd
YePyY0Wcls2vL6m6/I7AqgJiqnwWjEqpfqbYMkmRSKZYcfnwQudDgzV7uwCIY4u0
yb3dsvrZb0dV+tEk5SRAgy038n0OQXOsq5arE2m8lTtE2wjpQDYDUKLXA10BYq9J
hTgrtc1US4n4MPTKgeq2Zcs39T5INyEDezoxiNP179G/RKGWJIV3+16RScAriGgO
2/D+lF+89J165SBQM46mDJ12FcNoXjH5FPyD3FP98HwPNQ9HdZ6ASy4pKmz6t1k8
v8LC9ALCFYaGCnsx5W7HzynVVF2487IIN+xrEmS7h+e8ucBGkbDQVQnxlKzLUWuk
tH8CL9weSq9EV3eH5im9Upaio0WuCvUqmhTTYep4F7Y5hAEyJHH8UTvSVjw5E4a6
rpLSjyMRTVk=
=qEl0
-----END PGP SIGNATURE-----

--=-HHEbzAYwl/n0HrEXisct--
