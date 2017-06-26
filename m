Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40143
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752136AbdFZMR3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 08:17:29 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: davinci: variable 'common' set but not used
Date: Mon, 26 Jun 2017 09:16:39 -0300
Message-Id: <2ae9c615e40353b09a8d5961c76238f323c9f806.1498479386.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Get rid of those two warnings:
drivers/media/platform/davinci/vpif_capture.c: In function 'vpif_remove':
drivers/media/platform/davinci/vpif_capture.c:1722:21: warning: variable 'common' set but not used [-Wunused-but-set-variable]
  struct common_obj *common;
                     ^~~~~~
drivers/media/platform/davinci/vpif_display.c: In function 'vpif_remove':
drivers/media/platform/davinci/vpif_display.c:1342:21: warning: variable 'common' set but not used [-Wunused-but-set-variable]
  struct common_obj *common;
                     ^~~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/davinci/vpif_capture.c | 2 --
 drivers/media/platform/davinci/vpif_display.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index d78580f9e431..4be6554c56c5 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1719,7 +1719,6 @@ static __init int vpif_probe(struct platform_device *pdev)
  */
 static int vpif_remove(struct platform_device *device)
 {
-	struct common_obj *common;
 	struct channel_obj *ch;
 	int i;
 
@@ -1730,7 +1729,6 @@ static int vpif_remove(struct platform_device *device)
 	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[i];
-		common = &ch->common[VPIF_VIDEO_INDEX];
 		/* Unregister video device */
 		video_unregister_device(&ch->video_dev);
 		kfree(vpif_obj.dev[i]);
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index b5ac6ce626b3..bf982bf86542 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1339,7 +1339,6 @@ static __init int vpif_probe(struct platform_device *pdev)
  */
 static int vpif_remove(struct platform_device *device)
 {
-	struct common_obj *common;
 	struct channel_obj *ch;
 	int i;
 
@@ -1350,7 +1349,6 @@ static int vpif_remove(struct platform_device *device)
 	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[i];
-		common = &ch->common[VPIF_VIDEO_INDEX];
 		/* Unregister video device */
 		video_unregister_device(&ch->video_dev);
 		kfree(vpif_obj.dev[i]);
-- 
2.9.4
