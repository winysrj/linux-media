Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58765 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751151AbdCNS0w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 14:26:52 -0400
Date: Tue, 14 Mar 2017 19:26:46 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
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
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v5 15/39] [media] v4l2: add a frame interval error event
Message-ID: <20170314182646.GB3744@amd>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <1489121599-23206-16-git-send-email-steve_longerbeam@mentor.com>
 <5b0a0e76-2524-4140-5ccc-380a8f949cfa@xs4all.nl>
 <ec05e6e0-79f2-2db2-bde9-4aed00d76faa@gmail.com>
 <6b574476-77df-0e25-a4d1-32d4fe0aec12@xs4all.nl>
 <5d5cf4a4-a4d3-586e-cd16-54f543dfcce9@gmail.com>
 <aa6a5a1d-18fd-8bed-a349-2654d2d1abe0@xs4all.nl>
 <20170313104538.GF21222@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="aM3YZ0Iwxop3KEKx"
Content-Disposition: inline
In-Reply-To: <20170313104538.GF21222@n2100.armlinux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--aM3YZ0Iwxop3KEKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2017-03-13 10:45:38, Russell King - ARM Linux wrote:
> On Mon, Mar 13, 2017 at 11:02:34AM +0100, Hans Verkuil wrote:
> > On 03/11/2017 07:14 PM, Steve Longerbeam wrote:
> > > The event must be user visible, otherwise the user has no indication
> > > the error, and can't correct it by stream restart.
> >=20
> > In that case the driver can detect this and call vb2_queue_error. It's
> > what it is there for.
> >=20
> > The event doesn't help you since only this driver has this issue. So no=
body
> > will watch this event, unless it is sw specifically written for this So=
C.
> >=20
> > Much better to call vb2_queue_error to signal a fatal error (which this
> > apparently is) since there are more drivers that do this, and vivid sup=
ports
> > triggering this condition as well.
>=20
> So today, I can fiddle around with the IMX219 registers to help gain
> an understanding of how this sensor works.  Several of the registers
> (such as the PLL setup [*]) require me to disable streaming on the
> sensor while changing them.
>=20
> This is something I've done many times while testing various ideas,
> and is my primary way of figuring out and testing such things.
>=20
> Whenever I resume streaming (provided I've let the sensor stop
> streaming at a frame boundary) it resumes as if nothing happened.  If I
> stop the sensor mid-frame, then I get the rolling issue that Steve
> reports, but once the top of the frame becomes aligned with the top of
> the capture, everything then becomes stable again as if nothing happened.
>=20
> The side effect of what you're proposing is that when I disable streaming
> at the sensor by poking at its registers, rather than the capture just
> stopping, an error is going to be delivered to gstreamer, and gstreamer
> is going to exit, taking the entire capture process down.
>=20
> This severely restricts the ability to be able to develop and test
> sensor drivers.

Well, but kernel should do what is best for production, not what is
best for driver debugging.

And yes, I guess you can have #ifdef or module parameter or something
switching for behaviour you prefer when you are debugging. But for
production, vb2_queue_error() seems to be the right solution.

								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--aM3YZ0Iwxop3KEKx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAljINeYACgkQMOfwapXb+vK14QCbBgL8BWnvz975TIwHj1zYgdU3
Yc4AnRNhAYf0StYuCHTqTIHTfebPobdS
=9XSv
-----END PGP SIGNATURE-----

--aM3YZ0Iwxop3KEKx--
