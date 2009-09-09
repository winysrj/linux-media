Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.221.181]:43185 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbZIIVeq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2009 17:34:46 -0400
Received: by qyk11 with SMTP id 11so4197813qyk.1
        for <linux-media@vger.kernel.org>; Wed, 09 Sep 2009 14:34:49 -0700 (PDT)
Date: Wed, 9 Sep 2009 17:29:38 -0400
From: James Blanford <jhblanford@gmail.com>
To: linux-media@vger.kernel.org,
	Erik =?ISO-8859-1?Q?Andr=E9n?= <erik.andren@gmail.com>
Subject: [Patch 1/2] stv06xx webcams with HDCS 1xxx sensors
Message-ID: <20090909172938.56cf7105@blackbart.localnet.prv>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quickcam Express 046d:0840 and maybe others

Driver version:  v 2.60 from 2.6.31-rc7

Initialize image size before it's used to initialize exposure.
Work around lack of exposure set hardware latch with a sequence of
register writes in a single I2C command packet.

Signed-off-by: James Blanford <jhblanford@gmail.com>
--- a/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c	2009-09-01 09:45:42.000000000 -0400
+++ b/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c	2009-09-09 14:59:35.000000000 -0400
@@ -252,7 +252,7 @@ static int hdcs_set_exposure(struct gspc
 	   within the column processing period */
 	int mnct;
 	int cycles, err;
-	u8 exp[4];
+	u8 exp[14];
 
 	cycles = val * HDCS_CLK_FREQ_MHZ;
 
@@ -288,24 +288,37 @@ static int hdcs_set_exposure(struct gspc
 		srowexp = max_srowexp;
 
 	if (IS_1020(sd)) {
-		exp[0] = rowexp & 0xff;
-		exp[1] = rowexp >> 8;
-		exp[2] = (srowexp >> 2) & 0xff;
-		/* this clears exposure error flag */
-		exp[3] = 0x1;
-		err = hdcs_reg_write_seq(sd, HDCS_ROWEXPL, exp, 4);
+		exp[0] = HDCS20_CONTROL;
+		exp[1] = 0x00;		/* Stop streaming */
+		exp[2] = HDCS_ROWEXPL;
+		exp[3] = rowexp & 0xff;
+		exp[4] = HDCS_ROWEXPH;
+		exp[5] = rowexp >> 8;
+		exp[6] = HDCS20_SROWEXP;
+		exp[7] = (srowexp >> 2) & 0xff;
+		exp[8] = HDCS20_ERROR;
+		exp[9] = 0x10;		/* Clear exposure error flag*/
+		exp[10] = HDCS20_CONTROL;
+		exp[11] = 0x04;		/* Restart streaming */
+		err = stv06xx_write_sensor_bytes(sd, exp, 6);
 	} else {
-		exp[0] = rowexp & 0xff;
-		exp[1] = rowexp >> 8;
-		exp[2] = srowexp & 0xff;
-		exp[3] = srowexp >> 8;
-		err = hdcs_reg_write_seq(sd, HDCS_ROWEXPL, exp, 4);
+		exp[0] = HDCS00_CONTROL;
+		exp[1] = 0x00;         /* Stop streaming */
+		exp[2] = HDCS_ROWEXPL;
+		exp[3] = rowexp & 0xff;
+		exp[4] = HDCS_ROWEXPH;
+		exp[5] = rowexp >> 8;
+		exp[6] = HDCS00_SROWEXPL;
+		exp[7] = srowexp & 0xff;
+		exp[8] = HDCS00_SROWEXPH;
+		exp[9] = srowexp >> 8;
+		exp[10] = HDCS_STATUS;
+		exp[11] = 0x10;         /* Clear exposure error flag*/
+		exp[12] = HDCS00_CONTROL;
+		exp[13] = 0x04;         /* Restart streaming */
+		err = stv06xx_write_sensor_bytes(sd, exp, 7);
 		if (err < 0)
 			return err;
-
-		/* clear exposure error flag */
-		err = stv06xx_write_sensor(sd,
-		     HDCS_STATUS, BIT(4));
 	}
 	PDEBUG(D_V4L2, "Writing exposure %d, rowexp %d, srowexp %d",
 	       val, rowexp, srowexp);
@@ -577,11 +590,11 @@ static int hdcs_init(struct sd *sd)
 	if (err < 0)
 		return err;
 
-	err = hdcs_set_exposure(&sd->gspca_dev, HDCS_DEFAULT_EXPOSURE);
+	err = hdcs_set_size(sd, hdcs->array.width, hdcs->array.height);
 	if (err < 0)
 		return err;
 
-	err = hdcs_set_size(sd, hdcs->array.width, hdcs->array.height);
+	err = hdcs_set_exposure(&sd->gspca_dev, HDCS_DEFAULT_EXPOSURE);
 	return err;
 }
 
