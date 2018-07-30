Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45927 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbeG3K7S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 06:59:18 -0400
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH 3/3] media: usb: em28xx: Replace GFP_ATOMIC with GFP_KERNEL in em28xx_init_usb_xfer()
Date: Mon, 30 Jul 2018 17:25:07 +0800
Message-Id: <20180730092507.7902-1-baijiaju1990@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

em28xx_init_usb_xfer() is never called in atomic context.
It calls usb_submit_urb() with GFP_ATOMIC, which is not necessary.
GFP_ATOMIC can be replaced with GFP_KERNEL.

This is found by a static analysis tool named DCNS written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/media/usb/em28xx/em28xx-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 36d341fb65dd..4a2ba6132a90 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -1053,7 +1053,7 @@ int em28xx_init_usb_xfer(struct em28xx *dev, enum em28xx_mode mode,
 
 	/* submit urbs and enables IRQ */
 	for (i = 0; i < usb_bufs->num_bufs; i++) {
-		rc = usb_submit_urb(usb_bufs->urb[i], GFP_ATOMIC);
+		rc = usb_submit_urb(usb_bufs->urb[i], GFP_KERNEL);
 		if (rc) {
 			dev_err(&dev->intf->dev,
 				"submit of urb %i failed (error=%i)\n", i, rc);
-- 
2.17.0
