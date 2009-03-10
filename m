Return-path: <linux-media-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.187]:51050 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbZCJINO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 04:13:14 -0400
Received: by mu-out-0910.google.com with SMTP id i10so571425mue.1
        for <linux-media@vger.kernel.org>; Tue, 10 Mar 2009 01:13:12 -0700 (PDT)
Subject: [patch] radio-rtrack2: fix double mutex_unlock
From: Alexey Klimov <klimov.linux@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain
Date: Tue, 10 Mar 2009 11:14:00 +0300
Message-Id: <1236672840.11988.48.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch fixes double mutex unlocking.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r 615fb8f01610 linux/drivers/media/radio/radio-rtrack2.c
--- a/linux/drivers/media/radio/radio-rtrack2.c	Tue Mar 10 02:33:02 2009 -0300
+++ b/linux/drivers/media/radio/radio-rtrack2.c	Tue Mar 10 09:28:27 2009 +0300
@@ -60,7 +60,6 @@
 		return;
 	mutex_lock(&dev->lock);
 	outb(1, dev->io);
-	mutex_unlock(&dev->lock);
 	mutex_unlock(&dev->lock);
 	dev->muted = 1;
 }


-- 
Best regards, Klimov Alexey

