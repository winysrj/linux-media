Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:54076 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZEYBWA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 May 2009 21:22:00 -0400
Received: by ewy24 with SMTP id 24so2826062ewy.37
        for <linux-media@vger.kernel.org>; Sun, 24 May 2009 18:22:00 -0700 (PDT)
Date: Mon, 25 May 2009 11:22:41 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: [PATCH] Change order for FM tune.
Message-ID: <20090525112241.41a8f67b@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/FB3ntZ/KCUQzTybw0=RI9ip"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/FB3ntZ/KCUQzTybw0=RI9ip
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All.

Change order data of buffer in FM simple_tune function. It is usefull for:

1. Set data of tuner with CP bit UP. 0xCE for MK5 or 0xC6 for MK3
2. When call simple_fm_tune, read this byte from config and overwrite 
this byte in function simple_radio_bandswitch for set CP bit to OFF.

Of course it can be usefull for other tuner for overwrite default settings of FM.

diff -r 315bc4b65b4f linux/drivers/media/common/tuners/tuner-simple.c
--- a/linux/drivers/media/common/tuners/tuner-simple.c	Sun May 17 12:28:55 2009 +0000
+++ b/linux/drivers/media/common/tuners/tuner-simple.c	Mon May 25 05:45:39 2009 +1000
@@ -698,11 +698,11 @@
 		return 0;
 	}
 
+	buffer[2] = (t_params->ranges[0].config & ~TUNER_RATIO_MASK) |
+		    TUNER_RATIO_SELECT_50; /* 50 kHz step */
+
 	/* Bandswitch byte */
 	simple_radio_bandswitch(fe, &buffer[0]);
-
-	buffer[2] = (t_params->ranges[0].config & ~TUNER_RATIO_MASK) |
-		    TUNER_RATIO_SELECT_50; /* 50 kHz step */
 
 	/* Convert from 1/16 kHz V4L steps to 1/20 MHz (=50 kHz) PLL steps
 	   freq * (1 Mhz / 16000 V4L steps) * (20 PLL steps / 1 MHz) =

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

With my best regards, Dmitry.
--MP_/FB3ntZ/KCUQzTybw0=RI9ip
Content-Type: text/x-patch; name=fm_tune_order.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=fm_tune_order.patch

diff -r 315bc4b65b4f linux/drivers/media/common/tuners/tuner-simple.c
--- a/linux/drivers/media/common/tuners/tuner-simple.c	Sun May 17 12:28:55 2009 +0000
+++ b/linux/drivers/media/common/tuners/tuner-simple.c	Mon May 25 05:45:39 2009 +1000
@@ -698,11 +698,11 @@
 		return 0;
 	}
 
+	buffer[2] = (t_params->ranges[0].config & ~TUNER_RATIO_MASK) |
+		    TUNER_RATIO_SELECT_50; /* 50 kHz step */
+
 	/* Bandswitch byte */
 	simple_radio_bandswitch(fe, &buffer[0]);
-
-	buffer[2] = (t_params->ranges[0].config & ~TUNER_RATIO_MASK) |
-		    TUNER_RATIO_SELECT_50; /* 50 kHz step */
 
 	/* Convert from 1/16 kHz V4L steps to 1/20 MHz (=50 kHz) PLL steps
 	   freq * (1 Mhz / 16000 V4L steps) * (20 PLL steps / 1 MHz) =

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>
--MP_/FB3ntZ/KCUQzTybw0=RI9ip--
