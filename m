Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41708 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751027AbdCBMlR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 07:41:17 -0500
Date: Thu, 2 Mar 2017 13:38:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCHv2] omap3isp: add support for CSI1 bus
Message-ID: <20170302123848.GA28230@amd>
References: <20161228183036.GA13139@amd>
 <10545906.Gxg3yScdu4@avalon>
 <20170215094228.GA8586@amd>
 <2414221.XNA4JCFMRx@avalon>
 <20170302090143.GB27818@amd>
 <20170302101603.GE27818@amd>
 <20170302112401.GF3220@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <20170302112401.GF3220@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Ok, how about this one?
> > omap3isp: add rest of CSI1 support
> >    =20
> > CSI1 needs one more bit to be set up. Do just that.
> >    =20
> > It is not as straightforward as I'd like, see the comments in the code
> > for explanation.
=2E..
> > +	if (isp->phy_type =3D=3D ISP_PHY_TYPE_3430) {
> > +		struct media_pad *pad;
> > +		struct v4l2_subdev *sensor;
> > +		const struct isp_ccp2_cfg *buscfg;
> > +
> > +		pad =3D media_entity_remote_pad(&ccp2->pads[CCP2_PAD_SINK]);
> > +		sensor =3D media_entity_to_v4l2_subdev(pad->entity);
> > +		/* Struct isp_bus_cfg has union inside */
> > +		buscfg =3D &((struct isp_bus_cfg *)sensor->host_priv)->bus.ccp2;
> > +
> > +		csiphy_routing_cfg_3430(&isp->isp_csiphy2,
> > +					ISP_INTERFACE_CCP2B_PHY1,
> > +					enable, !!buscfg->phy_layer,
> > +					buscfg->strobe_clk_pol);
>=20
> You should do this through omap3isp_csiphy_acquire(), and not call
> csiphy_routing_cfg_3430() directly from here.

Well, unfortunately omap3isp_csiphy_acquire() does have csi2
assumptions hard-coded :-(.

This will probably fail.

	        rval =3D omap3isp_csi2_reset(phy->csi2);
	        if (rval < 0)
		                goto done;
			=09
And this will oops:

static int omap3isp_csiphy_config(struct isp_csiphy *phy)
{
	struct isp_csi2_device *csi2 =3D phy->csi2;
        struct isp_pipeline *pipe =3D to_isp_pipeline(&csi2->subdev.entity);
 	struct isp_bus_cfg *buscfg =3D pipe->external->host_priv;

> > @@ -1137,10 +1159,19 @@ int omap3isp_ccp2_init(struct isp_device *isp)
> >  	if (isp->revision =3D=3D ISP_REVISION_2_0) {
> >  		ccp2->vdds_csib =3D devm_regulator_get(isp->dev, "vdds_csib");
> >  		if (IS_ERR(ccp2->vdds_csib)) {
> > +			if (PTR_ERR(ccp2->vdds_csib) =3D=3D -EPROBE_DEFER)
> > +				return -EPROBE_DEFER;
>=20
> This should go to a separate patch.

Ok, easy enough.

> >  			dev_dbg(isp->dev,
> >  				"Could not get regulator vdds_csib\n");
> >  			ccp2->vdds_csib =3D NULL;
> >  		}
> > +		/*
> > +		 * If we set up ccp2->phy here,
> > +		 * omap3isp_csiphy_acquire() will go ahead and assume
> > +		 * csi2, dereferencing some null pointers.
> > +		 *
> > +		 * ccp2->phy =3D &isp->isp_csiphy2;
>=20
> That needs to be fixed separately.

See analysis above. Yes, it would be nice to fix it. Can you provide
some hints how to do that? Maybe even patch to test? :-).

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAli4ElgACgkQMOfwapXb+vJtXgCgg1RVzK2DMFwN5q/8J97qgh3H
elQAmwXsrg0fbnR3toq63FoD93ALKoD9
=QWPs
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
