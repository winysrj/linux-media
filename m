Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42398 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903AbcA2MML (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2016 07:12:11 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 12/13] [media] saa7115: initialize demod type and add the needed pads
Date: Fri, 29 Jan 2016 10:11:02 -0200
Message-Id: <9d43a652d74861f335fb904b1aba1e095efc4885.1454067262.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454067262.git.mchehab@osg.samsung.com>
References: <cover.1454067262.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454067262.git.mchehab@osg.samsung.com>
References: <cover.1454067262.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The saa7115 driver is used on several em28xx-based devices.
Now that we're about to add MC support to em28xx, we need to
be sure that the saa711x demod will be properly mapped at MC.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/i2c/saa7115.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index 24d2b76dbe97..d2a1ce2bc7f5 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -46,6 +46,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-mc.h>
 #include <media/i2c/saa7115.h>
 #include <asm/div64.h>
 
@@ -74,6 +75,9 @@ enum saa711x_model {
 
 struct saa711x_state {
 	struct v4l2_subdev sd;
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_pad pads[DEMOD_NUM_PADS];
+#endif
 	struct v4l2_ctrl_handler hdl;
 
 	struct {
@@ -1809,6 +1813,9 @@ static int saa711x_probe(struct i2c_client *client,
 	struct saa7115_platform_data *pdata;
 	int ident;
 	char name[CHIP_VER_SIZE + 1];
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	int ret;
+#endif
 
 	/* Check if the adapter supports the needed features */
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
@@ -1832,6 +1839,18 @@ static int saa711x_probe(struct i2c_client *client,
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &saa711x_ops);
 
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	state->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+	state->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[DEMOD_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
+
+	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
+
+	ret = media_entity_pads_init(&sd->entity, DEMOD_NUM_PADS, state->pads);
+	if (ret < 0)
+		return ret;
+#endif
+
 	v4l_info(client, "%s found @ 0x%x (%s)\n", name,
 		 client->addr << 1, client->adapter->name);
 	hdl = &state->hdl;
-- 
2.5.0


