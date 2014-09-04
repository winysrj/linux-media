Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44807 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757088AbaIDChE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:04 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 31/37] af9033: implement DVBv5 statistic for CNR
Date: Thu,  4 Sep 2014 05:36:39 +0300
Message-Id: <1409798205-25645-31-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Return CNR via DVBv5 statistic API.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 54 ++++++++++++++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index b9a0b00..576e9b5 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -1054,11 +1054,12 @@ static void af9033_stat_work(struct work_struct *work)
 {
 	struct af9033_dev *dev = container_of(work, struct af9033_dev, stat_work.work);
 	struct dtv_frontend_properties *c = &dev->fe.dtv_property_cache;
-	int ret, tmp;
-	u8 u8tmp;
+	int ret, tmp, i, len;
+	u8 u8tmp, buf[3];
 
 	dev_dbg(&dev->client->dev, "\n");
 
+	/* signal strength */
 	if (dev->fe_status & FE_HAS_SIGNAL) {
 		if (dev->is_af9035) {
 			ret = af9033_rd_reg(dev, 0x80004a, &u8tmp);
@@ -1078,6 +1079,55 @@ static void af9033_stat_work(struct work_struct *work)
 		c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	}
 
+	/* CNR */
+	if (dev->fe_status & FE_HAS_VITERBI) {
+		u32 snr_val;
+		const struct val_snr *snr_lut;
+
+		/* read value */
+		ret = af9033_rd_regs(dev, 0x80002c, buf, 3);
+		if (ret)
+			goto err;
+
+		snr_val = (buf[2] << 16) | (buf[1] << 8) | (buf[0] << 0);
+
+		/* read current modulation */
+		ret = af9033_rd_reg(dev, 0x80f903, &u8tmp);
+		if (ret)
+			goto err;
+
+		switch ((u8tmp >> 0) & 3) {
+		case 0:
+			len = ARRAY_SIZE(qpsk_snr_lut);
+			snr_lut = qpsk_snr_lut;
+			break;
+		case 1:
+			len = ARRAY_SIZE(qam16_snr_lut);
+			snr_lut = qam16_snr_lut;
+			break;
+		case 2:
+			len = ARRAY_SIZE(qam64_snr_lut);
+			snr_lut = qam64_snr_lut;
+			break;
+		default:
+			goto err_schedule_delayed_work;
+		}
+
+		for (i = 0; i < len; i++) {
+			tmp = snr_lut[i].snr * 1000;
+			if (snr_val < snr_lut[i].val)
+				break;
+		}
+
+		c->cnr.len = 1;
+		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+		c->cnr.stat[0].svalue = tmp;
+	} else {
+		c->cnr.len = 1;
+		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
+err_schedule_delayed_work:
 	schedule_delayed_work(&dev->stat_work, msecs_to_jiffies(2000));
 	return;
 err:
-- 
http://palosaari.fi/

