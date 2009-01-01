Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n017wfOu009152
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 02:58:41 -0500
Received: from mail-ew0-f21.google.com (mail-ew0-f21.google.com
	[209.85.219.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n017wRiM016668
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 02:58:27 -0500
Received: by ewy14 with SMTP id 14so6666946ewy.3
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 23:58:26 -0800 (PST)
From: Alexey Klimov <klimov.linux@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: text/plain
Date: Thu, 01 Jan 2009 10:58:31 +0300
Message-Id: <1230796711.5124.18.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: [PATCH] gspca: t613 - small codingstyle fix
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Lets make usb_driver and sd_desc looks nicer.


Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

---
diff -r 6f3948c174c1 linux/drivers/media/video/gspca/t613.c
--- a/linux/drivers/media/video/gspca/t613.c	Wed Dec 31 18:33:53 2008 +0100
+++ b/linux/drivers/media/video/gspca/t613.c	Thu Jan 01 09:55:54 2009 +0300
@@ -1135,15 +1135,15 @@
 
 /* sub-driver description */
 static const struct sd_desc sd_desc = {
-	.name = MODULE_NAME,
-	.ctrls = sd_ctrls,
-	.nctrls = ARRAY_SIZE(sd_ctrls),
-	.config = sd_config,
-	.init = sd_init,
-	.start = sd_start,
-	.stopN = sd_stopN,
-	.pkt_scan = sd_pkt_scan,
-	.querymenu = sd_querymenu,
+	.name		= MODULE_NAME,
+	.ctrls		= sd_ctrls,
+	.nctrls		= ARRAY_SIZE(sd_ctrls),
+	.config		= sd_config,
+	.init		= sd_init,
+	.start		= sd_start,
+	.stopN		= sd_stopN,
+	.pkt_scan	= sd_pkt_scan,
+	.querymenu	= sd_querymenu,
 };
 
 /* -- module initialisation -- */
@@ -1162,13 +1162,13 @@
 }
 
 static struct usb_driver sd_driver = {
-	.name = MODULE_NAME,
-	.id_table = device_table,
-	.probe = sd_probe,
-	.disconnect = gspca_disconnect,
+	.name		= MODULE_NAME,
+	.id_table	= device_table,
+	.probe		= sd_probe,
+	.disconnect	= gspca_disconnect,
 #ifdef CONFIG_PM
-	.suspend = gspca_suspend,
-	.resume = gspca_resume,
+	.suspend	= gspca_suspend,
+	.resume		= gspca_resume,
 #endif
 };
 


-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
