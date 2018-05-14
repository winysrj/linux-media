Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay11.mail.gandi.net ([217.70.178.231]:47193 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751626AbeENJQs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 05:16:48 -0400
Date: Mon, 14 May 2018 11:16:42 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v5 08/14] media: ov772x: support device tree probing
Message-ID: <20180514091642.GG5956@w540>
References: <1525616369-8843-1-git-send-email-akinobu.mita@gmail.com>
 <1525616369-8843-9-git-send-email-akinobu.mita@gmail.com>
 <20180507092641.bgsko6f34npn3mc7@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SUk9VBj82R8Xhb8H"
Content-Disposition: inline
In-Reply-To: <20180507092641.bgsko6f34npn3mc7@paasikivi.fi.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--SUk9VBj82R8Xhb8H
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sakari,

On Mon, May 07, 2018 at 12:26:41PM +0300, Sakari Ailus wrote:
> Dear Mita-san,
>
> On Sun, May 06, 2018 at 11:19:23PM +0900, Akinobu Mita wrote:
> > The ov772x driver currently only supports legacy platform data probe.
> > This change enables device tree probing.
> >
> > Note that the platform data probe can select auto or manual edge control
> > mode, but the device tree probling can only select auto edge control mo=
de
> > for now.
> >
> > Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Cc: Hans Verkuil <hans.verkuil@cisco.com>
> > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > ---
> > * v5
> > - Remove unnecessary space
> >
> >  drivers/media/i2c/ov772x.c | 64 ++++++++++++++++++++++++++++++++------=
--------
> >  1 file changed, 45 insertions(+), 19 deletions(-)
> >
> > diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> > index f939e28..2b02411 100644
> > --- a/drivers/media/i2c/ov772x.c
> > +++ b/drivers/media/i2c/ov772x.c
> > @@ -749,13 +749,13 @@ static int ov772x_s_ctrl(struct v4l2_ctrl *ctrl)
> >  	case V4L2_CID_VFLIP:
> >  		val =3D ctrl->val ? VFLIP_IMG : 0x00;
> >  		priv->flag_vflip =3D ctrl->val;
> > -		if (priv->info->flags & OV772X_FLAG_VFLIP)
> > +		if (priv->info && (priv->info->flags & OV772X_FLAG_VFLIP))
> >  			val ^=3D VFLIP_IMG;
> >  		return ov772x_mask_set(client, COM3, VFLIP_IMG, val);
> >  	case V4L2_CID_HFLIP:
> >  		val =3D ctrl->val ? HFLIP_IMG : 0x00;
> >  		priv->flag_hflip =3D ctrl->val;
> > -		if (priv->info->flags & OV772X_FLAG_HFLIP)
> > +		if (priv->info && (priv->info->flags & OV772X_FLAG_HFLIP))
> >  			val ^=3D HFLIP_IMG;
> >  		return ov772x_mask_set(client, COM3, HFLIP_IMG, val);
> >  	case V4L2_CID_BAND_STOP_FILTER:
> > @@ -914,19 +914,14 @@ static void ov772x_select_params(const struct v4l=
2_mbus_framefmt *mf,
> >  	*win =3D ov772x_select_win(mf->width, mf->height);
> >  }
> >
> > -static int ov772x_set_params(struct ov772x_priv *priv,
> > -			     const struct ov772x_color_format *cfmt,
> > -			     const struct ov772x_win_size *win)
> > +static int ov772x_edgectrl(struct ov772x_priv *priv)
> >  {
> >  	struct i2c_client *client =3D v4l2_get_subdevdata(&priv->subdev);
> > -	struct v4l2_fract tpf;
> >  	int ret;
> > -	u8  val;
> >
> > -	/* Reset hardware. */
> > -	ov772x_reset(client);
> > +	if (!priv->info)
> > +		return 0;
> >
> > -	/* Edge Ctrl. */
> >  	if (priv->info->edgectrl.strength & OV772X_MANUAL_EDGE_CTRL) {
> >  		/*
> >  		 * Manual Edge Control Mode.
> > @@ -937,19 +932,19 @@ static int ov772x_set_params(struct ov772x_priv *=
priv,
> >
> >  		ret =3D ov772x_mask_set(client, DSPAUTO, EDGE_ACTRL, 0x00);
> >  		if (ret < 0)
> > -			goto ov772x_set_fmt_error;
> > +			return ret;
> >
> >  		ret =3D ov772x_mask_set(client,
> >  				      EDGE_TRSHLD, OV772X_EDGE_THRESHOLD_MASK,
> >  				      priv->info->edgectrl.threshold);
> >  		if (ret < 0)
> > -			goto ov772x_set_fmt_error;
> > +			return ret;
> >
> >  		ret =3D ov772x_mask_set(client,
> >  				      EDGE_STRNGT, OV772X_EDGE_STRENGTH_MASK,
> >  				      priv->info->edgectrl.strength);
> >  		if (ret < 0)
> > -			goto ov772x_set_fmt_error;
> > +			return ret;
> >
> >  	} else if (priv->info->edgectrl.upper > priv->info->edgectrl.lower) {
> >  		/*
> > @@ -961,15 +956,35 @@ static int ov772x_set_params(struct ov772x_priv *=
priv,
> >  				      EDGE_UPPER, OV772X_EDGE_UPPER_MASK,
> >  				      priv->info->edgectrl.upper);
> >  		if (ret < 0)
> > -			goto ov772x_set_fmt_error;
> > +			return ret;
> >
> >  		ret =3D ov772x_mask_set(client,
> >  				      EDGE_LOWER, OV772X_EDGE_LOWER_MASK,
> >  				      priv->info->edgectrl.lower);
> >  		if (ret < 0)
> > -			goto ov772x_set_fmt_error;
> > +			return ret;
> >  	}
> >
> > +	return 0;
> > +}
> > +
> > +static int ov772x_set_params(struct ov772x_priv *priv,
> > +			     const struct ov772x_color_format *cfmt,
> > +			     const struct ov772x_win_size *win)
> > +{
> > +	struct i2c_client *client =3D v4l2_get_subdevdata(&priv->subdev);
> > +	struct v4l2_fract tpf;
> > +	int ret;
> > +	u8  val;
> > +
> > +	/* Reset hardware. */
> > +	ov772x_reset(client);
> > +
> > +	/* Edge Ctrl. */
> > +	ret =3D ov772x_edgectrl(priv);
> > +	if (ret < 0)
> > +		return ret;
> > +
> >  	/* Format and window size. */
> >  	ret =3D ov772x_write(client, HSTART, win->rect.left >> 2);
> >  	if (ret < 0)
> > @@ -1020,9 +1035,9 @@ static int ov772x_set_params(struct ov772x_priv *=
priv,
> >
> >  	/* Set COM3. */
> >  	val =3D cfmt->com3;
> > -	if (priv->info->flags & OV772X_FLAG_VFLIP)
> > +	if (priv->info && (priv->info->flags & OV772X_FLAG_VFLIP))
> >  		val |=3D VFLIP_IMG;
> > -	if (priv->info->flags & OV772X_FLAG_HFLIP)
> > +	if (priv->info && (priv->info->flags & OV772X_FLAG_HFLIP))
> >  		val |=3D HFLIP_IMG;
> >  	if (priv->flag_vflip)
> >  		val ^=3D VFLIP_IMG;
> > @@ -1271,8 +1286,9 @@ static int ov772x_probe(struct i2c_client *client,
> >  	struct i2c_adapter	*adapter =3D client->adapter;
> >  	int			ret;
> >
> > -	if (!client->dev.platform_data) {
> > -		dev_err(&client->dev, "Missing ov772x platform data\n");
> > +	if (!client->dev.of_node && !client->dev.platform_data) {
> > +		dev_err(&client->dev,
> > +			"Missing ov772x platform data for non-DT device\n");
> >  		return -EINVAL;
> >  	}
> >
> > @@ -1370,9 +1386,19 @@ static const struct i2c_device_id ov772x_id[] =
=3D {
> >  };
> >  MODULE_DEVICE_TABLE(i2c, ov772x_id);
> >
> > +#if IS_ENABLED(CONFIG_OF)
> > +static const struct of_device_id ov772x_of_match[] =3D {
> > +	{ .compatible =3D "ovti,ov7725", },
> > +	{ .compatible =3D "ovti,ov7720", },
> > +	{ /* sentinel */ },
> > +};
> > +MODULE_DEVICE_TABLE(of, ov772x_of_match);
> > +#endif
>
> No need for #ifdef's nor of_match_ptr below.
>
> If no other changes would be needed for the set (pending Jacopo's review),
> I can also drop these bits if you're ok for that.

I've now reviewed all the patches in the series, 11/14 apart where I
would apreciate if you could have a look at (nothing complex, just me
not knowing enough of controls to feel confident enough to give my ack
there).

=46rom my side then, the series is now fine. Thank Mita-san for your
work.

>
> > +
> >  static struct i2c_driver ov772x_i2c_driver =3D {
> >  	.driver =3D {
> >  		.name =3D "ov772x",
> > +		.of_match_table =3D of_match_ptr(ov772x_of_match),
> >  	},
> >  	.probe    =3D ov772x_probe,
> >  	.remove   =3D ov772x_remove,
>
> --
> Kind regards,
>
> Sakari Ailus
> sakari.ailus@linux.intel.com

--SUk9VBj82R8Xhb8H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa+VP6AAoJEHI0Bo8WoVY840oP/AoUmHux5KZtLdrCGy/zFcLV
4cdhEPI7Bfoz1liQLvpN4asxT2HyAJwQ88cVrBGgwPE4a031jHQrItaL2+GSgvCv
GpSSiTxF8UIiCUqgVOLwR1zaTFeZAaz1VFuj3rl72IdqvHtgGGBrKcYioLmf+apX
cFLi3ZwpAYWnCnFojZIs1BrtCr0gjYuXzZJGBvIr8dhg69eOAWgdOzKLbuOmsFlT
sXXAmgAAXo/YSplO2TPXdyIzhyU/8XruiCbEwXPuwLXkIfBZKl97xiV60PnvN3MC
2fNBp4FcpxEDxhBD7DFMEPWE5xLyQDqoCMWo086q4ioHs1oajoqLBkSHqCNBOVPE
46OaCWr09VR0P0zpndi2b7H0mvEdI141SBdozbpm/gwKF8MeAZMwyr/UE7lMdYkW
zh/9fNR+o3shWutO5Qsgxyjhdw0D5pyS0IV66YWGfkF2tGkkO/rw4Pbc4At0dYbO
qD1/fkOPt1BE9lQqPNslD1hAmIZPH35+iDq4scYjPlNmNsS5zx4O3XYyS6KkwgO7
hcRsUfRi3zuX8cFSQbTR4e6P7pktd7g/OXfmNRiCzID4HI3L8GnUdfsaXW32GTm+
0orC0oFBmsoJC7awXcWqAancbQIO9y7+xrft8gcdoaLjKq66eRNq5cF0M42yMp3u
36K6dJS6wWfBAIWSo+ol
=1l57
-----END PGP SIGNATURE-----

--SUk9VBj82R8Xhb8H--
