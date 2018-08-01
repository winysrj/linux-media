Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56482 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389895AbeHARln (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 13:41:43 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 11/13] media: saa7134: declare its own pads
Date: Wed,  1 Aug 2018 12:55:13 -0300
Message-Id: <e289c8513f444ed97924837088a8a1332e1687b1.1533138685.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1533138685.git.mchehab+samsung@kernel.org>
References: <cover.1533138685.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1533138685.git.mchehab+samsung@kernel.org>
References: <cover.1533138685.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we don't need anymore to share pad numbers with similar
drivers, use its own pad definition instead of a global
model.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/pci/saa7134/saa7134-core.c | 10 +++++-----
 drivers/media/pci/saa7134/saa7134.h      |  8 +++++++-
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index c4e2df197bf9..8984b1bf57a5 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -845,13 +845,13 @@ static void saa7134_create_entities(struct saa7134_dev *dev)
 	 */
 	if (!decoder) {
 		dev->demod.name = "saa713x";
-		dev->demod_pad[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
-		dev->demod_pad[DEMOD_PAD_IF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
-		dev->demod_pad[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
-		dev->demod_pad[DEMOD_PAD_VID_OUT].sig_type = PAD_SIGNAL_DV;
+		dev->demod_pad[SAA7134_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+		dev->demod_pad[SAA7134_PAD_IF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
+		dev->demod_pad[SAA7134_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
+		dev->demod_pad[SAA7134_PAD_VID_OUT].sig_type = PAD_SIGNAL_DV;
 		dev->demod.function = MEDIA_ENT_F_ATV_DECODER;
 
-		ret = media_entity_pads_init(&dev->demod, DEMOD_NUM_PADS,
+		ret = media_entity_pads_init(&dev->demod, SAA7134_NUM_PADS,
 					     dev->demod_pad);
 		if (ret < 0)
 			pr_err("failed to initialize demod pad!\n");
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index d99e937a98c1..ac05a38aa728 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -547,6 +547,12 @@ struct saa7134_mpeg_ops {
 						  unsigned long status);
 };
 
+enum saa7134_pads {
+       SAA7134_PAD_IF_INPUT,
+       SAA7134_PAD_VID_OUT,
+       SAA7134_NUM_PADS
+};
+
 /* global device status */
 struct saa7134_dev {
 	struct list_head           devlist;
@@ -674,7 +680,7 @@ struct saa7134_dev {
 	struct media_pad input_pad[SAA7134_INPUT_MAX + 1];
 
 	struct media_entity demod;
-	struct media_pad demod_pad[DEMOD_NUM_PADS];
+	struct media_pad demod_pad[SAA7134_NUM_PADS];
 
 	struct media_pad video_pad, vbi_pad;
 	struct media_entity *decoder;
-- 
2.17.1
