Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Jf2Tv-0005lJ-HV
	for linux-dvb@linuxtv.org; Fri, 28 Mar 2008 01:30:08 +0100
Message-ID: <47EC3BD4.3070307@iki.fi>
Date: Fri, 28 Mar 2008 02:29:08 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Patrick Boettcher <patrick.boettcher@desy.de>,
	ptay1685 <ptay1685@Bigpond.net.au>, John <bitumen.surfer@gmail.com>
References: <e44ae5e0712172128p4e1428aao493d0a1725b6fcd3@mail.gmail.com>
In-Reply-To: <e44ae5e0712172128p4e1428aao493d0a1725b6fcd3@mail.gmail.com>
Content-Type: multipart/mixed; boundary="------------010204040207050405060901"
Cc: linux-dvb@linuxtv.org, k.bannister@ieee.org
Subject: [linux-dvb] [PATCH] new USB-ID for Leadtek Winfast DTV was: Re: New
 Leadtek Winfast DTV Dongle working - with mods but	no RC
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

This is a multi-part message in MIME format.
--------------010204040207050405060901
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

hello
USB-ID for Leadtek Winfast DTV

Signed-off-by: Antti Palosaari <crope@iki.fi>

Patch done against current development-tree at 
http://linuxtv.org/hg/~pb/v4l-dvb/
Patrick, could you check and add it?

Could ptay1685 or John or some other test this?

Keith Bannister wrote:
> I hopped onto the IRC channel and crope` (thanks mate) advised me to 
> change dvb-usb-ids.h to
> 
> #define USB_PID_WINFAST_DTV_DONGLE_STK7700P        0x6f01

Sorry, I forgot make patch earlier...

regards
Antti
-- 
http://palosaari.fi/

--------------010204040207050405060901
Content-Type: text/x-diff;
 name="Leadtek_Winfast_DTV_Dongle_6f01.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Leadtek_Winfast_DTV_Dongle_6f01.patch"

diff -r 3d252c252869 linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Sat Mar 22 23:19:38 2008 +0100
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Fri Mar 28 02:15:01 2008 +0200
@@ -1115,6 +1115,8 @@ struct usb_device_id dib0700_usb_id_tabl
 	{ USB_DEVICE(USB_VID_YUAN,	USB_PID_YUAN_EC372S) },
 	{ USB_DEVICE(USB_VID_TERRATEC,	USB_PID_TERRATEC_CINERGY_HT_EXPRESS) },
 	{ USB_DEVICE(USB_VID_TERRATEC,	USB_PID_TERRATEC_CINERGY_T_XXS) },
+	{ USB_DEVICE(USB_VID_LEADTEK,
+			USB_PID_WINFAST_DTV_DONGLE_STK7700P_2) },
 	{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -1179,7 +1181,8 @@ struct dvb_usb_device_properties dib0700
 				{ NULL },
 			},
 			{   "Leadtek Winfast DTV Dongle (STK7700P based)",
-				{ &dib0700_usb_id_table[8], NULL },
+				{ &dib0700_usb_id_table[8],
+				  &dib0700_usb_id_table[34], NULL },
 				{ NULL },
 			},
 			{   "AVerMedia AVerTV DVB-T Express",
diff -r 3d252c252869 linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Sat Mar 22 23:19:38 2008 +0100
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Fri Mar 28 02:15:01 2008 +0200
@@ -180,6 +180,7 @@
 #define USB_PID_WINFAST_DTV_DONGLE_COLD			0x6025
 #define USB_PID_WINFAST_DTV_DONGLE_WARM			0x6026
 #define USB_PID_WINFAST_DTV_DONGLE_STK7700P		0x6f00
+#define USB_PID_WINFAST_DTV_DONGLE_STK7700P_2		0x6f01
 #define USB_PID_GENPIX_8PSK_REV_1_COLD			0x0200
 #define USB_PID_GENPIX_8PSK_REV_1_WARM			0x0201
 #define USB_PID_GENPIX_8PSK_REV_2			0x0202

--------------010204040207050405060901
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------010204040207050405060901--
