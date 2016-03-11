Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47169 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932579AbcCKPzX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 10:55:23 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 1/2] [media] au0828: disable tuner links and cache tuner/decoder
Date: Fri, 11 Mar 2016 12:55:15 -0300
Message-Id: <d14f3141901856eaed358ab049f4a3aac8fe4863.1457711514.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For au0828_enable_source() to work, the tuner links should be
disabled and the tuner/decoder should be cached at au0828 struct.

Fixes: 9822f4173f84 ('[media] au0828: use v4l2_mc_create_media_graph()')
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 42 ++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 5dc82e8c8670..ecfa18939663 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -456,7 +456,8 @@ static int au0828_media_device_register(struct au0828_dev *dev,
 {
 #ifdef CONFIG_MEDIA_CONTROLLER
 	int ret;
-	struct media_entity *entity, *demod = NULL, *tuner = NULL;
+	struct media_entity *entity, *demod = NULL;
+	struct media_link *link;
 
 	if (!dev->media_dev)
 		return 0;
@@ -482,26 +483,37 @@ static int au0828_media_device_register(struct au0828_dev *dev,
 	}
 
 	/*
-	 * Find tuner and demod to disable the link between
-	 * the two to avoid disable step when tuner is requested
-	 * by video or audio. Note that this step can't be done
-	 * until dvb graph is created during dvb register.
+	 * Find tuner, decoder and demod.
+	 *
+	 * The tuner and decoder should be cached, as they'll be used by
+	 *	au0828_enable_source.
+	 *
+	 * It also needs to disable the link between tuner and
+	 * decoder/demod, to avoid disable step when tuner is requested
+	 * by video or audio. Note that this step can't be done until dvb
+	 * graph is created during dvb register.
 	*/
 	media_device_for_each_entity(entity, dev->media_dev) {
-		if (entity->function == MEDIA_ENT_F_DTV_DEMOD)
+		switch (entity->function) {
+		case MEDIA_ENT_F_TUNER:
+			dev->tuner = entity;
+			break;
+		case MEDIA_ENT_F_ATV_DECODER:
+			dev->decoder = entity;
+			break;
+		case MEDIA_ENT_F_DTV_DEMOD:
 			demod = entity;
-		else if (entity->function == MEDIA_ENT_F_TUNER)
-			tuner = entity;
+			break;
+		}
 	}
-	/* Disable link between tuner and demod */
-	if (tuner && demod) {
-		struct media_link *link;
 
-		list_for_each_entry(link, &demod->links, list) {
-			if (link->sink->entity == demod &&
-			    link->source->entity == tuner) {
+	/* Disable link between tuner->demod and/or tuner->decoder */
+	if (dev->tuner) {
+		list_for_each_entry(link, &dev->tuner->links, list) {
+			if (demod && link->sink->entity == demod)
+				media_entity_setup_link(link, 0);
+			if (dev->decoder && link->sink->entity == dev->decoder)
 				media_entity_setup_link(link, 0);
-			}
 		}
 	}
 
-- 
2.5.0

