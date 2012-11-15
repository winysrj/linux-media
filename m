Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:49926 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992442Ab2KOK1g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Nov 2012 05:27:36 -0500
Date: Thu, 15 Nov 2012 11:27:12 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de
Subject: Re: [PATCH v10 0/6] of: add display helper
Message-ID: <20121115102711.GA20080@avionic-0098.mockup.avionic-design.de>
References: <1352971437-29877-1-git-send-email-s.trumtrar@pengutronix.de>
 <20121115102411.GA17272@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <20121115102411.GA17272@avionic-0098.mockup.avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 15, 2012 at 11:24:11AM +0100, Thierry Reding wrote:
> On Thu, Nov 15, 2012 at 10:23:51AM +0100, Steffen Trumtrar wrote:
> > Hi!
> >=20
> > Changes since v9:
> > 	- don't leak memory when previous timings were correct
> > 	- CodingStyle fixes
> > 	- move blank lines around
> >=20
> > Regards,
> > Steffen
> >=20
> >=20
> > Steffen Trumtrar (6):
> >   video: add display_timing and videomode
> >   video: add of helper for videomode
> >   fbmon: add videomode helpers
> >   fbmon: add of_videomode helpers
> >   drm_modes: add videomode helpers
> >   drm_modes: add of_videomode helpers
> >=20
> >  .../devicetree/bindings/video/display-timings.txt  |  107 ++++++++++
> >  drivers/gpu/drm/drm_modes.c                        |   70 +++++++
> >  drivers/video/Kconfig                              |   19 ++
> >  drivers/video/Makefile                             |    4 +
> >  drivers/video/display_timing.c                     |   24 +++
> >  drivers/video/fbmon.c                              |   86 ++++++++
> >  drivers/video/of_display_timing.c                  |  212 ++++++++++++=
++++++++
> >  drivers/video/of_videomode.c                       |   47 +++++
> >  drivers/video/videomode.c                          |   45 +++++
> >  include/drm/drmP.h                                 |   12 ++
> >  include/linux/display_timing.h                     |   69 +++++++
> >  include/linux/fb.h                                 |   12 ++
> >  include/linux/of_display_timings.h                 |   20 ++
> >  include/linux/of_videomode.h                       |   17 ++
> >  include/linux/videomode.h                          |   40 ++++
> >  15 files changed, 784 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/video/display-tim=
ings.txt
> >  create mode 100644 drivers/video/display_timing.c
> >  create mode 100644 drivers/video/of_display_timing.c
> >  create mode 100644 drivers/video/of_videomode.c
> >  create mode 100644 drivers/video/videomode.c
> >  create mode 100644 include/linux/display_timing.h
> >  create mode 100644 include/linux/of_display_timings.h
> >  create mode 100644 include/linux/of_videomode.h
> >  create mode 100644 include/linux/videomode.h
>=20
> With the one change that I pointed out, the whole series:
>=20
> Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
> Acked-by: Thierry Reding <thierry.reding@avionic-design.de>

Also:

Tested-by: Thierry Reding <thierry.reding@avionic-design.de>

=3D)

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQpMN/AAoJEN0jrNd/PrOhaLEP/A9EutJPI0Qc0Q8fu5Zgri8Z
eW/nBMN0aSD/VWEyRtgdgEJYo6v40c7b2SY63pMXTwGTuWXgm2hH5Hm4CuabALMt
dk8Rx6wVBfAE6kieK9T5mr+07S+xkFea516bfxXEBR0qiYjgvI3jdKCsMkFVUtcn
B4UCt7OQWc/6WXoH0exTB4/DCbZ7/hFpTd5Y6FudqtRb1KbI9512i9MNOnBjxm2Y
Ab9FPGFium3ixj5uYspTRgyduMCgM/etpJeAqDb4SdD3w7Tln9i4fYcIKF+O33lW
lWar6yZKVcVfPPKM1vEoI41kbXTXuoDiurgYhstBfPjF53C8AG/nQJAYmJK6V4XF
TqHHJKnYziXF0z4PKtn0+KXARQiZDugN3XFbM4r3jlTuU9ecGZjIQ7ADyaysR/Rf
4lDGsMbyDCzW0gbSjXft1b+NmosE3HjTHRJYmvRykJR5z96GKzDXocf66kWQvfdD
b6aV26cLsFxSUuftBl7wrR93W+ADkKhy0D+33wix4/8cjUHX1JjE7JsEK4cXnKx8
8EurB9yTa0wteINdBydL018q77HQ44nmkIdAM3Xd3ONN+hgtayKTi+5APLo1dM5H
oOmZJT3q5fqvcyjbOytDU7/WXJQSBL4R2Z8PQIvrOHMp0aCefXxcxMHje3ddIDzN
Zm/atjp6uPnbDgy8KDfe
=6PVi
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
