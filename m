Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:46158 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbcCCDiX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2016 22:38:23 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	chehabrafael@gmail.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: au0828 audio mixer isn't connected to decoder
Date: Wed,  2 Mar 2016 20:38:19 -0700
Message-Id: <1456976299-7525-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When snd_usb_audio gets probed first, audio mixer
doesn't get linked to the decoder.

Change au0828_media_graph_notify() to handle the
mixer entity getting registered before the decoder.

Change au0828_media_device_register() to invoke
au0828_media_graph_notify() to connect entites
that were created prior to registering the notify
handler.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
Reported-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---

Tested by black listing au0828 to force
snd_usb_audio to load first and then modprobe
au0828. Generated graphs to verify audio graph
is connected to the au0828 graph.
 
 drivers/media/usb/au0828/au0828-core.c | 54 ++++++++++++++++++++++++++++------
 1 file changed, 45 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index ca1e5eb..5821de4 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -211,23 +211,50 @@ static void au0828_media_graph_notify(struct media_entity *new,
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct au0828_dev *dev = (struct au0828_dev *) notify_data;
 	int ret;
+	struct media_entity *entity, *mixer = NULL, *decoder = NULL;
 
-	if (!dev->decoder)
-		return;
+	if (!new) {
+		/*
+		 * Called during au0828 probe time to connect
+		 * entites that were created prior to registering
+		 * the notify handler. Find mixer and decoder.
+		*/
+		media_device_for_each_entity(entity, dev->media_dev) {
+			if (entity->function == MEDIA_ENT_F_AUDIO_MIXER)
+				mixer = entity;
+			else if (entity->function == MEDIA_ENT_F_ATV_DECODER)
+				decoder = entity;
+		}
+		goto create_link;
+	}
 
 	switch (new->function) {
 	case MEDIA_ENT_F_AUDIO_MIXER:
-		ret = media_create_pad_link(dev->decoder,
+		mixer = new;
+		if (dev->decoder)
+			decoder = dev->decoder;
+		break;
+	case MEDIA_ENT_F_ATV_DECODER:
+		/* In case, Mixer is added first, find mixer and create link */
+		media_device_for_each_entity(entity, dev->media_dev) {
+			if (entity->function == MEDIA_ENT_F_AUDIO_MIXER)
+				mixer = entity;
+		}
+		decoder = new;
+		break;
+	default:
+		break;
+	}
+
+create_link:
+	if (decoder && mixer) {
+		ret = media_create_pad_link(decoder,
 					    AU8522_PAD_AUDIO_OUT,
-					    new, 0,
+					    mixer, 0,
 					    MEDIA_LNK_FL_ENABLED);
 		if (ret)
 			dev_err(&dev->usbdev->dev,
-				"Mixer Pad Link Create Error: %d\n",
-				ret);
-		break;
-	default:
-		break;
+				"Mixer Pad Link Create Error: %d\n", ret);
 	}
 #endif
 }
@@ -447,6 +474,15 @@ static int au0828_media_device_register(struct au0828_dev *dev,
 				"Media Device Register Error: %d\n", ret);
 			return ret;
 		}
+	} else {
+		/*
+		 * Call au0828_media_graph_notify() to connect
+		 * audio graph to our graph. In this case, audio
+		 * driver registered the device and there is no
+		 * entity_notify to be called when new entities
+		 * are added. Invoke it now.
+		*/
+		au0828_media_graph_notify(NULL, (void *) dev);
 	}
 	/* register entity_notify callback */
 	dev->entity_notify.notify_data = (void *) dev;
-- 
2.5.0

