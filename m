Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57374 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751440AbdJDKrU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Oct 2017 06:47:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Todor Tomov <todor.tomov@linaro.org>, mchehab@kernel.org,
        hansverk@cisco.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH] [media] ov5645: I2C address change
Date: Wed, 04 Oct 2017 13:47:22 +0300
Message-ID: <3073637.dhNDna4gKQ@avalon>
In-Reply-To: <20171004103008.g7azpn4a3hfj4fs2@valkosipuli.retiisi.org.uk>
References: <1506950925-13924-1-git-send-email-todor.tomov@linaro.org> <20171004103008.g7azpn4a3hfj4fs2@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CC'ing the I2C mainling list and the I2C maintainer.

On Wednesday, 4 October 2017 13:30:08 EEST Sakari Ailus wrote:
> Hi Todor,
>=20
> On Mon, Oct 02, 2017 at 04:28:45PM +0300, Todor Tomov wrote:
> > As soon as the sensor is powered on, change the I2C address to the one
> > specified in DT. This allows to use multiple physical sensors connected
> > to the same I2C bus.
> >=20
> > Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>=20
> The smiapp driver does something similar and I understand Laurent might be
> interested in such functionality as well.
>=20
> It'd be nice to handle this through the I=B2C framework instead and to de=
fine
> how the information is specified through DT. That way it could be made
> generic, to work with more devices than just this one.
>=20
> What do you think?
>=20
> Cc Laurent.
>=20
> > ---
> >=20
> >  drivers/media/i2c/ov5645.c | 42 ++++++++++++++++++++++++++++++++++++++=
++
> >  1 file changed, 42 insertions(+)
> >=20
> > diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
> > index d28845f..8541109 100644
> > --- a/drivers/media/i2c/ov5645.c
> > +++ b/drivers/media/i2c/ov5645.c
> > @@ -33,6 +33,7 @@
> >  #include <linux/i2c.h>
> >  #include <linux/init.h>
> >  #include <linux/module.h>
> > +#include <linux/mutex.h>
> >  #include <linux/of.h>
> >  #include <linux/of_graph.h>
> >  #include <linux/regulator/consumer.h>
> > @@ -42,6 +43,8 @@
> >  #include <media/v4l2-fwnode.h>
> >  #include <media/v4l2-subdev.h>
> >=20
> > +static DEFINE_MUTEX(ov5645_lock);
> > +
> >  #define OV5645_VOLTAGE_ANALOG               2800000
> >  #define OV5645_VOLTAGE_DIGITAL_CORE         1500000
> >  #define OV5645_VOLTAGE_DIGITAL_IO           1800000
> > @@ -590,6 +593,31 @@ static void ov5645_regulators_disable(struct ov5645
> > *ov5645)
> >  		dev_err(ov5645->dev, "io regulator disable failed\n");
> >  }
> >=20
> > +static int ov5645_write_reg_to(struct ov5645 *ov5645, u16 reg, u8 val,
> > +			       u16 i2c_addr)
> > +{
> > +	u8 regbuf[3] =3D {
> > +		reg >> 8,
> > +		reg & 0xff,
> > +		val
> > +	};
> > +	struct i2c_msg msgs =3D {
> > +		.addr =3D i2c_addr,
> > +		.flags =3D 0,
> > +		.len =3D 3,
> > +		.buf =3D regbuf
> > +	};
> > +	int ret;
> > +
> > +	ret =3D i2c_transfer(ov5645->i2c_client->adapter, &msgs, 1);
> > +	if (ret < 0)
> > +		dev_err(ov5645->dev,
> > +			"%s: write reg error %d on addr 0x%x: reg=3D0x%x, val=3D0x%x\n",
> > +			__func__, ret, i2c_addr, reg, val);
> > +
> > +	return ret;
> > +}
> > +
> >  static int ov5645_write_reg(struct ov5645 *ov5645, u16 reg, u8 val)
> >  {
> >  	u8 regbuf[3];
> > @@ -729,10 +757,24 @@ static int ov5645_s_power(struct v4l2_subdev *sd,
> > int on)
> >  	 */
> >  	if (ov5645->power_count =3D=3D !on) {
> >  		if (on) {
> > +			mutex_lock(&ov5645_lock);
> > +
> >  			ret =3D ov5645_set_power_on(ov5645);
> >  			if (ret < 0)
> >  				goto exit;
> >=20
> > +			ret =3D ov5645_write_reg_to(ov5645, 0x3100,
> > +						ov5645->i2c_client->addr, 0x78);
> > +			if (ret < 0) {
> > +				dev_err(ov5645->dev,
> > +					"could not change i2c address\n");
> > +				ov5645_set_power_off(ov5645);
> > +				mutex_unlock(&ov5645_lock);
> > +				goto exit;
> > +			}
> > +
> > +			mutex_unlock(&ov5645_lock);
> > +
> >  			ret =3D ov5645_set_register_array(ov5645,
> >  					ov5645_global_init_setting,
> >  					ARRAY_SIZE(ov5645_global_init_setting));

=2D-=20
Regards,

Laurent Pinchart
