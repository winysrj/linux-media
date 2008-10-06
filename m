Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bubo.tul.cz ([147.230.16.1])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <petr.cvek@tul.cz>) id 1KmmRO-0006ao-An
	for linux-dvb@linuxtv.org; Mon, 06 Oct 2008 11:31:46 +0200
Received: from webmail.vslib.cz (webmail.tul.cz [147.230.16.50])
	by bubo.tul.cz (Postfix) with ESMTP id E484D5F404
	for <linux-dvb@linuxtv.org>; Mon,  6 Oct 2008 11:31:34 +0200 (CEST)
Message-ID: <20081006113134.rpgzq4gpno40cowg@webmail.tul.cz>
Date: Mon,  6 Oct 2008 11:31:34 +0200
From: petr.cvek@tul.cz
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=_4ccy89e3eb6s"
Content-Transfer-Encoding: 7bit
Subject: [linux-dvb] [PATCH] Add support for Winfast Dongle Hybrid
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This message is in MIME format.

--=_4ccy89e3eb6s
Content-Type: text/plain;
	charset=ISO-8859-2;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Hello,
This patch adds USB ID of DVB-T and analog card Winfast Dongle Hybrid
(0x60f6). It is diffed against v4l-dvb-979d14edeb2e



----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.


--=_4ccy89e3eb6s
Content-Type: text/x-diff;
	charset=UTF-8;
	name="winfast_dongle_hybrid.patch"
Content-Disposition: attachment;
	filename="winfast_dongle_hybrid.patch"
Content-Transfer-Encoding: quoted-printable

From: Petr Cvek  <petr.cvek@tul.cz>

Add support for Leadtek Winfast Dongle H (DVB and analog TV USB card).

Signed-off-by: Petr Cvek  <petr.cvek@tul.cz>

diff -ruN v4l-dvb-979d14edeb2e_old/linux/drivers/media/dvb/dvb-usb/dib0700_d=
evices.c v4l-dvb-979d14edeb2e_new/linux/drivers/media/dvb/dvb-usb/dib0700_de=
vices.c
--- v4l-dvb-979d14edeb2e_old/linux/drivers/media/dvb/dvb-usb/dib0700_devices=
.c=092008-10-05 02:37:36.000000000 +0200
+++ v4l-dvb-979d14edeb2e_new/linux/drivers/media/dvb/dvb-usb/dib0700_devices=
.c=092008-10-06 03:06:51.000000000 +0200
@@ -1251,6 +1251,7 @@
 =09{ USB_DEVICE(USB_VID_ASUS,=09USB_PID_ASUS_U3000H) },
 /* 40 */{ USB_DEVICE(USB_VID_PINNACLE,  USB_PID_PINNACLE_PCTV801E) },
 =09{ USB_DEVICE(USB_VID_PINNACLE,  USB_PID_PINNACLE_PCTV801E_SE) },
+=09{ USB_DEVICE(USB_VID_LEADTEK,   USB_PID_WINFAST_DTV_DONGLE_HYBRID) },=09
 =09{ 0 }=09=09/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -1545,7 +1546,7 @@
 =09=09=09},
 =09=09},
=20
-=09=09.num_device_descs =3D 5,
+=09=09.num_device_descs =3D 6,
 =09=09.devices =3D {
 =09=09=09{   "Terratec Cinergy HT USB XE",
 =09=09=09=09{ &dib0700_usb_id_table[27], NULL },
@@ -1571,6 +1572,10 @@
 =09=09=09=09{ &dib0700_usb_id_table[39], NULL },
 =09=09=09=09{ NULL },
 =09=09=09},
+=09=09=09{   "Leadtek Winfast Dongle Hybrid",
+=09=09=09=09{ &dib0700_usb_id_table[42], NULL },
+=09=09=09=09{ NULL },
+=09=09=09},
 =09=09},
 =09=09.rc_interval      =3D DEFAULT_RC_INTERVAL,
 =09=09.rc_key_map       =3D dib0700_rc_keys,
diff -ruN v4l-dvb-979d14edeb2e_old/linux/drivers/media/dvb/dvb-usb/dvb-usb-i=
ds.h v4l-dvb-979d14edeb2e_new/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- v4l-dvb-979d14edeb2e_old/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h=
=092008-10-05 02:37:36.000000000 +0200
+++ v4l-dvb-979d14edeb2e_new/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h=
=092008-10-06 03:05:14.000000000 +0200
@@ -232,5 +232,6 @@
 #define USB_PID_DW2102=09=09=09=09=090x2102
 #define USB_PID_XTENSIONS_XD_380=09=09=090x0381
 #define USB_PID_TELESTAR_STARSTICK_2=09=09=090x8000
+#define USB_PID_WINFAST_DTV_DONGLE_HYBRID=09=090x60f6
=20
 #endif

--=_4ccy89e3eb6s
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=_4ccy89e3eb6s--
