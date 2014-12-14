Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34010 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbaLNI3t (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Dec 2014 03:29:49 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 13/18] rtl2830: wrap DVBv5 BER to DVBv3
Date: Sun, 14 Dec 2014 10:28:38 +0200
Message-Id: <1418545723-9536-13-git-send-email-crope@iki.fi>
In-Reply-To: <1418545723-9536-1-git-send-email-crope@iki.fi>
References: <1418545723-9536-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change legacy DVBv3 read BER to return values calculated by DVBv5
statistics.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2830.c      | 15 ++-------------
 drivers/media/dvb-frontends/rtl2830_priv.h |  1 +
 2 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index a02ccdf..0112b3f 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -596,22 +596,11 @@ static int rtl2830_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
 	struct i2c_client *client = fe->demodulator_priv;
 	struct rtl2830_dev *dev = i2c_get_clientdata(client);
-	int ret;
-	u8 buf[2];
-
-	if (dev->sleeping)
-		return 0;
-
-	ret = rtl2830_rd_regs(client, 0x34e, buf, 2);
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
 
 static int rtl2830_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
diff --git a/drivers/media/dvb-frontends/rtl2830_priv.h b/drivers/media/dvb-frontends/rtl2830_priv.h
index cdcaacf..6636834 100644
--- a/drivers/media/dvb-frontends/rtl2830_priv.h
+++ b/drivers/media/dvb-frontends/rtl2830_priv.h
@@ -32,6 +32,7 @@ struct rtl2830_dev {
 	u8 page; /* active register page */
 	struct delayed_work stat_work;
 	fe_status_t fe_status;
+	u64 post_bit_error_prev; /* for old DVBv3 read_ber() calculation */
 	u64 post_bit_error;
 	u64 post_bit_count;
 };
-- 
http://palosaari.fi/

