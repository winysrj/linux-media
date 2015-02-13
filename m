Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49456 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbbBMW6V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 17:58:21 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCHv4 15/25] [media] tuner-core: properly initialize media controller subdev
Date: Fri, 13 Feb 2015 20:57:58 -0200
Message-Id: <5c8a3752af88ba4c349d9d2416cad937f96a0423.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Properly initialize tuner core subdev at the media controller.

That requires a new subtype at the media controller API.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index 559f8372e2eb..9a83b27a7e8f 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -134,6 +134,9 @@ struct tuner {
 	unsigned int        type; /* chip type id */
 	void                *config;
 	const char          *name;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_pad	pad;
+#endif
 };
 
 /*
@@ -434,6 +437,8 @@ static void set_type(struct i2c_client *c, unsigned int type,
 		t->name = analog_ops->info.name;
 	}
 
+	t->sd.entity.name = t->name;
+
 	tuner_dbg("type set to %s\n", t->name);
 
 	t->mode_mask = new_mode_mask;
@@ -592,6 +597,9 @@ static int tuner_probe(struct i2c_client *client,
 	struct tuner *t;
 	struct tuner *radio;
 	struct tuner *tv;
+#ifdef CONFIG_MEDIA_CONTROLLER
+	int ret;
+#endif
 
 	t = kzalloc(sizeof(struct tuner), GFP_KERNEL);
 	if (NULL == t)
@@ -684,6 +692,18 @@ static int tuner_probe(struct i2c_client *client,
 
 	/* Should be just before return */
 register_client:
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	t->pad.flags = MEDIA_PAD_FL_SOURCE;
+	t->sd.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_TUNER;
+	t->sd.entity.name = t->name;
+
+	ret = media_entity_init(&t->sd.entity, 1, &t->pad, 0);
+	if (ret < 0) {
+		tuner_err("failed to initialize media entity!\n");
+		kfree(t);
+		return -ENODEV;
+	}
+#endif
 	/* Sets a default mode */
 	if (t->mode_mask & T_ANALOG_TV)
 		t->mode = V4L2_TUNER_ANALOG_TV;
-- 
2.1.0

