Return-path: <linux-media-owner@vger.kernel.org>
Received: from iodev.co.uk ([82.211.30.53]:43312 "EHLO iodev.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752732AbdHUMOF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 08:14:05 -0400
Date: Mon, 21 Aug 2017 09:13:52 -0300
From: Ismael Luceno <ismael@iodev.co.uk>
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: julia.lawall@lip6.fr, mchehab@kernel.org,
        maintainers@bluecherrydvr.com, andrey.utkin@corp.bluecherry.net,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] [media] solo6x10: make snd_kcontrol_new const
Message-ID: <20170821121350.GA10157@pirotess.bf.iodev.co.uk>
References: <1502875025-3224-1-git-send-email-bhumirks@gmail.com>
 <1502875025-3224-3-git-send-email-bhumirks@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <1502875025-3224-3-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16/Aug/2017 14:47, Bhumika Goyal wrote:
> Make this const as it is only used during a copy operation.
> Done using Coccinelle.
>=20
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
> ---
>  drivers/media/pci/solo6x10/solo6x10-g723.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/pci/solo6x10/solo6x10-g723.c b/drivers/media/p=
ci/solo6x10/solo6x10-g723.c
> index 3ca9470..81be1b8 100644
> --- a/drivers/media/pci/solo6x10/solo6x10-g723.c
> +++ b/drivers/media/pci/solo6x10/solo6x10-g723.c
> @@ -319,7 +319,7 @@ static int snd_solo_capture_volume_put(struct snd_kco=
ntrol *kcontrol,
>  	return 1;
>  }
> =20
> -static struct snd_kcontrol_new snd_solo_capture_volume =3D {
> +static const struct snd_kcontrol_new snd_solo_capture_volume =3D {
>  	.iface =3D SNDRV_CTL_ELEM_IFACE_MIXER,
>  	.name =3D "Capture Volume",
>  	.info =3D snd_solo_capture_volume_info,
> --=20
> 1.9.1
>=20

Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEAqyZ04eQQpueXW0v7JuE7EFrBNgFAlmazm8ACgkQ7JuE7EFr
BNhRUA/+LRvXaJ2BB/ddht4CbG+ZoLY+7JWCUHHGuCmGQ6ssOrZkIFcmP6TSQid4
/0+VVbaOFFOhU4Qtc12CzApU13HuBMVKAQAvKUahIQgQ+dCbSNLekuJMSbIeCB/M
c/wGNyeICzCnIPZkLGHOE1mx2irn6hjXrHJH1RLEwqEPS0hMCozNm869cENr48Bb
HDFEP1gsRWMRcfZwkP2oVRc3uT7+CUHQgrsxHl8MB073iXPBBVqzb95Z+l9ujqc7
/OQmJ4NZO8iM2YtZg6eE/z2AVqtWH62pESIVX4a+bMQUr85EVHvLRRx8V0HNH7bt
quWD9XuubPpJu+p08xuErmg5Cw2o3IuYBkK0ANszS8equEM7YzOMwBAn9vFfYyFp
E6V25OMUOV7nS1OrTLO9NAEtPfgz4J+mtSVJoK9xT9gOEmF8jqAcgDes3rdit2e1
jw7dHZGSlNVFYi7si8J1J/UKqMlGlSmCUF25NBocNTmFI8GCpAc8rY/TSE9Jiqyk
FDRBuf5nzLxA6sC66ME7Oys2xIwy39eYC5ckUFCFRjNhFWTKhTFI8n+glpt1P3Vm
dtgA1MYy+TJS/xZ7bUJfWB6UIzfpTg8/VDp66oEqWqt4CpAlkHvYvsYdRaLCR9dh
8UNG022AtfCIChGv9OHCmuxXd5e8ksTTUNgTVn7+Ao64CUY7CUQ=
=6svl
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
