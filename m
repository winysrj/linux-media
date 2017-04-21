Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38326 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1035826AbdDUGdP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Apr 2017 02:33:15 -0400
Date: Fri, 21 Apr 2017 08:33:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Bhumika Goyal <bhumirks@gmail.com>
Subject: Re: [PATCH] [media] ov2640: make GPIOLIB an optional dependency
Message-ID: <20170421063312.GA21434@amd>
References: <a463ea990d2138ca93027b006be96a0324b77fe4.1492602584.git.mchehab@s-opensource.com>
 <20170419132339.GA31747@amd>
 <20170419110300.2dbbf784@vento.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <20170419110300.2dbbf784@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Better solution would be for VIDEO_EM28XX_V4L2 to depend on GPIOLIB,
> > too, no? If not, should there be BUG_ON(priv->pwdn_gpio);
> > BUG_ON(priv->resetb_gpio);?
>=20
> Pavel,
>=20
> The em28xx driver was added upstream several years the gpio driver.=20
> It controls GPIO using a different logic. It makes no sense to make
> it dependent on GPIOLIB, except if someone converts it to use it.

At least comment in the sourcecode...? Remove pwdn_gpio fields from
structure in !GPIOLIB case, because otherwise they are trap for the
programmer trying to understand what is going on?

Plus, something like this, because otherwise it is quite confusing?

Thanks,
								Pavel

diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_=
camera/ov2640.c
index 56de182..85620e1 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -1060,7 +1060,7 @@ static int ov2640_hw_reset(struct device *dev)
 		/* Active the resetb pin to perform a reset pulse */
 		gpiod_direction_output(priv->resetb_gpio, 1);
 		usleep_range(3000, 5000);
-		gpiod_direction_output(priv->resetb_gpio, 0);
+		gpiod_set_value(priv->resetb_gpio, 0);
 	}
=20
 	return 0;

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlj5p6gACgkQMOfwapXb+vKABwCgpGW3HGlVKTf7nn+qx1mMnBVg
AvYAoJzqB8l6CBW/KbcYPTHrPZ5Fupm0
=NnCn
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
