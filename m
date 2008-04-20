Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1JngCl-0001oY-Hc
	for linux-dvb@linuxtv.org; Sun, 20 Apr 2008 22:32:14 +0200
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Sun, 20 Apr 2008 22:31:32 +0200
References: <200804190101.14457.dkuhlen@gmx.net>
	<200804201054.35570.dkuhlen@gmx.net>
	<854d46170804200605i711bda4ci2c2e1b78a3e1c47b@mail.gmail.com>
In-Reply-To: <854d46170804200605i711bda4ci2c2e1b78a3e1c47b@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200804202231.32999.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] Pinnacle PCTV Sat HDTV Pro USB (PCTV452e) and
	TT-Connect-S2-3600 final version (RC-keymap)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1483120155=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1483120155==
Content-Type: multipart/signed;
  boundary="nextPart3317429.D4DCas3coV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3317429.D4DCas3coV
Content-Type: multipart/mixed;
  boundary="Boundary-01=_kg6CIEISuiwAiqU"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_kg6CIEISuiwAiqU
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
>=20
> I'm using 32-bit Archlinux kernel 2.6.24.4 and my testing computer spec i=
s:
> Dell Optiplex GX620
> Pentium D 2.80GHz
> 2GB RAM, 160GB SATA2.
>=20
> thanks for "patch_add_tt_s2_3600_rc_keymap.diff" I have tested it with
> vdr remote plugin and all keys are working.

I was told that there's a bug in the rc keymap size which is fixed by the a=
ttached patch

=20
> If you are going to release another version or future update please
> add support for TT connect s2 3650 CI, its same as 3600 but with CI.
> +#define USB_PID_TECHNOTREND_CONNECT_S2_3650_CI             0x300a
attached as patch

Dominik

--Boundary-01=_kg6CIEISuiwAiqU
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="patch_add_tt_s2_3650_ci.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch_add_tt_s2_3650_ci.diff"

diff -r b25ed8c6c0e8 linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
=2D-- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Sun Apr 20 22:23:21 2=
008 +0200
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Sun Apr 20 22:28:21 200=
8 +0200
@@ -144,6 +144,7 @@
 #define USB_PID_PCTV_450E				0x0222
 #define USB_PID_PCTV_452E				0x021f
 #define USB_PID_TECHNOTREND_CONNECT_S2_3600             0x3007
+#define USB_PID_TECHNOTREND_CONNECT_S2_3650_CI          0x300a
 #define USB_PID_NEBULA_DIGITV				0x0201
 #define USB_PID_DVICO_BLUEBIRD_LGDT			0xd820
 #define USB_PID_DVICO_BLUEBIRD_LG064F_COLD		0xd500
diff -r b25ed8c6c0e8 linux/drivers/media/dvb/dvb-usb/pctv452e.c
=2D-- a/linux/drivers/media/dvb/dvb-usb/pctv452e.c	Sun Apr 20 22:23:21 2008=
 +0200
+++ b/linux/drivers/media/dvb/dvb-usb/pctv452e.c	Sun Apr 20 22:28:21 2008 +=
0200
@@ -967,6 +967,7 @@ static struct usb_device_id pctv452e_usb
 static struct usb_device_id pctv452e_usb_table[] =3D {
 	{USB_DEVICE(USB_VID_PINNACLE, USB_PID_PCTV_452E)},
 	{USB_DEVICE(USB_VID_TECHNOTREND, USB_PID_TECHNOTREND_CONNECT_S2_3600)},
+	{USB_DEVICE(USB_VID_TECHNOTREND, USB_PID_TECHNOTREND_CONNECT_S2_3650_CI)},
 	{}
 };
 MODULE_DEVICE_TABLE(usb, pctv452e_usb_table);
@@ -1077,6 +1078,10 @@ static struct dvb_usb_device_properties=20
 		  .cold_ids =3D { NULL, NULL }, // this is a warm only device
 		  .warm_ids =3D { &pctv452e_usb_table[1], NULL }
 		},
+		{ .name =3D "Technotrend TT Connect S2-3650-CI",
+		  .cold_ids =3D { NULL, NULL }, // this is a warm only device
+		  .warm_ids =3D { &pctv452e_usb_table[2], NULL }
+		},
 		{ 0 },
 	}
 };

--Boundary-01=_kg6CIEISuiwAiqU
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="patch_fix_tts2_keymap.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch_fix_tts2_keymap.diff"

diff -r 6ebc788b30f2 linux/drivers/media/dvb/dvb-usb/pctv452e.c
=2D-- a/linux/drivers/media/dvb/dvb-usb/pctv452e.c	Sun Apr 20 22:28:55 2008=
 +0200
+++ b/linux/drivers/media/dvb/dvb-usb/pctv452e.c	Sun Apr 20 22:29:13 2008 +=
0200
@@ -1038,7 +1038,7 @@ static struct dvb_usb_device_properties=20
 	.power_ctrl       =3D pctv452e_power_ctrl,
=20
 	.rc_key_map       =3D tt_connect_s2_3600_rc_key,
=2D	.rc_key_map_size  =3D ARRAY_SIZE(pctv452e_rc_keys),
+	.rc_key_map_size  =3D ARRAY_SIZE(tt_connect_s2_3600_rc_key),
 	.rc_query         =3D pctv452e_rc_query,
 	.rc_interval      =3D 100,
=20

--Boundary-01=_kg6CIEISuiwAiqU--

--nextPart3317429.D4DCas3coV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBIC6gk6OXrfqftMKIRAmgYAKCuy+bRhAheaE4LELaSFPVGodfMkACaAnUO
M7ZuPhMPwCPIqEDqtdzcsjQ=
=NPFK
-----END PGP SIGNATURE-----

--nextPart3317429.D4DCas3coV--


--===============1483120155==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1483120155==--
