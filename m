Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1JVDfr-0008VF-Oa
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 23:25:51 +0100
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Fri, 29 Feb 2008 23:25:17 +0100
References: <47BDA96B.7080700@okg-computer.de>
	<47BE095E.3040301@okg-computer.de>
	<200802221106.45303.dkuhlen@gmx.net>
In-Reply-To: <200802221106.45303.dkuhlen@gmx.net>
MIME-Version: 1.0
Message-Id: <200802292325.17473.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] Need Help with PCTV 452e (USB DVB-S2 device with
	STB0899)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1878755500=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1878755500==
Content-Type: multipart/signed;
  boundary="nextPart5507163.GJO2hi9M1U";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart5507163.GJO2hi9M1U
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 22 February 2008, Dominik Kuhlen wrote:
> Hi,
>=20
> -----snip----
> >=20
> > Great, that was the trick, now scanning and szap work fine.
> >=20
> > Thanks for that hint!
> You're welcome.
>=20
> BTW: do you receive broken streams  (symbol rate 22000 or 27500)?
> Currently I get a loss of about 1 TS packet every second or even more (wi=
th both symbol rates).
> And there is exactly one TS packet missing (I diffed a TS hexdump).
> If it were the USB controller that drops packets it would be a loss of 5 =
consecutive TS packets. (940 bytes iso frame size)

I have to correct that statement (I didn't record the whole TS):=20
The loss is exactly one USB frame (5 consecutive TS packets in this case)
which happens about every 1000 TS packets (200 USB frames)

I'll do further testings with different frame sizes the next days...

Dominik


--nextPart5507163.GJO2hi9M1U
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHyIZN6OXrfqftMKIRAkhRAJ9SgP5lXe56T/bpUbf4J7rZqBtcdACdHWAF
8dblc7skgLb8wOvCd/qTBRM=
=12v0
-----END PGP SIGNATURE-----

--nextPart5507163.GJO2hi9M1U--


--===============1878755500==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1878755500==--
