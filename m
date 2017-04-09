Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33424 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752440AbdDITit (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Apr 2017 15:38:49 -0400
Received: by mail-wm0-f65.google.com with SMTP id o81so6391284wmb.0
        for <linux-media@vger.kernel.org>; Sun, 09 Apr 2017 12:38:44 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: aospan@netup.ru, serjk@netup.ru, mchehab@kernel.org,
        linux-media@vger.kernel.org
Cc: rjkm@metzlerbros.de
Subject: [PATCH 13/19] [media] dvb-frontends/cxd2841er: configurable IFAGCNEG
Date: Sun,  9 Apr 2017 21:38:22 +0200
Message-Id: <20170409193828.18458-14-d.scheller.oss@gmail.com>
In-Reply-To: <20170409193828.18458-1-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Adds a flag to enable or disable the IFAGCNEG bit in cxd2841er_init_tc().

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/cxd2841er.c | 5 +++--
 drivers/media/dvb-frontends/cxd2841er.h | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 67d4399..67bd13c 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -3783,9 +3783,10 @@ static int cxd2841er_init_tc(struct dvb_frontend *fe)
 	dev_dbg(&priv->i2c->dev, "%s() bandwidth_hz=%d\n",
 			__func__, p->bandwidth_hz);
 	cxd2841er_shutdown_to_sleep_tc(priv);
-	/* SONY_DEMOD_CONFIG_IFAGCNEG = 1 */
+	/* SONY_DEMOD_CONFIG_IFAGCNEG = 1 (0 for NO_AGCNEG */
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0x10);
-	cxd2841er_set_reg_bits(priv, I2C_SLVT, 0xcb, 0x40, 0x40);
+	cxd2841er_set_reg_bits(priv, I2C_SLVT, 0xcb,
+		((priv->flags & CXD2841ER_NO_AGCNEG) ? 0x00 : 0x40), 0x40);
 	/* SONY_DEMOD_CONFIG_IFAGC_ADC_FS = 0 */
 	cxd2841er_write_reg(priv, I2C_SLVT, 0xcd, 0x50);
 	/* SONY_DEMOD_CONFIG_PARALLEL_SEL = 1 */
diff --git a/drivers/media/dvb-frontends/cxd2841er.h b/drivers/media/dvb-frontends/cxd2841er.h
index d77b59f..4f94422 100644
--- a/drivers/media/dvb-frontends/cxd2841er.h
+++ b/drivers/media/dvb-frontends/cxd2841er.h
@@ -30,6 +30,7 @@
 #define CXD2841ER_ASCOT		8	/* bit 3 */
 #define CXD2841ER_EARLY_TUNE	16	/* bit 4 */
 #define CXD2841ER_NO_WAIT_LOCK	32	/* bit 5 */
+#define CXD2841ER_NO_AGCNEG	64	/* bit 6 */
 
 enum cxd2841er_xtal {
 	SONY_XTAL_20500, /* 20.5 MHz */
-- 
2.10.2
