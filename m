Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout10.t-online.de ([194.25.134.21]:38470 "EHLO
	mailout10.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab2I3EGD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Sep 2012 00:06:03 -0400
From: Wolfgang Bail <wolfgang.bail@t-online.de>
To: linux-media@vger.kernel.org
Subject: v4l
Date: Sun, 30 Sep 2012 05:49:26 +0200
Cc: mchehab@redhat.com
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_GF8ZQbBF9X5nyaF"
Message-Id: <201209300549.26996.wolfgang.bail@t-online.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_GF8ZQbBF9X5nyaF
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello,

the ir-rc from my msi DigiVox mini II Version 3 (af9015) will not work sinc=
e=20
kernel 3.2.x (kubuntu 12.04), same with s2-liplianin or v4l.

sudo ir-keytable -t shows:

Testing events. Please, press CTRL-C to abort.
1348890734.303273: event MSC: scancode =3D 317
1348890734.303280: event key down: KEY_POWER (0x0074)
1348890734.303282: event sync
1348890734.553961: event key up: KEY_POWER (0x0074)
1348890734.553963: event sync
1348890741.303451: event MSC: scancode =3D 30d
1348890741.303457: event key down: KEY_DOWN (0x006c)
1348890741.303459: event sync
^[[B1348890741.553956: event key up: KEY_DOWN (0x006c)

So I changed in rc-msi-digivox-ii.c { 0x0002, KEY_2 }, to { 0x0302, KEY_2 }=
,=20
and so on. And now it works well.

I hope, my mini patch is standard, the first I made. I don't know, whether=
=20
there are different variants of remote controls. But I don't believe it,=20
because it was ok with kernel 2.6.x.

@Mauro, thank you for the reply.

=2D-=20
Greetings

Wolfgang Bail
Venloerstr. 156 a
50672 K=F6ln
Tel. 0221/526565
Email: Wolfgang.Bail@t-online.de

--Boundary-00=_GF8ZQbBF9X5nyaF
Content-Type: text/x-patch;
  charset="UTF-8";
  name="msi-digivox-mini-ii-v3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="msi-digivox-mini-ii-v3.patch"

--- linux/drivers/media/rc/keymaps/rc-msi-digivox-ii.c	2012-09-30 03:28:20.945765129 +0200
+++ linux/drivers/media/rc/keymaps/rc-msi-digivox-ii.c	2012-09-26 05:36:34.000000000 +0200
@@ -22,24 +22,24 @@
 #include <linux/module.h>
 
 static struct rc_map_table msi_digivox_ii[] = {
-	{ 0x0002, KEY_2 },
-	{ 0x0003, KEY_UP },              /* up */
-	{ 0x0004, KEY_3 },
-	{ 0x0005, KEY_CHANNELDOWN },
-	{ 0x0008, KEY_5 },
-	{ 0x0009, KEY_0 },
-	{ 0x000b, KEY_8 },
-	{ 0x000d, KEY_DOWN },            /* down */
-	{ 0x0010, KEY_9 },
-	{ 0x0011, KEY_7 },
-	{ 0x0014, KEY_VOLUMEUP },
-	{ 0x0015, KEY_CHANNELUP },
-	{ 0x0016, KEY_OK },
-	{ 0x0017, KEY_POWER2 },
-	{ 0x001a, KEY_1 },
-	{ 0x001c, KEY_4 },
-	{ 0x001d, KEY_6 },
-	{ 0x001f, KEY_VOLUMEDOWN },
+	{ 0x0302, KEY_2 },
+	{ 0x0303, KEY_UP },              /* up */
+	{ 0x0304, KEY_3 },
+	{ 0x0305, KEY_CHANNELDOWN },
+	{ 0x0308, KEY_5 },
+	{ 0x0309, KEY_0 },
+	{ 0x030b, KEY_8 },
+	{ 0x030d, KEY_DOWN },            /* down */
+	{ 0x0310, KEY_9 },
+	{ 0x0311, KEY_7 },
+	{ 0x0314, KEY_VOLUMEUP },
+	{ 0x0315, KEY_CHANNELUP },
+	{ 0x0316, KEY_OK },
+	{ 0x0317, KEY_POWER2 },
+	{ 0x031a, KEY_1 },
+	{ 0x031c, KEY_4 },
+	{ 0x031d, KEY_6 },
+	{ 0x031f, KEY_VOLUMEDOWN },
 };
 
 static struct rc_map_list msi_digivox_ii_map = {

--Boundary-00=_GF8ZQbBF9X5nyaF--
