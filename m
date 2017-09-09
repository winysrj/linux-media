Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49533 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751134AbdIIJeP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Sep 2017 05:34:15 -0400
Date: Sat, 9 Sep 2017 11:34:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        sre@kernel.org
Subject: Re: [PATCH v9 00/23] Unified fwnode endpoint parser, async
 sub-device notifier support, N9 flash DTS
Message-ID: <20170909093413.GN27428@amd>
References: <20170908131235.30294-1-sakari.ailus@linux.intel.com>
 <20170908132507.nqofkw2g43m7ydux@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oIlomvtVtXAVxSKT"
Content-Disposition: inline
In-Reply-To: <20170908132507.nqofkw2g43m7ydux@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--oIlomvtVtXAVxSKT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2017-09-08 16:25:07, Sakari Ailus wrote:
> On Fri, Sep 08, 2017 at 04:11:51PM +0300, Sakari Ailus wrote:
> > With this, the as3645a driver successfully registers a sub-device to the
> > media device created by the omap3isp driver. The kernel also has the
> > information it's related to the sensor driven by the smiapp driver but =
we
> > don't have a way to expose that information yet.
>=20
> The patches are also available here:
>=20
> <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=3Dfwnode-parse>

I merged the series on top of v4.14-rc0, and it does not break
anything. So:

Tested-by: Pavel Machek <pavel@ucw.cz>

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--oIlomvtVtXAVxSKT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmztZUACgkQMOfwapXb+vJ5ZQCbB+Kd6+IE3UvHH0N7OsXocWzr
z6oAn0mbhHs4hFc/5Nc/3drIARmxU04A
=F+zo
-----END PGP SIGNATURE-----

--oIlomvtVtXAVxSKT--
