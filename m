Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43683 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751047AbeEQIuN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 04:50:13 -0400
Date: Thu, 17 May 2018 10:50:11 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Sam Bobrowicz <sam@elite-embedded.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: Re: [PATCH v2 00/12] media: ov5640: Misc cleanup and improvements
Message-ID: <20180517085011.o4adlrbpdb5okbwk@flea>
References: <20180416123701.15901-1-maxime.ripard@bootlin.com>
 <CAFwsNOGBYxJUKpWCLacBJ04Da2-q3vnSjY4shuV3xExHN4Fqpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ivuzqlpa5ixl34rg"
Content-Disposition: inline
In-Reply-To: <CAFwsNOGBYxJUKpWCLacBJ04Da2-q3vnSjY4shuV3xExHN4Fqpg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ivuzqlpa5ixl34rg
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, May 07, 2018 at 06:00:55PM -0700, Sam Bobrowicz wrote:
> > Hi,
> >
> > Here is a "small" series that mostly cleans up the ov5640 driver code,
> > slowly getting rid of the big data array for more understandable code
> > (hopefully).
> >
> > The biggest addition would be the clock rate computation at runtime,
> > instead of relying on those arrays to setup the clock tree
> > properly. As a side effect, it fixes the framerate that was off by
> > around 10% on the smaller resolutions, and we now support 60fps.
> >
> > This also introduces a bunch of new features.
> >
> > Let me know what you think,
> > Maxime
> >
> > Changes from v1:
> >   - Integrated Hugues' suggestions to fix v4l2-compliance
> >   - Fixed the bus width with JPEG
> >   - Dropped the clock rate calculation loops for something simpler as
> >     suggested by Sakari
> >   - Cache the exposure value instead of using the control value
> >   - Rebased on top of 4.17
> >
> > Maxime Ripard (10):
> >   media: ov5640: Don't force the auto exposure state at start time
> >   media: ov5640: Init properly the SCLK dividers
> >   media: ov5640: Change horizontal and vertical resolutions name
> >   media: ov5640: Add horizontal and vertical totals
> >   media: ov5640: Program the visible resolution
> >   media: ov5640: Adjust the clock based on the expected rate
> >   media: ov5640: Compute the clock rate at runtime
> >   media: ov5640: Enhance FPS handling
> >   media: ov5640: Add 60 fps support
> >   media: ov5640: Remove duplicate auto-exposure setup
> >
> > Myl=E8ne Josserand (2):
> >   media: ov5640: Add auto-focus feature
> >   media: ov5640: Add light frequency control
> >
> >  drivers/media/i2c/ov5640.c | 752 +++++++++++++++++++++----------------
> >  1 file changed, 422 insertions(+), 330 deletions(-)
> >
> > --
> > 2.17.0
> >
>=20
> As discussed, MIPI required some additional work. Please see the
> patches here which add support for MIPI:
> https://www.dropbox.com/s/73epty7808yzq1t/ov5640_mipi_fixes.zip?dl=3D0
>=20
> The first 3 patches are fixes I believe should be made to earlier
> patches prior to submitting v2 of this series. The remaining 4 patches
> should probably just be added onto the end of this series as-is (or
> with feedback incorporated if needed).
>=20
> I will note that this is still not working correctly on my system for
> any resolution that requires a 672 Mbps mipi rate. This includes
> 1080p@30hz, full@15hz, and 720p@60hz. My CSI2 receiver is reporting
> CRC errors though, so this could be an integrity issue on my module.
> I'm curious to hear if others have success at these resolutions.
>=20
> Please try this out on other MIPI and DVP platforms with as many
> different resolutions as possible and let me know if it works.

I've took some of your changes to remain as feature stable as possible
in my series. Some other changes (like the PLL2 setup), while totally
welcome, should be in a separate, subsequent series.

DVP works as expected, after looking at the feedback from Loic (and
the clock tree especially), some of the comments you made (like the
bit divider being meaningless for DVP) are not totally accurate, so
I've tried to make the best blend of all the feedback you gave. It
still works properly with DVP, but I still don't have a MIPI camera to
test, so I'm not sure this works, even though I should have the same
setup than the one you reported.

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--ivuzqlpa5ixl34rg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlr9QkIACgkQ0rTAlCFN
r3QY1g//YKvfpV1Vx9hFZQojfieJCSVSkfSewNB2Vf4w+G0Gv7DV5B/zAQsh5ya3
EHp299pLAlg/NmtbTiQWTGRiTP9Mfgxm8EyH8gkmabPaP7ghRLoXSAlAMUHSYysJ
WXpdkQwxPCH8b2CjPdBWmPcX08KNWkoT136NdqhyRbI0K1ptKCK6imySxsSMLQHb
MamMjPZfNhh5UFTtL26JdhM/TkUldoo5Xml/Gas3AysK0Irntz7Y2XfJ2FcU+NAh
QKfKZTASU6GsyIPZNrRQRE+8muZuasBiSNU4k7UVIsDr+wtYXphk0LjTCXAdCIR1
Ew3y2tlmCjRRKgiIRfi2nde0bKCwYVmfw93F1Nl+WkkabVnWExMUzod/0InYLAq1
CKXXLEwWuA34v4LF2KUxU3ZUdw+2O7TpMxsnLL3XffZ14WtCAtbi9d+815ch37bH
px45iyCYNwKWbRSdvSS4zkoXdiQcZEpYbEum5nmLgTKgw1YZES4UOkooAc9ixg7r
ugoB/YxssQ64KxIGeabkLIGD5/3ZcQfI0NGBXRKWxvHChfPxkQzEJ3dVzB1CCURl
NhIlSY5OtIGuRUCOfRYjJoVnMhtpd2J65b+CYiGJoZzOxgzHZIVz8aMkyUaSdI6R
wmNWXcqrBLcTkZ1ybwXi8XBRQi9SX+Zb3gDT33eqCWzaMs0DHGg=
=A9Wk
-----END PGP SIGNATURE-----

--ivuzqlpa5ixl34rg--
