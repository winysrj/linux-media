Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:52209 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaABMIH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jan 2014 07:08:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH, RFC 06/30] [media] usbvision: remove bogus sleep_on_timeout
Date: Thu,  2 Jan 2014 13:07:30 +0100
Message-Id: <1388664474-1710039-7-git-send-email-arnd@arndb.de>
In-Reply-To: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no reason to use sleep_on_timeout here, and we want to get
rid of that interface. Use the simpler msleep_interruptible instead.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/usb/usbvision/usbvision.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision.h b/drivers/media/usb/usbvision/usbvision.h
index 8a25876..eb6dc8a 100644
--- a/drivers/media/usb/usbvision/usbvision.h
+++ b/drivers/media/usb/usbvision/usbvision.h
@@ -205,10 +205,8 @@ enum {
 
 /* Debugging aid */
 #define USBVISION_SAY_AND_WAIT(what) { \
-	wait_queue_head_t wq; \
-	init_waitqueue_head(&wq); \
 	printk(KERN_INFO "Say: %s\n", what); \
-	interruptible_sleep_on_timeout(&wq, HZ * 3); \
+	msleep_interruptible(3000); \
 }
 
 /*
-- 
1.8.3.2

