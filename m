Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:35906 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756186Ab0BKPDn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2010 10:03:43 -0500
Message-ID: <4B741C47.1090905@zerezo.com>
Date: Thu, 11 Feb 2010 16:03:35 +0100
From: Antoine Jacquet <royale@zerezo.com>
MIME-Version: 1.0
To: thomas.schorpp@gmail.com
CC: linux-media@vger.kernel.org
Subject: Re: zr364xx: Aiptek DV8800 (neo): 08ca:2062: Fails on subsequent
 zr364xx_open()
References: <4B73C792.3060907@gmail.com>
In-Reply-To: <4B73C792.3060907@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------080201010105040805080809"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080201010105040805080809
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Thomas,

> Looks like the device does not like to be fed with the (full) init 
> METHOD2 on every open()...
> Since the VIDIOC_QUERYCAP worked it should not be the wrong METHOD.

Someone reported similar behavior recently, and was apparently able to 
fix the issue by adding more delay between open/close sequences.

Could you try the attached patch to see if it solves the issue?

If not, we can also try to add some mdelay() after each usb_control_msg().

Regards,

Antoine

-- 
Antoine "Royale" Jacquet
http://royale.zerezo.com

--------------080201010105040805080809
Content-Type: text/x-patch;
 name="zr364xx-mdelay.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="zr364xx-mdelay.patch"

diff -r 77e731753c15 linux/drivers/media/video/zr364xx.c
--- a/linux/drivers/media/video/zr364xx.c	Thu Feb 11 12:02:16 2010 -0200
+++ b/linux/drivers/media/video/zr364xx.c	Thu Feb 11 16:01:44 2010 +0100
@@ -1005,7 +1005,7 @@
 	/* Added some delay here, since opening/closing the camera quickly,
 	 * like Ekiga does during its startup, can crash the webcam
 	 */
-	mdelay(100);
+	mdelay(200);
 	cam->skip = 2;
 	ret = 0;
 
@@ -1310,7 +1310,7 @@
 	/* Added some delay here, since opening/closing the camera quickly,
 	 * like Ekiga does during its startup, can crash the webcam
 	 */
-	mdelay(100);
+	mdelay(200);
 	err = 0;
 
 out:
@@ -1396,7 +1396,7 @@
 	/* Added some delay here, since opening/closing the camera quickly,
 	 * like Ekiga does during its startup, can crash the webcam
 	 */
-	mdelay(100);
+	mdelay(200);
 	err = 0;
 
 out:

--------------080201010105040805080809--
