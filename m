Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43911 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282AbbBBRjf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 12:39:35 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/3] rtl2832: add kernel-doc comments for platform_data
Date: Mon,  2 Feb 2015 19:39:18 +0200
Message-Id: <1422898759-25513-2-git-send-email-crope@iki.fi>
In-Reply-To: <1422898759-25513-1-git-send-email-crope@iki.fi>
References: <1422898759-25513-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add kernel-doc comments for platform_data configuration structure.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.h | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index e5f67cf..a8e912e 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -25,16 +25,20 @@
 #include <linux/dvb/frontend.h>
 #include <linux/i2c-mux.h>
 
+/**
+ * struct rtl2832_platform_data - Platform data for the rtl2832 driver
+ * @clk: Clock frequency (4000000, 16000000, 25000000, 28800000).
+ * @tuner: Used tuner model.
+ * @get_dvb_frontend: Get DVB frontend.
+ * @get_i2c_adapter: Get I2C adapter.
+ * @enable_slave_ts: Enable slave TS IF.
+ * @pid_filter: Set PID to PID filter.
+ * @pid_filter_ctrl: Control PID filter.
+ */
+
 struct rtl2832_platform_data {
-	/*
-	 * Clock frequency.
-	 * Hz
-	 * 4000000, 16000000, 25000000, 28800000
-	 */
 	u32 clk;
-
 	/*
-	 * Tuner.
 	 * XXX: This list must be kept sync with dvb_usb_rtl28xxu USB IF driver.
 	 */
 #define RTL2832_TUNER_TUA9001   0x24
@@ -45,15 +49,12 @@ struct rtl2832_platform_data {
 #define RTL2832_TUNER_R828D     0x2b
 	u8 tuner;
 
-	/*
-	 * Callbacks.
-	 */
 	struct dvb_frontend* (*get_dvb_frontend)(struct i2c_client *);
 	struct i2c_adapter* (*get_i2c_adapter)(struct i2c_client *);
 	int (*enable_slave_ts)(struct i2c_client *);
 	int (*pid_filter)(struct dvb_frontend *, u8, u16, int);
 	int (*pid_filter_ctrl)(struct dvb_frontend *, int);
-	/* Register access for SDR module */
+/* private: Register access for SDR module use only */
 	int (*bulk_read)(struct i2c_client *, unsigned int, void *, size_t);
 	int (*bulk_write)(struct i2c_client *, unsigned int, const void *, size_t);
 	int (*update_bits)(struct i2c_client *, unsigned int, unsigned int, unsigned int);
-- 
http://palosaari.fi/

