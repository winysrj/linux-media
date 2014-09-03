Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44392 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbaICUdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 36/46] [media] media-devnode: just return 0 instead of using a var
Date: Wed,  3 Sep 2014 17:33:08 -0300
Message-Id: <a0d927bd402638cbdf1dc86314ee5363b1b7e4ab.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of allocating a var to store 0 and just return it,
change the code to return 0 directly.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index 7acd19c881de..ebf9626e5ae5 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -192,7 +192,6 @@ static int media_open(struct inode *inode, struct file *filp)
 static int media_release(struct inode *inode, struct file *filp)
 {
 	struct media_devnode *mdev = media_devnode_data(filp);
-	int ret = 0;
 
 	if (mdev->fops->release)
 		mdev->fops->release(filp);
@@ -201,7 +200,7 @@ static int media_release(struct inode *inode, struct file *filp)
 	   return value is ignored. */
 	put_device(&mdev->dev);
 	filp->private_data = NULL;
-	return ret;
+	return 0;
 }
 
 static const struct file_operations media_devnode_fops = {
-- 
1.9.3

