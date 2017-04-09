Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35461 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752596AbdDITip (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Apr 2017 15:38:45 -0400
Received: by mail-wm0-f66.google.com with SMTP id d79so6410853wmi.2
        for <linux-media@vger.kernel.org>; Sun, 09 Apr 2017 12:38:44 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: aospan@netup.ru, serjk@netup.ru, mchehab@kernel.org,
        linux-media@vger.kernel.org
Cc: rjkm@metzlerbros.de
Subject: [PATCH 14/19] [media] dvb-frontends/cxd2841er: more configurable TSBITS
Date: Sun,  9 Apr 2017 21:38:23 +0200
Message-Id: <20170409193828.18458-15-d.scheller.oss@gmail.com>
In-Reply-To: <20170409193828.18458-1-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Bits 3 and 4 of the TSCONFIG register are important for certain hardware
constellations, in that they need to be zeroed. Add a configuration flag
to toggle this.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/cxd2841er.c | 4 ++++
 drivers/media/dvb-frontends/cxd2841er.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 67bd13c..efb2795 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -3794,6 +3794,10 @@ static int cxd2841er_init_tc(struct dvb_frontend *fe)
 	cxd2841er_set_reg_bits(priv, I2C_SLVT, 0xc4,
 		((priv->flags & CXD2841ER_TS_SERIAL) ? 0x80 : 0x00), 0x80);
 
+	/* clear TSCFG bits 3+4 */
+	if (priv->flags & CXD2841ER_TSBITS)
+		cxd2841er_set_reg_bits(priv, I2C_SLVT, 0xc4, 0x00, 0x18);
+
 	cxd2841er_init_stats(fe);
 
 	return 0;
diff --git a/drivers/media/dvb-frontends/cxd2841er.h b/drivers/media/dvb-frontends/cxd2841er.h
index 4f94422..dc32f5fb 100644
--- a/drivers/media/dvb-frontends/cxd2841er.h
+++ b/drivers/media/dvb-frontends/cxd2841er.h
@@ -31,6 +31,7 @@
 #define CXD2841ER_EARLY_TUNE	16	/* bit 4 */
 #define CXD2841ER_NO_WAIT_LOCK	32	/* bit 5 */
 #define CXD2841ER_NO_AGCNEG	64	/* bit 6 */
+#define CXD2841ER_TSBITS	128	/* bit 7 */
 
 enum cxd2841er_xtal {
 	SONY_XTAL_20500, /* 20.5 MHz */
-- 
2.10.2
