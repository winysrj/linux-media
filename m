Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38098 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752188AbdBORGs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 12:06:48 -0500
Date: Wed, 15 Feb 2017 18:06:44 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, mchehab@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] omap3isp: add support for CSI1 bus
Message-ID: <20170215170644.GA7573@amd>
References: <20161228183036.GA13139@amd>
 <20170208083813.GG13854@valkosipuli.retiisi.org.uk>
 <20170208125738.GA23236@amd>
 <10545906.Gxg3yScdu4@avalon>
 <20170215102301.GA29330@amd>
 <20170215165745.dxabuuvjspof26pg@earth>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
In-Reply-To: <20170215165745.dxabuuvjspof26pg@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2017-02-15 17:57:46, Sebastian Reichel wrote:
> Hi,
>=20
> On Wed, Feb 15, 2017 at 11:23:01AM +0100, Pavel Machek wrote:
> > It seems csiphy_routing_cfg_3430 is not called at all. I added
> > printks, but they don't trigger. If you have an idea what is going on
> > there, it would help...
>=20
> You added printk to csiphy_routing_cfg_3630 instead of csiphy_routing_cfg=
_3430
> and N900 has OMAP3430. Function should be called when you start (or
> stop) using the camera:
>=20
> csiphy_routing_cfg_3430(...)
> csiphy_routing_cfg(...)
> omap3isp_csiphy_config(...)
> omap3isp_csiphy_acquire(...) & omap3isp_csiphy_release(...)
> ccp2_s_stream(...)

Take another look, I believe I added printk to both of them.

Thanks for the expected backtrace, that should help figuring it out.

> -- Sebastian
>=20
> > diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/medi=
a/platform/omap3isp/ispcsiphy.c
> > index 6b814e1..fe9303a 100644
> > --- a/drivers/media/platform/omap3isp/ispcsiphy.c
> > +++ b/drivers/media/platform/omap3isp/ispcsiphy.c
> > @@ -30,6 +30,8 @@ static void csiphy_routing_cfg_3630(struct isp_csiphy=
 *phy,
> >  	u32 reg;
> >  	u32 shift, mode;
> > =20
> > +	printk("routing cfg 3630: iface %d, %d\n", iface, ISP_INTERFACE_CCP2B=
_PHY1);
> > +=09
> >  	regmap_read(phy->isp->syscon, phy->isp->syscon_offset, &reg);
> > =20
> >  	switch (iface) {
> > @@ -74,6 +76,9 @@ static void csiphy_routing_cfg_3430(struct isp_csiphy=
 *phy, u32 iface, bool on,
> >  	u32 csirxfe =3D OMAP343X_CONTROL_CSIRXFE_PWRDNZ
> >  		| OMAP343X_CONTROL_CSIRXFE_RESET;
> > =20
> > +	/* FIXME: can this be used instead of if (isp->revision) in ispccp2.c=
? */
> > +=09
> > +	printk("routing cfg: iface %d, %d\n", iface, ISP_INTERFACE_CCP2B_PHY1=
);
> >  	/* Only the CCP2B on PHY1 is configurable. */
> >  	if (iface !=3D ISP_INTERFACE_CCP2B_PHY1)
> >  		return;
> > @@ -105,6 +110,7 @@ static void csiphy_routing_cfg(struct isp_csiphy *p=
hy,
> >  			       enum isp_interface_type iface, bool on,
> >  			       bool ccp2_strobe)
> >  {
> > +	printk("csiphy_routing_cfg\n");
> >  	if (phy->isp->phy_type =3D=3D ISP_PHY_TYPE_3630 && on)
> >  		return csiphy_routing_cfg_3630(phy, iface, ccp2_strobe);
> >  	if (phy->isp->phy_type =3D=3D ISP_PHY_TYPE_3430)



--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlikiqMACgkQMOfwapXb+vLX1QCfQFOnECH38G4eSfbBRxIZDkI0
pxoAn02jj12ga+ZtoXm3sWwkcxuGUBIX
=n36N
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
