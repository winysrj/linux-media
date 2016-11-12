Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55539 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753023AbcKLKey (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 05:34:54 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 5/9] af9033: return regmap for integrated IT913x tuner driver
Date: Sat, 12 Nov 2016 12:33:57 +0200
Message-Id: <1478946841-2807-5-git-send-email-crope@iki.fi>
In-Reply-To: <1478946841-2807-1-git-send-email-crope@iki.fi>
References: <1478946841-2807-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

IT9130 series contains integrated tuner driver, which uses that
demodulator address space. Return regmap in order to allow it913x
driver communication.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 1 +
 drivers/media/dvb-frontends/af9033.h | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index b86a01e..2b86436 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -1154,6 +1154,7 @@ static int af9033_probe(struct i2c_client *client,
 		cfg->ops->pid_filter = af9033_pid_filter;
 		cfg->ops->pid_filter_ctrl = af9033_pid_filter_ctrl;
 	}
+	cfg->regmap = dev->regmap;
 	i2c_set_clientdata(client, dev);
 
 	dev_info(&client->dev, "Afatech AF9033 successfully attached\n");
diff --git a/drivers/media/dvb-frontends/af9033.h b/drivers/media/dvb-frontends/af9033.h
index c87367f..1a23c64 100644
--- a/drivers/media/dvb-frontends/af9033.h
+++ b/drivers/media/dvb-frontends/af9033.h
@@ -87,6 +87,12 @@ struct af9033_config {
 	 * returned by that driver
 	 */
 	struct dvb_frontend **fe;
+
+	/*
+	 * regmap for IT913x integrated tuner driver
+	 * returned by that driver
+	 */
+	struct regmap *regmap;
 };
 
 struct af9033_ops {
-- 
http://palosaari.fi/

