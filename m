Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:61068 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab3CETkv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2013 14:40:51 -0500
Received: by mail-pb0-f41.google.com with SMTP id um15so4913272pbc.0
        for <linux-media@vger.kernel.org>; Tue, 05 Mar 2013 11:40:50 -0800 (PST)
From: Syam Sidhardhan <syamsidhardh@gmail.com>
To: linux-media@vger.kernel.org
Cc: syamsidhardh@gmail.com, tvboxspy@gmail.com, mchehab@redhat.com
Subject: [PATCH] lmedm04: Remove redundant NULL check before kfree
Date: Wed,  6 Mar 2013 01:10:39 +0530
Message-Id: <1362512439-3914-1-git-send-email-s.syam@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kfree on NULL pointer is a no-op.

Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
---
 drivers/media/usb/dvb-usb-v2/lmedm04.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index 96804be..b3fd0ff 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -1302,8 +1302,7 @@ static void lme2510_exit(struct dvb_usb_device *d)
 
 	if (d != NULL) {
 		usb_buffer = lme2510_exit_int(d);
-		if (usb_buffer != NULL)
-			kfree(usb_buffer);
+		kfree(usb_buffer);
 	}
 }
 
-- 
1.7.9.5

