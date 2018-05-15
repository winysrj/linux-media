Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:42263 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752226AbeEOHKn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 03:10:43 -0400
Date: Tue, 15 May 2018 09:10:36 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, hans.verkuil@cisco.com,
        mchehab@kernel.org, robh+dt@kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] media: i2c: mt9t112: Add device tree support
Message-ID: <20180515071036.GM5956@w540>
References: <1524654014-17852-1-git-send-email-jacopo+renesas@jmondi.org>
 <1524654014-17852-3-git-send-email-jacopo+renesas@jmondi.org>
 <20180507093219.hrhaliadccaytenj@valkosipuli.retiisi.org.uk>
 <20180514143044.GK5956@w540>
 <20180514215004.5oy6jr7f32jpfhx2@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="6o78gXsyQHm68LY/"
Content-Disposition: inline
In-Reply-To: <20180514215004.5oy6jr7f32jpfhx2@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--6o78gXsyQHm68LY/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sakari,

On Tue, May 15, 2018 at 12:50:04AM +0300, Sakari Ailus wrote:
> Hi Jacopo,
>
> On Mon, May 14, 2018 at 04:30:44PM +0200, jacopo mondi wrote:
> > Hi Sakari,
> >
> > On Mon, May 07, 2018 at 12:32:19PM +0300, Sakari Ailus wrote:
> > > Hi Jacopo,
> > >
> > > On Wed, Apr 25, 2018 at 01:00:14PM +0200, Jacopo Mondi wrote:
> >
> > [snip]
> >
> > > >  static int mt9t112_probe(struct i2c_client *client,
> > > >  			 const struct i2c_device_id *did)
> > > >  {
> > > >  	struct mt9t112_priv *priv;
> > > >  	int ret;
> > > >
> > > > -	if (!client->dev.platform_data) {
> > > > +	if (!client->dev.of_node && !client->dev.platform_data) {
> > > >  		dev_err(&client->dev, "mt9t112: missing platform data!\n");
> > > >  		return -EINVAL;
> > > >  	}
> > > > @@ -1081,23 +1118,39 @@ static int mt9t112_probe(struct i2c_client =
*client,
> > > >  	if (!priv)
> > > >  		return -ENOMEM;
> > > >
> > > > -	priv->info =3D client->dev.platform_data;
> > > >  	priv->init_done =3D false;
> > > > -
> > > > -	v4l2_i2c_subdev_init(&priv->subdev, client, &mt9t112_subdev_ops);
> > > > -
> > > > -	priv->clk =3D devm_clk_get(&client->dev, "extclk");
> > > > -	if (PTR_ERR(priv->clk) =3D=3D -ENOENT) {
> > > > +	priv->dev =3D &client->dev;
> > > > +
> > > > +	if (client->dev.platform_data) {
> > > > +		priv->info =3D client->dev.platform_data;
> > > > +
> > > > +		priv->clk =3D devm_clk_get(&client->dev, "extclk");
> > >
> > > extclk needs to be documented in DT binding documentation.
> > >
> > > > +		if (PTR_ERR(priv->clk) =3D=3D -ENOENT) {
> > > > +			priv->clk =3D NULL;
> > > > +		} else if (IS_ERR(priv->clk)) {
> > > > +			dev_err(&client->dev,
> > > > +				"Unable to get clock \"extclk\"\n");
> > > > +			return PTR_ERR(priv->clk);
> > > > +		}
> > > > +	} else {
> > > > +		/*
> > > > +		 * External clock frequencies !=3D 24MHz are only supported
> > > > +		 * for non-OF systems.
> > > > +		 */
> > >
> > > Shouldn't you actually set the frequency? Or perhaps even better to c=
heck
> > > it, and use assigned-clocks and assigned-clock-rates properties?
> > >
> >
> > I might be confused, but my intention was to use an external clock
> > reference, with a configurable frequency only in the platform data use
> > case. As you can see in this 'else' branch, in OF case, the priv->clk
> > field is null, and all the PLL and clock computations are performed
> > assuming a 24MHz input clock.
> >
> > In my opinion, as the driver when running on OF systems does not
> > get any reference to 'extclk' clock, it should not be documented in
> > bindings. Do you agree?
>
> Uh, isn't the clock generally controlled by the driver on OF-based system=
s?
> You could assign the frequency in DT though, and not in the driver, but
> that should be documented in binding documentation.
>
> The register configuration the driver does not appear to be dependent on
> the clock frequency, which suggests that it is only applicable to a
> particular frequency --- 24 MHz?

Correct.
That's what the comment above here states...

	/*
	 * External clock frequencies !=3D 24MHz are only supported
	 * for non-OF systems.
	 */

That's how it works: the driver expects to receive the PLL dividers
=66rom platform data. It's ugly, I agree, but that's how it was. I do
not have time atm to poke around with PLL configuration, and I'm not
even sure I have the right documentation, so I made a 'default PLL
configuration' for 24MHz clock, copied from the platform data supplied
to the driver by the only user in mainline. In general, I would like
to have the driver calculate the PLL dividers based on the input clock
frequency, that should be supplied from DT. As this is not possible,
at the moment I made the driver only provide a PLL configuration for
24MHz, and that's the only clock the driver accepts.

 +		priv->info =3D &mt9t112_default_pdata_24MHz;

Would you prefer I take a reference to an external clock, check it's
frequency and refuse it if !=3D 24MHz?

By the way, I'm trying to run this driver with a camera module
connected to an ARM platform and so far I have not been able to
capture any image. The Ecovec I have (thanks Hans) has a camera module but =
the
cable is bad, so I can't test it on the platform the driver has
originally been developed on, but I assume on SH Ecovec it works properly.
Any confirmation from someone who has that board would be appreciate
though.

Thanks
   j

>
> >
> > Thanks
> >    j
> >
> > > >  		priv->clk =3D NULL;
> > > > -	} else if (IS_ERR(priv->clk)) {
> > > > -		dev_err(&client->dev, "Unable to get clock \"extclk\"\n");
> > > > -		return PTR_ERR(priv->clk);
> > > > +		priv->info =3D &mt9t112_default_pdata_24MHz;
> > > > +
> > > > +		ret =3D mt9t112_parse_dt(priv);
> > > > +		if (ret)
> > > > +			return ret;
> > > >  	}
> > > >
> > > > -	priv->standby_gpio =3D devm_gpiod_get_optional(&client->dev, "sta=
ndby",
> > > > +	v4l2_i2c_subdev_init(&priv->subdev, client, &mt9t112_subdev_ops);
> > > > +
> > > > +	priv->standby_gpio =3D devm_gpiod_get_optional(&client->dev, "pow=
erdown",
> > > >  						     GPIOD_OUT_HIGH);
> > > >  	if (IS_ERR(priv->standby_gpio)) {
> > > > -		dev_err(&client->dev, "Unable to get gpio \"standby\"\n");
> > > > +		dev_err(&client->dev, "Unable to get gpio \"powerdown\"\n");
> > > >  		return PTR_ERR(priv->standby_gpio);
> > > >  	}
> > > >
> > > > @@ -1124,9 +1177,19 @@ static const struct i2c_device_id mt9t112_id=
[] =3D {
> > > >  };
> > > >  MODULE_DEVICE_TABLE(i2c, mt9t112_id);
> > > >
> > > > +#if IS_ENABLED(CONFIG_OF)
> > > > +static const struct of_device_id mt9t112_of_match[] =3D {
> > > > +	{ .compatible =3D "micron,mt9t111", },
> > > > +	{ .compatible =3D "micron,mt9t112", },
> > > > +	{ /* sentinel */ },
> > > > +};
> > > > +MODULE_DEVICE_TABLE(of, mt9t112_of_match);
> > > > +#endif
> > > > +
> > > >  static struct i2c_driver mt9t112_i2c_driver =3D {
> > > >  	.driver =3D {
> > > >  		.name =3D "mt9t112",
> > > > +		.of_match_table =3D of_match_ptr(mt9t112_of_match),
> > >
> > > No need to use of_match_ptr().
> > >
> > > >  	},
> > > >  	.probe    =3D mt9t112_probe,
> > > >  	.remove   =3D mt9t112_remove,
> > >
> > > --
> > > Sakari Ailus
> > > e-mail: sakari.ailus@iki.fi
>
>
>
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi

--6o78gXsyQHm68LY/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa+ofsAAoJEHI0Bo8WoVY8z/EQALtSWHRbxcc57H4R5uQFgI69
I4VfNpf8RxUcpAK2ht/78I7bqU7xMNCdSoCVuZnUJj/ZY+36CWD6TZhtfhvwdRcn
HHImP7snHB2rxiYokUkqhEX8h3IMnXX0dxBYWBnxpf4zeas3qP7QbqYQS9jfmjr5
zgMcWTAmWWLkQcvzWYFKDTgWsOj99TOeoOtDM25XgnULobHu/evCpXEveB//awnJ
N4vH45hpyP4ZTh928HROMvDQhjCPRrJIiQEkY9uRsj66mADUnWpht6YvsbnxKgEK
XHqC4sYYtLJhmcX0sL+fUyQsSMhS1Z1beUhhgxGTdr4qNcs1qo8oNP/eHBHdxnue
3IwFP/a856EOUhCFKESdRUPx428tBM9n/zHDAXKk4skdp7jM4uBGgSB+WUVXx3H2
TmSfawmoatPfn4PkTnA39cHybDrZtoSuZrSPvpv6f74Hnp6L+OOr4nrToxIF8WLe
64egF9uWoqOAmsR5Kjpva7f5SuaR5+lydgu58+sdxS6fezhg20Wu9t9H3uLDiU98
K5NVWoRafMLErmlNrpNyK0mRdlpvjuI/+WUIG17n0gKGTojaQ+w6Y7j2jIU4D3wU
A6XwvxBJNYyPFFbhtystruRwqLxIqGpCxUwQW1WENVzqBEyobuL5sWTWsBkrPdyV
WeFYSUZcwyQsa079fRho
=wiZW
-----END PGP SIGNATURE-----

--6o78gXsyQHm68LY/--
