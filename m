Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1Jn9mY-0007Nu-GK
	for linux-dvb@linuxtv.org; Sat, 19 Apr 2008 11:54:55 +0200
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Sat, 19 Apr 2008 11:54:20 +0200
References: <200804190101.14457.dkuhlen@gmx.net>
In-Reply-To: <200804190101.14457.dkuhlen@gmx.net>
MIME-Version: 1.0
Message-Id: <200804191154.20445.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] Pinnacle PCTV Sat HDTV Pro USB (PCTV452e) and
	TT-Connect-S2-3600 final version
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1267257720=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1267257720==
Content-Type: multipart/signed;
  boundary="nextPart2280312.4toHAL8ca5";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2280312.4toHAL8ca5
Content-Type: multipart/mixed;
  boundary="Boundary-01=_MFcCIAXnUkbyt54"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_MFcCIAXnUkbyt54
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,
Good news for all stb0899 owners :)

On Saturday 19 April 2008, Dominik Kuhlen wrote:
> Hi,
>=20
> Here is my current version after quite a while of testing and tuning:
> I stripped the stb0899 tuning/searching algo to speed up tuning a bit
> now I have very fast and reliable locks (no failures, no errors)
>=20
The frequency reported by DVBFE_GET_PARAMS when in DVB-S2 mode is not corre=
ct.
The attached patch fixes this:
Now i can request any frequency near the center (even more than 10MHz lower=
 or higher)=20
and the reported frequency is within a few kHz of the actual center frequen=
cy.


 Dominik


--Boundary-01=_MFcCIAXnUkbyt54
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="patch_multiproto_dvbs2_frequency.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch_multiproto_dvbs2_frequency.diff"

diff -r 42a7b0fff69d linux/drivers/media/dvb/frontends/stb0899_algo.c
=2D-- a/linux/drivers/media/dvb/frontends/stb0899_algo.c	Sat Apr 19 11:27:4=
4 2008 +0200
+++ b/linux/drivers/media/dvb/frontends/stb0899_algo.c	Sat Apr 19 11:30:47 =
2008 +0200
@@ -1539,14 +1539,16 @@ enum stb0899_status stb0899_dvbs2_algo(s
=20
 		/* Store signal parameters	*/
 		offsetfreq =3D STB0899_READ_S2REG(STB0899_S2DEMOD, CRL_FREQ);
+		if (offsetfreq & 0x20000000) {
+			/* sign extension */
+			offsetfreq |=3D 0xc0000000;
+		}
+		/* use 64-bit arithmetic to avoid overflow */
+		offsetfreq =3D (s32)((s64)offsetfreq *=20
+		                  ((s64)internal->master_clk / (s64)1000000) /=20
+		                  ((s64)((1 << 30) / (s64)1000)));
=20
=2D		offsetfreq =3D offsetfreq / ((1 << 30) / 1000);
=2D		offsetfreq *=3D (internal->master_clk / 1000000);
=2D		reg =3D STB0899_READ_S2REG(STB0899_S2DEMOD, DMD_CNTRL2);
=2D		if (STB0899_GETFIELD(SPECTRUM_INVERT, reg))
=2D			offsetfreq *=3D -1;
=2D
=2D		internal->freq =3D internal->freq - offsetfreq;
+		internal->freq =3D internal->freq + offsetfreq;
 		internal->srate =3D stb0899_dvbs2_get_srate(state);
=20
 		reg =3D STB0899_READ_S2REG(STB0899_S2DEMOD, UWP_STAT2);

--Boundary-01=_MFcCIAXnUkbyt54--

--nextPart2280312.4toHAL8ca5
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBICcFM6OXrfqftMKIRApqEAJ9M831lbHiJg0Jf85AqhYeKpE9dNACfQj7I
8FSEkmkNXdVJjc1QSwEtNog=
=38AW
-----END PGP SIGNATURE-----

--nextPart2280312.4toHAL8ca5--


--===============1267257720==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1267257720==--
