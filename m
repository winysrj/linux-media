Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.221.174]:37163 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbZI1Qnf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Sep 2009 12:43:35 -0400
Received: by qyk4 with SMTP id 4so3387595qyk.33
        for <linux-media@vger.kernel.org>; Mon, 28 Sep 2009 09:43:38 -0700 (PDT)
Message-ID: <4AC0E7B0.3010409@gmail.com>
Date: Mon, 28 Sep 2009 13:43:28 -0300
From: Filipe Rosset <rosset.filipe@gmail.com>
Reply-To: rosset.filipe@gmail.com
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Subject: Re: [PATCH 2/2] em28xx: Convert printks to em28xx_err and em28xx_info
References: <4AC0D05D.4060304@gmail.com>	 <829197380909280824q487c3effp64914d8430f16092@mail.gmail.com>	 <4AC0E21F.1000301@gmail.com> <829197380909280923r28452c44j610ffdcccf3f5d38@mail.gmail.com>
In-Reply-To: <829197380909280923r28452c44j610ffdcccf3f5d38@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------000902070800040508090007"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000902070800040508090007
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Em 28-09-2009 13:23, Devin Heitmueller escreveu:
> 
> Filipe,
> 
> Your updated patch is going to effectively print dev->name twice.
> Please look at the definition of em28xx_errdev() and resubmit an
> updated patch that takes this into account.
> 
> Thanks,
> 
> Devin
> 

Hi Devin,

I now resend correct patch.
Sorry for inconvenience.
Thanks,

Filipe

--------------000902070800040508090007
Content-Type: text/plain;
 name="Convert_printks_to_em28xx_err_and_em28xx_info.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Convert_printks_to_em28xx_err_and_em28xx_info.diff"

diff -r cbf8899e0fd4 linux/drivers/media/video/em28xx/em28xx-dvb.c
--- a/linux/drivers/media/video/em28xx/em28xx-dvb.c	Mon Sep 28 11:22:23 2009 -0300
+++ b/linux/drivers/media/video/em28xx/em28xx-dvb.c	Mon Sep 28 13:37:46 2009 -0300
@@ -314,22 +314,20 @@
 	cfg.i2c_addr  = addr;
 
 	if (!dev->dvb->frontend) {
-		printk(KERN_ERR "%s/2: dvb frontend not attached. "
-				"Can't attach xc3028\n",
-		       dev->name);
+		em28xx_errdev("/2: dvb frontend not attached. "
+				"Can't attach xc3028\n");
 		return -EINVAL;
 	}
 
 	fe = dvb_attach(xc2028_attach, dev->dvb->frontend, &cfg);
 	if (!fe) {
-		printk(KERN_ERR "%s/2: xc3028 attach failed\n",
-		       dev->name);
+		em28xx_errdev("/2: xc3028 attach failed\n");
 		dvb_frontend_detach(dev->dvb->frontend);
 		dev->dvb->frontend = NULL;
 		return -EINVAL;
 	}
 
-	printk(KERN_INFO "%s/2: xc3028 attached\n", dev->name);
+	em28xx_info("%s/2: xc3028 attached\n", dev->name);
 
 	return 0;
 }
@@ -464,7 +462,7 @@
 	dvb = kzalloc(sizeof(struct em28xx_dvb), GFP_KERNEL);
 
 	if (dvb == NULL) {
-		printk(KERN_INFO "em28xx_dvb: memory allocation failed\n");
+		em28xx_info("em28xx_dvb: memory allocation failed\n");
 		return -ENOMEM;
 	}
 	dev->dvb = dvb;
@@ -570,15 +568,12 @@
 		}
 		break;
 	default:
-		printk(KERN_ERR "%s/2: The frontend of your DVB/ATSC card"
-				" isn't supported yet\n",
-		       dev->name);
+		em28xx_errdev("/2: The frontend of your DVB/ATSC card"
+				" isn't supported yet\n");
 		break;
 	}
 	if (NULL == dvb->frontend) {
-		printk(KERN_ERR
-		       "%s/2: frontend initialization failed\n",
-		       dev->name);
+		em28xx_errdev("/2: frontend initialization failed\n");
 		result = -EINVAL;
 		goto out_free;
 	}
@@ -592,7 +587,7 @@
 		goto out_free;
 
 	em28xx_set_mode(dev, EM28XX_SUSPEND);
-	printk(KERN_INFO "Successfully loaded em28xx-dvb\n");
+	em28xx_info("Successfully loaded em28xx-dvb\n");
 	return 0;
 
 out_free:

--------------000902070800040508090007--
