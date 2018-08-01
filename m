Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56490 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389907AbeHARln (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 13:41:43 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 06/13] media: au8522: declare its own pads
Date: Wed,  1 Aug 2018 12:55:08 -0300
Message-Id: <727ba77c1e3fe51af8fadd6029291886f42176c1.1533138685.git.mchehab+samsung@kernel.org>
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
 drivers/media/dvb-frontends/au8522_decoder.c | 12 ++++++------
 drivers/media/dvb-frontends/au8522_priv.h    |  9 ++++++++-
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index 583fdaa7339f..b2dd20ffd002 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -718,12 +718,12 @@ static int au8522_probe(struct i2c_client *client,
 	v4l2_i2c_subdev_init(sd, client, &au8522_ops);
 #if defined(CONFIG_MEDIA_CONTROLLER)
 
-	state->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
-	state->pads[DEMOD_PAD_IF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
-	state->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	state->pads[DEMOD_PAD_VID_OUT].sig_type = PAD_SIGNAL_DV;
-	state->pads[DEMOD_PAD_AUDIO_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	state->pads[DEMOD_PAD_AUDIO_OUT].sig_type = PAD_SIGNAL_AUDIO;
+	state->pads[AU8522_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+	state->pads[AU8522_PAD_IF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
+	state->pads[AU8522_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[AU8522_PAD_VID_OUT].sig_type = PAD_SIGNAL_DV;
+	state->pads[AU8522_PAD_AUDIO_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[AU8522_PAD_AUDIO_OUT].sig_type = PAD_SIGNAL_AUDIO;
 	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
 
 	ret = media_entity_pads_init(&sd->entity, ARRAY_SIZE(state->pads),
diff --git a/drivers/media/dvb-frontends/au8522_priv.h b/drivers/media/dvb-frontends/au8522_priv.h
index 2043c1744753..68299d2705f7 100644
--- a/drivers/media/dvb-frontends/au8522_priv.h
+++ b/drivers/media/dvb-frontends/au8522_priv.h
@@ -40,6 +40,13 @@
 #define AU8522_DIGITAL_MODE 1
 #define AU8522_SUSPEND_MODE 2
 
+enum au8522_pads {
+	AU8522_PAD_IF_INPUT,
+	AU8522_PAD_VID_OUT,
+	AU8522_PAD_AUDIO_OUT,
+	AU8522_NUM_PADS
+};
+
 struct au8522_state {
 	struct i2c_client *c;
 	struct i2c_adapter *i2c;
@@ -71,7 +78,7 @@ struct au8522_state {
 	struct v4l2_ctrl_handler hdl;
 
 #ifdef CONFIG_MEDIA_CONTROLLER
-	struct media_pad pads[DEMOD_NUM_PADS];
+	struct media_pad pads[AU8522_NUM_PADS];
 #endif
 };
 
-- 
2.17.1
