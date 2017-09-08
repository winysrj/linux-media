Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40227 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752858AbdIHM2m (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 08:28:42 -0400
Date: Fri, 8 Sep 2017 14:28:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, laurent.pinchart@ideasonboard.com,
        devicetree@vger.kernel.org, sre@kernel.org
Subject: Re: [PATCH v7 11/18] v4l: async: Register sub-devices before calling
 bound callback
Message-ID: <20170908122840.GL18365@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="I4VOKWutKNZEOIPu"
Content-Disposition: inline
In-Reply-To: <20170903201805.31998-1-sakari.ailus@linux.intel.com>
 <20170903174958.27058-18-sakari.ailus@linux.intel.com>
 <4900fc41-1b57-deb6-2041-26a6333f2033@xs4all.nl>
 <20170903174958.27058-17-sakari.ailus@linux.intel.com>
 <3921fde8-6192-87d7-9c5d-5dd2035a9565@xs4all.nl>
 <20170904163400.z26qmxuejhgdcmrw@valkosipuli.retiisi.org.uk>
 <0bb75f81-cc81-a4bf-f2af-41862c1d777a@xs4all.nl>
 <20170903174958.27058-16-sakari.ailus@linux.intel.com>
 <20170904162925.hxtzy5jagv5ylq4c@valkosipuli.retiisi.org.uk>
 <96371574-0205-fd0e-452e-d001695bd69e@xs4all.nl>
 <20170903174958.27058-15-sakari.ailus@linux.intel.com>
 <20170904162705.thujzc7xw6hgjau3@valkosipuli.retiisi.org.uk>
 <9a68a9a6-0949-f1c2-f029-8045d7d688b0@xs4all.nl>
 <20170903174958.27058-14-sakari.ailus@linux.intel.com>
 <31d63a76-adab-2a04-12dc-4717b1512eaa@linux.intel.com>
 <6ad1c25a-e2a7-b73f-4d7c-6a5c071e6366@xs4all.nl>
 <20170904164201.7rycyycvrukiusjz@valkosipuli.retiisi.org.uk>
 <60db0a4b-0560-9591-f41f-1d055a50ba12@xs4all.nl>
 <20170903174958.27058-13-sakari.ailus@linux.intel.com>
 <20170903174958.27058-12-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--I4VOKWutKNZEOIPu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun 2017-09-03 20:49:51, Sakari Ailus wrote:
> Register the sub-device before calling the notifier's bound callback.
> Doing this the other way around is problematic as the struct v4l2_device
> has not assigned for the sub-device yet and may be required by the bound
> callback.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Pavel Machek <pavel@ucw.cz>


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--I4VOKWutKNZEOIPu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmyjPgACgkQMOfwapXb+vIU7QCePl5cQWXsl+r5gT5D11yR2Zf4
rS8AnAjJkMAIdUkaudTEa+Bjt/zMdFPo
=gAI5
-----END PGP SIGNATURE-----

--I4VOKWutKNZEOIPu--
