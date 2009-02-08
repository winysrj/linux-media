Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:36634 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbZBHNnV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Feb 2009 08:43:21 -0500
Received: by fg-out-1718.google.com with SMTP id 16so882885fgg.17
        for <linux-media@vger.kernel.org>; Sun, 08 Feb 2009 05:43:19 -0800 (PST)
Subject: [patch review] em28xx-audio: replace printk with em28xx_errdev
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sun, 08 Feb 2009 16:43:28 +0300
Message-Id: <1234100608.10910.16.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,
i hope this patch will be useful.

Probably this change should looks like:

printk(KERN_ERR "em28xx-audio.c:..") but i suppose that em28xx_errdev is
better.

--
Patch removes printk and place em28xx_errdev macros to provide
information about driver name to dmesg.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

---
diff -r 71e5a36634ea linux/drivers/media/video/em28xx/em28xx-audio.c
--- a/linux/drivers/media/video/em28xx/em28xx-audio.c	Mon Feb 02 10:33:31 2009 +0100
+++ b/linux/drivers/media/video/em28xx/em28xx-audio.c	Sun Feb 08 15:28:18 2009 +0300
@@ -254,7 +254,7 @@
 			dev->adev.capture_stream = STREAM_OFF;
 			em28xx_isoc_audio_deinit(dev);
 		} else {
-			printk(KERN_ERR "An underrun very likely occurred. "
+			em28xx_errdev("An underrun very likely occurred. "
 					"Ignoring it.\n");
 		}
 		return 0;



-- 
Best regards, Klimov Alexey

