Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44763 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932090AbdHWPfj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 11:35:39 -0400
Date: Wed, 23 Aug 2017 17:35:34 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: omap3isp: fix uninitialized variable use
Message-ID: <20170823153534.enifcsolharwrtum@earth>
References: <20170823133044.686146-1-arnd@arndb.de>
 <20170823135827.l7fgozsbhw5opyy3@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="by5esd6o3khtfg5v"
Content-Disposition: inline
In-Reply-To: <20170823135827.l7fgozsbhw5opyy3@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--by5esd6o3khtfg5v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Aug 23, 2017 at 04:58:27PM +0300, Sakari Ailus wrote:
> On Wed, Aug 23, 2017 at 03:30:19PM +0200, Arnd Bergmann wrote:
> > A debug printk statement was copied incorrectly into the new
> > csi1 parser code and causes a warning there:
> >=20
> > drivers/media/platform/omap3isp/isp.c: In function 'isp_probe':
> > include/linux/dynamic_debug.h:134:3: error: 'i' may be used uninitializ=
ed in this function [-Werror=3Dmaybe-uninitialized]
> >=20
> > Since there is only one lane, the index is never set. This
> > changes the debug print to always print a zero instead,
> > keeping the original format of the message.
> >=20
> > Fixes: 9211434bad30 ("media: omap3isp: Parse CSI1 configuration from th=
e device tree")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/media/platform/omap3isp/isp.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/plat=
form/omap3isp/isp.c
> > index 83aea08b832d..30c825bf80d9 100644
> > --- a/drivers/media/platform/omap3isp/isp.c
> > +++ b/drivers/media/platform/omap3isp/isp.c
> > @@ -2092,7 +2092,7 @@ static int isp_fwnode_parse(struct device *dev, s=
truct fwnode_handle *fwnode,
> >  			buscfg->bus.ccp2.lanecfg.data[0].pol =3D
> >  				vep.bus.mipi_csi1.lane_polarity[1];
> > =20
> > -			dev_dbg(dev, "data lane %u polarity %u, pos %u\n", i,
> > +			dev_dbg(dev, "data lane 0 polarity %u, pos %u\n",
> >  				buscfg->bus.ccp2.lanecfg.data[0].pol,
> >  				buscfg->bus.ccp2.lanecfg.data[0].pos);
> > =20
>=20
> Thanks! I removed "0 "; CCP2 always has a single lane. The patch is now:
>=20
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platfo=
rm/omap3isp/isp.c
> index 83aea08b832d..1a428fe9f070 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2092,7 +2092,7 @@ static int isp_fwnode_parse(struct device *dev, str=
uct fwnode_handle *fwnode,
>  			buscfg->bus.ccp2.lanecfg.data[0].pol =3D
>  				vep.bus.mipi_csi1.lane_polarity[1];
> =20
> -			dev_dbg(dev, "data lane %u polarity %u, pos %u\n", i,
> +			dev_dbg(dev, "data lane polarity %u, pos %u\n",
>  				buscfg->bus.ccp2.lanecfg.data[0].pol,
>  				buscfg->bus.ccp2.lanecfg.data[0].pos);

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

--by5esd6o3khtfg5v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlmdoMYACgkQ2O7X88g7
+poVQA//RYqkZ/E8q9OR647fdPzI2TAJnnrd69cc5KCvdcmcEM2LTC+xQhBIP2Bv
R4wgx9iwFolaeTJjwqYmSjelHRAjwvr1l5zUFUTKI1BCPlz98lmEEnd+fOm7ldBD
+mjlQjE6V1IwptAgj0jaXa/a3V9RcM3138dYHRyHccDnWQMIxQc87WWZ46WzoKbS
CldeyFZkjL6Ja6TzUHvGLmE2ZEfmTkYTJ6Q50RoIrriEuBSzzYxVXVu8y+fnPP0e
yqahi3BTqO0ysg1t5BStT2g7jG8hgjeULv7v5vNc23Q188eoDhggQDtOzrG+GJzC
HFfX67wa1936q69j0U1NbUxzUnT78addT6hrZsiMROk3Y9+IEZxtTheiPPwSGLjZ
QNXNM3akqRiWuWIViHgWj/IWybRNt1k7gdhtTpbhxu64O6NVLggcFAI+5s2hgj2Y
tlP88H4Zk2EAW+cni6pHNARVJA/ecWWIL7W5/uuh18XROajke3Nd2CQOsKPk/9Yz
pOkP1U4tNgDQ8e4kZs/+saCF23nIlxLKix/gOTO5U2QhonlO6YfHJk5fXqI/bixH
Tmo8SF/h1dCz/L4sxJaeAR62Qg0+6QEBRYskBwk5dha7bVTFCbedwSM/+zzcfTVw
CRdKTrg2XDuC36u3zFuqOuQSSDUiVG10gU2oW98a7R+bHngDa1I=
=Xvrc
-----END PGP SIGNATURE-----

--by5esd6o3khtfg5v--
