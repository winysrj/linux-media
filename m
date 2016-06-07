Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35501 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1160995AbcFGVdn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2016 17:33:43 -0400
Received: by mail-wm0-f66.google.com with SMTP id k184so20938911wme.2
        for <linux-media@vger.kernel.org>; Tue, 07 Jun 2016 14:33:43 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org
Cc: benjamin@southpole.se, crope@iki.fi,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3] [media] rtl2832: add support for slave ts pid filter
Date: Tue,  7 Jun 2016 23:31:47 +0200
Message-Id: <20160607213147.18373-1-martin.blumenstingl@googlemail.com>
In-Reply-To: <1463932987-10526-1-git-send-email-martin.blumenstingl@googlemail.com>
References: <1463932987-10526-1-git-send-email-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The rtl2832 demod has 2 sets of PID filters. This patch enables
the filter support when using a slave demod.

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
changes since v2:
- rebased to make the patch apply again
- removed explicit initialization of dev->slave_ts as
  rtl2832_slave_ts_ctrl is always called when activating the frontend

This patch was originally written by Benjamin Larsson, all I did was
rebasing the patch and to extend the dev_dbg statements with the
slave_ts information.
This also supersedes the following patch:
https://patchwork.linuxtv.org/patch/34358/

 drivers/media/dvb-frontends/rtl2832.c      | 25 +++++++++++++++++++------
 drivers/media/dvb-frontends/rtl2832_priv.h |  1 +
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index bfb6bee..c16c69e 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -947,6 +947,8 @@ static int rtl2832_slave_ts_ctrl(struct i2c_client *client, bool enable)
 			goto err;
 	}
 
+	dev->slave_ts = enable;
+
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
@@ -960,7 +962,7 @@ static int rtl2832_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
 	int ret;
 	u8 u8tmp;
 
-	dev_dbg(&client->dev, "onoff=%d\n", onoff);
+	dev_dbg(&client->dev, "onoff=%d, slave_ts=%d\n", onoff, dev->slave_ts);
 
 	/* enable / disable PID filter */
 	if (onoff)
@@ -968,7 +970,10 @@ static int rtl2832_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
 	else
 		u8tmp = 0x00;
 
-	ret = regmap_update_bits(dev->regmap, 0x061, 0xc0, u8tmp);
+	if (dev->slave_ts)
+		ret = regmap_update_bits(dev->regmap, 0x021, 0xc0, u8tmp);
+	else
+		ret = regmap_update_bits(dev->regmap, 0x061, 0xc0, u8tmp);
 	if (ret)
 		goto err;
 
@@ -986,8 +991,8 @@ static int rtl2832_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid,
 	int ret;
 	u8 buf[4];
 
-	dev_dbg(&client->dev, "index=%d pid=%04x onoff=%d\n",
-		index, pid, onoff);
+	dev_dbg(&client->dev, "index=%d pid=%04x onoff=%d slave_ts=%d\n",
+		index, pid, onoff, dev->slave_ts);
 
 	/* skip invalid PIDs (0x2000) */
 	if (pid > 0x1fff || index > 32)
@@ -1003,14 +1008,22 @@ static int rtl2832_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid,
 	buf[1] = (dev->filters >>  8) & 0xff;
 	buf[2] = (dev->filters >> 16) & 0xff;
 	buf[3] = (dev->filters >> 24) & 0xff;
-	ret = regmap_bulk_write(dev->regmap, 0x062, buf, 4);
+
+	if (dev->slave_ts)
+		ret = regmap_bulk_write(dev->regmap, 0x022, buf, 4);
+	else
+		ret = regmap_bulk_write(dev->regmap, 0x062, buf, 4);
 	if (ret)
 		goto err;
 
 	/* add PID */
 	buf[0] = (pid >> 8) & 0xff;
 	buf[1] = (pid >> 0) & 0xff;
-	ret = regmap_bulk_write(dev->regmap, 0x066 + 2 * index, buf, 2);
+
+	if (dev->slave_ts)
+		ret = regmap_bulk_write(dev->regmap, 0x026 + 2 * index, buf, 2);
+	else
+		ret = regmap_bulk_write(dev->regmap, 0x066 + 2 * index, buf, 2);
 	if (ret)
 		goto err;
 
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index c1a8a69..9a6d01a 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -44,6 +44,7 @@ struct rtl2832_dev {
 	bool sleeping;
 	struct delayed_work i2c_gate_work;
 	unsigned long filters; /* PID filter */
+	bool slave_ts;
 };
 
 struct rtl2832_reg_entry {
-- 
2.8.3

