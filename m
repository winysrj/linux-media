Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2a.orange.fr ([80.12.242.140])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <david.bercot@wanadoo.fr>) id 1JR8lU-0002ao-5l
	for linux-dvb@linuxtv.org; Mon, 18 Feb 2008 17:22:48 +0100
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2a17.orange.fr (SMTP Server) with ESMTP id 42AC6700009E
	for <linux-dvb@linuxtv.org>; Mon, 18 Feb 2008 17:22:12 +0100 (CET)
Received: from localhost (ANantes-252-1-77-76.w86-195.abo.wanadoo.fr
	[86.195.216.76])
	by mwinf2a17.orange.fr (SMTP Server) with ESMTP id 3399A700009C
	for <linux-dvb@linuxtv.org>; Mon, 18 Feb 2008 17:22:10 +0100 (CET)
Date: Mon, 18 Feb 2008 17:22:00 +0100
From: David BERCOT <david.bercot@wanadoo.fr>
Cc: linux-dvb@linuxtv.org
Message-ID: <20080218172200.64004443@wanadoo.fr>
In-Reply-To: <20080218142116.GA4462@moelleritberatung.de>
References: <20080218135027.2b6a10e7@wanadoo.fr>
	<20080218142116.GA4462@moelleritberatung.de>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Error compiling multiproto
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1674162547=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1674162547==
Content-Type: multipart/signed; boundary="Sig_/ml=cIEMKe7=Y6KuAPsewepm";
 protocol="application/pgp-signature"; micalg=PGP-SHA1

--Sig_/ml=cIEMKe7=Y6KuAPsewepm
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Mon, 18 Feb 2008 15:21:16 +0100,
Artem Makhutov <artem@makhutov.org> a =C3=A9crit :
> Hi,
>=20
> On Mon, Feb 18, 2008 at 01:50:27PM +0100, David BERCOT wrote:
> > Hi,
> >=20
> > After a clean install, I try to compile multiproto. But, after the
> > "make", I have this error :
> > In file included from /opt/dvb/multiproto/v4l/em28xx-audio.c:39:
> > include/sound/core.h:281: error: 'SNDRV_CARDS' undeclared here (not
> > in a function) /opt/dvb/multiproto/v4l/em28xx-audio.c:58: error:
> > array index in initializer not of integer
> > type /opt/dvb/multiproto/v4l/em28xx-audio.c:58: error: (near
> > initialization for 'index') make[3]: ***
> > [/opt/dvb/multiproto/v4l/em28xx-audio.o] Error 1 make[2]: ***
> > [_module_/opt/dvb/multiproto/v4l] Error 2 make[2]: Leaving directory
> > `/usr/src/linux-headers-2.6.24-1-amd64' make[1]: *** [default]
> > Erreur 2 make[1]: quittant le r=C3=A9pertoire =C2=AB /opt/dvb/multiprot=
o/v4l
> > =C2=BB make: *** [all] Erreur 2
>=20
> You have to apply this patch to be able to compile multiproto under a
> 2.6.24 kernel:
>=20
> http://linuxtv.org/hg/v4l-dvb/rev/b0815101889d
>=20
> Patch download link:
>=20
> http://linuxtv.org/hg/v4l-dvb/raw-diff/b0815101889d/v4l/compat.h
>=20
> Regards, Artem

OK. Simple ;-)

I have not seen this information :-(

Thank you very much.

David.

--Sig_/ml=cIEMKe7=Y6KuAPsewepm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHubCvvSnthbGI8ygRAraWAKCoQz6KKkvMPYI+0cS8PxmIekNqnQCeIEOt
aArSzvMcGGHafhL7dvV6GLE=
=j0Wf
-----END PGP SIGNATURE-----

--Sig_/ml=cIEMKe7=Y6KuAPsewepm--



--===============1674162547==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1674162547==--
