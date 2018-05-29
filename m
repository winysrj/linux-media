Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55664 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933548AbeE2NAJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 09:00:09 -0400
Date: Tue, 29 May 2018 09:59:59 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH v5 03/14] media: ov772x: allow i2c controllers without
 I2C_FUNC_PROTOCOL_MANGLING
Message-ID: <20180529095657.675a6f54@vento.lan>
In-Reply-To: <1525616369-8843-4-git-send-email-akinobu.mita@gmail.com>
References: <1525616369-8843-1-git-send-email-akinobu.mita@gmail.com>
        <1525616369-8843-4-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun,  6 May 2018 23:19:18 +0900
Akinobu Mita <akinobu.mita@gmail.com> escreveu:

> The ov772x driver only works when the i2c controller have
> I2C_FUNC_PROTOCOL_MANGLING.  However, many i2c controller drivers don't
> support it.
>=20
> The reason that the ov772x requires I2C_FUNC_PROTOCOL_MANGLING is that
> it doesn't support repeated starts.
>=20
> This changes the reading ov772x register method so that it doesn't
> require I2C_FUNC_PROTOCOL_MANGLING by calling two separated i2c messages.

I had a D=C3=A9j=C3=A0 vu when I looked on this patch, as I saw the same
issue I pointed to another patch you submitted ;-)

So, I ended by not replying to this one. Just to be clear: the same
comment I did to the SCCB helpers apply here:

	https://www.mail-archive.com/linux-media@vger.kernel.org/msg130868.html

It is a very bad idea to replace an i2c xfer by a pair of i2c
send()/recv(), as, if are there any other device at the bus managed
by an independent driver, you may end by mangling i2c transfers and
eventually cause device malfunctions.

I've seen it a lot on media devices that have devices that need
constant polling via I2C (e. g. hardware with remote controllers,
for example).

So, IMO, the best is to push the patch you proposed that adds a
new I2C flag:

	https://patchwork.linuxtv.org/patch/49396/
=20
> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
> * v5
> - Add Reviewed-by: line
>=20
>  drivers/media/i2c/ov772x.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index e255070..b6223bf 100644
> --- a/drivers/media/i2c/ov772x.c
> +++ b/drivers/media/i2c/ov772x.c
> @@ -542,9 +542,19 @@ static struct ov772x_priv *to_ov772x(struct v4l2_sub=
dev *sd)
>  	return container_of(sd, struct ov772x_priv, subdev);
>  }
> =20
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
> =20
>  static inline int ov772x_write(struct i2c_client *client, u8 addr, u8 va=
lue)
> @@ -1255,13 +1265,11 @@ static int ov772x_probe(struct i2c_client *client,
>  		return -EINVAL;
>  	}
> =20
> -	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA |
> -					      I2C_FUNC_PROTOCOL_MANGLING)) {
> +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
>  		dev_err(&adapter->dev,
> -			"I2C-Adapter doesn't support SMBUS_BYTE_DATA or PROTOCOL_MANGLING\n");
> +			"I2C-Adapter doesn't support SMBUS_BYTE_DATA\n");
>  		return -EIO;
>  	}
> -	client->flags |=3D I2C_CLIENT_SCCB;
> =20
>  	priv =3D devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
>  	if (!priv)



Thanks,
Mauro
