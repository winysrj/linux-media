Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33858 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756637AbaLWUud (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:33 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 34/66] rtl2832: wrap DVBv5 BER to DVBv3
Date: Tue, 23 Dec 2014 22:49:27 +0200
Message-Id: <1419367799-14263-34-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change legacy DVBv3 read BER to return values calculated by DVBv5
statistics.
---
 drivers/media/dvb-frontends/rtl2832.c      | 13 ++-----------
 drivers/media/dvb-frontends/rtl2832_priv.h |  1 +
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index b5a8c79..531099b 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -805,20 +805,11 @@ static int rtl2832_read_snr(struct dvb_frontend *fe, u16 *snr)
 static int rtl2832_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
 	struct rtl2832_dev *dev = fe->demodulator_priv;
-	struct i2c_client *client = dev->client;
-	int ret;
-	u8 buf[2];
-
-	ret = rtl2832_rd_regs(dev, 0x4e, 3, buf, 2);
-	if (ret)
-		goto err;
 
-	*ber = buf[0] << 8 | buf[1];
+	*ber = (dev->post_bit_error - dev->post_bit_error_prev);
+	dev->post_bit_error_prev = dev->post_bit_error;
 
 	return 0;
-err:
-	dev_dbg(&client->dev, "failed=%d\n", ret);
-	return ret;
 }
 
 static void rtl2832_stat_work(struct work_struct *work)
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index 5e90cd4..a44614c 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -36,6 +36,7 @@ struct rtl2832_dev {
 	struct dvb_frontend fe;
 	struct delayed_work stat_work;
 	fe_status_t fe_status;
+	u64 post_bit_error_prev; /* for old DVBv3 read_ber() calculation */
 	u64 post_bit_error;
 	u64 post_bit_count;
 	bool i2c_gate_state;
-- 
http://palosaari.fi/

