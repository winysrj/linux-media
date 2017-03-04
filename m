Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58972 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752296AbdCDWxb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Mar 2017 17:53:31 -0500
Date: Sat, 4 Mar 2017 23:53:28 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCHv2] omap3isp: add support for CSI1 bus
Message-ID: <20170304225328.GD31766@amd>
References: <20161228183036.GA13139@amd>
 <10545906.Gxg3yScdu4@avalon>
 <20170215094228.GA8586@amd>
 <2414221.XNA4JCFMRx@avalon>
 <20170302090143.GB27818@amd>
 <20170302101603.GE27818@amd>
 <20170302112401.GF3220@valkosipuli.retiisi.org.uk>
 <20170302123848.GA28230@amd>
 <20170304130318.GU3220@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="EP0wieDxd4TSJjHq"
Content-Disposition: inline
In-Reply-To: <20170304130318.GU3220@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--EP0wieDxd4TSJjHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > +	if (isp->phy_type =3D=3D ISP_PHY_TYPE_3430) {
> > > > +		struct media_pad *pad;
> > > > +		struct v4l2_subdev *sensor;
> > > > +		const struct isp_ccp2_cfg *buscfg;
> > > > +
> > > > +		pad =3D media_entity_remote_pad(&ccp2->pads[CCP2_PAD_SINK]);
> > > > +		sensor =3D media_entity_to_v4l2_subdev(pad->entity);
> > > > +		/* Struct isp_bus_cfg has union inside */
> > > > +		buscfg =3D &((struct isp_bus_cfg *)sensor->host_priv)->bus.ccp2;
> > > > +
> > > > +		csiphy_routing_cfg_3430(&isp->isp_csiphy2,
> > > > +					ISP_INTERFACE_CCP2B_PHY1,
> > > > +					enable, !!buscfg->phy_layer,
> > > > +					buscfg->strobe_clk_pol);
> > >=20
> > > You should do this through omap3isp_csiphy_acquire(), and not call
> > > csiphy_routing_cfg_3430() directly from here.
> >=20
> > Well, unfortunately omap3isp_csiphy_acquire() does have csi2
> > assumptions hard-coded :-(.
> >=20
> > This will probably fail.
> >=20
> > 	        rval =3D omap3isp_csi2_reset(phy->csi2);
> > 	        if (rval < 0)
> > 		                goto done;
>=20
> Could you try to two patches I've applied on the ccp2 branch (I'll remove
> them if there are issues).
>=20
> That's compile tested for now only.

Thanks! They seem to be step in right direction. I still need to call
csiphy_routing_cfg_3430() directly for camera to work, but at least it
does not crash if I set up the phy pointer. I'll debug it some more.

Best regards,

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--EP0wieDxd4TSJjHq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAli7RWgACgkQMOfwapXb+vKwLgCgjicwndjAVodrGd+q56KArsf5
kSsAn01LvtOpOutAJYX7P3rjavQ52duG
=lzEr
-----END PGP SIGNATURE-----

--EP0wieDxd4TSJjHq--
