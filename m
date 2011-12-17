Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:22069 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab1LQU57 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Dec 2011 15:57:59 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 1/3] mt2063: add get_if_frequency call
Date: Sat, 17 Dec 2011 21:57:15 +0100
Message-Id: <1324155437-15834-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/common/tuners/mt2063.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 6743ffe..5b4b1ec 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -2211,18 +2211,29 @@ static int mt2063_get_frequency(struct dvb_frontend *fe, u32 *freq)
 	if (!state->init)
 		return -ENODEV;
 
-	/*
-	 * FIXME: This is an API abuse at DRX-K driver: in order to allow
-	 * tda18271 to change the IF based on the standard, it uses this
-	 * callback as "get_if_frequency".
-	 */
-	*freq = state->reference * 1000;
+	*freq = state->frequency;
 
 	dprintk(1, "frequency: %d\n", *freq);
 
 	return 0;
 }
 
+static int mt2063_get_if_frequency(struct dvb_frontend *fe, u32 *freq)
+{
+	struct mt2063_state *state = fe->tuner_priv;
+
+	dprintk(2, "\n");
+
+	if (!state->init)
+		return -ENODEV;
+
+	*freq = state->AS_Data.f_out;
+
+	dprintk(1, "if frequency: %d\n", *freq);
+
+	return 0;
+}
+
 static int mt2063_get_bandwidth(struct dvb_frontend *fe, u32 *bw)
 {
 	struct mt2063_state *state = fe->tuner_priv;
@@ -2253,6 +2264,7 @@ static struct dvb_tuner_ops mt2063_ops = {
 	.set_analog_params = mt2063_set_analog_params,
 	.set_params    = mt2063_set_params,
 	.get_frequency = mt2063_get_frequency,
+	.get_if_frequency = mt2063_get_if_frequency,
 	.get_bandwidth = mt2063_get_bandwidth,
 	.release = mt2063_release,
 };
-- 
1.7.7

