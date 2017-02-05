Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39978 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750851AbdBEVMY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 5 Feb 2017 16:12:24 -0500
Date: Sun, 5 Feb 2017 22:12:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>, mchehab@s-opensource.com
Cc: laurent.pinchart@ideasonboard.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, ivo.g.dimitrov.75@gmail.com,
        sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        galak@codeaurora.org, mchehab@osg.samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devicetree: Add video bus switch
Message-ID: <20170205211219.GA27072@amd>
References: <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
 <20161224152031.GA8420@amd>
 <20170203123508.GA10286@amd>
 <20170203130740.GB12291@valkosipuli.retiisi.org.uk>
 <20170203210610.GA18379@amd>
 <20170203213454.GD12291@valkosipuli.retiisi.org.uk>
 <20170204215610.GA9243@amd>
 <20170204223350.GF12291@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <20170204223350.GF12291@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > 9) Highly reconfigurable hardware - Julien Beraud
> >=20
> > - 44 sub-devices connected with an interconnect.
> > - As long as formats match, any sub-device could be connected to any
> > - other sub-device through a link.
> > - The result is 44 * 44 links at worst.
> > - A switch sub-device proposed as the solution to model the
> > - interconnect. The sub-devices are connected to the switch
> > - sub-devices through the hardware links that connect to the
> > - interconnect.
> > - The switch would be controlled through new IOCTLs S_ROUTING and
> > - G_ROUTING.
> > - Patches available:
> >  http://git.linuxtv.org/cgit.cgi/pinchartl/media.git/log/?h=3Dxilinx-wip
> >=20
> > but the patches are from 2005. So I guess I'll need some guidance here.=
=2E.
>=20
> Yeah, that's where it began (2015?), but right now I can only suggest to
> wait until there's more. My estimate is within next couple of weeks /
> months. But it won't be years.

Ok, week or two would be ok, couple of months is not. And all I need
is single hook in common structure.

So if g_endpoint_config hook looks sane to _you_, I suggest we simply
proceed. Now, maybe Mauro Carvalho Chehab <mchehab@s-opensource.com>
or Laurent or Julien will want a different solution, but
then... they'll have to suggest something doable now, not in couple of
months.

Does that sound like a plan?

Mauro added to cc list, so we can get some input.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAliXlTMACgkQMOfwapXb+vLTZQCggprGTWZ/5OsMhTltzu8ZF21v
WLkAn2JAtJn6Q1vTeHHnWS4tV1b0ysDb
=efDg
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
