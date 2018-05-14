Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:38279 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932172AbeENOat (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 10:30:49 -0400
Date: Mon, 14 May 2018 16:30:44 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, hans.verkuil@cisco.com,
        mchehab@kernel.org, robh+dt@kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] media: i2c: mt9t112: Add device tree support
Message-ID: <20180514143044.GK5956@w540>
References: <1524654014-17852-1-git-send-email-jacopo+renesas@jmondi.org>
 <1524654014-17852-3-git-send-email-jacopo+renesas@jmondi.org>
 <20180507093219.hrhaliadccaytenj@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="TdMwOTenGjBWB1uY"
Content-Disposition: inline
In-Reply-To: <20180507093219.hrhaliadccaytenj@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--TdMwOTenGjBWB1uY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Sakari,

On Mon, May 07, 2018 at 12:32:19PM +0300, Sakari Ailus wrote:
> Hi Jacopo,
>
> On Wed, Apr 25, 2018 at 01:00:14PM +0200, Jacopo Mondi wrote:

[snip]

> >  static int mt9t112_probe(struct i2c_client *client,
> >  			 const struct i2c_device_id *did)
> >  {
> >  	struct mt9t112_priv *priv;
> >  	int ret;
> >
> > -	if (!client->dev.platform_data) {
> > +	if (!client->dev.of_node && !client->dev.platform_data) {
> >  		dev_err(&client->dev, "mt9t112: missing platform data!\n");
> >  		return -EINVAL;
> >  	}
> > @@ -1081,23 +1118,39 @@ static int mt9t112_probe(struct i2c_client *client,
> >  	if (!priv)
> >  		return -ENOMEM;
> >
> > -	priv->info = client->dev.platform_data;
> >  	priv->init_done = false;
> > -
> > -	v4l2_i2c_subdev_init(&priv->subdev, client, &mt9t112_subdev_ops);
> > -
> > -	priv->clk = devm_clk_get(&client->dev, "extclk");
> > -	if (PTR_ERR(priv->clk) == -ENOENT) {
> > +	priv->dev = &client->dev;
> > +
> > +	if (client->dev.platform_data) {
> > +		priv->info = client->dev.platform_data;
> > +
> > +		priv->clk = devm_clk_get(&client->dev, "extclk");
>
> extclk needs to be documented in DT binding documentation.
>
> > +		if (PTR_ERR(priv->clk) == -ENOENT) {
> > +			priv->clk = NULL;
> > +		} else if (IS_ERR(priv->clk)) {
> > +			dev_err(&client->dev,
> > +				"Unable to get clock \"extclk\"\n");
> > +			return PTR_ERR(priv->clk);
> > +		}
> > +	} else {
> > +		/*
> > +		 * External clock frequencies != 24MHz are only supported
> > +		 * for non-OF systems.
> > +		 */
>
> Shouldn't you actually set the frequency? Or perhaps even better to check
> it, and use assigned-clocks and assigned-clock-rates properties?
>

I might be confused, but my intention was to use an external clock
reference, with a configurable frequency only in the platform data use
case. As you can see in this 'else' branch, in OF case, the priv->clk
field is null, and all the PLL and clock computations are performed
assuming a 24MHz input clock.

In my opinion, as the driver when running on OF systems does not
get any reference to 'extclk' clock, it should not be documented in
bindings. Do you agree?

Thanks
   j

> >  		priv->clk = NULL;
> > -	} else if (IS_ERR(priv->clk)) {
> > -		dev_err(&client->dev, "Unable to get clock \"extclk\"\n");
> > -		return PTR_ERR(priv->clk);
> > +		priv->info = &mt9t112_default_pdata_24MHz;
> > +
> > +		ret = mt9t112_parse_dt(priv);
> > +		if (ret)
> > +			return ret;
> >  	}
> >
> > -	priv->standby_gpio = devm_gpiod_get_optional(&client->dev, "standby",
> > +	v4l2_i2c_subdev_init(&priv->subdev, client, &mt9t112_subdev_ops);
> > +
> > +	priv->standby_gpio = devm_gpiod_get_optional(&client->dev, "powerdown",
> >  						     GPIOD_OUT_HIGH);
> >  	if (IS_ERR(priv->standby_gpio)) {
> > -		dev_err(&client->dev, "Unable to get gpio \"standby\"\n");
> > +		dev_err(&client->dev, "Unable to get gpio \"powerdown\"\n");
> >  		return PTR_ERR(priv->standby_gpio);
> >  	}
> >
> > @@ -1124,9 +1177,19 @@ static const struct i2c_device_id mt9t112_id[] = {
> >  };
> >  MODULE_DEVICE_TABLE(i2c, mt9t112_id);
> >
> > +#if IS_ENABLED(CONFIG_OF)
> > +static const struct of_device_id mt9t112_of_match[] = {
> > +	{ .compatible = "micron,mt9t111", },
> > +	{ .compatible = "micron,mt9t112", },
> > +	{ /* sentinel */ },
> > +};
> > +MODULE_DEVICE_TABLE(of, mt9t112_of_match);
> > +#endif
> > +
> >  static struct i2c_driver mt9t112_i2c_driver = {
> >  	.driver = {
> >  		.name = "mt9t112",
> > +		.of_match_table = of_match_ptr(mt9t112_of_match),
>
> No need to use of_match_ptr().
>
> >  	},
> >  	.probe    = mt9t112_probe,
> >  	.remove   = mt9t112_remove,
>
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi

--TdMwOTenGjBWB1uY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa+Z2UAAoJEHI0Bo8WoVY8/Z4P/35XLRg9kU6iyZjc0Jt/Dwyg
ynWBgR4jJRbb8ZG8V+XugpgDxRwbntMwnqRdGEwBY53lp+27+l6HqGJDnHJtEiSV
4j1r10H5KOiqE3OmHCfH5dnuW6wFBbzjPmkRluOuiC6T4XgiDN54Mow70dvecpiw
AP72j+FZraF1940RZn1i480VzztsStWx5I4qTgORXHKqqvt0ynk5+Dt8Q7Ty0vn6
gys1uRKQ4/6c+lzYIrl4hkkfIZs7bvOZ1xUGwe+O7GvqaZqNxb8UlpWJm4930J0t
TQQHVhZ0YpAXm4oBTc/x0EfSZNQuy+rSnpn+agIdPL6xUcEDjQ2AjBeVGf/Q3P9U
vwLwYsrG0lKw9SaCKCoC6GGEiudheH2LpnxrZkDLiYjeSNy4mAYGwxVjdGVl6++J
URBliqSxJ4MImbj9dPtQvYI62/KTVSUrtcYHagahWmuioqjn9WkkTmhQ5W7PJEai
yUb0v+Mc1K16v0/aepu2It7Q2M/YCFDHZN30+ZIp5Tu3Gxgt/Ax15b2+6xI9BRnj
hPELTaOqZaLquiM+dlDTvTvQOeowsj0W8ABd6YTxkO511K8bKR2vp/bB2k4shfNt
U2FIZRTjNTvPH4npAlflHVrPKsV+jsQCINHAx6doIopcxn19CkyDAw7uR0t22sXX
qvVEnJ5+FsVJa0So1Xgl
=dxbg
-----END PGP SIGNATURE-----

--TdMwOTenGjBWB1uY--
