Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:38425 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755941AbdLTTTn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Dec 2017 14:19:43 -0500
Date: Wed, 20 Dec 2017 20:19:39 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Dmitry Osipenko <digetx@gmail.com>
Cc: Jonathan Hunter <jonathanh@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Rob Herring <robh+dt@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/4] ARM: dts: tegra20: Add device tree node to
 describe IRAM
Message-ID: <20171220191939.GE9687@ulmo>
References: <cover.1513038011.git.digetx@gmail.com>
 <92563f9030ab413ff8f6d5a6b6a5680124ec4d98.1513038011.git.digetx@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="G6nVm6DDWH/FONJq"
Content-Disposition: inline
In-Reply-To: <92563f9030ab413ff8f6d5a6b6a5680124ec4d98.1513038011.git.digetx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--G6nVm6DDWH/FONJq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 12, 2017 at 03:26:09AM +0300, Dmitry Osipenko wrote:
> From: Vladimir Zapolskiy <vz@mleia.com>
>=20
> All Tegra20 SoCs contain 256KiB IRAM, which is used to store
> resume code and by a video decoder engine.
>=20
> Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> ---
>  arch/arm/boot/dts/tegra20.dtsi | 8 ++++++++
>  1 file changed, 8 insertions(+)

Applied, thanks.

Thierry

--G6nVm6DDWH/FONJq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAlo6t8sACgkQ3SOs138+
s6F3tQ//Qlj1LW9auRVzLNEljlIaVA9PvpaSI+bHlvcm2oaLI72x4+90goOb1FoU
bCBzHj8fgu3zu8pPGAskWhw3vx9OBA6tJjOywMBuxuEKtRXsXLe3tw4uKu4ASP6Q
MCM9RACnNCJf/mNFW3akz3L3WQKhozPGCdH5huANVvGGI3hChfNaPCX2N9Rc6Lkk
fUsTzUe+BpKUwN9Vm/XG6Bo0WbYuGBA+khGzGO4OGt9v95vhYoUOt7v1nuo3l0Wq
T0sN6UEQIyslunYLJqVwNmmBEPAuNCabdFhFfrto3BhkyFHsQqCG8S25EHWBHmcv
kbX47z/n89pdt0Frpz/c148lky/gr7T+BdWHvbuQw8FXAvRxOrtgnCzzCQyKd8Qi
xSZzbcjF5Wapy25m/N7KihAvuhWMsIENljarK5kHAGWqwZLrA+CyeVNrXXae1HFs
8TqCNUpBEoTKjBm4oZ5Cs7hazHM2XYjvddGdbWWO2B7AQRDXVf2WUCgicCvOU7nX
/6RbJqpiAPDB2W0Ye6S9B15ZAYxMzHy+B/+lBKql/pYysVEzqfvnUEkkLPayruyx
u9dRXxy2hQy7SYwuMM1/XP04b1Xrvn7S1rak09/W3GpbJrIJ56Q83Sl7L1XGb1GK
2fPn7POUiQGtY2auj4fD9K8PB3W2g5WWXSyj0ZERvoGZTL0OE2A=
=OB1z
-----END PGP SIGNATURE-----

--G6nVm6DDWH/FONJq--
