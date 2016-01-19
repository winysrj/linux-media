Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:54777 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371AbcASSds (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2016 13:33:48 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	chehabrafael@gmail.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] media: au0828 fix enable/disable source compile warns
Date: Tue, 19 Jan 2016 11:33:43 -0700
Message-Id: <191653dd281869ad5e5aded297be86d29eaba345.1453223886.git.shuahkh@osg.samsung.com>
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

 CC [M]  drivers/media/usb/au0828/au0828-core.o
drivers/media/usb/au0828/au0828-core.c:398:12: warning: ‘au0828_enable_source’ defined but not used [-Wunused-function]
 static int au0828_enable_source(struct media_entity *entity,
            ^
drivers/media/usb/au0828/au0828-core.c:497:13: warning: ‘au0828_disable_source’ defined but not used [-Wunused-function]
 static void au0828_disable_source(struct media_entity *entity)
             ^

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index de357a2..7dda0dd 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -395,10 +395,10 @@ void au0828_create_media_graph_notify(struct media_entity *new,
 #endif
 }
 
+#ifdef CONFIG_MEDIA_CONTROLLER
 static int au0828_enable_source(struct media_entity *entity,
 				struct media_pipeline *pipe)
 {
-#ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_entity  *source;
 	struct media_entity *sink;
 	struct media_link *link, *found_link = NULL;
@@ -490,13 +490,10 @@ end:
 	pr_debug("au0828_enable_source() end %s %d %d\n",
 		entity->name, entity->function, ret);
 	return ret;
-#endif
-	return 0;
 }
 
 static void au0828_disable_source(struct media_entity *entity)
 {
-#ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_entity *sink;
 	int ret = 0;
 	struct media_device *mdev = entity->graph_obj.mdev;
@@ -536,8 +533,8 @@ static void au0828_disable_source(struct media_entity *entity)
 
 end:
 	mutex_unlock(&mdev->graph_mutex);
-#endif
 }
+#endif
 
 static int au0828_media_device_register(struct au0828_dev *dev,
 					struct usb_device *udev)
-- 
2.5.0

