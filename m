Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45224 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753394AbdCBO6h (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 09:58:37 -0500
Date: Thu, 2 Mar 2017 15:58:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: subdevice config into pointer (was Re: [PATCH 1/4] v4l2:
 device_register_subdev_nodes: allow calling multiple times)
Message-ID: <20170302145808.GA3315@amd>
References: <d315073f004ce46e0198fd614398e046ffe649e7.1487111824.git.pavel@ucw.cz>
 <20170220103114.GA9800@amd>
 <20170220130912.GT16975@valkosipuli.retiisi.org.uk>
 <20170220135636.GU16975@valkosipuli.retiisi.org.uk>
 <20170221110721.GD5021@amd>
 <20170221111104.GD16975@valkosipuli.retiisi.org.uk>
 <20170225000918.GB23662@amd>
 <20170225134444.6qzumpvasaow5qoj@ihha.localdomain>
 <20170302090727.GC27818@amd>
 <20170302141617.GG3220@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <20170302141617.GG3220@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > Making the sub-device bus configuration a pointer should be in a sepa=
rate
> > > patch. It makes sense since the entire configuration is not valid for=
 all
> > > sub-devices attached to the ISP anymore. I think it originally was a
> > > separate patch, but they probably have been merged at some point. I c=
an't
> > > find it right now anyway.
> >=20
> > Something like this?
> >=20
> > commit df9141c66678b549fac9d143bd55ed0b242cf36e
> > Author: Pavel <pavel@ucw.cz>
> > Date:   Wed Mar 1 13:27:56 2017 +0100
> >=20
> >     Turn bus in struct isp_async_subdev into pointer; some of our subde=
vs
> >     (flash, focus) will not need bus configuration.
> >=20
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
>=20
> I applied this to the ccp2 branch with an improved patch
> description.

Thanks!

[But the important part is to get subdevices to work on ccp2 based
branch, and it still fails to work at all if I attempt to enable
them. I'd like to understand why...]

									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAli4MwAACgkQMOfwapXb+vI4+gCgmbNcYbc+sxjig/qgYREeqS2n
ubcAoIajUGPTxlYyO/N/JBMEoAMk6jvh
=UV2m
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
