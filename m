Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:40492 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbbK2CKS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2015 21:10:18 -0500
Received: from benjamin-desktop.lan (c-ce09e555.03-170-73746f36.cust.bredbandsbolaget.se [85.229.9.206])
	(Authenticated sender: ed8153)
	by smtp.bredband2.com (Postfix) with ESMTPA id 7D19D727C2
	for <linux-media@vger.kernel.org>; Sun, 29 Nov 2015 03:10:16 +0100 (CET)
From: Benjamin Larsson <benjamin@southpole.se>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/3] rtl2832: add support for slave ts pid filter
Date: Sun, 29 Nov 2015 03:10:14 +0100
Message-Id: <1448763016-10527-1-git-send-email-benjamin@southpole.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/media/dvb-frontends/rtl2832.c      | 21 ++++++++++++++++++---
 drivers/media/dvb-frontends/rtl2832_priv.h |  1 +
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 78b87b2..e054079 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -407,6 +407,7 @@ static int rtl2832_init(struct dvb_frontend *fe)
 	/* start statistics polling */
 	schedule_delayed_work(&dev->stat_work, msecs_to_jiffies(2000));
 	dev->sleeping = false;
+	dev->slave_ts = false;
 
 	return 0;
 err:
@@ -1122,6 +1123,8 @@ static int rtl2832_enable_slave_ts(struct i2c_client *client)
 	if (ret)
 		goto err;
 
+	dev->slave_ts = true;
+
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
@@ -1143,7 +1146,11 @@ static int rtl2832_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
 	else
 		u8tmp = 0x00;
 
-	ret = rtl2832_update_bits(client, 0x061, 0xc0, u8tmp);
+	if (dev->slave_ts)
+		ret = rtl2832_update_bits(client, 0x021, 0xc0, u8tmp);
+	else
+		ret = rtl2832_update_bits(client, 0x061, 0xc0, u8tmp);
 	if (ret)
 		goto err;
 
@@ -1178,14 +1185,22 @@ static int rtl2832_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid,
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
index 5dcd3a4..efc230f 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -46,6 +46,7 @@ struct rtl2832_dev {
 	bool sleeping;
 	struct delayed_work i2c_gate_work;
 	unsigned long filters; /* PID filter */
+	bool slave_ts;
 };
 
 struct rtl2832_reg_entry {
-- 
2.1.4

