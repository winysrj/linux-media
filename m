Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1K4M4Q-0005hV-S9
	for linux-dvb@linuxtv.org; Thu, 05 Jun 2008 22:28:27 +0200
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Thu, 5 Jun 2008 22:27:52 +0200
References: <484709F3.7020003@schoeller-soft.net>
	<854d46170806041505w69a0bebakfa997223cade4381@mail.gmail.com>
	<484794C8.5090506@okg-computer.de>
In-Reply-To: <484794C8.5090506@okg-computer.de>
MIME-Version: 1.0
Message-Id: <200806052227.52847.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] How to get a PCTV Sat HDTC Pro USB (452e) running?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1117822660=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1117822660==
Content-Type: multipart/signed;
  boundary="nextPart1678304.2FNpoEs3ZI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1678304.2FNpoEs3ZI
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,
On Thursday 05 June 2008, Jens Krehbiel-Gr=E4ther wrote:
> Hi Michael!
>=20
> Because of the several patches needed to add support for the=20
> pctv_452e/tt_s2_3600/tt_s2_3650_ci I made a new diff on todays hg tree=20
> with all the patches applied (I think all the patches were posted by=20
> Dominik Kuhlen??).
> I will try to update the wiki in the next days.
>=20
> Couldn't these patches be inserted into hg-tree (Manu??). The device=20
> works with them (i am using it a few months now).
>=20
> I applied ONE patch wich includes all the patches listed here:
> patch_multiproto_pctv452e_tts23600.diff
> patch_multiproto_dvbs2_frequency.diff
> patch_fix_tts2_keymap.diff
> patch_add_tt_s2_3650_ci.diff
> patch_add_tt_s2_3600_rc_keymap.diff
>=20
=2D----snip----
I had just a brief look at the patch and it seems that pctv452e.c and lnb22=
=2E* are missing
afaik hg diff  does not include added files if not specified explicitly.


Dominik
=20



--nextPart1678304.2FNpoEs3ZI
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkhITEgACgkQ6OXrfqftMKI0igCfZymT8drB+fTMz6ygERICIfdr
l2AAnjLOsKAYBGJ/+yfCS1RWHpAgj13z
=+N4x
-----END PGP SIGNATURE-----

--nextPart1678304.2FNpoEs3ZI--


--===============1117822660==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1117822660==--
