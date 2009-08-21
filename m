Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpbg65.qq.com ([119.147.10.224]:58320 "HELO smtpbg65.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751933AbZHUCuk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2009 22:50:40 -0400
Subject: [PATCH] em28xx: Don't call em28xx_ir_init when disable_ir is true
From: Shine Liu <shinel@foxmail.com>
Reply-To: shinel@foxmail.com
To: linux-media@vger.kernel.org
Cc: dheitmueller@kernellabs.com
Content-Type: text/plain
Date: Fri, 21 Aug 2009 10:49:26 +0800
Message-Id: <1250822966.5248.6.camel@shinel>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I think we should call em28xx_ir_init(dev) when disable_ir is true.
Following patch will fix the bug. 

Cheers,

Shine



Signed-off-by: Shine Liu <shinel@foxmail.com>
-----------------------------------------------------


--- a/drivers/media/video/em28xx/em28xx-cards.c	2009-08-14 06:43:34.000000000 +0800
+++ a/drivers/media/video/em28xx/em28xx-cards.c	2009-08-21 10:39:23.000000000 +0800
@@ -2367,7 +2367,9 @@
 	}
 
 	em28xx_tuner_setup(dev);
-	em28xx_ir_init(dev);
+
+	if(!disable_ir)
+		em28xx_ir_init(dev);
 }
 
 



