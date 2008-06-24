Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web90408.mail.mud.yahoo.com ([216.252.100.160])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <nicolasfournier@yahoo.com>) id 1KAwNH-0001ss-Fw
	for linux-dvb@linuxtv.org; Tue, 24 Jun 2008 02:27:08 +0200
Date: Mon, 23 Jun 2008 17:26:29 -0700 (PDT)
From: Nicolas Fournier <nicolasfournier@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <164389.24374.qm@web90408.mail.mud.yahoo.com>
Subject: [linux-dvb] [PATCH] Terratec Cinergy DT XS Diversity new USB ID
	(0ccd:0081)
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

The following patch adds support for a new version of the Terratec Cinergy DT USB XS Diversity Dual DVB-T TV tuner stick.  The hardware has changed, when compared to the first version of this stick, but it still uses quite standard components, so that only minor changes are needed to the sources.
The patch has been successfully tested with hotplugging the device and then 2 x tzap and 2 x mplayer, to watch two different TV programs simultaneously. 
The firmware used for this stick is the same as for the old stick: dvb-usb-dib0700-1.10.fw.  
Thanks go to Darren Salt for his feedback.

Signed-off-by: Nicolas Fournier <nicolasfournier[AT]yahoo[DOT]com>



diff -r 49ea64868f0c linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c Mon Jun 23 09:31:29 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c Tue Jun 24 01:18:48 2008 +0200
@@ -1117,6 +1117,7 @@ struct usb_device_id dib0700_usb_id_tabl
        { USB_DEVICE(USB_VID_TERRATEC,  USB_PID_TERRATEC_CINERGY_HT_EXPRESS) },
        { USB_DEVICE(USB_VID_TERRATEC,  USB_PID_TERRATEC_CINERGY_T_XXS) },
        { USB_DEVICE(USB_VID_LEADTEK,   USB_PID_WINFAST_DTV_DONGLE_STK7700P_2) },
+/* 35 */{ USB_DEVICE(USB_VID_TERRATEC,  USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY_2) },
        { 0 }           /* Terminating entry */
};
MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -1372,10 +1373,14 @@ struct dvb_usb_device_properties dib0700
                        }
                },

-               .num_device_descs = 2,
+               .num_device_descs = 3,
                .devices = {
                        {   "DiBcom STK7070PD reference design",
                                { &dib0700_usb_id_table[17], NULL },
+                               { NULL },
+                       },
+                       {   "Terratec Cinergy DT USB XS Diversity",
+                               { &dib0700_usb_id_table[35], NULL },
                                { NULL },
                        },
                        {   "Pinnacle PCTV Dual DVB-T Diversity Stick",
diff -r 49ea64868f0c linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h     Mon Jun 23 09:31:29 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h     Tue Jun 24 01:16:48 2008 +0200
@@ -139,6 +139,7 @@
#define USB_PID_AVERMEDIA_VOLAR_2                      0xb808
#define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
#define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY       0x005a
+#define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY_2     0x0081
#define USB_PID_TERRATEC_CINERGY_HT_USB_XE             0x0058
#define USB_PID_TERRATEC_CINERGY_HT_EXPRESS            0x0060
#define USB_PID_TERRATEC_CINERGY_T_XXS                 0x0078


      __________________________________________________________
Gesendet von Yahoo! Mail.
Dem pfiffigeren Posteingang.
http://de.overview.mail.yahoo.com

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
