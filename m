Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:36410 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754070AbeCGJt4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2018 04:49:56 -0500
From: Johan Hovold <johan@kernel.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH] [media] cpia2_usb: drop bogus interface-release call
Date: Wed,  7 Mar 2018 10:49:36 +0100
Message-Id: <20180307094936.9140-1-johan@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Drop bogus call to usb_driver_release_interface() from the disconnect()
callback. As the interface is already being unbound at this point,
usb_driver_release_interface() simply returns early.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/usb/cpia2/cpia2_usb.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/usb/cpia2/cpia2_usb.c b/drivers/media/usb/cpia2/cpia2_usb.c
index f3a1e5b1e57c..b51fc372ca25 100644
--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -910,9 +910,6 @@ static void cpia2_usb_disconnect(struct usb_interface *intf)
 		wake_up_interruptible(&cam->wq_stream);
 	}
 
-	DBG("Releasing interface\n");
-	usb_driver_release_interface(&cpia2_driver, intf);
-
 	LOG("CPiA2 camera disconnected.\n");
 }
 
-- 
2.16.2
