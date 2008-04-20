Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1JnbeH-0003cI-Gt
	for linux-dvb@linuxtv.org; Sun, 20 Apr 2008 17:40:15 +0200
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Sun, 20 Apr 2008 17:39:35 +0200
References: <200804190101.14457.dkuhlen@gmx.net>
	<200804201054.35570.dkuhlen@gmx.net>
	<854d46170804200605i711bda4ci2c2e1b78a3e1c47b@mail.gmail.com>
In-Reply-To: <854d46170804200605i711bda4ci2c2e1b78a3e1c47b@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200804201739.35206.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] Pinnacle PCTV Sat HDTV Pro USB (PCTV452e) and
	TT-Connect-S2-3600 final version (RC-keymap)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0197804979=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0197804979==
Content-Type: multipart/signed;
  boundary="nextPart2198481.b7FqofD50K";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2198481.b7FqofD50K
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 20 April 2008, Faruk A wrote:
> >  > The second patch you posted "patch_multiproto_dvbs2_frequency.diff"
> >  > doesn't seem to work for me, it does compile fine but the problem is
> >  > loading the the driver.
> >  >
> >  > insmod stb0899.ko verbose=3D5
> >  >
> >  > insmod: error inserting 'stb0899.ko': -1 Unknown symbol in module
> >  >
> >  > Apr 19 21:22:40 archer usbcore: deregistering interface driver pctv4=
52e
> >  > Apr 19 21:22:40 archer dvb-usb: Technotrend TT Connect S2-3600
> >  > successfully deinitialized and disconnected.
> >  > Apr 19 21:22:40 archer usbcore: deregistering interface driver
> >  > dvb-usb-tt-connect-s2-3600-01.fw
> >  > Apr 19 21:22:45 archer stb0899: Unknown symbol __divdi3
> >  hmm, there might be an issue with the 64-bit arithmetic. what platform=
 are your running?
> >  I'll try to convert that back to 32-bit only.
Could you please try to change line 1547 in stb0899_algo.c to:

offsetfreq =3D ((((offsetfreq / 1024) * 1000) / (1<<7)) * (s32)(internal->m=
aster_clk/1000000)) / (s32)(1<<13);

this should use only 32bit ops and not over/underflow for the expected rang=
es ;)

>=20
> I'm using 32-bit Archlinux kernel 2.6.24.4 and my testing computer spec i=
s:
> Dell Optiplex GX620
> Pentium D 2.80GHz
> 2GB RAM, 160GB SATA2.
>=20
> thanks for "patch_add_tt_s2_3600_rc_keymap.diff" I have tested it with
> vdr remote plugin and all keys are working.
 :)
=20
> If you are going to release another version or future update please
> add support for TT connect s2 3650 CI, its same as 3600 but with CI.
> +#define USB_PID_TECHNOTREND_CONNECT_S2_3650_CI             0x300a
Ok, I'll add it.


 Dominik

--nextPart2198481.b7FqofD50K
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBIC2O36OXrfqftMKIRApp2AJ9D8U/s2i9Ys+skJqOaOVivVYdhtQCfVl0S
iElN2bUU9bvyBcidm0wlGN4=
=PjxR
-----END PGP SIGNATURE-----

--nextPart2198481.b7FqofD50K--


--===============0197804979==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0197804979==--
