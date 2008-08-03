Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <liplianin@me.by>) id 1KPbBF-0006ij-81
	for linux-dvb@linuxtv.org; Sun, 03 Aug 2008 12:51:19 +0200
Received: by nf-out-0910.google.com with SMTP id g13so1664241nfb.11
	for <linux-dvb@linuxtv.org>; Sun, 03 Aug 2008 03:51:13 -0700 (PDT)
To: linux-dvb@linuxtv.org
Date: Sun, 3 Aug 2008 13:50:31 +0300
References: <20080803030118.DF8FF164293@ws1-4.us4.outblaze.com>
In-Reply-To: <20080803030118.DF8FF164293@ws1-4.us4.outblaze.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808031350.31928.igor@liplianin.net>
From: "Igor M. Liplianin" <liplianin@me.by>
Subject: [linux-dvb] TerraTec Cinergy S USB patch needs testing
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

> Hi Igor,
>
> I just gut the Terratec Cinergy S USB (not the mac-edition) to work. I just
> changed the product-id to 0064 und the vendor-id to 0ccd. Here in Germany
> this USB-box is quite popular. Maybe you want to add these values to your
> driver.
>
> best regards
>
> Thorsten Leupold

TerraTec Cinergy S USB patch. 
I am asking all to test it.
-----------------------------------------------------
Add TerraTec Cinergy S USB support

From: Igor M. Liplianin <liplianin@me.by>

Add TerraTec Cinergy S USB support

Signed-off-by: Igor M. Liplianin <liplianin@me.by> 

diff -Naur a/linux/drivers/media/dvb/dvb-usb/dw2102.c b/linux/drivers/media/dvb/dvb-usb/dw2102.c
--- a/linux/drivers/media/dvb/dvb-usb/dw2102.c	2008-07-21 23:51:10.000000000 +0300
+++ b/linux/drivers/media/dvb/dvb-usb/dw2102.c	2008-08-03 13:33:42.000000000 +0300
@@ -16,6 +16,9 @@
 #ifndef USB_PID_DW2102
 #define USB_PID_DW2102 0x2102
 #endif
+#ifndef USB_PID_CINERGY_S
+#define USB_PID_CINERGY_S 0x0064
+#endif
 
 #define DW2102_READ_MSG 0
 #define DW2102_WRITE_MSG 1
@@ -249,6 +252,7 @@
 static struct usb_device_id dw2102_table[] = {
 	{USB_DEVICE(USB_VID_CYPRESS, USB_PID_DW2102)},
 	{USB_DEVICE(USB_VID_CYPRESS, 0x2101)},
+	{USB_DEVICE(USB_VID_TERRATEC, USB_PID_CINERGY_S)},
 	{ }
 };
 
@@ -273,6 +277,7 @@
 			return ret;
 		}
 		break;
+	case USB_PID_CINERGY_S:
 	case USB_PID_DW2102:
 		fw = frmwr;
 		break;
@@ -313,6 +318,7 @@
 		}
 		/* init registers */
 		switch (dev->descriptor.idProduct) {
+		case USB_PID_CINERGY_S:
 		case USB_PID_DW2102:
 			dw2102_op_rw
 				(dev, 0xbf, 0x0040, &reset, 0,
@@ -375,7 +381,7 @@
 			},
 		}
 	},
-	.num_device_descs = 2,
+	.num_device_descs = 3,
 	.devices = {
 		{"DVBWorld DVB-S 2102 USB2.0",
 			{&dw2102_table[0], NULL},
@@ -385,6 +391,10 @@
 			{&dw2102_table[1], NULL},
 			{NULL},
 		},
+		{"TerraTec Cinergy S USB",
+			{&dw2102_table[2], NULL},
+			{NULL},
+		},
 	}
 };
 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
