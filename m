Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54430 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbbHRUE3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 16:04:29 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC v5 6/8] [media] media: add messages when media device gets (un)registered
Date: Tue, 18 Aug 2015 17:04:19 -0300
Message-Id: <f77b929eedd92943a14390a650dd1699cfda305c.1439927113.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439927113.git.mchehab@osg.samsung.com>
References: <cover.1439927113.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439927113.git.mchehab@osg.samsung.com>
References: <cover.1439927113.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We can only free the media device after being sure that no
graph object is used.

In order to help tracking it, let's add debug messages
that will print when the media controller gets registered
or unregistered.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 7f512223249b..d72d283c4f29 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -357,6 +357,7 @@ static DEVICE_ATTR(model, S_IRUGO, show_model, NULL);
 
 static void media_device_release(struct media_devnode *mdev)
 {
+	dev_dbg(mdev->parent, "Media device released\n");
 }
 
 /**
@@ -395,6 +396,8 @@ int __must_check __media_device_register(struct media_device *mdev,
 		return ret;
 	}
 
+	dev_dbg(mdev->dev, "Media device registered\n");
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(__media_device_register);
@@ -414,6 +417,8 @@ void media_device_unregister(struct media_device *mdev)
 
 	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
 	media_devnode_unregister(&mdev->devnode);
+
+	dev_dbg(mdev->dev, "Media device unregistered\n");
 }
 EXPORT_SYMBOL_GPL(media_device_unregister);
 
-- 
2.4.3

