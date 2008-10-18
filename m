Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1KrDWY-0006yT-VN
	for linux-dvb@linuxtv.org; Sat, 18 Oct 2008 17:15:29 +0200
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Sat, 18 Oct 2008 17:14:52 +0200
References: <200810181405.42620.dkuhlen@gmx.net>
	<854d46170810180708l5d109c9chdd97399f2f3c60e0@mail.gmail.com>
In-Reply-To: <854d46170810180708l5d109c9chdd97399f2f3c60e0@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200810181714.52505.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] S2API pctv452e stb0899 simples2apitune
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1289308782=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1289308782==
Content-Type: multipart/signed;
  boundary="nextPart1857197.IaTemJC7mW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1857197.IaTemJC7mW
Content-Type: multipart/mixed;
  boundary="Boundary-01=_s1f+I0lsVowmxCo"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_s1f+I0lsVowmxCo
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,
On Saturday 18 October 2008, Faruk A wrote:
> Hi Dominik!
>=20
>=20
> > - fast and always lock for DVB-S (up to 8MHz frequency offset allowed) =
(only tested with symrates: 22 and 27.5)
>=20
> yes channel lock is very fast and it always locks, i had no problem
> locking on DVB-S with 30000 symrate.
>=20
> > - DVB-S2 checked 19.2E 11915 H 27500 only (I cant test others)
>=20
> it locks fine on 13E DVB-S2 channels (27500)
>=20
> > - PCTV452e LED  green: FE open    orange: FE closed
> >  does the TT S2 3600 (3650CI) also have this led and is it attached to =
the same GPIO?
>=20
> The LED is working on TT-S2-3650CI
>=20
> > also attached simples2apitune which is same as simpledvbtune but for S2=
API
>=20
> simples2apitune is not working for me on both DVB-S and DVB-S2.
Oh yes, I haven't set the return value...
please find attached a new version which has that issue fixed

>=20
> [faruk@archer simples2apitune]$ ./simples2apitune -f 10975 -p h -s 27500
> using '/dev/dvb/adapter0/frontend0' as frontend
> frontend fd=3D3: type=3D0 name=3DSTB0899 Multistandard
> ioclt: FE_SET_VOLTAGE : 1
> Low band
> set tone: 0
> set symbol rate: 27500000 Sym/s
> set frequency: 1225000 kHz
> do tune....
> tuning qpsk failed
yes, the return value of set_qpsk_channel() is random :(

>=20
> Dominik are you too facing packet losses from TS?
Not in the streams i have tested so far.
how often and on which channels do you get errors?
what is the SNR for them?
>=20
> Thanks
> Faruk
>=20

Thanks for the feedback,
 Dominik

--Boundary-01=_s1f+I0lsVowmxCo
Content-Type: application/x-bzip2;
  name="simples2apitune.c.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="simples2apitune.c.bz2"

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

--Boundary-01=_s1f+I0lsVowmxCo--

--nextPart1857197.IaTemJC7mW
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkj5/WwACgkQ6OXrfqftMKIF6gCgvzmnJyNtGmlLVFU0tm9XX6/3
G6wAoMFieKU9p2RmAY8A3ka3JQJTiN1J
=7wfv
-----END PGP SIGNATURE-----

--nextPart1857197.IaTemJC7mW--


--===============1289308782==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1289308782==--
