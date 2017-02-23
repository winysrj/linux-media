Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36928 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdBWWww (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Feb 2017 17:52:52 -0500
Date: Thu, 23 Feb 2017 23:52:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: [PATCH 1/4] v4l2: device_register_subdev_nodes: allow calling
 multiple times
Message-ID: <20170223225234.GA6022@amd>
References: <d315073f004ce46e0198fd614398e046ffe649e7.1487111824.git.pavel@ucw.cz>
 <20170220103114.GA9800@amd>
 <20170220130912.GT16975@valkosipuli.retiisi.org.uk>
 <20170220135636.GU16975@valkosipuli.retiisi.org.uk>
 <20170221110721.GD5021@amd>
 <20170221111104.GD16975@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <20170221111104.GD16975@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

On Tue 2017-02-21 13:11:04, Sakari Ailus wrote:
> On Tue, Feb 21, 2017 at 12:07:21PM +0100, Pavel Machek wrote:
> > On Mon 2017-02-20 15:56:36, Sakari Ailus wrote:
> > > On Mon, Feb 20, 2017 at 03:09:13PM +0200, Sakari Ailus wrote:
> > > > I've tested ACPI, will test DT soon...
> > >=20
> > > DT case works, too (Nokia N9).
> >=20
> > Hmm. Good to know. Now to figure out how to get N900 case to work...
> >=20
> > AFAICT N9 has CSI2, not CSI1 support, right? Some of the core changes
> > seem to be in, so I'll need to figure out which, and will still need
> > omap3isp modifications...
>=20
> Indeed, I've only tested for CSI-2 as I have no functional CSI-1 devices.
>=20
> It's essentially the functionality in the four patches. The data-lane and
> clock-name properties have been renamed as data-lanes and clock-lanes (i.=
e.
> plural) to match the property documentation.

Ok, thanks, I got CSI-1 support to compile.

I'm now fighting with subdevices support. Camera flash and autofocus
coil really should be subdevices of the ISP, right?

Do you have any solution for that? [I need it for my userspace to
work, and porting the old one looks like lot of fun (tm) :-(].

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlivZ7IACgkQMOfwapXb+vIhMgCbBH5KqZ0eZwx5NuqBbb06TlhZ
LccAn2g346x6cEm7d9HS7tmjdSmohjtV
=B6Q8
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
