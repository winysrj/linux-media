Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33455 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbcD0QnB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2016 12:43:01 -0400
Date: Wed, 27 Apr 2016 18:42:56 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: pavel@ucw.cz, sakari.ailus@iki.fi, pali.rohar@gmail.com,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
Message-ID: <20160427164256.GA8156@earth>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160427030850.GA17034@earth>
 <572048AC.7050700@gmail.com>
 <572062EF.7060502@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
In-Reply-To: <572062EF.7060502@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 27, 2016 at 09:57:51AM +0300, Ivaylo Dimitrov wrote:
> >>https://git.kernel.org/cgit/linux/kernel/git/sre/linux-n900.git/log/?h=
=3Dn900-camera-ivo
> >
> >Ok, going to diff with my tree to see what I have missed to send in the
> >patchset
>=20
> Now, that's getting weird.

[...]

> I you want to try it, zImage and initrd are on
> http://46.249.74.23/linux/camera-n900/

The zImage + initrd works with the steps you described below. I
received a completly black image, but at least there are interrupts
and yavta is happy (=3D> it does not hang).

For reference I configured the pipeline using media-ctl and used
this to acquire the image:

=2E/yavta --capture=3D1 --format UYVY --file=3D"/tmp/frame.uyvy" --size 656=
x488 /dev/video6

Then I copied the file to my notebook using the FTP server coming
with your initrd and displayed it using "display" from imagemagick:

display -size 656x488 -colorspace rgb frame.uyvy

Before analysing why there is only a black image let's start
with the no image at all problem, though.

> I cloned n900-camera-ivo, copied rx51_defconfig from my tree, added:
>=20
> CONFIG_VIDEO_SMIAREGS=3Dm
> CONFIG_VIDEO_ET8EK8=3Dm
> CONFIG_VIDEO_BUS_SWITCH=3Dm
>=20
> to it, make mrproper, built the kernel using rx51_defconfig and made init=
rd
> for rescueos, so to be sure that maemo5 did not influence cameras somehow.

Ok, so there is probably a problem when some things are not built as
modules.

> I cloned n900-camera-ivo, copied rx51_defconfig from my tree, added:
>=20
> CONFIG_VIDEO_SMIAREGS=3Dm
> CONFIG_VIDEO_ET8EK8=3Dm
> CONFIG_VIDEO_BUS_SWITCH=3Dm
>=20
> to it, make mrproper, built the kernel using rx51_defconfig and made init=
rd
> for rescueos, so to be sure that maemo5 did not influence cameras somehow.

I will test your kernel + your modules with my userspace, so
that I know for sure, that my userland behaves correctly.

Can you try if your config still works if you configure
CONFIG_VIDEO_OMAP3=3Dy, but leaving the sensors configured
as modules? I will try the reverse process (using my config
and moving config options to =3Dm).

> ~$ modprobe smiapp

modprobing smiapp resulted in a kernel message about a missing
symbol btw. I currently don't remember which one and it's no
longer in dmesg due to ISP debug messages.

> Please, Sebastian and Pavel, make sure you're not using some development
> devices, old board versions need VAUX3 enabled as well, and this is not
> supported in the $subject patchset. I guess you may try to make VAUX3
> always-on in board DTS if that's the case, but I've never tested that, my
> device is a production one.

I don't have pre-production N900s. The phone I use for development
is HW revision 2101 with Finish keyboard layout. Apart from that
I have my productive phone, which is rev 2204 with German layout.

-- Sebastian

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJXIOwNAAoJENju1/PIO/qaAsgP/2H34Qc3Wm08c9kkKzay1dOb
bEySWmjVT/jTwth7UeoM7CP/F2I4T2bU0QgACJSpZWFjI5/qjMCsXAc7ow9N9fFo
cE6WY7I/rn6591DAMzw72gQZvNCg85EgiK4AHjpXm7F6p3XZKX5hIH7vxJCeQRPi
dccxvQ+o5FqVsyCRAt4+aDFZImTcUifdhHh3RVzw55ZO4bGiapKmF+4h4vSrJIrv
IlBf3/2GNoX1GLZm9TzByKm61xTDoyXHaR3qFNTKgd0UzD4cVTdsco6NVbFOAjwE
m1E+JrO6yaLebZUWHY5/fNog1ZRgx7g/AtvtaihyppEWsMOPes79d10fljhRaKVx
WnIHMPSRaKXKqan4hCR02ynAHb8vkYCX3M4ewiiW504VJA8Ujt31+BRDHPLGxpza
Q4LErHpUhrj90MAup0Y2f7KafB9F2V+icqJwAzppGswWvahL3Qe3lP9kD7zkksvk
6goVrJoV6FvRi30/FurfB9UUkgGH6h6TAqgZWdrjfCtUzc3vtIFeA450JWZv0ujp
6vmMf19I09aQDa6dXW8sW3H1LYuUsK2RXRbjCLU0Osc6ErJ15ISwBfbFZXRwRGvt
XyG42aif2DsyPyUd8LIfFN/M7ubbC3e+ptrsKVESHOLIjN/ID+znbqGQBoKNTrXE
HlBbdIi9ar04hG+45l81
=PyyN
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
