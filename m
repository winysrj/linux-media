Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:52112 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab1HDHOV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 03:14:21 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 02/21] [media] tuner/xc2028: Fix frequency offset for radio mode.
Date: Thu,  4 Aug 2011 09:14:00 +0200
Message-Id: <1312442059-23935-3-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In radio mode, no frequency offset is needed. While at it, split off the
frequency offset computation for digital TV into a separate function.
---
 drivers/media/common/tuners/tuner-xc2028.c |  137 +++++++++++++++-------------
 1 files changed, 75 insertions(+), 62 deletions(-)

diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
index b6b2868..8e53e5e 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -913,6 +913,66 @@ ret:
 
 #define DIV 15625
 
+static u32 digital_freq_offset(struct xc2028_data *priv, u32 freq)
+{
+	u32 offset = 0;
+
+	/*
+	 * Adjust to the center frequency. This is calculated by the
+	 * formula: offset = 1.25MHz - BW/2
+	 * For DTV 7/8, the firmware uses BW = 8000, so it needs a
+	 * further adjustment to get the frequency center on VHF
+	 */
+	if (priv->cur_fw.type & DTV6)
+		offset = 1750000;
+	else if (priv->cur_fw.type & DTV7)
+		offset = 2250000;
+	else /* DTV8 or DTV78 */
+		offset = 2750000;
+
+	if ((priv->cur_fw.type & DTV78) && freq < 470000000)
+		offset -= 500000;
+
+	/*
+	 * xc3028 additional "magic"
+	 * Depending on the firmware version, it needs some adjustments
+	 * to properly centralize the frequency. This seems to be
+	 * needed to compensate the SCODE table adjustments made by
+	 * newer firmwares
+	 */
+
+#if 1
+	/*
+	 * The proper adjustment would be to do it at s-code table.
+	 * However, this didn't work, as reported by
+	 * Robert Lowery <rglowery@exemail.com.au>
+	 */
+
+	if (priv->cur_fw.type & DTV7)
+		offset += 500000;
+
+#else
+	/*
+	 * Still need tests for XC3028L (firmware 3.2 or upper)
+	 * So, for now, let's just comment the per-firmware
+	 * version of this change. Reports with xc3028l working
+	 * with and without the lines bellow are welcome
+	 */
+
+	if (priv->firm_version < 0x0302) {
+		if (priv->cur_fw.type & DTV7)
+			offset += 500000;
+	} else {
+		if (priv->cur_fw.type & DTV7)
+			offset -= 300000;
+		else if (type != ATSC) /* DVB @6MHz, DTV 8 and DTV 7/8 */
+			offset += 200000;
+	}
+#endif
+
+	return offset;
+}
+
 static int generic_set_freq(struct dvb_frontend *fe, u32 freq /* in HZ */,
 			    enum v4l2_tuner_type new_type,
 			    unsigned int type,
@@ -933,75 +993,28 @@ static int generic_set_freq(struct dvb_frontend *fe, u32 freq /* in HZ */,
 	if (check_firmware(fe, type, std, int_freq) < 0)
 		goto ret;
 
-	/* On some cases xc2028 can disable video output, if
-	 * very weak signals are received. By sending a soft
-	 * reset, this is re-enabled. So, it is better to always
-	 * send a soft reset before changing channels, to be sure
-	 * that xc2028 will be in a safe state.
-	 * Maybe this might also be needed for DTV.
-	 */
-	if (new_type == V4L2_TUNER_ANALOG_TV) {
+	switch (new_type) {
+	case V4L2_TUNER_ANALOG_TV:
+		/* On some cases xc2028 can disable video output, if
+		 * very weak signals are received. By sending a soft
+		 * reset, this is re-enabled. So, it is better to always
+		 * send a soft reset before changing channels, to be sure
+		 * that xc2028 will be in a safe state.
+		 * Maybe this might also be needed for DTV.
+		 */
 		rc = send_seq(priv, {0x00, 0x00});
-
+		/* fall through */
+	case V4L2_TUNER_RADIO:
 		/* Analog modes require offset = 0 */
-	} else {
+		break;
+	case V4L2_TUNER_DIGITAL_TV:
 		/*
 		 * Digital modes require an offset to adjust to the
 		 * proper frequency. The offset depends on what
 		 * firmware version is used.
 		 */
-
-		/*
-		 * Adjust to the center frequency. This is calculated by the
-		 * formula: offset = 1.25MHz - BW/2
-		 * For DTV 7/8, the firmware uses BW = 8000, so it needs a
-		 * further adjustment to get the frequency center on VHF
-		 */
-		if (priv->cur_fw.type & DTV6)
-			offset = 1750000;
-		else if (priv->cur_fw.type & DTV7)
-			offset = 2250000;
-		else	/* DTV8 or DTV78 */
-			offset = 2750000;
-		if ((priv->cur_fw.type & DTV78) && freq < 470000000)
-			offset -= 500000;
-
-		/*
-		 * xc3028 additional "magic"
-		 * Depending on the firmware version, it needs some adjustments
-		 * to properly centralize the frequency. This seems to be
-		 * needed to compensate the SCODE table adjustments made by
-		 * newer firmwares
-		 */
-
-#if 1
-		/*
-		 * The proper adjustment would be to do it at s-code table.
-		 * However, this didn't work, as reported by
-		 * Robert Lowery <rglowery@exemail.com.au>
-		 */
-
-		if (priv->cur_fw.type & DTV7)
-			offset += 500000;
-
-#else
-		/*
-		 * Still need tests for XC3028L (firmware 3.2 or upper)
-		 * So, for now, let's just comment the per-firmware
-		 * version of this change. Reports with xc3028l working
-		 * with and without the lines bellow are welcome
-		 */
-
-		if (priv->firm_version < 0x0302) {
-			if (priv->cur_fw.type & DTV7)
-				offset += 500000;
-		} else {
-			if (priv->cur_fw.type & DTV7)
-				offset -= 300000;
-			else if (type != ATSC) /* DVB @6MHz, DTV 8 and DTV 7/8 */
-				offset += 200000;
-		}
-#endif
+		offset = digital_freq_offset(priv, freq);
+		break;
 	}
 
 	div = (freq - offset + DIV / 2) / DIV;
-- 
1.7.6

