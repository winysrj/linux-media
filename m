Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56707 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751079AbdFPGXF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 02:23:05 -0400
Date: Fri, 16 Jun 2017 08:23:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: v4l2-fwnode: status, plans for merge, any branch to merge
 against?
Message-ID: <20170616062302.GA455@amd>
References: <20170302123848.GA28230@amd>
 <20170304130318.GU3220@valkosipuli.retiisi.org.uk>
 <20170306072323.GA23509@amd>
 <20170310225418.GJ3220@valkosipuli.retiisi.org.uk>
 <20170613122240.GA2803@amd>
 <20170613124748.GD12407@valkosipuli.retiisi.org.uk>
 <20170613210900.GA31456@amd>
 <20170614110634.GP12407@valkosipuli.retiisi.org.uk>
 <20170614194128.GA5669@amd>
 <20170615220659.GG12407@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <20170615220659.GG12407@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2017-06-16 01:07:00, Sakari Ailus wrote:
> On Wed, Jun 14, 2017 at 09:41:29PM +0200, Pavel Machek wrote:
> > diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/plat=
form/omap3isp/isp.c
> > index 4ca3fc9..b80debf 100644
> > --- a/drivers/media/platform/omap3isp/isp.c
> > +++ b/drivers/media/platform/omap3isp/isp.c
> > @@ -2026,7 +2026,7 @@ static int isp_fwnode_parse(struct device *dev, s=
truct fwnode_handle *fwnode,
> > =20
> >  	isd->bus =3D buscfg;
> > =20
> > -	ret =3D v4l2_fwnode_endpoint_parse(fwn, vep);
> > +	ret =3D v4l2_fwnode_endpoint_parse(fwnode, &vep);
> >  	if (ret)
> >  		return ret;
>=20
> I just pushed the fix there.
>=20
> Btw. I think we should probably drop the change allocating the sub-device
> configuration separately. It's better to associate the lens, flash and
> eeprom (where it exists) to the sensor than to the CSI-2 receiver. In that
> case there are no async sub-devices without bus configuration.

Actually I thought about that a bit, and am not sure about that.

CSI-2 receiver may not be good place to associate lens and flash with,
agreed.

But is sensor a good place? In particular, phones with two cameras
cooperating (for example one black&white and one color) are getting
common. It seems to be true that each sensor has a lens and autofocus
motor associated, but flash LED is common, and both sensors are
designed to work as one device.

But yes, that's still better than placing it at CSI-2 receiver. But I
guess we should make sure that flash LED can associated with more than
one sensor, and maybe we should have some kind of "camera package"
entity.

Best regards,

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllDeUYACgkQMOfwapXb+vLFkQCgpXPopzquW18X15vpmKrAlVkP
SSMAoKrFbHIuw8jgVUxiIKvullef4Eoi
=cwdS
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
