Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:41533 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab3CFUoz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 15:44:55 -0500
Received: by mail-pb0-f50.google.com with SMTP id up1so6547548pbc.37
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2013 12:44:54 -0800 (PST)
From: syamsidhardh@gmail.com
To: linux-media@vger.kernel.org
Cc: syamsidhardh@gmail.com, tvboxspy@gmail.com, mchehab@redhat.com,
	Syam Sidhardhan <s.syam@samsung.com>
Subject: [PATCH v1] lmedm04: Remove redundant NULL check before kfree
Date: Thu,  7 Mar 2013 02:14:46 +0530
Message-Id: <1362602686-7196-1-git-send-email-s.syam@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Syam Sidhardhan <s.syam@samsung.com>

kfree on NULL pointer is a no-op.

Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
---
v1 -> Corrected the from address

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

