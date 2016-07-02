Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35618 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbcGBM7B (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jul 2016 08:59:01 -0400
Received: by mail-pf0-f195.google.com with SMTP id t190so12280571pfb.2
        for <linux-media@vger.kernel.org>; Sat, 02 Jul 2016 05:59:00 -0700 (PDT)
Received: from Aayush-PC ([117.197.17.3])
        by smtp.gmail.com with ESMTPSA id o193sm5148322pfo.12.2016.07.02.05.58.58
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Sat, 02 Jul 2016 05:58:59 -0700 (PDT)
Date: Sat, 2 Jul 2016 18:28:53 +0530
From: Aayush Gupta <aayustark007@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] drivers: staging: media: lirc: lirc_parallel: Fix multiline
 comments by adding trailing '*'
Message-ID: <20160702125849.GA29808@Aayush-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Aayush Gupta <aayustark007@gmail.com>
---
 drivers/staging/media/lirc/lirc_parallel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_parallel.c b/drivers/staging/media/lirc/lirc_parallel.c
index 68ede6c..3906ac6 100644
--- a/drivers/staging/media/lirc/lirc_parallel.c
+++ b/drivers/staging/media/lirc/lirc_parallel.c
@@ -305,9 +305,9 @@ static void lirc_lirc_irq_handler(void *blah)
 
 	/* enable interrupt */
 	/*
-	  enable_irq(irq);
-	  out(LIRC_PORT_IRQ, in(LIRC_PORT_IRQ)|LP_PINTEN);
-	*/
+	 * enable_irq(irq);
+	 * out(LIRC_PORT_IRQ, in(LIRC_PORT_IRQ)|LP_PINTEN);
+	 */
 }
 
 /*** file operations ***/
@@ -620,7 +620,7 @@ static void kf(void *handle)
 	lirc_off();
 	/* this is a bit annoying when you actually print...*/
 	/*
-	printk(KERN_INFO "%s: reclaimed port\n", LIRC_DRIVER_NAME);
+	 * printk(KERN_INFO "%s: reclaimed port\n", LIRC_DRIVER_NAME);
 	*/
 }
 
-- 
1.9.1

