Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53540 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751296AbeA2KZr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 05:25:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        David Airlie <airlied@linux.ie>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        John Stultz <john.stultz@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/2] drm: adv7511: Add support for i2c_new_secondary_device
Date: Mon, 29 Jan 2018 12:26:00 +0200
Message-ID: <1650729.pzuqXiNcLL@avalon>
In-Reply-To: <1516625389-6362-3-git-send-email-kieran.bingham@ideasonboard.com>
References: <1516625389-6362-1-git-send-email-kieran.bingham@ideasonboard.com> <1516625389-6362-3-git-send-email-kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Monday, 22 January 2018 14:50:00 EET Kieran Bingham wrote:
> The ADV7511 has four 256-byte maps that can be accessed via the main I=B2C
> ports. Each map has it own I=B2C address and acts as a standard slave
> device on the I=B2C bus.
>=20
> Allow a device tree node to override the default addresses so that
> address conflicts with other devices on the same bus may be resolved at
> the board description level.
>=20
> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
> ---
>  .../bindings/display/bridge/adi,adv7511.txt        | 10 +++++-

I don't mind personally, but device tree maintainers usually ask for DT=20
bindings changes to be split to a separate patch.

>  drivers/gpu/drm/bridge/adv7511/adv7511.h           |  4 +++
>  drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       | 36 ++++++++++++----=
=2D--
>  3 files changed, 37 insertions(+), 13 deletions(-)
>=20
> diff --git
> a/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
> b/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
> index 0047b1394c70..f6bb9f6d3f48 100644
> --- a/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
> +++ b/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
> @@ -70,6 +70,9 @@ Optional properties:
>    rather than generate its own timings for HDMI output.
>  - clocks: from common clock binding: reference to the CEC clock.
>  - clock-names: from common clock binding: must be "cec".
> +- reg-names : Names of maps with programmable addresses.
> +	It can contain any map needing a non-default address.
> +	Possible maps names are : "main", "edid", "cec", "packet"

Is the reg-names property (and the additional maps) mandatory or optional ?=
 If=20
mandatory you should also update the existing DT sources that use those=20
bindings. If optional you should define which I2C addresses will be used wh=
en=20
the maps are not specified (and in that case I think we should go for the=20
addresses listed as default in the datasheet, which correspond to the curre=
nt=20
driver implementation when the main address is 0x3d/0x7a).

You should also update the definition of the reg property that currently ju=
st=20
states

=2D reg: I2C slave address

And finally you might want to define the term "map" in this context. Here's=
 a=20
proposal (if we make all maps mandatory).

The ADV7511 internal registers are split into four pages exposed through=20
different I2C addresses, creating four register maps. The I2C addresses of =
all=20
four maps shall be specified by the reg and reg-names property.

=2D reg: I2C slave addresses, one per reg-names entry
=2D reg-names: map names, shall be "main", "edid", "cec", "packet"

