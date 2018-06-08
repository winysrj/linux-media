Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:35982 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753126AbeFHVjG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2018 17:39:06 -0400
Subject: Re: [PATCH] media: i2c: adv748x: csi2: set entity function to video
 interface bridge
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1528479785-5193-1-git-send-email-steve_longerbeam@mentor.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <94861795-e8ac-7c61-dee4-410083d7d388@ideasonboard.com>
Date: Fri, 8 Jun 2018 22:39:01 +0100
MIME-Version: 1.0
In-Reply-To: <1528479785-5193-1-git-send-email-steve_longerbeam@mentor.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="bVQZhsGe5yS0eDMItR0pJqs1YEqBLd2ME"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bVQZhsGe5yS0eDMItR0pJqs1YEqBLd2ME
Content-Type: multipart/mixed; boundary="McSuNv7nQVbR0FMUVRIKHelvYTRZrCepZ";
 protected-headers="v1"
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
 Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org,
 Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <94861795-e8ac-7c61-dee4-410083d7d388@ideasonboard.com>
Subject: Re: [PATCH] media: i2c: adv748x: csi2: set entity function to video
 interface bridge
References: <1528479785-5193-1-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1528479785-5193-1-git-send-email-steve_longerbeam@mentor.com>

--McSuNv7nQVbR0FMUVRIKHelvYTRZrCepZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On 08/06/18 18:43, Steve Longerbeam wrote:
> The ADV748x CSI-2 subdevices are HMDI/AFE to MIPI CSI-2 bridges.

Just spotted this :D

s/HMDI/HDMI/

Regards

Kieran

>=20
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
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


--McSuNv7nQVbR0FMUVRIKHelvYTRZrCepZ--

--bVQZhsGe5yS0eDMItR0pJqs1YEqBLd2ME
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEkC3XmD+9KP3jctR6oR5GchCkYf0FAlsa93UACgkQoR5GchCk
Yf35dQ/+MOpdXa3cd+jwvIdOnhm9M0VFrYPh3//l/5PJ2ge1H6kjwgusvwCMl5y3
Thb7jW8IdD1IciGdvO78Go0IwsGjJutrsUtNDw69fsymrr6PvX8Yg0oUe2W3RoaX
W6TKUr9Q4MFB5Ei0NKzv4fWLyzLEyERdHsUQRrQVERoZkNA02bvHcnv4N/wUpWvg
W7lIPw27gWjZ0zch0V8QdIt4njEHUNABIDBIA7XNAKoeOvniH3wXcPj8rc4lP6PL
swZLb0HYU3ZIu5+D7CqqAGD3H6/vLGcJfTyDqKk2kqzh9YzwWNJ0MQJOmMHt2Bb3
hgeU6uAzwIt9gNpQhl8M9jBG/HV5EFCxOgGl5/AtcO2n8itZOhvifHDcn5wzMEyk
iQmgZhTTtx63z+70rKuHUQFK9dJ5kvRI4neiiX7PBshsx0Drhs0yT/vmqCgPGxDl
blwaC+bzSudUp2c2Up5/+EHZnBIc8jG/WHSbpJ5tse1xtVnmOOkxvGXLRZ+5es6B
fnHwVQ8ZF5lbKqxCK0xKplTK0/rw+y47RmE2ZKVXNo2fJ71LdWkh2A59L63J1B26
caky8M/YN6HYzesBXNCj5boRr4Bbu/UJtI07/tp/beQwd3jS5F5uTS4HqdzIGjd4
zCyTvF58aB7KsEaGfgTuuDg1nl/q/aK+NXtnkpeZbVjgdVGQuts=
=7J/0
-----END PGP SIGNATURE-----

--bVQZhsGe5yS0eDMItR0pJqs1YEqBLd2ME--
