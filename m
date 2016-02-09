Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40771 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbcBIPth (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2016 10:49:37 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH] [media] au0828: only create V4L2 graph if V4L2 is registered
Date: Tue,  9 Feb 2016 13:48:13 -0200
Message-Id: <3a61444b9edbcb05dab9d5e6c6703e13ca6dbe3d.1455032887.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It doesn't make sense to try to create the analog TV graph,
if the device fails to register at V4L2, or if it doesn't have
V4L2 support.

Thanks to Shuah for pointing this issue.

Reported-by: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index df2bc3f732b6..0a8afbf181c9 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -419,8 +419,21 @@ static int au0828_usb_probe(struct usb_interface *interface,
 
 #ifdef CONFIG_VIDEO_AU0828_V4L2
 	/* Analog TV */
-	if (AUVI_INPUT(0).type != AU0828_VMUX_UNDEFINED)
-		au0828_analog_register(dev, interface);
+	if (AUVI_INPUT(0).type != AU0828_VMUX_UNDEFINED) {
+		retval = au0828_analog_register(dev, interface);
+		if (retval) {
+			pr_err("%s() au0282_dev_register failed to register on V4L2\n",
+			       __func__);
+			goto done;
+		}
+
+		retval = au0828_create_media_graph(dev);
+		if (retval) {
+			pr_err("%s() au0282_dev_register failed to create graph\n",
+			       __func__);
+			goto done;
+		}
+	}
 #endif
 
 	/* Digital TV */
@@ -443,13 +456,6 @@ static int au0828_usb_probe(struct usb_interface *interface,
 
 	mutex_unlock(&dev->lock);
 
-	retval = au0828_create_media_graph(dev);
-	if (retval) {
-		pr_err("%s() au0282_dev_register failed to create graph\n",
-		       __func__);
-		goto done;
-	}
-
 #ifdef CONFIG_MEDIA_CONTROLLER
 	retval = media_device_register(dev->media_dev);
 #endif
-- 
2.5.0

