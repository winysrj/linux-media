Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932943AbcKCWst (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Nov 2016 18:48:49 -0400
Date: Thu, 3 Nov 2016 23:48:43 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Pavel Machek <pavel@ucw.cz>, ivo.g.dimitrov.75@gmail.com,
        pali.rohar@gmail.com, linux-media@vger.kernel.org,
        galak@codeaurora.org, mchehab@osg.samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161103224843.itxlvvotni6w6tmu@earth>
References: <20161023200355.GA5391@amd>
 <20161023201954.GI9460@valkosipuli.retiisi.org.uk>
 <20161023203315.GC6391@amd>
 <20161031225408.GB3217@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zmwegiqmnzmvaz7p"
Content-Disposition: inline
In-Reply-To: <20161031225408.GB3217@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--zmwegiqmnzmvaz7p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 01, 2016 at 12:54:08AM +0200, Sakari Ailus wrote:
> > > Thanks, this answered half of my questions already. ;-)
> > :-).
> >=20
> > I'll have to go through the patches, et8ek8 driver is probably not
> > enough to get useful video. platform/video-bus-switch.c is needed for
> > camera switching, then some omap3isp patches to bind flash and
> > autofocus into the subdevice.
> >=20
> > Then, device tree support on n900 can be added.
>=20
> I briefly discussed with with Sebastian.
>=20
> Do you think the elusive support for the secondary camera is worth keeping
> out the main camera from the DT in mainline? As long as there's a reasona=
ble
> way to get it working, I'd just merge that. If someone ever gets the
> secondary camera working properly and nicely with the video bus switch,
> that's cool, we'll somehow deal with the problem then. But frankly I don't
> think it's very useful even if we get there: the quality is really bad.

If we want to keep open the option to add proper support for the
second camera, we could also add the bus switch and not add the
front camera node in DT. Then adding the front camera does not
require DT or userspace API changes. It would need an additional
DT quirk in arch/arm/mach-omap2/board-generic.c for RX51, which
adds the CCP2 bus settings from the camera node to the bus
switch node to keep isp_of_parse_node happy. That should be
easy to implement and not add much delay in upstreaming.

For actually getting both cameras available with runtime-switching
the proper solution would probably involve moving the parsing of
the bus-settings to the sensor driver and providing a callback.
This callback can be called by omap3isp when it wants to configure
the phy (which is basically when it starts streaming). That seems
to be the only place needing the buscfg anyways.

Then the video-bus-switch could do something like this (pseudocode):

static void get_buscfg(struct *this, struct *buscfg) {
    if (selected_cam =3D=3D 0)
        return this->sensor_a->get_buscfg(buscfg);
    else
        return this->sensor_b->get_buscfg(buscfg);
}

Regarding the usefulness: I noticed, that the Neo900 people also
plan to have the bus-switch [0]. It's still the same crappy front-cam,
though. Nevertheless it might be useful for testing. It has nice
test-image capabilities, which might be useful for regression
testing once everything is in place.

[0] http://neo900.org/stuff/block-diagrams/neo900/neo900.html

-- Sebastian

--zmwegiqmnzmvaz7p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAABCgAGBQJYG77JAAoJENju1/PIO/qae/YP/0xsamp5rwVCPNHHEwjh2rAG
t9STcFP6F04Y6XOru41JpmNaVQnGKeuB9NBatoR4J1Ppg216Bxkj52scy1fYHV0O
31B1WSvfYzkeg6UOVbjguci/uJ/+Y4P5gDmVcCuTBGpT73t3AHUIvzZ7UclbQ7LT
jERpa80SILyCzxaDC477CD493v0awd4lmUatm6sSF15rslHaLQe1pF0gFNalqTWC
kJ5KsXGhaAZH+NFCDeI37COQhyC/ufM111IM6RIV8OIQAU5v94wVklzQAM3RjlXJ
g1r5WpdP8xE12P65wOfw9fuw4Pty26gxpB7XKcp1M3UXJzSY70+CiCCg6ZskJjCh
Wmu/wXW/2Ubmk2Y9wi9jfehoJkJVdoSd4Elbq4n7kXlFCwAoA+9ITyKSeVYHwjc/
wAefBoaLwCZwbn0aUMUrglK2gTssByrAKxZUt+Bv0+ECB4zvOFxG5qpmTrvrYtkS
JUsCwFMxoCTII35SPnKET86Oi+t6bkLWWeDAsR9ueCkyLheUwelWbPYJCvRQ+C39
4xmsk7lkluGBpHhFrL7/kIlzuAF42r3jckHDtiJmEmmT8fyFM7td7zE9XC1lOLX1
Rwbg4/Ny2Vvre2M7xJsg4oXh9ff8YNMOkvpCWEpIJj81pIn4CNUg7k4KBs/Mgz89
JeSTqBXD2U0XsnJnjfUp
=Hezf
-----END PGP SIGNATURE-----

--zmwegiqmnzmvaz7p--
