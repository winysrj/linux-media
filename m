Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:32810 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab2HGCrw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 22:47:52 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so3432645vcb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 19:47:51 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 06/24] xc5000: add support for showing the SNR and gain in the debug output
Date: Mon,  6 Aug 2012 22:46:56 -0400
Message-Id: <1344307634-11673-7-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When debugging is enabled, also show the analog SNR and the total gain
status values.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/common/tuners/xc5000.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index c41f2b9..f660e33 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -111,6 +111,7 @@ struct xc5000_priv {
 #define XREG_PRODUCT_ID   0x08
 #define XREG_BUSY         0x09
 #define XREG_BUILD        0x0D
+#define XREG_TOTALGAIN    0x0F
 
 /*
    Basic firmware description. This will remain with
@@ -539,6 +540,16 @@ static int xc_get_quality(struct xc5000_priv *priv, u16 *quality)
 	return xc5000_readreg(priv, XREG_QUALITY, quality);
 }
 
+static int xc_get_analogsnr(struct xc5000_priv *priv, u16 *snr)
+{
+	return xc5000_readreg(priv, XREG_SNR, snr);
+}
+
+static int xc_get_totalgain(struct xc5000_priv *priv, u16 *totalgain)
+{
+	return xc5000_readreg(priv, XREG_TOTALGAIN, totalgain);
+}
+
 static u16 WaitForLock(struct xc5000_priv *priv)
 {
 	u16 lockState = 0;
@@ -650,6 +661,8 @@ static void xc_debug_dump(struct xc5000_priv *priv)
 	u32 hsync_freq_hz = 0;
 	u16 frame_lines;
 	u16 quality;
+	u16 snr;
+	u16 totalgain;
 	u8 hw_majorversion = 0, hw_minorversion = 0;
 	u8 fw_majorversion = 0, fw_minorversion = 0;
 	u16 fw_buildversion = 0;
@@ -685,6 +698,13 @@ static void xc_debug_dump(struct xc5000_priv *priv)
 
 	xc_get_quality(priv,  &quality);
 	dprintk(1, "*** Quality (0:<8dB, 7:>56dB) = %d\n", quality & 0x07);
+
+	xc_get_analogsnr(priv,  &snr);
+	dprintk(1, "*** Unweighted analog SNR = %d dB\n", snr & 0x3f);
+
+	xc_get_totalgain(priv,  &totalgain);
+	dprintk(1, "*** Total gain = %d.%d dB\n", totalgain / 256,
+		(totalgain % 256) * 100 / 256);
 }
 
 static int xc5000_set_params(struct dvb_frontend *fe)
-- 
1.7.1

