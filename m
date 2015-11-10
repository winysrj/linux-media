Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-05v.sys.comcast.net ([96.114.154.164]:46201 "EHLO
	resqmta-po-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751112AbbKJUq7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2015 15:46:59 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, tiwai@suse.de, perex@perex.cz,
	chehabrafael@gmail.com, hans.verkuil@cisco.com,
	prabhakar.csengg@gmail.com, chris.j.arges@canonical.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH MC Next Gen v3 6/6] media: au0828-core fix ignoring return value errors
Date: Tue, 10 Nov 2015 13:40:49 -0700
Message-Id: <296cd8810aa89866df6a8c1d97e228047b1072cf.1447184001.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1447183999.git.shuahkh@osg.samsung.com>
References: <cover.1447183999.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1447183999.git.shuahkh@osg.samsung.com>
References: <cover.1447183999.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the ignoring return value errors found during kbuild bot
compile test.

drivers/media/usb/au0828/au0828-core.c:298:5: warning: ignoring
return value of 'media_create_pad_link', declared with attribute
warn_unused_result [-Wunused-result]

drivers/media/usb/au0828/au0828-core.c:356:2: warning: ignoring
return value of 'media_device_register_entity_notify', declared
with attribute warn_unused_result [-Wunused-result]

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 3ef6fee..5b595a6 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -299,15 +299,20 @@ void au0828_create_media_graph(struct media_entity *new, void *notify_data)
 				if (!tuner)
 					break;
 
-				media_create_pad_link(ent, 0, tuner,
-						      TUNER_PAD_RF_INPUT,
-						      MEDIA_LNK_FL_ENABLED);
+				ret = media_create_pad_link(ent, 0, tuner,
+							TUNER_PAD_RF_INPUT,
+							MEDIA_LNK_FL_ENABLED);
+				if (ret)
+					pr_err("Create pad link err %d\n", ret);
 				break;
 			case AU0828_VMUX_COMPOSITE:
 			case AU0828_VMUX_SVIDEO:
 			default: /* AU0828_VMUX_DEBUG */
 				/* FIXME: fix the decoder PAD */
-				media_create_pad_link(ent, 0, decoder, 0, 0);
+				ret = media_create_pad_link(ent, 0, decoder,
+							    0, 0);
+				if (ret)
+					pr_err("Create pad link err %d\n", ret);
 				break;
 			}
 		}
@@ -504,7 +509,13 @@ static void au0828_media_device_register(struct au0828_dev *dev,
 	/* register entity_notify callback */
 	dev->entity_notify.notify_data = (void *) dev;
 	dev->entity_notify.notify = au0828_create_media_graph;
-	media_device_register_entity_notify(mdev, &dev->entity_notify);
+	ret = media_device_register_entity_notify(mdev, &dev->entity_notify);
+	if (ret) {
+		dev_err(&udev->dev,
+			"Couldn't register entity_notify handler. Error: %d\n",
+			ret);
+		return;
+	}
 
 	/* set enable_source */
 	mdev->source_priv = (void *) dev;
-- 
2.5.0

