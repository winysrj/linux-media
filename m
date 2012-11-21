Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:50979 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab2KUPNi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Nov 2012 10:13:38 -0500
Date: Wed, 21 Nov 2012 16:13:14 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Rob Herring <robherring2@gmail.com>
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	"Manjunathappa, Prakash" <prakash.pm@ti.com>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	David Airlie <airlied@linux.ie>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v12 2/6] video: add of helper for videomode
Message-ID: <20121121151314.GB4048@avionic-0098.adnet.avionic-design.de>
References: <1353426896-6045-1-git-send-email-s.trumtrar@pengutronix.de>
 <1353426896-6045-3-git-send-email-s.trumtrar@pengutronix.de>
 <A73F36158E33644199EB82C5EC81C7BC3E9FA7A0@DBDE01.ent.ti.com>
 <20121121114843.GC14013@pengutronix.de>
 <20121121115236.GA8886@avionic-0098.adnet.avionic-design.de>
 <50ACED4A.5040806@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dTy3Mrz/UPE2dbVg"
Content-Disposition: inline
In-Reply-To: <50ACED4A.5040806@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 21, 2012 at 09:03:38AM -0600, Rob Herring wrote:
> On 11/21/2012 05:52 AM, Thierry Reding wrote:
> > On Wed, Nov 21, 2012 at 12:48:43PM +0100, Steffen Trumtrar wrote:
> >> Hi!
> >>
> >> On Wed, Nov 21, 2012 at 10:12:43AM +0000, Manjunathappa, Prakash wrote:
> >>> Hi Steffen,
> >>>
> >>> On Tue, Nov 20, 2012 at 21:24:52, Steffen Trumtrar wrote:
> >>>> +/**
> >>>> + * of_get_display_timings - parse all display_timing entries from a=
 device_node
> >>>> + * @np: device_node with the subnodes
> >>>> + **/
> >>>> +struct display_timings *of_get_display_timings(const struct device_=
node *np)
> >>>> +{
> >>>> +	struct device_node *timings_np;
> >>>> +	struct device_node *entry;
> >>>> +	struct device_node *native_mode;
> >>>> +	struct display_timings *disp;
> >>>> +
> >>>> +	if (!np) {
> >>>> +		pr_err("%s: no devicenode given\n", __func__);
> >>>> +		return NULL;
> >>>> +	}
> >>>> +
> >>>> +	timings_np =3D of_find_node_by_name(np, "display-timings");
> >>>
> >>> I get below build warnings on this line
> >>> drivers/video/of_display_timing.c: In function 'of_get_display_timing=
s':
> >>> drivers/video/of_display_timing.c:109:2: warning: passing argument 1 =
of 'of_find_node_by_name' discards qualifiers from pointer target type
> >>> include/linux/of.h:167:28: note: expected 'struct device_node *' but =
argument is of type 'const struct device_node *'
> >>>
> >>>> + * of_display_timings_exists - check if a display-timings node is p=
rovided
> >>>> + * @np: device_node with the timing
> >>>> + **/
> >>>> +int of_display_timings_exists(const struct device_node *np)
> >>>> +{
> >>>> +	struct device_node *timings_np;
> >>>> +
> >>>> +	if (!np)
> >>>> +		return -EINVAL;
> >>>> +
> >>>> +	timings_np =3D of_parse_phandle(np, "display-timings", 0);
> >>>
> >>> Also here:
> >>> drivers/video/of_display_timing.c: In function 'of_display_timings_ex=
ists':
> >>> drivers/video/of_display_timing.c:209:2: warning: passing argument 1 =
of 'of_parse_phandle' discards qualifiers from pointer target type
> >>> include/linux/of.h:258:28: note: expected 'struct device_node *' but =
argument is of type 'const struct device_node *'
> >>>
> >>
> >> The warnings are because the of-functions do not use const pointers wh=
ere they
> >> should. I had two options: don't use const pointers even if they shoul=
d be and
> >> have no warnings or use const pointers and have a correct API. (Third =
option:
> >> send patches for of-functions). I chose the second option.
> >=20
> > Maybe a better approach would be a combination of 1 and 3: don't use
> > const pointers for struct device_node for now and bring the issue up
> > with the OF maintainers, possibly with patches attached that fix the
> > problematic functions.
>=20
> Why does this need to be const? Since some DT functions increment
> refcount the node, I'm not sure that making struct device_node const in
> general is right thing to do. I do think it should be okay for
> of_parse_phandle.

I wasn't proposing to do it everywhere but only where possible. If the
node is modified in some way then obviously it shouldn't be const.

Thierry

--dTy3Mrz/UPE2dbVg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQrO+KAAoJEN0jrNd/PrOhMiAQAJ4fJdlH+VJ6hrGAPKLMP4mW
BYFJIr//pDah93mSpvG2a07FgbGJNdIIHL8XERZSXy+m06lxDM0BIjlxZpKuo0n0
sEeNVfwQP6H/S0/pyqsMG2NqgGswzEzayNy+o7YkNTnFk33J1QU6csE48QpmQz6x
hS14W58T01Pv8mJ9gh0edix2vC1S5ORDUXE8EMPL4jQBiJ0vjobwcfmnJasfbNy9
mhhs8Mv3lFYqMlotmCcnZilQKXzR74TUkxnhopRNLLJIuL102jKYfVikhuTlul06
XoXwUlNF743IywoE8Tr/vfvewN4YA3oEA+a5kDkkmszpgd8Ue2kmsdK1d7sIeU7q
6B+PkoFm/VIA7rSMKIZAPANn9aW04MydilNXpaIEoUX5OW1/YnvHYQmiiy3TgPb5
YNGgvk0RoYGEW14yaIkMVZpTTMyzdVhKUXXrYuSx/jlh/T3myRdIOJXsSFZOW5Yw
kFAGDh9vWt1yT1OfJ1jpUrYAIeePM0cmH88QVMLbhQhReYVNAdPfjt71Bn1MB/2Y
rX1PpARF4LhAHWUNXJzNKhURAx19HR5N0RmYKyZwV7HPmXsml4cETbg1qzWLc4uv
vOSAJ+Y30K920DMHULhT9pGtwE/rvA5P0mO2+m4O8/f5VOCVrW84oirWEWdh33Xh
fTVVUGuM/uKJcEkzFbsq
=HrgX
-----END PGP SIGNATURE-----

--dTy3Mrz/UPE2dbVg--
