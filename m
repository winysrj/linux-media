Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1KA2LJ-0005rg-Qj
	for linux-dvb@linuxtv.org; Sat, 21 Jun 2008 14:37:23 +0200
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Sat, 21 Jun 2008 14:36:47 +0200
References: <200805122042.43456.ajurik@quick.cz>
	<200806151147.19451.dkuhlen@gmx.net>
	<200806151920.30719.ajurik@quick.cz>
In-Reply-To: <200806151920.30719.ajurik@quick.cz>
MIME-Version: 1.0
Message-Id: <200806211436.47765.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] Re : Re : No lock possible at some DVB-S2 channels
	with TT S2-3200/linux
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0946376791=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0946376791==
Content-Type: multipart/signed;
  boundary="nextPart1294499.4bcz8Uh8XX";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1294499.4bcz8Uh8XX
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi

=2D-----snip----
> >
> > Could you please try the attached patch if this fixes the problem with
> > nominal frequency/symbolrate settings?
> >
>=20
> Many thanks, but I don't see any improvement. Minimum time after I've loc=
k is=20
> 150s.=20
Could you please check whether the reported frequency is sane:
Example: 19.2=C2=B0E 11915MHz H 27500 DVB-S2

Test1: use the nominal frequency:
 ./simpledvbtune -f 11915 -d 2
dvbfe setparams :  delsys=3D4 1315.000MHz / Rate : 27500kSPS
Status: 1b: Signal Carrier Sync Lock
SNR: 0 44 (0x2c) (4.4dB)
BER: 0 0 0 0 (0x0)
Signal: 5 170 (0x5aa) 1450 (145.0dBm)
=46rontend: if=3D1313.627 MHz

Test2: set positive offset (+3MHz):
=2E/simpledvbtune -f 11918 -d 2
dvbfe setparams :  delsys=3D4 1318.000MHz / Rate : 27500kSPS
=46rontend: if=3D1313.660 MHz
The frontend does automatically locks on the correct frequency

Test3: set negative offset (-4MHz):
=2E/simpledvbtune -f 11911 -d 2
dvbfe setparams :  delsys=3D4 1311.000MHz / Rate : 27500kSPS
=46rontend: if=3D1313.650 MHz

=46ind lower limit:
=2E/simpledvbtune -f 11896 -d 2  (does not work)
=2E/simpledvbtune -f 11897 -d 2 (works 100%)
dvbfe setparams :  delsys=3D4 1297.000MHz / Rate : 27500kSPS
=46rontend: if=3D1313.654 MHz

=46ind upper limit:
=2E/simpledvbtune -f 11930 -d 2 (does not work)
=2E/simpledvbtune -f 11929 -d 2 (works 100%)
dvbfe setparams :  delsys=3D4 1329.000MHz / Rate : 27500kSPS
=46rontend: if=3D1313.645 MHz

Which means:
 - I can specify any frequency from 11896MHz to 11929MHz and get 100% lock =
success
 - and the Frontend (actually the derotator) reports the real frequency (e.=
g. for auto correcting the channels list)

Cards I have tested so far:=20
=2D pctv452e=20
=2D mantis (Multimedia controller [0480]: Twinhan Technology Co. Ltd Mantis=
 DTV PCI Bridge Controller [Ver 1.0] [1822:4e35] (rev 01)
               Subsystem: Twinhan Technology Co. Ltd Unknown device [1822:0=
031])

Unfortunately I'm trapped behind a single-cable installation and have only =
access to 19.2=C2=B0E Highband Horizontal


Dominik


--nextPart1294499.4bcz8Uh8XX
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkhc9d8ACgkQ6OXrfqftMKIXswCgu5vV3XLbch91jfKnivSkSDWP
PxQAoLvnj4uhufgRLtoj7aZjAlhqdy/X
=SBX2
-----END PGP SIGNATURE-----

--nextPart1294499.4bcz8Uh8XX--


--===============0946376791==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0946376791==--
