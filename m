Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52034 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751498AbdCSNZG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Mar 2017 09:25:06 -0400
Date: Sun, 19 Mar 2017 14:25:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
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
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
Message-ID: <20170319132501.GA25673@amd>
References: <c679f755-52a6-3c6f-3d65-277db46676cc@xs4all.nl>
 <20170310140124.GV21222@n2100.armlinux.org.uk>
 <cc8900b0-c091-b14b-96f4-01f8fa72431c@xs4all.nl>
 <20170310125342.7f047acf@vento.lan>
 <20170310223714.GI3220@valkosipuli.retiisi.org.uk>
 <20170311082549.576531d0@vento.lan>
 <20170313124621.GA10701@valkosipuli.retiisi.org.uk>
 <20170314004533.3b3cd44b@vento.lan>
 <e0a6c60b-1735-de0b-21f4-d8c3f4b3f10f@xs4all.nl>
 <20170317114203.GZ21222@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <20170317114203.GZ21222@n2100.armlinux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2017-03-17 11:42:03, Russell King - ARM Linux wrote:
> On Tue, Mar 14, 2017 at 08:55:36AM +0100, Hans Verkuil wrote:
> > We're all very driver-development-driven, and userspace gets very little
> > attention in general. So before just throwing in the towel we should ta=
ke
> > a good look at the reasons why there has been little or no development:=
 is
> > it because of fundamental design defects, or because nobody paid attent=
ion
> > to it?
> >=20
> > I strongly suspect it is the latter.
> >=20
> > In addition, I suspect end-users of these complex devices don't really =
care
> > about a plugin: they want full control and won't typically use generic
> > applications. If they would need support for that, we'd have seen much =
more
> > interest. The main reason for having a plugin is to simplify testing and
> > if this is going to be used on cheap hobbyist devkits.
>=20
> I think you're looking at it with a programmers hat on, not a users hat.
>=20
> Are you really telling me that requiring users to 'su' to root, and then
> use media-ctl to manually configure the capture device is what most
> users "want" ?

If you want to help users, right way is to improve userland support.=20

> Hasn't the way technology has moved towards graphical interfaces,
> particularly smart phones, taught us that the vast majority of users
> want is intuitive, easy to use interfaces, and not the command line
> with reams of documentation?

How is it relevant to _kernel_ interfaces?
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAljOhq0ACgkQMOfwapXb+vJ9ywCgiLbs4zD6qCIbTw4hAUuhMtfs
Y58An3yuL1bl63dFNji5vJn59vsTQqvq
=+jHQ
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
