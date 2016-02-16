Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53923 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbcBPK3w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2016 05:29:52 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 3/3] [media] siano: use generic function to create MC device
Date: Tue, 16 Feb 2016 08:28:23 -0200
Message-Id: <28611ac2d9fe7b9f2000abd12645714eaec27be8.1455618493.git.mchehab@osg.samsung.com>
In-Reply-To: <57e8ce823fdb89814e1510d9708a2edac9b356e6.1455618493.git.mchehab@osg.samsung.com>
References: <57e8ce823fdb89814e1510d9708a2edac9b356e6.1455618493.git.mchehab@osg.samsung.com>
In-Reply-To: <57e8ce823fdb89814e1510d9708a2edac9b356e6.1455618493.git.mchehab@osg.samsung.com>
References: <57e8ce823fdb89814e1510d9708a2edac9b356e6.1455618493.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, it is initializing the driver name using the wrong
name ("usb"). Use the generic function, as its logic works
best, and avoids repeating the very same code everywhere.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/siano/smsusb.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 8e0c05271a33..4dac499ed28e 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -367,20 +367,10 @@ static void *siano_media_device_register(struct smsusb_device_t *dev,
 	struct sms_board *board = sms_get_board(board_id);
 	int ret;
 
-	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+	mdev = v4l2_mc_usb_media_device_init(udev, board->name);
 	if (!mdev)
 		return NULL;
 
-	mdev->dev = &udev->dev;
-	strlcpy(mdev->model, board->name, sizeof(mdev->model));
-	if (udev->serial)
-		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
-	strcpy(mdev->bus_info, udev->devpath);
-	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
-	mdev->driver_version = LINUX_VERSION_CODE;
-
-	media_device_init(mdev);
-
 	ret = media_device_register(mdev);
 	if (ret) {
 		media_device_cleanup(mdev);
-- 
2.5.0

