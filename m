Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:59892 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab2JTKyZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Oct 2012 06:54:25 -0400
Date: Sat, 20 Oct 2012 12:54:16 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH 2/2 v6] of: add generic videomode description
Message-ID: <20121020105416.GB12545@avionic-0098.mockup.avionic-design.de>
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de>
 <12272414.930KpWciBg@avalon>
 <20121008124801.GD20800@pengutronix.de>
 <1737299.6PuzOm7XuT@avalon>
 <20121009072608.GA2519@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Content-Disposition: inline
In-Reply-To: <20121009072608.GA2519@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 09, 2012 at 09:26:08AM +0200, Steffen Trumtrar wrote:
> Hi Laurent,
>=20
> On Mon, Oct 08, 2012 at 10:52:04PM +0200, Laurent Pinchart wrote:
> > Hi Steffen,
> >=20
> > On Monday 08 October 2012 14:48:01 Steffen Trumtrar wrote:
> > > On Mon, Oct 08, 2012 at 02:13:50PM +0200, Laurent Pinchart wrote:
> > > > On Thursday 04 October 2012 19:59:20 Steffen Trumtrar wrote:
[...]
> > > > > +int of_get_videomode(struct device_node *np, struct videomode *v=
m, int
> > > > > index)
> > > >=20
> > > > I wonder how to avoid abuse of this functions. It's a useful helper=
 for
> > > > drivers that need to get a video mode once only, but would result i=
n lower
> > > > performances if a driver calls it for every mode. Drivers must call
> > > > of_get_display_timing_list instead in that case and case the display
> > > > timings. I'm wondering whether we should really expose of_get_video=
mode.
> > >=20
> > > The intent was to let the driver decide. That way all the other overh=
ead may
> > > be skipped.
> >=20
> > My point is that driver writers might just call of_get_videomode() in a=
 loop,=20
> > not knowing that it's expensive. I want to avoid that. We need to at le=
ast add=20
> > kerneldoc to the function stating that this shouldn't be done.
> >=20
>=20
> You're right. That should be made clear in the code.

In that case we should export videomode_from_timing(). For Tegra DRM I
wrote a small utility function that takes a struct display_timings and
converts every timing to a struct videomode which is then converted to
a struct drm_display_mode and added to the DRM connector. The code is
really generic and could be part of the DRM core.

Thierry

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQgoLYAAoJEN0jrNd/PrOh+J4P/idMtTfMJQHVkY2eNlVmMkNU
6Gxr54JUVxTGZ6Ogmp4H08fHxjh4aY6KZgmUwKPf6/aOQN61mwGXdfCylLRYEUmK
545p/nkf+8/dX1iiMLZGJC08v1H7SjWAO1nCa3+OkL0mrwzZ/MxxrzqKRdifzQJj
3n5sBo661c8Wk4hi/dp/gNbj+jJdqQCSQzTY4d1dUoZrUMsKK8Su0/+cWOsuphPl
XWJ9wH6xganu+kX/BfTVQdYp0BbzJ2xL4z51VLhKKlhICN1UVmtczYoXZWK41aZR
y7nrGuvvd/m+Wr5pUpakAZNr6FGGdb82Hg915ZvL3OgJwOwftPcjq2j3OOaxLAp5
HSdomKfHyD69GJ9TupDJf7AFN9ITBuexaHP7eK2bzPMM0wwcpKG5MpuI4hBDtwfF
HZfKRq491REkVjQB1lzYm+vHpUM0bQivur6U3c9ZPejkR64tATtIAts7DFIQ/VEt
m2/RC50KMZWCxfyJp5ropoY3PGYkuQwwPk5Z+Ol4789DnGxt3V4UQuAWiq7CEMSx
BdcTvYIWlrtygBNEpFklVyxX8yjoYgyGODHbTH05x83KF8CP0un+/ywDBFgYbQ4L
hByuSKkfDFBkLpwPiZ1py8QLHMMwvYlHxLkP19Dooz4gynAHoP9pQaJWRXZVNLkM
GqHiyAaHLAPNnTqTJKaN
=LYEy
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
