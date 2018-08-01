Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56468 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389825AbeHARln (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 13:41:43 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 07/13] media: msp3400: declare its own pads
Date: Wed,  1 Aug 2018 12:55:09 -0300
Message-Id: <8839fb63e761749123fc20d43875f1484c7c4346.1533138685.git.mchehab+samsung@kernel.org>
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
 drivers/media/i2c/msp3400-driver.c | 8 ++++----
 drivers/media/i2c/msp3400-driver.h | 8 +++++++-
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/msp3400-driver.c b/drivers/media/i2c/msp3400-driver.c
index 3b9c729fbd52..ef70fe0c77a1 100644
--- a/drivers/media/i2c/msp3400-driver.c
+++ b/drivers/media/i2c/msp3400-driver.c
@@ -703,10 +703,10 @@ static int msp_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	v4l2_i2c_subdev_init(sd, client, &msp_ops);
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
-	state->pads[IF_AUD_DEC_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
-	state->pads[IF_AUD_DEC_PAD_IF_INPUT].sig_type = PAD_SIGNAL_AUDIO;
-	state->pads[IF_AUD_DEC_PAD_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	state->pads[IF_AUD_DEC_PAD_OUT].sig_type = PAD_SIGNAL_AUDIO;
+	state->pads[MSP3400_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+	state->pads[MSP3400_PAD_IF_INPUT].sig_type = PAD_SIGNAL_AUDIO;
+	state->pads[MSP3400_PAD_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[MSP3400_PAD_OUT].sig_type = PAD_SIGNAL_AUDIO;
 
 	sd->entity.function = MEDIA_ENT_F_IF_AUD_DECODER;
 
diff --git a/drivers/media/i2c/msp3400-driver.h b/drivers/media/i2c/msp3400-driver.h
index b6c7698bce5a..2bb9d5ff1bbd 100644
--- a/drivers/media/i2c/msp3400-driver.h
+++ b/drivers/media/i2c/msp3400-driver.h
@@ -52,6 +52,12 @@ extern int msp_standard;
 extern bool msp_dolby;
 extern int msp_stereo_thresh;
 
+enum msp3400_pads {
+	MSP3400_PAD_IF_INPUT,
+	MSP3400_PAD_OUT,
+	MSP3400_NUM_PADS
+};
+
 struct msp_state {
 	struct v4l2_subdev sd;
 	struct v4l2_ctrl_handler hdl;
@@ -106,7 +112,7 @@ struct msp_state {
 	unsigned int         watch_stereo:1;
 
 #if IS_ENABLED(CONFIG_MEDIA_CONTROLLER)
-	struct media_pad pads[IF_AUD_DEC_PAD_NUM_PADS];
+	struct media_pad pads[MSP3400_NUM_PADS];
 #endif
 };
 
-- 
2.17.1
