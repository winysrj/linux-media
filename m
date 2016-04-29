Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39811 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbcD2AF5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2016 20:05:57 -0400
Date: Fri, 29 Apr 2016 02:05:52 +0200
From: Sebastian Reichel <sre@kernel.org>
To: =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?=
	<ivo.g.dimitrov.75@gmail.com>
Cc: pavel@ucw.cz, sakari.ailus@iki.fi, pali.rohar@gmail.com,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
Message-ID: <20160429000551.GA29312@earth>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160427030850.GA17034@earth>
 <572048AC.7050700@gmail.com>
 <572062EF.7060502@gmail.com>
 <20160427164256.GA8156@earth>
 <1461777170.18568.2.camel@Nokia-N900>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <1461777170.18568.2.camel@Nokia-N900>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--DocE+STaALJfprDB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ivo,

On Wed, Apr 27, 2016 at 08:12:50PM +0300, =D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=
=BE =D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2 wrote:
> > The zImage + initrd works with the steps you described below.
>=20
> Great!

I also got it working with the previously referenced branch with the
following built as modules:

CONFIG_VIDEOBUF2_CORE=3Dm
CONFIG_VIDEOBUF2_MEMOPS=3Dm
CONFIG_VIDEOBUF2_DMA_CONTIG=3Dm
CONFIG_VIDEO_OMAP3=3Dm
CONFIG_VIDEO_BUS_SWITCH=3Dm
CONFIG_VIDEO_SMIAPP_PLL=3Dm
CONFIG_VIDEO_SMIAPP=3Dm
CONFIG_VIDEO_SMIAREGS=3Dm
CONFIG_VIDEO_ET8EK8=3Dm

> > I received a completly black image, but at least there are interrupts
> > and yavta is happy (=3D> it does not hang).
>=20
> The black image is because by default exposure and gain are set to 0 :).=
=20
> Use yavta to set the appropriate controls. You can
> also enable test patterns from there.

The test patterns look ok for me, so it's definitively a sensor
configuration problem :)

> > Can you try if your config still works if you configure
> > CONFIG_VIDEO_OMAP3=3Dy, but leaving the sensors configured
> > as modules? I will try the reverse process (using my config
> > and moving config options to =3Dm).
> >
>=20
> Will try to find time later today.
> =20
> > > ~$ modprobe smiapp
> >=20
> > modprobing smiapp resulted in a kernel message about a missing
> > symbol btw. I currently don't remember which one and it's no
> > longer in dmesg due to ISP debug messages.
>=20
> Never seen such missing symbols.

It did not appear with my kernel built either.

-- Sebastian

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJXIqVdAAoJENju1/PIO/qaIrkP/1O1H8xtZ6f0gBebOGT3//SG
ZdauoCCHCdBHSKocR1Kh8ZmSJ94IsZP6IwOfwReG5LeyE1d5TkfEyO/w6I6BP3/O
nqoXZFAy42zZqoLd6tlzkSVG+yyCE8ieJUmvLv6/2Gd6Hsff7PCAgqfXeto166Ee
i1gc61QEE7P6yFlrqPepQYER1CuNZjyyYdcHk5GohR4m/sgFzH5YX1LZVKbff1en
UckRk044E5X4h8bWPWmZjv2WmPUVGNIq1mpZVZYs3VhGfeseec8rVEyza0WbnKMA
vKVgZxpAdOQUYd6RRkMch/w7pG9/jzB5UBGkA1cwh+tSou76/UPRsyAPSxSgZf5q
bcwq/Hcw3CxVYg6LDmIUF0FosMzQmb5t6Rv6jODgxT1RQUZ8NRZeTgCljdqXwOXm
ZJyeWQXmfIMw6xslUXcJDARe/c8Z7ZT74k2yA7hp1bWn/dFBPVUphdnQSPb0qs7x
xe+8w3R47QEyOmjFAV7e1stAvwO/iRKwlxzbO+GaSOKFfI6MsDGpdHzNtTjHLLgG
gK5lr55+sX0RYk9ozSwRT/BXNi1wX2FPQEE/npjQtDOb930PpZC/Tn78NMdbzj+v
t2W8tXegVjKkDW6xchWZ39zDbhkfJVvqRLZN8V14izGHjQhE7gJ5S8j36fI5qsIw
8e23yjqFYxRajBYlOZIK
=gUAD
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
