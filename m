Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:58847 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751007AbeECPQW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 11:16:22 -0400
Date: Thu, 3 May 2018 17:16:21 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Sam Bobrowicz <sam@elite-embedded.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: Re: [PATCH v2 00/12] media: ov5640: Misc cleanup and improvements
Message-ID: <20180503151621.onuq77ph32o5euis@flea>
References: <20180416123701.15901-1-maxime.ripard@bootlin.com>
 <20180419123244.tujbrkpazbdyows6@flea>
 <CAFwsNOEV0Q2HjmaoT-m-znD-+0VSfE4tJ2vCPuNpUe2M72ErAA@mail.gmail.com>
 <3075738.A80d5ULHjc@avalon>
 <CAFwsNOECP74VKYavSo6RBzzohZ1S69=CVjSP_zYDsBXMhyxMjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="o5adxtmjwv4pgsux"
Content-Disposition: inline
In-Reply-To: <CAFwsNOECP74VKYavSo6RBzzohZ1S69=CVjSP_zYDsBXMhyxMjw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--o5adxtmjwv4pgsux
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, May 02, 2018 at 11:11:55AM -0700, Sam Bobrowicz wrote:
> > On Wednesday, 25 April 2018 01:11:19 EEST Sam Bobrowicz wrote:
> >> FYI, still hard at work on this. Did some more experiments last week
> >> that seemed to corroborate the clock tree in the spreadsheet. It also
> >> seems that the output of the P divider cell, SCLK cell and MIPI Rate
> >> cell in the spreadsheet must have a ratio of 2x:1x:8x (respectively)
> >> in order for the sensor to work properly on my platform, and that the
> >> SCLK value must be close to the "rate" variable that you calculate and
> >> pass to set_mipi_pclk. Unfortunately, I've only got the sensor working
> >> well for 1080p@15Hz and 720p@30Hz, both with a SCLK of 42MHz (aka
> >> 84:42:336). I'm running experiments now trying to adjust the htot and
> >> vtot values to create different required rates, and also to try to get
> >> faster Mipi rates working. Any information you have on the
> >> requirements of the htot and vtot values with respect to vact and hact
> >> values would likely be helpful.
> >>
> >> I'm also keeping an eye on the scaler clock, which I think may be
> >> affecting certain resolutions, but haven't been able to see it make a
> >> difference yet (see register 0x3824 and 0x460c)
> >>
> >> I plan on pushing a set of patches once I get this figured out, we can
> >> discuss what I should base them on when I get closer to that point.
> >> I'm new to this process :)
> >
> > I'm also interested in getting the ov5640 driver working with MIPI CSI-=
2.
> > Studying the datasheet and the driver code, I found the stream on seque=
nce to
> > be a bit weird. In particular the configuration of OV5640_REG_IO_MIPI_C=
TRL00,
> > OV5640_REG_PAD_OUTPUT00 and OV5640_REG_MIPI_CTRL00 caught my attention.
> >
> > OV5640_REG_IO_MIPI_CTRL00 (0x300e) is set to 0x45 in the large array of=
 init
> > mode data and never touched for MIPI CSI-2 (the register is only touche=
d in
> > ov5640_set_stream_dvp). The value means
> >
> > - mipi_lane_mode: 010 is documented as "debug mode", I would have expec=
ted 000
> > for one lane or 001 for two lanes.
>=20
> I noticed this too, but it seems that 010 is the correct value for two
> lane mode. I think this is a typo in the datasheet.
>=20
> >
> > - MIPI TX PHY power down: 0 is documented as "debug mode" and 1 as "Pow=
er down
> > PHY HS TX", so I suppose 0 is correct.
> >
> > - MIPI RX PHY power down: 0 is documented as "debug mode" and 1 as "Pow=
er down
> > PHY LP RX module", so I suppose 0 is correct. I however wonder why ther=
e's a
> > RX PHY, it could be a typo.
> >
> > - mipi_en: 1 means MIPI enable, which should be correct.
> >
> > - BIT(0) is undocumented.
> >
> > OV5640_REG_PAD_OUTPUT00 (0x3019) isn't initialized explicitly and thus =
retains
> > its default value of 0x00, and is controlled when starting and stopping=
 the
