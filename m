Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1JSUoJ-0000e0-JD
	for linux-dvb@linuxtv.org; Fri, 22 Feb 2008 11:07:19 +0100
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Fri, 22 Feb 2008 11:06:45 +0100
References: <47BDA96B.7080700@okg-computer.de>
	<200802212208.05930.dkuhlen@gmx.net>
	<47BE095E.3040301@okg-computer.de>
In-Reply-To: <47BE095E.3040301@okg-computer.de>
MIME-Version: 1.0
Message-Id: <200802221106.45303.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] Need Help with PCTV 452e (USB DVB-S2 device with
	STB0899)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0617494844=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0617494844==
Content-Type: multipart/signed;
  boundary="nextPart11806805.eQc8TNraZs";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart11806805.eQc8TNraZs
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

=2D----snip----
>=20
> Great, that was the trick, now scanning and szap work fine.
>=20
> Thanks for that hint!
You're welcome.

BTW: do you receive broken streams  (symbol rate 22000 or 27500)?
Currently I get a loss of about 1 TS packet every second or even more (with=
 both symbol rates).
And there is exactly one TS packet missing (I diffed a TS hexdump).
If it were the USB controller that drops packets it would be a loss of 5 co=
nsecutive TS packets. (940 bytes iso frame size)

Thanks for testing,
 Dominik

--nextPart11806805.eQc8TNraZs
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHvp616OXrfqftMKIRAm3qAKCO/DzxZzSAyGCKL4XvlxfYnRYvewCfWrC5
Ly58Rmnhgt20/zNXgnvLtKU=
=rYWT
-----END PGP SIGNATURE-----

--nextPart11806805.eQc8TNraZs--


--===============0617494844==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0617494844==--
