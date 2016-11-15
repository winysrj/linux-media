Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57246 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752344AbcKOMKg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 07:10:36 -0500
Date: Tue, 15 Nov 2016 13:10:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Cc: mchehab@kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, geert+renesas@glider.be,
        akpm@linux-foundation.org, linux@roeck-us.net, hverkuil@xs4all.nl,
        dheitmueller@kernellabs.com, slongerbeam@gmail.com,
        lars@metafoo.de, robert.jarzmik@free.fr, pali.rohar@gmail.com,
        sakari.ailus@linux.intel.com, mark.rutland@arm.com,
        CARLOS.PALMINHA@synopsys.com
Subject: Re: [PATCH v4 2/2] Add support for OV5647 sensor
Message-ID: <20161115121032.GB7018@amd>
References: <cover.1479129004.git.roliveir@synopsys.com>
 <36447f1f102f648057eb9038a693941794a6c344.1479129004.git.roliveir@synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="8GpibOaaTibBMecb"
Content-Disposition: inline
In-Reply-To: <36447f1f102f648057eb9038a693941794a6c344.1479129004.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--8GpibOaaTibBMecb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Add support for OV5647 sensor.
>=20

> +static int ov5647_write(struct v4l2_subdev *sd, u16 reg, u8 val)
> +{
> +	int ret;
> +	unsigned char data[3] =3D { reg >> 8, reg & 0xff, val};
> +	struct i2c_client *client =3D v4l2_get_subdevdata(sd);
> +
> +	ret =3D i2c_master_send(client, data, 3);
> +	if (ret !=3D 3) {
> +		dev_dbg(&client->dev, "%s: i2c write error, reg: %x\n",
> +				__func__, reg);
> +		return ret < 0 ? ret : -EIO;
> +	}
> +	return 0;
> +}

Sorry, this is wrong. It should something <0 any time error is detected.

> +static int ov5647_write_array(struct v4l2_subdev *sd,
> +				struct regval_list *regs, int array_size)
> +{
> +	int i =3D 0;
> +	int ret =3D 0;
> +
> +	if (!regs)
> +		return -EINVAL;
> +
> +	while (i < array_size) {
> +		ret =3D ov5647_write(sd, regs->addr, regs->data);
> +		if (ret < 0)
> +			return ret;
> +		i++;
> +		regs++;
> +	}
> +	return 0;
> +}

For example this expects <0 on error.

> +static int set_sw_standby(struct v4l2_subdev *sd, bool standby)
> +{
> +	int ret;
> +	unsigned char rdval;
> +
> +	ret =3D ov5647_read(sd, 0x0100, &rdval);
> +	if (ret !=3D 0)
> +		return ret;
> +
> +	if (standby)
> +		ret =3D ov5647_write(sd, 0x0100, rdval&0xfe);
> +	else
> +		ret =3D ov5647_write(sd, 0x0100, rdval|0x01);
> +
> +	return ret;

if (standby)
     rdval &=3D 0xfe;
else
     rdval |=3D 0x01;

ret =3D ov5647_write(sd, 0x0100, rdval);

?


> +/**
> + * @short Store information about the video data format.
> + */
> +static struct sensor_format_struct {
> +	__u8 *desc;
> +	u32 mbus_code;

u8 is suitable here.


> +	ov5647_read(sd, 0x0100, &resetval);
> +		if (!resetval&0x01) {

add ()s here.

> +static int sensor_power(struct v4l2_subdev *sd, int on)
> +{
> +	int ret;
> +	struct ov5647 *ov5647 =3D to_state(sd);
> +	struct i2c_client *client =3D v4l2_get_subdevdata(sd);
> +
> +	ret =3D 0;
> +	mutex_lock(&ov5647->lock);
> +
> +	if (on)	{
> +		dev_dbg(&client->dev, "OV5647 power on!\n");
> +
> +		ret =3D ov5647_write_array(sd, sensor_oe_enable_regs,
> +				ARRAY_SIZE(sensor_oe_enable_regs));
> +
> +		ret =3D __sensor_init(sd);
> +
> +		if (ret < 0)
> +			dev_err(&client->dev,
> +				"Camera not available! Check Power!\n");
> +	} else {
> +		dev_dbg(&client->dev, "OV5647 power off!\n");
> +
> +		dev_dbg(&client->dev, "disable oe\n");
> +		ret =3D ov5647_write_array(sd, sensor_oe_disable_regs,
> +				ARRAY_SIZE(sensor_oe_disable_regs));
> +
> +		if (ret < 0)
> +			dev_dbg(&client->dev, "disable oe failed!\n");
> +
> +		ret =3D set_sw_standby(sd, true);
> +
> +		if (ret < 0)
> +			dev_dbg(&client->dev, "soft stby failed!\n");

dev_err for errors? Little less "!"s in the output?

> +static int sensor_get_register(struct v4l2_subdev *sd,
> +				struct v4l2_dbg_register *reg)
> +{
> +	unsigned char val =3D 0;
> +	int ret;
> +
> +	ret =3D ov5647_read(sd, reg->reg & 0xff, &val);
> +	reg->val =3D val;
> +	reg->size =3D 1;
> +	return ret;
> +}

Filling reg->* when read failed is strange.

> +static int sensor_set_register(struct v4l2_subdev *sd,
> +				const struct v4l2_dbg_register *reg)
> +{
> +	ov5647_write(sd, reg->reg & 0xff, reg->val & 0xff);
> +	return 0;
> +}

error handling?

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--8GpibOaaTibBMecb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgq+zgACgkQMOfwapXb+vLZ1wCgwsYhTurSIGKt8I7oQN3EOX+k
PvUAnjVPtIyFUqz/Z7iBCJ6jbt/8wKNF
=dGlJ
-----END PGP SIGNATURE-----

--8GpibOaaTibBMecb--
