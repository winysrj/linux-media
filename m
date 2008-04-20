Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1Jnfx0-00009e-FR
	for linux-dvb@linuxtv.org; Sun, 20 Apr 2008 22:15:51 +0200
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Sun, 20 Apr 2008 22:15:14 +0200
References: <200804190101.14457.dkuhlen@gmx.net>
	<200804201739.35206.dkuhlen@gmx.net>
	<854d46170804201248k70b14c99k5aba1fa8079b4649@mail.gmail.com>
In-Reply-To: <854d46170804201248k70b14c99k5aba1fa8079b4649@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200804202215.14234.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] Pinnacle PCTV Sat HDTV Pro USB (PCTV452e) and
	TT-Connect-S2-3600 final version (RC-keymap)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1040186692=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1040186692==
Content-Type: multipart/signed;
  boundary="nextPart6478662.utXirOr74R";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart6478662.utXirOr74R
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 20 April 2008, Faruk A wrote:
> >  Could you please try to change line 1547 in stb0899_algo.c to:
> >
> >  offsetfreq =3D ((((offsetfreq / 1024) * 1000) / (1<<7)) * (s32)(intern=
al->master_clk/1000000)) / (s32)(1<<13);
> >
> >  this should use only 32bit ops and not over/underflow for the expected=
 ranges ;)
> >
> >
> >   Dominik
>=20
> It works, with this new changes i had no problem loading the drivers.
>=20
> One more thing i did some testing with vdr and dvbs2 it looks like it
> locks in exactly after 1 minute
> but no video or audio vdr just displays no signal. I don't know if is
> the vdrs fault or the drivers
> anyway i have attached a small log. (no attachment rejected by
> moderator, I've sent copy of this mail to Dominik with attachment.
> Tried pastebin too didn't help)
Hmm, i have received your log file (its 3MB, you could try to bzip2 it befo=
re attaching.
usually log files compress well)
The log starts at 19:51:19 with opening the device.
but it looks like delivery system is set to DVB-S not DVB-S2
frequency and symbolrate would match the astra-hd channel (1314MHz and 2750=
0kSym/s).
then at 19:52:20 the frontend parameter were changed to 1479MHz and 24500kS=
ym/s
not sure what triggered the retuning.=20
after 5 seconds the FE locks, which is surprising since the symbolrate is n=
ot correct.

>=20
> The dvb-s2 channel is ASTRA HD+ on ASTRA 19E
> vdr version is 1.6.0 with Reinhard Nissl's DVB-S2 + H.264 patch
hmm, I'm not familiar with vdr but afaik this should be ok.

Dominik

--nextPart6478662.utXirOr74R
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBIC6RS6OXrfqftMKIRAp3kAJ9EEIWYjds+koLEO5expcGi6SdC0wCeMSYA
3V8jbnYmNpaZLODQxP3BTaY=
=byCH
-----END PGP SIGNATURE-----

--nextPart6478662.utXirOr74R--


--===============1040186692==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1040186692==--
