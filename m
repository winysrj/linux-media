Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:28273 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab2BNVs2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 16:48:28 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 15/22] mt_2063: add mt2063_sleep
Date: Tue, 14 Feb 2012 22:47:39 +0100
Message-Id: <1329256066-8844-15-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
References: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/common/tuners/mt2063.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 3af5242..0e26744 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -460,13 +460,25 @@ static int mt2063_init(struct dvb_frontend *fe)
 	return 0;
 }
 
+static int mt2063_sleep(struct dvb_frontend *fe)
 {
 	struct mt2063_state *state = fe->tuner_priv;
 
+	dprintk(1, "\n");
+	mutex_lock(&state->lock);
 
+	/* open gate */
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
 
+	/* set all power bits off */
+	mt2063_shutdown(state, MT2063_ALL_SD);
 
+	/* close gate */
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
 
+	mutex_unlock(&state->lock);
 	return 0;
 }
 
-- 
1.7.7.6

