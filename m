Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:36485 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751367AbeDIG6T (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 02:58:19 -0400
Date: Mon, 9 Apr 2018 08:58:12 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH 1/6] media: ov772x: allow i2c controllers without
 I2C_FUNC_PROTOCOL_MANGLING
Message-ID: <20180409065812.GT20945@w540>
References: <1523116090-13101-1-git-send-email-akinobu.mita@gmail.com>
 <1523116090-13101-2-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="R9dSeJxMIUBTi9Do"
Content-Disposition: inline
In-Reply-To: <1523116090-13101-2-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--R9dSeJxMIUBTi9Do
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello Akinobu,
    thank you for the patch.

On which platform have you tested the series (just curious) ?

On Sun, Apr 08, 2018 at 12:48:05AM +0900, Akinobu Mita wrote:
> The ov772x driver only works when the i2c controller have
> I2C_FUNC_PROTOCOL_MANGLING.  However, many i2c controller drivers don't
> support it.
>
> The reason that the ov772x requires I2C_FUNC_PROTOCOL_MANGLING is that
> it doesn't support repeated starts.
>
> This change adds an alternative method for reading from ov772x register
> which uses two separated i2c messages for the i2c controllers without
> I2C_FUNC_PROTOCOL_MANGLING.

Actually, and please correct me if I'm wrong, what I see here is that
an i2c_master_send+i2c_master_recv sequence is equivalent to a mangled
smbus transaction:

i2c_smbus_read_byte_data | I2C_CLIENT_SCCB:
S Addr Wr [A] Comm [A] P S Addr Rd [A] [Data] NA P

i2c_master_send() + i2c_master_recv():
S Addr Wr [A] Data [A] P
S Addr Rd [A] [Data] NA P

I wonder if it is not worth to ditch the existing read() function in
favour of your new proposed one completely.

I have tested it on the Migo-R board where I have an ov772x installed
and it works fine.

Although I would like to have a confirmation this is fine by people
how has seen more i2c adapters in action than me :)

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
>  drivers/media/i2c/ov772x.c | 42 +++++++++++++++++++++++++++++++++---------
>  1 file changed, 33 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index b62860c..283ae2c 100644
> --- a/drivers/media/i2c/ov772x.c
> +++ b/drivers/media/i2c/ov772x.c
> @@ -424,6 +424,7 @@ struct ov772x_priv {
>  	/* band_filter = COM8[5] ? 256 - BDBASE : 0 */
>  	unsigned short                    band_filter;
>  	unsigned int			  fps;
> +	int (*reg_read)(struct i2c_client *client, u8 addr);
>  };
>
>  /*
> @@ -542,11 +543,34 @@ static struct ov772x_priv *to_ov772x(struct v4l2_subdev *sd)
>  	return container_of(sd, struct ov772x_priv, subdev);
>  }
>
> -static inline int ov772x_read(struct i2c_client *client, u8 addr)
> +static int ov772x_read(struct i2c_client *client, u8 addr)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct ov772x_priv *priv = to_ov772x(sd);
> +
> +	return priv->reg_read(client, addr);
> +}
> +
> +static int ov772x_reg_read(struct i2c_client *client, u8 addr)
>  {
>  	return i2c_smbus_read_byte_data(client, addr);
>  }
>
> +static int ov772x_reg_read_fallback(struct i2c_client *client, u8 addr)
> +{
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
> +}
> +
>  static inline int ov772x_write(struct i2c_client *client, u8 addr, u8 value)
>  {
>  	return i2c_smbus_write_byte_data(client, addr, value);
> @@ -1255,20 +1279,20 @@ static int ov772x_probe(struct i2c_client *client,
>  		return -EINVAL;
>  	}
>
> -	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA |
> -					      I2C_FUNC_PROTOCOL_MANGLING)) {
> -		dev_err(&adapter->dev,
> -			"I2C-Adapter doesn't support SMBUS_BYTE_DATA or PROTOCOL_MANGLING\n");
> -		return -EIO;
> -	}
> -	client->flags |= I2C_CLIENT_SCCB;
> -
>  	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
>  	if (!priv)
>  		return -ENOMEM;
>
>  	priv->info = client->dev.platform_data;
>
> +	if (i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA |
> +					     I2C_FUNC_PROTOCOL_MANGLING))
> +		priv->reg_read = ov772x_reg_read;
> +	else
> +		priv->reg_read = ov772x_reg_read_fallback;
> +
> +	client->flags |= I2C_CLIENT_SCCB;
> +
>  	v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
>  	v4l2_ctrl_handler_init(&priv->hdl, 3);
>  	v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
> --
> 2.7.4
>

--R9dSeJxMIUBTi9Do
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJayw8EAAoJEHI0Bo8WoVY8fWkP/jLN1Zp/qa2iOGQes3Z2Pw/I
LaioXOdf4wLNq0Jo27AljU7deMBvHAggAg1YHDE0dpwI9Yf0LD7Libli7Kjdhifp
HNb+S1NNaBNZMYYTE0sPNbbFxPc9ce82QSYs4b1wiQH8kn0mL9itMf0K9rnPMmnb
zSZV7mbpqoS4iFcEQvxSpUnnh61vz+VfdnahViclSovYFWG/qWEKQnXJDU2EXehh
8zTyTJZ3WhMxWBx7r5rdmZqOhQYGg4rFxXRqZ0GF/6BJq4I+ckGe/VCrb6YIWYAk
mqY80WbPLM+2ALOvB8HXURP848/R4T+hrYR4W/RfWMkcusSaUiUjkE1pwgb97Cix
kSdpBKcB8QGi8xSK6w5Kq6uFeuibray1xGqGIpy4tkAKlWkTK/2ydQnhzp8aXQzA
ziE7Re0StzyopK5hvvQTXs5xmeDP80bnWglJveaViRDhDM9PM6vXIowVxe9wGArm
w/Vp458bkExeRwdsvZq8AMdub6xXfI1WhLjueT1cx4uzTqqcsGNoOttxJMQu2R8T
bCrtCoQ6Y1q4zFAaeH0GqJ/ItYOhVQTMGpPEKO0UBOwTYvQ2e2RROead1W70UDfy
plzMqz/t6qBMOJ6G3G4RW7xjBqN9/C1+kVeDsWBg6ZikIOZs8VqDw1BB5Mh7193D
w41qX/pt6VoYL4naalP2
=Rk4Z
-----END PGP SIGNATURE-----

--R9dSeJxMIUBTi9Do--
