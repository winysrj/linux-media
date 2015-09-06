Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53892 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbbIFRbk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 13:31:40 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>, Shuah Khan <shuahkh@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 03/18] [media] au0828: Create connector links
Date: Sun,  6 Sep 2015 14:30:46 -0300
Message-Id: <4923da11ff58d4b4dbfd0bc0c56392e7410c4b4c.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that connectors are entities, we need to represent the
connector links.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index fe9a60484343..35c607c35155 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -257,6 +257,7 @@ static void au0828_create_media_graph(struct au0828_dev *dev)
 	struct media_device *mdev = dev->media_dev;
 	struct media_entity *entity;
 	struct media_entity *tuner = NULL, *decoder = NULL;
+	int i;
 
 	if (!mdev)
 		return;
@@ -274,6 +275,7 @@ static void au0828_create_media_graph(struct au0828_dev *dev)
 
 	/* Analog setup, using tuner as a link */
 
+	/* Something bad happened! */
 	if (!decoder)
 		return;
 
@@ -284,6 +286,30 @@ static void au0828_create_media_graph(struct au0828_dev *dev)
 			      MEDIA_LNK_FL_ENABLED);
 	media_create_pad_link(decoder, 2, &dev->vbi_dev.entity, 0,
 			      MEDIA_LNK_FL_ENABLED);
+
+	for (i = 0; i < AU0828_MAX_INPUT; i++) {
+		struct media_entity *ent = &dev->input_ent[i];
+
+		if (AUVI_INPUT(i).type == AU0828_VMUX_UNDEFINED)
+			break;
+
+		switch(AUVI_INPUT(i).type) {
+		case AU0828_VMUX_CABLE:
+		case AU0828_VMUX_TELEVISION:
+		case AU0828_VMUX_DVB:
+			if (tuner)
+				media_create_pad_link(ent, 0, tuner,
+						      TUNER_PAD_RF_INPUT,
+						      MEDIA_LNK_FL_ENABLED);
+			break;
+		case AU0828_VMUX_COMPOSITE:
+		case AU0828_VMUX_SVIDEO:
+		default: /* AU0828_VMUX_DEBUG */
+			/* FIXME: fix the decoder PAD */
+			media_create_pad_link(ent, 0, decoder, 0, 0);
+			break;
+		}
+	}
 #endif
 }
 
-- 
2.4.3


