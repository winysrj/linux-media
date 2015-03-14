Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:56887 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbbCNLcS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2015 07:32:18 -0400
Date: Sat, 14 Mar 2015 12:32:37 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-i2c@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mike Galbraith <umgwanakikbuti@gmail.com>,
	Mike Rapoport <mike.rapoport@gmail.com>,
	Jean Delvare <khali@linux-fr.org>
Subject: Re: rt-mutex usage in i2c
Message-ID: <20150314113237.GE970@katana>
References: <54FDA380.8030405@linutronix.de>
 <20150314112703.GD970@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="10jrOL3x2xqLmOsH"
Content-Disposition: inline
In-Reply-To: <20150314112703.GD970@katana>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--10jrOL3x2xqLmOsH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 14, 2015 at 12:27:03PM +0100, Wolfram Sang wrote:
> Hi Sebastian,
>=20
> > - i2c_transfer() has this piece:
> >   2091                 if (in_atomic() || irqs_disabled()) {
> >   2092                         ret =3D i2c_trylock_adapter(adap);
> >=20
> >   is this irqs_disabled() is what bothers me and should not be there.
> >   pxa does a spin_lock_irq() which would enable interrupts on return /
> >   too early.
> >   mxs has a wait_for_completion() which needs irqs enabled _and_ makes
> >   in_atomic() problematic, too. I have't checked other drivers but the
> >   commit, that introduced it, does not explain why it is required.
>=20
> I haven't really looked into it, but a quick search gave me this thread
> explaining the intention of the code in question:
>=20
> http://lists.lm-sensors.org/pipermail/i2c/2007-November/002268.html
>=20
> Regards,
>=20
>    Wolfram
>=20

And adding a recent mail address from Mike to cc.


--10jrOL3x2xqLmOsH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVBBxVAAoJEBQN5MwUoCm2ugsP/0cPQMJUQUxQJo5d/v0xQxeG
LjadDMopuK6ntqyFjQASpOBdzzB1mxlFyfaPhkWwKU/vQT7LpT8VTEbvFoVAUf4L
RsIJ2gekhk/NQ6WMzk/qjSps3DAXjLEPP/9gY6glKx+zNY3fjwJab8lqp472N6CE
EFDAZFmbiYjhpok8JstAXeTSdxVd9z7oaPjS8A8JvIJJj+FHaE/N+UTqzcjEg2mV
UNnQ/CErbgHwuho59t0A9xzimg/KQwkA6p0YoPcF+gUhhjRmmKU61XjYisTNuWaE
Gh6f2Rejgfw50/D6NlTOEQYCNsaII9c0yZlgvC8kPPnSqLNKfBvdc4ZWRdzetqBJ
tcMTzZNLQIZgandHgdNy4sMaWMRu4QGc/qSwDUySFrKWGhGsWkoc+mcOY/zIY/y5
qy5aKMopFZWlgG0J8dH1GHWF0s5Qap81/UVk7n9XYQHu5f9bXd0/yvy/Db+3S6J/
/oxJzVdSIYrXmTqWgr/OPuMcefV8KeJIN8tON5uRMbG6dgxIrPl9lO0bO4SEEobz
G26sVwV2HNVdPaRBw9OLqjVnc1CTgvN3FIiImlrXApOplFrzKl6m60Wqth8bJBfD
UKX7SDpImUwbOF0eHJ05rpsIkwcvx1tz77e5QgagDSvdbUzBRnHIfFGsay4GAbNc
mHTwEi905vQ7Sb+tBbdF
=TWyG
-----END PGP SIGNATURE-----

--10jrOL3x2xqLmOsH--
