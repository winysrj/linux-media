Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:64998 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab3BXWt5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Feb 2013 17:49:57 -0500
Received: by mail-pb0-f43.google.com with SMTP id md12so1329659pbc.30
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2013 14:49:56 -0800 (PST)
From: Syam Sidhardhan <syamsidhardh@gmail.com>
To: linux-media@vger.kernel.org
Cc: syamsidhardh@gmail.com, mchehab@redhat.com
Subject: [PATCH] hdpvr: Fix memory leak
Date: Mon, 25 Feb 2013 04:19:43 +0530
Message-Id: <1361746183-28763-1-git-send-email-s.syam@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes the print_buf leaking.

Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
---
 drivers/media/usb/hdpvr/hdpvr-core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
index 5c61935..73195fe 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -196,6 +196,7 @@ static int device_authorization(struct hdpvr_device *dev)
 	hex_dump_to_buffer(response, 8, 16, 1, print_buf, 5*buf_size+1, 0);
 	v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev, " response: %s\n",
 		 print_buf);
+	kfree(print_buf);
 #endif
 
 	msleep(100);
-- 
1.7.9.5

