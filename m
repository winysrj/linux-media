Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:35760 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752981AbeFHV3Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2018 17:29:25 -0400
Subject: Re: [PATCH] media: i2c: adv748x: csi2: set entity function to video
 interface bridge
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: linux-media@vger.kernel.org
References: <1528479785-5193-1-git-send-email-steve_longerbeam@mentor.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <011af984-e447-8640-4173-4bf20919905b@ideasonboard.com>
Date: Fri, 8 Jun 2018 22:29:20 +0100
MIME-Version: 1.0
In-Reply-To: <1528479785-5193-1-git-send-email-steve_longerbeam@mentor.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="50usGK7OfKygqy3bDN4LRUZuRyYODD2f8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--50usGK7OfKygqy3bDN4LRUZuRyYODD2f8
Content-Type: multipart/mixed; boundary="7mb3iVeGhVJcDjao0bXvfHGkUe5iQzDm4";
 protected-headers="v1"
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
 Mauro Carvalho Chehab <mchehab@kernel.org>,
 Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: linux-media@vger.kernel.org
Message-ID: <011af984-e447-8640-4173-4bf20919905b@ideasonboard.com>
Subject: Re: [PATCH] media: i2c: adv748x: csi2: set entity function to video
 interface bridge
References: <1528479785-5193-1-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1528479785-5193-1-git-send-email-steve_longerbeam@mentor.com>

--7mb3iVeGhVJcDjao0bXvfHGkUe5iQzDm4
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi Steve,

Thankyou for the patch.

On 08/06/18 18:43, Steve Longerbeam wrote:
> The ADV748x CSI-2 subdevices are HMDI/AFE to MIPI CSI-2 bridges.
>=20

Reading the documentation for MEDIA_ENT_F_VID_IF_BRIDGE, this seems reaso=
nable.

Out of interest, have you stumbled across this as part of your other work=
 on
CSI2 drivers - or have you been looking to test the ADV748x with your CSI=
2
receiver? I'd love to know if the driver works with other (non-renesas) p=
latforms!

> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>

Acked-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>


> ---
>  drivers/media/i2c/adv748x/adv748x-csi2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i=
2c/adv748x/adv748x-csi2.c
> index 820b44e..469be87 100644
> --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> @@ -284,7 +284,7 @@ int adv748x_csi2_init(struct adv748x_state *state, =
struct adv748x_csi2 *tx)
>  	adv748x_csi2_set_virtual_channel(tx, 0);
> =20
>  	adv748x_subdev_init(&tx->sd, state, &adv748x_csi2_ops,
> -			    MEDIA_ENT_F_UNKNOWN,
> +			    MEDIA_ENT_F_VID_IF_BRIDGE,
>  			    is_txa(tx) ? "txa" : "txb");
> =20
>  	/* Ensure that matching is based upon the endpoint fwnodes */
>=20


--7mb3iVeGhVJcDjao0bXvfHGkUe5iQzDm4--

--50usGK7OfKygqy3bDN4LRUZuRyYODD2f8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEkC3XmD+9KP3jctR6oR5GchCkYf0FAlsa9TAACgkQoR5GchCk
Yf1ueA//V6RI2I59QTXyjN7pcOZx91w9GSTWupyo1F7P4kNo92IOKOHwiIJRmS9d
HQzM5c1O9vCP/eALe9KY4pw9J1IaPo+c/s4cyPumZzrq3kPzseMKxSaotq/J6iye
ot7YIQ2DJfSFj8lHu+6qjNOTLti01Z1t2vbF2JecjDzVqtGnzziLiZOTIgOONo0W
Zvlg+46+qRIX2zSIYKKJuJKAyQ4iJUgwGN7L565phqLITiZoRZAUvpOWkeqQ1l1O
jScdpMpUTMAKZwkFLlqE++0ZQk9b4R4tXk2Ix39bzVYNFh/Za7RJEb65IUjYeeeo
NVpYroLzUAaNb7NxoqBmox0cKgnA5JFIp1bSdw+S8FC2bmZxh/SKDM0nl6KWgWAo
ukFQo1tpKOxo8/PbwFRrZyKAj2JtLvHpfL93S4hjKe2IBI4u6vx5KTd5tiftjgrq
TtD75XuvBG/DFoPu4yMAQiDMzeVUyqeabF8/Ahxr+gx/O3fJ5rXUOXHG5mUB3/X1
Fd6PsnFZMhcWSsKsnrO7o10RuJHEd4ebZMSpstwZG2tbYdUPHth52G7ktwLevNx7
M7R4HF3UWHCs6BqObLWM5V7TJQp972+P2/byR4C+WQ3EYpcDVauBYeBtW57XYv80
H1wDxYxg4fp/LJpvpW4897HQsaKO1hQlie6+Gkkch4E5XrHeTow=
=DUeR
-----END PGP SIGNATURE-----

--50usGK7OfKygqy3bDN4LRUZuRyYODD2f8--
