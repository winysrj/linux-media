Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53394 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756263AbdLVJYy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Dec 2017 04:24:54 -0500
Date: Fri, 22 Dec 2017 10:24:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, ivo.g.dimitrov.75@gmail.com,
        sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        galak@codeaurora.org, mchehab@osg.samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devicetree: Add video bus switch
Message-ID: <20171222092452.GA16581@amd>
References: <20161023200355.GA5391@amd>
 <20170203213454.GD12291@valkosipuli.retiisi.org.uk>
 <20170204215610.GA9243@amd>
 <75694885.3PuLWzx4qN@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <75694885.3PuLWzx4qN@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > I don't really object using g_endpoint_config() as a temporary soluti=
on;
> > > I'd like to have Laurent's opinion on that though. Another option is =
to
> > > wait, but we've already waited a looong time (as in total).
> >=20
> > Laurent, do you have some input here? We have simple "2 cameras
> > connected to one signal processor" situation here. We need some way of
> > passing endpoint configuration from the sensors through the switch. I
> > did this:
>=20
> Could you give me a bit more information about the platform you're target=
ing:=20
> how the switch is connected, what kind of switch it is, and what endpoint=
=20
> configuration data you need ?

Platform is Nokia N900, Ivaylo already gave pointer to schematics.

Switch is controlled using GPIO, and basically there's CSI
configuration that would normally be in the device tree, but now we
have two CSI configurations to select from...

> > 9) Highly reconfigurable hardware - Julien Beraud
> >=20
> > - 44 sub-devices connected with an interconnect.
> > - As long as formats match, any sub-device could be connected to any
> > - other sub-device through a link.
> > - The result is 44 * 44 links at worst.
> > - A switch sub-device proposed as the solution to model the
> > - interconnect. The sub-devices are connected to the switch
> > - sub-devices through the hardware links that connect to the
> > - interconnect.
> > - The switch would be controlled through new IOCTLs S_ROUTING and
> > - G_ROUTING.
> > - Patches available:
> >  http://git.linuxtv.org/cgit.cgi/pinchartl/media.git/log/?h=3Dxilinx-wip
> >=20
> > but the patches are from 2005. So I guess I'll need some guidance here.=
=2E.
>=20
> You made me feel very old for a moment. The patches are from 2015 :-)

Sorry about that :-).
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlo8z2QACgkQMOfwapXb+vJsZgCbBTP/TSZqeMt9ztNZwy8vgxeo
Dv0AoJlt7/yNRop9DRe4vJWCTXucHDJy
=Ec4d
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
