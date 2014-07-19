Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41724 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760171AbaGSCis (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 22:38:48 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>, Luis Alves <ljalvs@gmail.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 06/10] si2157: Use name si2157_ops instead of si2157_tuner_ops
Date: Sat, 19 Jul 2014 05:38:22 +0300
Message-Id: <1405737506-13186-6-git-send-email-crope@iki.fi>
In-Reply-To: <1405737506-13186-1-git-send-email-crope@iki.fi>
References: <1405737506-13186-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Olli Salonen <olli.salonen@iki.fi>

The struct prototype is defined at the beginning of the code as
"si2157_ops" but the real struct is called "si2157_tuner_ops".

This is causing the name to be empty on this info msg: si2157 16-0060:
si2157: found a '' in cold state

[crope@iki.fi: commit msg from Luis email reply]
Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
Cc: Luis Alves <ljalvs@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
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
1.9.3

