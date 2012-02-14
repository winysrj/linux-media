Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:28278 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760886Ab2BNVs2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 16:48:28 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 22/22] mt2063: add mt2063_find_chip
Date: Tue, 14 Feb 2012 22:47:46 +0100
Message-Id: <1329256066-8844-22-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
References: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/common/tuners/mt2063.c |   43 ++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 7dd1d7c..a717479 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -557,18 +557,60 @@ static struct dvb_tuner_ops mt2063_ops = {
 	/* TODO */
 };
 
+static int mt2063_find_chip(struct mt2063_state *state)
 {
+	int err;
+	u8 chip = 0, chip_hi = 0;
+	char *step;
+	struct dvb_frontend *fe = state->frontend;
 
+	dprintk(1, "\n");
 
+	/* open gate */
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
 
+	/* Read the Part/Rev code from the tuner */
+	err = mt2063_read(state, MT2063_REG_PART_REV, &chip);
+	if (err < 0) {
+		printk(KERN_ERR "Can't read mt2063 part ID\n");
+		return -ENODEV;
+	}
+
+	/* Check the part/rev code */
+	switch (chip) {
+	case MT2063_B0:
+		step = "B0";
 		break;
+	case MT2063_B1:
+		step = "B1";
+		break;
+	case MT2063_B2:
+		step = "B2";
+		break;
+	case MT2063_B3:
+		step = "B3";
 		break;
 	default:
+		printk(KERN_ERR "mt2063: Unknown mt2063 device ID (0x%02x)\n",
+			chip);
 		return -ENODEV;
+	}
 
+	/* Check the 2nd byte of the Part/Rev code from the tuner */
+	mt2063_read(state, MT2063_REG_RSVD_3B, &chip_hi);
+	if ((chip_hi & 0x80) != 0x00) {
+		printk(KERN_ERR "mt2063: Unknown part ID (0x%02x%02x)\n",
+			chip, chip_hi);
 		return -ENODEV;
+	}
 
+	printk(KERN_INFO "mt2063: detected a mt2063 rev %s", step);
+	state->tuner_id = chip;
 
+	/* close gate */
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
 
 	return 0;
 }
@@ -599,6 +641,7 @@ struct dvb_frontend *mt2063_attach(struct dvb_frontend *fe,
 		/* find chip */
 		mutex_init(&state->lock);
 		state->frontend = fe;
+		ret = mt2063_find_chip(state);
 		if (ret < 0)
 			goto fail;
 		fe->tuner_priv = state;
-- 
1.7.7.6

