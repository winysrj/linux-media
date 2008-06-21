Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1KA69T-00089R-CZ
	for linux-dvb@linuxtv.org; Sat, 21 Jun 2008 18:41:28 +0200
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Sat, 21 Jun 2008 18:40:46 +0200
References: <200805122042.43456.ajurik@quick.cz>
	<200806211436.47765.dkuhlen@gmx.net>
	<200806211552.41278.ajurik@quick.cz>
In-Reply-To: <200806211552.41278.ajurik@quick.cz>
MIME-Version: 1.0
Message-Id: <200806211840.47025.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] Re : Re : No lock possible at some DVB-S2 channels
	with TT S2-3200/linux
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0505836518=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0505836518==
Content-Type: multipart/signed;
  boundary="nextPart6504008.281Js3FRkn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart6504008.281Js3FRkn
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

I managed to get access to a 19.2 + 13.0 diseqc dish with a TT-S2 3600 card=
 :)

On Saturday 21 June 2008, Ales Jurik wrote:
> Hi,
>=20
> on the frequency you've mentioned I didn't have any problem (never). But =
at=20
> lyngsat it is reported as 11914MHz. I never used freq. shifting (only=20
> tested), it was not reasonable for me.
I wanted to show that there's no reason for setting all frequencies +4Mhz o=
r -4MHz.
This is what my patch is all about :)
The request for test tuning with a offset was to confirm the "bug" i found=
=20
in the stb0899 tuning routine

>=20
> Problems I have are at transponders with 8PSK modulation.=20
Well, I tested:=20
19.2 12522 V 8PSK 22000 2/3
  i get 100% (and immediate) lock in the range from: 12512 to 12532
(The frontend always reports 1921MHz (i.e. 12521MHz))
the call looks like:
=2E/simpledvbtune -f 12512 -p v -s 22000 -d 2  -a 1
using '/dev/dvb/adapter1/frontend0' as frontend
frontend fd=3D3: type=3D0
ioclt: FE_SET_VOLTAGE : 0
High band
tone: 1
dvbfe setparams :  delsys=3D4 1912.000MHz / Rate : 22000kSPS
Status: 1b: Signal Carrier Sync Lock
SNR: 0 22 (0x16) (2.2dB)
BER: 0 0 0 0 (0x0)
Signal: 5 170 (0x5aa) 1450 (145.0dBm)
=46rontend: if=3D1921.821 MHz

19.2 12581 V 8PSK 22000 2/3
 works  in the range from 12570 to 12590
frontend reports: 1980 (i.e.12580)

13.0 11996 V 8PSK 27500 2/3
 works from 11986 to 12005
frontend reports: 1395 (i.e. 11995)


The other 13.0 8PSK (11278V and 11449H) are tougher:  they take a few secon=
ds to lock and sometimes they don't lock at all
according to the NIT they use roll-off factor 0.2 (the other channels use 0=
=2E35)
This is interesting: I'll check why this takes so much longer


=2D--snip---


Dominik

--nextPart6504008.281Js3FRkn
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkhdLw8ACgkQ6OXrfqftMKKO+gCgpcx2n02iuuLz8WFltJ9SqpKk
C7UAnj2SoyOvkdg0Hb1otY79MKO7IarZ
=rCoH
-----END PGP SIGNATURE-----

--nextPart6504008.281Js3FRkn--


--===============0505836518==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0505836518==--
