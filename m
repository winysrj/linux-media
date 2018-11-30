Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:52527 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbeLAA0J (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 19:26:09 -0500
Message-ID: <2a52719446c1050990494e44a991acb932da8273.camel@bootlin.com>
Subject: Re: [linux-sunxi] [PATCH 14/15] arm64: dts: allwinner: h5: Add
 Video Engine and reserved memory node
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-sunxi@googlegroups.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Date: Fri, 30 Nov 2018 14:16:50 +0100
In-Reply-To: <CAGb2v64pVKG4mSAF48xR54yj00rQ6iTvgYQB9Bf-XWmH2FhVqQ@mail.gmail.com>
References: <20181115145013.3378-1-paul.kocialkowski@bootlin.com>
         <20181115145013.3378-15-paul.kocialkowski@bootlin.com>
         <CAGb2v64pVKG4mSAF48xR54yj00rQ6iTvgYQB9Bf-XWmH2FhVqQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-453EcI7CdM8GuIru8Jyr"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-453EcI7CdM8GuIru8Jyr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 2018-11-15 at 23:35 +0800, Chen-Yu Tsai wrote:
> On Thu, Nov 15, 2018 at 10:51 PM Paul Kocialkowski
> <paul.kocialkowski@bootlin.com> wrote:
> > This adds nodes for the Video Engine and the associated reserved memory
> > for the H5. Up to 96 MiB of memory are dedicated to the CMA pool.
> >=20
> > The pool is located at the end of the first 256 MiB of RAM so that the
> > VPU can access it. It is unclear whether this is still a hard
> > requirement for this platform, but it seems safer that way.
>=20
> I think we can actually test this. You could move the reserved memory
> pool beyond 256 MiB, and have cedrus decode stuff, and try to display
> the results. If it's gibberish, or the system crashes, it's likely the
> memory access wrapped around at 256 MiB.
>=20
> What do you think?

I did the test on various platforms and found that starting with the
A33, the VPU can map any address in RAM! SO we shouldn't need reserved
memory nodes for these devices after all.

Cheers,

Paul

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-453EcI7CdM8GuIru8Jyr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlwBOEIACgkQ3cLmz3+f
v9FV/Af+JpWv2W/HOaxK1G4Ane+uWUNIMUUgOaXhtOWvSfOu9arSCtcVqerpnZHu
TegKhEKLo5GMEcEBOFbnqiFEno9JkrY+fN7ukdUp0QGqX8uSry5ehpm/yznNDTnZ
IvzNrsRO1CrcC0/YKn3+6hxbcD81wf86ALVtQwpUvVv3FNGsvEaKyi7YKKDNOyQs
Yevz1VInlDEXFJ5SXmR99LMbAyjNBt7UtHVM5jKODv3lkdXyAta5MGCaRlv8oqxk
hZnEe5M4mPns7vmNTa/wM0+zHkAORNs9IoOTepMep2f9pmMNq9qw03PT6hV0bxcU
2ZgSh2jiSJBB8jJk+VhAAUmB+iS8qg==
=wjcm
-----END PGP SIGNATURE-----

--=-453EcI7CdM8GuIru8Jyr--
