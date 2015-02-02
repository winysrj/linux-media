Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60958 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013AbbBBRjf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 12:39:35 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/3] rtl2830: add kernel-doc comments for platform_data
Date: Mon,  2 Feb 2015 19:39:17 +0200
Message-Id: <1422898759-25513-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add kernel-doc comments for platform_data configuration structure.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2830.h | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2830.h b/drivers/media/dvb-frontends/rtl2830.h
index 156edf7..0cde151 100644
--- a/drivers/media/dvb-frontends/rtl2830.h
+++ b/drivers/media/dvb-frontends/rtl2830.h
@@ -20,33 +20,26 @@
 
 #include <linux/dvb/frontend.h>
 
+/**
+ * struct rtl2830_platform_data - Platform data for the rtl2830 driver
+ * @clk: Clock frequency (4000000, 16000000, 25000000, 28800000).
+ * @spec_inv: Spectrum inversion.
+ * @vtop: AGC take-over point.
+ * @krf: AGC ratio.
+ * @agc_targ_val: AGC.
+ * @get_dvb_frontend: Get DVB frontend.
+ * @get_i2c_adapter: Get I2C adapter.
+ * @pid_filter: Set PID to PID filter.
+ * @pid_filter_ctrl: Control PID filter.
+ */
+
 struct rtl2830_platform_data {
-	/*
-	 * Clock frequency.
-	 * Hz
-	 * 4000000, 16000000, 25000000, 28800000
-	 */
 	u32 clk;
-
-	/*
-	 * Spectrum inversion.
-	 */
 	bool spec_inv;
-
-	/*
-	 */
 	u8 vtop;
-
-	/*
-	 */
 	u8 krf;
-
-	/*
-	 */
 	u8 agc_targ_val;
 
-	/*
-	 */
 	struct dvb_frontend* (*get_dvb_frontend)(struct i2c_client *);
 	struct i2c_adapter* (*get_i2c_adapter)(struct i2c_client *);
 	int (*pid_filter)(struct dvb_frontend *, u8, u16, int);
-- 
http://palosaari.fi/

