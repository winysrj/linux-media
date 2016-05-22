Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36840 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbcEVQDg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 May 2016 12:03:36 -0400
Received: by mail-wm0-f68.google.com with SMTP id q62so8819197wmg.3
        for <linux-media@vger.kernel.org>; Sun, 22 May 2016 09:03:36 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org
Cc: benjamin@southpole.se,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v2] [media] rtl2832: add support for slave ts pid filter
Date: Sun, 22 May 2016 18:03:07 +0200
Message-Id: <1463932987-10526-1-git-send-email-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The rtl2832 demod has 2 sets of PID filters. This patch enables
the filter support when using a slave demod.

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
This patch was originally written by Benjamin Larsson, all I did was
rebasing the patch and to extend the dev_dbg statements with the
slave_ts information.
This also supersedes the following patch:
https://patchwork.linuxtv.org/patch/34358/

 drivers/media/dvb-frontends/rtl2832.c      | 26 ++++++++++++++++++++------
 drivers/media/dvb-frontends/rtl2832_priv.h |  1 +
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 7c96f76..ba67fb4 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -409,6 +409,7 @@ static int rtl2832_init(struct dvb_frontend *fe)
 	c->post_bit_count.len = 1;
 	c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	dev->sleeping = false;
+	dev->slave_ts = false;
 
 	return 0;
 err:
@@ -1103,6 +1104,8 @@ static int rtl2832_slave_ts_ctrl(struct i2c_client *client, bool enable)
 			goto err;
 	}
 
+	dev->slave_ts = enable;
+
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
@@ -1116,7 +1119,7 @@ static int rtl2832_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
 	int ret;
 	u8 u8tmp;
 
-	dev_dbg(&client->dev, "onoff=%d\n", onoff);
+	dev_dbg(&client->dev, "onoff=%d, slave_ts=%d\n", onoff, dev->slave_ts);
 
 	/* enable / disable PID filter */
 	if (onoff)
@@ -1124,7 +1127,10 @@ static int rtl2832_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
 	else
 		u8tmp = 0x00;
 
-	ret = rtl2832_update_bits(client, 0x061, 0xc0, u8tmp);
+	if (dev->slave_ts)
+		ret = rtl2832_update_bits(client, 0x021, 0xc0, u8tmp);
+	else
+		ret = rtl2832_update_bits(client, 0x061, 0xc0, u8tmp);
 	if (ret)
 		goto err;
 
@@ -1142,8 +1148,8 @@ static int rtl2832_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid,
 	int ret;
 	u8 buf[4];
 
-	dev_dbg(&client->dev, "index=%d pid=%04x onoff=%d\n",
-		index, pid, onoff);
+	dev_dbg(&client->dev, "index=%d pid=%04x onoff=%d slave_ts=%d\n",
+		index, pid, onoff, dev->slave_ts);
 
 	/* skip invalid PIDs (0x2000) */
 	if (pid > 0x1fff || index > 32)
@@ -1159,14 +1165,22 @@ static int rtl2832_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid,
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
index 6b875f4..8eb2e0b 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -45,6 +45,7 @@ struct rtl2832_dev {
 	bool sleeping;
 	struct delayed_work i2c_gate_work;
 	unsigned long filters; /* PID filter */
+	bool slave_ts;
 };
 
 struct rtl2832_reg_entry {
-- 
2.8.2

