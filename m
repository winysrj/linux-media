Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60852 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbbBSVs0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 16:48:26 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Joe Perches <joe@perches.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH] [media] cx25840: better document the media pads
Date: Thu, 19 Feb 2015 19:48:10 -0200
Message-Id: <409cb3a15152aaa945cbd9e54ad5275152249a89.1424382466.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use an enum to better document the media pads.

No functional changes.

Suggested-by: Prabhakar Lad <prabhakar.csengg@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index 185cb55253c9..bd496447749a 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -5196,9 +5196,9 @@ static int cx25840_probe(struct i2c_client *client,
 	 * However, at least for now, there's no much gain on modelling
 	 * those extra inputs. So, let's add it only when needed.
 	 */
-	state->pads[0].flags = MEDIA_PAD_FL_SINK;	/* Tuner or input */
-	state->pads[1].flags = MEDIA_PAD_FL_SOURCE;	/* Video */
-	state->pads[2].flags = MEDIA_PAD_FL_SOURCE;	/* VBI */
+	state->pads[CX25840_PAD_INPUT].flags = MEDIA_PAD_FL_SINK;
+	state->pads[CX25840_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[CX25840_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
 	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
 
 	ret = media_entity_init(&sd->entity, ARRAY_SIZE(state->pads),
diff --git a/drivers/media/i2c/cx25840/cx25840-core.h b/drivers/media/i2c/cx25840/cx25840-core.h
index 17b409f55445..fdea48ce0c03 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.h
+++ b/drivers/media/i2c/cx25840/cx25840-core.h
@@ -41,6 +41,14 @@ enum cx25840_model {
 	CX25837,
 };
 
+enum cx25840_media_pads {
+	CX25840_PAD_INPUT,
+	CX25840_PAD_VID_OUT,
+	CX25840_PAD_VBI_OUT,
+
+	CX25840_NUM_PADS
+};
+
 struct cx25840_state {
 	struct i2c_client *c;
 	struct v4l2_subdev sd;
@@ -65,7 +73,7 @@ struct cx25840_state {
 	struct work_struct fw_work;   /* work entry for fw load */
 	struct cx25840_ir_state *ir_state;
 #if defined(CONFIG_MEDIA_CONTROLLER)
-	struct media_pad	pads[3];
+	struct media_pad	pads[CX25840_NUM_PADS];
 #endif
 };
 
-- 
2.1.0

