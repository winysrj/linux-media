Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:38948 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932278AbeGII6E (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2018 04:58:04 -0400
Date: Mon, 9 Jul 2018 10:58:01 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Dmitry Osipenko <digetx@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-tegra@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] ARM: dts: tegra30: Add Memory Client reset to VDE
Message-ID: <20180709085801.GC13963@ulmo>
References: <20180520134846.31046-1-digetx@gmail.com>
 <20180520134846.31046-3-digetx@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5G06lTa6Jq83wMTw"
Content-Disposition: inline
In-Reply-To: <20180520134846.31046-3-digetx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--5G06lTa6Jq83wMTw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 20, 2018 at 04:48:46PM +0300, Dmitry Osipenko wrote:
> Hook up Memory Client reset of the Video Decoder to the decoders DT node.
>=20
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> ---
>  arch/arm/boot/dts/tegra30.dtsi | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Applied, thanks.

Thierry

--5G06lTa6Jq83wMTw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAltDI5YACgkQ3SOs138+
s6G2JhAApdcg7IFWFMgqlbOLmpx2EiHprBIO5z2l0xJrC5l+f/h9apDygmRdO9h4
JK6REB7VXt62Ayjmm00n82XEwt9hwtnDxQngwDI9ILjdNYb/wU2IpvNEBEJVx2Zh
72+axVijaTvmZlhpx6V6BvRpHjd0RzsQhC1GiKJSBkszdaK4n6Es/bCtpZjPRFpo
Ptyay0KMjEf4yvuW1noxJHEZrIjdP4Zn5+TuLCEyVivpu/w8xAABAwqUMR3SMOts
JtEY5of4+ETl/ob/HsadvN3vjpxiKUUzkDjlysXcKhsQCBPqBtiEc48WHzngW8VX
TEOHotePbuEzmxmpEuy39btr+GzGNcX6eK2tJ23xm4hFaXU5pfP/ppUPM8ZY/gNj
H7BjGD3O/k0odkhigmL3p59tSafDbe/Ff3dOpqjx1FKOjzjIvEXBnfU/Osy0cbfp
SE0neBcWEv7RSoaptnz/Vd+VwM/e0JqKFTMlqFhTMW8yX4MPBo79Hi6A6EpgaCG1
uTDuIOTiKMGiTaitWziKJw7zQo8As915yJPadrKqpnW3Hgbka06bKa1aVmdKGMXn
VuTrhaEHhV4shLkbD4pV5PkWGlJwP65i9liubZ9RK27qv3q6NXxo3iFr7thxGiAs
koh+O+O9L1/3fzN4ccJbmp9Dngc+EqD+A40DY7tAAAXbfpmAsF0=
=h8rp
-----END PGP SIGNATURE-----

--5G06lTa6Jq83wMTw--
