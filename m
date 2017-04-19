Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:35020 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940326AbdDSXOp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 19:14:45 -0400
Received: by mail-qk0-f169.google.com with SMTP id f133so33324063qke.2
        for <linux-media@vger.kernel.org>; Wed, 19 Apr 2017 16:14:40 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 09/12] xc5000: Don't spin waiting for analog lock
Date: Wed, 19 Apr 2017 19:13:52 -0400
Message-Id: <1492643635-30823-10-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1492643635-30823-1-git-send-email-dheitmueller@kernellabs.com>
References: <1492643635-30823-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The xc5000 driver should not be spinning waiting for an analog lock.
The ioctl() should be returning immediately and the application is
responsible for polling for lock status.

This behavior isn't very visible in cases where you tune to a valid
channel, since lock is usually achieved much faster than 400ms.
However it is highly visible where doing things like changing video
standards, which sends tuning request for a frequency that is
almost never going to have an actual channel on it.

Also fixup the return values to treat zero as success and an actual
error code on error (to be consistent with other functions).  Note
this change has no practical effect at this time as none of the
callers inspect the return value.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/tuners/xc5000.c | 26 ++------------------------
 1 file changed, 2 insertions(+), 24 deletions(-)

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index e823aaf..e144627 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -565,38 +565,16 @@ static int xc_get_totalgain(struct xc5000_priv *priv, u16 *totalgain)
 	return xc5000_readreg(priv, XREG_TOTALGAIN, totalgain);
 }
 
-static u16 wait_for_lock(struct xc5000_priv *priv)
-{
-	u16 lock_state = 0;
-	int watch_dog_count = 40;
-
-	while ((lock_state == 0) && (watch_dog_count > 0)) {
-		xc_get_lock_status(priv, &lock_state);
-		if (lock_state != 1) {
-			msleep(5);
-			watch_dog_count--;
-		}
-	}
-	return lock_state;
-}
-
 #define XC_TUNE_ANALOG  0
 #define XC_TUNE_DIGITAL 1
 static int xc_tune_channel(struct xc5000_priv *priv, u32 freq_hz, int mode)
 {
-	int found = 0;
-
 	dprintk(1, "%s(%u)\n", __func__, freq_hz);
 
 	if (xc_set_rf_frequency(priv, freq_hz) != 0)
-		return 0;
-
-	if (mode == XC_TUNE_ANALOG) {
-		if (wait_for_lock(priv) == 1)
-			found = 1;
-	}
+		return -EREMOTEIO;
 
-	return found;
+	return 0;
 }
 
 static int xc_set_xtal(struct dvb_frontend *fe)
-- 
1.9.1
