Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56526 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab0CVIzS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 04:55:18 -0400
Date: Mon, 22 Mar 2010 09:54:29 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Greg KH <gregkh@suse.de>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Mike Isely <isely@pobox.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sujith Thomas <sujith.thomas@intel.com>,
	Matthew Garrett <mjg@redhat.com>, linuxppc-dev@ozlabs.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] device_attributes: add sysfs_attr_init() for dynamic
	attributes
Message-ID: <20100322085429.GA15063@pengutronix.de>
References: <1269238878-991-1-git-send-email-w.sang@pengutronix.de> <20100322064027.GG31621@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <20100322064027.GG31621@core.coreip.homeip.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 21, 2010 at 11:40:28PM -0700, Dmitry Torokhov wrote:

> My standard question - are all of these need to be dynamically
> allocated?

I have my doubts for a few of them. Still, this would be a more intrusive
change than just fixing the BUG appearance, so I'd like to leave that task =
for
those having the proper setup. Regarding thermal_sys.c, which has two bug
reports already, it needs to be dynamic as the attribute name depends on the
device.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkunMEUACgkQD27XaX1/VRsGjQCgteCT6utOHw1aT5jKNRJnqWa2
uqIAn0gXBpowL23wFc6gSgABp3M5T/oZ
=eDuH
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
