Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1JnVTJ-0003qr-8O
	for linux-dvb@linuxtv.org; Sun, 20 Apr 2008 11:04:30 +0200
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Sun, 20 Apr 2008 11:03:55 +0200
References: <200804190101.14457.dkuhlen@gmx.net>
	<1208607419l.6132l.0l@manu-laptop>
In-Reply-To: <1208607419l.6132l.0l@manu-laptop>
MIME-Version: 1.0
Message-Id: <200804201103.55265.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] Re : Pinnacle PCTV Sat HDTV Pro USB (PCTV452e) and
	TT-Connect-S2-3600 final version
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1072161204=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1072161204==
Content-Type: multipart/signed;
  boundary="nextPart3637058.sHDUshAPCd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3637058.sHDUshAPCd
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,
On Saturday 19 April 2008, manu wrote:
> On 04/18/2008 07:01:14 PM, Dominik Kuhlen wrote:
> > Hi,
> >=20
> > Here is my current version after quite a while of testing and tuning:
> > I stripped the stb0899 tuning/searching algo to speed up tuning a bit
> > now I have very fast and reliable locks (no failures, no errors)
> >=20
> > I have also merged the TT-S2-3600 patch from Andr=E9. (I cannot test it
> > though.)
> >=20
>=20
> 	Hi,
> I will try it right away! BTW should I substract the 4MHz you talked=20
> about in another email when using this patch or is it already fixed by=20
> this (I did not try yet).
This should be fixed. The offset I liked you to test was to check whether m=
y investigations went in the right direction ;)
=46or DVB-S transponders I can use a frequency offset in the range from -7M=
Hz to +7MHz=20
 and still get reliable locks. The actual frequency is reported by DVBFE_GE=
T_PARAM ioctl=20
which could be used to update the frequency list automagically.

Dominik

--nextPart3637058.sHDUshAPCd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBICwb76OXrfqftMKIRAhd2AJ466ssxOgMYLGnR1HJ1Zqgm9f9DxACaAt38
W0D06DyL8zPMxpNw3FQe0XY=
=OeT3
-----END PGP SIGNATURE-----

--nextPart3637058.sHDUshAPCd--


--===============1072161204==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1072161204==--
