Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36594 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752110AbdBULHe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 06:07:34 -0500
Date: Tue, 21 Feb 2017 12:07:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: [PATCH 1/4] v4l2: device_register_subdev_nodes: allow calling
 multiple times
Message-ID: <20170221110721.GD5021@amd>
References: <d315073f004ce46e0198fd614398e046ffe649e7.1487111824.git.pavel@ucw.cz>
 <20170220103114.GA9800@amd>
 <20170220130912.GT16975@valkosipuli.retiisi.org.uk>
 <20170220135636.GU16975@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5gxpn/Q6ypwruk0T"
Content-Disposition: inline
In-Reply-To: <20170220135636.GU16975@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--5gxpn/Q6ypwruk0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2017-02-20 15:56:36, Sakari Ailus wrote:
> On Mon, Feb 20, 2017 at 03:09:13PM +0200, Sakari Ailus wrote:
> > I've tested ACPI, will test DT soon...
>=20
> DT case works, too (Nokia N9).

Hmm. Good to know. Now to figure out how to get N900 case to work...

AFAICT N9 has CSI2, not CSI1 support, right? Some of the core changes
seem to be in, so I'll need to figure out which, and will still need
omap3isp modifications...

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--5gxpn/Q6ypwruk0T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlisH2kACgkQMOfwapXb+vK+5QCfU6T+OX+EjWnrtFidLTgvDJoY
DS8An2/Aa/CXEf7RV1+w+nWIB6dU1FVK
=C8TC
-----END PGP SIGNATURE-----

--5gxpn/Q6ypwruk0T--
