Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60104 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756640AbaLWUud (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:33 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 37/66] rtl2832: drop FE i2c gate control support
Date: Tue, 23 Dec 2014 22:49:30 +0200
Message-Id: <1419367799-14263-37-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We don't need it anymore as all users are using muxed I2C adapter.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c      | 33 ------------------------------
 drivers/media/dvb-frontends/rtl2832_priv.h |  1 -
 2 files changed, 34 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 39c8f34..94d08fb 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -309,30 +309,6 @@ err:
 
 }
 
-static int rtl2832_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
-{
-	struct rtl2832_dev *dev = fe->demodulator_priv;
-	struct i2c_client *client = dev->client;
-	int ret;
-
-	dev_dbg(&client->dev, "enable=%d\n", enable);
-
-	/* gate already open or close */
-	if (dev->i2c_gate_state == enable)
-		return 0;
-
-	ret = rtl2832_wr_demod_reg(dev, DVBT_IIC_REPEAT, (enable ? 0x1 : 0x0));
-	if (ret)
-		goto err;
-
-	dev->i2c_gate_state = enable;
-
-	return ret;
-err:
-	dev_dbg(&client->dev, "failed=%d\n", ret);
-	return ret;
-}
-
 static int rtl2832_set_if(struct dvb_frontend *fe, u32 if_freq)
 {
 	struct rtl2832_dev *dev = fe->demodulator_priv;
@@ -932,8 +908,6 @@ static void rtl2832_i2c_gate_work(struct work_struct *work)
 	if (ret)
 		goto err;
 
-	dev->i2c_gate_state = false;
-
 	return;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
@@ -949,9 +923,6 @@ static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 	/* terminate possible gate closing */
 	cancel_delayed_work(&dev->i2c_gate_work);
 
-	if (dev->i2c_gate_state == chan_id)
-		return 0;
-
 	/*
 	 * chan_id 1 is muxed adapter demod provides and chan_id 0 is demod
 	 * itself. We need open gate when request is for chan_id 1. On that case
@@ -965,8 +936,6 @@ static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 	if (ret)
 		goto err;
 
-	dev->i2c_gate_state = chan_id;
-
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
@@ -1017,8 +986,6 @@ static struct dvb_frontend_ops rtl2832_ops = {
 	.read_status = rtl2832_read_status,
 	.read_snr = rtl2832_read_snr,
 	.read_ber = rtl2832_read_ber,
-
-	.i2c_gate_ctrl = rtl2832_i2c_gate_ctrl,
 };
 
 /*
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index a44614c..6f3fe77 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -39,7 +39,6 @@ struct rtl2832_dev {
 	u64 post_bit_error_prev; /* for old DVBv3 read_ber() calculation */
 	u64 post_bit_error;
 	u64 post_bit_count;
-	bool i2c_gate_state;
 	bool sleeping;
 	struct delayed_work i2c_gate_work;
 };
-- 
http://palosaari.fi/

