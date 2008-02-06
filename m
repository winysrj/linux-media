Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from fmmailgate01.web.de ([217.72.192.221])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Andre.Weidemann@web.de>) id 1JMk62-0004t3-H8
	for linux-dvb@linuxtv.org; Wed, 06 Feb 2008 14:13:50 +0100
Received: from smtp05.web.de (fmsmtp05.dlan.cinetic.de [172.20.4.166])
	by fmmailgate01.web.de (Postfix) with ESMTP id 3E986D205C0D
	for <linux-dvb@linuxtv.org>; Wed,  6 Feb 2008 14:13:20 +0100 (CET)
Received: from [84.184.74.39] (helo=[127.0.0.1])
	by smtp05.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.109 #226) id 1JMk5V-0000sT-00
	for linux-dvb@linuxtv.org; Wed, 06 Feb 2008 14:13:18 +0100
Message-ID: <47A9B2AE.7090209@web.de>
Date: Wed, 06 Feb 2008 14:14:22 +0100
From: =?ISO-8859-1?Q?Andr=E9_Weidemann?= <Andre.Weidemann@web.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------080103010901060806080808"
Subject: [linux-dvb] [PATCH] Support for TT connect S-2400
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------080103010901060806080808
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi,
I have added few lines to dvb-usb-ids.h and ttusb2.c to get the=20
Technotrend TT connect S-2400 working.
The attached patch should apply against current HG repository.

However, the S-2400 will not be working unless an earlier patch is revert=
ed:
http://linuxtv.org/hg/v4l-dvb/diff/816f256c2973/linux/drivers/media/dvb/f=
rontends/tda10086.c

There is an ongoing thread in the list about the tuning problem.
See: "TDA10086 with Pinnacle 400e tuning broken"

Please try the attached patch and let me know whether it's working or not=
.

Andr=E9

--------------080103010901060806080808
Content-Type: text/x-patch;
 name="support for TT connect S-2400.diff"
Content-Disposition: inline;
 filename="support for TT connect S-2400.diff"
Content-Transfer-Encoding: quoted-printable

diff -Nrubw multiproto/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h mult=
iproto_patched-for-TT-Connect-S2400/linux/drivers/media/dvb/dvb-usb/dvb-u=
sb-ids.h
--- multiproto/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2008-02-04 1=
4:44:25.493921042 +0100
+++ multiproto_patched-for-TT-Connect-S2400/linux/drivers/media/dvb/dvb-u=
sb/dvb-usb-ids.h	2008-02-04 14:49:41.199912100 +0100
@@ -40,6 +40,7 @@
 #define USB_VID_MSI				0x0db0
 #define USB_VID_OPERA1				0x695c
 #define USB_VID_PINNACLE			0x2304
+#define USB_VID_TECHNOTREND			0x0b48
 #define USB_VID_TERRATEC			0x0ccd
 #define USB_VID_VISIONPLUS			0x13d3
 #define USB_VID_TWINHAN				0x1822
@@ -134,6 +135,7 @@
 #define USB_PID_AVERMEDIA_EXPRESS			0xb568
 #define USB_PID_AVERMEDIA_VOLAR				0xa807
 #define USB_PID_AVERMEDIA_VOLAR_2			0xb808
+#define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY	0x005a
 #define USB_PID_PINNACLE_PCTV2000E			0x022c
 #define USB_PID_PINNACLE_PCTV_DVB_T_FLASH		0x0228
diff -Nrubw multiproto/linux/drivers/media/dvb/dvb-usb/ttusb2.c multiprot=
o_patched-for-TT-Connect-S2400/linux/drivers/media/dvb/dvb-usb/ttusb2.c
--- multiproto/linux/drivers/media/dvb/dvb-usb/ttusb2.c	2008-02-04 14:44:=
25.541923777 +0100
+++ multiproto_patched-for-TT-Connect-S2400/linux/drivers/media/dvb/dvb-u=
sb/ttusb2.c	2008-02-04 15:10:48.168112504 +0100
@@ -191,6 +191,7 @@
 static struct usb_device_id ttusb2_table [] =3D {
 		{ USB_DEVICE(USB_VID_PINNACLE, USB_PID_PCTV_400E) },
 		{ USB_DEVICE(USB_VID_PINNACLE, USB_PID_PCTV_450E) },
+		{ USB_DEVICE(USB_VID_TECHNOTREND, USB_PID_TECHNOTREND_CONNECT_S2400) }=
,
 		{}		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE (usb, ttusb2_table);
@@ -234,7 +235,7 @@
=20
 	.generic_bulk_ctrl_endpoint =3D 0x01,
=20
-	.num_device_descs =3D 2,
+	.num_device_descs =3D 3,
 	.devices =3D {
 		{   "Pinnacle 400e DVB-S USB2.0",
 			{ &ttusb2_table[0], NULL },
@@ -244,6 +245,10 @@
 			{ &ttusb2_table[1], NULL },
 			{ NULL },
 		},
+		{   "Technotrend TT-connect=AE S-2400",
+			{ &ttusb2_table[2], NULL },
+			{ NULL },
+		},
 	}
 };
=20

--------------080103010901060806080808
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------080103010901060806080808--
