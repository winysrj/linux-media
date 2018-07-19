Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37212 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbeGSNQK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jul 2018 09:16:10 -0400
Date: Thu, 19 Jul 2018 14:33:08 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Peter Rosin <peda@axentia.se>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH -next v4 1/3] regmap: add SCCB support
Message-ID: <20180719123308.iiytv2o52dw5lsbk@earth.universe>
References: <1531756070-8560-1-git-send-email-akinobu.mita@gmail.com>
 <1531756070-8560-2-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ezlpf72tvg54m3jz"
Content-Disposition: inline
In-Reply-To: <1531756070-8560-2-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ezlpf72tvg54m3jz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 17, 2018 at 12:47:48AM +0900, Akinobu Mita wrote:
> This adds Serial Camera Control Bus (SCCB) support for regmap API that
> is intended to be used by some of Omnivision sensor drivers.
>=20
> The ov772x and ov9650 drivers are going to use this SCCB regmap API.
>=20
> The ov772x driver was previously only worked with the i2c controller
> drivers that support I2C_FUNC_PROTOCOL_MANGLING, because the ov772x
> device doesn't support repeated starts.  After commit 0b964d183cbf
> ("media: ov772x: allow i2c controllers without
> I2C_FUNC_PROTOCOL_MANGLING"), reading ov772x register is replaced with
> issuing two separated i2c messages in order to avoid repeated start.
> Using this SCCB regmap hides the implementation detail.
>=20
> The ov9650 driver also issues two separated i2c messages to read the
> registers as the device doesn't support repeated start.  So it can
> make use of this SCCB regmap.
>=20
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Peter Rosin <peda@axentia.se>
> Cc: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

>  drivers/base/regmap/Kconfig       |   4 ++
>  drivers/base/regmap/Makefile      |   1 +
>  drivers/base/regmap/regmap-sccb.c | 128 ++++++++++++++++++++++++++++++++=
++++++
>  include/linux/regmap.h            |  35 +++++++++++
>  4 files changed, 168 insertions(+)
>  create mode 100644 drivers/base/regmap/regmap-sccb.c
>=20
> diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
> index aff34c0..6ad5ef4 100644
> --- a/drivers/base/regmap/Kconfig
> +++ b/drivers/base/regmap/Kconfig
> @@ -45,3 +45,7 @@ config REGMAP_IRQ
>  config REGMAP_SOUNDWIRE
>  	tristate
>  	depends on SOUNDWIRE_BUS
> +
> +config REGMAP_SCCB
> +	tristate
> +	depends on I2C
> diff --git a/drivers/base/regmap/Makefile b/drivers/base/regmap/Makefile
> index 5ed0023..f5b4e88 100644
> --- a/drivers/base/regmap/Makefile
> +++ b/drivers/base/regmap/Makefile
> @@ -15,3 +15,4 @@ obj-$(CONFIG_REGMAP_MMIO) +=3D regmap-mmio.o
>  obj-$(CONFIG_REGMAP_IRQ) +=3D regmap-irq.o
>  obj-$(CONFIG_REGMAP_W1) +=3D regmap-w1.o
>  obj-$(CONFIG_REGMAP_SOUNDWIRE) +=3D regmap-sdw.o
> +obj-$(CONFIG_REGMAP_SCCB) +=3D regmap-sccb.o
> diff --git a/drivers/base/regmap/regmap-sccb.c b/drivers/base/regmap/regm=
ap-sccb.c
> new file mode 100644
> index 0000000..b6eb876
> --- /dev/null
> +++ b/drivers/base/regmap/regmap-sccb.c
> @@ -0,0 +1,128 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Register map access API - SCCB support
> +
> +#include <linux/regmap.h>
> +#include <linux/i2c.h>
> +#include <linux/module.h>
> +
> +#include "internal.h"
> +
> +/**
> + * sccb_is_available - Check if the adapter supports SCCB protocol
> + * @adap: I2C adapter
> + *
> + * Return true if the I2C adapter is capable of using SCCB helper functi=
ons,
> + * false otherwise.
> + */
> +static bool sccb_is_available(struct i2c_adapter *adap)
> +{
> +	u32 needed_funcs =3D I2C_FUNC_SMBUS_BYTE | I2C_FUNC_SMBUS_WRITE_BYTE_DA=
TA;
> +
> +	/*
> +	 * If we ever want support for hardware doing SCCB natively, we will
> +	 * introduce a sccb_xfer() callback to struct i2c_algorithm and check
> +	 * for it here.
> +	 */
> +
> +	return (i2c_get_functionality(adap) & needed_funcs) =3D=3D needed_funcs;
> +}
> +
> +/**
> + * regmap_sccb_read - Read data from SCCB slave device
> + * @context: Device that will be interacted wit
> + * @reg: Register to be read from
> + * @val: Pointer to store read value
> + *
> + * This executes the 2-phase write transmission cycle that is followed b=
y a
> + * 2-phase read transmission cycle, returning negative errno else zero on
> + * success.
> + */
> +static int regmap_sccb_read(void *context, unsigned int reg, unsigned in=
t *val)
> +{
> +	struct device *dev =3D context;
> +	struct i2c_client *i2c =3D to_i2c_client(dev);
> +	int ret;
> +	union i2c_smbus_data data;
> +
> +	i2c_lock_bus(i2c->adapter, I2C_LOCK_SEGMENT);
> +
> +	ret =3D __i2c_smbus_xfer(i2c->adapter, i2c->addr, i2c->flags,
> +			       I2C_SMBUS_WRITE, reg, I2C_SMBUS_BYTE, NULL);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret =3D __i2c_smbus_xfer(i2c->adapter, i2c->addr, i2c->flags,
> +			       I2C_SMBUS_READ, 0, I2C_SMBUS_BYTE, &data);
> +	if (ret < 0)
> +		goto out;
> +
> +	*val =3D data.byte;
> +out:
> +	i2c_unlock_bus(i2c->adapter, I2C_LOCK_SEGMENT);
> +
> +	return ret;
> +}
> +
> +/**
> + * regmap_sccb_write - Write data to SCCB slave device
> + * @context: Device that will be interacted wit
> + * @reg: Register to write to
> + * @val: Value to be written
> + *
> + * This executes the SCCB 3-phase write transmission cycle, returning ne=
gative
> + * errno else zero on success.
> + */
> +static int regmap_sccb_write(void *context, unsigned int reg, unsigned i=
nt val)
> +{
> +	struct device *dev =3D context;
> +	struct i2c_client *i2c =3D to_i2c_client(dev);
> +
> +	return i2c_smbus_write_byte_data(i2c, reg, val);
> +}
> +
> +static struct regmap_bus regmap_sccb_bus =3D {
> +	.reg_write =3D regmap_sccb_write,
> +	.reg_read =3D regmap_sccb_read,
> +};
> +
> +static const struct regmap_bus *regmap_get_sccb_bus(struct i2c_client *i=
2c,
> +					const struct regmap_config *config)
> +{
> +	if (config->val_bits =3D=3D 8 && config->reg_bits =3D=3D 8 &&
> +			sccb_is_available(i2c->adapter))
> +		return &regmap_sccb_bus;
> +
> +	return ERR_PTR(-ENOTSUPP);
> +}
> +
> +struct regmap *__regmap_init_sccb(struct i2c_client *i2c,
> +				  const struct regmap_config *config,
> +				  struct lock_class_key *lock_key,
> +				  const char *lock_name)
> +{
> +	const struct regmap_bus *bus =3D regmap_get_sccb_bus(i2c, config);
> +
> +	if (IS_ERR(bus))
> +		return ERR_CAST(bus);
> +
> +	return __regmap_init(&i2c->dev, bus, &i2c->dev, config,
> +			     lock_key, lock_name);
> +}
> +EXPORT_SYMBOL_GPL(__regmap_init_sccb);
> +
> +struct regmap *__devm_regmap_init_sccb(struct i2c_client *i2c,
> +				       const struct regmap_config *config,
> +				       struct lock_class_key *lock_key,
> +				       const char *lock_name)
> +{
> +	const struct regmap_bus *bus =3D regmap_get_sccb_bus(i2c, config);
> +
> +	if (IS_ERR(bus))
> +		return ERR_CAST(bus);
> +
> +	return __devm_regmap_init(&i2c->dev, bus, &i2c->dev, config,
> +				  lock_key, lock_name);
> +}
> +EXPORT_SYMBOL_GPL(__devm_regmap_init_sccb);
> +
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/regmap.h b/include/linux/regmap.h
> index 4f38068..52bf358 100644
> --- a/include/linux/regmap.h
> +++ b/include/linux/regmap.h
> @@ -514,6 +514,10 @@ struct regmap *__regmap_init_i2c(struct i2c_client *=
i2c,
>  				 const struct regmap_config *config,
>  				 struct lock_class_key *lock_key,
>  				 const char *lock_name);
> +struct regmap *__regmap_init_sccb(struct i2c_client *i2c,
> +				  const struct regmap_config *config,
> +				  struct lock_class_key *lock_key,
> +				  const char *lock_name);
>  struct regmap *__regmap_init_slimbus(struct slim_device *slimbus,
>  				 const struct regmap_config *config,
>  				 struct lock_class_key *lock_key,
> @@ -558,6 +562,10 @@ struct regmap *__devm_regmap_init_i2c(struct i2c_cli=
ent *i2c,
>  				      const struct regmap_config *config,
>  				      struct lock_class_key *lock_key,
>  				      const char *lock_name);
> +struct regmap *__devm_regmap_init_sccb(struct i2c_client *i2c,
> +				       const struct regmap_config *config,
> +				       struct lock_class_key *lock_key,
> +				       const char *lock_name);
>  struct regmap *__devm_regmap_init_spi(struct spi_device *dev,
>  				      const struct regmap_config *config,
>  				      struct lock_class_key *lock_key,
> @@ -646,6 +654,19 @@ int regmap_attach_dev(struct device *dev, struct reg=
map *map,
>  				i2c, config)
> =20
>  /**
> + * regmap_init_sccb() - Initialise register map
> + *
> + * @i2c: Device that will be interacted with
> + * @config: Configuration for register map
> + *
> + * The return value will be an ERR_PTR() on error or a valid pointer to
> + * a struct regmap.
> + */
> +#define regmap_init_sccb(i2c, config)					\
> +	__regmap_lockdep_wrapper(__regmap_init_sccb, #config,		\
> +				i2c, config)
> +
> +/**
>   * regmap_init_slimbus() - Initialise register map
>   *
>   * @slimbus: Device that will be interacted with
> @@ -798,6 +819,20 @@ bool regmap_ac97_default_volatile(struct device *dev=
, unsigned int reg);
>  				i2c, config)
> =20
>  /**
> + * devm_regmap_init_sccb() - Initialise managed register map
> + *
> + * @i2c: Device that will be interacted with
> + * @config: Configuration for register map
> + *
> + * The return value will be an ERR_PTR() on error or a valid pointer
> + * to a struct regmap.  The regmap will be automatically freed by the
> + * device management code.
> + */
> +#define devm_regmap_init_sccb(i2c, config)				\
> +	__regmap_lockdep_wrapper(__devm_regmap_init_sccb, #config,	\
> +				i2c, config)
> +
> +/**
>   * devm_regmap_init_spi() - Initialise register map
>   *
>   * @dev: Device that will be interacted with
> --=20
> 2.7.4
>=20

--ezlpf72tvg54m3jz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAltQhQIACgkQ2O7X88g7
+poInA//XOQNuin98E5XmdaYi8c6xYzQQ30Oz48zRy7RFGXht8JGvlh3Crpf1MDq
CE1QVUgMeqmU46Q04FLspZ9Ook+oRPuYFOgf7b1bK+vqsUnFHS+UYFLU1IXFTI+C
DV+8OwqA6MXJvA4ExPafu7UTLo65oxWB+wM4BG2DTY5m1Dk1oUlOzbF8P8H8MPai
EP+7GYvHfbBrAY9T48BgLmPerydbhr7gEaPvxea2We1Ymu6ooHotCHpxFXQuXTmR
hr1rWba7xpmuGJj/v2sCvvnzFIX6UNBAE8+FIKTS6xQvkLhsjWaDex0Vmjk9ivFx
qvW1Kf4y1cMZVPMBRjaK9SGoI4w+ZcsnM7MtkLzObb9rjBdQbMIQ0VapeY4T/vm4
3w2vjAQBDpRS033J4auA9lQbA8nN09tPfCnqVhI6/HrsezxWsNqL01r5eLUchwqW
XNRadZQSNt31NAVKGoyBDfoAmF4StqE1vWON+INHbCiNmyPgOxwG32qCRls+2fQJ
3pSoO9yA+8M3LOdskuYbUnL//TCOozd3Qxrs3mjRZ5ibw4zNbnEttnXpzVf4tiWY
Q/GZfWRRLBL+jlmCbuoBJkSrOyZ1Zr1lcyYzeTioXWrOf9O2jO0QPVJFC9knTrst
UYD9Xn0qRlrGGU8uW8XZAR09MCX08k4iZeTjIiX9ykZV79R6QZM=
=ZcyN
-----END PGP SIGNATURE-----

--ezlpf72tvg54m3jz--
