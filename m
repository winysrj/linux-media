Return-path: <linux-media-owner@vger.kernel.org>
Received: from web90402.mail.mud.yahoo.com ([216.252.100.154]:41584 "HELO
	web90402.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752572AbZAJBDl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Jan 2009 20:03:41 -0500
Date: Fri, 9 Jan 2009 16:57:00 -0800 (PST)
From: Nicolas Fournier <nicolasfournier@yahoo.com>
Subject: [PATCH] Terratec Cinergy DT XS Diversity new USB ID (0ccd:0081)
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <896541.44891.qm@web90402.mail.mud.yahoo.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following patch adds support for a new version of the 
Terratec Cinergy DT USB XS Diversity Dual DVB-T TV tuner stick.  
The USB ID of the new stick is 0ccd:0081.
The hardware of the stick has changed, when compared to the first version of 
this stick, but it still uses quite standard components, so that only minor
changes are needed to the sources.  

The patch has been successfully tested with hotplugging the device and then 
2 x tzap and 2 x mplayer, to watch two different TV programs simultaneously.

The stick works with both, the old and new firmwares:
- dvb-usb-dib0700-1.10.fw and 
- dvb-usb-dib0700-1.20.fw

Priority: normal

Signed-off-by: Nicolas Fournier <nicolasfournier -at- yahoo -dot- com>


diff -r 985ecd81d993 linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c Fri Jan 09 10:07:07 2009 -0200
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c Sat Jan 10 01:50:34 2009 +0100
@@ -1394,6 +1394,8 @@ struct usb_device_id dib0700_usb_id_tabl
 /* 40 */{ USB_DEVICE(USB_VID_PINNACLE,  USB_PID_PINNACLE_PCTV801E) },
        { USB_DEVICE(USB_VID_PINNACLE,  USB_PID_PINNACLE_PCTV801E_SE) },
        { USB_DEVICE(USB_VID_TERRATEC,  USB_PID_TERRATEC_CINERGY_T_EXPRESS) },
+       { USB_DEVICE(USB_VID_TERRATEC,
+                       USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY_2) },
        { 0 }           /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -1659,7 +1661,7 @@ struct dvb_usb_device_properties dib0700
                        }
                },
 
-               .num_device_descs = 4,
+               .num_device_descs = 5,
                .devices = {
                        {   "DiBcom STK7070PD reference design",
                                { &dib0700_usb_id_table[17], NULL },
@@ -1675,6 +1677,10 @@ struct dvb_usb_device_properties dib0700
                        },
                        {   "Hauppauge Nova-TD-500 (84xxx)",
                                { &dib0700_usb_id_table[36], NULL },
+                               { NULL },
+                       },
+                       {   "Terratec Cinergy DT USB XS Diversity",
+                               { &dib0700_usb_id_table[43], NULL },
                                { NULL },
                        }
                }
diff -r 985ecd81d993 linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h     Fri Jan 09 10:07:07 2009 -0200
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h     Sat Jan 10 01:38:32 2009 +0100
@@ -162,6 +162,7 @@
 #define USB_PID_AVERMEDIA_A309                         0xa309
 #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY       0x005a
+#define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY_2     0x0081
 #define USB_PID_TERRATEC_CINERGY_HT_USB_XE             0x0058
 #define USB_PID_TERRATEC_CINERGY_HT_EXPRESS            0x0060
 #define USB_PID_TERRATEC_CINERGY_T_EXPRESS             0x0062


      
