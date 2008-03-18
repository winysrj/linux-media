Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1Jbl8e-0001u0-Lw
	for linux-dvb@linuxtv.org; Wed, 19 Mar 2008 00:22:37 +0100
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Wed, 19 Mar 2008 00:22:01 +0100
References: <47BDA96B.7080700@okg-computer.de>
	<200803161603.24956.dkuhlen@gmx.net> <47DD45FE.3030702@gmail.com>
In-Reply-To: <47DD45FE.3030702@gmail.com>
MIME-Version: 1.0
Message-Id: <200803190022.01906.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] Need Help with PCTV 452e (USB DVB-S2 device with
	STB0899)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1262753690=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1262753690==
Content-Type: multipart/signed;
  boundary="nextPart25136798.gUnZyEz57e";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart25136798.gUnZyEz57e
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,
On Sunday 16 March 2008, Manu Abraham wrote:
> Dominik Kuhlen wrote:
> > Hi,
> >=20
=2D--snip----
> > The first tuning after powerup/init fails quite often for me but the fo=
lllowings are fine
> > even switching from DVB-S to DVB-S2 works like a charm.
>=20
>=20
> Nice to know it works great. Should i pull the patch into the multiproto=
=20
> tree to
> make it easier, since it works as expected ?
That would be nice, I'll prepare a patch next days (which also includes the=
 TT-connect S2-3600 patch from Andr=E9).

And I would also like to add a sample tuning application since this seems t=
o be the most common
issue when trying to get DVB-S2 running

>=20
> Also, can you test DVB-S2, a 30MSPS stream whether it works as expected ?
> (in case you have access to such a transponder ?)
which satellite/transponder has got such a rate?=20
I can only receive 19.2E and 13.0E but both don't have high rate dvb-s2 tra=
nsponders :(

>=20
> Currently, i have mixed results, so some amount of further test results=20
> would
> be quite nice
>=20
> >> Is it really isochronous transfer that the device really uses in it's
> >> default mode ? I guess many vendors prefer bulk transfers for the
> >> default transfer mode ?
> > There's a bulk pipe but it's only used for setup/control afaik.
> >=20
> >=20
> > Happy testing,
> > Dominik
> >=20
> >=20
> > BTW: why is the mantis development in a separate HG repo?
> >  I merged the mantis driver to the multiproto repo and can use the
> >  mantis-1041 and pctv452e simultanously :)
>=20
> I do expect quite some changes to the mantis bridge and have been touching
> very much mantis/bridge specific changes in that tree. Additionally, i=20
> plan to push
> out multiproto prior to mantis, so both in one tree will make it a bit=20
> messy.
Ok, that makes sense.
=20
>=20
> Regards,
> Manu
>=20
>=20


Dominik

--nextPart25136798.gUnZyEz57e
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBH4E6Z6OXrfqftMKIRAptnAJ4u19Lwjeqx9Clqknm8eqoSkdrvQACdGW1S
BEUV7Tq1reQeYaU+6KiUck8=
=eO4+
-----END PGP SIGNATURE-----

--nextPart25136798.gUnZyEz57e--


--===============1262753690==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1262753690==--
