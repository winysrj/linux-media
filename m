Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40383 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbaGJLNg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jul 2014 07:13:36 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/4] si2168: implement sleep
Date: Thu, 10 Jul 2014 14:13:12 +0300
Message-Id: <1404990794-2902-2-git-send-email-crope@iki.fi>
In-Reply-To: <1404990794-2902-1-git-send-email-crope@iki.fi>
References: <1404990794-2902-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement sleep for power-management.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 8637d2e..0d0545e 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -438,13 +438,6 @@ static int si2168_init(struct dvb_frontend *fe)
 
 	dev_dbg(&s->client->dev, "%s:\n", __func__);
 
-	cmd.args[0] = 0x13;
-	cmd.wlen = 1;
-	cmd.rlen = 0;
-	ret = si2168_cmd_execute(s, &cmd);
-	if (ret)
-		goto err;
-
 	cmd.args[0] = 0xc0;
 	cmd.args[1] = 0x12;
 	cmd.args[2] = 0x00;
@@ -559,12 +552,24 @@ err:
 static int si2168_sleep(struct dvb_frontend *fe)
 {
 	struct si2168 *s = fe->demodulator_priv;
+	int ret;
+	struct si2168_cmd cmd;
 
 	dev_dbg(&s->client->dev, "%s:\n", __func__);
 
 	s->active = false;
 
+	memcpy(cmd.args, "\x13", 1);
+	cmd.wlen = 1;
+	cmd.rlen = 0;
+	ret = si2168_cmd_execute(s, &cmd);
+	if (ret)
+		goto err;
+
 	return 0;
+err:
+	dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
 }
 
 static int si2168_get_tune_settings(struct dvb_frontend *fe,
-- 
1.9.3

