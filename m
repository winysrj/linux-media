Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34824 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbcBLJqb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 04:46:31 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 06/11] [media] v4l2-mc: use usb_make_path() to provide bus info
Date: Fri, 12 Feb 2016 07:45:01 -0200
Message-Id: <9b8fed2b73514df87fced36481f84a0a745b674d.1455269986.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1455269986.git.mchehab@osg.samsung.com>
References: <cover.1455269986.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1455269986.git.mchehab@osg.samsung.com>
References: <cover.1455269986.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Report the bus info on the same way as VIDIOC_QUERYCAP. Also,
currently, it is reporting just PORT/DEV.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/v4l2-core/v4l2-mc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index 649972e87621..ab5e42a86cc5 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -79,7 +79,7 @@ struct media_device * __v4l2_mc_usb_media_device_init(struct usb_device *udev,
 		strlcpy(mdev->model, "unknown model", sizeof(mdev->model));
 	if (udev->serial)
 		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
-	strcpy(mdev->bus_info, udev->devpath);
+	usb_make_path(udev, mdev->bus_info, sizeof(mdev->bus_info));
 	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
 	mdev->driver_version = LINUX_VERSION_CODE;
 
-- 
2.5.0