>  Required nodes:
> =20
> @@ -88,7 +91,12 @@ Example
> =20
>  	adv7511w: hdmi@39 {
>  		compatible =3D "adi,adv7511w";
> -		reg =3D <39>;
> +		/*
> +		 * The EDID page will be accessible on address 0x66 on the i2c
> +		 * bus. All other maps continue to use their default addresses.
> +		 */
> +		reg =3D <0x39 0x66>;
> +		reg-names =3D "main", "edid";
>  		interrupt-parent =3D <&gpio3>;
>  		interrupts =3D <29 IRQ_TYPE_EDGE_FALLING>;
>  		clocks =3D <&cec_clock>;
> diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511.h
> b/drivers/gpu/drm/bridge/adv7511/adv7511.h
> index d034b2cb5eee..7d81ce3808e0 100644
> --- a/drivers/gpu/drm/bridge/adv7511/adv7511.h
> +++ b/drivers/gpu/drm/bridge/adv7511/adv7511.h
> @@ -53,8 +53,10 @@
>  #define ADV7511_REG_POWER			0x41
>  #define ADV7511_REG_STATUS			0x42
>  #define ADV7511_REG_EDID_I2C_ADDR		0x43
> +#define ADV7511_REG_EDID_I2C_ADDR_DEFAULT	0x3f
>  #define ADV7511_REG_PACKET_ENABLE1		0x44
>  #define ADV7511_REG_PACKET_I2C_ADDR		0x45
> +#define ADV7511_REG_PACKET_I2C_ADDR_DEFAULT	0x38
>  #define ADV7511_REG_DSD_ENABLE			0x46
>  #define ADV7511_REG_VIDEO_INPUT_CFG2		0x48
>  #define ADV7511_REG_INFOFRAME_UPDATE		0x4a
> @@ -89,6 +91,7 @@
>  #define ADV7511_REG_TMDS_CLOCK_INV		0xde
>  #define ADV7511_REG_ARC_CTRL			0xdf
>  #define ADV7511_REG_CEC_I2C_ADDR		0xe1
> +#define ADV7511_REG_CEC_I2C_ADDR_DEFAULT	0x3c
>  #define ADV7511_REG_CEC_CTRL			0xe2
>  #define ADV7511_REG_CHIP_ID_HIGH		0xf5
>  #define ADV7511_REG_CHIP_ID_LOW			0xf6
> @@ -322,6 +325,7 @@ struct adv7511 {
>  	struct i2c_client *i2c_main;
>  	struct i2c_client *i2c_edid;
>  	struct i2c_client *i2c_cec;
> +	struct i2c_client *i2c_packet;
> =20
>  	struct regmap *regmap;
>  	struct regmap *regmap_cec;
> diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
> b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
> index efa29db5fc2b..7ec33837752b 100644
> --- a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
> +++ b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
> @@ -969,8 +969,8 @@ static int adv7511_init_cec_regmap(struct adv7511 *ad=
v)
> {
>  	int ret;
> =20
> -	adv->i2c_cec =3D i2c_new_dummy(adv->i2c_main->adapter,
> -				     adv->i2c_main->addr - 1);
> +	adv->i2c_cec =3D i2c_new_secondary_device(adv->i2c_main, "cec",
> +					ADV7511_REG_CEC_I2C_ADDR_DEFAULT);
>  	if (!adv->i2c_cec)
>  		return -ENOMEM;
>  	i2c_set_clientdata(adv->i2c_cec, adv);
> @@ -1082,8 +1082,6 @@ static int adv7511_probe(struct i2c_client *i2c, co=
nst
> struct i2c_device_id *id)
>  	struct adv7511_link_config link_config;
>  	struct adv7511 *adv7511;
>  	struct device *dev =3D &i2c->dev;
> -	unsigned int main_i2c_addr =3D i2c->addr << 1;
> -	unsigned int edid_i2c_addr =3D main_i2c_addr + 4;
>  	unsigned int val;
>  	int ret;
> =20
> @@ -1153,24 +1151,35 @@ static int adv7511_probe(struct i2c_client *i2c,
> const struct i2c_device_id *id)
>  	if (ret)
>  		goto uninit_regulators;
> =20
> -	regmap_write(adv7511->regmap, ADV7511_REG_EDID_I2C_ADDR, edid_i2c_addr);
> -	regmap_write(adv7511->regmap, ADV7511_REG_PACKET_I2C_ADDR,
> -		     main_i2c_addr - 0xa);
> -	regmap_write(adv7511->regmap, ADV7511_REG_CEC_I2C_ADDR,
> -		     main_i2c_addr - 2);
> -
>  	adv7511_packet_disable(adv7511, 0xffff);
> =20
> -	adv7511->i2c_edid =3D i2c_new_dummy(i2c->adapter, edid_i2c_addr >> 1);
> +	adv7511->i2c_edid =3D i2c_new_secondary_device(i2c, "edid",
> +					ADV7511_REG_EDID_I2C_ADDR_DEFAULT);
>  	if (!adv7511->i2c_edid) {
>  		ret =3D -ENOMEM;

I wonder if this is the right error code. Maybe -EINVAL ? In most cases err=
ors=20
will be caused by invalid addresses (out of memory and device_register()=20
failures can happen too but should be less common).

It would be nice if i2c_new_secondary_device() returned an ERR_PTR, but tha=
t's=20
out of scope.

>  		goto uninit_regulators;
>  	}
> =20
> +	regmap_write(adv7511->regmap, ADV7511_REG_EDID_I2C_ADDR,
> +		     adv7511->i2c_edid->addr << 1);
> +
>  	ret =3D adv7511_init_cec_regmap(adv7511);
>  	if (ret)
>  		goto err_i2c_unregister_edid;
> =20
> +	regmap_write(adv7511->regmap, ADV7511_REG_CEC_I2C_ADDR,
> +		     adv7511->i2c_cec->addr << 1);
> +
> +	adv7511->i2c_packet =3D i2c_new_secondary_device(i2c, "packet",
> +					ADV7511_REG_PACKET_I2C_ADDR_DEFAULT);
> +	if (!adv7511->i2c_packet) {
> +		ret =3D -ENOMEM;
> +		goto err_unregister_cec;
> +	}
> +
> +	regmap_write(adv7511->regmap, ADV7511_REG_PACKET_I2C_ADDR,
> +		     adv7511->i2c_packet->addr << 1);
> +
>  	INIT_WORK(&adv7511->hpd_work, adv7511_hpd_work);
> =20
>  	if (i2c->irq) {
> @@ -1181,7 +1190,7 @@ static int adv7511_probe(struct i2c_client *i2c, co=
nst
> struct i2c_device_id *id)
>  						IRQF_ONESHOT, dev_name(dev),
>  						adv7511);
>  		if (ret)
> -			goto err_unregister_cec;
> +			goto err_unregister_packet;
>  	}
> =20
>  	adv7511_power_off(adv7511);
> @@ -1203,6 +1212,8 @@ static int adv7511_probe(struct i2c_client *i2c, co=
nst
> struct i2c_device_id *id)
>  	adv7511_audio_init(dev, adv7511);
>  	return 0;
> =20
> +err_unregister_packet:
> +	i2c_unregister_device(adv7511->i2c_packet);
>  err_unregister_cec:
>  	i2c_unregister_device(adv7511->i2c_cec);
>  	if (adv7511->cec_clk)
> @@ -1234,6 +1245,7 @@ static int adv7511_remove(struct i2c_client *i2c)
>  	cec_unregister_adapter(adv7511->cec_adap);
> =20
>  	i2c_unregister_device(adv7511->i2c_edid);
> +	i2c_unregister_device(adv7511->i2c_packet);
> =20
>  	return 0;
>  }

=2D-=20
Regards,

Laurent Pinchart
