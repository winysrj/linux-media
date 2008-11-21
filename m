Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx5.loqal.no ([82.194.192.36] helo=mailsrv1.loqal.no)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bug@ohhh.no>) id 1L3bMh-0003aO-2i
	for linux-dvb@linuxtv.org; Fri, 21 Nov 2008 20:08:28 +0100
Received: from localhost (mailsrv1.loqal.no [127.0.0.1])
	by mailsrv1.loqal.no (Postfix) with ESMTP id 04138A300A7
	for <linux-dvb@linuxtv.org>; Fri, 21 Nov 2008 20:08:23 +0100 (CET)
Received: from mailsrv1.loqal.no ([127.0.0.1])
	by localhost (mailsrv1.loqal.no [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id Kvt2XN8H8Pc3 for <linux-dvb@linuxtv.org>;
	Fri, 21 Nov 2008 20:08:22 +0100 (CET)
Received: from maia.hoiseth.no (hoiseth.no [82.194.202.26])
	by mailsrv1.loqal.no (Postfix) with ESMTP id 4AE39A30097
	for <linux-dvb@linuxtv.org>; Fri, 21 Nov 2008 20:08:17 +0100 (CET)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by maia.hoiseth.no (Postfix) with ESMTP id 66CF117FC002
	for <linux-dvb@linuxtv.org>; Fri, 21 Nov 2008 20:08:17 +0100 (CET)
Received: from maia.hoiseth.no ([127.0.0.1])
	by localhost (hoiseth.no [127.0.0.1]) (amavisd-maia,
	port 10024) with ESMTP id 20081-04 for <linux-dvb@linuxtv.org>;
	Fri, 21 Nov 2008 20:08:16 +0100 (CET)
Received: from mail1.hoiseth.no (mail1.hoiseth.no [192.168.0.51])
	by maia.hoiseth.no (Postfix) with ESMTP id 4F3CC17FC001
	for <linux-dvb@linuxtv.org>; Fri, 21 Nov 2008 20:08:16 +0100 (CET)
Received: from a1 (a1.hoiseth.no [192.168.0.23])
	by mail1.hoiseth.no (Postfix) with ESMTP id 43BE87C78027
	for <linux-dvb@linuxtv.org>; Fri, 21 Nov 2008 20:08:16 +0100 (CET)
Date: Fri, 21 Nov 2008 20:08:24 +0100
From: "bug@ohhh.no" <bug@ohhh.no>
To: linux-dvb@linuxtv.org
Message-ID: <20081121200824.58af7d62@a1>
In-Reply-To: <1227271573.4090.1025.camel@alkaloid.netup.ru>
References: <1227263508.4090.1011.camel@alkaloid.netup.ru>
	<20081121120624.GY6193@titan.makhutov-it.de>
	<1227271573.4090.1025.camel@alkaloid.netup.ru>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Development of Linux driver for Dual DVB-S2-CI
 PCI-E x1 starts
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0324848545=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0324848545==
Content-Type: multipart/signed; boundary="Sig_/.3.me0aH/2z3HTLmTUBuNd_";
 protocol="application/pgp-signature"; micalg=PGP-SHA1

--Sig_/.3.me0aH/2z3HTLmTUBuNd_
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 21 Nov 2008 15:46:13 +0300
Abylai Ospan <aospan@netup.ru> wrote:

> =D0=92 =D0=9F=D1=82=D0=BD, 21/11/2008 =D0=B2 13:06 +0100, Artem Makhutov =
=D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>=20
> > Hello,
> >=20
> > On Fri, Nov 21, 2008 at 01:31:48PM +0300, Abylai Ospan wrote:
> > > Hello,
> > >=20
> > > We have designed NetUP Dual DVB-S2-CI PCI-E x1 card. A short
> > > description=20
> > > is available in wiki -
> > > http://linuxtv.org/wiki/index.php/NetUP_Dual_DVB_S2_CI
> > > Now we have started the work on the driver for Linux. The
> > > following components used in this card already have their code
> > > for Linux published:
> > > Conexant CX23885
> > > STM STV6110A
> > >=20
> > > We are working on the code for the following components:
> > > Dual demodulator STM STV0900BAB
> > > Dual LNB STM LNBH24
> > > SCM CiMax SP2
> > >=20
> > > The resulting code will be published under GPL after receiving=20
> > > permissions from IC vendors.
> >=20
> > This are really great news! I was looking for such a card for a
> > while now.
> >=20
> > Can I preorder one? ;)
>=20
> We will make some amount of this card I hope at Jan'09 - Feb'09. We
> can send one sample (free of charge) for you if you can make tests in
> linux environment :)
>=20


+1 on preorder.
Seriously tho, this I cannot wait to put into service. Looking forward
to a happy new year. =3D)

Snowy greetings from .no,
Kjetil

--Sig_/.3.me0aH/2z3HTLmTUBuNd_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkknBygACgkQXNHmkzbjdvxTTQCcCbtz0Y3cWZPpJeF8j6egrt3y
RUYAniEAb1sNgKJIKOl1ndHnB4T2bpwj
=KM0d
-----END PGP SIGNATURE-----

--Sig_/.3.me0aH/2z3HTLmTUBuNd_--


--===============0324848545==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0324848545==--
