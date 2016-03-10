Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:33207 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbcCJCPn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2016 21:15:43 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	chehabrafael@gmail.com, javier@osg.samsung.com,
	inki.dae@samsung.com, sw0312.kim@samsung.com,
	jh1009.sung@samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: au0828 disable tuner to demod link in au0828_media_device_register()
Date: Wed,  9 Mar 2016 19:15:38 -0700
Message-Id: <1457576138-8728-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Disable tuner to demod link in au0828_media_device_register(). This step
should be done after dvb graph is created.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c  | 26 ++++++++++++++++++++++++++
 drivers/media/usb/au0828/au0828-video.c | 20 +-------------------
 2 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 7fc3dba..5dc82e8 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -456,6 +456,7 @@ static int au0828_media_device_register(struct au0828_dev *dev,
 {
 #ifdef CONFIG_MEDIA_CONTROLLER
 	int ret;
+	struct media_entity *entity, *demod = NULL, *tuner = NULL;
 
 	if (!dev->media_dev)
 		return 0;
@@ -479,6 +480,31 @@ static int au0828_media_device_register(struct au0828_dev *dev,
 		*/
 		au0828_media_graph_notify(NULL, (void *) dev);
 	}
+
+	/*
+	 * Find tuner and demod to disable the link between
+	 * the two to avoid disable step when tuner is requested
+	 * by video or audio. Note that this step can't be done
+	 * until dvb graph is created during dvb register.
+	*/
+	media_device_for_each_entity(entity, dev->media_dev) {
+		if (entity->function == MEDIA_ENT_F_DTV_DEMOD)
+			demod = entity;
+		else if (entity->function == MEDIA_ENT_F_TUNER)
+			tuner = entity;
+	}
+	/* Disable link between tuner and demod */
+	if (tuner && demod) {
+		struct media_link *link;
+
+		list_for_each_entry(link, &demod->links, list) {
+			if (link->sink->entity == demod &&
+			    link->source->entity == tuner) {
+				media_entity_setup_link(link, 0);
+			}
+		}
+	}
+
 	/* register entity_notify callback */
 	dev->entity_notify.notify_data = (void *) dev;
 	dev->entity_notify.notify = (void *) au0828_media_graph_notify;
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 5f7c8be..aeaf27e 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -657,7 +657,7 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device *mdev = dev->media_dev;
 	struct media_entity *entity;
-	struct media_entity *tuner = NULL, *decoder = NULL, *demod = NULL;
+	struct media_entity *tuner = NULL, *decoder = NULL;
 	int i, ret;
 
 	if (!mdev)
@@ -671,9 +671,6 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 		case MEDIA_ENT_F_ATV_DECODER:
 			decoder = entity;
 			break;
-		case MEDIA_ENT_F_DTV_DEMOD:
-			demod = entity;
-			break;
 		}
 	}
 
@@ -729,21 +726,6 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 			break;
 		}
 	}
-
-	/*
-	 * Disable tuner to demod link to avoid disable step
-	 * when tuner is requested by video or audio
-	*/
-	if (tuner && demod) {
-		struct media_link *link;
-
-		list_for_each_entry(link, &demod->links, list) {
-			if (link->sink->entity == demod &&
-			    link->source->entity == tuner) {
-				media_entity_setup_link(link, 0);
-			}
-		}
-	}
 #endif
 	return 0;
 }
-- 
2.5.0

