Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:55141 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbZI1QTu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Sep 2009 12:19:50 -0400
Received: by qw-out-2122.google.com with SMTP id 5so1599244qwd.37
        for <linux-media@vger.kernel.org>; Mon, 28 Sep 2009 09:19:54 -0700 (PDT)
Message-ID: <4AC0E21F.1000301@gmail.com>
Date: Mon, 28 Sep 2009 13:19:43 -0300
From: Filipe Rosset <rosset.filipe@gmail.com>
Reply-To: rosset.filipe@gmail.com
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/2] em28xx: Convert printks to em28xx_err and em28xx_info
References: <4AC0D05D.4060304@gmail.com> <829197380909280824q487c3effp64914d8430f16092@mail.gmail.com>
In-Reply-To: <829197380909280824q487c3effp64914d8430f16092@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------010805050909040008030701"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010805050909040008030701
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Em 28-09-2009 12:24, Devin Heitmueller escreveu:
> On Mon, Sep 28, 2009 at 11:03 AM, Filipe Rosset <rosset.filipe@gmail.com> wrote:
>>
> 
> You should use the em28xx_errdev() instead of em28xx_err() if your
> intent is to insert "dev->name" in front of the message.
> 
> Devin
> 

OK, modified patch.

Filipe

--------------010805050909040008030701
Content-Type: text/plain;
 name="Convert_printks_to_em28xx_err_and_em28xx_info.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Convert_printks_to_em28xx_err_and_em28xx_info.diff"

diff -r cbf8899e0fd4 linux/drivers/media/video/em28xx/em28xx-dvb.c
--- a/linux/drivers/media/video/em28xx/em28xx-dvb.c	Mon Sep 28 11:22:23 2009 -0300
+++ b/linux/drivers/media/video/em28xx/em28xx-dvb.c	Mon Sep 28 12:56:48 2009 -0300
@@ -314,22 +314,22 @@
 	cfg.i2c_addr  = addr;
 
 	if (!dev->dvb->frontend) {
-		printk(KERN_ERR "%s/2: dvb frontend not attached. "
+		em28xx_errdev("%s/2: dvb frontend not attached. "
 				"Can't attach xc3028\n",
-		       dev->name);
+			dev->name);
 		return -EINVAL;
 	}
 
 	fe = dvb_attach(xc2028_attach, dev->dvb->frontend, &cfg);
 	if (!fe) {
-		printk(KERN_ERR "%s/2: xc3028 attach failed\n",
-		       dev->name);
+		em28xx_errdev("%s/2: xc3028 attach failed\n",
+			dev->name);
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
@@ -570,15 +570,14 @@
 		}
 		break;
 	default:
-		printk(KERN_ERR "%s/2: The frontend of your DVB/ATSC card"
+		em28xx_errdev("%s/2: The frontend of your DVB/ATSC card"
 				" isn't supported yet\n",
-		       dev->name);
+			dev->name);
 		break;
 	}
 	if (NULL == dvb->frontend) {
-		printk(KERN_ERR
-		       "%s/2: frontend initialization failed\n",
-		       dev->name);
+		em28xx_errdev("%s/2: frontend initialization failed\n",
+			dev->name);
 		result = -EINVAL;
 		goto out_free;
 	}
@@ -592,7 +591,7 @@
 		goto out_free;
 
 	em28xx_set_mode(dev, EM28XX_SUSPEND);
-	printk(KERN_INFO "Successfully loaded em28xx-dvb\n");
+	em28xx_info("Successfully loaded em28xx-dvb\n");
 	return 0;
 
 out_free:

--------------010805050909040008030701--
