Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44221 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751084AbdBDV4O (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Feb 2017 16:56:14 -0500
Date: Sat, 4 Feb 2017 22:56:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>,
        laurent.pinchart@ideasonboard.com
Cc: robh+dt@kernel.org, devicetree@vger.kernel.org,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devicetree: Add video bus switch
Message-ID: <20170204215610.GA9243@amd>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
 <20161224152031.GA8420@amd>
 <20170203123508.GA10286@amd>
 <20170203130740.GB12291@valkosipuli.retiisi.org.uk>
 <20170203210610.GA18379@amd>
 <20170203213454.GD12291@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <20170203213454.GD12291@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > +Required properties
> > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > +
> > > > +compatible	: must contain "video-bus-switch"
> > >=20
> > > How generic is this? Should we have e.g. nokia,video-bus-switch? And =
if so,
> > > change the file name accordingly.
> >=20
> > Generic for "single GPIO controls the switch", AFAICT. But that should
> > be common enough...
>=20
> Um, yes. Then... how about: video-bus-switch-gpio? No Nokia prefix.

Ok, done. I also fixed the english a bit.

> > > > +reg		: The interface:
> > > > +		  0 - port for image signal processor
> > > > +		  1 - port for first camera sensor
> > > > +		  2 - port for second camera sensor
> > >=20
> > > I'd say this must be pretty much specific to the one in N900. You cou=
ld have
> > > more ports. Or you could say that ports beyond 0 are camera sensors. =
I guess
> > > this is good enough for now though, it can be changed later on with t=
he
> > > source if a need arises.
> >=20
> > Well, I'd say that selecting between two sensors is going to be the
> > common case. If someone needs more than two, it will no longer be
> > simple GPIO, so we'll have some fixing to do.
>=20
> It could be two GPIOs --- that's how the GPIO I2C mux works.
>=20
> But I'd be surprised if someone ever uses something like that
> again. ;-)

I'd say.. lets handle that when we see hardware like that.

> > > Btw. was it still considered a problem that the endpoint properties f=
or the
> > > sensors can be different? With the g_routing() pad op which is to be =
added,
> > > the ISP driver (should actually go to a framework somewhere) could pa=
rse the
> > > graph and find the proper endpoint there.
> >=20
> > I don't know about g_routing. I added g_endpoint_config method that
> > passes the configuration, and that seems to work for me.
> >=20
> > I don't see g_routing in next-20170201 . Is there place to look?
>=20
> I think there was a patch by Laurent to LMML quite some time ago. I suppo=
se
> that set will be repicked soonish.
>=20
> I don't really object using g_endpoint_config() as a temporary solution; =
I'd
> like to have Laurent's opinion on that though. Another option is to wait,
> but we've already waited a looong time (as in total).

Laurent, do you have some input here? We have simple "2 cameras
connected to one signal processor" situation here. We need some way of
passing endpoint configuration from the sensors through the switch. I
did this:

> > @@ -415,6 +416,8 @@ struct v4l2_subdev_video_ops {
> >                          const struct v4l2_mbus_config *cfg);
> >     int (*s_rx_buffer)(struct v4l2_subdev *sd, void *buf,
> >                        unsigned int *size);
> > +   int (*g_endpoint_config)(struct v4l2_subdev *sd,
> > +                       struct v4l2_of_endpoint *cfg);

Google of g_routing tells me:

9) Highly reconfigurable hardware - Julien Beraud

- 44 sub-devices connected with an interconnect.
- As long as formats match, any sub-device could be connected to any
- other sub-device through a link.
- The result is 44 * 44 links at worst.
- A switch sub-device proposed as the solution to model the
- interconnect. The sub-devices are connected to the switch
- sub-devices through the hardware links that connect to the
- interconnect.
- The switch would be controlled through new IOCTLs S_ROUTING and
- G_ROUTING.
- Patches available:
 http://git.linuxtv.org/cgit.cgi/pinchartl/media.git/log/?h=3Dxilinx-wip

but the patches are from 2005. So I guess I'll need some guidance here...

> I'll reply to the other patch containing the code.

Ok, thanks.
								Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAliWTfoACgkQMOfwapXb+vJGpgCaA11DUW57SgRdf3Xi9yAd4QmZ
sFMAn0Gga7IICyx1LzxFwUjzV8D/oJGH
=DVuo
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
