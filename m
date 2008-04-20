Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1JnVKJ-0002aO-Su
	for linux-dvb@linuxtv.org; Sun, 20 Apr 2008 10:55:13 +0200
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Sun, 20 Apr 2008 10:54:35 +0200
References: <200804190101.14457.dkuhlen@gmx.net>
	<200804191154.20445.dkuhlen@gmx.net>
	<854d46170804191245m6015dbdpe8b244aa1c884153@mail.gmail.com>
In-Reply-To: <854d46170804191245m6015dbdpe8b244aa1c884153@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200804201054.35570.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] Pinnacle PCTV Sat HDTV Pro USB (PCTV452e) and
	TT-Connect-S2-3600 final version (RC-keymap)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1943437714=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1943437714==
Content-Type: multipart/signed;
  boundary="nextPart3470653.Of5xUiP5Wl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3470653.Of5xUiP5Wl
Content-Type: multipart/mixed;
  boundary="Boundary-01=_LTwCIF0gASDzUou"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_LTwCIF0gASDzUou
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,
On Saturday 19 April 2008, Faruk A wrote:
> 2008/4/19 Dominik Kuhlen <dkuhlen@gmx.net>:
> > Hi,
=2D--snip---
>=20
> First of all thanks for the latest drivers.
> I'm using  Technotrend TT Connect S2-3650 CI this new drivers works
> well with vdr, no problem locking and tunning to any dvbs channels. As
> for dvbs2 doesn't seem to work with vdr but i have no problem locking
> it with szap.
Nice to hear that :)
>=20
> The second patch you posted "patch_multiproto_dvbs2_frequency.diff"
> doesn't seem to work for me, it does compile fine but the problem is
> loading the the driver.
>=20
> insmod stb0899.ko verbose=3D5
>=20
> insmod: error inserting 'stb0899.ko': -1 Unknown symbol in module
>=20
> Apr 19 21:22:40 archer usbcore: deregistering interface driver pctv452e
> Apr 19 21:22:40 archer dvb-usb: Technotrend TT Connect S2-3600
> successfully deinitialized and disconnected.
> Apr 19 21:22:40 archer usbcore: deregistering interface driver
> dvb-usb-tt-connect-s2-3600-01.fw
> Apr 19 21:22:45 archer stb0899: Unknown symbol __divdi3
hmm, there might be an issue with the 64-bit arithmetic. what platform are =
your running?
I'll try to convert that back to 32-bit only.
=2D--snip---
> .........................................................................=
=2E....................
> One last thing how come you didn't include this part in your latest patch=
 ?
> +/* Remote Control Stuff fo S2-3600 (copied from TT-S1500): */
You're right, I had used an old patch which didn't contain the key-table.
I have attached an update.

Dominik

--Boundary-01=_LTwCIF0gASDzUou
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="patch_add_tt_s2_3600_rc_keymap.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch_add_tt_s2_3600_rc_keymap.diff"

diff -r 2dc3054e8bee linux/drivers/media/dvb/dvb-usb/pctv452e.c
=2D-- a/linux/drivers/media/dvb/dvb-usb/pctv452e.c	Sun Apr 20 10:45:39 2008=
 +0200
+++ b/linux/drivers/media/dvb/dvb-usb/pctv452e.c	Sun Apr 20 10:47:41 2008 +=
0200
@@ -305,6 +305,53 @@ static struct dvb_usb_rc_key pctv452e_rc
 	{0x07, 0x3c, KEY_STOP},
 	{0x07, 0x3f, KEY_HELP}
 };
+
+
+
+/* Remote Control Stuff fo S2-3600 (copied from TT-S1500): */
+static struct dvb_usb_rc_key tt_connect_s2_3600_rc_key[] =3D {
+        {0x15, 0x01, KEY_POWER},
+        {0x15, 0x02, KEY_SHUFFLE}, /* ? double-arrow key */
+        {0x15, 0x03, KEY_1},
+        {0x15, 0x04, KEY_2},
+        {0x15, 0x05, KEY_3},
+        {0x15, 0x06, KEY_4},
+        {0x15, 0x07, KEY_5},
+        {0x15, 0x08, KEY_6},
+        {0x15, 0x09, KEY_7},
+        {0x15, 0x0a, KEY_8},
+        {0x15, 0x0b, KEY_9},
+        {0x15, 0x0c, KEY_0},
+        {0x15, 0x0d, KEY_UP},
+        {0x15, 0x0e, KEY_LEFT},
+        {0x15, 0x0f, KEY_OK},
+        {0x15, 0x10, KEY_RIGHT},
+        {0x15, 0x11, KEY_DOWN},
+        {0x15, 0x12, KEY_INFO},
+        {0x15, 0x13, KEY_EXIT},
+        {0x15, 0x14, KEY_RED},
+        {0x15, 0x15, KEY_GREEN},
+        {0x15, 0x16, KEY_YELLOW},
+        {0x15, 0x17, KEY_BLUE},
+        {0x15, 0x18, KEY_MUTE},
+        {0x15, 0x19, KEY_TEXT},
+        {0x15, 0x1a, KEY_MODE},  /* ? TV/Radio */
+        {0x15, 0x21, KEY_OPTION},
+        {0x15, 0x22, KEY_EPG},
+        {0x15, 0x23, KEY_CHANNELUP},
+        {0x15, 0x24, KEY_CHANNELDOWN},
+        {0x15, 0x25, KEY_VOLUMEUP},
+        {0x15, 0x26, KEY_VOLUMEDOWN},
+        {0x15, 0x27, KEY_SETUP},
+        {0x15, 0x3a, KEY_RECORD},/* these keys are only in the black remot=
e */
+        {0x15, 0x3b, KEY_PLAY},
+        {0x15, 0x3c, KEY_STOP},
+        {0x15, 0x3d, KEY_REWIND},
+        {0x15, 0x3e, KEY_PAUSE},
+        {0x15, 0x3f, KEY_FORWARD}
+};
+
+
=20
=20
 static int pctv452e_rc_query(struct dvb_usb_device *d, u32 *keyevent, int =
*keystate) {
@@ -989,7 +1036,7 @@ static struct dvb_usb_device_properties=20
=20
 	.power_ctrl       =3D pctv452e_power_ctrl,
=20
=2D	.rc_key_map       =3D pctv452e_rc_keys,
+	.rc_key_map       =3D tt_connect_s2_3600_rc_key,
 	.rc_key_map_size  =3D ARRAY_SIZE(pctv452e_rc_keys),
 	.rc_query         =3D pctv452e_rc_query,
 	.rc_interval      =3D 100,
@@ -1079,5 +1126,6 @@ module_exit(pctv452e_usb_exit);
 module_exit(pctv452e_usb_exit);
=20
 MODULE_AUTHOR("Dominik Kuhlen <dkuhlen@gmx.net>");
=2DMODULE_DESCRIPTION("Pinnacle PCTV HDTV USB DVB Driver");
+MODULE_AUTHOR("Andre Weidemann <Andre.Weidemann@web.de>");
+MODULE_DESCRIPTION("Pinnacle PCTV HDTV USB DVB / TT connect S2-3600 Driver=
");
 MODULE_LICENSE("GPL");

--Boundary-01=_LTwCIF0gASDzUou--

--nextPart3470653.Of5xUiP5Wl
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBICwTL6OXrfqftMKIRAiXKAKCiZSOZZGgY23urAsl2P4ktdeeZQgCbBLBq
Lk202ye1qFSHeZQkjHlGiMc=
=cdHN
-----END PGP SIGNATURE-----

--nextPart3470653.Of5xUiP5Wl--


--===============1943437714==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1943437714==--
