Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54947 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbcD0DI4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Apr 2016 23:08:56 -0400
Date: Wed, 27 Apr 2016 05:08:50 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: sakari.ailus@iki.fi, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
Message-ID: <20160427030850.GA17034@earth>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Apr 25, 2016 at 12:08:00AM +0300, Ivaylo Dimitrov wrote:
> Those patch series make cameras on Nokia N900 partially working.
> Some more patches are needed, but I've already sent them for
> upstreaming so they are not part of the series:
>=20
> https://lkml.org/lkml/2016/4/16/14
> https://lkml.org/lkml/2016/4/16/33
>=20
> As omap3isp driver supports only one endpoint on ccp2 interface,
> but cameras on N900 require different strobe settings, so far
> it is not possible to have both cameras correctly working with
> the same board DTS. DTS patch in the series has the correct
> settings for the front camera. This is a problem still to be
> solved.
>=20
> The needed pipeline could be made with:
>=20
> media-ctl -r
> media-ctl -l '"vs6555 binner 2-0010":1 -> "video-bus-switch":2 [1]'
> media-ctl -l '"video-bus-switch":0 -> "OMAP3 ISP CCP2":0 [1]'
> media-ctl -l '"OMAP3 ISP CCP2":1 -> "OMAP3 ISP CCDC":0 [1]'
> media-ctl -l '"OMAP3 ISP CCDC":2 -> "OMAP3 ISP preview":0 [1]'
> media-ctl -l '"OMAP3 ISP preview":1 -> "OMAP3 ISP resizer":0 [1]'
> media-ctl -l '"OMAP3 ISP resizer":1 -> "OMAP3 ISP resizer output":0 [1]'
> media-ctl -V '"vs6555 pixel array 2-0010":0 [SGRBG10/648x488 (0,0)/648x48=
8 (0,0)/648x488]'
> media-ctl -V '"vs6555 binner 2-0010":1 [SGRBG10/648x488 (0,0)/648x488 (0,=
0)/648x488]'
> media-ctl -V '"OMAP3 ISP CCP2":0 [SGRBG10 648x488]'
> media-ctl -V '"OMAP3 ISP CCP2":1 [SGRBG10 648x488]'
> media-ctl -V '"OMAP3 ISP CCDC":2 [SGRBG10 648x488]'
> media-ctl -V '"OMAP3 ISP preview":1 [UYVY 648x488]'
> media-ctl -V '"OMAP3 ISP resizer":1 [UYVY 656x488]'
>=20
> and tested with:
>=20
> mplayer -tv driver=3Dv4l2:width=3D656:height=3D488:outfmt=3Duyvy:device=
=3D/dev/video6 -vo xv -vf screenshot tv://

4.6-rc4 + twl regulator patch + the patches mentioned above + this
patchset (I put everything together here [0]) do _not_ work for me.
The error matches what I have seen when I was working on it: No
image data seems to be received by the ISP. For example there are
no related IRQs:

root@n900:~# cat /proc/interrupts  | grep ISP
 40:          0      INTC  24 Edge      480bd400.mmu, OMAP3 ISP

I tested with mpv and yavta (yavta --capture=3D8 --pause --skip 0
--format UYVY --size 656x488 /dev/video6)

[0] https://git.kernel.org/cgit/linux/kernel/git/sre/linux-n900.git/log/?h=
=3Dn900-camera-ivo

-- Sebastian

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJXIC0/AAoJENju1/PIO/qakWoP/1fuDH4Y7s1HYC7zXSmVPCJq
mUelO9jz6AapSbOdCWWjt9rbW5q55qovYsM2vZRGkZQGkQu1kpXGXUN2FpJEK6Eb
O1x26gpuifKYAGitn2oLKQNkF8zmhYwQy6w47jdAopIa8VmtLb9Xd1UxpmQ8tdEg
lLppLEsRHUHfCoB1AXEZF2C+KizHKEo3M7+SEGNDz0h6PkehUwD5msMvelMOdVbl
QAr+V5dH09YhsVPOdGiz2gjjqaRFvj54dVURNTvCEjkvQkND0b4V3dm4wCa2vtBs
mUSif53DjKMmlUSObIT/VmEU3/gPUJgSr8reDPUW0pBIOe+KMAtpOeG+GcjtBAlu
ArMh2j3GivNSzqAks51r0FlGKBGTwIC7yhKFDN9JlMOylg+ykWnFttwo+t2Lkcyc
IiRqcFXv4PR5bmhfQVSoutPEyrg72bIhPrkWZftvzfwjbWW/cvm6RzBCTtctE2op
IYrWZZcgVYCl/l/Z+oLrNnllCVsJZwKqGl9GF8uIuU84PbopNO1qRqmf9Dm4VkLN
M3+qJ4uB1kbtnZJjKu2mDSvIqVDbElPfo9gJdwNqqaQa/fkNbalW3rLv7a/3aQP/
q1jGI3LzPSbNqDYxuVqY9lMqFyPfYdEwQZeQV7zR3DF/Y4RniY2F6CnufeQplL09
rb/fojnxrBUdq4h32bHt
=e61T
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
