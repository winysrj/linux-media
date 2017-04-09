Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34784 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752322AbdDITiq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Apr 2017 15:38:46 -0400
Received: by mail-wm0-f67.google.com with SMTP id x75so6393781wma.1
        for <linux-media@vger.kernel.org>; Sun, 09 Apr 2017 12:38:46 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: aospan@netup.ru, serjk@netup.ru, mchehab@kernel.org,
        linux-media@vger.kernel.org
Cc: rjkm@metzlerbros.de
Subject: [PATCH 15/19] [media] dvb-frontends/cxd2841er: improved snr reporting
Date: Sun,  9 Apr 2017 21:38:24 +0200
Message-Id: <20170409193828.18458-16-d.scheller.oss@gmail.com>
In-Reply-To: <20170409193828.18458-1-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

On DVB-T/T2 at least, SNR might be reported as >2500dB, which not only is
just wrong but also ridiculous, so fix this by improving the conversion
of the register value.

The INTLOG10X100 function/macro and the way the values are converted were
both taken from DD's cxd2843 driver.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/cxd2841er.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index efb2795..a01ac58 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -38,6 +38,8 @@
 #define MAX_WRITE_REGSIZE	16
 #define LOG2_E_100X 144
 
+#define INTLOG10X100(x) ((u32) (((u64) intlog10(x) * 100) >> 24))
+
 /* DVB-C constellation */
 enum sony_dvbc_constellation_t {
 	SONY_DVBC_CONSTELLATION_16QAM,
@@ -1817,7 +1819,7 @@ static int cxd2841er_read_snr_t(struct cxd2841er_priv *priv, u32 *snr)
 	}
 	if (reg > 4996)
 		reg = 4996;
-	*snr = 10000 * ((intlog10(reg) - intlog10(5350 - reg)) >> 24) + 28500;
+	*snr = 100 * ((INTLOG10X100(reg) - INTLOG10X100(5350 - reg)) + 285);
 	return 0;
 }
 
@@ -1846,8 +1848,7 @@ static int cxd2841er_read_snr_t2(struct cxd2841er_priv *priv, u32 *snr)
 	}
 	if (reg > 10876)
 		reg = 10876;
-	*snr = 10000 * ((intlog10(reg) -
-		intlog10(12600 - reg)) >> 24) + 32000;
+	*snr = 100 * ((INTLOG10X100(reg) - INTLOG10X100(12600 - reg)) + 320);
 	return 0;
 }
 
-- 
2.10.2
