Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37531 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751397AbdGZScK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Jul 2017 14:32:10 -0400
Date: Wed, 26 Jul 2017 20:32:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Rui Miguel Silva <rmfrfs@gmail.com>
Cc: Johan Hovold <johan@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        jacek.anaszewski@gmail.com, laurent.pinchart@ideasonboard.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/2] staging: greybus: light: Don't leak memory for no
 gain
Message-ID: <20170726183207.GB29978@amd>
References: <20170718184107.10598-1-sakari.ailus@linux.intel.com>
 <20170718184107.10598-2-sakari.ailus@linux.intel.com>
 <20170725123031.GB27516@localhost>
 <20170726150356.GA21301@arch-late.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="aVD9QWMuhilNxW9f"
Content-Disposition: inline
In-Reply-To: <20170726150356.GA21301@arch-late.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--aVD9QWMuhilNxW9f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> On Tue, Jul 25, 2017 at 02:30:31PM +0200, Johan Hovold wrote:
> > [ +CC: Rui and Greg ]
>=20
> Thanks Johan. I only got this because of you.

> > >  	return ret;
> > >  }
> >=20
> > And while it's fine to take this through linux-media, it would still be
> > good to keep the maintainers on CC.
>=20
> Sakari, if you could resend the all series to the right lists and
> maintainers for proper review that would be great.
>=20
> I did not get 0/2 and 2/2 patches.

0/2 and 2/2 were unrelated to the memory leak, IIRC. Let me google it
for you...

https://www.mail-archive.com/linux-media@vger.kernel.org/msg115840.html

This is memory leak and the driver is in staging. Acked-by or fixing
it yourself would be appropriate response, asking for resending of the
series... not quite so.

Best regards,

									Pavel

> > On Tue, Jul 18, 2017 at 09:41:06PM +0300, Sakari Ailus wrote:
> > > Memory for struct v4l2_flash_config is allocated in
> > > gb_lights_light_v4l2_register() for no gain and yet the allocated mem=
ory is
> > > leaked; the struct isn't used outside the function. Fix this.
> > >=20
> > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > ---
> > >  drivers/staging/greybus/light.c | 17 ++++++-----------
> > >  1 file changed, 6 insertions(+), 11 deletions(-)
> > >=20
> > > diff --git a/drivers/staging/greybus/light.c b/drivers/staging/greybu=
s/light.c
> > > index 129ceed39829..b25c117ec41a 100644
> > > --- a/drivers/staging/greybus/light.c
> > > +++ b/drivers/staging/greybus/light.c
> > > @@ -534,25 +534,21 @@ static int gb_lights_light_v4l2_register(struct=
 gb_light *light)
> > >  {
> > >  	struct gb_connection *connection =3D get_conn_from_light(light);
> > >  	struct device *dev =3D &connection->bundle->dev;
> > > -	struct v4l2_flash_config *sd_cfg;
> > > +	struct v4l2_flash_config sd_cfg =3D { 0 };
> > >  	struct led_classdev_flash *fled;
> > >  	struct led_classdev *iled =3D NULL;
> > >  	struct gb_channel *channel_torch, *channel_ind, *channel_flash;
> > >  	int ret =3D 0;
> > > =20
> > > -	sd_cfg =3D kcalloc(1, sizeof(*sd_cfg), GFP_KERNEL);
> > > -	if (!sd_cfg)
> > > -		return -ENOMEM;
> > > -
> > >  	channel_torch =3D get_channel_from_mode(light, GB_CHANNEL_MODE_TORC=
H);
> > >  	if (channel_torch)
> > >  		__gb_lights_channel_v4l2_config(&channel_torch->intensity_uA,
> > > -						&sd_cfg->torch_intensity);
> > > +						&sd_cfg.torch_intensity);
> > > =20
> > >  	channel_ind =3D get_channel_from_mode(light, GB_CHANNEL_MODE_INDICA=
TOR);
> > >  	if (channel_ind) {
> > >  		__gb_lights_channel_v4l2_config(&channel_ind->intensity_uA,
> > > -						&sd_cfg->indicator_intensity);
> > > +						&sd_cfg.indicator_intensity);
> > >  		iled =3D &channel_ind->fled.led_cdev;
> > >  	}
> > > =20
> > > @@ -561,17 +557,17 @@ static int gb_lights_light_v4l2_register(struct=
 gb_light *light)
> > > =20
> > >  	fled =3D &channel_flash->fled;
> > > =20
> > > -	snprintf(sd_cfg->dev_name, sizeof(sd_cfg->dev_name), "%s", light->n=
ame);
> > > +	snprintf(sd_cfg.dev_name, sizeof(sd_cfg.dev_name), "%s", light->nam=
e);
> > > =20
> > >  	/* Set the possible values to faults, in our case all faults */
> > > -	sd_cfg->flash_faults =3D LED_FAULT_OVER_VOLTAGE | LED_FAULT_TIMEOUT=
 |
> > > +	sd_cfg.flash_faults =3D LED_FAULT_OVER_VOLTAGE | LED_FAULT_TIMEOUT |
> > >  		LED_FAULT_OVER_TEMPERATURE | LED_FAULT_SHORT_CIRCUIT |
> > >  		LED_FAULT_OVER_CURRENT | LED_FAULT_INDICATOR |
> > >  		LED_FAULT_UNDER_VOLTAGE | LED_FAULT_INPUT_VOLTAGE |
> > >  		LED_FAULT_LED_OVER_TEMPERATURE;
> > > =20
> > >  	light->v4l2_flash =3D v4l2_flash_init(dev, NULL, fled, iled,
> > > -					    &v4l2_flash_ops, sd_cfg);
> > > +					    &v4l2_flash_ops, &sd_cfg);
> > >  	if (IS_ERR_OR_NULL(light->v4l2_flash)) {
> > >  		ret =3D PTR_ERR(light->v4l2_flash);
> > >  		goto out_free;
> > > @@ -580,7 +576,6 @@ static int gb_lights_light_v4l2_register(struct g=
b_light *light)
> > >  	return ret;
> > > =20
> > >  out_free:
> > > -	kfree(sd_cfg);
> >=20
> > This looks a bit lazy, even if I just noticed that you repurpose this
> > error label (without renaming it) in you second patch.
> >=20
> >=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--aVD9QWMuhilNxW9f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAll44CcACgkQMOfwapXb+vIzSQCgrbBiYeKwejyiOu5/MVqLgum5
0T8An0uOvX6vDaPFltjiwYTayQvmFS6j
=19nZ
-----END PGP SIGNATURE-----

--aVD9QWMuhilNxW9f--
