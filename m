Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1JSIem-000130-B5
	for linux-dvb@linuxtv.org; Thu, 21 Feb 2008 22:08:40 +0100
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Thu, 21 Feb 2008 22:08:05 +0100
References: <47BDA96B.7080700@okg-computer.de>
In-Reply-To: <47BDA96B.7080700@okg-computer.de>
MIME-Version: 1.0
Message-Id: <200802212208.05930.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] Need Help with PCTV 452e (USB DVB-S2 device with
	STB0899)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1288228823=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1288228823==
Content-Type: multipart/signed;
  boundary="nextPart2636790.8bmWUG12AU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2636790.8bmWUG12AU
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 21 February 2008, Jens Krehbiel-Gr=E4ther wrote:
> Hi!
>=20
> After two defective devices I got now a working one from pinnacle=20
> support (I tested it in Windows and it works fine).
>=20
> But under Linux I could not get a positive scan or channel-lock. Could=20
> please anyone tell me what I am doing wrong? I read the list and=20
> searched the list archive and did everything described here, but my=20
> device isn't working.
>=20
> I followed the instructions of the wiki about this device:
>=20
> hg clone http://www.jusst.de/hg/multiproto
> wget -O pctv452e.patch http://www.linuxtv.org/pipermail/linux-dvb/attachm=
ents/20080125/b9e1d749/attachment-0001.patch
> cd multiproto
> patch -p1 < ../pctv452e.patch
Hmm, I discovered that there's in an issue in pctv452e.c line 426 which sho=
uld be:
  { STB0899_I2CRPT        , 0x58 },
In the patch there's 0x5c as value which doesn't work for me.

Could you please try this and report if it works for you too.

Dominik

--nextPart2636790.8bmWUG12AU
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHveg16OXrfqftMKIRAsPVAJ0aG2mFZoKVRsrM6z0FgT2ANI+04wCglQNS
cUdRpDm02XCEJUmox5aXOPI=
=O7Ct
-----END PGP SIGNATURE-----

--nextPart2636790.8bmWUG12AU--


--===============1288228823==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1288228823==--
