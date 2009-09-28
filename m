Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.247]:25758 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbZI1PDp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Sep 2009 11:03:45 -0400
Received: by an-out-0708.google.com with SMTP id d40so4914340and.1
        for <linux-media@vger.kernel.org>; Mon, 28 Sep 2009 08:03:49 -0700 (PDT)
Message-ID: <4AC0D046.5000701@gmail.com>
Date: Mon, 28 Sep 2009 12:03:34 -0300
From: Filipe Rosset <rosset.filipe@gmail.com>
Reply-To: rosset.filipe@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Douglas Schilling Landgraf <dougsland@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/2] em28xx: Convert printks to em28xx_err
Content-Type: multipart/mixed;
 boundary="------------040404080003010507030501"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040404080003010507030501
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


--------------040404080003010507030501
Content-Type: text/plain;
 name="Convert_printks_to_em28xx_err.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Convert_printks_to_em28xx_err.diff"

em28xx: Convert printks to em28xx_err

From: Filipe Rosset <rosset.filipe@gmail.com>

Convert printks to em28xx_err

Priority: normal

Signed-off-by: Filipe Rosset <rosset.filipe@gmail.com>

diff -r 6b7617d4a0be linux/drivers/media/video/em28xx/em28xx-audio.c
--- a/linux/drivers/media/video/em28xx/em28xx-audio.c	Sat Sep 26 13:45:03 2009 -0300
+++ b/linux/drivers/media/video/em28xx/em28xx-audio.c	Mon Sep 28 10:49:25 2009 -0300
@@ -335,7 +335,7 @@
 	dprintk("opening device and trying to acquire exclusive lock\n");
 
 	if (!dev) {
-		printk(KERN_ERR "BUG: em28xx can't find device struct."
+		em28xx_err("BUG: em28xx can't find device struct."
 				" Can't proceed with open\n");
 		return -ENODEV;
 	}
@@ -367,7 +367,7 @@
 
 	return 0;
 err:
-	printk(KERN_ERR "Error while configuring em28xx mixer\n");
+	em28xx_err("Error while configuring em28xx mixer\n");
 	return ret;
 }
 


--------------040404080003010507030501--
