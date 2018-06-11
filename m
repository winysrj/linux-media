Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:37419 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933508AbeFKQoI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Jun 2018 12:44:08 -0400
Date: Mon, 11 Jun 2018 18:43:57 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH] media: soc_camera: ov772x: correct setting of banding
 filter
Message-ID: <20180611164343.GA4952@w540>
References: <1528645346-19401-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zCKi3GIZzVBPywwA"
Content-Disposition: inline
In-Reply-To: <1528645346-19401-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--zCKi3GIZzVBPywwA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Mita-san,

On Mon, Jun 11, 2018 at 12:42:26AM +0900, Akinobu Mita wrote:
> The banding filter ON/OFF is controlled via bit 5 of COM8 register.  It
> is attempted to be enabled in ov772x_set_params() by the following line.
>
> 	ret = ov772x_mask_set(client, COM8, BNDF_ON_OFF, 1);
>
> But this unexpectedly results disabling the banding filter, because the
> mask and set bits are exclusive.
>
> On the other hand, ov772x_s_ctrl() correctly sets the bit by:
>
> 	ret = ov772x_mask_set(client, COM8, BNDF_ON_OFF, BNDF_ON_OFF);
>
> The same fix was already applied to non-soc_camera version of ov772x
> driver in the commit commit a024ee14cd36 ("media: ov772x: correct setting
> of banding filter")

This driver is aimed for removal, but until it's there, as per the
patch you mentioned:
Acked-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Thanks
   j

>
> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  drivers/media/i2c/soc_camera/ov772x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
> index 8063835..14377af 100644
> --- a/drivers/media/i2c/soc_camera/ov772x.c
> +++ b/drivers/media/i2c/soc_camera/ov772x.c
> @@ -834,7 +834,7 @@ static int ov772x_set_params(struct ov772x_priv *priv,
>  	 * set COM8
>  	 */
>  	if (priv->band_filter) {
> -		ret = ov772x_mask_set(client, COM8, BNDF_ON_OFF, 1);
> +		ret = ov772x_mask_set(client, COM8, BNDF_ON_OFF, BNDF_ON_OFF);
>  		if (!ret)
>  			ret = ov772x_mask_set(client, BDBASE,
>  					      0xff, 256 - priv->band_filter);
> --
> 2.7.4
>

--zCKi3GIZzVBPywwA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbHqbNAAoJEHI0Bo8WoVY8k1QQAI3AiBAUC/9WdZQtcnH/cg2P
/CzpgHgEdypqD/7vZSiwRvGDCuFqg0cgZAR2PICTJNOjoXBXrIxIkFBr3q7M6p8o
NwQsgkCUlsbzBBTD8Hruc9r8p7q84KMSD935OYk4UApxhF81OQnfF9Wi3qL2PGDL
oQ0kKr32LnWq9oniTDbjRgDgUz5nJinBjAs6sqUT0IHgZNIL94fL20KhMXDRDEHF
yCk1qB5aamJ2nkYwZx4v+fgySioMBMbdK82yTkpTkujThvfqRQou8/KYVb+oCGyo
vRhKgqoJT4Hv2m3+LvXQ/mPQbuWhfceH+kWziQlhwKRlaZWkG3qe7U22uIY+FIO8
Q7NGuJo4lbHOZhXxrrG8jfieDrLqMC/DhEIlMRAiDWijxUOOnUb0DJlQBtWD09cc
dQ4joY2pNMuTblfAc/kktRRqOD7Dk1ttRjh7klXpotQfM5GGeEwlYVlIRQTtvv7U
KzBgILZxAK5gIqvxN0C0QWI12Dbj7kdmLj5oVuiD+StBkLlO55ox0lAsISBvUKQz
c9d/Kv/u+cM8UYk/dxjrQbyvwGS+NBEjzovuHXZ3RDRWH2mjDFBApWLHbn6k7Qpq
6bczmU3OoZbQDUM3cAOPT1fxKZebb0Lmgk5MgCRPQlaADgxhdH7EPiyx0AOq6Dz/
s1ALyiBel5zW/KkF7qH8
=VDH0
-----END PGP SIGNATURE-----

--zCKi3GIZzVBPywwA--
