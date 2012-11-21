Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:59109 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab2KULwm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Nov 2012 06:52:42 -0500
Date: Wed, 21 Nov 2012 12:52:36 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: "Manjunathappa, Prakash" <prakash.pm@ti.com>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Rob Herring <robherring2@gmail.com>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	David Airlie <airlied@linux.ie>
Subject: Re: [PATCH v12 2/6] video: add of helper for videomode
Message-ID: <20121121115236.GA8886@avionic-0098.adnet.avionic-design.de>
References: <1353426896-6045-1-git-send-email-s.trumtrar@pengutronix.de>
 <1353426896-6045-3-git-send-email-s.trumtrar@pengutronix.de>
 <A73F36158E33644199EB82C5EC81C7BC3E9FA7A0@DBDE01.ent.ti.com>
 <20121121114843.GC14013@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <20121121114843.GC14013@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 21, 2012 at 12:48:43PM +0100, Steffen Trumtrar wrote:
> Hi!
>=20
> On Wed, Nov 21, 2012 at 10:12:43AM +0000, Manjunathappa, Prakash wrote:
> > Hi Steffen,
> >=20
> > On Tue, Nov 20, 2012 at 21:24:52, Steffen Trumtrar wrote:
> > > +/**
> > > + * of_get_display_timings - parse all display_timing entries from a =
device_node
> > > + * @np: device_node with the subnodes
> > > + **/
> > > +struct display_timings *of_get_display_timings(const struct device_n=
ode *np)
> > > +{
> > > +	struct device_node *timings_np;
> > > +	struct device_node *entry;
> > > +	struct device_node *native_mode;
> > > +	struct display_timings *disp;
> > > +
> > > +	if (!np) {
> > > +		pr_err("%s: no devicenode given\n", __func__);
> > > +		return NULL;
> > > +	}
> > > +
> > > +	timings_np =3D of_find_node_by_name(np, "display-timings");
> >=20
> > I get below build warnings on this line
> > drivers/video/of_display_timing.c: In function 'of_get_display_timings':
> > drivers/video/of_display_timing.c:109:2: warning: passing argument 1 of=
 'of_find_node_by_name' discards qualifiers from pointer target type
> > include/linux/of.h:167:28: note: expected 'struct device_node *' but ar=
gument is of type 'const struct device_node *'
> >=20
> > > + * of_display_timings_exists - check if a display-timings node is pr=
ovided
> > > + * @np: device_node with the timing
> > > + **/
> > > +int of_display_timings_exists(const struct device_node *np)
> > > +{
> > > +	struct device_node *timings_np;
> > > +
> > > +	if (!np)
> > > +		return -EINVAL;
> > > +
> > > +	timings_np =3D of_parse_phandle(np, "display-timings", 0);
> >=20
> > Also here:
> > drivers/video/of_display_timing.c: In function 'of_display_timings_exis=
ts':
> > drivers/video/of_display_timing.c:209:2: warning: passing argument 1 of=
 'of_parse_phandle' discards qualifiers from pointer target type
> > include/linux/of.h:258:28: note: expected 'struct device_node *' but ar=
gument is of type 'const struct device_node *'
> >=20
>=20
> The warnings are because the of-functions do not use const pointers where=
 they
> should. I had two options: don't use const pointers even if they should b=
e and
> have no warnings or use const pointers and have a correct API. (Third opt=
ion:
> send patches for of-functions). I chose the second option.

Maybe a better approach would be a combination of 1 and 3: don't use
const pointers for struct device_node for now and bring the issue up
with the OF maintainers, possibly with patches attached that fix the
problematic functions.

Thierry

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQrMCEAAoJEN0jrNd/PrOhgr4QAJRWC7hS8tnBuTzrpN680qy3
V8g2r587fGabxUakch7jlAQ/woXkww7qUoUuPIAPT4jiasnA2v+FR77HwOkpQgLC
Q4sJS6g1VE+jpN3VUHfTYgRDehgCmSwyn1Y8jnjACSJUz31UsfqgpGCF3ULshHxF
pkF9pBuCBS/wGylwdbCCvLD8ARxcKW+BulagqBrC7S56P/sXtq6oYuuuW98K0rHV
poh0AsionTNcSn/mg0GssorH1yfwiPgTZNuZuJnGFzcNWWxuA3BZhKwQArgseJWI
KryOAGHMEQuAPA1PgiLpb7cKaYKXtWiurqMNLzkSz/kt3qCMUz5OyC1wwkRlxQhs
nvGrEwp7vDfKWJrEcK8w5JG3rdUwWBK/WFEi5OtuNC1Wan2krIfhKPv/8fi/P6Xa
nICUNcx7GhVU0iFuo24apez8FwEKhKYjg73gfI4IwrMLFKlJkpcBvL84kBP016eM
M01A3E7g0lZfHGXq5metE6iBFNHuilkx8QU6kRGHYIIU06rMQ8YFokbtQzhVqs3Q
+rYiVKn8rBIftOjnn1Yzen4A6XyJbs40wvxN4S013efjKe/PtBMbTdnVeEveXKcz
Hw605dOcTNnwnIX6G47hW95JC8bReDhxARMHTLbHL3MA7BK9/VhimPPfzGkDmSLm
t98ucnuFCilNQk4eOvo0
=eSiZ
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
