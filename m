Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57315 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697AbcCaSmw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2016 14:42:52 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 2/2] [media] Revert "[media] media: au0828 change to use Managed Media Controller API"
Date: Thu, 31 Mar 2016 15:41:53 -0300
Message-Id: <405ddbfa68177b6169d09bc2308a39196a8eb64a.1459449687.git.mchehab@osg.samsung.com>
In-Reply-To: <c89178f57a19300b2056f58167e183e966a4836d.1459449687.git.mchehab@osg.samsung.com>
References: <c89178f57a19300b2056f58167e183e966a4836d.1459449687.git.mchehab@osg.samsung.com>
In-Reply-To: <c89178f57a19300b2056f58167e183e966a4836d.1459449687.git.mchehab@osg.samsung.com>
References: <c89178f57a19300b2056f58167e183e966a4836d.1459449687.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extending the lifetime of the media_device struct is not handled well
by the core, as it will erase some data from the struct, when
media_device_cleanup() is called after unregistering it.

While we have a fixup patch for it already, the usage of those new
functions are needed only when we share data with other drivers.

So, better to revert the changes.

This reverts commit 182dde7c5d4c ("[media] media: au0828 change
to use Managed Media Controller API")

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index a40958ad8341..cc22b32776ad 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -144,6 +144,7 @@ static void au0828_unregister_media_device(struct au0828_dev *dev)
 
 		media_device_unregister(dev->media_dev);
 		media_device_cleanup(dev->media_dev);
+		kfree(dev->media_dev);
 		dev->media_dev = NULL;
 	}
 #endif
@@ -197,7 +198,7 @@ static int au0828_media_device_init(struct au0828_dev *dev,
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device *mdev;
 
-	mdev = media_device_get_devres(&udev->dev);
+	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
 	if (!mdev)
 		return -ENOMEM;
 
-- 
2.5.5

