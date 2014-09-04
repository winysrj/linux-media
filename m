Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40863 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757070AbaIDChC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:02 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 19/37] it913x: get rid of script loader and and private header file
Date: Thu,  4 Sep 2014 05:36:27 +0300
Message-Id: <1409798205-25645-19-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Used script loader is quite useless and hides register numbers
making code hard to understand. Get rid of it and use standard
RegMap register write functions directly.

it913x_priv.h file leaves empty after that change and is also
removed.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/it913x.c      | 63 +++++++++++++++++++-------------------
 drivers/media/tuners/it913x_priv.h | 47 ----------------------------
 2 files changed, 31 insertions(+), 79 deletions(-)
 delete mode 100644 drivers/media/tuners/it913x_priv.h

diff --git a/drivers/media/tuners/it913x.c b/drivers/media/tuners/it913x.c
index ab386bf..924f18d 100644
--- a/drivers/media/tuners/it913x.c
+++ b/drivers/media/tuners/it913x.c
@@ -20,7 +20,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.=
  */
 
-#include "it913x_priv.h"
+#include "it913x.h"
+#include <linux/regmap.h>
 
 struct it913x_dev {
 	struct i2c_client *client;
@@ -34,25 +35,6 @@ struct it913x_dev {
 	u32 tun_fn_min;
 };
 
-static int it913x_script_loader(struct it913x_dev *dev,
-		struct it913xset *loadscript)
-{
-	int ret, i;
-
-	if (loadscript == NULL)
-		return -EINVAL;
-
-	for (i = 0; i < 1000; ++i) {
-		if (loadscript[i].address == 0x000000)
-			break;
-		ret = regmap_bulk_write(dev->regmap, loadscript[i].address,
-			loadscript[i].reg, loadscript[i].count);
-		if (ret < 0)
-			return -ENODEV;
-	}
-	return 0;
-}
-
 static int it913x_init(struct dvb_frontend *fe)
 {
 	struct it913x_dev *dev = fe->tuner_priv;
@@ -181,7 +163,6 @@ err:
 static int it9137_set_params(struct dvb_frontend *fe)
 {
 	struct it913x_dev *dev = fe->tuner_priv;
-	struct it913xset *set_tuner = set_it9135_template;
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	u32 bandwidth = p->bandwidth_hz;
 	u32 frequency_m = p->frequency;
@@ -231,7 +212,10 @@ static int it9137_set_params(struct dvb_frontend *fe)
 		lna_band = 1;
 	} else
 		return -EINVAL;
-	set_tuner[0].reg[0] = lna_band;
+
+	ret = regmap_write(dev->regmap, 0x80ee06, lna_band);
+	if (ret)
+		goto err;
 
 	switch (bandwidth) {
 	case 5000000:
@@ -249,8 +233,13 @@ static int it9137_set_params(struct dvb_frontend *fe)
 		break;
 	}
 
-	set_tuner[1].reg[0] = bw;
-	set_tuner[2].reg[0] = 0xa0 | (l_band << 3);
+	ret = regmap_write(dev->regmap, 0x80ec56, bw);
+	if (ret)
+		goto err;
+
+	ret = regmap_write(dev->regmap, 0x80ec4c, 0xa0 | (l_band << 3));
+	if (ret)
+		goto err;
 
 	if (frequency > 53000 && frequency <= 74000) {
 		n_div = 48;
@@ -309,20 +298,30 @@ static int it9137_set_params(struct dvb_frontend *fe)
 	/* Frequency OMEGA_IQIK_M_CAL_MID*/
 	temp_f = freq + (u32)iqik_m_cal;
 
-	set_tuner[3].reg[0] =  temp_f & 0xff;
-	set_tuner[4].reg[0] =  (temp_f >> 8) & 0xff;
+	ret = regmap_write(dev->regmap, 0x80ec4d, temp_f & 0xff);
+	if (ret)
+		goto err;
+
+	ret = regmap_write(dev->regmap, 0x80ec4e, (temp_f >> 8) & 0xff);
+	if (ret)
+		goto err;
 
 	dev_dbg(&dev->client->dev, "High Frequency = %04x\n", temp_f);
 
 	/* Lower frequency */
-	set_tuner[5].reg[0] =  freq & 0xff;
-	set_tuner[6].reg[0] =  (freq >> 8) & 0xff;
-
-	dev_dbg(&dev->client->dev, "low Frequency = %04x\n", freq);
+	ret = regmap_write(dev->regmap, 0x80011e, freq & 0xff);
+	if (ret)
+		goto err;
 
-	ret = it913x_script_loader(dev, set_tuner);
+	ret = regmap_write(dev->regmap, 0x80011f, (freq >> 8) & 0xff);
+	if (ret)
+		goto err;
 
-	return (ret < 0) ? -ENODEV : 0;
+	dev_dbg(&dev->client->dev, "low Frequency = %04x\n", freq);
+	return 0;
+err:
+	dev_dbg(&dev->client->dev, "failed %d\n", ret);
+	return ret;
 }
 
 static const struct dvb_tuner_ops it913x_tuner_ops = {
diff --git a/drivers/media/tuners/it913x_priv.h b/drivers/media/tuners/it913x_priv.h
deleted file mode 100644
index a6ddd02..0000000
--- a/drivers/media/tuners/it913x_priv.h
+++ /dev/null
@@ -1,47 +0,0 @@
-/*
- * ITE Tech IT9137 silicon tuner driver
- *
- *  Copyright (C) 2011 Malcolm Priestley (tvboxspy@gmail.com)
- *  IT9137 Copyright (C) ITE Tech Inc.
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.=
- */
-
-#ifndef IT913X_PRIV_H
-#define IT913X_PRIV_H
-
-#include "it913x.h"
-#include <linux/regmap.h>
-
-#define TRIGGER_OFSM		0x0000
-
-struct it913xset {	u32 address;
-			u8 reg[15];
-			u8 count;
-};
-
-static struct it913xset set_it9135_template[] = {
-	{0x80ee06, {0x00}, 0x01},
-	{0x80ec56, {0x00}, 0x01},
-	{0x80ec4c, {0x00}, 0x01},
-	{0x80ec4d, {0x00}, 0x01},
-	{0x80ec4e, {0x00}, 0x01},
-	{0x80011e, {0x00}, 0x01}, /* Older Devices */
-	{0x80011f, {0x00}, 0x01},
-	{0x000000, {0x00}, 0x00}, /* Terminating Entry */
-};
-
-#endif
-- 
http://palosaari.fi/

