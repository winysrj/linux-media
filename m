Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:43383 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbaGQTiO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 15:38:14 -0400
Received: by mail-wi0-f179.google.com with SMTP id f8so3393003wiw.12
        for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 12:38:13 -0700 (PDT)
From: Luis Alves <ljalvs@gmail.com>
To: linux-media@vger.kernel.org
Cc: crope@iki.fi, Luis Alves <ljalvs@gmail.com>
Subject: [PATCH 1/1] si2168: Fix i2c_add_mux_adapter return value in probe function. In case it failed the return value was always 0.
Date: Thu, 17 Jul 2014 20:38:08 +0100
Message-Id: <1405625888-9056-1-git-send-email-ljalvs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Luis Alves <ljalvs@gmail.com>
---
 drivers/media/dvb-frontends/si2168.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 7980741..3fed522 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -619,8 +619,10 @@ static int si2168_probe(struct i2c_client *client,
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
1.9.1

