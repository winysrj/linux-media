Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:36800 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751024AbdJaJhf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 05:37:35 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Songjun Wu <songjun.wu@microchip.com>
Subject: [PATCH] media: atmel-isc: get rid of an unused var
Date: Tue, 31 Oct 2017 05:37:28 -0400
Message-Id: <ec62464e83beacd8b8856e8313a4cae4a91ea90b.1509442643.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/atmel/atmel-isc.c: In function 'isc_async_complete':
drivers/media/platform/atmel/atmel-isc.c:1900:28: warning: variable 'sd_entity' set but not used [-Wunused-but-set-variable]
  struct isc_subdev_entity *sd_entity;
                            ^~~~~~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/atmel/atmel-isc.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index 2c40a7886542..8b37656f035d 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -1897,7 +1897,6 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 {
 	struct isc_device *isc = container_of(notifier->v4l2_dev,
 					      struct isc_device, v4l2_dev);
-	struct isc_subdev_entity *sd_entity;
 	struct video_device *vdev = &isc->video_dev;
 	struct vb2_queue *q = &isc->vb2_vidq;
 	int ret;
@@ -1910,8 +1909,6 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 
 	isc->current_subdev = container_of(notifier,
 					   struct isc_subdev_entity, notifier);
-	sd_entity = isc->current_subdev;
-
 	mutex_init(&isc->lock);
 	init_completion(&isc->comp);
 
-- 
2.13.6
