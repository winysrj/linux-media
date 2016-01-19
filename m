Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:54781 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932664AbcASSds (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2016 13:33:48 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	chehabrafael@gmail.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] media: au0828 fix au0828_media_device_register warn
Date: Tue, 19 Jan 2016 11:33:44 -0700
Message-Id: <a7c4fbb02cbaf70d0e1a80374c79c48d9a5093ce.1453223886.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1453223886.git.shuahkh@osg.samsung.com>
References: <cover.1453223886.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1453223886.git.shuahkh@osg.samsung.com>
References: <cover.1453223886.git.shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following compile warns for MEDIA_CONTROLLER
disabled case.

drivers/media/usb/au0828/au0828-core.c:539:12: warning: ‘au0828_media_device_register’ defined but not used [-Wunused-function]
 static int au0828_media_device_register(struct au0828_dev *dev,

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 7dda0dd..d25f7ac 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -536,10 +536,10 @@ end:
 }
 #endif
 
+#ifdef CONFIG_MEDIA_CONTROLLER
 static int au0828_media_device_register(struct au0828_dev *dev,
 					struct usb_device *udev)
 {
-#ifdef CONFIG_MEDIA_CONTROLLER
 	int ret;
 
 	if (!dev->media_dev)
@@ -570,9 +570,9 @@ static int au0828_media_device_register(struct au0828_dev *dev,
 	dev->media_dev->source_priv = (void *) dev;
 	dev->media_dev->enable_source = au0828_enable_source;
 	dev->media_dev->disable_source = au0828_disable_source;
-#endif
 	return 0;
 }
+#endif
 
 static int au0828_usb_probe(struct usb_interface *interface,
 	const struct usb_device_id *id)
-- 
2.5.0

