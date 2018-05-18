Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38560 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750763AbeERVJT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 17:09:19 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: kernel@collabora.com, Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH] stk1160: Fix typo s/therwise/Otherwise
Date: Fri, 18 May 2018 18:07:45 -0300
Message-Id: <20180518210748.21983-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a trivial typo.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/usb/stk1160/stk1160-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/stk1160/stk1160-core.c b/drivers/media/usb/stk1160/stk1160-core.c
index bea8bbbb84fb..881ba0283261 100644
--- a/drivers/media/usb/stk1160/stk1160-core.c
+++ b/drivers/media/usb/stk1160/stk1160-core.c
@@ -423,7 +423,7 @@ static void stk1160_disconnect(struct usb_interface *interface)
 
 	/*
 	 * This calls stk1160_release if it's the last reference.
-	 * therwise, release is posponed until there are no users left.
+	 * Otherwise, release is posponed until there are no users left.
 	 */
 	v4l2_device_put(&dev->v4l2_dev);
 }
-- 
2.16.3
