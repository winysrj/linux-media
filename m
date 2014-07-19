Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44529 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760102AbaGSCis (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 22:38:48 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Luis Alves <ljalvs@gmail.com>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 03/10] si2168: Fix i2c_add_mux_adapter return value
Date: Sat, 19 Jul 2014 05:38:19 +0300
Message-Id: <1405737506-13186-3-git-send-email-crope@iki.fi>
In-Reply-To: <1405737506-13186-1-git-send-email-crope@iki.fi>
References: <1405737506-13186-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Luis Alves <ljalvs@gmail.com>

In case of failure the return value was always 0. Return proper
error code (ENODEV) instead.

Signed-off-by: Luis Alves <ljalvs@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 767dada..7659764 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -626,8 +626,10 @@ static int si2168_probe(struct i2c_client *client,
 	/* create mux i2c adapter for tuner */
 	s->adapter = i2c_add_mux_adapter(client->adapter, &client->dev, s,
 			0, 0, 0, si2168_select, si2168_deselect);
-	if (s->adapter == NULL)
+	if (s->adapter == NULL) {
+		ret = -ENODEV;
 		goto err;
+	}
 
 	/* create dvb_frontend */
 	memcpy(&s->fe.ops, &si2168_ops, sizeof(struct dvb_frontend_ops));
-- 
1.9.3

