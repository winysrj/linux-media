Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Jbfht-0003j2-Kw
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 18:34:38 +0100
Message-ID: <47DFFD0D.9060206@iki.fi>
Date: Tue, 18 Mar 2008 19:34:05 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org, Patrick Boettcher <patrick.boettcher@desy.de>,
	Albert Comerma <albert.comerma@gmail.com>,
	insomniac <insomniac@slackware.it>
Content-Type: multipart/mixed; boundary="------------090907000109080909020206"
Subject: [linux-dvb] PATCH Support for Pinnacle PCTV 73e (Dib7770)
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
--------------090907000109080909020206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

moi
This patch adds support for Pinnacle PCTV 73e DVB-T stick.

Albert, could you also give signed-off-by?

Insomniac, can you still test that there is no copy & paste errors in 
this patch :)

Signed-off-by: Antti Palosaari <crope@iki.fi>

Regards
Antti Palosaari

-- 
http://palosaari.fi/

--------------090907000109080909020206
Content-Type: text/x-diff;
 name="pinnacle_pctv_73e_2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pinnacle_pctv_73e_2.patch"

diff -r 2e9a92dbe2be linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Sun Mar 16 12:14:12 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Tue Mar 18 19:28:43 2008 +0200
@@ -905,6 +905,7 @@ struct usb_device_id dib0700_usb_id_tabl
 		{ USB_DEVICE(USB_VID_ASUS,      USB_PID_ASUS_U3100) },
 /* 25 */	{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_NOVA_T_STICK_3) },
 		{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_MYTV_T) },
+		{ USB_DEVICE(USB_VID_PINNACLE,  USB_PID_PINNACLE_PCTV73E) },
 		{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -1090,7 +1091,7 @@ struct dvb_usb_device_properties dib0700
 			},
 		},
 
-		.num_device_descs = 6,
+		.num_device_descs = 7,
 		.devices = {
 			{   "DiBcom STK7070P reference design",
 				{ &dib0700_usb_id_table[15], NULL },
@@ -1114,6 +1115,10 @@ struct dvb_usb_device_properties dib0700
 			},
 			{   "Hauppauge Nova-T MyTV.t",
 				{ &dib0700_usb_id_table[26], NULL },
+				{ NULL },
+			},
+			{   "Pinnacle PCTV 73e",			
+				{ &dib0700_usb_id_table[27], NULL },
 				{ NULL },
 			},
 		},
diff -r 2e9a92dbe2be linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Sun Mar 16 12:14:12 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Tue Mar 18 19:28:43 2008 +0200
@@ -138,6 +138,7 @@
 #define USB_PID_PINNACLE_PCTV2000E			0x022c
 #define USB_PID_PINNACLE_PCTV_DVB_T_FLASH		0x0228
 #define USB_PID_PINNACLE_PCTV_DUAL_DIVERSITY_DVB_T	0x0229
+#define USB_PID_PINNACLE_PCTV73E			0x0237
 #define USB_PID_PCTV_200E				0x020e
 #define USB_PID_PCTV_400E				0x020f
 #define USB_PID_PCTV_450E				0x0222

--------------090907000109080909020206
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------090907000109080909020206--
