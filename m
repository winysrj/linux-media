Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41043 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751060AbdB1JRL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 04:17:11 -0500
Date: Tue, 28 Feb 2017 10:17:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: [PATCH 1/4] v4l2: device_register_subdev_nodes: allow calling
 multiple times
Message-ID: <20170228091708.GA5214@amd>
References: <d315073f004ce46e0198fd614398e046ffe649e7.1487111824.git.pavel@ucw.cz>
 <20170220103114.GA9800@amd>
 <20170220130912.GT16975@valkosipuli.retiisi.org.uk>
 <20170220135636.GU16975@valkosipuli.retiisi.org.uk>
 <20170221110721.GD5021@amd>
 <20170221111104.GD16975@valkosipuli.retiisi.org.uk>
 <20170225221255.GA6411@amd>
 <20170227205420.GF16975@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <20170227205420.GF16975@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Please find my comments below.

Thanks for quick review, will fix.

> >  		switch (vfwn.base.port) {
> >  		case ISP_OF_PHY_CSIPHY1:
> > -			buscfg->interface =3D ISP_INTERFACE_CSI2C_PHY1;
> > +			if (csi1)
>=20
> You could compare vfwn.bus_type =3D=3D V4L2_MBUS_CSI2 for this. But if you
> choose the local variable, please make it bool instead.

I prefer variable, will switch to bool.

> > +
> > +			buscfg->bus.ccp2.lanecfg.data[0].pos =3D 1;
>=20
> Shouldn't this be vfwn.bus.mipi_csi1.data_lane ?
>=20
> > +			buscfg->bus.ccp2.lanecfg.data[0].pol =3D 0;
>=20
> And this one is vfwn.bus.mipi_csi1.lane_polarity[1] .

Thanks for catching this.

Checkpatch issues will be fixed.

								 Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAli1QBMACgkQMOfwapXb+vKWzQCeOcXCUKR45iNnRpbPEfi9h6WF
LBkAn1x3StAZJeE06zj07Lyj1S78mI/s
=R9ye
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
