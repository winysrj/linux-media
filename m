Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60425 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbbHTJzD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2015 05:55:03 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>
Subject: [PATCH] au0828: Fix the logic that enables the analog demoder link
Date: Thu, 20 Aug 2015 06:54:55 -0300
Message-Id: <da46c7fe0cb195e80f5b6128820c8f72bea9f8e2.1440064488.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This logic was broken on the original patch, likely due to a
cut-and-paste mistake.

Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index a9087f05b29a..4511e2893282 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -641,7 +641,7 @@ static int au0828_enable_analog_tuner(struct au0828_dev *dev)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device *mdev = dev->media_dev;
-	struct media_entity  *entity, *source;
+	struct media_entity *source;
 	struct media_link *link, *found_link = NULL;
 	int ret, active_links = 0;
 
@@ -674,7 +674,7 @@ static int au0828_enable_analog_tuner(struct au0828_dev *dev)
 
 		sink = link->sink->entity;
 
-		if (sink == entity)
+		if (sink == dev->decoder)
 			flags = MEDIA_LNK_FL_ENABLED;
 
 		ret = media_entity_setup_link(link, flags);
-- 
2.4.3

