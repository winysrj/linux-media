Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:58702 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932556AbbCPWMo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 18:12:44 -0400
Message-ID: <55075559.50100@southpole.se>
Date: Mon, 16 Mar 2015 23:12:41 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [RFC][PATCH] rtl2832: PID filter support for slave demod
Content-Type: multipart/mixed;
 boundary="------------070200050504000002010800"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070200050504000002010800
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Is this structure ok for the slave pid implementation? Or should there 
be only one filters parameter? Will the overlaying pid filter framework 
properly "flush" the set pid filters ?

Note that this code currently is only compile tested.

MvH
Benjamin Larsson

--------------070200050504000002010800
Content-Type: text/x-patch;
 name="0001-rtl2832-PID-filter-support-for-slave-demod.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-rtl2832-PID-filter-support-for-slave-demod.patch"

>From 8efb26c18b4f9416bd516195c6a82853c9cccc24 Mon Sep 17 00:00:00 2001
From: Benjamin Larsson <benjamin@southpole.se>
Date: Mon, 16 Mar 2015 22:59:50 +0100
Subject: [PATCH] rtl2832: PID filter support for slave demod
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>

RTL2832p supports a slave configuration with a demodulator connected
to a ts input on the chip. This makes it possible to receive DVB-T2
muxes that are of larger size then what the rtl2832p usb-bridge is
capable of transfering.

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/media/dvb-frontends/rtl2832.c      | 40 ++++++++++++++++++++++--------
 drivers/media/dvb-frontends/rtl2832_priv.h |  2 ++
 2 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 5d2d8f4..3725211 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -488,6 +488,8 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
+	dev->slave_demod_active = 0;
+
 	/* If the frontend has get_if_frequency(), use it */
 	if (fe->ops.tuner_ops.get_if_frequency) {
 		u32 if_freq;
@@ -1114,6 +1116,8 @@ static int rtl2832_enable_slave_ts(struct i2c_client *client)
 	if (ret)
 		goto err;
 
+	dev->slave_demod_active = 1;
+
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
@@ -1135,7 +1139,10 @@ static int rtl2832_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
 	else
 		u8tmp = 0x00;
 
-	ret = rtl2832_update_bits(client, 0x061, 0xc0, u8tmp);
+	if (dev->slave_demod_active)
+		ret = rtl2832_update_bits(client, 0x021, 0xc0, u8tmp);
+	else
+		ret = rtl2832_update_bits(client, 0x061, 0xc0, u8tmp);
 	if (ret)
 		goto err;
 
@@ -1152,6 +1159,7 @@ static int rtl2832_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid,
 	struct i2c_client *client = dev->client;
 	int ret;
 	u8 buf[4];
+	unsigned long* filters;
 
 	dev_dbg(&client->dev, "index=%d pid=%04x onoff=%d\n",
 		index, pid, onoff);
@@ -1160,24 +1168,36 @@ static int rtl2832_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid,
 	if (pid > 0x1fff || index > 32)
 		return 0;
 
-	if (onoff)
-		set_bit(index, &dev->filters);
+	if (dev->slave_demod_active)
+		filters = &dev->filters_slave;
 	else
-		clear_bit(index, &dev->filters);
+		filters = &dev->filters;
+
+	if (onoff) {
+		set_bit(index, filters);
+	} else {
+		clear_bit(index, filters);
+	}
 
 	/* enable / disable PIDs */
-	buf[0] = (dev->filters >>  0) & 0xff;
-	buf[1] = (dev->filters >>  8) & 0xff;
-	buf[2] = (dev->filters >> 16) & 0xff;
-	buf[3] = (dev->filters >> 24) & 0xff;
-	ret = rtl2832_bulk_write(client, 0x062, buf, 4);
+	buf[0] = (*filters >>  0) & 0xff;
+	buf[1] = (*filters >>  8) & 0xff;
+	buf[2] = (*filters >> 16) & 0xff;
+	buf[3] = (*filters >> 24) & 0xff;
+	if (dev->slave_demod_active)
+		ret = rtl2832_bulk_write(client, 0x022, buf, 4);
+	else
+		ret = rtl2832_bulk_write(client, 0x062, buf, 4);
 	if (ret)
 		goto err;
 
 	/* add PID */
 	buf[0] = (pid >> 8) & 0xff;
 	buf[1] = (pid >> 0) & 0xff;
-	ret = rtl2832_bulk_write(client, 0x066 + 2 * index, buf, 2);
+	if (dev->slave_demod_active)
+		ret = rtl2832_bulk_write(client, 0x026 + 2 * index, buf, 2);
+	else
+		ret = rtl2832_bulk_write(client, 0x066 + 2 * index, buf, 2);
 	if (ret)
 		goto err;
 
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index c3a922c..b95a7b7 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -46,6 +46,8 @@ struct rtl2832_dev {
 	bool sleeping;
 	struct delayed_work i2c_gate_work;
 	unsigned long filters; /* PID filter */
+	unsigned long filters_slave; /* PID filter */
+	int slave_demod_active;
 };
 
 struct rtl2832_reg_entry {
-- 
2.1.0


--------------070200050504000002010800--
