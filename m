Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.130]:52065 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbaBZLCp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 06:02:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 06/16] [media] usbvision: drop unused define USBVISION_SAY_AND_WAIT
Date: Wed, 26 Feb 2014 12:01:46 +0100
Message-Id: <1393412516-3762435-7-git-send-email-arnd@arndb.de>
In-Reply-To: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
References: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This define uses the deprecated interruptible_sleep_on_timeout
function. Since this define is unused anyway we just remove it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/usb/usbvision/usbvision.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision.h b/drivers/media/usb/usbvision/usbvision.h
index 8a25876..a0c73cf 100644
--- a/drivers/media/usb/usbvision/usbvision.h
+++ b/drivers/media/usb/usbvision/usbvision.h
@@ -203,14 +203,6 @@ enum {
 	mr = LIMIT_RGB(mm_r); \
 }
 
-/* Debugging aid */
-#define USBVISION_SAY_AND_WAIT(what) { \
-	wait_queue_head_t wq; \
-	init_waitqueue_head(&wq); \
-	printk(KERN_INFO "Say: %s\n", what); \
-	interruptible_sleep_on_timeout(&wq, HZ * 3); \
-}
-
 /*
  * This macro checks if usbvision is still operational. The 'usbvision'
  * pointer must be valid, usbvision->dev must be valid, we are not
-- 
1.8.3.2

