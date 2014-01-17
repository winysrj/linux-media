Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3392 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaAQK1i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jan 2014 05:27:38 -0500
Message-ID: <52D9058F.9010000@xs4all.nl>
Date: Fri, 17 Jan 2014 11:27:27 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] usbvision: drop unused define USBVISION_SAY_AND_WAIT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This define uses the deprecated interruptible_sleep_on_timeout
function. Since this define is unused anyway we just remove it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Arnd Bergmann <arnd@arndb.de>
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
1.8.5.2

