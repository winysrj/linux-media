Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44836 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754605Ab2HST3r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Aug 2012 15:29:47 -0400
Message-ID: <1345404569.22400.64.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [patch] [media] rc: divide by zero bugs in s_tx_carrier()
From: Ben Hutchings <ben@decadent.org.uk>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jarod Wilson <jarod@redhat.com>,
	Luis Henriques <luis.henriques@canonical.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Sun, 19 Aug 2012 20:29:29 +0100
In-Reply-To: <20120818155850.GA11819@elgon.mountain>
References: <20120818155850.GA11819@elgon.mountain>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-0t80kclXEh6B75DHwZqj"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-0t80kclXEh6B75DHwZqj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-08-18 at 18:58 +0300, Dan Carpenter wrote:
> "carrier" comes from a get_user() in ir_lirc_ioctl().  We need to test
> that it's not zero before using it as a divisor.

Other RC drivers seem to have the same problem, only more deeply buried.
I think it's better to put this check in ir_lirc_ioctl() instead,
consistent with LIRC_SET_REC_CARRIER.

Ben.

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>=20
> diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
> index 647dd95..d05ac15 100644
> --- a/drivers/media/rc/ene_ir.c
> +++ b/drivers/media/rc/ene_ir.c
> @@ -881,10 +881,13 @@ static int ene_set_tx_mask(struct rc_dev *rdev, u32=
 tx_mask)
>  static int ene_set_tx_carrier(struct rc_dev *rdev, u32 carrier)
>  {
>  	struct ene_device *dev =3D rdev->priv;
> -	u32 period =3D 2000000 / carrier;
> +	u32 period;
> =20
>  	dbg("TX: attempt to set tx carrier to %d kHz", carrier);
> +	if (carrier =3D=3D 0)
> +		return -EINVAL;
> =20
> +	period =3D 2000000 / carrier;
>  	if (period && (period > ENE_CIRMOD_PRD_MAX ||
>  			period < ENE_CIRMOD_PRD_MIN)) {
> =20
> diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-ci=
r.c
> index 699eef3..2ea913a 100644
> --- a/drivers/media/rc/nuvoton-cir.c
> +++ b/drivers/media/rc/nuvoton-cir.c
> @@ -517,6 +517,9 @@ static int nvt_set_tx_carrier(struct rc_dev *dev, u32=
 carrier)
>  	struct nvt_dev *nvt =3D dev->priv;
>  	u16 val;
> =20
> +	if (carrier =3D=3D 0)
> +		return -EINVAL;
> +
>  	nvt_cir_reg_write(nvt, 1, CIR_CP);
>  	val =3D 3000000 / (carrier) - 1;
>  	nvt_cir_reg_write(nvt, val & 0xff, CIR_CC);
>=20

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-0t80kclXEh6B75DHwZqj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUDE+mee/yOyVhhEJAQoiVhAAvcSyg4OkHhyvnGeRwApgaxFy5ZZPKtPX
oYGtQK73y4kD8JbSg2XhR/1BN4dTFELLzhFa41OI3QaOEO7Y+W3n7KB7/DGfN+QT
ABoxOeC3SzH8+SCK2wfO4EDBet55VRPMjkmnvDOmn7BkcL6FzeKxfp7pHDNDa16H
KgYFPBGaJPeos+/1OVFQIkCNMldKGu+18U3ovPXZR3W/KfuRBuHKviae0PFp5Gi8
ett5lcsjsnIsxN4K06g6XPK3eSWl8OCCg4XjkWi5/uLx8TR+CDRZS7hoy0R8REfo
ICwz2KvSyTVj5BUiFKaKCGgBFdkvvfCTto/q8CNPGRHPmjaLRLjfrS00yqZGCevI
QUOlFXIpgVVHQ/z8Zy9Wq7sUNbxzm9GztNd2+DzWfVUqLNjYLASkjsiFZwG87xua
i8L48o56TsYRCQ8MC9LS7ht0ygHFHXpw2N36GS3gAsyVEv4QlApl1gs2pOn3LKvG
+/2oK609BGQ1Ar0GaaSxM3X6NF1TkeXiZKCyKiE4Xp9uDno3IfsWhVAlHraQQP3j
xEXgB9Z9C7VSWxlFnJ3hLYu2JRXJ8yda8aYNXInQyuUNgCnWivTDJbqdRGXQGUIP
T85oA2TvCtM9LpbEtcoGRukkBmWuXPPtEsPS9IXln1n31HMcZrkbrphcNeZ9DGsN
Bv8GliNf/ek=
=J3Z8
-----END PGP SIGNATURE-----

--=-0t80kclXEh6B75DHwZqj--
