Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35963 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbaEUSUP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 May 2014 14:20:15 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Changbing Xiong <cb.xiong@samsung.com>,
	Trevor G <trevor.forums@gmail.com>,
	"Reynaldo H. Verdejo Pinochet" <r.verdejo@sisa.samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 5/8] xc5000: Don't wrap msleep()
Date: Wed, 21 May 2014 15:19:59 -0300
Message-Id: <1400696402-1805-6-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1400696402-1805-1-git-send-email-m.chehab@samsung.com>
References: <1400696402-1805-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's absolutely no reason to wrap msleep() call here.
Just rename all occurences of xc_wait() with msleep() and
remove the wrapper function.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/tuners/xc5000.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index 94278cc5f3ef..a5dff9714836 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -293,11 +293,6 @@ static int xc5000_readreg(struct xc5000_priv *priv, u16 reg, u16 *val)
 	return 0;
 }
 
-static void xc_wait(int wait_ms)
-{
-	msleep(wait_ms);
-}
-
 static int xc5000_TunerReset(struct dvb_frontend *fe)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
@@ -342,7 +337,7 @@ static int xc_write_reg(struct xc5000_priv *priv, u16 regAddr, u16 i2cData)
 					/* busy flag cleared */
 					break;
 				} else {
-					xc_wait(5); /* wait 5 ms */
+					msleep(5); /* wait 5 ms */
 					WatchDogTimer--;
 				}
 			}
@@ -374,7 +369,7 @@ static int xc_load_i2c_sequence(struct dvb_frontend *fe, const u8 *i2c_sequence)
 				return result;
 		} else if (len & 0x8000) {
 			/* WAIT command */
-			xc_wait(len & 0x7FFF);
+			msleep(len & 0x7FFF);
 			index += 2;
 		} else {
 			/* Send i2c data whilst ensuring individual transactions
@@ -571,7 +566,7 @@ static u16 WaitForLock(struct xc5000_priv *priv)
 	while ((lockState == 0) && (watchDogCount > 0)) {
 		xc_get_lock_status(priv, &lockState);
 		if (lockState != 1) {
-			xc_wait(5);
+			msleep(5);
 			watchDogCount--;
 		}
 	}
@@ -687,7 +682,7 @@ static void xc_debug_dump(struct xc5000_priv *priv)
 	 * Frame Lines needs two frame times after initial lock
 	 * before it is valid.
 	 */
-	xc_wait(100);
+	msleep(100);
 
 	xc_get_ADC_Envelope(priv,  &adc_envelope);
 	dprintk(1, "*** ADC envelope (0-1023) = %d\n", adc_envelope);
@@ -1137,7 +1132,7 @@ fw_retry:
 		 * I2C transactions until calibration is complete.  This way we
 		 * don't have to rely on clock stretching working.
 		 */
-		xc_wait(100);
+		msleep(100);
 
 		if (priv->init_status_supported) {
 			if (xc5000_readreg(priv, XREG_INIT_STATUS, &fw_ck) != 0) {
-- 
1.9.0

