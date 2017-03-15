Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60688 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751100AbdCOSNA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 14:13:00 -0400
Date: Wed, 15 Mar 2017 19:04:21 +0100
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
Message-ID: <20170315180421.GA10206@amd>
References: <cc8900b0-c091-b14b-96f4-01f8fa72431c@xs4all.nl>
 <20170310125342.7f047acf@vento.lan>
 <20170310223714.GI3220@valkosipuli.retiisi.org.uk>
 <20170311082549.576531d0@vento.lan>
 <20170313124621.GA10701@valkosipuli.retiisi.org.uk>
 <20170314004533.3b3cd44b@vento.lan>
 <e0a6c60b-1735-de0b-21f4-d8c3f4b3f10f@xs4all.nl>
 <20170314072143.498cde9b@vento.lan>
 <20170314223254.GA7141@amd>
 <20170314215420.6fc63c67@vento.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <20170314215420.6fc63c67@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Well, I believe first question is: what applications would we want to
> > run on complex devices? Will sending control from video to subdevs
> > actually help?
>=20
> I would say: camorama, xawtv3, zbar, google talk, skype. If it runs
> with those, it will likely run with any other application.

I'll take a look when I'm at better internet access.

> > mplayer is useful for testing... but that one already works (after you
> > setup the pipeline, and configure exposure/gain).
> >=20
> > But thats useful for testing, not really for production. Image will be
> > out of focus and with wrong white balance.
> >=20
> > What I would really like is an application to get still photos. For
> > taking pictures with manual settings we need
> >=20
> > a) units for controls: user wants to focus on 1m, and take picture
> > with ISO200, 1/125 sec. We should also tell him that lens is f/5.6 and
> > focal length is 20mm with 5mm chip.
> >=20
> > But... autofocus/autogain would really be good to have. Thus we need:
> >=20
> > b) for each frame, we need exposure settings and focus position at
> > time frame was taken. Otherwise autofocus/autogain will be too
> > slow. At least focus position is going to be tricky -- either kernel
> > would have to compute focus position for us (not trivial) or we'd need
> > enough information to compute it in userspace.
> >=20
> > There are more problems: hardware-accelerated preview is not trivial
> > to set up (and I'm unsure if it can be done in generic way). Still
> > photos application needs to switch resolutions between preview and
> > photo capture. Probably hardware-accelerated histograms are needed for
> > white balance, auto gain and auto focus, ....
> >=20
> > It seems like there's a _lot_ of stuff to be done before we have
> > useful support for complex cameras...
>=20
> Taking still pictures using a hardware-accelerated preview is
> a sophisticated use case. I don't know any userspace application
> that does that. Ok, several allow taking snapshots, by simply
> storing the image of the current frame.

Well, there are applications that take still pictures. Android has
one. Maemo has another. Then there's fcam-dev. Its open source; with
modified kernel it is fully usable. I have version that runs on recent
nearly-mainline on N900.=20

So yes, I'd like solution for problems a) and b).

> > (And I'm not sure... when application such as skype is running, is
> > there some way to run autogain/autofocus/autowhitebalance? Is that
> > something we want to support?)
>=20
> Autofocus no. Autogain/Autowhite can be done via libv4l, provided that
> it can access the device's controls via /dev/video devnode. Other
> applications may be using some other similar algorithms.
>=20
> Ok, they don't use histograms provided by the SoC. So, they do it in
> software, with is slower. Still, it works fine when the light
> conditions don't change too fast.

I guess it is going to work well enough with higher CPU
usage. Question is if camera without autofocus is usable. I'd say "not
really".

> > I believe other question is: will not having same control on main
> > video device and subdevs be confusing? Does it actually help userspace
> > in any way? Yes, we can make controls accessible to old application,
> > but does it make them more useful?=20
>=20
> Yes. As I said, libv4l (and some apps) have logic inside to adjust
> the image via bright, contrast and white balance controls, using the
> video devnode. They don't talk subdev API. So, if those controls
> aren't exported, they won't be able to provide a good quality image.

Next question is if the libv4l will do the right thing if we just put
all controls to one node. For example on N900 you have exposure/gain
and brightness. But the brightness is applied at preview phase, so it
is "basically useless". You really need to adjust the image using the
exposure/gain.

> > > > In addition, I suspect end-users of these complex devices don't rea=
lly care
> > > > about a plugin: they want full control and won't typically use gene=
ric
> > > > applications. If they would need support for that, we'd have seen m=
uch more
> > > > interest. The main reason for having a plugin is to simplify testin=
g and
> > > > if this is going to be used on cheap hobbyist devkits. =20
> > >=20
> > > What are the needs for a cheap hobbyist devkit owner? Do we currently
> > > satisfy those needs? I'd say that having a functional driver when
> > > compiled without the subdev API, that implements the ioctl's/controls=
 =20
> >=20
> > Having different interface based on config options... is just
> > weird. What about poor people (like me) trying to develop complex
> > applications?
>=20
> Well, that could be done using other mechanisms, like a modprobe
> parameter or by switching the behaviour if a subdev interface is
> opened. I don't see much trouble on allowing accessing a control via
> both interfaces.

If we really want to go that way (is not modifying library to access
the right files quite easy?), I believe non-confusing option would be
to have '/dev/video0 -- omap3 camera for legacy applications' which
would include all the controls.

> > You can get Nokia N900 on aliexpress. If not, they are still available
> > between people :-)
>=20
> I have one. Unfortunately, I never had a chance to use it, as the display
> stopped working one week after I get it.

Well, I guess the easiest option is to just get another one :-).

But otoh -- N900 is quite usable without the screen. 0xffff tool can
be used to boot the kernel, then you can use nfsroot and usb
networking. It also has serial port (over strange
connector). Connected over ssh over usb network is actually how I do
most of the v4l work.

Best regards,

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAljJgiUACgkQMOfwapXb+vLTRQCgu9VfJ8AJHxCkc+5HU2zw0axk
lhoAnjKtfqjUbafgmhVm/jE3vbRotrCg
=Dyg1
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
