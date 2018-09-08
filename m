Return-path: <linux-media-owner@vger.kernel.org>
Received: from leonov.paulk.fr ([185.233.101.22]:38016 "EHLO leonov.paulk.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727616AbeIIA3y (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 8 Sep 2018 20:29:54 -0400
Message-ID: <e17313d436b8b8b778218f0ab309274e2ae2f1c4.camel@paulk.fr>
Subject: Re: [PATCH 0/2] Follow-up patches for Cedrus v9
From: Paul Kocialkowski <contact@paulk.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>, Chen-Yu Tsai <wens@csie.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Randy Li <ayaka@soulik.info>, ezequiel@collabora.com,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Date: Sat, 08 Sep 2018 21:42:34 +0200
In-Reply-To: <3c4e5a98-4dbd-9a8c-8dab-612a923f0eb9@xs4all.nl>
References: <20180907163347.32312-1-contact@paulk.fr>
         <11104c03-97ac-8b36-7d75-dfecb8fcce10@xs4all.nl>
         <CAGb2v67F2a-kYFRb_f+CyhzkHf5+Y+h01=SE-rxJ=-Oj-ma1BA@mail.gmail.com>
         <3c4e5a98-4dbd-9a8c-8dab-612a923f0eb9@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-BQ1ZYar5IRrxV/S/Pl6P"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-BQ1ZYar5IRrxV/S/Pl6P
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Le samedi 08 septembre 2018 =C3=A0 13:24 +0200, Hans Verkuil a =C3=A9crit :
> On 09/08/2018 12:22 PM, Chen-Yu Tsai wrote:
> > On Sat, Sep 8, 2018 at 6:06 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > >=20
> > > On 09/07/2018 06:33 PM, Paul Kocialkowski wrote:
> > > > This brings the requested modifications on top of version 9 of the
> > > > Cedrus VPU driver, that implements stateless video decoding using t=
he
> > > > Request API.
> > > >=20
> > > > Paul Kocialkowski (2):
> > > >   media: cedrus: Fix error reporting in request validation
> > > >   media: cedrus: Add TODO file with tasks to complete before unstag=
ing
> > > >=20
> > > >  drivers/staging/media/sunxi/cedrus/TODO     |  7 +++++++
> > > >  drivers/staging/media/sunxi/cedrus/cedrus.c | 15 ++++++++++++---
> > > >  2 files changed, 19 insertions(+), 3 deletions(-)
> > > >  create mode 100644 drivers/staging/media/sunxi/cedrus/TODO
> > > >=20
> > >=20
> > > So close...
> > >=20
> > > When compiling under e.g. intel I get errors since it doesn't know ab=
out
> > > the sunxi_sram_claim/release function and the PHYS_PFN_OFFSET define.
> > >=20
> > > Is it possible to add stub functions to linux/soc/sunxi/sunxi_sram.h
> > > if CONFIG_SUNXI_SRAM is not defined? That would be the best fix for t=
hat.
> > >=20
> > > The use of PHYS_PFN_OFFSET is weird: are you sure this is the right
> > > way? I see that drivers/of/device.c also sets dev->dma_pfn_offset, wh=
ich
> > > makes me wonder if this information shouldn't come from the device tr=
ee.
> > >=20
> > > You are the only driver that uses this define directly, which makes m=
e
> > > suspicious.
> >=20
> > On Allwinner platforms, some devices do DMA directly on the memory BUS
> > with the DRAM controller. In such cases, the DRAM has no offset. In all
> > other cases where the DMA goes through the common system bus and the DR=
AM
> > offset is either 0x40000000 or 0x20000000, depending on the SoC. Since =
the
> > former case is not described in the device tree (this is being worked o=
n
> > by Maxime BTW), the dma_pfn_offset is not the value it should be. AFAIK
> > only the display and media subsystems (VPU, camera, TS) are wired this
> > way.
> >=20
> > In drivers/gpu/drm/sun4i/sun4i_backend.c (the display driver) we use
> > PHYS_OFFSET, which is pretty much the same thing.
> >=20
>=20
> OK, in that case just put #ifdef PHYS_PFN_OFFSET around that line togethe=
r
> with a comment that this will eventually come from the device tree.

That seems fine, although I'm less certain about what to do for the
SRAM situation. Other drivers that use SUNXI_SRAM have a Kconfig select
on it (that Cedrus lacks). Provided that the SRAM driver builds fine
for non-sunxi configs, bringing-in that select would remove the need
for dummy functions and also ensure that the actual implementation is
always used on sunxi. Otherwise, there'd be a risk of having the dummy
functions used (if the SRAM driver is not explicitly selected in the
config), causing a hang when accessing the VPU.

What do you think?

Cheers,

Paul

--=20
Developer of free digital technology and hardware support.

Website: https://www.paulk.fr/
Coding blog: https://code.paulk.fr/
Git repositories: https://git.paulk.fr/ https://git.code.paulk.fr/

--=-BQ1ZYar5IRrxV/S/Pl6P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEAbcMXZQMtj1fphLChP3B6o/ulQwFAluUJioACgkQhP3B6o/u
lQzoEA/7BibKzBuB8d983RQNZICzt8NYV7W2spVW8z+SHS/s1/CGEPpIxTzYcQAX
vc073Kx6pDw5U+wnkvBU0DsxJ3uTIofzb+VKkAWtqneGYFKHmlccbrlF25t99DVv
AlcupZE4hINniubA2zDz6kl8kKHa+2PfvqENszrYiTpNRcVXfuhYcZJwtUr+QKOV
3Lti8Nfo90aHmRJErLSU8PeyXitIuDkIGIqhLoigXzbP4sT+vnu53l5WWBKmrqsc
wFweoa445g4+Sf/bb0i7Mku4jgC0OwyeKQOH+AYLAoihaFdNO+FkpoWnI/Zyk1o1
NttICTmBy+PclaAFQP6H772UaO/SIFJ0V56nPR/Cg9RxuChj8Ngc4HRvxRUaq8wk
Gfj9pvAehrdxTHJHtAYiAdpkdI9dOSb1+hgMwjA/o26QbgqgCiWsiub9S/UWcHLj
9/U1kvoLtRt4boLxmrC5UiUP/kQVZ3Hc+K1NbzDcsjzBQ4ULUVV/u/qZBLImfvVh
1aJ5d36IWWIDMnw1ytH51RuxgrkobiIlDgzkq/nz3KAix21A1DTUY+AVqNSCx1NT
XZowyqbPFwm5wz6b74bPsZi1xH/TVGYlQl/CrrgUOBe2VC3TICGTMdXaRP/7TRet
1JHwAPZnSH2pvCVyCWM09OBfb+sJvLR+gtxFSSwmiI55WZrQYdA=
=vw5+
-----END PGP SIGNATURE-----

--=-BQ1ZYar5IRrxV/S/Pl6P--
