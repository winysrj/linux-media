Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37465 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbbLJRhr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2015 12:37:47 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>
Subject: [PATCH] [media] au0828: postpone call to au0828_unregister_media_device()
Date: Thu, 10 Dec 2015 15:37:35 -0200
Message-Id: <7fd2ea99f6035067fbebbfbfd55db002ece483c8.1449769050.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DVB core needs to unregister the media device. So, we
can't call au0828_unregister_media_device() before calling
au0828_dvb_unregister(), otherwise the DVB MC free code
(that will be implemented on the next patch) will fail.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index ee20f4354ba2..e7ebb5e638be 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -178,8 +178,6 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
 	*/
 	dev->dev_state = DEV_DISCONNECTED;
 
-	au0828_unregister_media_device(dev);
-
 	au0828_rc_unregister(dev);
 	/* Digital TV */
 	au0828_dvb_unregister(dev);
@@ -193,6 +191,10 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
 		au0828_analog_unregister(dev);
 		v4l2_device_disconnect(&dev->v4l2_dev);
 		v4l2_device_put(&dev->v4l2_dev);
+		/*
+		 * No need to call au0828_usb_release() if V4L2 is enabled,
+		 * as this is already called via au0828_usb_v4l2_release()
+		 */
 		return;
 	}
 #endif
-- 
2.5.0

