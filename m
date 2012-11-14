Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:61589 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932872Ab2KNLRZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 06:17:25 -0500
Date: Wed, 14 Nov 2012 12:17:14 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de
Subject: Re: [PATCH v8 1/6] video: add display_timing and videomode
Message-ID: <20121114111714.GA32071@avionic-0098.mockup.avionic-design.de>
References: <1352734626-27412-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352734626-27412-2-git-send-email-s.trumtrar@pengutronix.de>
 <20121114105634.GA31801@avionic-0098.mockup.avionic-design.de>
 <20121114105925.GA18579@pengutronix.de>
 <20121114110215.GA31999@avionic-0098.mockup.avionic-design.de>
 <20121114111015.GB18579@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <20121114111015.GB18579@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 14, 2012 at 12:10:15PM +0100, Steffen Trumtrar wrote:
> On Wed, Nov 14, 2012 at 12:02:15PM +0100, Thierry Reding wrote:
> > On Wed, Nov 14, 2012 at 11:59:25AM +0100, Steffen Trumtrar wrote:
> > > On Wed, Nov 14, 2012 at 11:56:34AM +0100, Thierry Reding wrote:
> > > > On Mon, Nov 12, 2012 at 04:37:01PM +0100, Steffen Trumtrar wrote:
> > > > [...]
> > > > > diff --git a/drivers/video/display_timing.c b/drivers/video/displ=
ay_timing.c
> > > > [...]
> > > > > +void display_timings_release(struct display_timings *disp)
> > > > > +{
> > > > > +	if (disp->timings) {
> > > > > +		unsigned int i;
> > > > > +
> > > > > +		for (i =3D 0; i < disp->num_timings; i++)
> > > > > +			kfree(disp->timings[i]);
> > > > > +		kfree(disp->timings);
> > > > > +	}
> > > > > +	kfree(disp);
> > > > > +}
> > > >=20
> > > > I think this is still missing an EXPORT_SYMBOL_GPL. Otherwise it ca=
n't
> > > > be used from modules.
> > > >=20
> > > > Thierry
> > >=20
> > > Yes. Just in time. I was just starting to type the send-email command=
 ;-)
> >=20
> > Great! In that case don't forget to also look at my other email before
> > sending. =3D)
> >=20
> Sure.

Besides those comments (and those from other people) I think your
patchset is in pretty good shape. Have you thought about how and when
you want to get things merged?

Thierry

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQo326AAoJEN0jrNd/PrOhVuYQAJ5oXxec2kv86D51EhloMKtD
W92GNKD7K9aaAzsnnKz0JjzJHN625pRNd1tnsIaQJkzsHLddDcJ3oGJJpL2Im7eV
A2eXC76e5V9RmZU0NxPCP4f1ei8mdWTyL/GoLh/qiWhVop3T0201HGx2gGZfb/rw
+EYCJkFnYCpE3zVPKPne85jS9jPWSNViB4MmHL26VSFENiIYl2uQaqFIpb2e8oIQ
k5X6KAVPyt3Kg9P3+tZC+Eh9asRfevw5Ai7UJIg6GucM55zyYMCZnYTRWWxyZrNz
jJ0KSmWAZfIuzY3umeDSeTl6cVVkWblX4fvPcZKiz2nyUOL5W46vx79bWG6H2tU7
TVQCDQIlRbsUhwPy8FLMCl/Es8sxMz2Y1irVh+ak+jwgbTrVm3btZRDgW5c5P5f9
OCdlJHZq8PaNekCkv7dZVTRv7EblkHPvrT9CUhD0ZfHRxW20xsJshQR1IIKNbPPi
XW4a5GUhoMSY+mcD9Okr0VTve0mBxyxwGwOH3m9gQhi0QXY7ms0V1FyALSF/XB8C
g/VvWvljcjApqdEbn3swT2NJNd1se+J/r831QtCLryszdqiv5QTJlwN+9V/lxsvz
1gUe4FEPNnwMKdpNWS7S6Af98ynZeLDrUsc76/8U5fp7fGca+9YU82vbA2Sxgbse
mTJRhcox2ehstI+ENBSX
=s/5w
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
