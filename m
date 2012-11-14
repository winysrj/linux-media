Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:63997 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab2KNLCm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 06:02:42 -0500
Date: Wed, 14 Nov 2012 12:02:15 +0100
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
Message-ID: <20121114110215.GA31999@avionic-0098.mockup.avionic-design.de>
References: <1352734626-27412-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352734626-27412-2-git-send-email-s.trumtrar@pengutronix.de>
 <20121114105634.GA31801@avionic-0098.mockup.avionic-design.de>
 <20121114105925.GA18579@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <20121114105925.GA18579@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 14, 2012 at 11:59:25AM +0100, Steffen Trumtrar wrote:
> On Wed, Nov 14, 2012 at 11:56:34AM +0100, Thierry Reding wrote:
> > On Mon, Nov 12, 2012 at 04:37:01PM +0100, Steffen Trumtrar wrote:
> > [...]
> > > diff --git a/drivers/video/display_timing.c b/drivers/video/display_t=
iming.c
> > [...]
> > > +void display_timings_release(struct display_timings *disp)
> > > +{
> > > +	if (disp->timings) {
> > > +		unsigned int i;
> > > +
> > > +		for (i =3D 0; i < disp->num_timings; i++)
> > > +			kfree(disp->timings[i]);
> > > +		kfree(disp->timings);
> > > +	}
> > > +	kfree(disp);
> > > +}
> >=20
> > I think this is still missing an EXPORT_SYMBOL_GPL. Otherwise it can't
> > be used from modules.
> >=20
> > Thierry
>=20
> Yes. Just in time. I was just starting to type the send-email command ;-)

Great! In that case don't forget to also look at my other email before
sending. =3D)

Thierry

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQo3o3AAoJEN0jrNd/PrOhIJAP/R7ENnmVEzib3ttW7KSKEKpa
B0T6hLtiIWmOMiZIAHpXbbG91DV2HyMtI0zk2E67dq3FBJfDRm7AuyD3DKZTg1Qu
H8hL+c1f4z0MTKhfuVutnKSKU/J/SE1sbAqy+R6intPaatyEhhVjEunn8kYCgwrQ
iw17Uaq6ibTeV4Uv8JkmMc6g6eqXj2VCRhKyRzcVO/bcGUKSGnVPZj2+HKSwBjbJ
vPaigJlFohIhD9OtQdkKVAae5ZvTuXgHQeHSy5rLf3UG4q6a5cdPeRBEWRZwW7WW
JZCA41PbzHg7lHEsfKQ5RrN+LOqmadRXll3RvUyiusdlzBur9duxrtmoDDGkbs2z
rl5fHS95xAmgQNnpthpCKTkZXE2eoYM1HzBNkQo+7OAWon1mBII8XJ0wejSY7ACN
/ikHmKd9SWDt5FWgISGJoE7yRofI/ZYei/PBd3yZ9++9tUrOpm4yptJ5DgqevE1m
Rh3vSN/rGDM0BH3X2vPyPW11AJBjVI9s9nncIzgL2nbCQYF1YQJ1aBLvu2qjlxpZ
z8nNjzxKGRv3yt1vDyG9fm14/H3hAeObnFGZsUd04ji/IqgUBy5O/iI6JCWOkagE
wLeLd5Wup6pQ10e9oM/VVAag5pa57FHyfw7SAY/Qnvvy/cydClX1Qd45+oNnwxDV
WvHW50R5FiVjhNVnub0t
=GVco
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