> > stream where it's set to 0x00 and 0x70 respectively. Bits 6:4 control t=
he
> > "sleep mode" state of lane 2, lane 1 and clock lane respectively, and s=
hould
> > be LP11 in my opinion (that's the PHY stop state). However, setting the=
m to
> > 0x00 when starting the stream mean that LP00 is selected as the sleep s=
tate at
> > stream start, and LP11 when stopping the stream. Maybe "sleep mode" mea=
ns
> > LPDT, but I would expect that to be controlled by the idle status bit in
> > register 0x4800.
> >
>=20
> I did not need to mess with the accesses to 0x3019 in order to get
> things working on my system. I'm not sure of this registers actual
> behavior, but it might affect idling while not streaming (after power
> on). My pipeline currently only powers the sensor while streaming, so
> I might be missing some ramifications of this register.
>=20
> > OV5640_REG_MIPI_CTRL00 (0x4800) is set to 0x04 in the large array of in=
it mode
> > data, and BIT(5) is then cleared at stream on time and set at stream of=
f time.
> > This means:
> >
> > - Clock lane gate enable: Clock lane is free running
> > - Line sync enable: Do not send line short packets for each line (I ass=
ume
> > that's LS/LE)
> > - Lane select: Use lane1 as default data lane.
> > - Idle status: MIPI bus will be LP11 when no packet to transmit. I woul=
d have
> > expected the idle status to correspond to LPDT, and thus be LP00 (as op=
posed
> > to the stop state that should be LP11, which I believe is named "sleep =
mode"
> > in the datasheet and controlled in register 0x3019).
> >
> > BIT(5) is the clock lane gate enable, so at stream on time the clock is=
 set to
> > free running, and at stream off time to "Gate clock lane when no packet=
 to
> > transmit". Couldn't we always enable clock gating ?
>=20
> Good question, it might be worth testing. Same as above, I didn't need
> to mess with this reg either.
>=20
> > Do you have any insight on this ? Have you modified the MIPI CSI-2
> > configuration to get the CSI-2 output working ?
>=20
> Good news, MIPI is now working on my platform. I had to make several
> changes to how the mipi clocking is calculated in order to get things
> stable, but I think I got it figured out. Maxime's changes were really
> helpful.
>=20
> I will try to get some patches out today or tomorrow that should get
> you up and running.
>=20
> Maxime, I'd prefer to create the patches myself for the experience.
> I've read all of the submission guidelines and I understand the
> general process, but how should I submit them to the mailing list
> since they are based to your patches, which are still under review?
> Should I send the patch series to the mailing list myself and just
> mention this patch series, maybe with the In-Reply-To header? Or
> should I just post a link to them here so you can review them and add
> them to a new version of your patch series?

That's definitely something you can do if you want to try it out :)

However, we shouldn't break the bisectability either, so this will
need to be folded into this serie eventually.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--o5adxtmjwv4pgsux
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlrrJ8QACgkQ0rTAlCFN
r3TIgQ/9Fwl+UQ5wk7U89+kfBg1kkjRcvuV5BqInv2jITZ8X2s4UKcEfucFeEdoT
dhcpaDioS5zd37vocwePgkOgvSEuRDae/EUPv4jeg+UcRjfnkjYMjHp6MHt1I7Ua
DLygHR6QclUKIPrg8eZPQjz6WvRm/XdV47JCgQTEAj6FRI2CPqhX+IckBEK1Wo9u
Udblt/LLPg2g6y7MkBBelSf9OU/KWA1IU5ekNt5ZbmXixUs/wnVn5ytR0v7NFM5/
buqsXz+NqeLGygYdgitQ9qjI4AzozOkuBmRoKIZLuxiC4Wmbc5PMfMerepBfcy6W
ygNvbnckSGVIP5zZIhVH9pYSob4jidvhzMP2LkhcrQdh4xVL3EsJgO1M5m969/0U
3cUy7666gTEdLO4U9p0NKBNokAzlC2pmRAHn6Sg5XOp3wleRvrTzEj5hfY1cM49q
R6fZpGgJtZR/TfnxIfowgG6FUD5juA5+A5ArvxGO+3Oo2SMo2rGOrL3fMqCBeIdD
SifNhoadytK9QVEOKV4mkNE7rR/4uBjAMHYE1R/ngzcjr1qnUdoH1O15QtdghMi+
GZ8siVI5QJ9diS9fc1XoVfqkKKICfznuYpXZeOuxEVeE87wpR2vY1vDofIhDZGLe
TGyga1kPtPFCxjCfx6xVqKM+ncCLnTUNmkESNkVXI+J91X5e7m4=
=j0ud
-----END PGP SIGNATURE-----

--o5adxtmjwv4pgsux--
