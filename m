Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58593 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbbFRQKN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2015 12:10:13 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] au0828: Cache the decoder info at au0828 dev structure
Date: Thu, 18 Jun 2015 13:09:36 -0300
Message-Id: <1434643776-25614-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of seeking for the decoder every time analog stream is
started, cache it.

Requested-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-video.c | 37 ++++++++++++++++++---------------
 drivers/media/usb/au0828/au0828.h       |  1 +
 2 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 4ebe13673adf..5f6e2aaad222 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -641,32 +641,35 @@ static int au0828_enable_analog_tuner(struct au0828_dev *dev)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device *mdev = dev->media_dev;
-	struct media_entity  *entity, *decoder = NULL, *source;
+	struct media_entity  *entity, *source;
 	struct media_link *link, *found_link = NULL;
 	int i, ret, active_links = 0;
 
 	if (!mdev)
 		return 0;
 
-	/*
-	 * This will find the tuner that is connected into the decoder.
-	 * Technically, this is not 100% correct, as the device may be
-	 * using an analog input instead of the tuner. However, as we can't
-	 * do DVB streaming while the DMA engine is being used for V4L2,
-	 * this should be enough for the actual needs.
-	 */
-	media_device_for_each_entity(entity, mdev) {
-		if (entity->type == MEDIA_ENT_T_V4L2_SUBDEV_DECODER) {
-			decoder = entity;
-			break;
+	if (!dev->decoder) {
+		/*
+		* This will find the tuner that is connected into the decoder.
+		* Technically, this is not 100% correct, as the device may be
+		* using an analog input instead of the tuner. However, as we
+		* can't do DVB streaming while the DMA engine is being used for
+		* V4L2, this should be enough for the actual needs.
+		*/
+		media_device_for_each_entity(entity, mdev) {
+			if (entity->type == MEDIA_ENT_T_V4L2_SUBDEV_DECODER) {
+				dev->decoder = entity;
+				break;
+			}
 		}
+
+		if (!dev->decoder)
+			return 0;
 	}
-	if (!decoder)
-		return 0;
 
-	for (i = 0; i < decoder->num_links; i++) {
-		link = &decoder->links[i];
-		if (link->sink->entity == decoder) {
+	for (i = 0; i < dev->decoder->num_links; i++) {
+		link = &dev->decoder->links[i];
+		if (link->sink->entity == dev->decoder) {
 			found_link = link;
 			if (link->flags & MEDIA_LNK_FL_ENABLED)
 				active_links++;
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 7e6a3bbc68ab..d3644b3fe6fa 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -280,6 +280,7 @@ struct au0828_dev {
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device *media_dev;
 	struct media_pad video_pad, vbi_pad;
+	struct media_entity *decoder;
 #endif
 };
 
-- 
2.4.3

