Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:40200 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbcEUUiR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2016 16:38:17 -0400
Received: from benjamin-desktop.lan (c-0a08e555.03-170-73746f36.cust.bredbandsbolaget.se [85.229.8.10])
	(Authenticated sender: ed8153)
	by smtp.bredband2.com (Postfix) with ESMTPA id B90A629190
	for <linux-media@vger.kernel.org>; Sat, 21 May 2016 22:38:11 +0200 (CEST)
From: Benjamin Larsson <benjamin@southpole.se>
To: linux-media@vger.kernel.org
Subject: [PATCH] rtl2832: add support for slave ts pid filter
Date: Sat, 21 May 2016 22:38:11 +0200
Message-Id: <1463863091-535-1-git-send-email-benjamin@southpole.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The rtl2832 demod has 2 sets of PID filters. This patch enables
the filter support when using a slave demod.

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/media/dvb-frontends/rtl2832.c      | 21 ++++++++++++++++++---
 drivers/media/dvb-frontends/rtl2832_priv.h |  1 +
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 7c96f76..fe771b9 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -409,6 +409,7 @@ static int rtl2832_init(struct dvb_frontend *fe)
 	c->post_bit_count.len = 1;
 	c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	dev->sleeping = false;
+	dev->slave_ts = 0;
 
 	return 0;
 err:
@@ -1124,10 +1125,16 @@ static int rtl2832_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
 	else
 		u8tmp = 0x00;
 
-	ret = rtl2832_update_bits(client, 0x061, 0xc0, u8tmp);
+	if (dev->slave_ts) {
+		ret = rtl2832_update_bits(client, 0x021, 0xc0, u8tmp);
+	} else {
+		ret = rtl2832_update_bits(client, 0x061, 0xc0, u8tmp);
+	}
 	if (ret)
 		goto err;
 
+	dev->slave_ts = 1;
+
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
@@ -1159,14 +1166,22 @@ static int rtl2832_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid,
 	buf[1] = (dev->filters >>  8) & 0xff;
 	buf[2] = (dev->filters >> 16) & 0xff;
 	buf[3] = (dev->filters >> 24) & 0xff;
-	ret = rtl2832_bulk_write(client, 0x062, buf, 4);
+
+	if (dev->slave_ts)
+		ret = rtl2832_bulk_write(client, 0x022, buf, 4);
+	else
+		ret = rtl2832_bulk_write(client, 0x062, buf, 4);
 	if (ret)
 		goto err;
 
 	/* add PID */
 	buf[0] = (pid >> 8) & 0xff;
 	buf[1] = (pid >> 0) & 0xff;
-	ret = rtl2832_bulk_write(client, 0x066 + 2 * index, buf, 2);
+
+	if (dev->slave_ts)
+		ret = rtl2832_bulk_write(client, 0x026 + 2 * index, buf, 2);
+	else
+		ret = rtl2832_bulk_write(client, 0x066 + 2 * index, buf, 2);
 	if (ret)
 		goto err;
 
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index 6b875f4..561f8ab 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -45,6 +45,7 @@ struct rtl2832_dev {
 	bool sleeping;
 	struct delayed_work i2c_gate_work;
 	unsigned long filters; /* PID filter */
+	unsigned long slave_ts;
 };
 
 struct rtl2832_reg_entry {
-- 
2.5.0

