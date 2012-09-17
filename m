Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39593 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab2IQC1Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Sep 2012 22:27:24 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/3] tua9001: enter full power save on attach
Date: Mon, 17 Sep 2012 05:26:55 +0300
Message-Id: <1347848817-18607-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Disable RXEN and enable RESETN pins on attach to ensure chip is
totally powered down after attach.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/tua9001.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/tuners/tua9001.c b/drivers/media/tuners/tua9001.c
index e6394fc..3896684 100644
--- a/drivers/media/tuners/tua9001.c
+++ b/drivers/media/tuners/tua9001.c
@@ -261,6 +261,16 @@ struct dvb_frontend *tua9001_attach(struct dvb_frontend *fe,
 				TUA9001_CMD_CEN, 1);
 		if (ret < 0)
 			goto err;
+
+		ret = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
+				TUA9001_CMD_RXEN, 0);
+		if (ret < 0)
+			goto err;
+
+		ret = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
+				TUA9001_CMD_RESETN, 1);
+		if (ret < 0)
+			goto err;
 	}
 
 	dev_info(&priv->i2c->dev,
-- 
1.7.11.4

