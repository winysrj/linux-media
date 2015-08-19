Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38108 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbbHSLDo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2015 07:03:44 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v6 6/8] [media] media: add messages when media device gets (un)registered
Date: Wed, 19 Aug 2015 08:01:53 -0300
Message-Id: <f07fdec54485863d0db5710845d680f34709686b.1439981515.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439981515.git.mchehab@osg.samsung.com>
References: <cover.1439981515.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439981515.git.mchehab@osg.samsung.com>
References: <cover.1439981515.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We can only free the media device after being sure that no
graph object is used.

In order to help tracking it, let's add debug messages
that will print when the media controller gets registered
or unregistered.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 065f6f08da37..0f3844470147 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -359,6 +359,7 @@ static DEVICE_ATTR(model, S_IRUGO, show_model, NULL);
 
 static void media_device_release(struct media_devnode *mdev)
 {
+	dev_dbg(mdev->parent, "Media device released\n");
 }
 
 /**
@@ -397,6 +398,8 @@ int __must_check __media_device_register(struct media_device *mdev,
 		return ret;
 	}
 
+	dev_dbg(mdev->dev, "Media device registered\n");
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(__media_device_register);
@@ -416,6 +419,8 @@ void media_device_unregister(struct media_device *mdev)
 
 	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
 	media_devnode_unregister(&mdev->devnode);
+
+	dev_dbg(mdev->dev, "Media device unregistered\n");
 }
 EXPORT_SYMBOL_GPL(media_device_unregister);
 
-- 
2.4.3

