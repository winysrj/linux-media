Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41546 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021Ab2IBXWN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Sep 2012 19:22:13 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] mc44s803: implement get_if_frequency()
Date: Mon,  3 Sep 2012 02:21:51 +0300
Message-Id: <1346628111-5784-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/mc44s803.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/mc44s803.c b/drivers/media/tuners/mc44s803.c
index 5ddce7e..f1b7640 100644
--- a/drivers/media/tuners/mc44s803.c
+++ b/drivers/media/tuners/mc44s803.c
@@ -298,6 +298,12 @@ static int mc44s803_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
+static int mc44s803_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+	*frequency = MC44S803_IF2; /* 36.125 MHz */
+	return 0;
+}
+
 static const struct dvb_tuner_ops mc44s803_tuner_ops = {
 	.info = {
 		.name           = "Freescale MC44S803",
@@ -309,7 +315,8 @@ static const struct dvb_tuner_ops mc44s803_tuner_ops = {
 	.release       = mc44s803_release,
 	.init          = mc44s803_init,
 	.set_params    = mc44s803_set_params,
-	.get_frequency = mc44s803_get_frequency
+	.get_frequency = mc44s803_get_frequency,
+	.get_if_frequency = mc44s803_get_if_frequency,
 };
 
 /* This functions tries to identify a MC44S803 tuner by reading the ID
-- 
1.7.11.4

