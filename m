Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:39863 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751137AbeECPqv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 11:46:51 -0400
Date: Thu, 3 May 2018 17:46:43 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH v4 03/14] media: ov772x: allow i2c controllers without
 I2C_FUNC_PROTOCOL_MANGLING
Message-ID: <20180503154643.GC19612@w540>
References: <1525021993-17789-1-git-send-email-akinobu.mita@gmail.com>
 <1525021993-17789-4-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ncSAzJYg3Aa9+CRW"
Content-Disposition: inline
In-Reply-To: <1525021993-17789-4-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ncSAzJYg3Aa9+CRW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Akinobu,

On Mon, Apr 30, 2018 at 02:13:02AM +0900, Akinobu Mita wrote:
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
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

As you have sent a separate series to move the SCCB case handling to
the i2c core, and I feel like it may take some time to get there, as
Sakari suggested, I'm fine with this change in the driver code.

Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Thanks
  j

> ---
> * v4
> - No changes
>
>  drivers/media/i2c/ov772x.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index e255070..b6223bf 100644
> --- a/drivers/media/i2c/ov772x.c
> +++ b/drivers/media/i2c/ov772x.c
> @@ -542,9 +542,19 @@ static struct ov772x_priv *to_ov772x(struct v4l2_subdev *sd)
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
> +	ret = i2c_master_send(client, &addr, 1);
> +	if (ret < 0)
> +		return ret;
> +	ret = i2c_master_recv(client, &val, 1);
> +	if (ret < 0)
> +		return ret;
> +
> +	return val;
>  }
>
>  static inline int ov772x_write(struct i2c_client *client, u8 addr, u8 value)
> @@ -1255,13 +1265,11 @@ static int ov772x_probe(struct i2c_client *client,
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
> -	client->flags |= I2C_CLIENT_SCCB;
>
>  	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
>  	if (!priv)
> --
> 2.7.4
>

--ncSAzJYg3Aa9+CRW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa6y7jAAoJEHI0Bo8WoVY8FKcQAIJweuIR2i8cbqot8QpADbdL
Q1zLbhPCYqFxrKwiLa49sINDNdwpCJsqBFAL+Ef/Pt0RGDNbiZLA/MzL2RYdjVLR
ELk/6P1gGOVMEAblIqGEnfWfwklUSg2mMU/wLmO+3CfPi5qNC+DktdaPjJgJx4TO
Ez95JOPkZGFc3OXKh7xOGOTh8A0cR5DvkM4rKX1o1Ey4pbWOmeGB3EPbGmZp/Hy4
Cx4HLhuWlpsM7m5rMsH+VB3i5tQvxmTm7AwHlyuMUdAXHDtIiJHzeEkbrlUdK9OP
xXIVMY9qkZB4gr8HGUhv1cBVSYRmiyJFNeMyIWzo6+4fkdbwHZX9GX4meVrKXrRq
Uc7rAy/kmXu1zSHMv122R8SPRa5VbM0KCH+BfKZcR0PEG2zofBEEzaIYbnMeIM8p
M2lXIAeHm7sVtUpT+mcLCXyzSCr+0ffGUWFgPX90APO5/80Mof5GEnLuv5caWLGj
F0AJC+KGagyHn8y+UdT2mFSqO4mlLuKQK2NIoXDjcKk3B0zySUA8jEIPsXFAEHoK
O4wGAfIywhW5tU71Z7cDavF+cmrfJ2ASITjd1VbUPOanZzZN/kzweQZk85C2Tojy
QDNs1zEjlduUJNZEHjpvN/NH0aVnekrvVzbI61PiGK778dybm9aHYlwSQOM0edUZ
IAKR/rSIljxd0XMrbiPj
=ytqw
-----END PGP SIGNATURE-----

--ncSAzJYg3Aa9+CRW--
