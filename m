Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56917 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934303AbdCJV5m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 16:57:42 -0500
Date: Fri, 10 Mar 2017 22:57:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Fabio Estevam <festevam@gmail.com>
Cc: Troy Kisky <troy.kisky@boundarydevices.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        mchehab@kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Nick Dyer <nick@shmanahar.org>, markus.heiser@darmarit.de,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        bparrot@ti.com, Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        minghsiu.tsai@mediatek.com, Tiffany Lin <tiffany.lin@mediatek.com>,
        Jean-Christophe TROTIN <jean-christophe.trotin@st.com>,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        shuah@kernel.org, sakari.ailus@linux.intel.com,
        devel@driverdev.osuosl.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH v5 07/39] ARM: dts: imx6qdl-sabrelite: remove erratum
 ERR006687 workaround
Message-ID: <20170310215731.GB6540@amd>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <1489121599-23206-8-git-send-email-steve_longerbeam@mentor.com>
 <9f5d0ac4-0602-c729-5c00-1d9ef49247c1@boundarydevices.com>
 <CAOMZO5BNrSEyrbWbCBCbsy4yTrh4AHfk2Too0qHuffxqUCgADg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="MW5yreqqjyrRcusr"
Content-Disposition: inline
In-Reply-To: <CAOMZO5BNrSEyrbWbCBCbsy4yTrh4AHfk2Too0qHuffxqUCgADg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2017-03-10 16:17:28, Fabio Estevam wrote:
> On Fri, Mar 10, 2017 at 3:59 PM, Troy Kisky
> <troy.kisky@boundarydevices.com> wrote:
> > On 3/9/2017 8:52 PM, Steve Longerbeam wrote:
> >> There is a pin conflict with GPIO_6. This pin functions as a power
> >> input pin to the OV5642 camera sensor, but ENET uses it as the h/w
> >> workaround for erratum ERR006687, to wake-up the ARM cores on normal
> >> RX and TX packet done events. So we need to remove the h/w workaround
> >> to support the OV5642. The result is that the CPUidle driver will no
> >> longer allow entering the deep idle states on the sabrelite.
> >>
> >> This is a partial revert of
> >>
> >> commit 6261c4c8f13e ("ARM: dts: imx6qdl-sabrelite: use GPIO_6 for FEC
> >>                       interrupt.")
> >> commit a28eeb43ee57 ("ARM: dts: imx6: tag boards that have the HW work=
around
> >>                       for ERR006687")
> >>
> >> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> >> ---
> >>  arch/arm/boot/dts/imx6qdl-sabrelite.dtsi | 4 ----
> >>  1 file changed, 4 deletions(-)
> >>
> >> diff --git a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi b/arch/arm/boot/=
dts/imx6qdl-sabrelite.dtsi
> >> index 8413179..89dce27 100644
> >> --- a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
> >> +++ b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
> >> @@ -270,9 +270,6 @@
> >>       txd1-skew-ps =3D <0>;
> >>       txd2-skew-ps =3D <0>;
> >>       txd3-skew-ps =3D <0>;
> >
> > How about
> >
> > +#if !IS_ENABLED(CONFIG_VIDEO_OV5642)

dts is supposed to be hardware description.

> Or maybe just create a new device tree for using the camera, like
> imx6q-sabrelite-camera.dts.

And it should not depend on configuration. Hardware vendor should be
able to ship board with working device tree...

									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--MW5yreqqjyrRcusr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAljDIUsACgkQMOfwapXb+vK6eQCfalP+qOUXROn/DqpnUJ1m+F+K
gesAnjzHVrD23JJklCM2vSrD4uDreyPU
=Ttsd
-----END PGP SIGNATURE-----

--MW5yreqqjyrRcusr--
