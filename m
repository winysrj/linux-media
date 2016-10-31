Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:58623 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S945231AbcJaRwc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Oct 2016 13:52:32 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 6/9] [media] redrat3: increase set size for lengths to maximum
Date: Mon, 31 Oct 2016 17:52:24 +0000
Message-Id: <1477936347-9029-7-git-send-email-sean@mess.org>
In-Reply-To: <1477936347-9029-1-git-send-email-sean@mess.org>
References: <1477936347-9029-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In learning mode, you can get much longer messages which can run out
of lengths. The usb message will slightly larger.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/redrat3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 4370d21..12e299f 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -113,7 +113,7 @@
 #define RR3_NARROW_IN_EP_ADDR	0x82
 
 /* Size of the fixed-length portion of the signal */
-#define RR3_DRIVER_MAXLENS	128
+#define RR3_DRIVER_MAXLENS	255
 #define RR3_MAX_SIG_SIZE	512
 #define RR3_TIME_UNIT		50
 #define RR3_END_OF_SIGNAL	0x7f
-- 
2.7.4

