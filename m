Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outmailhost.telefonica.net ([213.4.149.242]
	helo=ctsmtpout4.frontal.correo)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jareguero@telefonica.net>) id 1Kx6jJ-00010E-9V
	for linux-dvb@linuxtv.org; Mon, 03 Nov 2008 22:12:58 +0100
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: linux-dvb@linuxtv.org
Date: Mon, 3 Nov 2008 22:11:40 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Nk2DJEdqqc8vKcc"
Message-Id: <200811032211.41760.jareguero@telefonica.net>
Cc: Antti Palosaari <crope@iki.fi>
Subject: [linux-dvb] [PATCH] Add suport for AverMedia Volar X remote
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

--Boundary-00=_Nk2DJEdqqc8vKcc
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch add support for AverMedia Volar X remote.

Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>

Jose Alberto

--Boundary-00=_Nk2DJEdqqc8vKcc
Content-Type: text/x-patch;
  charset="us-ascii";
  name="af9015.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="af9015.diff"

diff -r 55f8fcf70843 linux/drivers/media/dvb/dvb-usb/af9015.c
--- a/linux/drivers/media/dvb/dvb-usb/af9015.c	Thu Oct 30 08:07:44 2008 +0000
+++ b/linux/drivers/media/dvb/dvb-usb/af9015.c	Mon Nov 03 22:08:27 2008 +0100
@@ -806,6 +806,16 @@
 					  ARRAY_SIZE(af9015_ir_table_msi);
 				}
 				break;
+			case USB_VID_AVERMEDIA:
+				af9015_properties[i].rc_key_map =
+			 	  af9015_rc_keys_avermedia;
+				af9015_properties[i].rc_key_map_size =
+				  ARRAY_SIZE(af9015_rc_keys_avermedia);	
+				af9015_config.ir_table =
+				  af9015_ir_table_avermedia;
+				af9015_config.ir_table_size =
+				  ARRAY_SIZE(af9015_ir_table_avermedia);
+				break;
 			}
 		}
 	}
diff -r 55f8fcf70843 linux/drivers/media/dvb/dvb-usb/af9015.h
--- a/linux/drivers/media/dvb/dvb-usb/af9015.h	Thu Oct 30 08:07:44 2008 +0000
+++ b/linux/drivers/media/dvb/dvb-usb/af9015.h	Mon Nov 03 22:08:27 2008 +0100
@@ -521,4 +521,80 @@
 	0x86, 0x6b, 0x23, 0xdc, 0x45, 0x07, 0x00,
 };
 
