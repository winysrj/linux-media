Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55019 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbaBIIt4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 03:49:56 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 10/86] rtl2832: remove unused if_dvbt config parameter
Date: Sun,  9 Feb 2014 10:48:15 +0200
Message-Id: <1391935771-18670-11-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All used tuners has get_if_frequency() callback and that parameter
is not needed and will not needed as all upcoming tuner drivers
should implement get_if_frequency().

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c   | 6 ------
 drivers/media/dvb-frontends/rtl2832.h   | 7 -------
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 --
 3 files changed, 15 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index ff73da9..61d4ecb 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -514,12 +514,6 @@ static int rtl2832_init(struct dvb_frontend *fe)
 			goto err;
 	}
 
-	if (!fe->ops.tuner_ops.get_if_frequency) {
-		ret = rtl2832_set_if(fe, priv->cfg.if_dvbt);
-		if (ret)
-			goto err;
-	}
-
 	/*
 	 * r820t NIM code does a software reset here at the demod -
 	 * may not be needed, as there's already a software reset at set_params()
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index 2cfbb6a..e543081 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -38,13 +38,6 @@ struct rtl2832_config {
 	u32 xtal;
 
 	/*
-	 * IFs for all used modes.
-	 * Hz
-	 * 4570000, 4571429, 36000000, 36125000, 36166667, 44000000
-	 */
-	u32 if_dvbt;
-
-	/*
 	 * tuner
 	 * XXX: This must be keep sync with dvb_usb_rtl28xxu demod driver.
 	 */
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index c0e651a..6a5eb0f 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -587,14 +587,12 @@ err:
 static const struct rtl2832_config rtl28xxu_rtl2832_fc0012_config = {
 	.i2c_addr = 0x10, /* 0x20 */
 	.xtal = 28800000,
-	.if_dvbt = 0,
 	.tuner = TUNER_RTL2832_FC0012
 };
 
 static const struct rtl2832_config rtl28xxu_rtl2832_fc0013_config = {
 	.i2c_addr = 0x10, /* 0x20 */
 	.xtal = 28800000,
-	.if_dvbt = 0,
 	.tuner = TUNER_RTL2832_FC0013
 };
 
-- 
1.8.5.3

