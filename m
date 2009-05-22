Return-path: <linux-media-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:38765 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbZEVH4A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 03:56:00 -0400
Date: Fri, 22 May 2009 17:55:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Paul Mundt <lethal@linux-sh.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH -next] v4l2: handle unregister for non-I2C builds
Message-Id: <20090522175554.19465733.sfr@canb.auug.org.au>
In-Reply-To: <20090522054847.GB14059@linux-sh.org>
References: <20090511161442.3e9d9cb9.sfr@canb.auug.org.au>
	<4A085455.5040108@oracle.com>
	<20090522054847.GB14059@linux-sh.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__22_May_2009_17_55_54_+1000_AnrYUdOEBql.yOot"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Fri__22_May_2009_17_55_54_+1000_AnrYUdOEBql.yOot
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 22 May 2009 14:48:47 +0900 Paul Mundt <lethal@linux-sh.org> wrote:
>
> On Mon, May 11, 2009 at 09:37:41AM -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> >=20
> > Build fails when CONFIG_I2C=3Dn, so handle that case in the if block:
> >=20
> > drivers/built-in.o: In function `v4l2_device_unregister':
> > (.text+0x157821): undefined reference to `i2c_unregister_device'
> >=20
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> This patch still has not been applied as far as I can tell, and builds
> are still broken as a result, almost 2 weeks after the fact.

In fact there has been no updates to the v4l-dvb tree at all since
May 11.  Mauro?

I have reverted the patch that caused the build breakage ... (commit
d5bc7940d39649210f1affac1fa32f253cc45a81 "V4L/DVB (11673): v4l2-device:
unregister i2c_clients when unregistering the v4l2_device").

[By the way, an alternative fix might be to just define
V4L2_SUBDEV_FL_IS_I2C to be zero if CONFIG_I2C and CONFIG_I2C_MODULE are
not defined (gcc should then just elide the offending code).]
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__22_May_2009_17_55_54_+1000_AnrYUdOEBql.yOot
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoWWooACgkQjjKRsyhoI8w7rgCggEWLp6hoIXkOZBbP2DPimKLP
R/AAoJRQSv0GPkbWolVv4Nn8lWIdO/VK
=GvOx
-----END PGP SIGNATURE-----

--Signature=_Fri__22_May_2009_17_55_54_+1000_AnrYUdOEBql.yOot--
