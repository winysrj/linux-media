Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47646 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267AbbBBRjf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 12:39:35 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/3] rtl2832_sdr: add kernel-doc comments for platform_data
Date: Mon,  2 Feb 2015 19:39:19 +0200
Message-Id: <1422898759-25513-3-git-send-email-crope@iki.fi>
In-Reply-To: <1422898759-25513-1-git-send-email-crope@iki.fi>
References: <1422898759-25513-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add kernel-doc comments for platform_data configuration structure.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832_sdr.h | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.h b/drivers/media/dvb-frontends/rtl2832_sdr.h
index dd22e42..d259476 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.h
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.h
@@ -29,16 +29,22 @@
 #include <media/v4l2-subdev.h>
 #include "dvb_frontend.h"
 
+/**
+ * struct rtl2832_sdr_platform_data - Platform data for the rtl2832_sdr driver
+ * @clk: Clock frequency (4000000, 16000000, 25000000, 28800000).
+ * @tuner: Used tuner model.
+ * @i2c_client: rtl2832 demod driver I2C client.
+ * @bulk_read: rtl2832 driver private I/O interface.
+ * @bulk_write: rtl2832 driver private I/O interface.
+ * @update_bits: rtl2832 driver private I/O interface.
+ * @dvb_frontend: rtl2832 DVB frontend.
+ * @v4l2_subdev: Tuner v4l2 controls.
+ * @dvb_usb_device: DVB USB interface for USB streaming.
+ */
+
 struct rtl2832_sdr_platform_data {
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
 #define RTL2832_SDR_TUNER_TUA9001   0x24
-- 
http://palosaari.fi/

