Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:51122 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab2KMTRj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 14:17:39 -0500
Date: Tue, 13 Nov 2012 20:17:26 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mitch Bradley <wmb@firmworks.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
	linux-fbdev@vger.kernel.org, kernel@pengutronix.de,
	devicetree-discuss@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v8 2/6] video: add of helper for videomode
Message-ID: <20121113191726.GA3093@avionic-0098.mockup.avionic-design.de>
References: <1352734626-27412-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352734626-27412-3-git-send-email-s.trumtrar@pengutronix.de>
 <20121113110837.GA30049@avionic-0098.mockup.avionic-design.de>
 <50A2878D.8020707@wwwdotorg.org>
 <20121113175147.GA2597@avionic-0098.mockup.avionic-design.de>
 <50A28DCB.7050707@firmworks.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <50A28DCB.7050707@firmworks.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 13, 2012 at 08:13:31AM -1000, Mitch Bradley wrote:
> On 11/13/2012 7:51 AM, Thierry Reding wrote:
> > On Tue, Nov 13, 2012 at 10:46:53AM -0700, Stephen Warren wrote:
> >> On 11/13/2012 04:08 AM, Thierry Reding wrote:
> >>> On Mon, Nov 12, 2012 at 04:37:02PM +0100, Steffen Trumtrar wrote:
> >>>> This adds support for reading display timings from DT or/and
> >>>> convert one of those timings to a videomode. The
> >>>> of_display_timing implementation supports multiple children where
> >>>> each property can have up to 3 values. All children are read into
> >>>> an array, that can be queried. of_get_videomode converts exactly
> >>>> one of that timings to a struct videomode.
> >>
> >>>> diff --git
> >>>> a/Documentation/devicetree/bindings/video/display-timings.txt
> >>>> b/Documentation/devicetree/bindings/video/display-timings.txt
> >>
> >>>> + - clock-frequency: displayclock in Hz
> >>>
> >>> "display clock"?
> >>
> >> I /think/ I had suggested naming this clock-frequency before so that
> >> the property name would be more standardized; other bindings use that
> >> same name. But I'm not too attached to the name I guess.
> >=20
> > That's not what I meant. I think "displayclock" should be two words in
> > the description of the property. The property name is fine.
>=20
> Given that modern display engines often have numerous clocks, perhaps it
> would be better to use a more specific name, like for example "pixel-cloc=
k".

This binding is only about defining display modes. Are any of the clocks
that you're referring to relevant to the actual display modes?

Thierry

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQopzGAAoJEN0jrNd/PrOhhE4P/2TpIqIW9kYSa3x1ZFUNOqTa
6uuMnjXQIs/yEKla5T0A/ggBx+dqIr7qR3HkrhT32Mbijv/LcNTyc8F66EJg/UEp
QrgPkDdsuttcu0afLlVNhAvjm4vHGx3EHEjT+PChv4AkGPhJo5mW8lqPbsV+I+nU
QyHbefwR8CSEnrerymqB6oUGsagGDDqS0yt9Soaa2A7JxOd6KFOwdjWH9ssntnHI
sdspMrbh5xU2Yx26nbsJoEc6URCusWtQnYU7LKUxgTxP9R6dnE6X3AJrEpz5n2S3
cQ3fEhnFkjMVE7BhVrNtkRAsxveYVn1k+dvsFd0rULfC+UPLrGkVhGyaJK6Q5po4
oeC42BT2TvFcRZKYXdnlp3p4cRqhgv4T+tSMbKttsfp/GypHfUmzZJzwAoaR+pi1
Z4rzjryni3wFaTkeT0LEVAyGJRikgYHnedCXsJy5dvZUObEjzyok2JULDvymjwrO
ANEJaluI6irFqu1I82eOd7lMvSEx5nZlrvrpBh6T5HlHi1w77nZJ4FhT0tySJtm0
Xl016z7jJoQk3FQ3dPjwPiz7W+5GZuf1banpuIXe0InE2ml3eNvO0rflra1Qu7Hy
h5iN53mRx1Q9LBzsCx0m+DahmGG36vdu22N6ew62e5O29Glv3uBF9E78ARSF9SwB
NxPdWVxCOBzpMRTTyKLc
=ljl4
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
