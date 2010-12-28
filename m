Return-path: <mchehab@gaivota>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:60934 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab0L1AFM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 19:05:12 -0500
Date: Tue, 28 Dec 2010 03:04:58 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Devin Heitmueller <dheitmueller@hauppauge.com>,
	Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
	Michael Krufky <mkrufky@kernellabs.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] cx231xx: use bitwise negate instead of logical
Message-ID: <20101228000458.GX1936@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Bitwise negate was intended here.  INPUT_SEL_MASK is 0x30.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-avcore.c b/drivers/media/video/cx231xx/cx231xx-avcore.c
index d52955c..c53e972 100644
--- a/drivers/media/video/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/video/cx231xx/cx231xx-avcore.c
@@ -274,7 +274,7 @@ int cx231xx_afe_set_input_mux(struct cx231xx *dev, u32 input_mux)
 
 	if (ch1_setting != 0) {
 		status = afe_read_byte(dev, ADC_INPUT_CH1, &value);
-		value &= (!INPUT_SEL_MASK);
+		value &= ~INPUT_SEL_MASK;
 		value |= (ch1_setting - 1) << 4;
 		value &= 0xff;
 		status = afe_write_byte(dev, ADC_INPUT_CH1, value);
@@ -282,7 +282,7 @@ int cx231xx_afe_set_input_mux(struct cx231xx *dev, u32 input_mux)
 
 	if (ch2_setting != 0) {
 		status = afe_read_byte(dev, ADC_INPUT_CH2, &value);
-		value &= (!INPUT_SEL_MASK);
+		value &= ~INPUT_SEL_MASK;
 		value |= (ch2_setting - 1) << 4;
 		value &= 0xff;
 		status = afe_write_byte(dev, ADC_INPUT_CH2, value);
@@ -292,7 +292,7 @@ int cx231xx_afe_set_input_mux(struct cx231xx *dev, u32 input_mux)
 	   7 less than the input number */
 	if (ch3_setting != 0) {
 		status = afe_read_byte(dev, ADC_INPUT_CH3, &value);
-		value &= (!INPUT_SEL_MASK);
+		value &= ~INPUT_SEL_MASK;
 		value |= (ch3_setting - 1) << 4;
 		value &= 0xff;
 		status = afe_write_byte(dev, ADC_INPUT_CH3, value);
