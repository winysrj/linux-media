Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40297 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbbEEV7A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 17:59:00 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 15/21] tua9001: use div_u64() for frequency calculation
Date: Wed,  6 May 2015 00:58:36 +0300
Message-Id: <1430863122-9888-15-git-send-email-crope@iki.fi>
In-Reply-To: <1430863122-9888-1-git-send-email-crope@iki.fi>
References: <1430863122-9888-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use div_u64() to simplify and remove home made divides.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/tua9001.c      | 9 +--------
 drivers/media/tuners/tua9001_priv.h | 1 +
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/media/tuners/tua9001.c b/drivers/media/tuners/tua9001.c
index 09a1034..d4f6ca0 100644
--- a/drivers/media/tuners/tua9001.c
+++ b/drivers/media/tuners/tua9001.c
@@ -88,7 +88,6 @@ static int tua9001_set_params(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
 	u16 val;
-	u32 frequency;
 	struct tua9001_reg_val data[2];
 
 	dev_dbg(&client->dev,
@@ -122,14 +121,8 @@ static int tua9001_set_params(struct dvb_frontend *fe)
 
 	data[0].reg = 0x04;
 	data[0].val = val;
-
-	frequency = (c->frequency - 150000000);
-	frequency /= 100;
-	frequency *= 48;
-	frequency /= 10000;
-
 	data[1].reg = 0x1f;
-	data[1].val = frequency;
+	data[1].val = div_u64((u64) (c->frequency - 150000000) * 48, 1000000);
 
 	if (fe->callback) {
 		ret = fe->callback(client->adapter,
diff --git a/drivers/media/tuners/tua9001_priv.h b/drivers/media/tuners/tua9001_priv.h
index 327ead9..bc406c5 100644
--- a/drivers/media/tuners/tua9001_priv.h
+++ b/drivers/media/tuners/tua9001_priv.h
@@ -18,6 +18,7 @@
 #define TUA9001_PRIV_H
 
 #include "tua9001.h"
+#include <linux/math64.h>
 #include <linux/regmap.h>
 
 struct tua9001_reg_val {
-- 
http://palosaari.fi/

