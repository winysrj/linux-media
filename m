Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out1.inet.fi ([62.71.2.198]:46486 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759546AbaGRFro (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 01:47:44 -0400
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH] si2157: Use name si2157_ops instead of si2157_tuner_ops (harmonize with si2168)
Date: Fri, 18 Jul 2014 08:41:12 +0300
Message-Id: <1405662072-26808-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/tuners/si2157.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 329004f..4730f69 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -277,7 +277,7 @@ err:
 	return ret;
 }
 
-static const struct dvb_tuner_ops si2157_tuner_ops = {
+static const struct dvb_tuner_ops si2157_ops = {
 	.info = {
 		.name           = "Silicon Labs Si2157/Si2158",
 		.frequency_min  = 110000000,
@@ -317,7 +317,7 @@ static int si2157_probe(struct i2c_client *client,
 		goto err;
 
 	fe->tuner_priv = s;
-	memcpy(&fe->ops.tuner_ops, &si2157_tuner_ops,
+	memcpy(&fe->ops.tuner_ops, &si2157_ops,
 			sizeof(struct dvb_tuner_ops));
 
 	i2c_set_clientdata(client, s);
-- 
1.9.1

