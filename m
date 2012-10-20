Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:54319 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab2JTKqW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Oct 2012 06:46:22 -0400
Date: Sat, 20 Oct 2012 12:45:51 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	linux-fbdev@vger.kernel.org,
	Stephen Warren <swarren@wwwdotorg.org>,
	devicetree-discuss@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2 v6] of: add generic videomode description
Message-ID: <20121020104551.GA12545@avionic-0098.mockup.avionic-design.de>
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de>
 <506DDA94.1090702@wwwdotorg.org>
 <20121005155121.GA2053@pengutronix.de>
 <1865954.iaNNHHSnLW@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <1865954.iaNNHHSnLW@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 07, 2012 at 03:38:33PM +0200, Laurent Pinchart wrote:
> Hi Steffen,
>=20
> On Friday 05 October 2012 17:51:21 Steffen Trumtrar wrote:
> > On Thu, Oct 04, 2012 at 12:51:00PM -0600, Stephen Warren wrote:
> > > On 10/04/2012 11:59 AM, Steffen Trumtrar wrote:
> > > > Get videomode from devicetree in a format appropriate for the
> > > > backend. drm_display_mode and fb_videomode are supported atm.
> > > > Uses the display signal timings from of_display_timings
> > > >=20
> > > > +++ b/drivers/of/of_videomode.c
> > > >=20
> > > > +int videomode_from_timing(struct display_timings *disp, struct
> > > > videomode *vm,
> > > >=20
> > > > +	st =3D display_timings_get(disp, index);
> > > > +
> > > > +	if (!st) {
> > >=20
> > > It's a little odd to leave a blank line between those two lines.
> >=20
> > Hm, well okay. That can be remedied
> >=20
> > > Only half of the code in this file seems OF-related; the routines to
> > > convert a timing to a videomode or drm display mode seem like they'd =
be
> > > useful outside device tree, so I wonder if putting them into
> > > of_videomode.c is the correct thing to do. Still, it's probably not a
> > > big deal.
> >=20
> > I am not sure, what the appropriate way to do this is. I can split it up
> > (again).
>=20
> I think it would make sense to move them to their respective subsystems.

I agree. While looking at integrating this for Tegra DRM, I came across
the issue that if I build DRM as a module, linking with this code will
fail. The reason for that was that it was that the code, itself builtin,
uses drm_mode_set_name(), which would be exported by the drm module. So
I had to modifiy the Kconfig entries to be "def_tristate DRM". That
obviously isn't very nice since the code can also be used without DRM.

Moving the subsystem specific conversion routines to the respective
subsystems should solve any of these issues.

Thierry

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQgoDfAAoJEN0jrNd/PrOhQF0P/1vtiiNgVpJUZGNyEiKprALw
JgZwmZFDnplp3SENN6Nr90DOIGPbfJjR+8iDa5jJ7MACBAxaNWbGQLbieSdU8IBN
Ewu90o2+CPasE9CqGYrUD/hokzIm9H6gSW+N6qCIWl41raGBF33KIrosQEDlPInv
L0k+SIj7fXTt/TjDYZl0k6tucpyh3HaZ+4qh2uemEy2XpJKXQAZwMqFLMWLnipG1
GFqVLptJlZHeC+VGFylqFl5O07RRrkMwsFGetVDbilPInHv+tkTgOHfet10b2opY
yP8Y54OMoMI/R7Yh9SRgzwiJTgCs2QANwx7nx+lGgsuRos5YVXyKw31xZkN9ZW2R
xRyDTZvZdW5NJsXGzPU/ottirVr0CbUJydVpoPEVzWvQ0xt5yoxN1q3xmqA0L8d2
tTYb8de7m6iZdjFmamXdbqpb+Q7evZQvpH9C8VQ1SscMlA3uu0jTjVa6IsRMcyc2
cA/vToEZklJ8Henae+yKBsRlNx8XBgYtqWn+6M5E47fHzN0t05ZER3YRFQSjT77B
Z0dP0PpVDUcKkTwNUj2dKSsHt5QIniK2ae1owWRWckSIWnvNfnvtpXVDPkSZb8FJ
mAERsNQUO6vDp9z8k2a8vK+E/tpY0sCozmK/JHySS1OSAFXfpv8/nkmu8gL22vV4
pIchLUB6DowQNYob45ao
=XnRW
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
