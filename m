Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:59895 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab0C1L3p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Mar 2010 07:29:45 -0400
Date: Sun, 28 Mar 2010 14:29:35 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] video/cx231xx: cleanup. remove unneed null checks
Message-ID: <20100328112935.GQ5069@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"dev" is never NULL here so there is no need to check.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-core.c b/drivers/media/video/cx231xx/cx231xx-core.c
index 4a60dfb..866fb12 100644
--- a/drivers/media/video/cx231xx/cx231xx-core.c
+++ b/drivers/media/video/cx231xx/cx231xx-core.c
@@ -95,10 +95,9 @@ int cx231xx_register_extension(struct cx231xx_ops *ops)
 	mutex_lock(&cx231xx_devlist_mutex);
 	mutex_lock(&cx231xx_extension_devlist_lock);
 	list_add_tail(&ops->next, &cx231xx_extension_devlist);
-	list_for_each_entry(dev, &cx231xx_devlist, devlist) {
-		if (dev)
-			ops->init(dev);
-	}
+	list_for_each_entry(dev, &cx231xx_devlist, devlist)
+		ops->init(dev);
+
 	printk(KERN_INFO DRIVER_NAME ": %s initialized\n", ops->name);
 	mutex_unlock(&cx231xx_extension_devlist_lock);
 	mutex_unlock(&cx231xx_devlist_mutex);
@@ -111,10 +110,8 @@ void cx231xx_unregister_extension(struct cx231xx_ops *ops)
 	struct cx231xx *dev = NULL;
 
 	mutex_lock(&cx231xx_devlist_mutex);
-	list_for_each_entry(dev, &cx231xx_devlist, devlist) {
-		if (dev)
-			ops->fini(dev);
-	}
+	list_for_each_entry(dev, &cx231xx_devlist, devlist)
+		ops->fini(dev);
 
 	mutex_lock(&cx231xx_extension_devlist_lock);
 	printk(KERN_INFO DRIVER_NAME ": %s removed\n", ops->name);
