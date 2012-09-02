Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33888 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab2IBWo4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Sep 2012 18:44:56 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] mxl5005s: implement get_if_frequency()
Date: Mon,  3 Sep 2012 01:44:31 +0300
Message-Id: <1346625871-28301-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/mxl5005s.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/tuners/mxl5005s.c b/drivers/media/tuners/mxl5005s.c
index 6133315..b473b76 100644
--- a/drivers/media/tuners/mxl5005s.c
+++ b/drivers/media/tuners/mxl5005s.c
@@ -4054,6 +4054,16 @@ static int mxl5005s_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
 	return 0;
 }
 
+static int mxl5005s_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+	struct mxl5005s_state *state = fe->tuner_priv;
+	dprintk(1, "%s()\n", __func__);
+
+	*frequency = state->IF_OUT;
+
+	return 0;
+}
+
 static int mxl5005s_release(struct dvb_frontend *fe)
 {
 	dprintk(1, "%s()\n", __func__);
@@ -4076,6 +4086,7 @@ static const struct dvb_tuner_ops mxl5005s_tuner_ops = {
 	.set_params    = mxl5005s_set_params,
 	.get_frequency = mxl5005s_get_frequency,
 	.get_bandwidth = mxl5005s_get_bandwidth,
+	.get_if_frequency = mxl5005s_get_if_frequency,
 };
 
 struct dvb_frontend *mxl5005s_attach(struct dvb_frontend *fe,
-- 
1.7.11.4

