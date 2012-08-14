Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46919 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488Ab2HNT4y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 15:56:54 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] anysee: fix compiler warning
Date: Tue, 14 Aug 2012 22:56:19 +0300
Message-Id: <1344974180-19391-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

debug_dump macro was defined twice when CONFIG_DVB_USB_DEBUG was
not set. Move debug_dump macro to correct place.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/anysee.h | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/anysee.h b/drivers/media/usb/dvb-usb-v2/anysee.h
index dc40dcf..834dc12 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.h
+++ b/drivers/media/usb/dvb-usb-v2/anysee.h
@@ -41,19 +41,18 @@
 #ifdef CONFIG_DVB_USB_DEBUG
 #define dprintk(var, level, args...) \
 	do { if ((var & level)) printk(args); } while (0)
-#define DVB_USB_DEBUG_STATUS
-#else
-#define dprintk(args...)
-#define debug_dump(b, l, func)
-#define DVB_USB_DEBUG_STATUS " (debugging is not enabled)"
-#endif
-
 #define debug_dump(b, l, func) {\
 	int loop_; \
 	for (loop_ = 0; loop_ < l; loop_++) \
 		func("%02x ", b[loop_]); \
 	func("\n");\
 }
+#define DVB_USB_DEBUG_STATUS
+#else
+#define dprintk(args...)
+#define debug_dump(b, l, func)
+#define DVB_USB_DEBUG_STATUS " (debugging is not enabled)"
+#endif
 
 #define deb_info(args...) dprintk(dvb_usb_anysee_debug, 0x01, args)
 #define deb_xfer(args...) dprintk(dvb_usb_anysee_debug, 0x02, args)
-- 
1.7.11.2

