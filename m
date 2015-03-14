Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:56866 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324AbbCNL0q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2015 07:26:46 -0400
Date: Sat, 14 Mar 2015 12:27:03 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-i2c@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mike Galbraith <umgwanakikbuti@gmail.com>,
	Mike Rapoport <mike@compulab.co.il>,
	Jean Delvare <khali@linux-fr.org>
Subject: Re: rt-mutex usage in i2c
Message-ID: <20150314112703.GD970@katana>
References: <54FDA380.8030405@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mJm6k4Vb/yFcL9ZU"
Content-Disposition: inline
In-Reply-To: <54FDA380.8030405@linutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--mJm6k4Vb/yFcL9ZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sebastian,

> - i2c_transfer() has this piece:
>   2091                 if (in_atomic() || irqs_disabled()) {
>   2092                         ret =3D i2c_trylock_adapter(adap);
>=20
>   is this irqs_disabled() is what bothers me and should not be there.
>   pxa does a spin_lock_irq() which would enable interrupts on return /
>   too early.
>   mxs has a wait_for_completion() which needs irqs enabled _and_ makes
>   in_atomic() problematic, too. I have't checked other drivers but the
>   commit, that introduced it, does not explain why it is required.

I haven't really looked into it, but a quick search gave me this thread
explaining the intention of the code in question:

http://lists.lm-sensors.org/pipermail/i2c/2007-November/002268.html

Regards,

   Wolfram


--mJm6k4Vb/yFcL9ZU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVBBsHAAoJEBQN5MwUoCm2GpYP/1kjIom7QEkxMdW3Pc56Xy3+
YfHxRNJ9CH8PhtlVIhAJvoYa8TZCEzTxhVGDUy9tYNV5kJVTGS7A/7KZbOsKFyK3
crFXFIs8JMMENtSWIFrL7dDzENvp/tGG1iwIsM8wb1CLVwCLZ72nB0OOgFTVHgVk
9JTzCgtLu8XlGMvXV5rkdpba71hsPfDBg9WCr60Wvy/Dt2d3O4oB6tMkqs0H44Bt
Xz2GXNcd/gbl/TWszL8Ti44DuDtawXkX7bbYjxtF05rarj89NeFJY6Tmy4UqRozI
guA64KvqQiwpy7xWS0WxUBQpKb74bMLHXMdRpwvRHF8G4sNm9o51zNjG/xxLwpe6
61yGVdpk3xPe1jU3MhYL39xCe88BUWmQ6PnfHzMDcUI7GjNtYdMi1DfDwa6ijyWL
G4L1gVOqetS28lNOneszNDsRC9XBtjmXwnE+0FzQLAFez/bTXoA5aDlDTPo0o7GE
6B8hlEDbQxBdI0iGuNobBikPafAL/VPlcMZe36gCu2+TthkADmJBI3O++bhAX3XU
w2V1jrXkXuNdysvzI/qbkw1UZy7ZEtaJqpAqck53ff4hVmL/iBmBQqwxaIjUmBqn
XFd5vWlutkv+FP5N446/Mbcnq7dn7uCGwCPVNgy5XWL6dKExmhxUAvMgy/D2GFzW
7DgbVRyOW7VSARsq165l
=WoeY
-----END PGP SIGNATURE-----

--mJm6k4Vb/yFcL9ZU--
