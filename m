Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52823 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750909AbdIPHSY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Sep 2017 03:18:24 -0400
Date: Sat, 16 Sep 2017 09:18:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        devicetree@vger.kernel.org, sre@kernel.org
Subject: Re: [PATCH v13 06/25] omap3isp: Use generic parser for parsing
 fwnode endpoints
Message-ID: <20170916071820.GA9432@amd>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
 <20170915141724.23124-7-sakari.ailus@linux.intel.com>
 <20170916070431.GA8257@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <20170916070431.GA8257@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat 2017-09-16 09:04:31, Pavel Machek wrote:
> Hi!
>=20
> > Instead of using driver implementation, use
> > v4l2_async_notifier_parse_fwnode_endpoints() to parse the fwnode endpoi=
nts
> > of the device.
> >=20
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>=20
> Patches at least up to here look fine o me.

I went through some others.

So, 2,4,5,6,10,12:

Acked-by: Pavel Machek <pavel@ucw.cz>

Best regards,


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlm80DwACgkQMOfwapXb+vJNVwCgpFTjiBBLG/0oK+qEbk/8ptR6
WqoAnRSgCqcVZ4uoXDiiWtGehRtaAINt
=o9qu
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
