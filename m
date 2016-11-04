Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754631AbcKDAFc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Nov 2016 20:05:32 -0400
Date: Fri, 4 Nov 2016 01:05:25 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Pavel Machek <pavel@ucw.cz>, ivo.g.dimitrov.75@gmail.com,
        pali.rohar@gmail.com, linux-media@vger.kernel.org,
        galak@codeaurora.org, mchehab@osg.samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161104000525.jzouapxxwwiwdwjy@earth>
References: <20161023200355.GA5391@amd>
 <20161023201954.GI9460@valkosipuli.retiisi.org.uk>
 <20161023203315.GC6391@amd>
 <20161031225408.GB3217@valkosipuli.retiisi.org.uk>
 <20161103224843.itxlvvotni6w6tmu@earth>
 <20161103230501.GJ3217@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ur2q4tqgacezmbkv"
Content-Disposition: inline
In-Reply-To: <20161103230501.GJ3217@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ur2q4tqgacezmbkv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Nov 04, 2016 at 01:05:01AM +0200, Sakari Ailus wrote:
> On Thu, Nov 03, 2016 at 11:48:43PM +0100, Sebastian Reichel wrote:
> > On Tue, Nov 01, 2016 at 12:54:08AM +0200, Sakari Ailus wrote:
> > > > > Thanks, this answered half of my questions already. ;-)
> > > > :-).
> > > >=20
> > > > I'll have to go through the patches, et8ek8 driver is probably not
> > > > enough to get useful video. platform/video-bus-switch.c is needed f=
or
> > > > camera switching, then some omap3isp patches to bind flash and
> > > > autofocus into the subdevice.
> > > >=20
> > > > Then, device tree support on n900 can be added.
> > >=20
> > > I briefly discussed with with Sebastian.
> > >=20
> > > Do you think the elusive support for the secondary camera is worth ke=
eping
> > > out the main camera from the DT in mainline? As long as there's a rea=
sonable
> > > way to get it working, I'd just merge that. If someone ever gets the
> > > secondary camera working properly and nicely with the video bus switc=
h,
> > > that's cool, we'll somehow deal with the problem then. But frankly I =
don't
> > > think it's very useful even if we get there: the quality is really ba=
d.
> >=20
> > If we want to keep open the option to add proper support for the
> > second camera, we could also add the bus switch and not add the
> > front camera node in DT. Then adding the front camera does not
> > require DT or userspace API changes. It would need an additional
> > DT quirk in arch/arm/mach-omap2/board-generic.c for RX51, which
> > adds the CCP2 bus settings from the camera node to the bus
> > switch node to keep isp_of_parse_node happy. That should be
> > easy to implement and not add much delay in upstreaming.
>=20
> By adding the video bus switch we have a little bit more complex system a=
s a
> whole. The V4L2 async does not currently support this. There's more here:
>=20
> <URL:http://www.spinics.net/lists/linux-media/msg107262.html>

I'm not sure what part relevant for video-bus-switch is currently
not supported?

video-bus-switch registers its own async notifier and only registers
itself as subdevices to omap3isp, once its own subdevices have been
registered successfully.

> What I thought was that once we have everything that's required in
> place, we can just change what's in DT. But the software needs to
> continue to work with the old DT content.

Right, so DT is not a problem. But adding the switch would change
the media-graph, which is exposed to userspace.

> > For actually getting both cameras available with runtime-switching
> > the proper solution would probably involve moving the parsing of
> > the bus-settings to the sensor driver and providing a callback.
> > This callback can be called by omap3isp when it wants to configure
> > the phy (which is basically when it starts streaming). That seems
> > to be the only place needing the buscfg anyways.
> >=20
> > Then the video-bus-switch could do something like this (pseudocode):
> >=20
> > static void get_buscfg(struct *this, struct *buscfg) {
> >     if (selected_cam =3D=3D 0)
> >         return this->sensor_a->get_buscfg(buscfg);
> >     else
> >         return this->sensor_b->get_buscfg(buscfg);
> > }
> >=20
> > Regarding the usefulness: I noticed, that the Neo900 people also
> > plan to have the bus-switch [0]. It's still the same crappy front-cam,
> > though. Nevertheless it might be useful for testing. It has nice
> > test-image capabilities, which might be useful for regression
> > testing once everything is in place.
> >=20
> > [0] http://neo900.org/stuff/block-diagrams/neo900/neo900.html
>=20
> Seriously? I suppose there should be no need for that anymore, is there?
>=20
> I think they wanted to save one GPIO in order to shave off 0,0001 cents f=
rom
> the manufacturing costs or something like that. And the result is...
> painful. :-I

CSI1/CCP2 is more than a single I/O pin, isn't it? Or do you
reference to the GPIO dual use to enable frontcam and switch
between the cameras? That is indeed a really ugly solution :(

-- Sebastian

--ur2q4tqgacezmbkv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAABCgAGBQJYG9DAAAoJENju1/PIO/qaG2sP/iH6iX23I9YpuZLuvAzrzSSy
GjsumpwBQGwo/CFh73JFiqnVu+bjru3bGxaGfH/IVM3wSQmT50usPz/pg7jf24y6
hGnk7KMEhkSl98eE9UuHMtBF/4OFEZKIPsa341wGHy2gQinAu/xMR1bUTFrOOR7M
RsMSbKPCF2zuIyvbV0YECEQ7BiKK0SelQCrPkz/0bI2iEynWDl36XzWk0hED2Pnw
zod3OqD+9L55xK1Jb4OuVfQR6/BARKzVAAGHTdIc0eBBwfo0qU7Fhu6ef1YGMoEn
2L9zJ0vFSOTIk3wlwPQvquhI10aYAkfp/f66GGhxR+Rvg0jY6SU5sErYNr5bDbbh
LIn1OXF86gt3vuoUYt+6CUT7uSiDBNMUHo6OOa0sZUdI5hus2uS/d9/6SxXD1OZo
RhzZnIQeSHfbtcbuz3IBWlXJIJBDmLzlDIXYSZAXN7Mzfr/A7L4yHDse4AtQiTK7
cEyC3SmNQ83reTi08g0XUKoF8Rlbap7TTWmunBPaCQVkqrqoJDuH4kuekaOuK5uE
yqBCn2Y/GQbqu9TLQuJg1NUhQImqkChmGPiPTYHjvsGcgPimsco8HQrLPGNRaYfL
WkOH60sCq0qcEEZwDK8NdthzqQU3zh09oq7GIf7/dTrR1ez0RNheJo/Aev3kDlaG
jgJallj6hbaXB9U7awPP
=dy9I
-----END PGP SIGNATURE-----

--ur2q4tqgacezmbkv--
