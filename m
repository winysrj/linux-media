Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42386 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892AbcA2MML (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2016 07:12:11 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 10/13] [media] msp3400: initialize MC data
Date: Fri, 29 Jan 2016 10:11:00 -0200
Message-Id: <546c6e1b38369f754e0a6e5f795a45c3a1a4bf11.1454067262.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454067262.git.mchehab@osg.samsung.com>
References: <cover.1454067262.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454067262.git.mchehab@osg.samsung.com>
References: <cover.1454067262.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add pads and set the device type when used with the media
controller.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/i2c/msp3400-driver.c | 14 ++++++++++++++
 drivers/media/i2c/msp3400-driver.h |  5 +++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/media/i2c/msp3400-driver.c b/drivers/media/i2c/msp3400-driver.c
index a84561d0d4a8..e016626ebf89 100644
--- a/drivers/media/i2c/msp3400-driver.c
+++ b/drivers/media/i2c/msp3400-driver.c
@@ -688,6 +688,9 @@ static int msp_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	int msp_revision;
 	int msp_product, msp_prod_hi, msp_prod_lo;
 	int msp_rom;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	int ret;
+#endif
 
 	if (!id)
 		strlcpy(client->name, "msp3400", sizeof(client->name));
@@ -704,6 +707,17 @@ static int msp_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &msp_ops);
 
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	state->pads[IF_AUD_DEC_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+	state->pads[IF_AUD_DEC_PAD_OUT].flags = MEDIA_PAD_FL_SOURCE;
+
+	sd->entity.function = MEDIA_ENT_F_IF_AUD_DECODER;
+
+	ret = media_entity_pads_init(&sd->entity, 2, state->pads);
+	if (ret < 0)
+		return ret;
+#endif
+
 	state->v4l2_std = V4L2_STD_NTSC;
 	state->detected_std = V4L2_STD_ALL;
 	state->audmode = V4L2_TUNER_MODE_STEREO;
diff --git a/drivers/media/i2c/msp3400-driver.h b/drivers/media/i2c/msp3400-driver.h
index 6cae21366ed5..f0bb37dc9013 100644
--- a/drivers/media/i2c/msp3400-driver.h
+++ b/drivers/media/i2c/msp3400-driver.h
@@ -7,6 +7,7 @@
 #include <media/drv-intf/msp3400.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-mc.h>
 
 /* ---------------------------------------------------------------------- */
 
@@ -102,6 +103,10 @@ struct msp_state {
 	wait_queue_head_t    wq;
 	unsigned int         restart:1;
 	unsigned int         watch_stereo:1;
+
+#if CONFIG_MEDIA_CONTROLLER
+	struct media_pad pads[IF_AUD_DEC_PAD_NUM_PADS];
+#endif
 };
 
 static inline struct msp_state *to_state(struct v4l2_subdev *sd)
-- 
2.5.0


