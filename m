Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44142 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934312AbdCJNlg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 08:41:36 -0500
Date: Fri, 10 Mar 2017 14:41:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [RFC] omap3isp: add support for CSI1 bus
Message-ID: <20170310134131.GD11875@amd>
References: <20161228183036.GA13139@amd>
 <10545906.Gxg3yScdu4@avalon>
 <20170215094228.GA8586@amd>
 <2414221.XNA4JCFMRx@avalon>
 <20170302090143.GB27818@amd>
 <20170302101603.GE27818@amd>
 <20170302112401.GF3220@valkosipuli.retiisi.org.uk>
 <20170302123848.GA28230@amd>
 <20170304130318.GU3220@valkosipuli.retiisi.org.uk>
 <20170306075659.GB23509@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3Pql8miugIZX0722"
Content-Disposition: inline
In-Reply-To: <20170306075659.GB23509@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--3Pql8miugIZX0722
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2017-03-06 08:56:59, Pavel Machek wrote:
> omap3isp: add rest of CSI1 support
>=20
> CSI1 needs one more bit to be set up. Do just that.
>=20
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>=20
> ---
>=20
> Hmm. Looking at that... num_data_lanes probably should be modified in
> local variable, not globally like this. Should I do that?
>=20
> Anything else that needs fixing?

Ping? Feedback here would be nice. This is last "interesting" piece of
the hardware support...

Best regards,
								Pavel

> index 24a9fc5..6feba36 100644
> --- a/drivers/media/platform/omap3isp/ispccp2.c
> +++ b/drivers/media/platform/omap3isp/ispccp2.c
> @@ -21,6 +23,7 @@
>  #include <linux/mutex.h>
>  #include <linux/uaccess.h>
>  #include <linux/regulator/consumer.h>
> +#include <linux/regmap.h>
> =20
>  #include "isp.h"
>  #include "ispreg.h"
> @@ -1149,6 +1152,7 @@ int omap3isp_ccp2_init(struct isp_device *isp)
>  				"Could not get regulator vdds_csib\n");
>  			ccp2->vdds_csib =3D NULL;
>  		}
> +		ccp2->phy =3D &isp->isp_csiphy2;
>  	} else if (isp->revision =3D=3D ISP_REVISION_15_0) {
>  		ccp2->phy =3D &isp->isp_csiphy1;
>  	}
> diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/media/=
platform/omap3isp/ispcsiphy.c
> index 50c0f64..cd6351b 100644
> --- a/drivers/media/platform/omap3isp/ispcsiphy.c
> +++ b/drivers/media/platform/omap3isp/ispcsiphy.c
> @@ -197,9 +200,10 @@ static int omap3isp_csiphy_config(struct isp_csiphy =
*phy)
>  	}
> =20
>  	if (buscfg->interface =3D=3D ISP_INTERFACE_CCP2B_PHY1
> -	    || buscfg->interface =3D=3D ISP_INTERFACE_CCP2B_PHY2)
> +	    || buscfg->interface =3D=3D ISP_INTERFACE_CCP2B_PHY2) {
>  		lanes =3D &buscfg->bus.ccp2.lanecfg;
> -	else
> +		phy->num_data_lanes =3D 1;
> +	} else
>  		lanes =3D &buscfg->bus.csi2.lanecfg;
> =20
>  	/* Clock and data lanes verification */
> @@ -302,13 +306,16 @@ int omap3isp_csiphy_acquire(struct isp_csiphy *phy)
>  	if (rval < 0)
>  		goto done;
> =20
> -	rval =3D csiphy_set_power(phy, ISPCSI2_PHY_CFG_PWR_CMD_ON);
> -	if (rval) {
> -		regulator_disable(phy->vdd);
> -		goto done;
> +	if (phy->isp->revision =3D=3D ISP_REVISION_15_0) {
> +		rval =3D csiphy_set_power(phy, ISPCSI2_PHY_CFG_PWR_CMD_ON);
> +		if (rval) {
> +			regulator_disable(phy->vdd);
> +			goto done;
> +		}
> +	=09
> +		csiphy_power_autoswitch_enable(phy, true);	=09
>  	}
> =20
> -	csiphy_power_autoswitch_enable(phy, true);
>  	phy->phy_in_use =3D 1;
> =20
>  done:
>=20



--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--3Pql8miugIZX0722
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAljCrQsACgkQMOfwapXb+vLSNgCdETmKgyTz5vu2g25Kl4ZEvkzb
5I8AmgOspB2wChxqE/+4SPmggI1DhhB7
=j2Ss
-----END PGP SIGNATURE-----

--3Pql8miugIZX0722--
