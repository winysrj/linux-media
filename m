Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43633 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757085AbaIDChE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:04 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 30/37] af9033: implement DVBv5 statistic for signal strength
Date: Thu,  4 Sep 2014 05:36:38 +0300
Message-Id: <1409798205-25645-30-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Let the demod firmware estimate RF signal strength and return it
to the app as a dBm. To handle that, use thread which reads signal
strengths from firmware in 2 sec intervals when device is active.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 48 ++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 1bd5a9a..b9a0b00 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -28,13 +28,17 @@ struct af9033_dev {
 	struct i2c_client *client;
 	struct dvb_frontend fe;
 	struct af9033_config cfg;
+	bool is_af9035;
+	bool is_it9135;
 
 	u32 bandwidth_hz;
 	bool ts_mode_parallel;
 	bool ts_mode_serial;
 
+	fe_status_t fe_status;
 	u32 ber;
 	u32 ucb;
+	struct delayed_work stat_work;
 	unsigned long last_stat_check;
 };
 
@@ -442,6 +446,8 @@ static int af9033_init(struct dvb_frontend *fe)
 	}
 
 	dev->bandwidth_hz = 0; /* force to program all parameters */
+	/* start statistics polling */
+	schedule_delayed_work(&dev->stat_work, msecs_to_jiffies(2000));
 
 	return 0;
 
@@ -457,6 +463,9 @@ static int af9033_sleep(struct dvb_frontend *fe)
 	int ret, i;
 	u8 tmp;
 
+	/* stop statistics polling */
+	cancel_delayed_work_sync(&dev->stat_work);
+
 	ret = af9033_wr_reg(dev, 0x80004c, 1);
 	if (ret < 0)
 		goto err;
@@ -810,6 +819,8 @@ static int af9033_read_status(struct dvb_frontend *fe, fe_status_t *status)
 					FE_HAS_LOCK;
 	}
 
+	dev->fe_status = *status;
+
 	return 0;
 
 err:
@@ -1039,6 +1050,40 @@ err:
 	return ret;
 }
 
+static void af9033_stat_work(struct work_struct *work)
+{
+	struct af9033_dev *dev = container_of(work, struct af9033_dev, stat_work.work);
+	struct dtv_frontend_properties *c = &dev->fe.dtv_property_cache;
+	int ret, tmp;
+	u8 u8tmp;
+
+	dev_dbg(&dev->client->dev, "\n");
+
+	if (dev->fe_status & FE_HAS_SIGNAL) {
+		if (dev->is_af9035) {
+			ret = af9033_rd_reg(dev, 0x80004a, &u8tmp);
+			tmp = -u8tmp * 1000;
+		} else {
+			ret = af9033_rd_reg(dev, 0x8000f7, &u8tmp);
+			tmp = (u8tmp - 100) * 1000;
+		}
+		if (ret)
+			goto err;
+
+		c->strength.len = 1;
+		c->strength.stat[0].scale = FE_SCALE_DECIBEL;
+		c->strength.stat[0].svalue = tmp;
+	} else {
+		c->strength.len = 1;
+		c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
+	schedule_delayed_work(&dev->stat_work, msecs_to_jiffies(2000));
+	return;
+err:
+	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
+}
+
 static struct dvb_frontend_ops af9033_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
@@ -1099,6 +1144,7 @@ static int af9033_probe(struct i2c_client *client,
 
 	/* setup the state */
 	dev->client = client;
+	INIT_DELAYED_WORK(&dev->stat_work, af9033_stat_work);
 	memcpy(&dev->cfg, cfg, sizeof(struct af9033_config));
 
 	if (dev->cfg.clock != 12000000) {
@@ -1117,9 +1163,11 @@ static int af9033_probe(struct i2c_client *client,
 	case AF9033_TUNER_IT9135_60:
 	case AF9033_TUNER_IT9135_61:
 	case AF9033_TUNER_IT9135_62:
+		dev->is_it9135 = true;
 		reg = 0x004bfc;
 		break;
 	default:
+		dev->is_af9035 = true;
 		reg = 0x0083e9;
 		break;
 	}
-- 
http://palosaari.fi/

