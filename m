Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:45849 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750752AbeCLI0J (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Mar 2018 04:26:09 -0400
Message-ID: <1520843103.1513.8.camel@bootlin.com>
Subject: Re: [RFCv4,19/21] media: vim2m: add request support
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Tomasz Figa <tfiga@chromium.org>,
        Dmitry Osipenko <digetx@gmail.com>
Cc: Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Date: Mon, 12 Mar 2018 09:25:03 +0100
In-Reply-To: <CAAFQd5A9mSP8Ufe-gn2Epa55M_NNOVaBL_cdWjdZ5PycbTvqbA@mail.gmail.com>
References: <20180220044425.169493-20-acourbot@chromium.org>
         <1520440654.1092.15.camel@bootlin.com>
         <6470b45d-e9dc-0a22-febc-cd18ae1092be@gmail.com>
         <1520842245.1513.5.camel@bootlin.com>
         <CAAFQd5A9mSP8Ufe-gn2Epa55M_NNOVaBL_cdWjdZ5PycbTvqbA@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-vi8lL/WrEHkMCOMTypE+"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-vi8lL/WrEHkMCOMTypE+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 2018-03-12 at 17:15 +0900, Tomasz Figa wrote:
> Hi Paul, Dmitry,
>=20
> On Mon, Mar 12, 2018 at 5:10 PM, Paul Kocialkowski
> <paul.kocialkowski@bootlin.com> wrote:
> > Hi,
> >=20
> > On Sun, 2018-03-11 at 22:42 +0300, Dmitry Osipenko wrote:
> > > Hello,
> > >=20
> > > On 07.03.2018 19:37, Paul Kocialkowski wrote:
> > > > Hi,
> > > >=20
> > > > First off, I'd like to take the occasion to say thank-you for
> > > > your
> > > > work.
> > > > This is a major piece of plumbing that is required for me to add
> > > > support
> > > > for the Allwinner CedarX VPU hardware in upstream Linux. Other
> > > > drivers,
> > > > such as tegra-vde (that was recently merged in staging) are also
> > > > badly
> > > > in need of this API.
> > >=20
> > > Certainly it would be good to have a common UAPI. Yet I haven't
> > > got my
> > > hands on
> > > trying to implement the V4L interface for the tegra-vde driver,
> > > but
> > > I've taken a
> > > look at Cedrus driver and for now I've one question:
> > >=20
> > > Would it be possible (or maybe already is) to have a single IOCTL
> > > that
> > > takes input/output buffers with codec parameters, processes the
> > > request(s) and returns to userspace when everything is done?
> > > Having 5
> > > context switches for a single frame decode (like Cedrus VAAPI
> > > driver
> > > does) looks like a bit of overhead.
> >=20
> > The V4L2 interface exposes ioctls for differents actions and I don't
> > think there's a combined ioctl for this. The request API was
> > introduced
> > precisely because we need to have consistency between the various
> > ioctls
> > needed for each frame. Maybe one single (atomic) ioctl would have
> > worked
> > too, but that's apparently not how the V4L2 API was designed.
> >=20
> > I don't think there is any particular overhead caused by having n
> > ioctls
> > instead of a single one. At least that would be very surprising
> > IMHO.
>=20
> Well, there is small syscall overhead, which normally shouldn't be
> very painful, although with all the speculative execution hardening,
> can't be sure of anything anymore. :)

Oh, my mistake then, I had it in mind that it is not really something
noticeable. Hopefully, it won't be a limiting factor in our cases.

> Hans and Alex can correct me if I'm wrong, but I believe there is a
> more atomic-like API being planned, which would only need one IOCTL to
> do everything. However, that would be a more serious change to the
> V4L2 interfaces, so should be decoupled from Request API itself.
>=20
> Best regards,
> Tomasz
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-vi8lL/WrEHkMCOMTypE+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlqmOV8ACgkQ3cLmz3+f
v9Enqwf/dGlUworp9wGBWUKSVsM7pgf2yfj2RcdyhkJ9JyD8udtaVguCtr+V45Ie
Ve87E+0rWw97rRBHkZwL50g18s56PwsdYzNIv8p6w203LQ224RFDqSalCBkSxPWR
QWCLz5PVsrKPWUdFTrcdsRviTAdqcsTAfarZ6hBVukhc0Uh8+sKS243AxN+BuaKz
9INTOr4HfLnYh/vLJjQf6n7CfKOyp12mfnIavkk75p24teRpjae9UNBrsbQJQ5d4
W9ncC8VVWXOgY41+FdkSCcLAUvrD75tGkAGUjF7xz102Or0J5djWSvR/PUjIBuMt
s2+bmRRjii+T8U3PtwRyI8+3UXUH1Q==
=J1Z1
-----END PGP SIGNATURE-----

--=-vi8lL/WrEHkMCOMTypE+--
