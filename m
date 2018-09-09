Return-path: <linux-media-owner@vger.kernel.org>
Received: from leonov.paulk.fr ([185.233.101.22]:44858 "EHLO leonov.paulk.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbeIJAEk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Sep 2018 20:04:40 -0400
Message-ID: <f1527ee171087dc17b96ae6781e22991673efbff.camel@paulk.fr>
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
Date: Sun, 09 Sep 2018 21:13:40 +0200
In-Reply-To: <7386a631-1753-22cb-955e-fd0f1ca7a2d1@xs4all.nl>
References: <20180907163347.32312-1-contact@paulk.fr>
         <11104c03-97ac-8b36-7d75-dfecb8fcce10@xs4all.nl>
         <CAGb2v67F2a-kYFRb_f+CyhzkHf5+Y+h01=SE-rxJ=-Oj-ma1BA@mail.gmail.com>
         <3c4e5a98-4dbd-9a8c-8dab-612a923f0eb9@xs4all.nl>
         <e17313d436b8b8b778218f0ab309274e2ae2f1c4.camel@paulk.fr>
         <7386a631-1753-22cb-955e-fd0f1ca7a2d1@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-rM16QRiM22KYzxHBC9Xs"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-rM16QRiM22KYzxHBC9Xs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Le dimanche 09 septembre 2018 =C3=A0 11:04 +0200, Hans Verkuil a =C3=A9crit=
 :
> On 09/08/2018 09:42 PM, Paul Kocialkowski wrote:
> > Hi,
> >=20
> > Le samedi 08 septembre 2018 =C3=A0 13:24 +0200, Hans Verkuil a =C3=A9cr=
it :
> > > On 09/08/2018 12:22 PM, Chen-Yu Tsai wrote:
> > > > On Sat, Sep 8, 2018 at 6:06 PM Hans Verkuil <hverkuil@xs4all.nl> wr=
ote:
> > > > >=20
> > > > > On 09/07/2018 06:33 PM, Paul Kocialkowski wrote:
> > > > > > This brings the requested modifications on top of version 9 of =
the
> > > > > > Cedrus VPU driver, that implements stateless video decoding usi=
ng the
> > > > > > Request API.
> > > > > >=20
> > > > > > Paul Kocialkowski (2):
> > > > > >   media: cedrus: Fix error reporting in request validation
> > > > > >   media: cedrus: Add TODO file with tasks to complete before un=
staging
> > > > > >=20
> > > > > >  drivers/staging/media/sunxi/cedrus/TODO     |  7 +++++++
> > > > > >  drivers/staging/media/sunxi/cedrus/cedrus.c | 15 ++++++++++++-=
--
> > > > > >  2 files changed, 19 insertions(+), 3 deletions(-)
> > > > > >  create mode 100644 drivers/staging/media/sunxi/cedrus/TODO
> > > > > >=20
> > > > >=20
> > > > > So close...
> > > > >=20
> > > > > When compiling under e.g. intel I get errors since it doesn't kno=
w about
> > > > > the sunxi_sram_claim/release function and the PHYS_PFN_OFFSET def=
ine.
> > > > >=20
> > > > > Is it possible to add stub functions to linux/soc/sunxi/sunxi_sra=
m.h
> > > > > if CONFIG_SUNXI_SRAM is not defined? That would be the best fix f=
or that.
> > > > >=20
> > > > > The use of PHYS_PFN_OFFSET is weird: are you sure this is the rig=
ht
> > > > > way? I see that drivers/of/device.c also sets dev->dma_pfn_offset=
, which
> > > > > makes me wonder if this information shouldn't come from the devic=
e tree.
> > > > >=20
> > > > > You are the only driver that uses this define directly, which mak=
es me
> > > > > suspicious.
> > > >=20
> > > > On Allwinner platforms, some devices do DMA directly on the memory =
BUS
> > > > with the DRAM controller. In such cases, the DRAM has no offset. In=
 all
> > > > other cases where the DMA goes through the common system bus and th=
e DRAM
> > > > offset is either 0x40000000 or 0x20000000, depending on the SoC. Si=
nce the
> > > > former case is not described in the device tree (this is being work=
ed on
> > > > by Maxime BTW), the dma_pfn_offset is not the value it should be. A=
FAIK
> > > > only the display and media subsystems (VPU, camera, TS) are wired t=
his
> > > > way.
> > > >=20
> > > > In drivers/gpu/drm/sun4i/sun4i_backend.c (the display driver) we us=
e
> > > > PHYS_OFFSET, which is pretty much the same thing.
> > > >=20
> > >=20
> > > OK, in that case just put #ifdef PHYS_PFN_OFFSET around that line tog=
ether
> > > with a comment that this will eventually come from the device tree.
> >=20
> > That seems fine, although I'm less certain about what to do for the
> > SRAM situation. Other drivers that use SUNXI_SRAM have a Kconfig select
> > on it (that Cedrus lacks). Provided that the SRAM driver builds fine
> > for non-sunxi configs, bringing-in that select would remove the need
> > for dummy functions and also ensure that the actual implementation is
> > always used on sunxi. Otherwise, there'd be a risk of having the dummy
> > functions used (if the SRAM driver is not explicitly selected in the
> > config), causing a hang when accessing the VPU.
>=20
> You should certainly select this kernel config.
>=20
> But the real problem seems to to be drivers/soc/Makefile where it says:
>=20
> obj-$(CONFIG_ARCH_SUNXI)       +=3D sunxi/
>=20
> I think this should be:
>=20
> obj-y       +=3D sunxi/
>=20
> Now all compiles fine on i686 with the cedrus driver selecting SUNXI_SRAM=
.

I have just crafted a patch to the attention of Maxime to allow
building the sunxi SRAM driver without selecting the sunxi
architecture, the way you suggested.

With that, I just sent out v2 of the follow-up series for the Cedrus
driver, which should cover the build issues encountered so far.

Hopefully everything should be in order this time!

Cheers,

Paul

--=20
Developer of free digital technology and hardware support.

Website: https://www.paulk.fr/
Coding blog: https://code.paulk.fr/
Git repositories: https://git.paulk.fr/ https://git.code.paulk.fr/

--=-rM16QRiM22KYzxHBC9Xs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEAbcMXZQMtj1fphLChP3B6o/ulQwFAluVcOQACgkQhP3B6o/u
lQykqQ//QYbM/uJYNKugcZ9ryGjZRUbMLeeB+AeVyk++fcu65tchn5PZwGo8l6GP
HQiz3cJAjrhrLqcJjufWgKy+CCs5N13TL9mFEYm7YR6D9kfRtiWVq+4p7KNGZjeX
vLhMPdg4EbU/9bYliGTPzGfYCjezD8nh3KmHerh2K1Z6k4lExVdy10bNjISRhzmg
n0aXFirWlPOlyZW4fQgeijsvVQLBfMRCHzBWUEsfoFP6yb4p/icdAkmWX9+8B08U
8bosyiEmVqSg4YAw+h2/Vv/xO4a3udt+5MRd9TET3r2bYFaiQOsdj2B9c7EfncQj
qdBfUiJYn70MfI975BXwQh3t1RyqJCAW8VvqxWpDts7Kw9cO/g5fLT1kgzH/gZnL
mEETXLHipghEg/V7t6g1Hka/SSDm6FImujxbne1ALKAtFqtj0sA4zgzWipNLOkY8
pEWA1vlxvpYGUBseWp62kdr/wUlslUGzDH+KqABPP0ZWbsw751mo7IFQ5YzB2AnK
LCra2JXVPrz9y9ih8ZyOzGF0iLrNvaj8ed+JFozdT+T/FqqV8S6De7sY/CEDAM/U
vPTVNBeiGB3hqTIhPWATubtE0CnsonbYrjN0xTzawjNZButQKyvHBW5xbZrVZBq2
6MsCzFW8MvRuJX/5bYKq2gd1yCEjCyiKO6xN6I6ldxWQ9gqVyW0=
=slNS
-----END PGP SIGNATURE-----

--=-rM16QRiM22KYzxHBC9Xs--
