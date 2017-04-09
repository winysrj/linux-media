Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35880 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752440AbdDITil (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Apr 2017 15:38:41 -0400
Received: by mail-wm0-f68.google.com with SMTP id q125so6399675wmd.3
        for <linux-media@vger.kernel.org>; Sun, 09 Apr 2017 12:38:40 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: aospan@netup.ru, serjk@netup.ru, mchehab@kernel.org,
        linux-media@vger.kernel.org
Cc: rjkm@metzlerbros.de
Subject: [PATCH 09/19] [media] dvb-frontends/cxd2841er: TS_SERIAL config flag
Date: Sun,  9 Apr 2017 21:38:18 +0200
Message-Id: <20170409193828.18458-10-d.scheller.oss@gmail.com>
In-Reply-To: <20170409193828.18458-1-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Some constellations work/need a serial TS transport mode. This adds a flag
that will toggle set up of such mode.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/cxd2841er.c | 18 ++++++++++++++++--
 drivers/media/dvb-frontends/cxd2841er.h |  5 +++--
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index fa6a963..1df95c4 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -912,6 +912,18 @@ static void cxd2841er_set_ts_clock_mode(struct cxd2841er_priv *priv,
 
 	/*
 	 * slave    Bank    Addr    Bit    default    Name
+	 * <SLV-T>  00h     C4h     [1:0]  2'b??      OSERCKMODE
+	 */
+	cxd2841er_set_reg_bits(priv, I2C_SLVT, 0xc4,
+		((priv->flags & CXD2841ER_TS_SERIAL) ? 0x01 : 0x00), 0x03);
+	/*
+	 * slave    Bank    Addr    Bit    default    Name
+	 * <SLV-T>  00h     D1h     [1:0]  2'b??      OSERDUTYMODE
+	 */
+	cxd2841er_set_reg_bits(priv, I2C_SLVT, 0xd1,
+		((priv->flags & CXD2841ER_TS_SERIAL) ? 0x01 : 0x00), 0x03);
+	/*
+	 * slave    Bank    Addr    Bit    default    Name
 	 * <SLV-T>  00h     D9h     [7:0]  8'h08      OTSCKPERIOD
 	 */
 	cxd2841er_write_reg(priv, I2C_SLVT, 0xd9, 0x08);
@@ -925,7 +937,8 @@ static void cxd2841er_set_ts_clock_mode(struct cxd2841er_priv *priv,
 	 * slave    Bank    Addr    Bit    default    Name
 	 * <SLV-T>  00h     33h     [1:0]  2'b01      OREG_CKSEL_TSIF
 	 */
-	cxd2841er_set_reg_bits(priv, I2C_SLVT, 0x33, 0x00, 0x03);
+	cxd2841er_set_reg_bits(priv, I2C_SLVT, 0x33,
+		((priv->flags & CXD2841ER_TS_SERIAL) ? 0x01 : 0x00), 0x03);
 	/*
 	 * Enable TS IF Clock
 	 * slave    Bank    Addr    Bit    default    Name
@@ -3745,7 +3758,8 @@ static int cxd2841er_init_tc(struct dvb_frontend *fe)
 	cxd2841er_write_reg(priv, I2C_SLVT, 0xcd, 0x50);
 	/* SONY_DEMOD_CONFIG_PARALLEL_SEL = 1 */
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0x00);
-	cxd2841er_set_reg_bits(priv, I2C_SLVT, 0xc4, 0x00, 0x80);
+	cxd2841er_set_reg_bits(priv, I2C_SLVT, 0xc4,
+		((priv->flags & CXD2841ER_TS_SERIAL) ? 0x80 : 0x00), 0x80);
 
 	cxd2841er_init_stats(fe);
 
diff --git a/drivers/media/dvb-frontends/cxd2841er.h b/drivers/media/dvb-frontends/cxd2841er.h
index 38d7f9f..58fbd98 100644
--- a/drivers/media/dvb-frontends/cxd2841er.h
+++ b/drivers/media/dvb-frontends/cxd2841er.h
@@ -24,8 +24,9 @@
 
 #include <linux/dvb/frontend.h>
 
-#define CXD2841ER_USE_GATECTRL	1
-#define CXD2841ER_AUTO_IFHZ	2
+#define CXD2841ER_USE_GATECTRL	1	/* bit 0 */
+#define CXD2841ER_AUTO_IFHZ	2	/* bit 1 */
+#define CXD2841ER_TS_SERIAL	4	/* bit 2 */
 
 enum cxd2841er_xtal {
 	SONY_XTAL_20500, /* 20.5 MHz */
-- 
2.10.2
