Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35257 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756544AbaLWVFx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 16:05:53 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 53/66] rtl2832: implement sleep
Date: Tue, 23 Dec 2014 22:49:46 +0200
Message-Id: <1419367799-14263-53-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Put demod to soft reset in order to save power when sleep. That drops
power usage ~30mA @5V on USB dongle I tested. In real life it does
not matter much as USB IF powers off demod too, but now it is done
twice - demod and USB IF.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 70fdce4..e620a61 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -410,13 +410,23 @@ static int rtl2832_sleep(struct dvb_frontend *fe)
 {
 	struct rtl2832_dev *dev = fe->demodulator_priv;
 	struct i2c_client *client = dev->client;
+	int ret;
 
 	dev_dbg(&client->dev, "\n");
+
 	dev->sleeping = true;
 	/* stop statistics polling */
 	cancel_delayed_work_sync(&dev->stat_work);
 	dev->fe_status = 0;
+
+	ret = rtl2832_wr_demod_reg(dev, DVBT_SOFT_RST, 0x1);
+	if (ret)
+		goto err;
+
 	return 0;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
 }
 
 static int rtl2832_get_tune_settings(struct dvb_frontend *fe,
-- 
http://palosaari.fi/

