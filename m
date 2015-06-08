Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:53550 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbbFHNkt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 09:40:49 -0400
Received: from t19.piap.pl (OSB1819.piap.pl [10.0.9.19])
	by ni.piap.pl (Postfix) with ESMTP id 5FC134411A7
	for <linux-media@vger.kernel.org>; Mon,  8 Jun 2015 15:35:05 +0200 (CEST)
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH] SOLO6x10: Fix G.723 minimum audio period count.
References: <m3a8waxr86.fsf@t19.piap.pl>
Date: Mon, 08 Jun 2015 15:35:05 +0200
In-Reply-To: <m3a8waxr86.fsf@t19.piap.pl> ("Krzysztof \=\?utf-8\?Q\?Ha\=C5\=82as\?\=
 \=\?utf-8\?Q\?a\=22's\?\= message of
	"Mon, 08 Jun 2015 15:30:17 +0200")
Message-ID: <m33822xr06.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The period count is fixed, don't confuse ALSA.

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

--- a/drivers/media/pci/solo6x10/solo6x10-g723.c
+++ b/drivers/media/pci/solo6x10/solo6x10-g723.c
@@ -48,10 +48,8 @@
 /* The solo writes to 1k byte pages, 32 pages, in the dma. Each 1k page
  * is broken down to 20 * 48 byte regions (one for each channel possible)
  * with the rest of the page being dummy data. */
-#define G723_MAX_BUFFER		(G723_PERIOD_BYTES * PERIODS_MAX)
+#define PERIODS			G723_FDMA_PAGES
 #define G723_INTR_ORDER		4 /* 0 - 4 */
-#define PERIODS_MIN		(1 << G723_INTR_ORDER)
-#define PERIODS_MAX		G723_FDMA_PAGES
 
 struct solo_snd_pcm {
 	int				on;
@@ -130,11 +128,11 @@ static const struct snd_pcm_hardware snd_solo_pcm_hw = {
 	.rate_max		= SAMPLERATE,
 	.channels_min		= 1,
 	.channels_max		= 1,
-	.buffer_bytes_max	= G723_MAX_BUFFER,
+	.buffer_bytes_max	= G723_PERIOD_BYTES * PERIODS,
 	.period_bytes_min	= G723_PERIOD_BYTES,
 	.period_bytes_max	= G723_PERIOD_BYTES,
-	.periods_min		= PERIODS_MIN,
-	.periods_max		= PERIODS_MAX,
+	.periods_min		= PERIODS,
+	.periods_max		= PERIODS,
 };
 
 static int snd_solo_pcm_open(struct snd_pcm_substream *ss)
@@ -340,7 +338,8 @@ static int solo_snd_pcm_init(struct solo_dev *solo_dev)
 	ret = snd_pcm_lib_preallocate_pages_for_all(pcm,
 					SNDRV_DMA_TYPE_CONTINUOUS,
 					snd_dma_continuous_data(GFP_KERNEL),
-					G723_MAX_BUFFER, G723_MAX_BUFFER);
+					G723_PERIOD_BYTES * PERIODS,
+					G723_PERIOD_BYTES * PERIODS);
 	if (ret < 0)
 		return ret;
 
