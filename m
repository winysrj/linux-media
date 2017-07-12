Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56989 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753784AbdGLQci (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 12:32:38 -0400
Date: Wed, 12 Jul 2017 18:32:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: v4l2-fwnode: status, plans for merge, any branch to merge
 against?
Message-ID: <20170712163235.GA11892@amd>
References: <20170306072323.GA23509@amd>
 <20170310225418.GJ3220@valkosipuli.retiisi.org.uk>
 <20170613122240.GA2803@amd>
 <20170613124748.GD12407@valkosipuli.retiisi.org.uk>
 <20170613210900.GA31456@amd>
 <20170614110634.GP12407@valkosipuli.retiisi.org.uk>
 <20170704150819.GA10703@localhost>
 <20170705093248.hndchnamibhqczfr@valkosipuli.retiisi.org.uk>
 <20170706103851.GA9555@amd>
 <20170711161245.5ftg6jgomudzlosz@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <20170711161245.5ftg6jgomudzlosz@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!


> > > 1) Make sure there will be no regressions,
> >=20
> > Well, all I have running recent kernels is N900. If ccp branch works
> > for you on N9, that's probably as much testing as we can get.
> >=20
> > > 2) clean things up in the omap3isp; which resources are needed and wh=
en
> > > (e.g. regulators, PHY configuration) isn't clear at the moment and
> > >=20
> > > 2) have one driver using the implementation.
> > >=20
> > > At least 1) is needed. I think a number of framework patches could be
> > > mergeable before 2) and 3) are done. I can prepare a set later this w=
eek.
> > > But even that'd be likely for 4.14, not 4.13.
> >=20
> > Yep, it is too late for v4.13 now. But getting stuff ready for v4.14
> > would be good.
=2E..
> > @@ -302,13 +303,16 @@ int omap3isp_csiphy_acquire(struct isp_csiphy *ph=
y)
> >  	if (rval < 0)
> >  		goto done;
> > =20
> > -	rval =3D csiphy_set_power(phy, ISPCSI2_PHY_CFG_PWR_CMD_ON);
> > -	if (rval) {
> > -		regulator_disable(phy->vdd);
> > -		goto done;
> > +	if (phy->isp->revision =3D=3D ISP_REVISION_15_0) {
>=20
> Shouldn't you make the related changes to omap3isp_csiphy_release() as
> well?
>=20
> Other than that the patch looks good to me.

Ah, yes, that needs to be fixed. Thanks for review.

I'll refresh the series. I believe we now have everything neccessary
to have useful driver for 4.14. Series is still based on 4.12-rc3, I
can rebase it when there's better base.

Best regards,

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllmTyMACgkQMOfwapXb+vIvTwCfep7gKn4wlxyFb/eJSDM/yxSr
EkcAn2sdtBTAcwoN22LuyUFyFuRRQMCt
=++4y
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
