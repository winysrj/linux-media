Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47567 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753022AbdHGLJJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Aug 2017 07:09:09 -0400
Date: Mon, 7 Aug 2017 13:09:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Stefan Agner <stefan@agner.ch>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Revert "[media] et8ek8: Export OF device ID as module aliases"
Message-ID: <20170807110907.GA28655@amd>
References: <20170608090156.2373326-1-arnd@arndb.de>
 <aae480c52bd7e9e4772b3c9c76420435@agner.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <aae480c52bd7e9e4772b3c9c76420435@agner.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Just hit this issue too. This seems not to have made it into v4.13 as of
> today yet, any chance to get it still in?

If Mauro does not react, I guess we can push the patche through
akpm. Hmm. Or directly to the Linus. -rc really is about fixing
regressions, such as this.

Best regards,
									Pavel

> --
> Stefan
>=20
> On 2017-06-08 02:01, Arnd Bergmann wrote:
> > This one got applied twice, causing a build error with clang:
> >=20
> > drivers/media/i2c/et8ek8/et8ek8_driver.c:1499:1: error: redefinition
> > of '__mod_of__et8ek8_of_table_device_table'
> >=20
> > Fixes: 9ae05fd1e791 ("[media] et8ek8: Export OF device ID as module ali=
ases")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Acked-by: Pavel Machek <pavel@ucw.cz>
> > ---
> >  drivers/media/i2c/et8ek8/et8ek8_driver.c | 1 -
> >  1 file changed, 1 deletion(-)
> >=20
> > diff --git a/drivers/media/i2c/et8ek8/et8ek8_driver.c
> > b/drivers/media/i2c/et8ek8/et8ek8_driver.c
> > index 6e313d5243a0..f39f5179dd95 100644
> > --- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
> > +++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
> > @@ -1496,7 +1496,6 @@ MODULE_DEVICE_TABLE(i2c, et8ek8_id_table);
> >  static const struct dev_pm_ops et8ek8_pm_ops =3D {
> >  	SET_SYSTEM_SLEEP_PM_OPS(et8ek8_suspend, et8ek8_resume)
> >  };
> > -MODULE_DEVICE_TABLE(of, et8ek8_of_table);
> > =20
> >  static struct i2c_driver et8ek8_i2c_driver =3D {
> >  	.driver		=3D {

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmISlIACgkQMOfwapXb+vI1OwCfXgsayJX54VYGUYi4Fd2vc5q8
E8MAn3a/xBPRuEXdUgG7mV3wbbX1UZuL
=/oUH
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
