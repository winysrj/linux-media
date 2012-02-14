Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:28204 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab2BNVsX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 16:48:23 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 08/22] mt2063: add shutdown
Date: Tue, 14 Feb 2012 22:47:32 +0100
Message-Id: <1329256066-8844-8-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
References: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/common/tuners/mt2063.c |   47 +++++++++++++++++++++------------
 1 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index f659d4c..c3b5108 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -230,9 +230,23 @@ static int mt2063_set_reg_mask(struct mt2063_state *state, u8 reg,
 	return 0;
 }
 
+static void mt2063_shutdown(struct mt2063_state *state,
+			enum MT2063_Mask_Bits sd)
 {
+	dprintk(1, "\n");
 
+	/*
+	 * set all power bits
+	 *
+	 */
+	if (sd == MT2063_NONE_SD) {
+		mt2063_write(state, MT2063_REG_PWR_1, 0x00);
+		mt2063_write(state, MT2063_REG_PWR_2, 0x00);
 	} else {
+		mt2063_set_reg_mask(state, MT2063_REG_PWR_1,
+						sd & 0xff, sd & 0xff);
+		mt2063_set_reg_mask(state, MT2063_REG_PWR_2, sd >> 8,
+						sd >> 8);
 	}
 }
 
@@ -1144,6 +1158,22 @@ static int mt2063_set_analog_params(struct dvb_frontend *fe,
 	return 0;
 }
 
+static struct dvb_tuner_ops mt2063_ops = {
+	.info = {
+		.name = "MT2063 Silicon Tuner",
+		.frequency_min = 48000000,      /* 48 MHz */
+		.frequency_max = 1002000000,    /* 1002 MHz */
+		.frequency_step = 50000,        /* 50 kHz */
+	},
+	.release = mt2063_release,
+	.init = mt2063_init,
+	.sleep = mt2063_sleep,
+
+	.set_params = mt2063_set_params,
+	.set_analog_params = mt2063_set_analog_params,
+	.get_if_frequency = mt2063_get_if_frequency,
+	/* TODO */
+};
 /*
  * As defined on EN 300 429, the DVB-C roll-off factor is 0.15.
  * So, the amount of the needed bandwith is given by:
@@ -1249,23 +1279,6 @@ static int mt2063_get_bandwidth(struct dvb_frontend *fe, u32 *bw)
 	return 0;
 }
 
-static struct dvb_tuner_ops mt2063_ops = {
-	.info = {
-		 .name = "MT2063 Silicon Tuner",
-		 .frequency_min = 45000000,
-		 .frequency_max = 865000000,
-		 .frequency_step = 0,
-		 },
-
-	.init = mt2063_init,
-	.get_status = mt2063_get_status,
-	.set_analog_params = mt2063_set_analog_params,
-	.set_params    = mt2063_set_params,
-	.get_if_frequency = mt2063_get_if_frequency,
-	.get_bandwidth = mt2063_get_bandwidth,
-	.release = mt2063_release,
-};
-
 struct dvb_frontend *mt2063_attach(struct dvb_frontend *fe,
                    struct mt2063_config *config,
                    struct i2c_adapter *i2c)
-- 
1.7.7.6

