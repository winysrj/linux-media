Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:54795 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750996AbeABVBa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 2 Jan 2018 16:01:30 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/3] media: lirc: add module alias for lirc_dev
Date: Tue,  2 Jan 2018 21:01:27 +0000
Message-Id: <20180102210129.7608-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit a60d64b15c20 ("media: lirc: lirc interface should not be
a raw decoder"), there is no lirc_dev module any more. On Ubuntu 16.10,
the /etc/init.d/lirc startup script attempts to load the lirc_dev module.

Since this module does not exist any more, this script fails. Add an alias
so the correct module is loaded.

Fixes: a60d64b15c20 ("media: lirc: lirc interface should not be a raw decoder")

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/lirc_dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 713d42e4b661..c96543812040 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -815,3 +815,5 @@ void __exit lirc_dev_exit(void)
 	class_destroy(lirc_class);
 	unregister_chrdev_region(lirc_base_dev, RC_DEV_MAX);
 }
+
+MODULE_ALIAS("lirc_dev");
-- 
2.14.3
