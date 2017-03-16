Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39226 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752681AbdCPWLe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Mar 2017 18:11:34 -0400
Date: Thu, 16 Mar 2017 23:11:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, nick@shmanahar.org,
        markus.heiser@darmarIT.de, p.zabel@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: Re: media / v4l2-mc: wishlist for complex cameras (was Re: [PATCH v4
 14/36] [media] v4l2-mc: add a function to inherit controls from a pipeline)
Message-ID: <20170316221122.GA31588@amd>
References: <20170310223714.GI3220@valkosipuli.retiisi.org.uk>
 <20170311082549.576531d0@vento.lan>
 <20170313124621.GA10701@valkosipuli.retiisi.org.uk>
 <20170314004533.3b3cd44b@vento.lan>
 <e0a6c60b-1735-de0b-21f4-d8c3f4b3f10f@xs4all.nl>
 <20170314072143.498cde9b@vento.lan>
 <20170314223254.GA7141@amd>
 <20170314215420.6fc63c67@vento.lan>
 <20170315180421.GA10206@amd>
 <20170315172627.6b7cc955@vento.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20170315172627.6b7cc955@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > mplayer is useful for testing... but that one already works (after =
you
> > > > setup the pipeline, and configure exposure/gain).
> > > >=20
> > > > But thats useful for testing, not really for production. Image will=
 be
> > > > out of focus and with wrong white balance.
> > > >=20
> > > > What I would really like is an application to get still photos. For
> > > > taking pictures with manual settings we need
> > > >=20
> > > > a) units for controls: user wants to focus on 1m, and take picture
> > > > with ISO200, 1/125 sec. We should also tell him that lens is f/5.6 =
and
> > > > focal length is 20mm with 5mm chip.
> > > >=20
> > > > But... autofocus/autogain would really be good to have. Thus we nee=
d:
> > > >=20
> > > > b) for each frame, we need exposure settings and focus position at
> > > > time frame was taken. Otherwise autofocus/autogain will be too
> > > > slow. At least focus position is going to be tricky -- either kernel
> > > > would have to compute focus position for us (not trivial) or we'd n=
eed
> > > > enough information to compute it in userspace.
> > > >=20
> > > > There are more problems: hardware-accelerated preview is not trivial
> > > > to set up (and I'm unsure if it can be done in generic way). Still
> > > > photos application needs to switch resolutions between preview and
> > > > photo capture. Probably hardware-accelerated histograms are needed =
for
> > > > white balance, auto gain and auto focus, ....
> > > >=20
> > > > It seems like there's a _lot_ of stuff to be done before we have
> > > > useful support for complex cameras... =20
> > >=20
> > > Taking still pictures using a hardware-accelerated preview is
> > > a sophisticated use case. I don't know any userspace application
> > > that does that. Ok, several allow taking snapshots, by simply
> > > storing the image of the current frame. =20
> >=20
> > Well, there are applications that take still pictures. Android has
> > one. Maemo has another. Then there's fcam-dev. Its open source; with
> > modified kernel it is fully usable. I have version that runs on recent
> > nearly-mainline on N900.=20
>=20
> Hmm... it seems that FCam is specific for N900:
> 	http://fcam.garage.maemo.org/
>=20
> If so, then we have here just the opposite problem, if want it to be
> used as a generic application, as very likely it requires OMAP3-specific
> graph/subdevs.

Well... there's quick and great version on maemo.org. I do have local
version (still somehow N900-specific), but it no longer uses hardware
histogram/sharpness support. Should be almost generic.

> > So yes, I'd like solution for problems a) and b).

=2E..but it has camera parameters hardcoded (problem a) and slow
(problem b).=20

> > Question is if camera without autofocus is usable. I'd say "not
> > really".qv4l2
>=20
> That actually depends on the sensor and how focus is adjusted.
>=20
> I'm testing right now this camera module for RPi:
>    https://www.raspberrypi.org/products/camera-module-v2/
>=20
> I might be wrong, but this sensor doesn't seem to have auto-focus.
> Instead, it seems to use a wide-angle lens. So, except when the
> object is too close, the focus look OK.

Well, cameras without autofocus are somehow usable without
autofocus. But cameras with autofocus don't work too well without one.

> > If we really want to go that way (is not modifying library to access
> > the right files quite easy?), I believe non-confusing option would be
> > to have '/dev/video0 -- omap3 camera for legacy applications' which
> > would include all the controls.
>=20
> Yeah, keeping /dev/video0 reserved for generic applications is something
> that could work. Not sure how easy would be to implement it.

Plus advanced applications would just ignore /dev/video0.. and not be confu=
sed.

> > > > > > You can get Nokia N900 on aliexpress. If not, they are still av=
ailable
> > > > between people :-) =20
> > >=20
> > > I have one. Unfortunately, I never had a chance to use it, as the dis=
play
> > > stopped working one week after I get it. =20
> >=20
> > Well, I guess the easiest option is to just get another one :-).
>=20
> :-)  Well, I guess very few units of N900 was sold in Brazil. Importing
> one is too expensive, due to taxes.

Try to ask at local mailing list. Those machines were quite common.

> > But otoh -- N900 is quite usable without the screen. 0xffff tool can
> > be used to boot the kernel, then you can use nfsroot and usb
> > networking. It also has serial port (over strange
> > connector). Connected over ssh over usb network is actually how I do
> > most of the v4l work.
>=20
> If you pass me the pointers, I can try it when I have some time.

Ok, I guess I'll do that in private email.

> Anyway, I got myself an ISEE IGEPv2, with the expansion board:
> 	https://www.isee.biz/products/igep-processor-boards/igepv2-dm3730
> 	https://www.isee.biz/products/igep-expansion-boards/igepv2-expansion
>=20
> The expansion board comes with a tvp5150 analog TV demod. So, with
> this device, I can simply connect it to a composite input signal.
> I have some sources here that I can use to test it.

Well... it looks like TV capture is a "solved" problem. Taking useful
photos is what is hard...


									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAljLDYoACgkQMOfwapXb+vLuxgCgioDKBFPW0CY5+q+9qy7KLVu+
YXsAnA1T4q6VZAJcB0AR0khbSR5/eSKo
=A/Nh
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
