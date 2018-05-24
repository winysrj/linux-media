Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:34473 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S970489AbeEXO7E (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 10:59:04 -0400
Date: Thu, 24 May 2018 16:59:02 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Daniel Mack <daniel@zonque.org>
Cc: Sam Bobrowicz <sam@elite-embedded.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH v3 03/12] media: ov5640: Remove the clocks registers
 initialization
Message-ID: <20180524145902.2iiyp2pxzedf7ane@flea>
References: <20180517085405.10104-1-maxime.ripard@bootlin.com>
 <20180517085405.10104-4-maxime.ripard@bootlin.com>
 <0de04d7b-9c75-3e4e-4cf9-deaedeab54a4@zonque.org>
 <CAFwsNOEkLU91qYtj=n_pd=kvvovXs6JTFiMFvwsMRvB0nY5H=g@mail.gmail.com>
 <20180521073902.ayky27k5pcyfyyvc@flea>
 <20180522195437.bay6muqp3uqq5k3z@flea>
 <f4948940-c3e1-5464-c012-e4d6ca196cdd@zonque.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lpns2gjluurk3v6u"
Content-Disposition: inline
In-Reply-To: <f4948940-c3e1-5464-c012-e4d6ca196cdd@zonque.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--lpns2gjluurk3v6u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 23, 2018 at 11:31:58AM +0200, Daniel Mack wrote:
> Hi Maxime,
>=20
> On Tuesday, May 22, 2018 09:54 PM, Maxime Ripard wrote:
> > On Mon, May 21, 2018 at 09:39:02AM +0200, Maxime Ripard wrote:
> > > On Fri, May 18, 2018 at 07:42:34PM -0700, Sam Bobrowicz wrote:
>=20
> > > > This set of patches is also not working for my MIPI platform (mine =
has
> > > > a 12 MHz external clock). I am pretty sure is isn't working because=
 it
> > > > does not include the following, which my tests have found to be
> > > > necessary:
> > > >=20
> > > > 1) Setting pclk period reg in order to correct DPHY timing.
> > > > 2) Disabling of MIPI lanes when streaming not enabled.
> > > > 3) setting mipi_div to 1 when the scaler is disabled
> > > > 4) Doubling ADC clock on faster resolutions.
> > >=20
> > > Yeah, I left them out because I didn't think this was relevant to this
> > > patchset but should come as future improvements. However, given that
> > > it works with the parallel bus, maybe the two first are needed when
> > > adjusting the rate.
> >=20
> > I've checked for the pclk period, and it's hardcoded to the same value
> > all the time, so I guess this is not the reason it doesn't work on
> > MIPI CSI anymore.
> >=20
> > Daniel, could you test:
> > http://code.bulix.org/ki6kgz-339327?raw
>=20
> [Note that there's a missing parenthesis in this snippet]

Sorry :/

> Hmm, no, that doesn't change anything. Streaming doesn't work here, even =
if
> I move ov5640_load_regs() before any other initialization.
>=20
> One of my test setup is the following gst pipeline:
>=20
>   gst-launch-1.0	\
> 	v4l2src device=3D/dev/video0 ! \
> 	videoconvert ! \
> 	video/x-raw,format=3DUYVY,width=3D1920,height=3D1080 ! \
> 	glimagesink
>=20
> With the pixel clock hard-coded to 166600000 in qcom camss, the setup wor=
ks
> on 4.14, but as I said, it broke already before this series with
> 5999f381e023 ("media: ov5640: Add horizontal and vertical
> totals").
>=20
> Frankly, my understanding of these chips is currently limited, so I don't
> really know where to start digging. It seems clear though that the timing
> registers setup is necessary for other register writes to succeed.
>=20
> Can I help in any other way?

If you feel like it, you could go through the various changes
(especially the pclk period I guess) changes Sam pushed in the
previous iteration to his dropbox. That's probably not going to be
quite easy to merge though, so that's going to require some manual
holding.

Sorry for not being able to help more than that :/

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--lpns2gjluurk3v6u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlsG0zUACgkQ0rTAlCFN
r3RzFQ//SfAn8XAPurKkSKj7KDmuJeDEls0hLn1uj4+nRGKNEAqNDDuXC2U62dNf
j3cnlqUEQfyYli0LegWR98CJGmtNknM6Yv/NpIFOpQ83rayGi5xBKysdpDnLlNYu
yol7U30PtAlTTlwr6JbSgwZTj3FZ4DGnpoTjj6KjL6pCpWottnOqpffIJuJ4+4Nn
ZEPpj1Rk79fXh9+h7+PpwkjPBH6vJ4X8Tj5IPiMIE362i0C20lOAW1ByKxe5YweT
SJyxJtjuRlVgk3uSPkY4BwPf3Wr6vBL7B0MtcOu1ucdFndejQdjk/25Orxa8CAp6
dwQCjmhHqz2//fBazBO0cgknvI77liRyq+SgsYvOPHggL3rUr6dTTUyhzEtI4OZQ
g/OZL9XVa36y1Vx7d06abzQsstFOBS6S/PUM0A5PBqYEHPwhnkXCfB2JPS/FxDbx
AM5yxNg2Z/NQZYWmbfiMBYks3vV8pQyjYoHGoCigQBWBDvvzWXpQCK3l4gx8ncnw
cTgadN7eTTdaccuYVKTddZOxtyBxMo2F3sgHobkjQdrk22PVePQ2oakvBgWZf/Ag
v5vaS/EiCKeOkuQ3THxrMm3fz1C4RUIteUAv66w3ZOuXkrSjzN0jYJJ+7LDe3PHS
PoutW200iMvkNKrtQbwwF3BrkOaY/OTovqQL8+tK0JtHMvuWCDw=
=xOHj
-----END PGP SIGNATURE-----

--lpns2gjluurk3v6u--
