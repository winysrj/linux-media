Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36471 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932241AbeGII7G (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2018 04:59:06 -0400
Date: Mon, 9 Jul 2018 10:59:02 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Dmitry Osipenko <digetx@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-tegra@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] ARM: dts: tegra20: Add Memory Client reset to VDE
Message-ID: <20180709085902.GD13963@ulmo>
References: <20180520134846.31046-1-digetx@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZJcv+A0YCCLh2VIg"
Content-Disposition: inline
In-Reply-To: <20180520134846.31046-1-digetx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ZJcv+A0YCCLh2VIg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 20, 2018 at 04:48:44PM +0300, Dmitry Osipenko wrote:
> Hook up Memory Client reset of the Video Decoder to the decoders DT node.
>=20
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> ---
>  arch/arm/boot/dts/tegra20.dtsi | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

Applied, thanks.

Thierry

--ZJcv+A0YCCLh2VIg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAltDI9YACgkQ3SOs138+
s6HNlg//WWXO7YBRWnaR2AaXE6q2QxdZKw7Fy69Flx4luA1rQYO7jlMkh6CQkxra
gbzAsStpe3WZSKFjgC+ysUta7zRFmBG2uANyUPp9UJp28hVkJSwV5JzY8McNlLZ2
n8CV7Kj2JHRi/cm7VeaYaWVkOdZF8sKkKuowqrTlFCbFxx1QqGxS5n/lyB46KB8S
2MWXWoCCUAq+bbHPUGpMlWgjI+6eoofVAB65wQdsX1bTNMv7U5/LkokbU6xWG7uA
qutgMouPOhqtTztX7Qspe30aVn+bvdjsQwd2/KwYJHXCVtrKWYyIey8fEcUzWeFU
LnQP+rnYEB9WA9Vpx4h7Gehs2YlQ2d68BWZX0mijvFMlj2gK92ZMGg4qyscuAMjd
1jh5nYzRU8JKlNPXo9HTC3rifQRJFlzm00Ch9zXRYH4KGREqg06ojqm22OHGNOvZ
UU0wyg+BTFGmwnPIDKbebFm1XtUpfR0UfI8/Ok3m5DF2n5QOSz2B6+vboGAO6I/2
kczw2NUgQdjnwaqJqro7rzD05wFeNbjAwErQTLijTG1ozqssZoEpIupkmKIv3t3z
bWQZkQ+m/sqJGgI+dtujIO8QmFT09qCAiUSWdqxFKZUv2XgHrNNMhsQRNXm5GDfd
0JSNOhZkMA4fijTrwHCmpEvhkJ5VXOXc4VJE7CbBziwEO1RZnPo=
=s+P9
-----END PGP SIGNATURE-----

--ZJcv+A0YCCLh2VIg--
