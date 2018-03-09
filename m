Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:63071 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751122AbeCIPxm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 10:53:42 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 01/11] media: lgdt330x: use kernel-doc instead of inlined comments
Date: Fri,  9 Mar 2018 12:53:26 -0300
Message-Id: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change the lgdt330x_config documentation to use kernel-doc
style.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/lgdt330x.h | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb-frontends/lgdt330x.h b/drivers/media/dvb-frontends/lgdt330x.h
index 61434cbecd2c..18bd54eabca4 100644
--- a/drivers/media/dvb-frontends/lgdt330x.h
+++ b/drivers/media/dvb-frontends/lgdt330x.h
@@ -26,25 +26,26 @@ typedef enum lg_chip_t {
 		LGDT3303
 }lg_chip_type;
 
+/**
+ * struct lgdt330x_config - contains lgdt330x configuration
+ *
+ * @demod_address:	The demodulator's i2c address
+ * @demod_chip:		LG demodulator chip LGDT3302 or LGDT3303
+ * @serial_mpeg:	MPEG hardware interface - 0:parallel 1:serial
+ * @pll_rf_set:		Callback function to set PLL interface
+ * @set_ts_params:	Callback function to set device param for start_dma
+ * @clock_polarity_flip:
+ *	Flip the polarity of the mpeg data transfer clock using alternate
+ *	init data.
+ *	This option applies ONLY to LGDT3303 - 0:disabled (default) 1:enabled
+ */
 struct lgdt330x_config
 {
-	/* The demodulator's i2c address */
 	u8 demod_address;
-
-	/* LG demodulator chip LGDT3302 or LGDT3303 */
 	lg_chip_type demod_chip;
-
-	/* MPEG hardware interface - 0:parallel 1:serial */
 	int serial_mpeg;
-
-	/* PLL interface */
 	int (*pll_rf_set) (struct dvb_frontend* fe, int index);
-
-	/* Need to set device param for start_dma */
 	int (*set_ts_params)(struct dvb_frontend* fe, int is_punctured);
-
-	/* Flip the polarity of the mpeg data transfer clock using alternate init data
-	 * This option applies ONLY to LGDT3303 - 0:disabled (default) 1:enabled */
 	int clock_polarity_flip;
 };
 
-- 
2.14.3
