Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:58442 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab2JTLfF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Oct 2012 07:35:05 -0400
Date: Sat, 20 Oct 2012 13:35:00 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Leela Krishna Amudala <l.krishna@samsung.com>,
	linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 0/2 v6] of: add display helper
Message-ID: <20121020113500.GA12978@avionic-0098.mockup.avionic-design.de>
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de>
 <CAL1wa8fP8LBCUBVJS1=dy3cyFe+bY-Gu2+wtJyuCrgbP93m3Wg@mail.gmail.com>
 <20121015141751.GA11396@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <20121015141751.GA11396@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 15, 2012 at 04:17:51PM +0200, Steffen Trumtrar wrote:
> Hi Leela,
>=20
> On Mon, Oct 15, 2012 at 04:24:43PM +0530, Leela Krishna Amudala wrote:
> > Hello Steffen,
> >=20
> > To which version of the kernel we can expect this patch set to be merge=
d into?
> > Because I'm waiting for this from long time to add DT support for my
> > display controller :)
> >=20
>=20
> I have no idea, sorry. It seems like we have almost settled with the bind=
ing
> (clock-name needs to be changed), but I'm not responsible for any merging=
/inclusions
> in the kernel.

I want to use this in the Tegra DRM driver which I hope to get into 3.8.
If you need any help with this, please let me know.

Thierry

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQgoxkAAoJEN0jrNd/PrOhgOMQAJW6PHzJr2s96wUKJnSpPErY
Ydw2VxX2ouNc7BIwLYibMzwzCDy6CWQCITWHWx6KIIg4Vi4gg5J65fuS9a/lQlMK
7Iuo7T3j0EYUiOw44omjmJbPm2o1iUEvx3B0GJvV2Udkvo3O8DcDpVZ/f/KH4+JF
GBwjOZFQIttTHdTOwmAKrUolVk9Iqax1ILUqmG6SBs8cfe2p5qR8nYEQSFcZmuGQ
6JBix2QHifR9ke/c9xhu9kKODjcRXd7MxqK8bILB7eqYppnXrdjktarwLBUduYEk
DN8ozclyolwY7q1VtcUHS5hNF2QoEzyuA1cE3Ofkd+Gu6PuCQBFXLqHGOHQPq1lx
TGoU+yLHU0MeUjt/iRVoII468z1J66lCPbECaKBCSvP0CJcVEDSNSERkIsS+KCpG
W4W2eqh/BASWR6Bfnto0NSUSlXLB/5+OhEfCto4mTLyfkM2dG6Jr0lbqiuhHhN3E
ZUNHicAnZKJLAUaQm/Ac+QH437b604I/LHEJzn4t5MBIEFCgnZhdihGAk4Nj6zao
Me1HLN1UK2Hr9KrEB/gFATvYS6maiTHeNy/xSp9cN+sz5sdS2HhRIKze1cn3m76r
sDRUf/5u1UV4kcOy/KFuYxnxxyc9Bykl2cSF0zsGxV98KkZx26rUJNEfnFKlnWkt
WpzhT8aTF9kittx0VjyV
=wh+K
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
