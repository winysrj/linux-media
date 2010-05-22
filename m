Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f183.google.com ([209.85.221.183]:39929 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab0EVTyY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 May 2010 15:54:24 -0400
Date: Sat, 22 May 2010 21:53:27 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] em28xx: remove unneeded null checks
Message-ID: <20100522194854.GH22515@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The "dev" variable is used as a list cursor in a list_for_each_entry()
loop and can never be null here so I removed the check.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
index 331e1ca..44c63cb 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -1186,8 +1186,7 @@ int em28xx_register_extension(struct em28xx_ops *ops)
 	mutex_lock(&em28xx_devlist_mutex);
 	list_add_tail(&ops->next, &em28xx_extension_devlist);
 	list_for_each_entry(dev, &em28xx_devlist, devlist) {
-		if (dev)
-			ops->init(dev);
+		ops->init(dev);
 	}
 	printk(KERN_INFO "Em28xx: Initialized (%s) extension\n", ops->name);
 	mutex_unlock(&em28xx_devlist_mutex);
@@ -1201,10 +1200,8 @@ void em28xx_unregister_extension(struct em28xx_ops *ops)
 
 	mutex_lock(&em28xx_devlist_mutex);
 	list_for_each_entry(dev, &em28xx_devlist, devlist) {
-		if (dev)
-			ops->fini(dev);
+		ops->fini(dev);
 	}
-
 	printk(KERN_INFO "Em28xx: Removed (%s) extension\n", ops->name);
 	list_del(&ops->next);
 	mutex_unlock(&em28xx_devlist_mutex);
