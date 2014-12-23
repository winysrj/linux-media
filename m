Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54605 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756612AbaLWUuc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:32 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 32/66] rtl2832: implement DVBv5 BER statistic
Date: Tue, 23 Dec 2014 22:49:25 +0200
Message-Id: <1419367799-14263-32-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVBv5 BER.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c      | 25 +++++++++++++++++++++++++
 drivers/media/dvb-frontends/rtl2832_priv.h |  2 ++
 2 files changed, 27 insertions(+)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 7dc4c27..cd53311 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -476,6 +476,10 @@ static int rtl2832_init(struct dvb_frontend *fe)
 	/* init stats here in order signal app which stats are supported */
 	c->cnr.len = 1;
 	c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->post_bit_error.len = 1;
+	c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->post_bit_count.len = 1;
+	c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	/* start statistics polling */
 	schedule_delayed_work(&dev->stat_work, msecs_to_jiffies(2000));
 	dev->sleeping = false;
@@ -904,6 +908,27 @@ static void rtl2832_stat_work(struct work_struct *work)
 		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	}
 
+	/* BER */
+	if (dev->fe_status & FE_HAS_LOCK) {
+		ret = rtl2832_bulk_read(client, 0x34e, buf, 2);
+		if (ret)
+			goto err;
+
+		u16tmp = buf[0] << 8 | buf[1] << 0;
+		dev->post_bit_error += u16tmp;
+		dev->post_bit_count += 1000000;
+
+		dev_dbg(&client->dev, "ber errors=%u total=1000000\n", u16tmp);
+
+		c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_error.stat[0].uvalue = dev->post_bit_error;
+		c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_count.stat[0].uvalue = dev->post_bit_count;
+	} else {
+		c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
 err_schedule_delayed_work:
 	schedule_delayed_work(&dev->stat_work, msecs_to_jiffies(2000));
 	return;
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index 3c44983..a5f5ccd 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -35,6 +35,8 @@ struct rtl2832_dev {
 	struct dvb_frontend fe;
 	struct delayed_work stat_work;
 	fe_status_t fe_status;
+	u64 post_bit_error;
+	u64 post_bit_count;
 	bool i2c_gate_state;
 	bool sleeping;
 	struct delayed_work i2c_gate_work;
-- 
http://palosaari.fi/

