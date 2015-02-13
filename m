Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49474 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbbBMW6W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 17:58:22 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Joe Perches <joe@perches.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCHv4 16/25] [media] cx25840: fill the media controller entity
Date: Fri, 13 Feb 2015 20:57:59 -0200
Message-Id: <6e028daf7da0bb15af4ff03290a2a67b7b35515c.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of keeping the media controller entity not initialized,
fill it and create the pads for cx25840.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index 573e08826b9b..bdb5bb6b58da 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -5137,6 +5137,9 @@ static int cx25840_probe(struct i2c_client *client,
 	int default_volume;
 	u32 id;
 	u16 device_id;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	int ret;
+#endif
 
 	/* Check if the adapter supports the needed features */
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
@@ -5178,6 +5181,21 @@ static int cx25840_probe(struct i2c_client *client,
 
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &cx25840_ops);
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	/* TODO: need to represent analog inputs too */
+	state->pads[0].flags = MEDIA_PAD_FL_SINK;	/* Tuner or input */
+	state->pads[1].flags = MEDIA_PAD_FL_SOURCE;	/* Video */
+	state->pads[2].flags = MEDIA_PAD_FL_SOURCE;	/* VBI */
+	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
+
+	ret = media_entity_init(&sd->entity, ARRAY_SIZE(state->pads),
+				state->pads, 0);
+	if (ret < 0) {
+		v4l_info(client, "failed to initialize media entity!\n");
+		kfree(state);
+		return -ENODEV;
+	}
+#endif
 
 	switch (id) {
 	case CX23885_AV:
diff --git a/drivers/media/i2c/cx25840/cx25840-core.h b/drivers/media/i2c/cx25840/cx25840-core.h
index 37bc04217c44..17b409f55445 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.h
+++ b/drivers/media/i2c/cx25840/cx25840-core.h
@@ -64,6 +64,9 @@ struct cx25840_state {
 	wait_queue_head_t fw_wait;    /* wake up when the fw load is finished */
 	struct work_struct fw_work;   /* work entry for fw load */
 	struct cx25840_ir_state *ir_state;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_pad	pads[3];
+#endif
 };
 
 static inline struct cx25840_state *to_state(struct v4l2_subdev *sd)
-- 
2.1.0

