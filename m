Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37500 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbcCJT5v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2016 14:57:51 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH] [media] au0828: disable tuner->decoder on init
Date: Thu, 10 Mar 2016 16:57:44 -0300
Message-Id: <436107c4db642cdab28d3f26ccc918f3c6e52e38.1457639860.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As au0828 assumes that all links to ATV decoder and DTV demod
should be disabled, make sure this is the case.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 5dc82e8c8670..af68663915fd 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -456,7 +456,9 @@ static int au0828_media_device_register(struct au0828_dev *dev,
 {
 #ifdef CONFIG_MEDIA_CONTROLLER
 	int ret;
-	struct media_entity *entity, *demod = NULL, *tuner = NULL;
+	struct media_entity *entity;
+	struct media_entity *demod = NULL, *tuner = NULL, *decoder = NULL;
+	struct media_link *link;
 
 	if (!dev->media_dev)
 		return 0;
@@ -490,18 +492,19 @@ static int au0828_media_device_register(struct au0828_dev *dev,
 	media_device_for_each_entity(entity, dev->media_dev) {
 		if (entity->function == MEDIA_ENT_F_DTV_DEMOD)
 			demod = entity;
+		else if (entity->function == MEDIA_ENT_F_ATV_DECODER)
+			decoder = entity;
 		else if (entity->function == MEDIA_ENT_F_TUNER)
 			tuner = entity;
 	}
-	/* Disable link between tuner and demod */
-	if (tuner && demod) {
-		struct media_link *link;
 
-		list_for_each_entry(link, &demod->links, list) {
-			if (link->sink->entity == demod &&
-			    link->source->entity == tuner) {
+	/* Disable link between tuner->demod and/or tuner->decoder */
+	if (tuner) {
+		list_for_each_entry(link, &tuner->links, list) {
+			if (demod && link->sink->entity == demod)
+				media_entity_setup_link(link, 0);
+			if (decoder && link->sink->entity == decoder)
 				media_entity_setup_link(link, 0);
-			}
 		}
 	}
 
-- 
2.5.0

