Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1K4kGo-0003sG-Nw
	for linux-dvb@linuxtv.org; Sat, 07 Jun 2008 00:18:51 +0200
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Sat, 7 Jun 2008 00:18:16 +0200
References: <484709F3.7020003@schoeller-soft.net>
	<854d46170806060249h1aec73e4s645462a123371c29@mail.gmail.com>
	<48497340.3050602@schoeller-soft.net>
In-Reply-To: <48497340.3050602@schoeller-soft.net>
MIME-Version: 1.0
Message-Id: <200806070018.16103.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] How to get a PCTV Sat HDTC Pro USB (452e) running?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0155930713=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0155930713==
Content-Type: multipart/signed;
  boundary="nextPart1286487.mi14nsrnm3";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1286487.mi14nsrnm3
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

On Friday 06 June 2008, Michael Sch=F6ller wrote:
> Well that worked! I was able to compile the drivers. :)
>=20
> And the bad news. I wasn't able to compile dvb-apps. Or to be more=20
> specific I followed the instructions for patching dvb-apps to work with=20
> multiproto. (
>=20
> http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025222.html)
>=20
> As I understand the instructions I copied the source code of scan to the =
dvb-apps/util/scan directory and applied the patch on it. After a little ex=
tra change for the includes (changed them to point to the ones of multiprot=
o). I was able to compile the hole stuff without errors. However scan alway=
s gives me an DVBFE_SET_PARAMS ioctl fail with "Invalid argument".
are you sure you have unloaded all old dvb modules?

> After some time I give up on and tried to patch szap. Well szap seems to =
be a wrong version since even used structures in the source code has differ=
ent names than the ones in the patch file. I got dvb-apps with hg from linu=
xtv.org.
>=20
> I'm really down now my hope to get this damn thing running before the fir=
st EM match is now not present. Good by HDTV quality games hello PAL...
could you please try whether the simpledvbtune application from=20
http://linuxtv.org/pipermail/linux-dvb/2008-April/025535.html
works.

=2D--snip---

> >> make[2]: Leaving directory `/usr/src/ps3-linux'
Are you running this on a PS3?=20


 Dominik


--nextPart1286487.mi14nsrnm3
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkhJt6gACgkQ6OXrfqftMKLisgCffWzAKXJH7C1pMgIBrER6VDDP
SFoAmwausrEO5de00yYu0pDwYDmqju/6
=iz4I
-----END PGP SIGNATURE-----

--nextPart1286487.mi14nsrnm3--


--===============0155930713==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0155930713==--
