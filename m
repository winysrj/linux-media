Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.andi.de1.cc ([85.214.239.24]:51696 "EHLO
        h2641619.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752493AbdCOWXB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 18:23:01 -0400
From: Andreas Kemnade <andreas@kemnade.info>
To: crope@iki.fi, mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Andreas Kemnade <andreas@kemnade.info>
Subject: [PATCH 2/3] [media] af9035: init i2c already in it930x_frontend_attach
Date: Wed, 15 Mar 2017 23:22:09 +0100
Message-Id: <1489616530-4025-3-git-send-email-andreas@kemnade.info>
In-Reply-To: <1489616530-4025-1-git-send-email-andreas@kemnade.info>
References: <1489616530-4025-1-git-send-email-andreas@kemnade.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i2c bus is already needed when the frontend is probed,
so init it already in it930x_frontend_attach
That prevents errors like
     si2168: probe of 6-0067 failed with error -5

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 43 ++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 4df9486..a95f4b2 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1214,8 +1214,49 @@ static int it930x_frontend_attach(struct dvb_usb_adapter *adap)
 	struct si2168_config si2168_config;
 	struct i2c_adapter *adapter;
 
-	dev_dbg(&intf->dev, "adap->id=%d\n", adap->id);
+	dev_dbg(&intf->dev, "%s  adap->id=%d\n", __func__, adap->id);
+
+	/* I2C master bus 2 clock speed 300k */
+	ret = af9035_wr_reg(d, 0x00f6a7, 0x07);
+	if (ret < 0)
+		goto err;
+
+	/* I2C master bus 1,3 clock speed 300k */
+	ret = af9035_wr_reg(d, 0x00f103, 0x07);
+	if (ret < 0)
+		goto err;
+
+	/* set gpio11 low */
+	ret = af9035_wr_reg_mask(d, 0xd8d4, 0x01, 0x01);
+	if (ret < 0)
+		goto err;
+
+	ret = af9035_wr_reg_mask(d, 0xd8d5, 0x01, 0x01);
+	if (ret < 0)
+		goto err;
+
+	ret = af9035_wr_reg_mask(d, 0xd8d3, 0x01, 0x01);
+	if (ret < 0)
+		goto err;
 
+	/* Tuner enable using gpiot2_en, gpiot2_on and gpiot2_o (reset) */
+	ret = af9035_wr_reg_mask(d, 0xd8b8, 0x01, 0x01);
+	if (ret < 0)
+		goto err;
+
+	ret = af9035_wr_reg_mask(d, 0xd8b9, 0x01, 0x01);
+	if (ret < 0)
+		goto err;
+
+	ret = af9035_wr_reg_mask(d, 0xd8b7, 0x00, 0x01);
+	if (ret < 0)
+		goto err;
+
+	msleep(200);
+
+	ret = af9035_wr_reg_mask(d, 0xd8b7, 0x01, 0x01);
+	if (ret < 0)
+		goto err;
 	memset(&si2168_config, 0, sizeof(si2168_config));
 	si2168_config.i2c_adapter = &adapter;
 	si2168_config.fe = &adap->fe[0];
-- 
2.1.4
