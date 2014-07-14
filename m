Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59723 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756310AbaGNRJU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 13:09:20 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 01/18] si2157: implement sleep
Date: Mon, 14 Jul 2014 20:08:42 +0300
Message-Id: <1405357739-3570-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement sleep for power-management.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/si2157.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index fa4cc7b..082e80e 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -89,12 +89,23 @@ static int si2157_init(struct dvb_frontend *fe)
 static int si2157_sleep(struct dvb_frontend *fe)
 {
 	struct si2157 *s = fe->tuner_priv;
+	int ret;
+	struct si2157_cmd cmd;
 
 	dev_dbg(&s->client->dev, "%s:\n", __func__);
 
 	s->active = false;
 
+	memcpy(cmd.args, "\x13", 1);
+	cmd.len = 1;
+	ret = si2157_cmd_execute(s, &cmd);
+	if (ret)
+		goto err;
+
 	return 0;
+err:
+	dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
 }
 
 static int si2157_set_params(struct dvb_frontend *fe)
-- 
1.9.3

