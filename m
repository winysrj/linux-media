Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:39296 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbcCMD5o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Mar 2016 22:57:44 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	chehabrafael@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: au0828 fix to clear enable/disable/change source handlers
Date: Sat, 12 Mar 2016 20:57:40 -0700
Message-Id: <1457841460-6042-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix to clear enable/disable/change source handlers in the media device
when media device is unregistered in au0828_unregister_media_device().
When au0828 module is removed, snd-usb-audio shouldn't call the handlers.
Clearing will ensure snd-usb-audio won't call them once au0828 is removed.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index de9ab11..abdb956 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -137,6 +137,12 @@ static void au0828_unregister_media_device(struct au0828_dev *dev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 	if (dev->media_dev &&
 		media_devnode_is_registered(&dev->media_dev->devnode)) {
+		/* clear enable_source, disable_source, change_source */
+		dev->media_dev->source_priv = NULL;
+		dev->media_dev->enable_source = NULL;
+		dev->media_dev->disable_source = NULL;
+		dev->media_dev->change_source = NULL;
+
 		media_device_unregister(dev->media_dev);
 		media_device_cleanup(dev->media_dev);
 		dev->media_dev = NULL;
-- 
2.5.0

