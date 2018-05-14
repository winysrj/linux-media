Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40732 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752038AbeENVuH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 17:50:07 -0400
Date: Tue, 15 May 2018 00:50:04 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, hans.verkuil@cisco.com,
        mchehab@kernel.org, robh+dt@kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] media: i2c: mt9t112: Add device tree support
Message-ID: <20180514215004.5oy6jr7f32jpfhx2@valkosipuli.retiisi.org.uk>
References: <1524654014-17852-1-git-send-email-jacopo+renesas@jmondi.org>
 <1524654014-17852-3-git-send-email-jacopo+renesas@jmondi.org>
 <20180507093219.hrhaliadccaytenj@valkosipuli.retiisi.org.uk>
 <20180514143044.GK5956@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180514143044.GK5956@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Mon, May 14, 2018 at 04:30:44PM +0200, jacopo mondi wrote:
> Hi Sakari,
> 
> On Mon, May 07, 2018 at 12:32:19PM +0300, Sakari Ailus wrote:
> > Hi Jacopo,
> >
> > On Wed, Apr 25, 2018 at 01:00:14PM +0200, Jacopo Mondi wrote:
> 
> [snip]
> 
> > >  static int mt9t112_probe(struct i2c_client *client,
> > >  			 const struct i2c_device_id *did)
> > >  {
> > >  	struct mt9t112_priv *priv;
> > >  	int ret;
> > >
> > > -	if (!client->dev.platform_data) {
> > > +	if (!client->dev.of_node && !client->dev.platform_data) {
> > >  		dev_err(&client->dev, "mt9t112: missing platform data!\n");
> > >  		return -EINVAL;
> > >  	}
> > > @@ -1081,23 +1118,39 @@ static int mt9t112_probe(struct i2c_client *client,
> > >  	if (!priv)
> > >  		return -ENOMEM;
> > >
> > > -	priv->info = client->dev.platform_data;
> > >  	priv->init_done = false;
> > > -
> > > -	v4l2_i2c_subdev_init(&priv->subdev, client, &mt9t112_subdev_ops);
> > > -
> > > -	priv->clk = devm_clk_get(&client->dev, "extclk");
> > > -	if (PTR_ERR(priv->clk) == -ENOENT) {
> > > +	priv->dev = &client->dev;
> > > +
> > > +	if (client->dev.platform_data) {
> > > +		priv->info = client->dev.platform_data;
> > > +
> > > +		priv->clk = devm_clk_get(&client->dev, "extclk");
> >
> > extclk needs to be documented in DT binding documentation.
> >
> > > +		if (PTR_ERR(priv->clk) == -ENOENT) {
> > > +			priv->clk = NULL;
> > > +		} else if (IS_ERR(priv->clk)) {
> > > +			dev_err(&client->dev,
> > > +				"Unable to get clock \"extclk\"\n");
> > > +			return PTR_ERR(priv->clk);
> > > +		}
> > > +	} else {
> > > +		/*
> > > +		 * External clock frequencies != 24MHz are only supported
> > > +		 * for non-OF systems.
> > > +		 */
> >
> > Shouldn't you actually set the frequency? Or perhaps even better to check
> > it, and use assigned-clocks and assigned-clock-rates properties?
> >
> 
> I might be confused, but my intention was to use an external clock
> reference, with a configurable frequency only in the platform data use
> case. As you can see in this 'else' branch, in OF case, the priv->clk
> field is null, and all the PLL and clock computations are performed
> assuming a 24MHz input clock.
> 
> In my opinion, as the driver when running on OF systems does not
> get any reference to 'extclk' clock, it should not be documented in
> bindings. Do you agree?

Uh, isn't the clock generally controlled by the driver on OF-based systems?
You could assign the frequency in DT though, and not in the driver, but
that should be documented in binding documentation.

The register configuration the driver does not appear to be dependent on
the clock frequency, which suggests that it is only applicable to a
particular frequency --- 24 MHz?

> 
> Thanks
>    j
> 
> > >  		priv->clk = NULL;
> > > -	} else if (IS_ERR(priv->clk)) {
> > > -		dev_err(&client->dev, "Unable to get clock \"extclk\"\n");
> > > -		return PTR_ERR(priv->clk);
> > > +		priv->info = &mt9t112_default_pdata_24MHz;
> > > +
> > > +		ret = mt9t112_parse_dt(priv);
> > > +		if (ret)
> > > +			return ret;
> > >  	}
> > >
> > > -	priv->standby_gpio = devm_gpiod_get_optional(&client->dev, "standby",
> > > +	v4l2_i2c_subdev_init(&priv->subdev, client, &mt9t112_subdev_ops);
> > > +
> > > +	priv->standby_gpio = devm_gpiod_get_optional(&client->dev, "powerdown",
> > >  						     GPIOD_OUT_HIGH);
> > >  	if (IS_ERR(priv->standby_gpio)) {
> > > -		dev_err(&client->dev, "Unable to get gpio \"standby\"\n");
> > > +		dev_err(&client->dev, "Unable to get gpio \"powerdown\"\n");
> > >  		return PTR_ERR(priv->standby_gpio);
> > >  	}
> > >
> > > @@ -1124,9 +1177,19 @@ static const struct i2c_device_id mt9t112_id[] = {
> > >  };
> > >  MODULE_DEVICE_TABLE(i2c, mt9t112_id);
> > >
> > > +#if IS_ENABLED(CONFIG_OF)
> > > +static const struct of_device_id mt9t112_of_match[] = {
> > > +	{ .compatible = "micron,mt9t111", },
> > > +	{ .compatible = "micron,mt9t112", },
> > > +	{ /* sentinel */ },
> > > +};
> > > +MODULE_DEVICE_TABLE(of, mt9t112_of_match);
> > > +#endif
> > > +
> > >  static struct i2c_driver mt9t112_i2c_driver = {
> > >  	.driver = {
> > >  		.name = "mt9t112",
> > > +		.of_match_table = of_match_ptr(mt9t112_of_match),
> >
> > No need to use of_match_ptr().
> >
> > >  	},
> > >  	.probe    = mt9t112_probe,
> > >  	.remove   = mt9t112_remove,
> >
> > --
> > Sakari Ailus
> > e-mail: sakari.ailus@iki.fi



-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
