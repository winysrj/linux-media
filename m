Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36744 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbaGJLSQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jul 2014 07:18:16 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] m88ds3103: fix SNR reporting on 32-bit arch
Date: Thu, 10 Jul 2014 14:17:58 +0300
Message-Id: <1404991079-3027-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There was 32-bit calculation overflow. Use div_u64.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c      | 4 ++--
 drivers/media/dvb-frontends/m88ds3103_priv.h | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 2ef8ce1..4176edf 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -879,7 +879,7 @@ static int m88ds3103_read_snr(struct dvb_frontend *fe, u16 *snr)
 		/* SNR(X) dB = 10 * ln(X) / ln(10) dB */
 		tmp = DIV_ROUND_CLOSEST(tmp, 8 * M88DS3103_SNR_ITERATIONS);
 		if (tmp)
-			*snr = 100ul * intlog2(tmp) / intlog2(10);
+			*snr = div_u64((u64) 100 * intlog2(tmp), intlog2(10));
 		else
 			*snr = 0;
 		break;
@@ -908,7 +908,7 @@ static int m88ds3103_read_snr(struct dvb_frontend *fe, u16 *snr)
 		/* SNR(X) dB = 10 * log10(X) dB */
 		if (signal > noise) {
 			tmp = signal / noise;
-			*snr = 100ul * intlog10(tmp) / (1 << 24);
+			*snr = div_u64((u64) 100 * intlog10(tmp), (1 << 24));
 		} else {
 			*snr = 0;
 		}
diff --git a/drivers/media/dvb-frontends/m88ds3103_priv.h b/drivers/media/dvb-frontends/m88ds3103_priv.h
index 84c3c06..e73db5c 100644
--- a/drivers/media/dvb-frontends/m88ds3103_priv.h
+++ b/drivers/media/dvb-frontends/m88ds3103_priv.h
@@ -22,6 +22,7 @@
 #include "dvb_math.h"
 #include <linux/firmware.h>
 #include <linux/i2c-mux.h>
+#include <linux/math64.h>
 
 #define M88DS3103_FIRMWARE "dvb-demod-m88ds3103.fw"
 #define M88DS3103_MCLK_KHZ 96000
-- 
1.9.3