+/* AverMedia Volar X */
+static struct dvb_usb_rc_key af9015_rc_keys_avermedia[] = {
+	{ 0x05, 0x3d, KEY_PROG1 },       /* SOURCE */
+	{ 0x05, 0x12, KEY_POWER },       /* POWER */
+	{ 0x05, 0x1e, KEY_1 },           /* 1 */
+	{ 0x05, 0x1f, KEY_2 },           /* 2 */
+	{ 0x05, 0x20, KEY_3 },           /* 3 */
+	{ 0x05, 0x21, KEY_4 },           /* 4 */
+	{ 0x05, 0x22, KEY_5 },           /* 5 */
+	{ 0x05, 0x23, KEY_6 },           /* 6 */
+	{ 0x05, 0x24, KEY_7 },           /* 7 */
+	{ 0x05, 0x25, KEY_8 },           /* 8 */
+	{ 0x05, 0x26, KEY_9 },           /* 9 */
+	{ 0x05, 0x3f, KEY_LEFT },        /* L / DISPLAY */
+	{ 0x05, 0x27, KEY_0 },           /* 0 */
+	{ 0x05, 0x0f, KEY_RIGHT },       /* R / CH RTN */
+	{ 0x05, 0x18, KEY_PROG2 },       /* SNAP SHOT */
+	{ 0x05, 0x1c, KEY_PROG3 },       /* 16-CH PREV */
+	{ 0x05, 0x2d, KEY_VOLUMEDOWN },  /* VOL DOWN */
+	{ 0x05, 0x3e, KEY_ZOOM },        /* FULL SCREEN */
+	{ 0x05, 0x2e, KEY_VOLUMEUP },    /* VOL UP */
+	{ 0x05, 0x10, KEY_MUTE },        /* MUTE */
+	{ 0x05, 0x04, KEY_AUDIO },       /* AUDIO */
+	{ 0x05, 0x15, KEY_RECORD },      /* RECORD */
+	{ 0x05, 0x11, KEY_PLAY },        /* PLAY */
+	{ 0x05, 0x16, KEY_STOP },        /* STOP */
+	{ 0x05, 0x0c, KEY_PLAYPAUSE },   /* TIMESHIFT / PAUSE */
+	{ 0x05, 0x05, KEY_BACK },        /* << / RED */
+	{ 0x05, 0x09, KEY_FORWARD },     /* >> / YELLOW */
+	{ 0x05, 0x17, KEY_TEXT },        /* TELETEXT */
+	{ 0x05, 0x0a, KEY_EPG },         /* EPG */
+	{ 0x05, 0x13, KEY_MENU },        /* MENU */
+
+	{ 0x05, 0x0e, KEY_CHANNELUP },   /* CH UP */
+	{ 0x05, 0x0d, KEY_CHANNELDOWN }, /* CH DOWN */
+	{ 0x05, 0x19, KEY_FIRST },       /* |<< / GREEN */
+	{ 0x05, 0x08, KEY_LAST },        /* >>| / BLUE */
+};
+
+static u8 af9015_ir_table_avermedia[] = {
+	0x02, 0xfd, 0x00, 0xff, 0x12, 0x05, 0x00,
+	0x02, 0xfd, 0x01, 0xfe, 0x3d, 0x05, 0x00,
+	0x02, 0xfd, 0x03, 0xfc, 0x17, 0x05, 0x00,
+	0x02, 0xfd, 0x04, 0xfb, 0x0a, 0x05, 0x00,
+	0x02, 0xfd, 0x05, 0xfa, 0x1e, 0x05, 0x00,
+	0x02, 0xfd, 0x06, 0xf9, 0x1f, 0x05, 0x00,
+	0x02, 0xfd, 0x07, 0xf8, 0x20, 0x05, 0x00,
+	0x02, 0xfd, 0x09, 0xf6, 0x21, 0x05, 0x00,
+	0x02, 0xfd, 0x0a, 0xf5, 0x22, 0x05, 0x00,
+	0x02, 0xfd, 0x0b, 0xf4, 0x23, 0x05, 0x00,
+	0x02, 0xfd, 0x0d, 0xf2, 0x24, 0x05, 0x00,
+	0x02, 0xfd, 0x0e, 0xf1, 0x25, 0x05, 0x00,
+	0x02, 0xfd, 0x0f, 0xf0, 0x26, 0x05, 0x00,
+	0x02, 0xfd, 0x11, 0xee, 0x27, 0x05, 0x00,
+	0x02, 0xfd, 0x08, 0xf7, 0x04, 0x05, 0x00,
+	0x02, 0xfd, 0x0c, 0xf3, 0x3e, 0x05, 0x00,
+	0x02, 0xfd, 0x10, 0xef, 0x1c, 0x05, 0x00,
+	0x02, 0xfd, 0x12, 0xed, 0x3f, 0x05, 0x00,
+	0x02, 0xfd, 0x13, 0xec, 0x0f, 0x05, 0x00,
+	0x02, 0xfd, 0x14, 0xeb, 0x10, 0x05, 0x00,
+	0x02, 0xfd, 0x15, 0xea, 0x13, 0x05, 0x00,
+	0x02, 0xfd, 0x17, 0xe8, 0x18, 0x05, 0x00,
+	0x02, 0xfd, 0x18, 0xe7, 0x11, 0x05, 0x00,
+	0x02, 0xfd, 0x19, 0xe6, 0x15, 0x05, 0x00,
+	0x02, 0xfd, 0x1a, 0xe5, 0x0c, 0x05, 0x00,
+	0x02, 0xfd, 0x1b, 0xe4, 0x16, 0x05, 0x00,
+	0x02, 0xfd, 0x1c, 0xe3, 0x09, 0x05, 0x00,
+	0x02, 0xfd, 0x1d, 0xe2, 0x05, 0x05, 0x00,
+	0x02, 0xfd, 0x1e, 0xe1, 0x2d, 0x05, 0x00,
+	0x02, 0xfd, 0x1f, 0xe0, 0x2e, 0x05, 0x00,
+	0x03, 0xfc, 0x00, 0xff, 0x08, 0x05, 0x00,  
+	0x03, 0xfc, 0x01, 0xfe, 0x19, 0x05, 0x00,
+	0x03, 0xfc, 0x02, 0xfd, 0x0d, 0x05, 0x00,
+	0x03, 0xfc, 0x03, 0xfc, 0x0e, 0x05, 0x00,
+};
+
 #endif

--Boundary-00=_Nk2DJEdqqc8vKcc
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_Nk2DJEdqqc8vKcc--
