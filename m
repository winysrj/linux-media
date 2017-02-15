Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57328 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751246AbdBOKXE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 05:23:04 -0500
Date: Wed, 15 Feb 2017 11:23:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, mchehab@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] omap3isp: add support for CSI1 bus
Message-ID: <20170215102301.GA29330@amd>
References: <20161228183036.GA13139@amd>
 <20170208083813.GG13854@valkosipuli.retiisi.org.uk>
 <20170208125738.GA23236@amd>
 <10545906.Gxg3yScdu4@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <10545906.Gxg3yScdu4@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > +		if (enable) {
> > +			csirxfe =3D OMAP343X_CONTROL_CSIRXFE_PWRDNZ |
> > +				  OMAP343X_CONTROL_CSIRXFE_RESET;
> > +
> > +			if (buscfg->phy_layer)
> > +				csirxfe |=3D OMAP343X_CONTROL_CSIRXFE_SELFORM;
> > +
> > +			if (buscfg->strobe_clk_pol)
> > +				csirxfe |=3D OMAP343X_CONTROL_CSIRXFE_CSIB_INV;
> > +		} else
> > +			csirxfe =3D 0;
>=20
> You need curly braces for the else statement too.
>=20
> > +
> > +		regmap_write(isp->syscon, isp->syscon_offset, csirxfe);
>=20
> Isn't this already configured by csiphy_routing_cfg_3430(), called throug=
h=20
> omap3isp_csiphy_acquire() ? You'll need to add support for the strobe/clo=
ck=20
> polarity there, but the rest should already be handled.

It seems csiphy_routing_cfg_3430 is not called at all. I added
printks, but they don't trigger. If you have an idea what is going on
there, it would help...
									Pavel

diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/media/pl=
atform/omap3isp/ispcsiphy.c
index 6b814e1..fe9303a 100644
--- a/drivers/media/platform/omap3isp/ispcsiphy.c
+++ b/drivers/media/platform/omap3isp/ispcsiphy.c
@@ -30,6 +30,8 @@ static void csiphy_routing_cfg_3630(struct isp_csiphy *ph=
y,
 	u32 reg;
 	u32 shift, mode;
=20
+	printk("routing cfg 3630: iface %d, %d\n", iface, ISP_INTERFACE_CCP2B_PHY=
1);
+=09
 	regmap_read(phy->isp->syscon, phy->isp->syscon_offset, &reg);
=20
 	switch (iface) {
@@ -74,6 +76,9 @@ static void csiphy_routing_cfg_3430(struct isp_csiphy *ph=
y, u32 iface, bool on,
 	u32 csirxfe =3D OMAP343X_CONTROL_CSIRXFE_PWRDNZ
 		| OMAP343X_CONTROL_CSIRXFE_RESET;
=20
+	/* FIXME: can this be used instead of if (isp->revision) in ispccp2.c? */
+=09
+	printk("routing cfg: iface %d, %d\n", iface, ISP_INTERFACE_CCP2B_PHY1);
 	/* Only the CCP2B on PHY1 is configurable. */
 	if (iface !=3D ISP_INTERFACE_CCP2B_PHY1)
 		return;
@@ -105,6 +110,7 @@ static void csiphy_routing_cfg(struct isp_csiphy *phy,
 			       enum isp_interface_type iface, bool on,
 			       bool ccp2_strobe)
 {
+	printk("csiphy_routing_cfg\n");
 	if (phy->isp->phy_type =3D=3D ISP_PHY_TYPE_3630 && on)
 		return csiphy_routing_cfg_3630(phy, iface, ccp2_strobe);
 	if (phy->isp->phy_type =3D=3D ISP_PHY_TYPE_3430)



--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlikLAUACgkQMOfwapXb+vLN7QCaA+q03kwYWXP0w2YsSDHXItwc
DZ0AnAzwJ9kIrDpQyAbfX8R+KAdLX1WH
=h7pp
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
