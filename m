Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.211.174]:64271 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbZI1PED (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Sep 2009 11:04:03 -0400
Received: by ywh4 with SMTP id 4so4737761ywh.33
        for <linux-media@vger.kernel.org>; Mon, 28 Sep 2009 08:04:06 -0700 (PDT)
Message-ID: <4AC0D05D.4060304@gmail.com>
Date: Mon, 28 Sep 2009 12:03:57 -0300
From: Filipe Rosset <rosset.filipe@gmail.com>
Reply-To: rosset.filipe@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Douglas Schilling Landgraf <dougsland@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/2] em28xx: Convert printks to em28xx_err and em28xx_info
Content-Type: multipart/mixed;
 boundary="------------020306050106040107080600"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020306050106040107080600
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


--------------020306050106040107080600
Content-Type: text/plain;
 name="Convert_printks_to_em28xx_err_and_em28xx_info.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Convert_printks_to_em28xx_err_and_em28xx_info.diff"

em28xx: Convert printks to em28xx_err and em28xx_info

From: Filipe Rosset <rosset.filipe@gmail.com>

Convert printks to em28xx_err and em28xx_info

Priority: normal

Signed-off-by: Filipe Rosset <rosset.filipe@gmail.com>

diff -r cbf8899e0fd4 linux/drivers/media/video/em28xx/em28xx-dvb.c
--- a/linux/drivers/media/video/em28xx/em28xx-dvb.c	Mon Sep 28 11:22:23 2009 -0300
+++ b/linux/drivers/media/video/em28xx/em28xx-dvb.c	Mon Sep 28 11:52:23 2009 -0300
@@ -314,7 +314,7 @@
 	cfg.i2c_addr  = addr;
 
 	if (!dev->dvb->frontend) {
-		printk(KERN_ERR "%s/2: dvb frontend not attached. "
+		em28xx_err("%s/2: dvb frontend not attached. "
 				"Can't attach xc3028\n",
 		       dev->name);
 		return -EINVAL;
@@ -322,14 +322,14 @@
 
 	fe = dvb_attach(xc2028_attach, dev->dvb->frontend, &cfg);
 	if (!fe) {
-		printk(KERN_ERR "%s/2: xc3028 attach failed\n",
+		em28xx_err("%s/2: xc3028 attach failed\n",
 		       dev->name);
 		dvb_frontend_detach(dev->dvb->frontend);
 		dev->dvb->frontend = NULL;
 		return -EINVAL;
 	}
 
-	printk(KERN_INFO "%s/2: xc3028 attached\n", dev->name);
+	em28xx_info("%s/2: xc3028 attached\n", dev->name);
 
 	return 0;
 }
@@ -464,7 +464,7 @@
 	dvb = kzalloc(sizeof(struct em28xx_dvb), GFP_KERNEL);
 
 	if (dvb == NULL) {
-		printk(KERN_INFO "em28xx_dvb: memory allocation failed\n");
+		em28xx_info("em28xx_dvb: memory allocation failed\n");
 		return -ENOMEM;
 	}
 	dev->dvb = dvb;
@@ -570,14 +570,13 @@
 		}
 		break;
 	default:
-		printk(KERN_ERR "%s/2: The frontend of your DVB/ATSC card"
+		em28xx_err("%s/2: The frontend of your DVB/ATSC card"
 				" isn't supported yet\n",
 		       dev->name);
 		break;
 	}
 	if (NULL == dvb->frontend) {
-		printk(KERN_ERR
-		       "%s/2: frontend initialization failed\n",
+		em28xx_err("%s/2: frontend initialization failed\n",
 		       dev->name);
 		result = -EINVAL;
 		goto out_free;
@@ -592,7 +591,7 @@
 		goto out_free;
 
 	em28xx_set_mode(dev, EM28XX_SUSPEND);
-	printk(KERN_INFO "Successfully loaded em28xx-dvb\n");
+	em28xx_info("Successfully loaded em28xx-dvb\n");
 	return 0;
 
 out_free:

--------------020306050106040107080600--
