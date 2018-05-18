Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38562 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751320AbeERVJV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 17:09:21 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: kernel@collabora.com, Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH] stk1160: Add missing calls to mutex_destroy
Date: Fri, 18 May 2018 18:07:46 -0300
Message-Id: <20180518210748.21983-2-ezequiel@collabora.com>
In-Reply-To: <20180518210748.21983-1-ezequiel@collabora.com>
References: <20180518210748.21983-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mutexes are not being destroyed in the release path. Fix it.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/usb/stk1160/stk1160-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/stk1160/stk1160-core.c b/drivers/media/usb/stk1160/stk1160-core.c
index 881ba0283261..72bd893c9659 100644
--- a/drivers/media/usb/stk1160/stk1160-core.c
+++ b/drivers/media/usb/stk1160/stk1160-core.c
@@ -167,6 +167,8 @@ static void stk1160_release(struct v4l2_device *v4l2_dev)
 
 	v4l2_ctrl_handler_free(&dev->ctrl_handler);
 	v4l2_device_unregister(&dev->v4l2_dev);
+	mutex_destroy(&dev->v4l_lock);
+	mutex_destroy(&dev->vb_queue_lock);
 	kfree(dev->alt_max_pkt_size);
 	kfree(dev);
 }
-- 
2.16.3
