Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57707 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752778AbcKTPUn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Nov 2016 10:20:43 -0500
Date: Sun, 20 Nov 2016 16:20:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161120152034.GA5189@amd>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > +	u32 min, max;
> > +
> > +	v4l2_ctrl_handler_init(&sensor->ctrl_handler, 4);
> > +
> > +	/* V4L2_CID_GAIN */
> > +	v4l2_ctrl_new_std(&sensor->ctrl_handler, &et8ek8_ctrl_ops,
> > +			  V4L2_CID_GAIN, 0, ARRAY_SIZE(et8ek8_gain_table) - 1,
> > +			  1, 0);
> > +
> > +	/* V4L2_CID_EXPOSURE */
> > +	min =3D et8ek8_exposure_rows_to_us(sensor, 1);
> > +	max =3D et8ek8_exposure_rows_to_us(sensor,
> > +				sensor->current_reglist->mode.max_exp);
>=20
> Haven't I suggested to use lines instead? I vaguely remember doing so...
> this would remove quite some code from the driver.

Do you have some more hints? I'll try to figure it out...

> > +#ifdef CONFIG_PM
> > +
> > +static int et8ek8_suspend(struct device *dev)
>=20
> static int __maybe_unused ...
>=20
> Please check the smiapp patches I just sent to the list. The smiapp driver
> had similar issues.

Ok, I guess I figured it out from other code (no network at the
moment).

> > +	if (sensor->power_count) {
> > +		gpiod_set_value(sensor->reset, 0);
> > +		clk_disable_unprepare(sensor->ext_clk);
> > +		sensor->power_count =3D 0;
> > +	}
> > +
>=20
> You're missing v4l2_async_unregister_subdev() here.

Added.

> > +	v4l2_device_unregister_subdev(&sensor->subdev);
> > +	device_remove_file(&client->dev, &dev_attr_priv_mem);
> > +	v4l2_ctrl_handler_free(&sensor->ctrl_handler);
> > +	media_entity_cleanup(&sensor->subdev.entity);
> > +
> > +	return 0;
> > +}

> > +MODULE_DEVICE_TABLE(i2c, et8ek8_id_table);
> > +
> > +static const struct dev_pm_ops et8ek8_pm_ops =3D {
> > +	.suspend	=3D et8ek8_suspend,
> > +	.resume		=3D et8ek8_resume,
>=20
> How about using  SET_SYSTEM_SLEEP_PM_OPS() here?

Ok, I guess that saves few lines.

> > +module_i2c_driver(et8ek8_i2c_driver);
> > +
> > +MODULE_AUTHOR("Sakari Ailus <sakari.ailus@iki.fi>");
>=20
> You should put your name here as well. :-)
>=20
> It's been a long time I even tried to use it. :-i

Me? Ok, I can list myself there, but I don't really know much about
that driver.

> > + * Contact: Sakari Ailus <sakari.ailus@iki.fi>
> > + *          Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
>=20
> Tuukka's e-mail is wrong here (the correct address is elsewhere in the
> patch).

Fixed.

Ok, these cleanups are here.

									Pavel

diff --git a/drivers/media/i2c/et8ek8/et8ek8_driver.c b/drivers/media/i2c/e=
t8ek8/et8ek8_driver.c
index eb131b2..eb8c1b4 100644
--- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
+++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
@@ -5,6 +5,7 @@
  *
  * Contact: Sakari Ailus <sakari.ailus@iki.fi>
  *          Tuukka Toivonen <tuukkat76@gmail.com>
+ *          Pavel Machek <pavel@ucw.cz>
  *
  * Based on code from Toni Leinonen <toni.leinonen@offcode.fi>.
  *
@@ -1435,9 +1436,7 @@ static const struct v4l2_subdev_internal_ops et8ek8_i=
nternal_ops =3D {
 /* -----------------------------------------------------------------------=
---
  * I2C driver
  */
-#ifdef CONFIG_PM
-
-static int et8ek8_suspend(struct device *dev)
+static int __maybe_unused et8ek8_suspend(struct device *dev)
 {
 	struct i2c_client *client =3D to_i2c_client(dev);
 	struct v4l2_subdev *subdev =3D i2c_get_clientdata(client);
@@ -1449,7 +1448,7 @@ static int et8ek8_suspend(struct device *dev)
 	return __et8ek8_set_power(sensor, false);
 }
=20
-static int et8ek8_resume(struct device *dev)
+static int __maybe_unused et8ek8_resume(struct device *dev)
 {
 	struct i2c_client *client =3D to_i2c_client(dev);
 	struct v4l2_subdev *subdev =3D i2c_get_clientdata(client);
@@ -1461,13 +1460,6 @@ static int et8ek8_resume(struct device *dev)
 	return __et8ek8_set_power(sensor, true);
 }
=20
-#else
-
-#define et8ek8_suspend NULL
-#define et8ek8_resume NULL
-
-#endif /* CONFIG_PM */
-
 static int et8ek8_probe(struct i2c_client *client,
 			const struct i2c_device_id *devid)
 {
@@ -1542,6 +1534,7 @@ static int __exit et8ek8_remove(struct i2c_client *cl=
ient)
 	v4l2_device_unregister_subdev(&sensor->subdev);
 	device_remove_file(&client->dev, &dev_attr_priv_mem);
 	v4l2_ctrl_handler_free(&sensor->ctrl_handler);
+	v4l2_async_unregister_subdev(&sensor->subdev);
 	media_entity_cleanup(&sensor->subdev.entity);
=20
 	return 0;
@@ -1559,8 +1552,7 @@ static const struct i2c_device_id et8ek8_id_table[] =
=3D {
 MODULE_DEVICE_TABLE(i2c, et8ek8_id_table);
=20
 static const struct dev_pm_ops et8ek8_pm_ops =3D {
-	.suspend	=3D et8ek8_suspend,
-	.resume		=3D et8ek8_resume,
+	SET_SYSTEM_SLEEP_PM_OPS(et8ek8_suspend, et8ek8_resume)
 };
=20
 static struct i2c_driver et8ek8_i2c_driver =3D {
@@ -1576,6 +1568,6 @@ static struct i2c_driver et8ek8_i2c_driver =3D {
=20
 module_i2c_driver(et8ek8_i2c_driver);
=20
-MODULE_AUTHOR("Sakari Ailus <sakari.ailus@iki.fi>");
+MODULE_AUTHOR("Sakari Ailus <sakari.ailus@iki.fi>, Pavel Machek <pavel@ucw=
=2Ecz");
 MODULE_DESCRIPTION("Toshiba ET8EK8 camera sensor driver");
 MODULE_LICENSE("GPL");


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgxv0IACgkQMOfwapXb+vIPlwCfXlUct8HIH+F57HWhhAryjbfP
6k4AnjgoDMfh7m0GC5Ve1Kutw4zmQN/s
=QoW+
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
