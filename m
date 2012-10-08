Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:49161 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558Ab2JHMUf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Oct 2012 08:20:35 -0400
Received: by mail-la0-f46.google.com with SMTP id h6so2204196lag.19
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2012 05:20:32 -0700 (PDT)
Message-ID: <1349698816.9437.5.camel@deskari>
Subject: Re: [PATCH 1/2 v6] of: add helper to parse display timings
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Date: Mon, 08 Oct 2012 15:20:16 +0300
In-Reply-To: <1479122.2xVsV4MZ4o@avalon>
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de>
	 <Pine.LNX.4.64.1210081000530.11034@axis700.grange>
	 <1349686878.3227.40.camel@deskari> <1479122.2xVsV4MZ4o@avalon>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-VexL9VcUIvb49Fq4XdT3"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-VexL9VcUIvb49Fq4XdT3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-10-08 at 14:04 +0200, Laurent Pinchart wrote:
> Hi Tomi,
>=20
> On Monday 08 October 2012 12:01:18 Tomi Valkeinen wrote:
> > On Mon, 2012-10-08 at 10:25 +0200, Guennadi Liakhovetski wrote:
> > > In general, I might be misunderstanding something, but don't we have =
to
> > > distinguish between 2 types of information about display timings: (1)=
 is
> > > defined by the display controller requirements, is known to the displ=
ay
> > > driver and doesn't need to be present in timings DT. We did have some=
 of
> > > these parameters in board data previously, because we didn't have pro=
per
> > > display controller drivers... (2) is board specific configuration, an=
d is
> > > such it has to be present in DT.
> > >=20
> > > In that way, doesn't "interlaced" belong to type (1) and thus doesn't=
 need
> > > to be present in DT?
> >=20
> > As I see it, this DT data is about the display (most commonly LCD
> > panel), i.e. what video mode(s) the panel supports. If things were done
> > my way, the panel's supported timings would be defined in the driver fo=
r
> > the panel, and DT would be left to describe board specific data, but
> > this approach has its benefits.
>=20
> What about dumb DPI panels ? They will all be supported by a single drive=
r,=20
> would you have the driver contain information about all known DPI panels =
? DT=20
> seems a good solution to me in this case.

Yes, I would have a table in the driver for all the devices it supports,
which would describe the device specific parameters.

But I don't have a problem with DT solution. Both methods have their
pros and cons, and perhaps DT based solution is more practical.

> For complex panels where the driver will support a single (or very few) m=
odel=20
> I agree that specifying the timings in DT isn't needed.
>=20
> > Thus, if you connect an interlaced panel to your board, you need to tel=
l
> > the display controller that this panel requires interlace signal. Also,
> > pixel clock source doesn't make sense in this context, as this doesn't
> > describe the actual used configuration, but only what the panel
> > supports.
> >=20
> > Of course, if this is about describing the hardware, the default-mode
> > property doesn't really fit in...
>=20
> Maybe we should rename it to native-mode then ?

Hmm, right, if it means native mode, then it is describing the hardware.
But would it make sense to require that the native mode is the first
mode in the list, then? This would make the separate
default-mode/native-mode property not needed.

 Tomi


--=-VexL9VcUIvb49Fq4XdT3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQcsUAAAoJEPo9qoy8lh71k3oP/jJlOuMLK8YA71KFe0uEmA95
5vb3nyR32KJj1FLQFoBA/sSS/pnOE6DRK10dyEVmXAzL8pK86MxYzJ3hbHhJDpWx
qHYb3ptAnHIwqLBbHu4XDl8HGRBlhqLv97UGfctY6CuqKY9nEUeW/CVUUKaxdWVQ
F5TczV3I3V9LdU1Ugq5NmXCBrgZA5wp/D2+xE5y4R31338RzFk7aZQiZme3AHiXn
h4HjlkPnvfozzIyZnxYczgpLsUZFBkYQ56vK7IxPiAQtT8xFaz/OXiMI8hCzf2rT
YghONehW+IGSuy4iJRP5L7sg0d0RtgDFDEg4PhGztNat+4gjRNu7lV8/AFbigZQe
QMhK34mZ2mUnR9CLlvgWLd1otsak4HDd4tG9cRMOQU9v1iyhzal5WpENzmI5vARo
9mi4jW/4Tt6qDVEBSr/Criw/aKu8Ci3KBfc5nKNfAsdQh63ZwGKpLCN2y9EgM/oh
3SoTPwR6OQczFBwbtlLjjB4lo7LgERpC+101joAIDEu4EWgT6iSQR+ZfbAYSCCIM
yYLk50O73RfXkqBKFhFf4YGV91SNxh5jhsata/u3yxlnSOj+Wh3Olr/yTQAEB33r
k3vI8DgwPt0WyoxA/ZK2Zo5U5RWGYFpQdb9wfy8UZ51jtBTsZAERLne2p9uvu8UJ
mAd/QC8xPlv0SihkbHl1
=Z4g+
-----END PGP SIGNATURE-----

--=-VexL9VcUIvb49Fq4XdT3--

