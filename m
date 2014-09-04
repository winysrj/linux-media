Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54286 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757095AbaIDChF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:05 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 37/37] af9033: remove all DVBv3 stat calculation logic
Date: Thu,  4 Sep 2014 05:36:45 +0300
Message-Id: <1409798205-25645-37-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Statistics are now calculated for DVBv5 and those DVBv5 values are
returned for legacy DVBv3 calls also. So we could remove all old
statistics calculation logic.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 49 ------------------------------------
 1 file changed, 49 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index f5267fd..be5002a 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -36,15 +36,12 @@ struct af9033_dev {
 	bool ts_mode_serial;
 
 	fe_status_t fe_status;
-	u32 ber;
-	u32 ucb;
 	u64 post_bit_error_prev; /* for old read_ber we return (curr - prev) */
 	u64 post_bit_error;
 	u64 post_bit_count;
 	u64 error_block_count;
 	u64 total_block_count;
 	struct delayed_work stat_work;
-	unsigned long last_stat_check;
 };
 
 /* write multiple registers */
@@ -870,52 +867,6 @@ err:
 	return ret;
 }
 
-static int af9033_update_ch_stat(struct af9033_dev *dev)
-{
-	int ret = 0;
-	u32 err_cnt, bit_cnt;
-	u16 abort_cnt;
-	u8 buf[7];
-
-	/* only update data every half second */
-	if (time_after(jiffies, dev->last_stat_check + msecs_to_jiffies(500))) {
-		ret = af9033_rd_regs(dev, 0x800032, buf, sizeof(buf));
-		if (ret < 0)
-			goto err;
-		/* in 8 byte packets? */
-		abort_cnt = (buf[1] << 8) + buf[0];
-		/* in bits */
-		err_cnt = (buf[4] << 16) + (buf[3] << 8) + buf[2];
-		/* in 8 byte packets? always(?) 0x2710 = 10000 */
-		bit_cnt = (buf[6] << 8) + buf[5];
-
-		if (bit_cnt < abort_cnt) {
-			abort_cnt = 1000;
-			dev->ber = 0xffffffff;
-		} else {
-			/*
-			 * 8 byte packets, that have not been rejected already
-			 */
-			bit_cnt -= (u32)abort_cnt;
-			if (bit_cnt == 0) {
-				dev->ber = 0xffffffff;
-			} else {
-				err_cnt -= (u32)abort_cnt * 8 * 8;
-				bit_cnt *= 8 * 8;
-				dev->ber = err_cnt * (0xffffffff / bit_cnt);
-			}
-		}
-		dev->ucb += abort_cnt;
-		dev->last_stat_check = jiffies;
-	}
-
-	return 0;
-err:
-	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
-
-	return ret;
-}
-
 static int af9033_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
 	struct af9033_dev *dev = fe->demodulator_priv;
-- 
http://palosaari.fi/

