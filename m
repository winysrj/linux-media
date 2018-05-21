Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:37537 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750883AbeEUHjO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 03:39:14 -0400
Date: Mon, 21 May 2018 09:39:02 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Sam Bobrowicz <sam@elite-embedded.com>
Cc: Daniel Mack <daniel@zonque.org>,
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
Message-ID: <20180521073902.ayky27k5pcyfyyvc@flea>
References: <20180517085405.10104-1-maxime.ripard@bootlin.com>
 <20180517085405.10104-4-maxime.ripard@bootlin.com>
 <0de04d7b-9c75-3e4e-4cf9-deaedeab54a4@zonque.org>
 <CAFwsNOEkLU91qYtj=n_pd=kvvovXs6JTFiMFvwsMRvB0nY5H=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="s3k34fpfaq26ud2j"
Content-Disposition: inline
In-Reply-To: <CAFwsNOEkLU91qYtj=n_pd=kvvovXs6JTFiMFvwsMRvB0nY5H=g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--s3k34fpfaq26ud2j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 18, 2018 at 07:42:34PM -0700, Sam Bobrowicz wrote:
> On Fri, May 18, 2018 at 3:35 AM, Daniel Mack <daniel@zonque.org> wrote:
> > On Thursday, May 17, 2018 10:53 AM, Maxime Ripard wrote:
> >>
> >> Part of the hardcoded initialization sequence is to set up the proper
> >> clock
> >> dividers. However, this is now done dynamically through proper code an=
d as
> >> such, the static one is now redundant.
> >>
> >> Let's remove it.
> >>
> >> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> >> ---
> >
> >
> > [...]
> >
> >> @@ -625,8 +623,8 @@ static const struct reg_value
> >> ov5640_setting_30fps_1080P_1920_1080[] =3D {
> >>         {0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, =
0},
> >>         {0x4001, 0x02, 0, 0}, {0x4004, 0x06, 0, 0}, {0x4713, 0x03, 0, =
0},
> >>         {0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, =
0},
> >> -       {0x3824, 0x02, 0, 0}, {0x5001, 0x83, 0, 0}, {0x3035, 0x11, 0, =
0},
> >> -       {0x3036, 0x54, 0, 0}, {0x3c07, 0x07, 0, 0}, {0x3c08, 0x00, 0, =
0},
> >> +       {0x3824, 0x02, 0, 0}, {0x5001, 0x83, 0, 0},
> >> +       {0x3c07, 0x07, 0, 0}, {0x3c08, 0x00, 0, 0},
> >
> >
> > This is the mode that I'm testing with. Previously, the hard-coded regi=
sters
> > here were:
> >
> >  OV5640_REG_SC_PLL_CTRL1 (0x3035) =3D 0x11
> >  OV5640_REG_SC_PLL_CTRL2 (0x3036) =3D 0x54
> >  OV5640_REG_SC_PLL_CTRL3 (0x3037) =3D 0x07
> >
> > Your new code that calculates the clock rates dynamically ends up with
> > different values however:
> >
> >  OV5640_REG_SC_PLL_CTRL1 (0x3035) =3D 0x11
> >  OV5640_REG_SC_PLL_CTRL2 (0x3036) =3D 0xa8
> >  OV5640_REG_SC_PLL_CTRL3 (0x3037) =3D 0x03
> >
> > Interestingly, leaving the hard-coded values in the array *and* letting
> > ov5640_set_mipi_pclk() do its thing later still works. So again it seems
> > that writes to registers after 0x3035/0x3036/0x3037 seem to depend on t=
he
> > values of these timing registers. You might need to leave these values =
as
> > dummies in the array. Confusing.
> >
> > Any idea?
> >
> >
> > Thanks,
> > Daniel
>=20
> This set of patches is also not working for my MIPI platform (mine has
> a 12 MHz external clock). I am pretty sure is isn't working because it
> does not include the following, which my tests have found to be
> necessary:
>=20
> 1) Setting pclk period reg in order to correct DPHY timing.
> 2) Disabling of MIPI lanes when streaming not enabled.
> 3) setting mipi_div to 1 when the scaler is disabled
> 4) Doubling ADC clock on faster resolutions.

Yeah, I left them out because I didn't think this was relevant to this
patchset but should come as future improvements. However, given that
it works with the parallel bus, maybe the two first are needed when
adjusting the rate.

The mipi divider however seems to be a bit more complicated than you
report here. It is indeed set to 1 when the scaler is enabled (all
resolutions > 1280 * 960), but it's also set to 4 in some cases
(640x480@30, 320x240@30, 176x144@30). I couldn't really find any
relationship between the resolution/framerate and whether to use a
divider of 2 or 4.

And the faster resolutions were working already, so I guess the ADC
clock is already fast enough with a 24MHz oscillator?

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--s3k34fpfaq26ud2j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlsCd5UACgkQ0rTAlCFN
r3TLqg/9Ge8V1OyZoITSdmytgw/3dRrZVSc9gT7Mcj8uA+Hs/3YF+QSH9YM+dh0b
8XU5gVr8JT9dyX9nd6K8C9Qr/Y7Jgtv7c3zGgol8XQbPGqRLLZfdTuBYhpejXHCv
uvNuArJ7ZQNtmeNFu+GUMvv3ePgWE48aPru+hh8mNjUDeg425TOnRCbg2xBQiB99
S031hc6neTFGnwmFZ8iB15NaB7ps4AZ8Vqx7nQeVGKlF+xsIGlcX16Jygke8deh2
IRZ0kYlLDw2o0uw7NzQYB0nQ5jUvLBTCo/2AhviSloHoTTjkkEazW2+Je06laO3W
powhNkZ75ZCOelsFJWYpdPaza8KKfFz2uTfWCNGiiKAHiXM2akpNT1QsbX5skAyC
2C9OvnMY696Try89aTWHKMSFp1jPFN6B5E3iZgaRKnFN4dhkTXg//kd+gnrOtD8o
fy1KhpdszBmk8HG+dJ3a3zw5RYgfJ8f7L6CaEn6SO95xwBE4dj7bshfZSR7YSMgR
rXQ/4NlbgHNFU20IMC6uNbqxTe5No4HAx7lJ3IVZevJtF2yGiX1Svlocdpg3XoOF
5NjQJ1VkwNF1ddEQCl8lX7EmeheFNQKwb79RzwQuy13AvcXJmE9IbRVbfI9izBDD
95e6avJLyfw93l9Mgwt1uqG6MTkUPxPYxHbmfPrCb8UbZsSREX4=
=paP5
-----END PGP SIGNATURE-----

--s3k34fpfaq26ud2j--
