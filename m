Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43515 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587AbaAYRLJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 12:11:09 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 49/52] msi3101: improve ADC config stream format selection
Date: Sat, 25 Jan 2014 19:10:43 +0200
Message-Id: <1390669846-8131-50-git-send-email-crope@iki.fi>
In-Reply-To: <1390669846-8131-1-git-send-email-crope@iki.fi>
References: <1390669846-8131-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Improve ADC config stream format selection. No functional changes.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 37 +++++++++++++----------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 6b9f0da..ba37fce 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -1247,38 +1247,35 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 	f_sr = s->f_adc;
 
 	/* select stream format */
-	if (f_sr < 6000000) {
-		s->convert_stream = msi3101_convert_stream_252;
-		reg7 = 0x00009407;
-	} else if (f_sr < 8000000) {
-		s->convert_stream = msi3101_convert_stream_336;
-		reg7 = 0x00008507;
-	} else if (f_sr < 9000000) {
-		s->convert_stream = msi3101_convert_stream_384;
-		reg7 = 0x0000a507;
-	} else {
-		s->convert_stream = msi3101_convert_stream_504;
-		reg7 = 0x000c9407;
-	}
-
-	if (s->pixelformat == V4L2_PIX_FMT_SDR_U8) {
+	switch (s->pixelformat) {
+	case V4L2_PIX_FMT_SDR_U8:
 		s->convert_stream = msi3101_convert_stream_504_u8;
 		reg7 = 0x000c9407;
-	} else if (s->pixelformat == V4L2_PIX_FMT_SDR_U16LE) {
+		break;
+	case V4L2_PIX_FMT_SDR_U16LE:
 		s->convert_stream = msi3101_convert_stream_252_u16;
 		reg7 = 0x00009407;
-	} else if (s->pixelformat == V4L2_PIX_FMT_SDR_S8) {
+		break;
+	case V4L2_PIX_FMT_SDR_S8:
 		s->convert_stream = msi3101_convert_stream_504;
 		reg7 = 0x000c9407;
-	} else if (s->pixelformat == V4L2_PIX_FMT_SDR_MSI2500_384) {
+		break;
+	case V4L2_PIX_FMT_SDR_MSI2500_384:
 		s->convert_stream = msi3101_convert_stream_384;
 		reg7 = 0x0000a507;
-	} else if (s->pixelformat == V4L2_PIX_FMT_SDR_S12) {
+		break;
+	case V4L2_PIX_FMT_SDR_S12:
 		s->convert_stream = msi3101_convert_stream_336;
 		reg7 = 0x00008507;
-	} else if (s->pixelformat == V4L2_PIX_FMT_SDR_S14) {
+		break;
+	case V4L2_PIX_FMT_SDR_S14:
 		s->convert_stream = msi3101_convert_stream_252;
 		reg7 = 0x00009407;
+		break;
+	default:
+		s->convert_stream = msi3101_convert_stream_504_u8;
+		reg7 = 0x000c9407;
+		break;
 	}
 
 	/*
-- 
1.8.5.3

