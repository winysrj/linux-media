Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:47899 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816AbcCULdI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 07:33:08 -0400
Subject: [PATCH] drivers/media/rc: postpone kfree(rc_dev)
From: Max Kellermann <max@duempel.org>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Date: Mon, 21 Mar 2016 12:33:05 +0100
Message-ID: <145855998541.9135.18170484612406448203.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CONFIG_DEBUG_KOBJECT_RELEASE found this bug.
---
 drivers/media/rc/rc-main.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 1042fa3..cb3e8db 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1248,6 +1248,9 @@ unlock:
 
 static void rc_dev_release(struct device *device)
 {
+	struct rc_dev *dev = to_rc_dev(device);
+
+	kfree(dev);
 }
 
 #define ADD_HOTPLUG_VAR(fmt, val...)					\
@@ -1369,7 +1372,9 @@ void rc_free_device(struct rc_dev *dev)
 
 	put_device(&dev->dev);
 
-	kfree(dev);
+	/* kfree(dev) will be called by the callback function
+	   rc_dev_release() */
+
 	module_put(THIS_MODULE);
 }
 EXPORT_SYMBOL_GPL(rc_free_device);

