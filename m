Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:55019 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729733AbeKFBU2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Nov 2018 20:20:28 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] media: rc: ensure close() is called on rc_unregister_device
Date: Mon,  5 Nov 2018 16:00:06 +0000
Message-Id: <20181105160006.22926-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If userspace has an open file descriptor on the rc input device or lirc
device when rc_unregister_device() is called, then the rc close() is
never called.

This ensures that the receiver is turned off on the nuvoton-cir driver
during shutdown.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 552bbe82a160..8863da4204a3 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1950,6 +1950,8 @@ void rc_unregister_device(struct rc_dev *dev)
 	rc_free_rx_device(dev);
 
 	mutex_lock(&dev->lock);
+	if (dev->users && dev->close)
+		dev->close(dev);
 	dev->registered = false;
 	mutex_unlock(&dev->lock);
 
-- 
2.17.2
