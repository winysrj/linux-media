Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45946 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751846AbdGRVCa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 17:02:30 -0400
Date: Tue, 18 Jul 2017 23:02:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 4/7] omap3isp: Return -EPROBE_DEFER if the required
 regulators can't be obtained
Message-ID: <20170718210228.GA13046@amd>
References: <20170717220116.17886-1-sakari.ailus@linux.intel.com>
 <20170717220116.17886-5-sakari.ailus@linux.intel.com>
 <1652763.9EYemjAvaH@avalon>
 <20170718100352.GA28481@amd>
 <20170718101702.qi72355jjjuq7jjs@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <20170718101702.qi72355jjjuq7jjs@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > diff --git a/drivers/media/platform/omap3isp/ispccp2.c
> > > > b/drivers/media/platform/omap3isp/ispccp2.c index
> > > > 4f8fd0c00748..47210b102bcb 100644
> > > > --- a/drivers/media/platform/omap3isp/ispccp2.c
> > > > +++ b/drivers/media/platform/omap3isp/ispccp2.c
> > > > @@ -1140,6 +1140,11 @@ int omap3isp_ccp2_init(struct isp_device *is=
p)
> > > >  	if (isp->revision =3D=3D ISP_REVISION_2_0) {
> > > >  		ccp2->vdds_csib =3D devm_regulator_get(isp->dev, "vdds_csib");
> > > >  		if (IS_ERR(ccp2->vdds_csib)) {
> > > > +			if (PTR_ERR(ccp2->vdds_csib) =3D=3D -EPROBE_DEFER) {
> > > > +				dev_dbg(isp->dev,
> > > > +					"Can't get regulator vdds_csib,=20
> > > deferring probing\n");
> > > > +				return -EPROBE_DEFER;
> > > > +			}
> > > >  			dev_dbg(isp->dev,
> > > >  				"Could not get regulator vdds_csib\n");
> > >=20
> > > I would just move this message above the -EPROBE_DEFER check and remo=
ve the=20
> > > one inside the check. Probe deferral debug information can be obtaine=
d by=20
> > > enabling the debug messages in the driver core.
> >=20
> > Actually, in such case perhaps the message in -EPROBE_DEFER could be
> > removed. Deferred probing happens all the time. OTOH "Could not get
> > regulator" probably should be dev_err(), as it will make device
> > unusable?
>=20
> Isn't this only if you need ccp2?

No idea really. I only have N900 working with linux at the moment. I'm
trying to get N9 and N950 working, but no luck so far.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllud2QACgkQMOfwapXb+vK3GwCgrrh1Upnjsnc7i39y4eCXOzAA
ILcAnjUFIaYapJQtC8I5Q+F2L3S+nqp0
=21DN
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
