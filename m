Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay10.mail.gandi.net ([217.70.178.230]:59781 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbeI0NxK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Sep 2018 09:53:10 -0400
Date: Thu, 27 Sep 2018 09:36:13 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] rcar-vin: fix redeclaration of symbol
Message-ID: <20180927073613.GB20786@w540>
References: <20180926214006.28486-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
Content-Disposition: inline
In-Reply-To: <20180926214006.28486-1-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,

On Wed, Sep 26, 2018 at 11:40:06PM +0200, Niklas S=C3=B6derlund wrote:
> When adding support for parallel subdev for Gen3 it was missed that the
> symbol 'i' in rvin_group_link_notify() was already declare, remove the
> dupe as it's only used as a loop variable this have no functional
> change. This fixes warning:
>
>     rcar-core.c:117:52: originally declared here
>     rcar-core.c:173:30: warning: symbol 'i' shadows an earlier one
>
> Fixes: 1284605dc821cebd ("media: rcar-vin: Handle parallel subdev in link=
_notify")
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>

Acked-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Thanks
  j

> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/=
platform/rcar-vin/rcar-core.c
> index 5dd16af3625c333b..01e418c2d4c6792e 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -170,7 +170,6 @@ static int rvin_group_link_notify(struct media_link *=
link, u32 flags,
>
>  	if (csi_id =3D=3D -ENODEV) {
>  		struct v4l2_subdev *sd;
> -		unsigned int i;
>
>  		/*
>  		 * Make sure the source entity subdevice is registered as
> --
> 2.19.0
>

--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbrIhtAAoJEHI0Bo8WoVY8hvoP/2TB5oq9r1FtvmDCBiVq5y13
ZtzYE4orGKeTPyrphRniRzfy7mtQzz4ll5PgxsL5yklQpcx0nhdj79cGoqEk9gL/
p2v6yduAmh0PZVNak6wsdZ8iiuJfX767DypCAbNqMVi7akDAhG2NVHQNX/UTnJC7
PDxE8sdFfV2bYR0ndflghgv3suGX3miot3QVYkTAK2du/4qF5vmV7roL/5TQmTUq
epggfhQaAdwxaIkp2rlO+nTbA0egw57mDQ8oD4hI8JyAQL44v//qUetkjUP6Sv/B
Jj0uyi1jQIippLGtyttulVOgBkM9qh6Kq3IIYlZ5LhV5/qB/Tu22U2Gw6oXeHM9K
txG1SWOaPOHpztlgCTanRV14pZ2hsgVPuBkPqZO/pIFWVxu73REcxJ5J/Ix1+DFk
eCgxr7xPvosR+OaJeCgh5scbm+DZLLX4odY6kaDVre6BT1q9DRXW7rNUnaZxu3CK
GdPDpQZHZWPnd8j0BkNMG18GRc8y0eP2UM7eI3wirvWvYOOVjpcugUp9aFvefi6j
9j5p69IDtx7YuxZZWPo9y7um6NCeTvRpCwVpEGeBXektn8XBJkjfOlYdak4GA4Xm
pd/Zv34n0JmoxvRnUigATMaNUnm1USFMdKiaaSS85cIsMa8cBAyuHHK8hi1toyww
0DCutlHcvmxsyPXjHoKd
=Y6L+
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--
