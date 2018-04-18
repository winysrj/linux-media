Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:42311 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752699AbeDRKHO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 06:07:14 -0400
Date: Wed, 18 Apr 2018 12:05:49 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v2 01/10] media: ov772x: allow i2c controllers without
 I2C_FUNC_PROTOCOL_MANGLING
Message-ID: <20180418100549.GA17088@w540>
References: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
 <1523847111-12986-2-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
In-Reply-To: <1523847111-12986-2-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Akinobu,

On Mon, Apr 16, 2018 at 11:51:42AM +0900, Akinobu Mita wrote:
> The ov772x driver only works when the i2c controller have
> I2C_FUNC_PROTOCOL_MANGLING.  However, many i2c controller drivers don't
> support it.
>
> The reason that the ov772x requires I2C_FUNC_PROTOCOL_MANGLING is that
> it doesn't support repeated starts.
>
> This changes the reading ov772x register method so that it doesn't
> require I2C_FUNC_PROTOCOL_MANGLING by calling two separated i2c messages.
>
> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
> * v2
> - Replace the implementation of ov772x_read() instead of adding an
>   alternative method

I now wonder if my initial reply to this patch was wrong, and where
possible we should try to use smbus operations...

=46rom Documentation/i2c/smbus-protocol
"If you write a driver for some I2C device, please try to use the SMBus
commands if at all possible... " and that's because, according to
documentation, most I2c adapters support smbus protocol but may not
support the full i2c command set.

The fact this driver then restricts the supported adapters to the ones
that support protocol mangling makes me think your change is fine,
but as it often happens, I would scale this to more knowledgable
people...

>
>  drivers/media/i2c/ov772x.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index b62860c..7e79da0 100644
> --- a/drivers/media/i2c/ov772x.c
> +++ b/drivers/media/i2c/ov772x.c
> @@ -542,9 +542,19 @@ static struct ov772x_priv *to_ov772x(struct v4l2_sub=
dev *sd)
>  	return container_of(sd, struct ov772x_priv, subdev);
>  }
>
> -static inline int ov772x_read(struct i2c_client *client, u8 addr)
> +static int ov772x_read(struct i2c_client *client, u8 addr)
>  {
> -	return i2c_smbus_read_byte_data(client, addr);
> +	int ret;
> +	u8 val;
> +
> +	ret =3D i2c_master_send(client, &addr, 1);
> +	if (ret < 0)
> +		return ret;
> +	ret =3D i2c_master_recv(client, &val, 1);
> +	if (ret < 0)
> +		return ret;
> +
> +	return val;
>  }
>
>  static inline int ov772x_write(struct i2c_client *client, u8 addr, u8 va=
lue)
> @@ -1255,10 +1265,9 @@ static int ov772x_probe(struct i2c_client *client,
>  		return -EINVAL;
>  	}
>
> -	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA |
> -					      I2C_FUNC_PROTOCOL_MANGLING)) {
> +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
>  		dev_err(&adapter->dev,
> -			"I2C-Adapter doesn't support SMBUS_BYTE_DATA or PROTOCOL_MANGLING\n");
> +			"I2C-Adapter doesn't support SMBUS_BYTE_DATA\n");
>  		return -EIO;
>  	}
>  	client->flags |=3D I2C_CLIENT_SCCB;

I think you can remove this flag if we're using plain i2c
transactions. Sorry, I have missed this in v1.

Thanks
   j

> --
> 2.7.4
>

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa1xh9AAoJEHI0Bo8WoVY8QDUP/R7ABENgZRwYFuAgAewOvyoh
G+2UjgiN2GZ2RE6sjIEgut3j68b/PKmoQH3StalgmikfdnevVikYvk/20zLttZbN
OdOsi66DGURypqeI5+zuXLYW1GMoYM+0nF3103cM/4sOMbQgPIuLWxYpasuBuKgp
3wdWsE3PDLJneFtgdPhqkC6+MECptL8Tq6b9Qa7opmt4TmVDIcd8I0bqJZOFipvF
Piyd8WhrDmbefiSW5zmNhFuLecn9kObp6yUf1RjAhbtpAevtDkXHHcKDAYmJG4vR
evAtaB3GVQGX4wB98p6mJka+2/CoZYOtOjW2eaber2jCvnUAoeYwrNq75U2f+vRL
VcOdIH7u5bnM6O+QRbzF2nJoQGi0yomhzepLmBdqtwlJaRuRcH3IkOwaFiboltxJ
C9b3Av1bWv54EwkFUgmmharLsszxFIlBvic5ah6jkg1kv6Q97Tka5cKOCI3aFYPV
H0xw+qudPKxyUAkNBJ99gl+k7Rt445ziAcr/Tne9T95ZyWlE2noH7J4dX2DVF9Tu
zpJCPIgtUOLMznE0IM1Cvoeo+N0yMfZxEvmZ8LVkyFvMwEAF3vZuGZey2DxrrO56
198w1mCFdu4YJov77km+awuV24oactjd6w2sUPjrBtOudUhHT36sJRc/EG3OpbvK
MsZdQZYEjmZVk6EMd1kB
=FByX
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
