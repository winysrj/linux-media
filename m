Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45760 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757090AbaIDChE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:04 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 33/37] af9033: implement DVBv5 stat block counters
Date: Thu,  4 Sep 2014 05:36:41 +0300
Message-Id: <1409798205-25645-33-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement following API commands:
DTV_STAT_ERROR_BLOCK_COUNT
DTV_STAT_TOTAL_BLOCK_COUNT

These returns total and uncorrected error packets from outer FEC.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 4c20616..7b85346 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -38,6 +38,8 @@ struct af9033_dev {
 	fe_status_t fe_status;
 	u32 ber;
 	u32 ucb;
+	u64 error_block_count;
+	u64 total_block_count;
 	struct delayed_work stat_work;
 	unsigned long last_stat_check;
 };
@@ -1015,7 +1017,7 @@ static void af9033_stat_work(struct work_struct *work)
 	struct af9033_dev *dev = container_of(work, struct af9033_dev, stat_work.work);
 	struct dtv_frontend_properties *c = &dev->fe.dtv_property_cache;
 	int ret, tmp, i, len;
-	u8 u8tmp, buf[3];
+	u8 u8tmp, buf[7];
 
 	dev_dbg(&dev->client->dev, "\n");
 
@@ -1087,6 +1089,35 @@ static void af9033_stat_work(struct work_struct *work)
 		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	}
 
+	/* UCB/PER/BER */
+	if (dev->fe_status & FE_HAS_LOCK) {
+		/* outer FEC, 204 byte packets */
+		u16 abort_packet_count, rsd_packet_count;
+
+		/*
+		 * Packet count used for measurement is 10000
+		 * (rsd_packet_count). Maybe it should be increased?
+		 */
+
+		ret = af9033_rd_regs(dev, 0x800032, buf, 7);
+		if (ret)
+			goto err;
+
+		abort_packet_count = (buf[1] << 8) | (buf[0] << 0);
+		rsd_packet_count = (buf[6] << 8) | (buf[5] << 0);
+
+		dev->error_block_count += abort_packet_count;
+		dev->total_block_count += rsd_packet_count;
+
+		c->block_count.len = 1;
+		c->block_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->block_count.stat[0].uvalue = dev->total_block_count;
+
+		c->block_error.len = 1;
+		c->block_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->block_error.stat[0].uvalue = dev->error_block_count;
+	}
+
 err_schedule_delayed_work:
 	schedule_delayed_work(&dev->stat_work, msecs_to_jiffies(2000));
 	return;
-- 
http://palosaari.fi/

