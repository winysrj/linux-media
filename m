Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58070 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757069AbaIDChC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:02 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 18/37] it913x: remove dead code
Date: Thu,  4 Sep 2014 05:36:26 +0300
Message-Id: <1409798205-25645-18-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unused tuner set template.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/it913x.c      |  9 +--------
 drivers/media/tuners/it913x_priv.h | 11 -----------
 2 files changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/media/tuners/it913x.c b/drivers/media/tuners/it913x.c
index 11d391a..ab386bf 100644
--- a/drivers/media/tuners/it913x.c
+++ b/drivers/media/tuners/it913x.c
@@ -28,7 +28,6 @@ struct it913x_dev {
 	struct dvb_frontend *fe;
 	u8 chip_ver:2;
 	u8 role:2;
-	u8 firmware_ver;
 	u16 tun_xtal;
 	u8 tun_fdiv;
 	u8 tun_clk_mode;
@@ -182,7 +181,7 @@ err:
 static int it9137_set_params(struct dvb_frontend *fe)
 {
 	struct it913x_dev *dev = fe->tuner_priv;
-	struct it913xset *set_tuner = set_it9137_template;
+	struct it913xset *set_tuner = set_it9135_template;
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	u32 bandwidth = p->bandwidth_hz;
 	u32 frequency_m = p->frequency;
@@ -197,11 +196,6 @@ static int it9137_set_params(struct dvb_frontend *fe)
 	u8 lna_band;
 	u8 bw;
 
-	if (dev->firmware_ver == 1)
-		set_tuner = set_it9135_template;
-	else
-		set_tuner = set_it9137_template;
-
 	dev_dbg(&dev->client->dev, "Tuner Frequency %d Bandwidth %d\n",
 			frequency, bandwidth);
 
@@ -367,7 +361,6 @@ static int it913x_probe(struct i2c_client *client,
 	dev->fe = cfg->fe;
 	dev->chip_ver = cfg->chip_ver;
 	dev->role = cfg->role;
-	dev->firmware_ver = 1;
 	dev->regmap = regmap_init_i2c(client, &regmap_config);
 	if (IS_ERR(dev->regmap)) {
 		ret = PTR_ERR(dev->regmap);
diff --git a/drivers/media/tuners/it913x_priv.h b/drivers/media/tuners/it913x_priv.h
index 41f9b2a..a6ddd02 100644
--- a/drivers/media/tuners/it913x_priv.h
+++ b/drivers/media/tuners/it913x_priv.h
@@ -44,15 +44,4 @@ static struct it913xset set_it9135_template[] = {
 	{0x000000, {0x00}, 0x00}, /* Terminating Entry */
 };
 
-static struct it913xset set_it9137_template[] = {
-	{0x80ee06, {0x00}, 0x01},
-	{0x80ec56, {0x00}, 0x01},
-	{0x80ec4c, {0x00}, 0x01},
-	{0x80ec4d, {0x00}, 0x01},
-	{0x80ec4e, {0x00}, 0x01},
-	{0x80ec4f, {0x00}, 0x01},
-	{0x80ec50, {0x00}, 0x01},
-	{0x000000, {0x00}, 0x00}, /* Terminating Entry */
-};
-
 #endif
-- 
http://palosaari.fi/

